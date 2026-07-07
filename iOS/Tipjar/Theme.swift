import SwiftUI

enum Theme {
    static let accent = Color(red: 0.7804, green: 0.6039, blue: 0.1804)
    static let background = Color(red: 0.0824, green: 0.0667, blue: 0.0353)
    static let card = background.opacity(0.6)
    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let cornerRadius: CGFloat = 16
}
