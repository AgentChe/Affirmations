//
//  PaygateViewModel.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 26.08.2021.
//

import RxSwift
import RxCocoa

final class PaygateViewModel {
    private lazy var activity = RxActivityIndicator()
    
    private lazy var iapManager = IAPManager()
    private lazy var interactor = PaygateInteractor()
}

// MARK: Public
extension PaygateViewModel {
    struct Input {
        let didTapBuy: Observable<String>
        let didTapRestore: Observable<Void>
    }
    
    struct Output {
        let activity: Driver<Bool>
        let errorMessage: Driver<String>
        let purchased: Signal<Void>
        let price: Driver<String>
    }
    
    func configure(input: Input) -> Output {
        let product = makeProduct()
        let purchased = makePurchased(
            didTapBuy: input.didTapBuy,
            didTapRestore: input.didTapRestore
        )
        
        return Output(
            activity: activity.asDriver(),
            errorMessage: makeErrorMessage(
                product: product,
                purchased: purchased
            ),
            purchased: purchased
                .compactMap { $0.success ? Void() : nil }
                .asSignal(onErrorSignalWith: .never()),
            price: product.compactMap { $0?.original.localizedPrice }
        )
    }
}

// MARK: Private
private extension PaygateViewModel {
    func makePurchased(didTapBuy: Observable<String>, didTapRestore: Observable<Void>) -> Driver<(success: Bool, errorMessage: String?)> {
        let buy = didTapBuy
            .withUnretained(self)
            .flatMapLatest { base, productId -> Observable<PaygateInteractor.PurchaseActionResult> in
                base.interactor
                    .makeActiveSubscription(at: .buy(productId))
                    .trackActivity(base.activity)
            }
        
        let restore = didTapRestore
            .withUnretained(self)
            .flatMapLatest { base, void -> Observable<PaygateInteractor.PurchaseActionResult> in
                base.interactor
                    .makeActiveSubscription(at: .restore)
                    .trackActivity(base.activity)
            }
        
        return Observable
            .merge(buy, restore)
            .compactMap { result -> (success: Bool, errorMessage: String?)? in
                switch result {
                case .cancelled:
                    return nil
                case .purchased:
                    return (success: true, errorMessage: nil)
                case .failure(let errorMessage):
                    let message = errorMessage ?? "Paygate.Error".localized
                    return (success: false, errorMessage: message)
                }
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeProduct() -> Driver<IAPProduct?> {
        iapManager
            .obtainProducts(ids: [GlobalDefinitions.Paygate.productId])
            .map { products -> IAPProduct? in
                products.first(where: { $0.original.productIdentifier == GlobalDefinitions.Paygate.productId })
            }
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeErrorMessage(
        product: Driver<IAPProduct?>,
        purchased: Driver<(success: Bool, errorMessage: String?)>
    ) -> Driver<String> {
        let productError = product
            .compactMap { product -> String? in
                product == nil ? "Paygate.Error".localized : nil
            }
        let purchasedError = purchased
            .compactMap { (success: Bool, errorMessage: String?) -> String? in
                success ? nil : errorMessage
            }
        
        return Driver.merge(
            productError,
            purchasedError
        )
    }
}
