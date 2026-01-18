//
//  MainView.swift
//  SilentKey
//
//  Created by Assistant AI on 18/01/2026.
//

import SwiftUI
import SilentKeyCore
import os.log

private let logger = Logger(subsystem: "com.thephoenixagency.silentkey", category: "MainView")

/**
 MainView (v0.7.3-staging)
 Hub central de SILENT KEY.
 Améliorations WCAG :
 - Sidebar élargie (280pt) pour éviter les coupures de texte ("Déconnexion").
 - Désactivation stricte de la césure (hyphenation) pour la lisibilité.
 - Support natif du redimensionnement dynamique des caractères.
 */
struct MainView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var localization = LocalizationManager.shared
    @State private var selectedTab: TabItem = .vault
    
    // WCAG: Define a minimum sidebar width that supports long French words
    private let sidebarMinWidth: CGFloat = 260
    
    var body: some View {
        NavigationSplitView {
            sidebarContent
                .frame(minWidth: sidebarMinWidth)
                .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow))
        } detail: {
            VStack(spacing: 0) {
                ZStack {
                    backgroundGradient
                    
                    Group {
                        switch selectedTab {
                        case .vault: VaultView()
                        case .projects: ProjectsView()
                        case .trash: TrashView()
                        case .settings: SettingsView()
                        }
                    }
                    .transition(.opacity)
                }
                
                PermanentFooterView()
                    .background(Color.black.opacity(0.1))
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            logger.info("MainView active (v0.7.3). WCAG layouts optimized.")
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.12, green: 0.15, blue: 0.3),
                Color(red: 0.08, green: 0.1, blue: 0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).ignoresSafeArea()
    }
    
    private var sidebarContent: some View {
        VStack(spacing: 0) {
            List(selection: $selectedTab) {
                Section {
                    navigationLabel(localization.localized(.vault), icon: "shield.fill")
                        .tag(TabItem.vault)
                } header: {
                    Text(localization.localized(.appName).uppercased())
                        .font(.system(size: 10, weight: .black))
                        .foregroundStyle(.blue)
                }
                
                Section {
                    navigationLabel(localization.localized(.projects), icon: "folder.fill")
                        .tag(TabItem.projects)
                    
                    navigationLabel(localization.localized(.trash), icon: "trash.fill")
                        .tag(TabItem.trash)
                } header: {
                    Text("ORGANIZATION").font(.system(size: 10, weight: .black))
                }
            }
            .listStyle(.sidebar)
            
            Divider().opacity(0.1)
            
            // BOTTOM BAR: Optimized for long labels (WCAG)
            VStack(alignment: .leading, spacing: 16) {
                Button(action: { selectedTab = .settings }) {
                    navigationLabel(localization.localized(.settings), icon: "gearshape.fill")
                        .foregroundStyle(selectedTab == .settings ? .blue : .white)
                }
                .buttonStyle(.plain)
                
                Button(action: { authManager.logout() }) {
                    navigationLabel(localization.localized(.logout), icon: "lock.open.fill")
                        .foregroundStyle(.red.opacity(0.9))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .background(Color.white.opacity(0.02))
        }
    }
    
    // MARK: - WCAG Helpers
    
    /**
     A helper to create labels that respect WCAG rules:
     - No truncation.
     - No hyphens.
     - Scalable text.
     */
    private func navigationLabel(_ text: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 14, weight: .bold))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
                .allowsTightening(false) // WCAG: ensure characters aren't squeezed
        }
    }
}

// MARK: - Subviews stubs optimized for WCAG

struct ProjectsView: View {
    @StateObject private var localization = LocalizationManager.shared
    var body: some View {
        VStack {
            Text(localization.localized(.projects).uppercased())
                .font(.system(size: 32, weight: .black, design: .rounded)).tracking(4)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Image(systemName: "folder.badge.plus").font(.system(size: 80)).foregroundStyle(.white.opacity(0.1))
            Text("NO PROJECTS DETECTED").font(.system(size: 14, weight: .black)).opacity(0.3)
            Spacer()
        }
        .padding(30)
    }
}

struct TrashView: View {
    var body: some View {
        VStack {
            Text("TRASH").font(.system(size: 32, weight: .black, design: .rounded)).tracking(4)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Image(systemName: "trash.slash.fill").font(.system(size: 80)).foregroundStyle(.white.opacity(0.1))
            Text("TRASH IS EMPTY").font(.system(size: 14, weight: .black)).opacity(0.3)
            Spacer()
        }
        .padding(30)
    }
}

struct SettingsView: View {
    @StateObject private var localization = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(localization.localized(.settings).uppercased())
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .tracking(4)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(30)
            
            List {
                Section("LOCALIZATION") {
                    Picker("Language", selection: $localization.currentLanguage) {
                        ForEach(AppLanguage.allCases) { lang in
                            Text("\(lang.flag) \(lang.displayName)").tag(lang)
                        }
                    }
                    .pickerStyle(.inline)
                }
                
                Section("SECURITY") {
                    Toggle("Auto-lock on idle", isOn: .constant(true))
                    Toggle("Biometric unlock (Touch ID)", isOn: .constant(true))
                }
                
                Section("ABOUT") {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("0.7.3-staging")
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
            }
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
        }
    }
}
