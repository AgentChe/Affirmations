//
//  PaygateInteractor.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 06.03.2023.
//

import RxSwift
import RxCocoa

final class PaygateInteractor {
    enum Action {
        case buy(String)
        case restore
    }
    
    enum PurchaseActionResult {
        case cancelled
        case purchased
        case failure(String? = nil)
    }
    
    private lazy var iapManager = IAPManager()
}

// MARK: Public
extension PaygateInteractor {
    func makeActiveSubscription(at action: Action) -> Single<PurchaseActionResult> {
        switch action {
        case .buy(let productId):
            return buy(productId: productId)
        case .restore:
            return restore()
        }
    }
}

// MARK: Private
private extension PaygateInteractor {
    func buy(productId: String) -> Single<PurchaseActionResult> {
        iapManager
            .buyProduct(with: productId)
            .map { [weak self] result -> PurchaseActionResult in
                guard let self = self else {
                    return .cancelled
                }
                
                switch result {
                case .cancelled:
                    return .cancelled
                case .completed:
                    return self.iapManager.hasActiveSubscriptions ? .purchased : .failure()
                }
            }
    }
    
    func restore() -> Single<PurchaseActionResult> {
        iapManager
            .restorePurchases()
            .catchAndReturn([])
            .map { [weak self] ids -> PurchaseActionResult in
                guard let self else {
                    return .cancelled
                }
                
                if ids.isEmpty {
                    return .failure("Paygate.Restore.Error".localized)
                }
                
                return self.iapManager.hasActiveSubscriptions ? .purchased : .failure("Paygate.Restore.Error".localized)
            }
    }
}
