# Feuille de Route SilentKey

**Version:** 2.0.0  
**Dernière mise à jour:** 18 janvier 2026  
**Statut:** Développement Actif - Phase d'Architecture Étendue

[🇬🇧 English Version](../en/ROADMAP.md)

---

## Table des Matières

- [État du Projet](#état-du-projet)
- [Sprint 1 - Fonctionnalités de Base](#sprint-1---fonctionnalités-de-base)
- [Sprint 2 - Sécurité et Stockage](#sprint-2---sécurité-et-stockage)
- [Sprint 3 - Fonctionnalités Étendues](#sprint-3---fonctionnalités-étendues)
- [Backlog - Fonctionnalités Futures](#backlog---fonctionnalités-futures)
- [Validation Technique](#validation-technique)

---

## État du Projet

### Phase Actuelle
Architecture étendue avec focus sur:
- Gestion de projets développeur avec relations multiples
- Système CRUD complet avec versioning
- Corbeille intelligente avec rétention de 30 jours
- Notifications push natives (macOS)
- Intégration Apple Intelligence (on-device)

### Complété
- ✅ Chiffrement de base (AES-256-GCM + ChaCha20-Poly1305)
- ✅ Modèles de données de base (Clés API, Banking, SSH)
- ✅ Architecture système de plugins
- ✅ Extensibilité basée sur les protocoles
- ✅ Corrections de sécurité force unwrapping
- ✅ Dépendances module Core (Logger, EncryptionManager)

---

## Sprint 1 - Fonctionnalités de Base

### A. Gestion de Projets Développeur
**Priorité: CRITIQUE**

- [ ] **Modèle ProjectItem**
  - Nom du projet, description, tags
  - Relations multiples vers clés API, secrets, comptes
  - Support relations N-N (un secret dans plusieurs projets)
  - Métadonnées: date création, dernière modification, statut
  - Icône personnalisable

- [ ] **Système de Relations**
  - Table de jointure pour associations multiples
  - API pour lier/délier des éléments
  - Vue graphique des dépendances
  - Export des relations pour backup

- [ ] **CRUD Complet Sécurisé**
  - Create: création de projet avec validation
  - Read: avec filtres et tri
  - Update: versionné avec historique
  - Delete: soft delete vers corbeille

- [ ] **Gestion des Exceptions de Nommage**
  - Validation des caractères autorisés
  - Détection des noms réservés
  - Longueur min/max
  - Suggestions de noms alternatifs

### B. Système de Corbeille Intelligente
**Priorité: CRITIQUE**

- [ ] **Implémentation TrashManager**
  - Soft delete pour tous les types d'items
  - Rétention automatique de 30 jours
  - Nettoyage auto après expiration
  - Restauration avec gestion des conflits de noms

- [ ] **Résolution des Conflits de Noms**
  - Détection de doublon à la restauration
  - Incrémentation auto (ex: "Projet" → "Projet (1)")
  - Aperçu avant restauration
  - Option de renommer manuellement

- [ ] **Interface Corbeille**
  - Liste des items supprimés avec dates
  - Tri par type, date, nom
  - Actions: restaurer, supprimer définitivement
  - Vider la corbeille complètement
  - Alertes avant suppression définitive

### C. Notifications Push Natives
**Priorité: HAUTE**

- [ ] **Intégration Framework UserNotifications**
  - Import natif macOS UserNotifications
  - Demande de permissions utilisateur
  - Configuration des catégories de notifications

- [ ] **Types de Notifications**
  - Mot de passe compromis (HaveIBeenPwned)
  - Document expirant (passeport, carte d'identité)
  - Backup recommandé
  - Items de corbeille expirant bientôt
  - Tentative d'accès non autorisé

- [ ] **Gestion des Préférences**
  - Toggle notifications dans l'app
  - Intégration Préférences Système macOS
  - Configuration par type de notification
  - Mode silencieux temporaire
  - Planification des notifications (heures actives)

### D. Intégration Apple Intelligence
**Priorité: HAUTE**

- [ ] **Framework Foundation Models**
  - Intégration native Swift (3 lignes de code)
  - Accès au modèle on-device
  - Zéro donnée envoyée au cloud
  - Fonctionne hors ligne

- [ ] **Fonctionnalités IA**
  - Résumé auto des notes sécurisées
  - Suggestions de tags pour projets
  - Détection d'anomalies dans les patterns d'usage
  - Génération de mots de passe contextuels
  - Extraction de texte des documents scannés
  - Privacy-first (calculs locaux uniquement)

- [ ] **Configuration**
  - Toggle Apple Intelligence dans paramètres
  - Choix des features IA à activer/désactiver
  - Fallback gracieux si IA non disponible

---

## Sprint 2 - Sécurité et Stockage

### E. Gestion Avancée des Mots de Passe
**Priorité: HAUTE**

- [ ] **Détection de Réutilisation**
  - Comparaison de hash (SHA-256)
  - Alerte si mot de passe déjà utilisé
  - Suggestion de changement
  - Historique des mots de passe par site

- [ ] **Détection de Doublons**
  - Mapping parfait des entrées
  - Fusion intelligente des doublons
  - Prévention de création de doublons

- [ ] **Intégration HaveIBeenPwned**
  - API Pwned Passwords (GRATUIT, k-Anonymity)
  - Check auto à la création/modification
  - Alerte si mot de passe compromis
  - Check batch de tous les mots de passe
  - Privacy: envoi seulement 5 premiers caractères SHA-1

- [ ] **Générateur de Mots de Passe**
  - Longueur configurable
  - Complexité ajustable
  - Exclusion des caractères ambigus
  - Passphrase Diceware

### F. Recovery et Backup
**Priorité: HAUTE**

- [ ] **Système de Backup Chiffré**
  - Export complet du vault (format chiffré propriétaire)
  - Backup automatique local
  - Backup manuel sur demande
  - Vérification d'intégrité du backup

- [ ] **Import/Export Universel**
  - Import depuis 1Password, Bitwarden, LastPass, Dashlane
  - Export CSV chiffré
  - Format d'échange JSON chiffré
  - Mapping intelligent des champs

- [ ] **Clé de Recovery**
  - Génération de clé maître de recovery
  - QR Code de recovery
  - Split key (Shamir Secret Sharing)
  - Stockage sécurisé hors app

### G. Renforcement de la Sécurité
**Priorité: CRITIQUE**

- [ ] **Politique Zero Local Storage**
  - JAMAIS stocker de données en clair sur disque
  - RAM uniquement pour données déchiffrées
  - Nettoyage RAM après usage
  - Sandboxing strict macOS

- [ ] **Double Encryption**
  - Layer 1: AES-256-GCM (données)
  - Layer 2: ChaCha20-Poly1305 (conteneur)
  - Dérivation de clé Argon2id
  - Salt unique par entrée

- [ ] **Code Signing et Notarisation**
  - Certificat Developer ID Application
  - Notarisation obligatoire (macOS 10.15+)
  - Hardened Runtime
  - Secure Timestamp

- [ ] **Audit de Sécurité**
  - Conformité OWASP
  - Comparaison avec Bitwarden/1Password
  - Penetration testing
  - Publication Security.txt

---

## Sprint 3 - Fonctionnalités Étendues

### H. Gestion de Documents Privés
**Priorité: MOYENNE**

- [ ] **Modèle DocumentItem**
  - Photos chiffrées
  - Documents scannés (PDF, images)
  - Catégories: Notarial, Identité, Assurance, Médical, Financier
  - Métadonnées: date d'expiration, pays émetteur
  - Tags personnalisés

- [ ] **Stockage Sécurisé de Documents**
  - Chiffrement AES-256 avant stockage
  - Compression optionnelle
  - Limite de taille de fichier
  - Gestion de versions

- [ ] **Import/Export de Documents**
  - Import depuis Photos, Scanner, Fichiers
  - Export chiffré (format propriétaire)
  - Aperçu sécurisé dans l'app

### I. Contacts d'Urgence Internationaux
**Priorité: MOYENNE**

- [ ] **Base de Données de Contacts par Pays**
  - Numéros d'urgence fraude bancaire (par pays + international)
  - Emails support plateformes (Google, Apple, Microsoft, etc.)
  - Autorités cyber (CNIL France, IC3 USA, etc.)
  - Ambassades/consulats
  - Opérateurs télécom

- [ ] **Détection du Pays Utilisateur**
  - Géolocalisation optionnelle
  - Sélection manuelle du pays
  - Liste de plusieurs pays

- [ ] **Actions Rapides d'Urgence**
  - Bouton panique "J'ai été piraté"
  - Checklist d'actions immédiates
  - Accès rapide aux contacts
  - Log des actions prises

### J. Monétisation
**Priorité: MOYENNE**

- [ ] **In-App Purchase (StoreKit)**
  - Produit: SilentKey Pro (non-consommable)
  - Features Pro: sync cloud, documents illimités, support prioritaire
  - Configuration App Store Connect
  - Gestion des achats restaurés
  - Période d'essai gratuite optionnelle

- [ ] **Soumission App Store**
  - Conformité App Store Guidelines
  - Politique de Confidentialité
  - EULA
  - Captures d'écran et descriptions
  - App Store Optimization (ASO)

---

## Backlog - Fonctionnalités Futures

### Intégrations Tierces
- [ ] Import depuis Bitwarden
- [ ] Import depuis 1Password (OPVault)
- [ ] Import depuis LastPass
- [ ] Import depuis KeePass
- [ ] Import depuis mots de passe Chrome
- [ ] Import CSV générique

### Fonctionnalités Avancées
- [ ] Authentification biométrique (Touch ID, Face ID)
- [ ] Support Yubikey
- [ ] Gestion de clés SSH
- [ ] Certificats de signature de code
- [ ] Générateur TOTP/2FA
- [ ] Notes sécurisées
- [ ] Partage de mots de passe chiffrés
- [ ] Audit trail complet
- [ ] Monitoring continu des violations

### DevOps
- [ ] CI/CD GitHub Actions
- [ ] Tests automatisés (>80% coverage)
- [ ] Sécurité: SAST, DAST
- [ ] Documentation complète
- [ ] Guidelines de contribution

---

## Validation Technique

### API HaveIBeenPwned
- **Statut**: FAISABLE et GRATUIT
- **API**: Pwned Passwords (modèle k-Anonymity)
- **Privacy**: Envoi seulement 5 premiers caractères du hash SHA-1
- **Coût**: GRATUIT (pas de clé API nécessaire pour passwords)
- **Implémentation**: Simple requête HTTPS
- **Référence**: haveibeenpwned.com/API/v3

### Code Signing App Store
- **Statut**: OBLIGATOIRE et FAISABLE
- **Requis**: Certificat Developer ID Application ($99/an)
- **Processus**: Code signing + Notarization (macOS 10.15+)
- **Outils**: Xcode, notarytool, Hardened Runtime
- **Référence**: support.apple.com/guide/security/sec3ad8e6e53

### In-App Purchase (StoreKit)
- **Statut**: STANDARD et FAISABLE
- **Framework**: StoreKit (natif Apple)
- **Configuration**: App Store Connect
- **Types**: Non-consumable (SilentKey Pro)
- **Frais Apple**: Commission 15-30%
- **Référence**: developer.apple.com/storekit

### Framework UserNotifications
- **Statut**: NATIF macOS et FAISABLE
- **Framework**: UserNotifications (natif Apple)
- **Permissions**: Demande utilisateur obligatoire
- **Features**: Alertes, badges, sons, actions
- **Intégration**: Préférences Système macOS
- **Référence**: developer.apple.com/documentation/usernotifications

### Apple Intelligence / Foundation Models
- **Statut**: NOUVEAU (macOS 15+) et FAISABLE
- **Framework**: Foundation Models (natif Swift)
- **Prérequis**: Apple Silicon (M1+)
- **Privacy**: 100% on-device, zéro cloud
- **Implémentation**: 3 lignes de code Swift
- **Capacités**: Résumé, extraction de texte, génération
- **Référence**: developer.apple.com/apple-intelligence

---

## Historique des Versions

### Version 2.0.0 (18 janvier 2026)
- Restructuration complète de la roadmap
- Séparation en sprints clairs
- Section de validation technique ajoutée
- Séparation anglais/français
- Formatage professionnel
- Suppression de tous les emojis pour professionnalisme

### Version 1.3.0 (18 janvier 2026)
- Ajout gestion de projets développeur
- Ajout CRUD complet sécurisé
- Ajout corbeille avec rétention de 30 jours
- Ajout notifications push
- Ajout intégration Apple Intelligence

---

<div align="center">

**Maintenu par: Assistant IA pour ThePhoenixAgency**  
**Format: Markdown Professionnel**

[🇬🇧 English Version](../en/ROADMAP.md) | [📚 Documentation](README.md) | [🐛 Signaler un Bug](https://github.com/ThePhoenixAgency/SilentKey/issues)

</div>
