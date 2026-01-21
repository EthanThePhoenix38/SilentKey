//
//  VaultManager.swift
//  SilentKey
//

import Foundation
import CryptoKit

/// Gestionnaire principal du coffre-fort chiffré
public actor VaultManager {
    public static let shared = VaultManager()
    
    private let encryptionManager: EncryptionManager
    private let fileStorage: FileStorage
    private let logger = Logger.shared
    
    private(set) var isUnlocked: Bool = false
    private var masterKey: SymmetricKey?
    
    // MARK: - Initialisation
    
    private init() {
        self.encryptionManager = EncryptionManager.shared
        self.fileStorage = FileStorage.shared
    }
    
    // MARK: - Unlock/Lock
    
    /// Initialise le coffre avec un nouveau mot de passe (première utilisation)
    public func setup(masterPassword: String) async throws {
        logger.log("Initialisation du coffre", level: .info, category: .security)
        
        // Générer un nouveau sel
        let salt = try KeyDerivationService.generateSalt()
        
        // Créer les métadonnées
        let metadata = VaultMetadata(salt: salt)
        try await fileStorage.saveMetadata(metadata)
        
        // Dériver la clé et déverrouiller
        let derivedKey = try await encryptionManager.deriveKey(from: masterPassword, salt: salt)
        masterKey = derivedKey
        isUnlocked = true
        
        logger.log("Coffre initialisé et déverrouillé", level: .info, category: .security)
    }
    
    /// Déverrouille le coffre avec le mot de passe maître
    public func unlock(masterPassword: String) async throws {
        logger.log("Tentative de déverrouillage du coffre", level: .info, category: .security)
        
        // Charger les métadonnées pour récupérer le sel
        guard let metadata = try await fileStorage.loadMetadata() else {
            logger.log("Métadonnées introuvables. Le coffre doit être initialisé.", level: .error, category: .security)
            throw VaultError.itemNotFound
        }
        
        // Dériver la clé maître depuis le mot de passe et le sel stocké
        let derivedKey = try await encryptionManager.deriveKey(from: masterPassword, salt: metadata.salt)
        
        masterKey = derivedKey
        isUnlocked = true
        
        logger.log("Coffre déverrouillé avec succès", level: .info, category: .security)
    }
    
    /// Verrouille le coffre et efface la clé de la RAM
    public func lock() {
        logger.log("Verrouillage du coffre", level: .info, category: .security)
        
        // Effacer la clé de la RAM
        masterKey = nil
        isUnlocked = false
        
        logger.log("Coffre verrouillé", level: .info, category: .security)
    }
    
    // MARK: - CRUD Operations
    
    /// Crée un nouvel item dans le coffre
    public func create<T: SecretItemProtocol>(_ item: T) async throws -> T {
        guard isUnlocked, let key = masterKey else {
            throw VaultError.vaultLocked
        }
        
        logger.log("Création d'un nouvel item: \(item.title)", level: .info, category: .storage)
        
        // Chiffrer l'item
        let encryptedData = try await encryptionManager.encrypt(item, using: key)
        
        // Sauvegarder
        try await fileStorage.save(encryptedData, forID: item.id)
        
        logger.log("Item créé avec succès", level: .info, category: .storage)
        return item
    }
    
    /// Lit un item depuis le coffre
    public func read<T: SecretItemProtocol>(id: UUID, as type: T.Type) async throws -> T {
        guard isUnlocked, let key = masterKey else {
            throw VaultError.vaultLocked
        }
        
        logger.log("Lecture de l'item: \(id)", level: .debug, category: .storage)
        
        // Charger les données chiffrées
        let encryptedData = try await fileStorage.load(forID: id)
        
        // Déchiffrer
        let item = try await encryptionManager.decrypt(encryptedData, as: type, using: key)
        
        return item
    }
    
    /// Met à jour un item existant
    public func update<T: SecretItemProtocol>(_ item: T) async throws -> T {
        guard isUnlocked, let key = masterKey else {
            throw VaultError.vaultLocked
        }
        
        logger.log("Mise à jour de l'item: \(item.title)", level: .info, category: .storage)
        
        // Créer une nouvelle version avec modifiedAt mis à jour
        var updatedItem = item
        updatedItem.modifiedAt = Date()
        
        // Chiffrer et sauvegarder
        let encryptedData = try await encryptionManager.encrypt(updatedItem, using: key)
        try await fileStorage.save(encryptedData, forID: updatedItem.id)
        
        // Mettre à jour la date de modification des métadonnées
        if var metadata = try await fileStorage.loadMetadata() {
            metadata.lastModified = Date()
            try await fileStorage.saveMetadata(metadata)
        }
        
        logger.log("Item mis à jour avec succès", level: .info, category: .storage)
        return updatedItem
    }
    
    /// Supprime un item (soft delete vers la poubelle)
    public func delete(id: UUID) async throws {
        guard isUnlocked else {
            throw VaultError.vaultLocked
        }
        
        logger.log("Suppression de l'item: \(id)", level: .info, category: .storage)
        
        // Déplacer vers la poubelle au lieu de supprimer
        try await fileStorage.moveToTrash(forID: id)
        
        logger.log("Item déplacé vers la poubelle", level: .info, category: .storage)
    }
    
    /// Liste tous les items d'un type donné
    public func list<T: SecretItemProtocol>(type: T.Type) async throws -> [T] {
        guard isUnlocked, let _ = masterKey else {
            throw VaultError.vaultLocked
        }
        
        logger.log("Liste des items de type: \(type)", level: .debug, category: .storage)
        
        let ids = try await fileStorage.listAllIDs()
        var items: [T] = []
        
        for id in ids {
            do {
                let item = try await read(id: id, as: type)
                items.append(item)
            } catch {
                logger.log("Erreur lecture item \(id): \(error)", level: .warning, category: .storage)
            }
        }
        
        return items
    }
    
    // MARK: - Backup & Recovery
    
    /// Crée un backup complet du coffre
    public func createBackup(to url: URL) async throws {
        guard isUnlocked else {
            throw VaultError.vaultLocked
        }
        
        logger.log("Création d'un backup", level: .info, category: .storage)
        
        let backupData = try await fileStorage.createBackup()
        try backupData.write(to: url)
        
        logger.log("Backup créé avec succès", level: .info, category: .storage)
    }
    
    /// Restaure le coffre depuis un backup
    public func restoreBackup(from url: URL, masterPassword: String) async throws {
        logger.log("Restauration depuis backup", level: .info, category: .storage)
        
        let backupData = try Data(contentsOf: url)
        let backup = try JSONDecoder().decode(VaultBackup.self, from: backupData)
        
        // Vérifier le mot de passe en essayant de dériver la clé avec le sel du backup
        let _ = try await encryptionManager.deriveKey(from: masterPassword, salt: backup.metadata.salt)
        
        // Si ça passe, on restaure
        try await fileStorage.restoreBackup(backupData)
        
        logger.log("Backup restauré avec succès", level: .info, category: .storage)
    }
}

// MARK: - Vault Errors

public enum VaultError: LocalizedError {
    case vaultLocked
    case invalidMasterPassword
    case itemNotFound
    case encryptionFailed
    case decryptionFailed
    
    public var errorDescription: String? {
        switch self {
        case .vaultLocked:
            return "Le coffre est verrouillé. Veuillez le déverrouiller d'abord."
        case .invalidMasterPassword:
            return "Mot de passe maître invalide."
        case .itemNotFound:
            return "Item non trouvé."
        case .encryptionFailed:
            return "Échec du chiffrement."
        case .decryptionFailed:
            return "Échec du déchiffrement."
        }
    }
}
