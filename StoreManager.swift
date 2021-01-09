import StoreKit

class StoreManager: NSObject, SKPaymentTransactionObserver {
    static var sharedStore = StoreManager()
    
    // product idの一覧を定義する
    let productsIdentifiers: Set<String> = []
    var products: [SKProduct] = []
    
    // AppDelegateや課金処理前に呼び出してproduct一覧を取得する
    static func setup() {
        sharedStore.validateProductsIdentifiersWithRequest()
    }
    
    // product情報をStoreから取得
    private func validateProductsIdentifiersWithRequest() {
        let request = SKProductsRequest(productIdentifiers: productsIdentifiers)
        request.delegate = self
        request.start()
    }
    
    // 購入
    func purchaseProduct(_ productIdentifier: String) {
        guard let product = productForIdentifiers(productIdentifier) else { return }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // 該当のproduct情報はproductsに存在するか確認
    private func productForIdentifiers(_ productIdentifier: String) -> SKProduct? {
        return products.filter({ (product: SKProduct) -> Bool in
            return product.productIdentifier == productIdentifier
        }).first
    }
    
    // transactionsが変わるたびに呼ばれる
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                completeTransaction(transaction)
            case .restored:
                restoreTransaction(transaction)
            case .deferred:
                break
            case .failed:
                failedTransaction(transaction)
            default:
                break
            }
        }
    }
    
    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        // レシートの検証や課金後の必要な処理を完了してからトランザクションを閉じること
    }

    private func restoreTransaction(_ transaction: SKPaymentTransaction) {
        // レシートの検証や課金後の必要な処理を完了してからトランザクションを閉じること
    }

    private func failedTransaction(_ transaction: SKPaymentTransaction) {
        // トランザクションの終了処理
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func finishTransaction(_ transaction: SKPaymentTransaction) {
        // トランザクションの終了処理
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

extension StoreManager: SKProductsRequestDelegate {
    
    // product情報の取得完了
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }
}
