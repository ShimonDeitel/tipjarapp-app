import XCTest
@testable import Tipjar

@MainActor
final class TipjarTests: XCTestCase {
    func makeStore() -> Store {
        Store()
    }

    func testSeedDataBelowFreeLimit() {
        let store = makeStore()
        XCTAssertLessThan(store.entries.count, Store.freeLimit)
    }

    func testAddEntrySucceedsUnderLimit() {
        let store = makeStore()
        let before = store.entries.count
        let ok = store.add(field1: "Test", field2: "10", field3: "Note")
        XCTAssertTrue(ok)
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = makeStore()
        XCTAssertTrue(store.canAddMore)
    }

    func testAddBlockedWhenAtLimitAndNotPro() {
        let store = makeStore()
        while store.entries.count < Store.freeLimit {
            store.add(field1: "x", field2: "1", field3: "y")
        }
        let ok = store.add(field1: "over", field2: "1", field3: "z")
        XCTAssertFalse(ok)
    }

    func testProBypassesLimit() {
        let store = makeStore()
        store.isPro = true
        while store.entries.count < Store.freeLimit {
            store.add(field1: "x", field2: "1", field3: "y")
        }
        let ok = store.add(field1: "over", field2: "1", field3: "z")
        XCTAssertTrue(ok)
    }

    func testDeleteRemovesEntry() {
        let store = makeStore()
        let before = store.entries.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testNewestEntryInsertedFirst() {
        let store = makeStore()
        store.add(field1: "Newest", field2: "1", field3: "z")
        XCTAssertEqual(store.entries.first?.field1, "Newest")
    }
}
