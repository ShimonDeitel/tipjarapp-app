import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let productID = "com.shimondeitel.tipjarapp.pro.monthly"

    @Published var isSubscribed: Bool = false
    @Published var product: Product?

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                await self?.handle(result)
            }
        }
        Task { await load() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func load() async {
        if let products = try? await Product.products(for: [Self.productID]) {
            product = products.first
        }
        await refreshStatus()
    }

    func purchase() async {
        guard let product else { return }
        if let result = try? await product.purchase() {
            switch result {
            case .success(let verification):
                await handle(verification)
            default:
                break
            }
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshStatus()
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        if case .verified(let transaction) = result {
            await transaction.finish()
        }
        await refreshStatus()
    }

    func refreshStatus() async {
        var subscribed = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == Self.productID {
                subscribed = true
            }
        }
        isSubscribed = subscribed
    }
}
