# SilentKey

<div align="center">

**Local-first developer secrets vault with double-layer encryption**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey.svg)](https://github.com/EthanThePhoenix38/SilentKey)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-blue.svg)](https://developer.apple.com/xcode/swiftui/)

[English](#english) | [Français](#français)

</div>

---

## English

### Overview

SilentKey is a professional, local-first secrets vault designed specifically for developers who need to securely manage API keys, tokens, credentials, SSH keys, and sensitive data. Built with SwiftUI, it runs natively on both iOS and macOS with no cloud dependency, no telemetry, and complete transparency.

### Key Features

- **Double-Layer Encryption**: AES-256-GCM + XChaCha20-Poly1305 for maximum security
- **Local-First Architecture**: All data stays on your device, no cloud sync required
- **Cross-Platform**: Native SwiftUI app for iOS 16+ and macOS 13+
- **Biometric Authentication**: Touch ID / Face ID integration
- **Developer-Focused**: Optimized for API keys, tokens, credentials, SSH keys, database connections
- **Zero Telemetry**: No tracking, no analytics, no data collection
- **Modern UI**: Professional, clean interface with dark mode support
- **Export/Import**: Encrypted backup and restore functionality

### Security Model

#### Encryption Layers

**Layer 1: Vault-Level Encryption**
- Algorithm: AES-256-GCM
- Key Derivation: Argon2id (600,000 iterations, 16-byte salt)
- Master key never stored, derived from password on each unlock

**Layer 2: Item-Level Encryption**
- Algorithm: XChaCha20-Poly1305
- Per-item keys derived via HKDF-SHA512
- Independent encryption for each secret entry

#### Key Management
```
User Password → Argon2id → Master Key → HKDF → [Vault Key | Item Seed]
                                              ↓              ↓
                                        DB Encryption   Per-Item Keys
```

### Supported Secret Types

- **API Keys**: REST APIs, GraphQL, third-party services
- **Tokens**: JWT, OAuth, Bearer tokens, refresh tokens
- **Credentials**: Username/password, database connections
- **SSH Keys**: Private keys, passphrases, connection details
- **Generic Secrets**: Environment variables, config values, notes

### Installation

#### Requirements
- iOS 16.0+ or macOS 13.0+
- Xcode 15.0+
- Swift 5.9+

#### Build from Source

```bash
git clone https://github.com/EthanThePhoenix38/SilentKey.git
cd SilentKey
open SilentKey.xcodeproj
```

1. Select your target (iOS or macOS)
2. Build and run (⌘R)

### Architecture

```
SilentKey/
├── SilentKeyApp/          # Main app entry point
├── Core/                  # Core infrastructure
│   ├── Crypto/           # Encryption modules
│   ├── Models/           # Data models
│   ├── Security/         # Security utilities
│   └── Errors/           # Error handling
├── Features/             # Feature modules
│   ├── Secrets/          # Secret management
│   ├── ApiKeys/          # API key handling
│   ├── Tokens/           # Token management
│   ├── Credentials/      # Credentials
│   ├── SSH/              # SSH key management
│   ├── Backup/           # Export/import
│   ├── Settings/         # App settings
│   └── QuickSearch/      # Global search
├── Infrastructure/       # Infrastructure layer
│   ├── Persistence/      # Local storage
│   ├── Keychain/         # Keychain integration
│   └── Biometrics/       # Face ID / Touch ID
├── UI/                   # Shared UI components
└── Docs/                 # Documentation
    ├── en/               # English docs
    └── fr/               # French docs
```

### Roadmap

- [x] Core encryption engine
- [x] iOS + macOS support
- [x] Biometric authentication
- [ ] iCloud encrypted sync (optional)
- [ ] Browser extension (autofill)
- [ ] CLI tool
- [ ] Team sharing (E2E encrypted)
- [ ] Password generator
- [ ] Import from .env files
- [ ] Export to various formats

### Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Security

Found a vulnerability? Please email security@silentkey.dev or open a private security advisory.

### License

MIT License - see [LICENSE](LICENSE) for details.

---

## Français

### Aperçu

SilentKey est un coffre-fort professionnel local-first conçu spécifiquement pour les développeurs qui doivent gérer en toute sécurité des clés API, tokens, identifiants, clés SSH et données sensibles. Construit avec SwiftUI, il fonctionne nativement sur iOS et macOS sans dépendance cloud, sans télémétrie et en toute transparence.

### Fonctionnalités Principales

- **Chiffrement Double Couche**: AES-256-GCM + XChaCha20-Poly1305 pour une sécurité maximale
- **Architecture Local-First**: Toutes les données restent sur votre appareil, pas de sync cloud requis
- **Multi-Plateforme**: App SwiftUI native pour iOS 16+ et macOS 13+
- **Authentification Biométrique**: Intégration Touch ID / Face ID
- **Orienté Développeurs**: Optimisé pour clés API, tokens, credentials, clés SSH, connexions DB
- **Zéro Télémétrie**: Pas de tracking, pas d'analytics, pas de collecte de données
- **Interface Moderne**: Interface professionnelle et épurée avec support du mode sombre
- **Export/Import**: Fonctionnalité de sauvegarde et restauration chiffrée

### Modèle de Sécurité

#### Couches de Chiffrement

**Couche 1 : Chiffrement au Niveau du Coffre**
- Algorithme : AES-256-GCM
- Dérivation de Clé : Argon2id (600 000 itérations, sel de 16 octets)
- Clé maître jamais stockée, dérivée du mot de passe à chaque déverrouillage

**Couche 2 : Chiffrement au Niveau des Éléments**
- Algorithme : XChaCha20-Poly1305
- Clés par élément dérivées via HKDF-SHA512
- Chiffrement indépendant pour chaque entrée secrète

#### Gestion des Clés
```
Mot de Passe Utilisateur → Argon2id → Clé Maître → HKDF → [Clé Coffre | Graine Éléments]
                                                            ↓                ↓
                                                    Chiffrement DB    Clés par Élément
```

### Types de Secrets Supportés

- **Clés API**: APIs REST, GraphQL, services tiers
- **Tokens**: JWT, OAuth, Bearer tokens, refresh tokens
- **Identifiants**: Username/password, connexions base de données
- **Clés SSH**: Clés privées, passphrases, détails de connexion
- **Secrets Génériques**: Variables d'environnement, valeurs de config, notes

### Installation

#### Prérequis
- iOS 16.0+ ou macOS 13.0+
- Xcode 15.0+
- Swift 5.9+

#### Compiler depuis les Sources

```bash
git clone https://github.com/EthanThePhoenix38/SilentKey.git
cd SilentKey
open SilentKey.xcodeproj
```

1. Sélectionnez votre cible (iOS ou macOS)
2. Compilez et lancez (⌘R)

### Architecture

```
SilentKey/
├── SilentKeyApp/          # Point d'entrée principal
├── Core/                  # Infrastructure de base
│   ├── Crypto/           # Modules de chiffrement
│   ├── Models/           # Modèles de données
│   ├── Security/         # Utilitaires de sécurité
│   └── Errors/           # Gestion des erreurs
├── Features/             # Modules fonctionnels
│   ├── Secrets/          # Gestion des secrets
│   ├── ApiKeys/          # Gestion des clés API
│   ├── Tokens/           # Gestion des tokens
│   ├── Credentials/      # Identifiants
│   ├── SSH/              # Gestion des clés SSH
│   ├── Backup/           # Export/import
│   ├── Settings/         # Paramètres de l'app
│   └── QuickSearch/      # Recherche globale
├── Infrastructure/       # Couche infrastructure
│   ├── Persistence/      # Stockage local
│   ├── Keychain/         # Intégration Keychain
│   └── Biometrics/       # Face ID / Touch ID
├── UI/                   # Composants UI partagés
└── Docs/                 # Documentation
    ├── en/               # Docs anglais
    └── fr/               # Docs français
```

### Feuille de Route

- [x] Moteur de chiffrement principal
- [x] Support iOS + macOS
- [x] Authentification biométrique
- [ ] Sync iCloud chiffré (optionnel)
- [ ] Extension navigateur (autofill)
- [ ] Outil CLI
- [ ] Partage d'équipe (E2E chiffré)
- [ ] Générateur de mots de passe
- [ ] Import depuis fichiers .env
- [ ] Export vers différents formats

### Contribution

Les contributions sont les bienvenues ! Veuillez lire [CONTRIBUTING.md](CONTRIBUTING.md) pour les directives.

### Sécurité

Vous avez trouvé une vulnérabilité ? Veuillez envoyer un email à security@silentkey.dev ou ouvrir un avis de sécurité privé.

### Licence

Licence MIT - voir [LICENSE](LICENSE) pour les détails.

---

**Built with ❤️ for developers who value privacy and security**
