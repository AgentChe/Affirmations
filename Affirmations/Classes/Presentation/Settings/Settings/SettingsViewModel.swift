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
        Driver
            .combineLatest(
                activeSubscription,
                Backup.shared.isSignIn.asDriver(onErrorDriveWith: .never())
            )
            .map { activeSubscription, isGoogleSignIn -> [SettingsTableElement] in
                var result = [SettingsTableElement]()
                
                if !activeSubscription {
                    result.append(.paygate)
                }
                
                result.append(.backup(enable: isGoogleSignIn))
                result.append(contentsOf: [
                    .route(.contentPreferences),
                    .route(.gender),
                    .route(.reminders),
                    .route(.language),
                    .route(.favorites),
                    .route(.myAffirmations)
                ])
                
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
