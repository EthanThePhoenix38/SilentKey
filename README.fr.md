# SilentKey

<div align="center">

**Coffre-fort local pour secrets de développeurs avec double encryption**

[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey.svg)](https://github.com/ThePhoenixAgency/SilentKey)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[🇬🇧 English version](README.en.md) | [📚 Documentation](docs/fr/) | [🐛 Signaler un bug](https://github.com/ThePhoenixAgency/SilentKey/issues)

</div>

---

## Présentation

SilentKey est un coffre-fort professionnel local conçu spécifiquement pour les développeurs qui ont besoin de gérer de manière sécurisée leurs clés API, tokens, identifiants, clés SSH et données sensibles. Construit avec SwiftUI, il fonctionne nativement sur iOS et macOS sans dépendance cloud, sans télémétrie et en toute transparence.

## Fonctionnalités Principales

- **Double Encryption**: AES-256-GCM + ChaCha20-Poly1305 pour une sécurité maximale
- **Architecture Local-First**: Toutes les données restent sur votre appareil, aucune synchronisation cloud requise
- **Multi-plateforme**: Application SwiftUI native pour iOS 16+ et macOS 13+
- **Authentification Biométrique**: Intégration Touch ID / Face ID
- **Optimisé Développeurs**: Conçu pour les clés API, tokens, identifiants, clés SSH, connexions base de données
- **Zéro Télémétrie**: Pas de tracking, pas d'analytics, pas de collecte de données
- **Interface Moderne**: Interface professionnelle et épurée avec support du mode sombre
- **Export/Import**: Fonctionnalité de sauvegarde et restauration chiffrée
- **Gestion de Projets**: Liez vos secrets à des projets avec relations multiples
- **Corbeille Intelligente**: Rétention de 30 jours avec résolution automatique des conflits
- **Notifications Push**: Alertes natives macOS pour les événements de sécurité
- **Apple Intelligence**: IA locale pour suggestions intelligentes (macOS 15+)
- **HaveIBeenPwned**: Détection automatique des mots de passe compromis

## Modèle de Sécurité

**Couches de Chiffrement:**
1. **Couche 1 - Niveau Champ**: AES-256-GCM pour les champs individuels
2. **Couche 2 - Conteneur**: ChaCha20-Poly1305 pour l'ensemble du coffre
3. **Dérivation de Clé**: Argon2id pour la génération de clé maître

**Principes de Sécurité:**
- Aucun stockage en clair sur disque
- Déchiffrement en RAM uniquement avec nettoyage automatique
- Environnement macOS sandboxé
- Signature de code et notarisation (macOS 10.15+)
- Conformité OWASP

## Types de Secrets Supportés

- Clés API (REST, GraphQL, OAuth, JWT, Bearer)
- Clés SSH (RSA, ED25519, ECDSA, DSA)
- Identifiants Base de Données (PostgreSQL, MySQL, MongoDB, Redis)
- Identifiants Cloud (AWS, Azure, GCP, DigitalOcean)
- Informations Bancaires (détails de compte chiffrés)
- Cartes de Crédit (chiffrées)
- Notes Sécurisées
- Certificats (SSL/TLS)
- Clés de Licence
- Types Personnalisés (extensible via plugins)

## Compiler depuis les Sources

```bash
git clone https://github.com/ThePhoenixAgency/SilentKey.git
cd SilentKey
swift build
```

Ou ouvrir dans Xcode:
```bash
open Package.swift
```

## Architecture

```
SilentKey/
├── Sources/
│   ├── SilentKeyApp/       # Point d'entrée de l'app
│   ├── Core/               # Infrastructure de base
│   │   ├── Crypto/         # Modules de chiffrement
│   │   ├── Models/         # Modèles de données
│   │   ├── Protocols/      # Définitions de protocoles
│   │   ├── Plugins/        # Système de plugins
│   │   └── Storage/        # Couche de stockage
│   └── Features/           # Modules de fonctionnalités
├── Tests/                  # Suite de tests
└── docs/                   # Documentation
    ├── en/                 # Documentation anglaise
    └── fr/                 # Documentation française
```

## Documentation

- [Guide d'Architecture](docs/ARCHITECTURE.md)
- [Feuille de Route](docs/fr/ROADMAP.md)
- [Templates & Plugins](docs/TEMPLATES.md)
- [Guide de Contribution](CONTRIBUTING.md)
- [Politique de Sécurité](SECURITY.md)

## Démarrage Rapide

1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/ThePhoenixAgency/SilentKey.git
   cd SilentKey
   ```

2. **Compiler le projet**
   ```bash
   swift build
   ```

3. **Lancer les tests**
   ```bash
   swift test
   ```

4. **Ouvrir dans Xcode** (optionnel)
   ```bash
   open Package.swift
   ```

## Prérequis

- macOS 13.0+ ou iOS 16.0+
- Swift 5.9+
- Xcode 15.0+ (pour le développement)

## Contribuer

Les contributions sont les bienvenues ! Veuillez lire notre [Guide de Contribution](CONTRIBUTING.md) pour les détails sur :
- Style de code et conventions
- Workflow de développement
- Processus de pull request
- Considérations de sécurité

## Sécurité

Pour signaler une vulnérabilité de sécurité :
- **NE PAS** ouvrir une issue publique
- Utilisez la fonctionnalité GitHub d'advisory de sécurité privée
- Ou email: security@phoenixproject.dev

Voir [SECURITY.md](SECURITY.md) pour plus de détails.

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## Support

Pour les demandes de support :
- [GitHub Issues](https://github.com/ThePhoenixAgency/SilentKey/issues) - Rapports de bugs et demandes de fonctionnalités
- [GitHub Discussions](https://github.com/ThePhoenixAgency/SilentKey/discussions) - Questions et support communautaire

## Remerciements

Construit avec :
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - Framework UI natif Apple
- [CryptoKit](https://developer.apple.com/documentation/cryptokit) - Framework de cryptographie Apple
- [Swift Package Manager](https://swift.org/package-manager/) - Gestion des dépendances

---

<div align="center">

**Développé par [PhoenixProject](https://github.com/ThePhoenixAgency)**

[Site Web](https://ThePhoenixAgency.github.io) • [GitHub](https://github.com/ThePhoenixAgency) • [Issues](https://github.com/ThePhoenixAgency/SilentKey/issues)

</div>
