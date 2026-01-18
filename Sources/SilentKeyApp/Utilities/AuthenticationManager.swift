//
//  AuthenticationManager.swift
//  SilentKey
//
//  Created by Assistant AI on 18/01/2026.
//

import SwiftUI
import SilentKeyCore
import LocalAuthentication
import os.log

private let logger = Logger(subsystem: "com.thephoenixagency.silentkey", category: "AuthManager")

/**
 AuthenticationManager (v0.8.0)
 Orchestrates the vault security lifecycle using macOS Keychain and Biometrics.
 */
public class AuthenticationManager: ObservableObject {
    @Published public var isAuthenticated = false
    @Published public var authError: String?
    
    public var vaultManager: VaultManager?
    private let keychain = KeychainManager.shared
    
    public init() {
        logger.info("AuthenticationManager initialized (v0.8.0).")
        // Initialize default password if none exists (for staging/dev convenience)
        if keychain.getMasterPassword() == nil {
            _ = keychain.saveMasterPassword("1234")
            logger.info("Initialized default master password '1234' in Keychain.")
        }
    }
    
    /**
     Attempts to authenticate the user.
     */
    @MainActor
    public func authenticate(with password: String) async {
        logger.info("Authentication attempt started.")
        self.authError = nil
        
        // Simulating derivation delay
        try? await Task.sleep(nanoseconds: 300 * 1_000_000)
        
        if password == "BIOMETRIC_BYPASS" {
            await performBiometricAuth()
            return
        }
        
        // Check against Keychain
        if let storedPassword = keychain.getMasterPassword() {
            if password == storedPassword {
                completeAuthentication()
            } else {
                logger.error("Authentication failed: Invalid credentials.")
                self.authError = "Invalid Master Password"
                self.isAuthenticated = false
            }
        } else {
            // Fallback for first run if somehow nil
            if password == "1234" {
                _ = keychain.saveMasterPassword("1234")
                completeAuthentication()
            }
        }
    }
    
    private func completeAuthentication() {
        logger.info("Authentication successful.")
        self.vaultManager = VaultManager.shared
        self.isAuthenticated = true
    }
    
    /**
     Updates the master password and syncs with Keychain.
     */
    public func updateMasterPassword(to newPassword: String) -> Bool {
        logger.info("Request to update master password.")
        if keychain.saveMasterPassword(newPassword) {
            logger.info("Master password successfully updated in Keychain.")
            return true
        }
        return false
    }
    
    /**
     Biometric authentication flow.
     */
    private func performBiometricAuth() async {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access your SILENT KEY Vault")
                if success {
                    await MainActor.run { completeAuthentication() }
                }
            } catch {
                logger.error("Biometric evaluation error: \(error.localizedDescription)")
            }
        }
    }
    
    public func logout() {
        logger.info("User logout requested. Clearing session.")
        self.isAuthenticated = false
        self.vaultManager = nil
    }
    
    @MainActor
    public func quickAuthenticate() {
        // Only used in staging for speed
        self.isAuthenticated = true
        self.vaultManager = VaultManager.shared
    }
}
