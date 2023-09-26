//
//  SplashViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 17.07.2023.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Route {
        case onboarding, main
    }
    
    private lazy var contentManager = ContentManager()
}

// MARK: Public
extension SplashViewModel {
    struct Input {}
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let activeSubscription = makeActiveSubscription()
        let reminders = makeReminders()
        
        return Output(
            route: makeRoute(
                activeSubscription: activeSubscription,
                reminders: reminders
            )
        )
    }
}

// MARK: Private
private extension SplashViewModel {
    func makeRoute(
        activeSubscription: Driver<Bool>,
        reminders: Driver<[Reminder]>
    ) -> Driver<Route> {
        Driver
            .combineLatest(activeSubscription, reminders)
            .flatMapLatest { [weak self] activeSubscription, reminders -> Driver<Route> in
                guard let self else {
                    return .never()
                }
                
                let route = OnboardingViewController.wasViewed() ? Route.main : Route.onboarding
                
                if !activeSubscription && reminders.count > 2 {
                    return self.contentManager
                        .delete(reminders: Array(reminders[2...(reminders.count - 1)]))
                        .map { route }
                        .asDriver(onErrorDriveWith: .never())
                }
                
                return .just(route)
            }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        Single<Bool>
            .create { single in
                let activeSubscription = IAPManager().hasActiveSubscriptions
                single(.success(activeSubscription))
                
                return Disposables.create()
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeReminders() -> Driver<[Reminder]> {
        contentManager
            .obtainReminders()
            .asDriver(onErrorJustReturn: [])
    }
}
