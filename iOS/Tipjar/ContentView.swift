import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var field1 = ""
    @State private var field2 = ""
    @State private var field3 = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.entries) { entry in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.field1).font(Theme.headlineFont)
                            HStack {
                                Text(entry.field2)
                                Spacer()
                                Text(entry.field3).foregroundStyle(.secondary)
                            }
                            .font(Theme.bodyFont)
                        }
                        .listRowBackground(Theme.card)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Tipjar")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                addSheet
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
    }

    private var addSheet: some View {
        NavigationStack {
            Form {
                TextField("Job", text: $field1)
                    .accessibilityIdentifier("field1Input")
                TextField("Tips", text: $field2)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("field2Input")
                TextField("Hours", text: $field3)
                    .accessibilityIdentifier("field3Input")
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAdd = false
                    }
                    .accessibilityIdentifier("cancelAddButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let ok = store.add(field1: field1, field2: field2, field3: field3)
                        if ok {
                            field1 = ""; field2 = ""; field3 = ""
                            showingAdd = false
                        } else {
                            showingAdd = false
                            showingPaywall = true
                        }
                    }
                    .disabled(field1.isEmpty)
                    .accessibilityIdentifier("saveAddButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(PurchaseManager())
}
