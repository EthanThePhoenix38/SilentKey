//
//  FileStorage.swift
//  SilentKey
//

import Foundation

/// Gestionnaire du stockage fichier local chiffré
actor FileStorage {
    static let shared = FileStorage()
    
    private let fileManager = FileManager.default
    private let logger = Logger.shared
    
    private var vaultDirectory: URL
    private var trashDirectory: URL
    
    // MARK: - Initialisation
    
    private init() {
        // Configuration des répertoires
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let silentKeyDir = appSupport.appendingPathComponent("SilentKey")
        
        self.vaultDirectory = silentKeyDir.appendingPathComponent("Vault")
        self.trashDirectory = silentKeyDir.appendingPathComponent("Trash")
        
        // Créer les répertoires si nécessaire
        try? fileManager.createDirectory(at: vaultDirectory, withIntermediateDirectories: true)
        try? fileManager.createDirectory(at: trashDirectory, withIntermediateDirectories: true)
        
        logger.log("FileStorage initialisé", level: .info, category: .storage)
    }
    
    // MARK: - CRUD Operations
    
    /// Sauvegarde des données chiffrées
    func save(_ data: Data, forID id: UUID) async throws {
        let fileURL = vaultDirectory.appendingPathComponent("\(id.uuidString).vault")
        
        logger.log("Sauvegarde fichier: \(id)", level: .debug, category: .storage)
        
        do {
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            logger.log("Fichier sauvegardé: \(id)", level: .debug, category: .storage)
        } catch {
            logger.log("Erreur sauvegarde: \(error)", level: .error, category: .storage)
            throw StorageError.writeFailed(error)
        }
    }
    
    /// Charge des données chiffrées
    func load(forID id: UUID) async throws -> Data {
        let fileURL = vaultDirectory.appendingPathComponent("\(id.uuidString).vault")
        
        logger.log("Chargement fichier: \(id)", level: .debug, category: .storage)
        
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            logger.log("Erreur chargement: \(error)", level: .error, category: .storage)
            throw StorageError.readFailed(error)
        }
    }
    
    /// Déplace un item vers la poubelle (soft delete)
    func moveToTrash(forID id: UUID) async throws {
        let sourceURL = vaultDirectory.appendingPathComponent("\(id.uuidString).vault")
        let destinationURL = trashDirectory.appendingPathComponent("\(id.uuidString).trash")
        
        logger.log("Déplacement vers poubelle: \(id)", level: .info, category: .storage)
        
        // Ajouter métadonnées de suppression
        let trashMetadata = TrashMetadata(
            originalID: id,
            deletedDate: Date(),
            expirationDate: Date().addingTimeInterval(30 * 24 * 60 * 60) // 30 jours
        )
        
        do {
            // Déplacer le fichier
            try fileManager.moveItem(at: sourceURL, to: destinationURL)
            
            // Sauvegarder les métadonnées
            let metadataURL = trashDirectory.appendingPathComponent("\(id.uuidString).meta")
            let metadataData = try JSONEncoder().encode(trashMetadata)
            try metadataData.write(to: metadataURL)
            
            logger.log("Item déplacé vers poubelle", level: .info, category: .storage)
        } catch {
            logger.log("Erreur déplacement poubelle: \(error)", level: .error, category: .storage)
            throw StorageError.deleteFailed(error)
        }
    }
    
    /// Restaure un item depuis la poubelle
    func restoreFromTrash(id: UUID, newName: String? = nil) async throws {
        let trashURL = trashDirectory.appendingPathComponent("\(id.uuidString).trash")
        let metadataURL = trashDirectory.appendingPathComponent("\(id.uuidString).meta")
        
        logger.log("Restauration depuis poubelle: \(id)", level: .info, category: .storage)
        
        // Gestion des conflits de noms
        var finalID = id
        var vaultURL = vaultDirectory.appendingPathComponent("\(id.uuidString).vault")
        
        // Si fichier existe déjà, créer un nouveau UUID
        if fileManager.fileExists(atPath: vaultURL.path) {
            finalID = UUID()
            vaultURL = vaultDirectory.appendingPathComponent("\(finalID.uuidString).vault")
            logger.log("Conflit détecté, nouvel ID: \(finalID)", level: .warning, category: .storage)
        }
        
        do {
            // Déplacer le fichier
            try fileManager.moveItem(at: trashURL, to: vaultURL)
            
            // Supprimer les métadonnées
            try? fileManager.removeItem(at: metadataURL)
            
            logger.log("Item restauré depuis poubelle", level: .info, category: .storage)
        } catch {
            logger.log("Erreur restauration: \(error)", level: .error, category: .storage)
            throw StorageError.restoreFailed(error)
        }
    }
    
    /// Supprime définitivement un item de la poubelle
    func permanentDelete(id: UUID) async throws {
        let trashURL = trashDirectory.appendingPathComponent("\(id.uuidString).trash")
        let metadataURL = trashDirectory.appendingPathComponent("\(id.uuidString).meta")
        
        logger.log("Suppression définitive: \(id)", level: .warning, category: .storage)
        
        do {
            try fileManager.removeItem(at: trashURL)
            try? fileManager.removeItem(at: metadataURL)
            
            logger.log("Item supprimé définitivement", level: .warning, category: .storage)
        } catch {
            logger.log("Erreur suppression définitive: \(error)", level: .error, category: .storage)
            throw StorageError.deleteFailed(error)
        }
    }
    
    // MARK: - Listing
    
    /// Liste tous les IDs dans le coffre
    func listAllIDs() async throws -> [UUID] {
        logger.log("Liste de tous les IDs", level: .debug, category: .storage)
        
        do {
            let contents = try fileManager.contentsOfDirectory(at: vaultDirectory, includingPropertiesForKeys: nil)
            let vaultFiles = contents.filter { $0.pathExtension == "vault" }
            
            let ids = vaultFiles.compactMap { url -> UUID? in
                let filename = url.deletingPathExtension().lastPathComponent
                return UUID(uuidString: filename)
            }
            
            logger.log("\(ids.count) items trouvés", level: .debug, category: .storage)
            return ids
        } catch {
            logger.log("Erreur liste IDs: \(error)", level: .error, category: .storage)
            throw StorageError.listFailed(error)
        }
    }
    
    /// Liste tous les items dans la poubelle
    func listTrashIDs() async throws -> [UUID] {
        logger.log("Liste des items dans la poubelle", level: .debug, category: .storage)
        
        do {
            let contents = try fileManager.contentsOfDirectory(at: trashDirectory, includingPropertiesForKeys: nil)
            let trashFiles = contents.filter { $0.pathExtension == "trash" }
            
            let ids = trashFiles.compactMap { url -> UUID? in
                let filename = url.deletingPathExtension().lastPathComponent
                return UUID(uuidString: filename)
            }
            
            logger.log("\(ids.count) items en poubelle", level: .debug, category: .storage)
            return ids
        } catch {
            logger.log("Erreur liste poubelle: \(error)", level: .error, category: .storage)
            throw StorageError.listFailed(error)
        }
    }
    
    // MARK: - Trash Management
    
    /// Nettoie les items expirés de la poubelle
    func cleanExpiredTrash() async throws {
        logger.log("Nettoyage items expirés", level: .info, category: .storage)
        
        let trashIDs = try await listTrashIDs()
        let now = Date()
        var cleanedCount = 0
        
        for id in trashIDs {
            let metadataURL = trashDirectory.appendingPathComponent("\(id.uuidString).meta")
            
            if let metadataData = try? Data(contentsOf: metadataURL),
               let metadata = try? JSONDecoder().decode(TrashMetadata.self, from: metadataData) {
                
                if metadata.expirationDate < now {
                    try await permanentDelete(id: id)
                    cleanedCount += 1
                }
            }
        }
        
        logger.log("\(cleanedCount) items expirés supprimés", level: .info, category: .storage)
    }
    
    /// Vide complètement la poubelle
    func emptyTrash() async throws {
        logger.log("Vidage complet de la poubelle", level: .warning, category: .storage)
        
        let trashIDs = try await listTrashIDs()
        
        for id in trashIDs {
            try await permanentDelete(id: id)
        }
        
        logger.log("Poubelle vidée: \(trashIDs.count) items supprimés", level: .warning, category: .storage)
    }
    
    // MARK: - Backup & Recovery
    
    /// Crée un backup du coffre complet
    func createBackup() async throws -> Data {
        logger.log("Création backup", level: .info, category: .storage)
        
        let ids = try await listAllIDs()
        var items: [String: Data] = [:]
        
        for id in ids {
            let data = try await load(forID: id)
            items[id.uuidString] = data
        }
        
        guard let metadata = try await loadMetadata() else {
            throw StorageError.readFailed(NSError(domain: "FileStorage", code: 404, userInfo: [NSLocalizedDescriptionKey: "Metadata not found"]))
        }
        
        let backup = VaultBackup(metadata: metadata, items: items)
        let backupData = try JSONEncoder().encode(backup)
        
        logger.log("Backup créé: \(ids.count) items", level: .info, category: .storage)
        return backupData
    }
    
    /// Restaure depuis un backup
    func restoreBackup(_ backupData: Data) async throws {
        logger.log("Restauration backup", level: .warning, category: .storage)
        
        let backup = try JSONDecoder().decode(VaultBackup.self, from: backupData)
        
        // Restaurer métadonnées
        try await saveMetadata(backup.metadata)
        
        // Restaurer items
        for (uuidString, data) in backup.items {
            if let id = UUID(uuidString: uuidString) {
                try await save(data, forID: id)
            }
        }
        
        logger.log("Backup restauré: \(backup.items.count) items", level: .info, category: .storage)
    }
    
    // MARK: - Metadata
    
    /// Sauvegarde les métadonnées du coffre
    func saveMetadata(_ metadata: VaultMetadata) async throws {
        let fileURL = vaultDirectory.appendingPathComponent("metadata.json")
        let data = try JSONEncoder().encode(metadata)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
    
    /// Charge les métadonnées du coffre
    func loadMetadata() async throws -> VaultMetadata? {
        let fileURL = vaultDirectory.appendingPathComponent("metadata.json")
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(VaultMetadata.self, from: data)
    }
}

// MARK: - Supporting Types

public struct VaultMetadata: Codable {
    public let salt: Data
    public let createdAt: Date
    public var lastModified: Date
    public var version: String
    
    public init(salt: Data, version: String = "1.3.1") {
        self.salt = salt
        self.createdAt = Date()
        self.lastModified = Date()
        self.version = version
    }
}

public struct VaultBackup: Codable {
    public let metadata: VaultMetadata
    public let items: [String: Data]
}

public struct TrashMetadata: Codable {
    let originalID: UUID
    let deletedDate: Date
    let expirationDate: Date
}

// MARK: - Storage Errors

public enum StorageError: LocalizedError {
    case writeFailed(Error)
    case readFailed(Error)
    case deleteFailed(Error)
    case restoreFailed(Error)
    case listFailed(Error)
    case directoryCreationFailed
    
    public var errorDescription: String? {
        switch self {
        case .writeFailed(let error):
            return "Échec écriture: \(error.localizedDescription)"
        case .readFailed(let error):
            return "Échec lecture: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Échec suppression: \(error.localizedDescription)"
        case .restoreFailed(let error):
            return "Échec restauration: \(error.localizedDescription)"
        case .listFailed(let error):
            return "Échec liste: \(error.localizedDescription)"
        case .directoryCreationFailed:
            return "Échec création répertoire"
        }
    }
}
