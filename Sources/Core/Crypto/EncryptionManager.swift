//
//  EncryptionManager.swift
//  SilentKey
//
//  Gestionnaire centralisé du chiffrement pour VaultManager
//

import Foundation
import CryptoKit

/// Gestionnaire de chiffrement pour le coffre-fort
public actor EncryptionManager {
    public static let shared = EncryptionManager()
    
    private init() {}
    
    /// Dérive une clé depuis un mot de passe et un sel
    /// - Parameters:
    ///   - password: Mot de passe maître
    ///   - salt: Sel cryptographique
    /// - Returns: Clé symétrique dérivée
    public func deriveKey(from password: String, salt: Data) async throws -> SymmetricKey {
        guard !password.isEmpty else {
            throw KeyDerivationService.KeyDerivationError.invalidPassword
        }
        
        return try KeyDerivationService.deriveMasterKey(from: password, salt: salt)
    }
    
    /// Chiffre un item codable
    /// - Parameters:
    ///   - item: Item à chiffrer
    ///   - key: Clé de chiffrement
    /// - Returns: Données chiffrées
    public func encrypt<T: Encodable>(_ item: T, using key: SymmetricKey) async throws -> Data {
        let encoder = JSONEncoder()
        let plainData = try encoder.encode(item)
        return try AESEncryptionService.encrypt(plainData, with: key)
    }
    
    /// Déchiffre des données vers un type codable
    /// - Parameters:
    ///   - data: Données chiffrées
    ///   - type: Type cible
    ///   - key: Clé de déchiffrement
    /// - Returns: Item déchiffré
    public func decrypt<T: Decodable>(_ data: Data, as type: T.Type, using key: SymmetricKey) async throws -> T {
        let plainData = try AESEncryptionService.decrypt(data, with: key)
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: plainData)
    }
    
    /// Chiffre des données avec un nouveau sel et retourne un conteneur sécurisé
    public func encryptWithNewSalt(_ data: Data, password: String) async throws -> EncryptedContainer {
        let salt = try KeyDerivationService.generateSalt()
        let key = try await deriveKey(from: password, salt: salt)
        let ciphertext = try AESEncryptionService.encrypt(data, with: key)
        return EncryptedContainer(salt: salt, ciphertext: ciphertext)
    }
    
    /// Déchiffre un conteneur sécurisé avec un mot de passe
    public func decryptContainer(_ container: EncryptedContainer, password: String) async throws -> Data {
        let key = try await deriveKey(from: password, salt: container.salt)
        return try AESEncryptionService.decrypt(container.ciphertext, with: key)
    }
}

/// Conteneur pour données chiffrées avec leur sel
public struct EncryptedContainer: Codable {
    public let salt: Data
    public let ciphertext: Data
}
