//
//  ContentView.swift
//  SilentKey - Vue principale de l'application
//

import SwiftUI

struct ContentView: View {
    @State private var secrets: [SecretItem] = []
    @State private var showingAddSecret = false
    
    var body: some View {
        NavigationView {
            // Sidebar
            List {
                Section("Secrets") {
                    ForEach(secrets) { secret in
                        NavigationLink(destination: SecretDetailView(secret: secret)) {
                            HStack {
                                Image(systemName: iconFor(type: secret.type))
                                VStack(alignment: .leading) {
                                    Text(secret.title)
                                        .font(.headline)
                                    Text(secret.type.rawValue)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSecret = true }) {
                        Label("Add Secret", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("SilentKey")
            
            // Placeholder
            Text("Select a secret or create a new one")
                .foregroundColor(.secondary)
        }
        .sheet(isPresented: $showingAddSecret) {
            AddSecretView()
        }
    }
    
    private func iconFor(type: SecretType) -> String {
        switch type {
        case .apiKey: return "key"
        case .token: return "ticket"
        case .credential: return "person.badge.key"
        case .sshKey: return "terminal"
        case .generic: return "doc.text"
        }
    }
}

struct SecretDetailView: View {
    let secret: SecretItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(secret.title)
                .font(.title)
            Text(secret.type.rawValue)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}

struct AddSecretView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var type = SecretType.apiKey
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                Picker("Type", selection: $type) {
                    Text("API Key").tag(SecretType.apiKey)
                    Text("Token").tag(SecretType.token)
                    Text("Credential").tag(SecretType.credential)
                    Text("SSH Key").tag(SecretType.sshKey)
                    Text("Generic").tag(SecretType.generic)
                }
            }
            .navigationTitle("New Secret")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
