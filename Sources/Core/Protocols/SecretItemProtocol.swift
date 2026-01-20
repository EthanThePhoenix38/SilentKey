//
// SecretItemProtocol.swift
// SilentKey
//
// Modular protocol-based architecture for extensible secret types
// Supports API keys, banking credentials, SSH keys, and custom types
//

import Foundation

// MARK: - Core Protocol for all Secret Types

/// Base protocol that all secret items must conform to
/// Enables modular architecture for easy feature additions
public protocol SecretItemProtocol: Identifiable, Codable, Hashable {
    /// Unique identifier for the secret
    var id: UUID { get }
    
    /// Human-readable name/title for the secret
    var title: String { get set }
    
    /// Optional description or notes
    var notes: String? { get set }
    
    /// Category/type identifier for grouping
    var category: SecretCategory { get }
    
    /// Tags for organization and filtering
    var tags: Set<String> { get set }
    
    /// Creation timestamp
    var createdAt: Date { get }
    
    /// Last modification timestamp
    var modifiedAt: Date { get set }
    
    /// Favorite/starred status
    var isFavorite: Bool { get set }
    
    /// Icon name for UI display
    var iconName: String { get }
    
    /// Returns the encrypted data representation
    func encryptedData() throws -> Data
    
    /// Validates the secret data
    func validate() throws
    
    /// Returns searchable text for filtering
    func searchableText() -> String
}

// MARK: - Secret Categories

public enum SecretCategory: String, Codable, CaseIterable {
    case apiKey = "API Key"
    case bankAccount = "Bank Account"
    case creditCard = "Credit Card"
    case sshKey = "SSH Key"
    case password = "Password"
    case token = "Token"
    case certificate = "Certificate"
    case license = "License"
    case note = "Secure Note"
    case project = "Project"
    case custom = "Custom"
    
    var icon: String {
        switch self {
        case .apiKey: return "key.fill"
        case .bankAccount: return "building.columns.fill"
        case .creditCard: return "creditcard.fill"
        case .sshKey: return "terminal.fill"
        case .password: return "lock.fill"
        case .token: return "ticket.fill"
        case .certificate: return "doc.badge.gearshape.fill"
        case .license: return "doc.text.fill"
        case .note: return "note.text"
        case .project: return "folder.fill"
        case .custom: return "puzzlepiece.extension.fill"
        }
    }
}

// MARK: - Encryptable Protocol

/// Protocol for items that support encryption
public protocol EncryptableSecret: SecretItemProtocol {
    /// Fields that should be encrypted
    var encryptedFields: [String: Data] { get set }
    
    /// Encrypt specific fields
    mutating func encrypt(field: String, value: String, using key: Data) throws
    
    /// Decrypt specific fields
    func decrypt(field: String, using key: Data) throws -> String
}

// MARK: - Exportable Protocol

/// Protocol for secrets that can be exported
public protocol ExportableSecret: SecretItemProtocol {
    /// Export format options
    func export(format: ExportFormat) throws -> Data
    
    /// Available export formats for this secret type
    var supportedExportFormats: [ExportFormat] { get }
}

public enum ExportFormat: String, CaseIterable {
    case json = "JSON"
    case csv = "CSV"
    case encrypted = "Encrypted Vault"
    case plainText = "Plain Text"
}

// MARK: - Validatable Protocol

/// Protocol for secrets with validation rules
public protocol ValidatableSecret: SecretItemProtocol {
    /// Validation errors specific to this secret type
    associatedtype ValidationError: Error
    
    /// Perform validation
    func performValidation() throws -> Void
}

// MARK: - Template Protocol

/// Protocol for creating new secret types easily
public protocol SecretTemplate {
    /// Template name
    static var templateName: String { get }
    
    /// Template description
    static var templateDescription: String { get }
    
    /// Required fields for this template
    static var requiredFields: [FieldDefinition] { get }
    
    /// Optional fields for this template
    static var optionalFields: [FieldDefinition] { get }
    
    /// Create instance from field values
    static func create(from fields: [String: Any]) throws -> Self
}

public struct FieldDefinition: Codable {
    let name: String
    let displayName: String
    let type: FieldType
    let isSecure: Bool
    let placeholder: String?
    let validationPattern: String?
    
    public enum FieldType: String, Codable {
        case text
        case number
        case email
        case url
        case date
        case password
        case multiline
        case dropdown
    }
}

// MARK: - Plugin Protocol

/// Protocol for creating feature plugins
public protocol SecretPlugin {
    /// Plugin identifier
    var id: String { get }
    
    /// Plugin name
    var name: String { get }
    
    /// Plugin version
    var version: String { get }
    
    /// Supported secret categories
    var supportedCategories: [SecretCategory] { get }
    
    /// Plugin actions
    func performAction(_ action: PluginAction, on secret: any SecretItemProtocol) async throws -> PluginResult
}

public enum PluginAction {
    case validate
    case transform
    case sync
    case backup
    case custom(String)
}

public struct PluginResult {
    public let success: Bool
    public let message: String?
    public let data: [String: Any]?
    
    public init(success: Bool, message: String?, data: [String: Any]? = nil) {
        self.success = success
        self.message = message
        self.data = data
    }
}
