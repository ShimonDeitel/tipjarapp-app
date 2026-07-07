import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) var dismiss
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                    Toggle("Haptics", isOn: $hapticsEnabled)
                }
                Section("Tipjar Pro") {
                    if purchaseManager.isSubscribed {
                        Label("Pro Unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Text("Unlock Pro from the paywall to access: Weekly/monthly summaries and per-job tagging")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    Button("Restore Purchases") {
                        Task { await purchaseManager.restore() }
                    }
                    .accessibilityIdentifier("restorePurchasesButton")
                }
                Section("Legal") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/tipjarapp-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/tipjarapp-app/terms.html")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("doneSettingsButton")
                }
            }
        }
    }
}

#Preview {
    SettingsView().environmentObject(PurchaseManager())
}
