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
}

// MARK: Public
extension OnboardingViewModel {
    // TODO
    func whatNext() -> Step {
        .paygate
    }
}
