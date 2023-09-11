//
//  SettingsViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 11.09.2023.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    private lazy var iapManager = IAPManager()
}

// MAKR: Public
extension SettingsViewModel {
    struct Input {}
    
    struct Output {
        let elements: Driver<[SettingsTableElement]>
    }
    
    func configure(input: Input) -> Output {
        let activeSubscription = makeActiveSubscription()
        
        return Output(
            elements: makeElements(activeSubscription: activeSubscription)
        )
    }
}

// MARK: Private
private extension SettingsViewModel {
    func makeElements(activeSubscription: Driver<Bool>) -> Driver<[SettingsTableElement]> {
        activeSubscription
            .map { activeSubscription -> [SettingsTableElement] in
                var result = [SettingsTableElement]()
                
                if !activeSubscription {
                    result.append(.paygate)
                }
                
                return result
            }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PaygateMediator.shared
            .didPurchased
            .startWith(Void())
            .compactMap { [weak self] void -> Bool? in
                self?.iapManager.hasActiveSubscriptions
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
