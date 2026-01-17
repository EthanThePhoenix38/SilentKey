//
//  PasswordGenerator.swift
//  SilentKey
//
//  Générateur de mots de passe sécurisés avec options personnalisables.
//  Compatible iOS 16+ et macOS 13+.
//

import Foundation
import CryptoKit

/// Générateur de mots de passe sécurisés.
/// Utilise des sources aléatoires cryptographiquement sécurisées.
public struct PasswordGenerator {
    
    // MARK: - Configuration
    
    /// Configuration pour la génération de mots de passe.
    public struct Configuration {
        /// Longueur du mot de passe (minimum 8, maximum 128).
        public let length: Int
        
        /// Inclure les lettres majuscules (A-Z).
        public let includeUppercase: Bool
        
        /// Inclure les lettres minuscules (a-z).
        public let includeLowercase: Bool
        
        /// Inclure les chiffres (0-9).
        public let includeNumbers: Bool
        
        /// Inclure les symboles spéciaux (!@#$%^&*...).
        public let includeSymbols: Bool
        
        /// Exclure les caractères ambigus (0,O,l,1,etc.).
        public let excludeAmbiguous: Bool
        
        /// Nombre minimum de chaque type de caractère.
        public let minimumRequirements: Bool
        
        /// Initialise une configuration par défaut.
        public init(
            length: Int = 16,
            includeUppercase: Bool = true,
            includeLowercase: Bool = true,
            includeNumbers: Bool = true,
            includeSymbols: Bool = true,
            excludeAmbiguous: Bool = false,
            minimumRequirements: Bool = true
        ) {
            self.length = max(8, min(128, length))
            self.includeUppercase = includeUppercase
            self.includeLowercase = includeLowercase
            self.includeNumbers = includeNumbers
            self.includeSymbols = includeSymbols
            self.excludeAmbiguous = excludeAmbiguous
            self.minimumRequirements = minimumRequirements
        }
        
        /// Configuration forte recommandée (20 caractères, tous types).
        public static var strong: Configuration {
            Configuration(
                length: 20,
                includeUppercase: true,
                includeLowercase: true,
                includeNumbers: true,
                includeSymbols: true,
                excludeAmbiguous: false,
                minimumRequirements: true
            )
        }
        
        /// Configuration PIN numérique (6 chiffres).
        public static var pin: Configuration {
            Configuration(
                length: 6,
                includeUppercase: false,
                includeLowercase: false,
                includeNumbers: true,
                includeSymbols: false,
                excludeAmbiguous: false,
                minimumRequirements: false
            )
        }
        
        /// Configuration pass
