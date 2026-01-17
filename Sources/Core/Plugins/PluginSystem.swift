//
// PluginSystem.swift
// SilentKey
//
// Modular plugin system for extending functionality
// Allows easy addition of new features without modifying core code
//

import Foundation

// MARK: - Plugin Manager

public class PluginManager {
    public static let shared = PluginManager()
    
    private var plugins: [String: any SecretPlugin] = [:]
    private let pluginQueue = DispatchQueue(label: "com.silentkey.pluginmanager")
    
    private init() {}
    
    /// Register a new plugin
    public func register(_ plugin: any SecretPlugin) {
        pluginQueue.async(flags: .barrier) { [weak self] in
            self?.plugins[plugin.id] = plugin
        }
    }
    
    /// Unregister a plugin
    public func unregister(pluginId: String) {
        pluginQueue.async(flags: .barrier) { [weak self] in
            self?.plugins.removeValue(forKey: pluginId)
        }
    }
    
    /// Get all registered plugins
    public func allPlugins() -> [any SecretPlugin] {
        pluginQueue.sync {
            Array(plugins.values)
        }
    }
    
    /// Get plugins that support a specific category
    public func plugins(for category: SecretCategory) -> [any SecretPlugin] {
        pluginQueue.sync {
            plugins.values.filter { $0.supportedCategories.contains(category) }
        }
    }
    
    /// Execute a plugin action
    public func execute(
        pluginId: String,
        action: PluginAction,
        on secret: any SecretItemProtocol
    ) async throws -> PluginResult {
        guard let plugin = plugins[pluginId] else {
            throw PluginError.pluginNotFound
        }
        
        return try await plugin.performAction(action, on: secret)
    }
}

// MARK: - Plugin Errors

public enum PluginError: Error {
    case pluginNotFound
    case actionNotSupported
    case executionFailed(String)
    case invalidConfiguration
}

// MARK: - Example Plugins

/// Validation plugin for banking secrets
public struct BankingValidationPlugin: SecretPlugin {
    public let id = "com.silentkey.banking.validation"
    public let name = "Banking Validation"
    public let version = "1.0.0"
    
    public var supportedCategories: [SecretCategory] {
        [.bankAccount, .creditCard]
    }
    
    public func performAction(
        _ action: PluginAction,
        on secret: any SecretItemProtocol
    ) async throws -> PluginResult {
        switch action {
        case .validate:
            return try await validateBankingSecret(secret)
        default:
            throw PluginError.actionNotSupported
        }
    }
    
    private func validateBankingSecret(_ secret: any SecretItemProtocol) async throws -> PluginResult {
        // Custom banking validation logic
        var issues: [String] = []
        
        if secret.title.isEmpty {
            issues.append("Title is required")
        }
        
        if secret.category == .bankAccount {
            // Additional bank account validation
            if secret.title.count < 3 {
                issues.append("Account name too short")
            }
        }
        
        return PluginResult(
            success: issues.isEmpty,
            message: issues.isEmpty ? "Validation passed" : "Validation failed",
            data: ["issues": issues]
        )
    }
}

/// Export plugin for multiple formats
public struct ExportPlugin: SecretPlugin {
    public let id = "com.silentkey.export"
    public let name = "Multi-Format Export"
    public let version = "1.0.0"
    
    public var supportedCategories: [SecretCategory] {
        SecretCategory.allCases
    }
    
    public func performAction(
        _ action: PluginAction,
        on secret: any SecretItemProtocol
    ) async throws -> PluginResult {
        switch action {
        case .transform:
            return try await exportSecret(secret)
        default:
            throw PluginError.actionNotSupported
        }
    }
    
    private func exportSecret(_ secret: any SecretItemProtocol) async throws -> PluginResult {
        if let exportable = secret as? any ExportableSecret {
            let data = try exportable.export(format: .json)
            
            return PluginResult(
                success: true,
                message: "Export successful",
                data: ["exportData": data]
            )
        }
        
        throw PluginError.executionFailed("Secret does not support export")
    }
}

/// Backup plugin for automatic backups
public struct BackupPlugin: SecretPlugin {
    public let id = "com.silentkey.backup"
    public let name = "Automatic Backup"
    public let version = "1.0.0"
    
    public var supportedCategories: [SecretCategory] {
        SecretCategory.allCases
    }
    
    public func performAction(
        _ action: PluginAction,
        on secret: any SecretItemProtocol
    ) async throws -> PluginResult {
        switch action {
        case .backup:
            return try await createBackup(secret)
        default:
            throw PluginError.actionNotSupported
        }
    }
    
    private func createBackup(_ secret: any SecretItemProtocol) async throws -> PluginResult {
        // Create encrypted backup
        let backupData = try secret.encryptedData()
        let timestamp = Date()
        
        return PluginResult(
            success: true,
            message: "Backup created successfully",
            data: [
                "backupData": backupData,
                "timestamp": timestamp,
                "secretId": secret.id.uuidString
            ]
        )
    }
}

// MARK: - Template Manager

public class TemplateManager {
    public static let shared = TemplateManager()
    
    private var templates: [String: any SecretTemplate.Type] = [:]
    
    private init() {
        // Register built-in templates
        registerBuiltInTemplates()
    }
    
    private func registerBuiltInTemplates() {
        register(BankAccountSecret.self)
        register(APIKeySecret.self)
    }
    
    /// Register a new template
    public func register<T: SecretTemplate>(_ template: T.Type) {
        templates[template.templateName] = template
    }
    
    /// Get all available templates
    public func availableTemplates() -> [any SecretTemplate.Type] {
        Array(templates.values)
    }
    
    /// Get template by name
    public func template(named name: String) -> (any SecretTemplate.Type)? {
        templates[name]
    }
    
    /// Create instance from template
    public func createSecret<T: SecretTemplate>(
        from template: T.Type,
        with fields: [String: Any]
    ) throws -> T {
        try template.create(from: fields)
    }
}
