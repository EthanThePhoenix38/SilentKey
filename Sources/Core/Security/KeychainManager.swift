//
//  KeychainManager.swift
//  SilentKey
//
//  Created by Assistant AI on 18/01/2026.
//

import Foundation
import Security
import os.log

private let logger = Logger(subsystem: "com.thephoenixagency.silentkey", category: "Keychain")

/**
 KeychainManager (v0.8.0)
 Provides secure storage for sensitive data in the macOS Keychain.
 Specifically used for the Master Password and Biometric tokens.
 */
public class KeychainManager {
    public static let shared = KeychainManager()
    
    private let service = "com.thephoenixagency.silentkey"
    private let masterPasswordAccount = "master_password"
    
    private init() {}
    
    /**
     Saves data to the keychain.
     */
    public func save(_ data: Data, for account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemDelete(query as CFDictionary) // Remove existing if any
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            logger.info("Successfully saved data to keychain for account: \(account)")
            return true
        } else {
            logger.error("Failed to save data to keychain. Status: \(status)")
            return false
        }
    }
    
    /**
     Reads data from the keychain.
     */
    public func read(for account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            return result as? Data
        } else {
            logger.debug("No data found in keychain for account: \(account) (Status: \(status))")
            return nil
        }
    }
    
    /**
     Deletes data from the keychain.
     */
    public func delete(for account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
        logger.info("Deleted keychain record for account: \(account)")
    }
    
    // MARK: - Specialized Methods
    
    public func saveMasterPassword(_ password: String) -> Bool {
        guard let data = password.data(using: .utf8) else { return false }
        return save(data, for: masterPasswordAccount)
    }
    
    public func getMasterPassword() -> String? {
        guard let data = read(for: masterPasswordAccount) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
