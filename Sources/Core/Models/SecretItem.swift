//
//  SecretItem.swift
//  SilentKey - Modèle de données pour secret
//

import Foundation

/// Type de secret stocké.
public enum SecretType: String, Codable {
    case apiKey = "API Key"
    case token = "Token"
    case credential = "Credential"
    case sshKey = "SSH Key"
    case generic = "Generic"
}

/// Représente un secret chiffré dans le coffre.
public struct SecretItem: SecretItemProtocol, Identifiable, Codable, Hashable {
    public let id: UUID
    public var title: String
    public var type: SecretType
    public var encryptedValue: Data
    public var notes: String?
    public var createdAt: Date
    public var modifiedAt: Date
    public var tags: Set<String>
    public var isFavorite: Bool
    
    public var category: SecretCategory {
        switch type {
        case .apiKey: return .apiKey
        case .token: return .token
        case .credential: return .password
        case .sshKey: return .sshKey
        case .generic: return .custom
        }
    }
    
    public var iconName: String {
        category.icon
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        type: SecretType,
        encryptedValue: Data,
        notes: String? = nil,
        tags: Set<String> = [],
        isFavorite: Bool = false,
        createdAt: Date = Date(),
        modifiedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.encryptedValue = encryptedValue
        self.notes = notes
        self.tags = tags
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
    
    public func encryptedData() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    public func validate() throws {
        if title.isEmpty { throw SecretError.invalidTitle }
    }
    
    public func searchableText() -> String {
        "\(title) \(notes ?? "")"
    }
}

public enum SecretError: Error {
    case invalidTitle
}
