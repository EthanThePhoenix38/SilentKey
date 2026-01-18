# SilentKey Development Roadmap

**Version:** 2.0.0  
**Last Updated:** January 18, 2026  
**Status:** Active Development - Extended Architecture Phase

[🇫🇷 Version Française](../fr/ROADMAP.md)

---

## Table of Contents

- [Project Status](#project-status)
- [Sprint 1 - Core Features](#sprint-1---core-features)
- [Sprint 2 - Security & Storage](#sprint-2---security--storage)
- [Sprint 3 - Extended Features](#sprint-3---extended-features)
- [Backlog - Future Features](#backlog---future-features)
- [Technical Validation](#technical-validation)

---

## Project Status

### Current Phase
Extended architecture with focus on:
- Developer project management with multiple relations
- Complete CRUD system with versioning
- Smart trash with 30-day retention
- Native push notifications (macOS)
- Apple Intelligence integration (on-device)

### Completed
- ✅ Core encryption (AES-256-GCM + ChaCha20-Poly1305)
- ✅ Basic data models (API Keys, Banking, SSH)
- ✅ Plugin system architecture
- ✅ Protocol-based extensibility
- ✅ Force unwrapping security fixes
- ✅ Core module dependencies (Logger, EncryptionManager)

---

## Sprint 1 - Core Features

### A. Developer Project Management
**Priority: CRITICAL**

- [ ] **ProjectItem Model**
  - Project name, description, tags
  - Multiple relations to API keys, secrets, accounts
  - N-N relationship support (one secret in multiple projects)
  - Metadata: creation date, last modified, status
  - Customizable icon

- [ ] **Relationship System**
  - Join table for multiple associations
  - API for linking/unlinking elements
  - Graphical dependency view
  - Export relationships for backup

- [ ] **Complete Secure CRUD**
  - Create: project creation with validation
  - Read: with filters and sorting
  - Update: versioned with history
  - Delete: soft delete to trash

- [ ] **Naming Exception Management**
  - Validation of allowed characters
  - Reserved name detection
  - Min/max length
  - Alternative name suggestions

### B. Smart Trash System
**Priority: CRITICAL**

- [ ] **TrashManager Implementation**
  - Soft delete for all item types
  - Automatic 30-day retention
  - Auto cleanup after expiration
  - Restore with name conflict management

- [ ] **Name Conflict Resolution**
  - Duplicate detection on restore
  - Auto increment (e.g., "Project" → "Project (1)")
  - Preview before restore
  - Manual rename option

- [ ] **Trash UI**
  - List deleted items with dates
  - Sort by type, date, name
  - Actions: restore, permanently delete
  - Empty trash completely
  - Alerts before permanent deletion

### C. Native Push Notifications
**Priority: HIGH**

- [ ] **UserNotifications Framework Integration**
  - Native macOS UserNotifications import
  - User permission request
  - Notification categories configuration

- [ ] **Notification Types**
  - Compromised password (HaveIBeenPwned)
  - Expiring document (passport, ID card)
  - Recommended backup
  - Trash items expiring soon
  - Unauthorized access attempt

- [ ] **Preferences Management**
  - Toggle notifications in app
  - macOS System Preferences integration
  - Configuration per notification type
  - Temporary silent mode
  - Notification scheduling (active hours)

### D. Apple Intelligence Integration
**Priority: HIGH**

- [ ] **Foundation Models Framework**
  - Native Swift integration (3 lines of code)
  - On-device model access
  - Zero data sent to cloud
  - Works offline

- [ ] **AI Features**
  - Auto summarize secure notes
  - Tag suggestions for projects
  - Anomaly detection in usage patterns
  - Contextual password generation
  - Text extraction from scanned documents
  - Privacy-first (local computations only)

- [ ] **Configuration**
  - Toggle Apple Intelligence in settings
  - Choose which AI features to enable/disable
  - Graceful fallback if AI unavailable

---

## Sprint 2 - Security & Storage

### E. Advanced Password Management
**Priority: HIGH**

- [ ] **Password Reuse Detection**
  - Hash comparison (SHA-256)
  - Alert if password already used
  - Suggest change
  - Password history per site

- [ ] **Duplicate Detection**
  - Perfect entry mapping
  - Intelligent duplicate merging
  - Prevent duplicate creation

- [ ] **HaveIBeenPwned Integration**
  - Pwned Passwords API (FREE, k-Anonymity)
  - Auto check on creation/modification
  - Alert if password compromised
  - Batch check all passwords
  - Privacy: send only first 5 chars of SHA-1

- [ ] **Password Generator**
  - Configurable length
  - Adjustable complexity
  - Exclude ambiguous characters
  - Diceware passphrase

### F. Recovery & Backup
**Priority: HIGH**

- [ ] **Encrypted Backup System**
  - Complete vault export (proprietary encrypted format)
  - Automatic local backup
  - Manual backup on demand
  - Backup integrity verification

- [ ] **Universal Import/Export**
  - Import from 1Password, Bitwarden, LastPass, Dashlane
  - Encrypted CSV export
  - Encrypted JSON interchange format
  - Intelligent field mapping

- [ ] **Recovery Key**
  - Master recovery key generation
  - Recovery QR Code
  - Split key (Shamir Secret Sharing)
  - Secure storage outside app

### G. Security Hardening
**Priority: CRITICAL**

- [ ] **Zero Local Storage Policy**
  - NEVER store data in plaintext on disk
  - RAM only for decrypted data
  - RAM cleanup after use
  - Strict macOS sandboxing

- [ ] **Double-Layer Encryption**
  - Layer 1: AES-256-GCM (data)
  - Layer 2: ChaCha20-Poly1305 (container)
  - Argon2id key derivation
  - Unique salt per entry

- [ ] **Code Signing & Notarization**
  - Developer ID Application certificate
  - Mandatory notarization (macOS 10.15+)
  - Hardened Runtime
  - Secure Timestamp

- [ ] **Security Audit**
  - OWASP compliance
  - Comparison with Bitwarden/1Password
  - Penetration testing
  - Security.txt publication

---

## Sprint 3 - Extended Features

### H. Private Document Management
**Priority: MEDIUM**

- [ ] **DocumentItem Model**
  - Encrypted photos
  - Scanned documents (PDF, images)
  - Categories: Notarial, Identity, Insurance, Medical, Financial
  - Metadata: expiration date, issuing country
  - Custom tags

- [ ] **Secure Document Storage**
  - AES-256 encryption before storage
  - Optional compression
  - File size limit
  - Version management

- [ ] **Document Import/Export**
  - Import from Photos, Scanner, Files
  - Encrypted export (proprietary format)
  - Secure preview in app

### I. International Emergency Contacts
**Priority: MEDIUM**

- [ ] **Contact Database by Country**
  - Bank fraud emergency numbers (by country + international)
  - Platform support emails (Google, Apple, Microsoft, etc.)
  - Cyber authorities (CNIL France, IC3 USA, etc.)
  - Embassies/consulates
  - Telecom operators

- [ ] **User Country Detection**
  - Optional geolocation
  - Manual country selection
  - Multiple country list

- [ ] **Quick Emergency Actions**
  - Panic button "I've been hacked"
  - Immediate action checklist
  - Quick access to contacts
  - Log of actions taken

### J. Monetization
**Priority: MEDIUM**

- [ ] **In-App Purchase (StoreKit)**
  - Product: SilentKey Pro (non-consumable)
  - Pro features: cloud sync, unlimited documents, priority support
  - App Store Connect configuration
  - Restore purchases management
  - Optional free trial period

- [ ] **App Store Submission**
  - App Store Guidelines compliance
  - Privacy Policy
  - EULA
  - Screenshots & descriptions
  - App Store Optimization (ASO)

---

## Backlog - Future Features

### Third-Party Integrations
- [ ] Import from Bitwarden
- [ ] Import from 1Password (OPVault)
- [ ] Import from LastPass
- [ ] Import from KeePass
- [ ] Import from Chrome passwords
- [ ] Generic CSV import

### Advanced Features
- [ ] Biometric authentication (Touch ID, Face ID)
- [ ] Yubikey support
- [ ] SSH key management
- [ ] Code signing certificates
- [ ] TOTP/2FA generator
- [ ] Secure notes
- [ ] Encrypted password sharing
- [ ] Complete audit trail
- [ ] Continuous breach monitoring

### DevOps
- [ ] CI/CD GitHub Actions
- [ ] Automated tests (>80% coverage)
- [ ] Security: SAST, DAST
- [ ] Complete documentation
- [ ] Contribution guidelines

---

## Technical Validation

### HaveIBeenPwned API
- **Status**: FEASIBLE and FREE
- **API**: Pwned Passwords (k-Anonymity model)
- **Privacy**: Send only first 5 chars of SHA-1 hash
- **Cost**: FREE (no API key needed for passwords)
- **Implementation**: Simple HTTPS request
- **Reference**: haveibeenpwned.com/API/v3

### App Store Code Signing
- **Status**: MANDATORY and FEASIBLE
- **Required**: Developer ID Application certificate ($99/year)
- **Process**: Code signing + Notarization (macOS 10.15+)
- **Tools**: Xcode, notarytool, Hardened Runtime
- **Reference**: support.apple.com/guide/security/sec3ad8e6e53

### In-App Purchase (StoreKit)
- **Status**: STANDARD and FEASIBLE
- **Framework**: StoreKit (native Apple)
- **Configuration**: App Store Connect
- **Types**: Non-consumable (SilentKey Pro)
- **Apple Fees**: 15-30% commission
- **Reference**: developer.apple.com/storekit

### UserNotifications Framework
- **Status**: NATIVE macOS and FEASIBLE
- **Framework**: UserNotifications (native Apple)
- **Permissions**: User request mandatory
- **Features**: Alerts, badges, sounds, actions
- **Integration**: macOS System Preferences
- **Reference**: developer.apple.com/documentation/usernotifications

### Apple Intelligence / Foundation Models
- **Status**: NEW (macOS 15+) and FEASIBLE
- **Framework**: Foundation Models (native Swift)
- **Requirements**: Apple Silicon (M1+)
- **Privacy**: 100% on-device, zero cloud
- **Implementation**: 3 lines of Swift code
- **Capabilities**: Summarization, text extraction, generation
- **Reference**: developer.apple.com/apple-intelligence

---

## Version History

### Version 2.0.0 (January 18, 2026)
- Complete roadmap restructuring
- Separation into clear sprints
- Technical validation section added
- English/French separation
- Professional formatting
- Removed all emojis for professionalism

### Version 1.3.0 (January 18, 2026)
- Added developer project management
- Added complete secure CRUD
- Added trash with 30-day retention
- Added push notifications
- Added Apple Intelligence integration

---

<div align="center">

**Maintained by: AI Assistant for ThePhoenixAgency**  
**Format: Professional Markdown**

[🇫🇷 Version Française](../fr/ROADMAP.md) | [📚 Documentation](README.md) | [🐛 Report Issue](https://github.com/ThePhoenixAgency/SilentKey/issues)

</div>
