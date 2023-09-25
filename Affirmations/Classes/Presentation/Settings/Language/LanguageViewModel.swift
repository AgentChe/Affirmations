//
//  LanguageViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 25.09.2023.
//

import RxSwift
import RxCocoa

final class LanguageViewModel {
    enum Route {
        case confirm(ApplicationLanguage)
    }
}

// MARK: Public
extension LanguageViewModel {
    struct Input {
        let didTapContinue: Signal<ApplicationLanguage>
    }
    
    struct Output {
        let elements: Driver<[LanguageTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements()
        
        return Output(
            elements: elements,
            route: makeRoute(didTapContinue: input.didTapContinue)
        )
    }
}

// MARK: Private
private extension LanguageViewModel {
    func makeElements() -> Driver<[LanguageTableElement]> {
        Single<[LanguageTableElement]>
            .create { single in
                let elements = ApplicationLanguage.allCases
                    .map { language -> LanguageTableElement in
                        LanguageTableElement(
                            language: language,
                            marked: language == Localizable.shared.currentLanguage
                        )
                    }
                single(.success(elements))
                
                return Disposables.create()
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeRoute(didTapContinue: Signal<ApplicationLanguage>) -> Driver<Route> {
        didTapContinue
            .map { Route.confirm($0) }
            .asDriver(onErrorDriveWith: .never())
    }
}
