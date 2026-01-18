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
 MainView (v0.7.4-staging)
 Hub central de SILENT KEY.
 Changements :
 - Suppression du nom d'app dans la sidebar.
 - Ajout du logo et nom d'app agrandi dans l'en-tête de la vue de détail (Standard Pro).
 - Optimisation WCAG et espacements.
 */
struct MainView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var localization = LocalizationManager.shared
    @State private var selectedTab: TabItem = .vault
    
    private let sidebarMinWidth: CGFloat = 260
    
    var body: some View {
        NavigationSplitView {
            sidebarContent
                .frame(minWidth: sidebarMinWidth)
                .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow))
        } detail: {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    backgroundGradient
                    
                    // Header Pro: Logo + App Name (Grand format)
                    appHeaderOverlay
                    
                    Group {
                        switch selectedTab {
                        case .vault: VaultView().padding(.top, 100)
                        case .projects: ProjectsView().padding(.top, 100)
                        case .trash: TrashView().padding(.top, 100)
                        case .settings: SettingsView().padding(.top, 100)
                        }
                    }
                    .transition(.opacity)
                }
                
                PermanentFooterView()
                    .background(Color.black.opacity(0.1))
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - App Header (The "Pro" Look)
    
    private var appHeaderOverlay: some View {
        HStack(spacing: 20) {
            LogoView(size: 44) // Rappel du logo en haut à droite (standard pro)
            
            Text(localization.localized(.appName).uppercased())
                .font(.system(size: 28, weight: .black, design: .rounded))
                .tracking(8)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .padding(.top, 40)
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
            // Sidebar unifiée sans le titre répétitif
            List(selection: $selectedTab) {
                Section {
                    navigationLabel(localization.localized(.vault), icon: "shield.fill")
                        .tag(TabItem.vault)
                } header: {
                    Text("VAULT").font(.system(size: 10, weight: .black)).opacity(0.5)
                }
                
                Section {
                    navigationLabel(localization.localized(.projects), icon: "folder.fill")
                        .tag(TabItem.projects)
                    
                    navigationLabel(localization.localized(.trash), icon: "trash.fill")
                        .tag(TabItem.trash)
                } header: {
                    Text("ORGANIZATION").font(.system(size: 10, weight: .black)).opacity(0.5)
                }
            }
            .listStyle(.sidebar)
            
            Divider().opacity(0.1)
            
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
    
    private func navigationLabel(_ text: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 14, weight: .bold))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
                .allowsTightening(false)
        }
    }
}

// MARK: - Subviews optimized for WCAG

struct ProjectsView: View {
    @StateObject private var localization = LocalizationManager.shared
    var body: some View {
        VStack {
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
            }
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
