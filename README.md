# SilentKey

<div align="center">

**Local-first developer secrets vault with double-layer encryption**  
**Coffre-fort local pour secrets de développeurs avec double encryption**

[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey.svg)](https://github.com/ThePhoenixAgency/SilentKey)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 🌍 Choose Your Language / Choisissez votre langue

<table>
  <tr>
    <td align="center" width="50%">
      <a href="README.en.md">
        <img src="https://raw.githubusercontent.com/lipis/flag-icons/main/flags/4x3/gb.svg" width="60" height="45" alt="English">
        <br><br>
        <strong>🇬🇧 English Documentation</strong>
      </a>
      <br><br>
      <p>Complete documentation in English</p>
    </td>
    <td align="center" width="50%">
      <a href="README.fr.md">
        <img src="https://raw.githubusercontent.com/lipis/flag-icons/main/flags/4x3/fr.svg" width="60" height="45" alt="Français">
        <br><br>
        <strong>🇫🇷 Documentation Française</strong>
      </a>
      <br><br>
      <p>Documentation complète en français</p>
    </td>
  </tr>
</table>

---

## Quick Links / Liens Rapides

- 📚 [English Documentation](README.en.md) | [Documentation Française](README.fr.md)
- 🏗️ [Architecture Guide](docs/en/ARCHITECTURE.md) | [Guide d'Architecture](docs/fr/ARCHITECTURE.md)
- 🗺️ [Development Roadmap](docs/en/ROADMAP.md) | [Feuille de Route](docs/fr/ROADMAP.md)
- 🔌 [Templates & Plugins](docs/en/TEMPLATES.md)
- 🤝 [Contributing Guidelines](CONTRIBUTING.md)
- 🔒 [Security Policy](SECURITY.md)
- 🐛 [Report Issue](https://github.com/ThePhoenixAgency/SilentKey/issues)
- 💬 [Discussions](https://github.com/ThePhoenixAgency/SilentKey/discussions)

---

<div align="center">

**Developed by [PhoenixProject](https://github.com/ThePhoenixAgency)**

[Website](https://ThePhoenixAgency.github.io) • [GitHub](https://github.com/ThePhoenixAgency)

© 2025 PhoenixProject • MIT License

</div>

</div>

### Overview

SilentKey is a professional, local-first secrets vault designed specifically for developers who need to securely manage API keys, tokens, credentials, SSH keys, and sensitive data. Built with SwiftUI, it runs natively on both iOS and macOS with no cloud dependency, no telemetry, and complete transparency.

### Key Features

- **Double-Layer Encryption**: AES-256-GCM + ChaCha20-Poly1305 for maximum security
- **Local-First Architecture**: All data stays on your device, no cloud sync required
- **Cross-Platform**: Native SwiftUI app for iOS 16+ and macOS 13+
- **Biometric Authentication**: Touch ID / Face ID integration
- **Developer-Focused**: Optimized for API keys, tokens, credentials, SSH keys, database connections
- **Zero Telemetry**: No tracking, no analytics, no data collection
- **Modern UI**: Professional, clean interface with dark mode support
- **Export/Import**: Encrypted backup and restore functionality
- **Project Management**: Link secrets to projects with multiple relations
- **Smart Trash**: 30-day retention with automatic conflict resolution
- **Push Notifications**: Native macOS alerts for security events
- **Apple Intelligence**: On-device AI for smart suggestions (macOS 15+)
- **HaveIBeenPwned**: Automatic password breach detection

### Security Model

**Encryption Layers:**
1. **Layer 1 - Field Level**: AES-256-GCM for individual secret fields
2. **Layer 2 - Container**: ChaCha20-Poly1305 for the entire vault
3. **Key Derivation**: Argon2id for master key generation

**Security Principles:**
- Zero plaintext storage on disk
- RAM-only decryption with automatic cleanup
- Sandboxed macOS environment
- Code signing and notarization (macOS 10.15+)
- OWASP compliance

### Supported Secret Types

- API Keys (REST, GraphQL, OAuth, JWT, Bearer)
- SSH Keys (RSA, ED25519, ECDSA, DSA)
- Database Credentials (PostgreSQL, MySQL, MongoDB, Redis)
- Cloud Provider Credentials (AWS, Azure, GCP, DigitalOcean)
- Banking Information (encrypted account details)
- Credit Cards (encrypted)
- Secure Notes
- Certificates (SSL/TLS)
- License Keys
- Custom Types (extensible via plugins)

### Build from Source

```bash
git clone https://github.com/ThePhoenixAgency/SilentKey.git
cd SilentKey
open SilentKey.xcodeproj
```

1. Select your target (iOS or macOS)
2. Build and run (Cmd+R)

### Architecture

```
SilentKey/
├── SilentKeyApp/          # Main app entry
├── Core/                  # Core infrastructure
│   ├── Crypto/            # Encryption modules
│   ├── Models/            # Data models
│   ├── Security/          # Security utilities
│   └── Errors/            # Error handling
├── Features/              # Feature modules
│   ├── Secrets/           # Secret management
│   ├── ApiKeys/           # API key handling
│   ├── Tokens/            # Token management
│   ├── Credentials/       # Credentials
│   ├── SSH/               # SSH key manager
│   ├── Backup/            # Export/import
│   ├── Settings/          # App settings
│   └── QuickSearch/       # Global search
├── Infrastructure/        # Infrastructure
│   ├── Persistence/       # Local storage
│   ├── Keychain/          # Keychain integration
│   └── Biometrics/        # Face ID / Touch ID
├── UI/                    # Shared UI components
└── Docs/                  # Documentation
    ├── en/                # English docs
    └── fr/                # French docs
```

### Documentation

- [Architecture Guide](docs/ARCHITECTURE.md)
- [Templates & Plugins](docs/TEMPLATES.md)
- [Development Roadmap](docs/BACKLOG.md)

### Features

- Secure vault for all developer secrets
- Field-level encryption
- Import/Export encrypted backups
- Biometric unlock (Touch ID / Face ID)
- Auto-fill support (macOS)
- Quick search (Cmd+K)
- Dark mode
- Multiple vaults
- Team sharing (E2E encrypted)
- Password generator
- Import from .env files
- Export to various formats

### Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Security

For security vulnerabilities, please open a private security advisory on GitHub or submit an issue.

### License

Commercial License - see [LICENSE](LICENSE) for details.

### Support

For support requests:
- Submit an issue on GitHub: https://github.com/ThePhoenixAgency/SilentKey/issues
- Use the in-app support form (coming soon)

---

