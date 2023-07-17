//
//  IAPManagerCore.swift
//  CarCheckUK
//
//  Created by Andrey Chernyshev on 08.10.2020.
//

import RxSwift
import SwiftyStoreKit
import StoreKit

protocol IAPManagerProtocol: AnyObject {
    static func initialize()
    func obtainProducts(ids: [String]) -> Single<[IAPProduct]>
    func buyProduct(with id: String) -> Single<IAPActionResult>
    func restorePurchases() -> Single<[String]>
    func retrieveReceipt(forceUpdate: Bool) -> Single<String?>
}

final class IAPManager {}

// MARK: IAPManagerProtocol
extension IAPManager: IAPManagerProtocol {
    static func initialize() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                let state = purchase.transaction.transactionState
                if state == .purchased || state == .restored {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
        }
        
        SwiftyStoreKit.shouldAddStorePaymentHandler = { _, _ in
            true
        }
    }
    
    func obtainProducts(ids: [String]) -> Single<[IAPProduct]> {
        Single<[IAPProduct]>.create { event in
            SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { result in
                let products = result.retrievedProducts.map { IAPProduct(original: $0) }

                event(.success(products))
            }

            return Disposables.create()
        }
    }
    
    func buyProduct(with id: String) -> Single<IAPActionResult> {
        guard SwiftyStoreKit.canMakePayments else {
            return .error(IAPError(.paymentsDisabled))
        }

        return Single<IAPActionResult>
            .create { event in
                SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        if purchase.productId == id {
                            event(.success(.completed(id)))
                        }
                    case .error(let error):
                        if IAPErrorHelper.treatErrorAsCancellation(error) {
                            event(.success(.cancelled))
                        } else if IAPErrorHelper.treatErrorAsSuccess(error) {
                            event(.success(.completed(id)))
                        } else {
                            event(.failure(IAPError(.paymentFailed, underlyingError: error)))
                        }
                    }
                }

                return Disposables.create()
            }
    }
    
    func restorePurchases() -> Single<[String]> {
        Single<[String]>
            .create { event in
                SwiftyStoreKit.restorePurchases { result in
                    if result.restoredPurchases.isEmpty {
                        event(.failure(IAPError(.cannotRestorePurchases)))
                    } else {
                        event(.success(result.restoredPurchases.map { $0.productId }))
                    }
                }

                return Disposables.create()
            }
    }
    
    func retrieveReceipt(forceUpdate: Bool) -> Single<String?> {
        Single<String?>
            .create { event in
                if forceUpdate {
                    SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
                        switch result {
                        case .success(let receiptData):
                            let base64Receipt = receiptData.base64EncodedString()
                            event(.success(base64Receipt))
                        case .error:
                            event(.success(nil))
                        }
                    }
                } else {
                    let base64Receipt = SwiftyStoreKit.localReceiptData?.base64EncodedString()
                    event(.success(base64Receipt))
                }
                
                return Disposables.create()
            }
    }
}
