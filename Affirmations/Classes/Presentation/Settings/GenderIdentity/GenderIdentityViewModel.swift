//
//  GenderIdentityViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 19.09.2023.
//

import RxSwift
import RxCocoa

final class GenderIdentityViewModel {
    private lazy var profileManager = ProfileManager()
}

// MARK: Public
extension GenderIdentityViewModel {
    struct Input {
        let didSelect: Signal<Gender>
    }
    
    struct Output {
        let gender: Driver<Gender>
    }
    
    func configure(input: Input) -> Output {
        Output(
            gender: makeGender(didSelect: input.didSelect)
        )
    }
}

// MARK: Private
private extension GenderIdentityViewModel {
    func makeGender(didSelect: Signal<Gender>) -> Driver<Gender> {
        let initial = profileManager
            .obtainGender()
            .map { $0 ?? .other }
            .asDriver(onErrorJustReturn: .other)
        let action = didSelect
            .flatMapLatest { [weak self] gender -> Driver<Gender> in
                guard let self else {
                    return .never()
                }
                
                return self.profileManager
                    .setup(gender: gender)
                    .asDriver(onErrorDriveWith: .never())
                    .map { gender }
            }
        return Driver.merge(initial, action)
    }
}
