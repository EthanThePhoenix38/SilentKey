# SilentKey Architecture

## Modular Protocol-Based Architecture

SilentKey is built on a modular, protocol-oriented architecture that allows easy extension without modifying core code. This design follows Swift best practices and enables rapid feature development.

## Core Protocols

### SecretItemProtocol

The foundation of all secret types. Every secret in SilentKey conforms to this protocol:

```swift
public protocol SecretItemProtocol: Identifiable, Codable, Hashable {
    var id: UUID { get }
    var title: String { get set }
    var category: SecretCategory { get }
    var tags: Set<String> { get set }
    // ... more properties
}
```

**Benefits:**
- Consistent interface across all secret types
- Easy to add new secret types
- Type-safe and composable

### EncryptableSecret

Enables encryption capabilities for any secret type:

```swift
public protocol EncryptableSecret: SecretItemProtocol {
    var encryptedFields: [String: Data] { get set }
    mutating func encrypt(field: String, value: String, using key: Data) throws
    func decrypt(field: String, using key: Data) throws -> String
}
```

**Features:**
- Field-level encryption
- Support for multiple encryption keys
- Automatic encryption/decryption

### ExportableSecret

Provides export functionality:

```swift
public protocol ExportableSecret: SecretItemProtocol {
    func export(format: ExportFormat) throws -> Data
    var supportedExportFormats: [ExportFormat] { get }
}
```

**Supported Formats:**
- JSON
- CSV
- Encrypted Vault
- Plain Text (with warnings)

## Secret Categories

All secrets are categorized for organization:

- **API Key**: REST APIs, GraphQL, OAuth, JWT, Bearer Tokens
- **Bank Account**: Checking, Savings, Credit, Investment, Business
- **Credit Card**: Visa, Mastercard, Amex, Discover
- **SSH Key**: RSA, ED25519, ECDSA, DSA
- **Password**: Generic passwords
- **Token**: Access tokens, refresh tokens
- **Certificate**: SSL/TLS certificates
- **License**: Software licenses
- **Secure Note**: Encrypted notes
- **Custom**: User-defined types

## Built-in Secret Models

### BankAccountSecret

Full banking support with encrypted fields:

```swift
public struct BankAccountSecret: SecretItemProtocol, EncryptableSecret, ExportableSecret {
    public var bankName: String
    public var accountType: BankAccountType
    public var encryptedFields: [String: Data]
    
    // Encrypted fields: accountNumber, routingNumber, IBAN, SWIFT, PIN
}
```

**Account Types:**
- Checking
- Savings
- Credit
- Investment
- Business

### CreditCardSecret

Secure credit card storage:

```swift
public struct CreditCardSecret: SecretItemProtocol, EncryptableSecret {
    public var cardIssuer: String
    public var cardType: CreditCardType
    public var expirationDate: Date?
    public var billingAddress: Address?
    
    // Encrypted fields: cardNumber, CVV, PIN
}
```

### APIKeySecret

API key management:

```swift
public struct APIKeySecret: SecretItemProtocol, EncryptableSecret, ExportableSecret {
    public var serviceName: String
    public var apiKeyType: APIKeyType
    public var scopes: Set<String>
    
    // Supports: REST API, GraphQL, OAuth, JWT, Basic Auth, Bearer Token
}
```

### SSHKeySecret

SSH credential management:

```swift
public struct SSHKeySecret: SecretItemProtocol, EncryptableSecret {
    public var hostname: String
    public var username: String
    public var keyType: SSHKeyType
    public var port: Int
    
    // Supports: RSA, ED25519, ECDSA, DSA
}
```

## Plugin System

### PluginManager

Centralized plugin management:

```swift
public class PluginManager {
    public static let shared = PluginManager()
    
    public func register(_ plugin: any SecretPlugin)
    public func execute(pluginId: String, action: PluginAction, on secret: any SecretItemProtocol) async throws -> PluginResult
}
```

**Thread-Safe:**
- Uses DispatchQueue for safe concurrent access
- Barrier flags for write operations

### Built-in Plugins

#### BankingValidationPlugin

Validates banking secrets:
- Account name validation
- Field completeness checks
- Business rule enforcement

#### ExportPlugin

Multi-format export:
- JSON export
- CSV export
- Encrypted vault export

#### BackupPlugin

Automatic backups:
- Encrypted backup creation
- Timestamp tracking
- Restore capabilities

## Template System

### SecretTemplate Protocol

Defines how to create new secret types:

```swift
public protocol SecretTemplate {
    static var templateName: String { get }
    static var requiredFields: [FieldDefinition] { get }
    static var optionalFields: [FieldDefinition] { get }
    static func create(from fields: [String: Any]) throws -> Self
}
```

### TemplateManager

Manages all templates:

```swift
public class TemplateManager {
    public static let shared = TemplateManager()
    
    public func register<T: SecretTemplate>(_ template: T.Type)
    public func createSecret<T: SecretTemplate>(from template: T.Type, with fields: [String: Any]) throws -> T
}
```

## How to Add New Features

### 1. Create a New Secret Type

```swift
public struct MyCustomSecret: SecretItemProtocol, EncryptableSecret {
    public let id: UUID
    public var title: String
    // ... implement required properties
    
    public var category: SecretCategory {
        .custom
    }
}
```

### 2. Add a Template

```swift
extension MyCustomSecret: SecretTemplate {
    public static var templateName: String { "My Custom Secret" }
    public static var requiredFields: [FieldDefinition] { [...] }
    public static func create(from fields: [String: Any]) throws -> MyCustomSecret { ... }
}
```

### 3. Create a Plugin

```swift
public struct MyCustomPlugin: SecretPlugin {
    public let id = "com.mycompany.custom"
    public let name = "Custom Plugin"
    public var supportedCategories: [SecretCategory] { [.custom] }
    
    public func performAction(_ action: PluginAction, on secret: any SecretItemProtocol) async throws -> PluginResult {
        // Implementation
    }
}
```

### 4. Register Everything

```swift
// Register template
TemplateManager.shared.register(MyCustomSecret.self)

// Register plugin
PluginManager.shared.register(MyCustomPlugin())
```

## Directory Structure

```
Sources/
└── Core/
    ├── Protocols/
    │   └── SecretItemProtocol.swift    # Base protocols
    ├── Models/
    │   ├── BankingModels.swift         # Banking secrets
    │   ├── APIKeyModels.swift          # API & SSH secrets
    │   └── SecretItem.swift            # Base model
    ├── Plugins/
    │   └── PluginSystem.swift          # Plugin infrastructure
    └── Crypto/
        └── EncryptionManager.swift     # Encryption logic
```

## Design Principles

### 1. Protocol-Oriented Programming
- Protocols over classes
- Composition over inheritance
- Value types (struct) over reference types (class)

### 2. Modularity
- Each module is self-contained
- Easy to test in isolation
- Clear separation of concerns

### 3. Extensibility
- New features via protocols
- Plugins for custom behavior
- Templates for new types

### 4. Security
- Field-level encryption
- No plaintext storage
- Double-layer encryption support

### 5. Type Safety
- Swift's strong typing
- Compile-time guarantees
- No runtime type casting

## Benefits of This Architecture

✅ **Easy to Extend**: Add new secret types without modifying existing code
✅ **Type-Safe**: Compiler catches errors at build time
✅ **Testable**: Mock protocols for unit testing
✅ **Maintainable**: Clear separation of concerns
✅ **Performant**: Value types and protocol witnesses
✅ **Flexible**: Plugins and templates for custom behavior
✅ **Secure**: Encryption built into the protocol layer

## Next Steps

See [TEMPLATES.md](TEMPLATES.md) for a guide on creating custom templates and plugins.
