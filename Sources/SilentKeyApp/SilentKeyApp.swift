//
//  SilentKeyApp.swift
//  SilentKey
//
//  Created by Assistant AI on 18/01/2026.
//

import SwiftUI
import SilentKeyCore
import os.log

private let logger = Logger(subsystem: "com.thephoenixagency.silentkey", category: "Lifecycle")

/**
 SilentKeyApp (v0.7.3-staging)
 Core entry point.
 Features:
 - Explicit window centering on launch.
 - Standardized aspect ratio preservation.
 - Single-instance enforcement.
 */
@main
struct SilentKeyApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        #if os(macOS)
        Window("SILENT KEY", id: "silentkey_main") {
            ContentView()
                .environmentObject(appState)
                .environmentObject(authManager)
                // Center the window at launch using a responsive base size
                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)
                .onAppear {
                    setupAppEnvironment()
                    centerWindowOnLaunch()
                }
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
        #else
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(authManager)
                .preferredColorScheme(.dark)
        }
        #endif
    }
    
    private func setupAppEnvironment() {
        logger.info("Setting up SILENT KEY execution policy.")
        #if os(macOS)
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        // Auto-login for staging validation
        authManager.quickAuthenticate()
        #endif
    }
    
    private func centerWindowOnLaunch() {
        #if os(macOS)
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first(where: { $0.identifier?.rawValue == "silentkey_main" }) {
                if let screen = window.screen ?? NSScreen.main {
                    let screenRect = screen.visibleFrame
                    let newOriginX = screenRect.origin.x + (screenRect.width - window.frame.width) / 2
                    let newOriginY = screenRect.origin.y + (screenRect.height - window.frame.height) / 2
                    window.setFrameOrigin(NSPoint(x: newOriginX, y: newOriginY))
                    window.makeKeyAndOrderFront(nil)
                    logger.info("Window centered on screen: \(screen.localizedName)")
                }
            }
        }
        #endif
    }
}
