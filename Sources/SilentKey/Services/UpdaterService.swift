//
//  UpdaterService.swift
//  SilentKey
//
//  Service de mise à jour automatique pour les nouvelles versions
//  Vérifie les releases GitHub et propose les mises à jour
//

import Foundation
import AppKit

/// Service de gestion des mises à jour automatiques de l'application
/// Vérifie périodiquement les nouvelles versions disponibles sur GitHub Releases
class UpdaterService: ObservableObject {
    
    // MARK: - Propriétés
    
    /// URL du fichier appcast contenant les informations de mise à jour
    private let appcastURL = "https://ethanthephoenix38.github.io/SilentKey/appcast.xml"
    
    /// Version actuelle de l'application (versioning sémantique)
    @Published var currentVersion: String = "1.0.0"
    
    /// Nouvelle version disponible
    @Published var availableVersion: String?
    
    /// Indicateur de mise à jour disponible
    @Published var updateAvailable: Bool = false
    
    /// Description des changements de la nouvelle version
    @Published var releaseNotes: String = ""
    
    /// URL de téléchargement de la mise à jour
    private var downloadURL: URL?
    
    // MARK: - Initialisation
    
    /// Initialise le service de mise à jour
    /// - Author: PhoenixProject
    /// - Website: http://ThePhoenixAgency.github.io
    init() {
        loadCurrentVersion()
        scheduleUpdateCheck()
    }
    
    // MARK: - Méthodes Publiques
    
    /// Vérifie manuellement les mises à jour disponibles
    /// - Author: PhoenixProject
    /// - Returns: Void
    func checkForUpdates() {
        guard let url = URL(string: appcastURL) else {
            print("[UpdaterService] URL d'appcast invalide")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("[UpdaterService] Erreur lors de la vérification: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("[UpdaterService] Aucune donnée reçue")
                return
            }
            
            self.parseAppcast(data)
        }
        
        task.resume()
    }
    
    /// Lance le téléchargement et l'installation de la mise à jour
    /// - Author: PhoenixProject
    func installUpdate() {
        guard let downloadURL = downloadURL else {
            print("[UpdaterService] Aucune URL de téléchargement disponible")
            return
        }
        
        NSWorkspace.shared.open(downloadURL)
    }
    
    // MARK: - Méthodes Privées
    
    /// Charge la version actuelle depuis le bundle
    /// - Author: PhoenixProject
    private func loadCurrentVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            currentVersion = version
        }
    }
    
    /// Programme la vérification automatique des mises à jour
    /// Vérifie toutes les 24 heures
    /// - Author: PhoenixProject
    private func scheduleUpdateCheck() {
        Timer.scheduledTimer(withTimeInterval: 86400, repeats: true) { [weak self] _ in
            self?.checkForUpdates()
        }
        
        // Vérification initiale après 30 secondes
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            self?.checkForUpdates()
        }
    }
    
    /// Parse le fichier appcast XML pour extraire les informations de mise à jour
    /// - Parameter data: Données XML du fichier appcast
    /// - Author: PhoenixProject
    private func parseAppcast(_ data: Data) {
        let parser = XMLParser(data: data)
        let delegate = AppcastParserDelegate()
        parser.delegate = delegate
        
        if parser.parse() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let latestVersion = delegate.latestVersion,
                   self.isNewerVersion(latestVersion, than: self.currentVersion) {
                    self.availableVersion = latestVersion
                    self.releaseNotes = delegate.releaseNotes ?? ""
                    self.downloadURL = delegate.downloadURL
                    self.updateAvailable = true
                    
                    self.showUpdateNotification(version: latestVersion)
                }
            }
        }
    }
    
    /// Compare deux versions sémantiques (MAJOR.MINOR.PATCH)
    /// - Parameters:
    ///   - newVersion: Nouvelle version à comparer
    ///   - currentVersion: Version actuelle
    /// - Returns: True si newVersion est plus récente
    /// - Author: PhoenixProject
    private func isNewerVersion(_ newVersion: String, than currentVersion: String) -> Bool {
        let newComponents = newVersion.split(separator: ".").compactMap { Int($0) }
        let currentComponents = currentVersion.split(separator: ".").compactMap { Int($0) }
        
        for i in 0..<min(newComponents.count, currentComponents.count) {
            if newComponents[i] > currentComponents[i] {
                return true
            } else if newComponents[i] < currentComponents[i] {
                return false
            }
        }
        
        return newComponents.count > currentComponents.count
    }
    
    /// Affiche une notification système pour informer de la mise à jour
    /// - Parameter version: Numéro de la nouvelle version
    /// - Author: PhoenixProject
    private func showUpdateNotification(version: String) {
        let notification = NSUserNotification()
        notification.title = "Mise à jour disponible"
        notification.informativeText = "SilentKey \(version) est maintenant disponible"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.actionButtonTitle = "Mettre à jour"
        
        NSUserNotificationCenter.default.deliver(notification)
    }
}

// MARK: - AppcastParserDelegate

/// Délégué pour parser le fichier XML appcast
/// - Author: PhoenixProject
private class AppcastParserDelegate: NSObject, XMLParserDelegate {
    var latestVersion: String?
    var releaseNotes: String?
    var downloadURL: URL?
    
    private var currentElement = ""
    private var currentEnclosure: [String: String] = [:]
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        
        if elementName == "enclosure" {
            currentEnclosure = attributeDict
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        switch currentElement {
        case "sparkle:version":
            if latestVersion == nil {
                latestVersion = trimmed
            }
        case "sparkle:releaseNotesLink":
            if releaseNotes == nil {
                releaseNotes = trimmed
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "enclosure", let urlString = currentEnclosure["url"] {
            downloadURL = URL(string: urlString)
        }
        currentElement = ""
    }
}
