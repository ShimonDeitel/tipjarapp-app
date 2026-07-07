import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [Entry] = []
    @Published var isPro: Bool = false

    static let freeLimit = 25

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("tipjar_entries.json")
        load()
    }

    func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Entry].self, from: data) {
            entries = decoded
        } else {
            entries = [
        Entry(field1: "Diner Shift", field2: "64", field3: "5"),
        Entry(field1: "Diner Shift", field2: "81", field3: "6"),
        Entry(field1: "Bartend Sat", field2: "145", field3: "7")
            ]
            save()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL)
        }
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    @discardableResult
    func add(field1: String, field2: String, field3: String) -> Bool {
        guard canAddMore else { return false }
        entries.insert(Entry(field1: field1, field2: field2, field3: field3), at: 0)
        save()
        return true
    }

    func update(_ entry: Entry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: Entry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }
}
