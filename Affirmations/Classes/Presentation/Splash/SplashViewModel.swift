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
}

// MARK: Public
extension SplashViewModel {
    struct Input {}
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute()
        )
    }
}

// MARK: Private
private extension SplashViewModel {
    func makeRoute() -> Driver<Route> {
        Single<Route>
            .create { event in
                event(.success(OnboardingViewController.wasViewed() ? .main : .onboarding))
                
                return Disposables.create()
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
