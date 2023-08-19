//
//  OnboardingViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 30.07.2023.
//

final class OnboardingViewModel {
    enum Step {
        case paygate, main
    }
    
    private lazy var iapManager = IAPManager()
}

// MARK: Public
extension OnboardingViewModel {
    func whatNext() -> Step {
        iapManager.hasActiveSubscriptions ? .main : .paygate
    }
}
