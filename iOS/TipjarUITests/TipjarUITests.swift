import XCTest

final class TipjarUITests: XCTestCase {
    let freeLimit = 25

    func testAddFlowAddsEntry() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let field1 = app.textFields["field1Input"]
        field1.tap()
        field1.typeText("Test Entry")
        app.buttons["saveAddButton"].tap()
        XCTAssertTrue(app.staticTexts["Test Entry"].waitForExistence(timeout: 2))
    }

    func testFreeLimitTriggersPaywall() {
        let app = XCUIApplication()
        app.launch()
        for _ in 0..<(freeLimit + 2) {
            app.buttons["addButton"].tap()
            if app.buttons["unlockProButton"].waitForExistence(timeout: 1) {
                break
            }
            let field1 = app.textFields["field1Input"]
            if field1.waitForExistence(timeout: 1) {
                field1.tap()
                field1.typeText("Entry")
                app.buttons["saveAddButton"].tap()
            }
        }
        XCTAssertTrue(app.buttons["unlockProButton"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissOnTapOutside() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let field1 = app.textFields["field1Input"]
        field1.tap()
        field1.typeText("Dismiss Test")
        app.navigationBars["Add Entry"].tap()
        XCTAssertFalse(field1.hasFocus)
    }

    func testSettingsOpensAndCloses() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["doneSettingsButton"].waitForExistence(timeout: 2))
        app.buttons["doneSettingsButton"].tap()
    }
}

extension XCUIElement {
    var hasFocus: Bool {
        (value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }
}
