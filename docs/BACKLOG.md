# SilentKey Development Backlog

<!-- INSTRUCTIONS POUR IA - FICHIER: docs/BACKLOG.md
Ce fichier doit etre maintenu a jour par toute IA travaillant sur le projet SilentKey.

REGLES DE MAINTENANCE:
1. TOUJOURS mettre a jour la version et la date en haut du fichier
2. Ajouter les nouvelles taches dans la section appropriee (Critique/Sprint/Backlog)
3. Deplacer les taches completees vers "Taches Terminees"
4. Maintenir la structure actuelle du fichier
5. Verifier que les chemins de fichiers correspondent a la structure reelle
6. Ajouter un commentaire de changement dans l'historique des versions

FORMAT DES VERSIONS:
- Version X.Y.Z (Date JJ/MM/AAAA)
  - Liste des changements

PRIORISATION:
CRITIQUE > Sprint actuel > Prochain sprint > UX > Nice-to-have
-->

---

# SilentKey Development Backlog

**Version:** 1.3.0  
**Date:** 18/01/2026  
**Status:** Developpement actif - Phase d'architecture etendue

## Historique des Versions

### Version 1.3.0 (18/01/2026)
- Ajout gestion projets developpeur avec relations multiples
- Ajout systeme CRUD complet securise et versionne
- Ajout poubelle avec retention 30 jours
- Ajout gestion conflits noms avec incrementation automatique
- Ajout alerting push natif macOS (UserNotifications framework)
- Ajout integration Apple Intelligence (Foundation Models framework)
- Ajout gestion exceptions nommage et versions
- SUPPRESSION de tous les emojis du backlog

### Version 1.2.0 (18/01/2026)
- Ajout gestion documents prives (photos, papiers notariaux, assurances, pieces d'identite)
- Ajout contacts d'urgence internationaux en cas de piratage (par pays)
- Ajout procedures de recovery/backup/export/import
- Ajout detection doublons et mots de passe reutilises
- Ajout integration HaveIBeenPwned API (gratuit) pour verification fuites
- Ajout systeme de paiement App Store (In-App Purchase)
- Ajout exigences code signing et notarisation macOS
- Ajout politique de stockage securise (rien en local non chiffre)
- Comparaison avec top 10 apps securisees (Bitwarden, Vault, 1Password)

### Version 1.1.0 (18/01/2026)
- Ajout section securite des donnees sensibles
- Ajout modeles d'identite (SSN, passeport, permis, carte ID)
- Ajout strategies de stockage local et cloud
- Ajout considerations de securite cloud
- Documentation sur protection contre piratage via cloud

### Version 1.0.0 (18/01/2026)
- Creation initiale du backlog
- Documentation structure existante
- Definition sprints 1, 2, 3
- Liste des taches critiques

---

## Structure Actuelle (Ce qui existe)

### Fichiers Crees

```
Sources/Core/
├── Crypto/
│   └── (fichiers de chiffrement existants)
├── Models/
│   ├── BankingModels.swift - CREE
│   ├── APIKeyModels.swift - CREE
│   └── SecretItem.swift - EXISTE
├── Plugins/
│   └── PluginSystem.swift - CREE
├── Protocols/
│   └── SecretItemProtocol.swift - CREE
└── ErrorHandling.swift - EXISTE

docs/
├── BACKLOG.md - CE FICHIER
└── ARCHITECTURE.md - A CORRIGER (references invalides)
```

---

## CRITIQUE - Taches a Faire Immediatement

### 1. Audit & Corrections Documentation (PRIORITE MAXIMALE)
- [ ] **Verifier TOUS les fichiers markdown** pour references inexistantes
- [ ] Corriger ARCHITECTURE.md - supprimer references a fichiers/dossiers inexistants
- [ ] Creer liste exhaustive de tous les fichiers/dossiers manquants
- [ ] Creer le dossier `Security/` s'il est reference
- [ ] Mapper la structure reelle vs structure documentee

### 2. Fichiers Manquants Core (BLOQUANT)
- [ ] `Sources/Core/Crypto/EncryptionManager.swift` (mentionne mais absent)
- [ ] `Sources/Core/Models/PasswordModels.swift`
- [ ] `Sources/Core/Models/CertificateModels.swift`
- [ ] `Sources/Core/Models/ProjectModels.swift` (NOUVEAU)
- [ ] `Sources/Core/Storage/VaultManager.swift`
- [ ] `Sources/Core/Storage/FileStorage.swift`
- [ ] `Sources/Core/Storage/TrashManager.swift` (NOUVEAU)
- [ ] `Sources/Core/Security/` (dossier complet)
- [ ] `Sources/Core/Notifications/PushNotificationManager.swift` (NOUVEAU)

### 3. Tests Manquants
- [ ] `Tests/SilentKeyTests/ProtocolTests.swift`
- [ ] `Tests/SilentKeyTests/BankingModelsTests.swift`
- [ ] `Tests/SilentKeyTests/APIKeyModelsTests.swift`
- [ ] `Tests/SilentKeyTests/PluginSystemTests.swift`
- [ ] `Tests/SilentKeyTests/EncryptionTests.swift`
- [ ] `Tests/SilentKeyTests/ProjectRelationsTests.swift` (NOUVEAU)
- [ ] `Tests/SilentKeyTests/TrashManagerTests.swift` (NOUVEAU)

---

## Sprint 1 - Fonctionnalites Principales

### A. Gestion Projets Developpeur (NOUVEAU CRITIQUE)
- [ ] **Modele ProjectItem.swift**
  - Nom projet, description, tags
  - Relations multiples vers API keys, secrets, comptes
  - Support relations N-N (un secret peut appartenir a plusieurs projets)
  - Metadonnees: date creation, derniere modif, statut
  - Icone personnalisable
- [ ] **Systeme de relations**
  - Table de jointure pour associations multiples
  - API pour lier/delier elements
  - Vue graphique des dependances
  - Export relations pour backup
- [ ] **CRUD Complete Securisee**
  - Create: creation projets avec validation
  - Read: lecture avec filtres et tri
  - Update: modification versionnee avec historique
  - Delete: soft delete vers poubelle
- [ ] **Gestion exceptions nommage**
  - Validation caracteres autorises
  - Detection noms reserves
  - Longueur min/max
  - Suggestions noms alternatifs

### B. Systeme Poubelle (NOUVEAU CRITIQUE)
- [ ] **TrashManager.swift**
  - Soft delete de tous types d'items
  - Retention automatique 30 jours
  - Nettoyage automatique apres expiration
  - Restauration avec gestion conflits noms
- [ ] **Gestion conflits noms**
  - Detection doublon a la restauration
  - Incrementation automatique (ex: "Projet" -> "Projet (1)")
  - Preview avant restauration
  - Option renommer manuellement
- [ ] **UI Poubelle**
  - Liste items supprimes avec dates
  - Tri par type, date, nom
  - Actions: restaurer, supprimer definitivement
  - Vider poubelle complete
  - Alertes avant suppression definitive

### C. Alerting Push Natif (NOUVEAU)
- [ ] **Integration UserNotifications framework**
  - Import UserNotifications natif macOS
  - Demande permissions utilisateur
  - Configuration categories notifications
- [ ] **Types notifications**
  - Mot de passe compromis (HaveIBeenPwned)
  - Document expirant (passeport, carte ID)
  - Backup recommande
  - Poubelle elements expirant bientot
  - Tentative acces non autorise
- [ ] **Gestion preferences**
  - Toggle notifications dans app
  - Integration Preferences Systeme macOS
  - Configuration par type notification
  - Mode silencieux temporaire
  - Planification notifications (heures actives)

### D. Apple Intelligence Integration (NOUVEAU)
- [ ] **Foundation Models framework**
  - Integration native Swift (3 lignes code)
  - Acces modele on-device
  - Zero data sent to cloud
  - Fonctionne offline
- [ ] **Fonctionnalites IA**
  - Resume automatique notes securisees
  - Suggestions tags pour projets
  - Detection anomalies dans patterns usage
  - Generation mots de passe contextuels
  - Extraction text des documents scannes
  - Privacy-first (calculs locaux uniquement)
- [ ] **Configuration**
  - Toggle Apple Intelligence dans settings
  - Choix features IA a activer/desactiver
  - Fallback gracieux si IA non disponible

### E. Gestion Documents Prives
- [ ] **Modele DocumentItem.swift**
  - Photos chiffrees
  - Documents scannes (PDF, images)
  - Categories: Notarial, Identite, Assurance, Medical, Financier
  - Metadonnees: date d'expiration, pays emetteur
  - Tags personnalises
- [ ] **Stockage securise documents**
  - Chiffrement AES-256 avant stockage
  - Compression optionnelle
  - Limite taille fichier
  - Gestion versions
- [ ] **Import/Export documents**
  - Import depuis Photos, Scanner, Fichiers
  - Export chiffre (format proprietaire)
  - Preview securise dans l'app

### F. Gestion Mots de Passe Avancee
- [ ] **Detection reutilisation**
  - Hash comparaison (SHA-256)
  - Alert si mot de passe deja utilise
  - Suggestion changement
  - Historique des mots de passe par site
- [ ] **Detection doublons**
  - Mapping parfait des entrees
  - Fusion intelligente des doublons
  - Prevention creation doublons
- [ ] **HaveIBeenPwned Integration**
  - API Pwned Passwords (GRATUIT, k-Anonymity)
  - Check automatique a la creation/modification
  - Alert si mot de passe compromis
  - Batch check de tous les mots de passe
  - Privacy: envoi seulement 5 premiers caracteres du SHA-1
- [ ] **Generateur mots de passe**
  - Longueur configurable
  - Complexite parametrable
  - Exclusion caracteres ambigus
  - Passphrase diceware

### G. Recovery & Backup
- [ ] **Systeme de backup chiffre**
  - Export complet vault (format chiffre proprietaire)
  - Backup automatique local
  - Backup manuel sur demande
  - Verification integrite backup
- [ ] **Import/Export universel**
  - Import depuis 1Password, Bitwarden, LastPass, Dashlane
  - Export CSV chiffre
  - Format interchange JSON chiffre
  - Mapping intelligent des champs
- [ ] **Recovery key**
  - Generation cle maitre recovery
  - QR Code de recovery
  - Split key (Shamir Secret Sharing)
  - Stockage securise hors app

### H. Contacts Urgence Internationaux
- [ ] **Base de donnees contacts par pays**
  - Numeros urgence fraude bancaire (par pays + international)
  - Emails support plateformes (Google, Apple, Microsoft, etc.)
  - Contacts autorites cyber (CNIL France, IC3 USA, etc.)
  - Ambassades/consulats
  - Operateurs telecom
- [ ] **Detection pays utilisateur**
  - Geolocalisation optionnelle
  - Selection manuelle pays
  - Liste pays multiples
- [ ] **Actions rapides urgence**
  - Bouton panic "J'ai ete pirate"
  - Checklist actions immediates
  - Acces rapide contacts
  - Log des actions prises

---

## Sprint 2 - Fonctionnalites Principales

### I. Securite & Chiffrement (RENFORCE)
- [ ] **Politique "Zero local storage non chiffre"**
  - JAMAIS de donnees en clair sur disque
  - RAM uniquement pour donnees dechiffrees
  - Effacement RAM apres usage
  - Sandboxing strict macOS
- [ ] **Double-layer encryption**
  - Layer 1: AES-256-GCM (donnees)
  - Layer 2: ChaCha20-Poly1305 (conteneur)
  - Cles derivees via Argon2id
  - Salt unique par entree
- [ ] **Code signing & Notarization**
  - Developer ID Application certificate
  - Notarization obligatoire (macOS 10.15+)
  - Hardened Runtime
  - Secure Timestamp
- [ ] **Audit securite**
  - Conformite OWASP
  - Comparaison avec Bitwarden/1Password
  - Penetration testing
  - Security.txt publication

### J. Stockage & Sync Cloud (SECURISE)
- [ ] **iCloud Keychain integration**
  - Sync optionnel via CloudKit
  - Chiffrement end-to-end
  - Minimal metadata exposure
- [ ] **Custom cloud backend (optionnel)**
  - Chiffrement cote client AVANT upload
  - Zero-knowledge architecture
  - Serveur ne voit que blob chiffre
  - Protection contre piratage cloud
- [ ] **Offline-first**
  - Fonctionnement 100% local par defaut
  - Sync optionnel uniquement
  - Conflit resolution

### K. Monetisation
- [ ] **In-App Purchase (StoreKit)**
  - Produit: SilentKey Pro (non-consommable)
  - Features Pro: sync cloud, documents illimites, support prioritaire
  - Configuration App Store Connect
  - Gestion achats restaures
  - Periode essai gratuite (optionnel)
- [ ] **App Store submission**
  - Conformite App Store Guidelines
  - Privacy Policy
  - EULA
  - Screenshots & descriptions
  - App Store Optimization (ASO)

---

## Sprint 3 - Fonctionnalites Principales

### L. Modeles de Donnees Etendus
- [ ] **IdentityModels.swift** (completer)
  - Passeports (avec scan)
  - Cartes identite
  - Permis de conduire
  - Cartes vitale/secu sociale
  - Documents notariaux
  - Contrats assurance
- [ ] **Validation donnees sensibles**
  - Format numero secu selon pays
  - Validation IBAN/BIC
  - Validation numero passeport
  - Date expiration alertes
- [ ] **Attachments systeme**
  - Photos de documents
  - PDF scannes
  - Fichiers multiples par entree
  - Indexation recherche

### M. UI/UX Excellence
- [ ] Interface SwiftUI moderne
- [ ] Dark mode optimise
- [ ] Animations fluides
- [ ] Drag & drop documents
- [ ] Search performant
- [ ] Quick actions (Cmd+K)
- [ ] Touch Bar support

### N. Plugins & Extensibilite (MODULAIRE)
- [ ] Architecture plugins documentee
- [ ] Templates plugins
  - Template base plugin
  - Template integration service tiers
  - Template transformation donnees
- [ ] API plugins securisee
  - Sandboxing plugins
  - Permissions granulaires
  - Validation signatures
- [ ] Browser extensions (Safari)
- [ ] CLI tool
- [ ] Alfred/Raycast workflow

---

## Backlog Long Terme

### Integrations Tierces
- [ ] Import Bitwarden
- [ ] Import 1Password (OPVault)
- [ ] Import LastPass
- [ ] Import KeePass
- [ ] Import Chrome passwords
- [ ] Import CSV generique

### Fonctionnalites Avancees
- [ ] Authentification biometrique (Touch ID, Face ID)
- [ ] Yubikey support
- [ ] SSH key management
- [ ] Code signing certificates
- [ ] TOTP/2FA generator
- [ ] Secure notes
- [ ] Password sharing (chiffre)
- [ ] Audit trail complet
- [ ] Breach monitoring continu

### DevOps
- [ ] CI/CD GitHub Actions
- [ ] Tests automatises (>80% coverage)
- [ ] Securite: SAST, DAST
- [ ] Documentation complete
- [ ] Contribution guidelines

---

## Comparaison Top 10 Apps Securisees

### Apps a Analyser
1. **Bitwarden** (open source, reference)
2. **1Password** (UX gold standard)
3. **Dashlane** (features riches)
4. **LastPass** (legacy leader)
5. **KeePassXC** (offline, open source)
6. **HashiCorp Vault** (entreprise, infrastructure)
7. **Infisical** (secrets management dev)
8. **NordPass** (password manager)
9. **Keeper** (entreprise, famille)
10. **Enpass** (offline-first)

### Points Cles a Retenir
- **Bitwarden**: Open source, audit public, zero-knowledge, gratuit
- **1Password**: UX exemplaire, travel mode, watchtower
- **KeePassXC**: 100% offline, pas de cloud, portable
- **Vault**: Infrastructure secrets, enterprise-grade
- **SilentKey Differenciateurs**:
  - Documents prives (photos, papiers notariaux)
  - Gestion projets avec relations multiples
  - Contacts urgence internationaux
  - HaveIBeenPwned integre
  - Modulaire avec plugins
  - Compatible banking
  - Zero local storage non chiffre
  - Apple Intelligence integration
  - Push notifications natives
  - Systeme poubelle versionne

---

## Faisabilite Technique Verifiee

### HaveIBeenPwned API
- **Statut**: FAISABLE et GRATUIT
- **API**: Pwned Passwords (k-Anonymity model)
- **Privacy**: Envoi seulement 5 premiers caracteres SHA-1 hash
- **Cout**: GRATUIT (pas de cle API necessaire pour passwords)
- **Implementation**: Simple requete HTTPS
- **Reference**: haveibeenpwned.com/API/v3

### App Store Code Signing
- **Statut**: OBLIGATOIRE et FAISABLE
- **Requis**: Developer ID Application certificate ($99/an)
- **Process**: Code signing + Notarization (macOS 10.15+)
- **Tools**: Xcode, notarytool, Hardened Runtime
- **Reference**: support.apple.com/guide/security/sec3ad8e6e53

### In-App Purchase (StoreKit)
- **Statut**: STANDARD et FAISABLE
- **Framework**: StoreKit (natif Apple)
- **Config**: App Store Connect
- **Types**: Non-consumable (SilentKey Pro)
- **Apple Fees**: 15-30% commission
- **Reference**: developer.apple.com/storekit

### UserNotifications Framework
- **Statut**: NATIF macOS et FAISABLE
- **Framework**: UserNotifications (natif Apple)
- **Permissions**: Demande utilisateur obligatoire
- **Features**: Alerts, badges, sons, actions
- **Integration**: Preferences Systeme macOS
- **Reference**: developer.apple.com/documentation/usernotifications

### Apple Intelligence / Foundation Models
- **Statut**: NOUVEAU (macOS 15+) et FAISABLE
- **Framework**: Foundation Models (natif Swift)
- **Requirements**: Apple Silicon (M1+)
- **Privacy**: 100% on-device, zero cloud
- **Implementation**: 3 lignes de code Swift
- **Capabilities**: Summarization, text extraction, generation
- **Reference**: developer.apple.com/apple-intelligence

---

## Priorites Immediates

### Cette Semaine
1. [FAIT] Backlog complet cree (v1.3.0) SANS EMOJIS
2. [CRITIQUE] **Audit TOUS les fichiers markdown**
3. [CRITIQUE] **Creer fichiers manquants Core**
4. [SPRINT 1] Creer ProjectModels.swift
5. [SPRINT 1] Creer TrashManager.swift

### Semaine Prochaine
1. Implementer systeme relations projets
2. Implementer poubelle avec retention 30j
3. Implementer PushNotificationManager
4. Creer base donnees contacts urgence
5. Tests unitaires core

### Mois 1
1. Architecture complete
2. Tous les modeles de donnees
3. Chiffrement double-layer
4. UI SwiftUI basique
5. Tests >50% coverage
6. Integration Apple Intelligence
7. Push notifications operationnelles

---

## Notes Importantes

### Securite IRREPROCHABLE
- JAMAIS stocker donnees en clair localement
- TOUJOURS chiffrer avant ecriture disque
- Effacer RAM apres usage
- Audit code avant release
- Conformite OWASP Top 10
- Code signing + notarization obligatoires

### Architecture Modulaire
- Plugin system pour extensibilite
- Templates pour nouveaux plugins
- API claire et documentee
- Banking compatible des le depart

### UX Premium
- Inspiration 1Password
- SwiftUI moderne
- Animations fluides
- Dark mode parfait

### Gestion Versions
- Versioning semantique (MAJOR.MINOR.PATCH)
- Historique complet des modifications
- Rollback possible
- Gestion conflits automatique

---

## Support & Contribution

**Maintenance IA**: Ce fichier doit etre mis a jour a chaque changement significatif
**Format**: Markdown SANS EMOJIS pour professionnalisme
**Versioning**: Semantic versioning (MAJOR.MINOR.PATCH)

---

*Derniere mise a jour: 18/01/2026 - Version 1.3.0*
*Maintenu par: IA Assistant pour ThePhoenixAgency*
*AUCUN EMOJI - Format professionnel*
