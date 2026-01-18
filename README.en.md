# SilentKey

<div align="center">

**Local-first developer secrets vault with double-layer encryption**

[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey.svg)](https://github.com/ThePhoenixAgency/SilentKey)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[🇫🇷 Version française](README.fr.md) | [📚 Documentation](docs/en/) | [🐛 Report Issue](https://github.com/ThePhoenixAgency/SilentKey/issues)

</div>

---

## Overview

SilentKey is a professional, local-first secrets vault designed specifically for developers who need to securely manage API keys, tokens, credentials, SSH keys, and sensitive data. Built with SwiftUI, it runs natively on both iOS and macOS with no cloud dependency, no telemetry, and complete transparency.

## Key Features

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

## Security Model

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

## Supported Secret Types

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

## Build from Source

```bash
git clone https://github.com/ThePhoenixAgency/SilentKey.git
cd SilentKey
swift build
```

Or open in Xcode:
```bash
open Package.swift
```

## Architecture

```
SilentKey/
├── Sources/
│   ├── SilentKeyApp/       # Main app entry
│   ├── Core/               # Core infrastructure
│   │   ├── Crypto/         # Encryption modules
│   │   ├── Models/         # Data models
│   │   ├── Protocols/      # Protocol definitions
│   │   ├── Plugins/        # Plugin system
│   │   └── Storage/        # Storage layer
│   └── Features/           # Feature modules
├── Tests/                  # Test suite
└── docs/                   # Documentation
    ├── en/                 # English documentation
    └── fr/                 # French documentation
```

## Documentation

- [Architecture Guide](docs/en/ARCHITECTURE.md)
- [Development Roadmap](docs/en/ROADMAP.md)
- [Templates & Plugins](docs/en/TEMPLATES.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Security Policy](SECURITY.md)

## Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/ThePhoenixAgency/SilentKey.git
   cd SilentKey
   ```

2. **Build the project**
   ```bash
   swift build
   ```

3. **Run tests**
   ```bash
   swift test
   ```

4. **Open in Xcode** (optional)
   ```bash
   open Package.swift
   ```

## Requirements

- macOS 13.0+ or iOS 16.0+
- Swift 5.9+
- Xcode 15.0+ (for development)

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on:
- Code style and conventions
- Development workflow
- Pull request process
- Security considerations

## Security

For security vulnerabilities, please:
- **DO NOT** open a public issue
- Use GitHub's private security advisory feature
- Or email: security@phoenixproject.dev

See [SECURITY.md](SECURITY.md) for more details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support requests:
- [GitHub Issues](https://github.com/ThePhoenixAgency/SilentKey/issues) - Bug reports and feature requests
- [GitHub Discussions](https://github.com/ThePhoenixAgency/SilentKey/discussions) - Questions and community support

## Acknowledgments

Built with:
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - Native Apple UI framework
- [CryptoKit](https://developer.apple.com/documentation/cryptokit) - Apple's cryptography framework
- [Swift Package Manager](https://swift.org/package-manager/) - Dependency management

---

<div align="center">

**Developed by [PhoenixProject](https://github.com/ThePhoenixAgency)**

[Website](https://ThePhoenixAgency.github.io) • [GitHub](https://github.com/ThePhoenixAgency) • [Issues](https://github.com/ThePhoenixAgency/SilentKey/issues)

</div>
