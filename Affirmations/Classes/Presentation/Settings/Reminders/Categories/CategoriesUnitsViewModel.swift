//
//  CategoriesUnitsViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 22.09.2023.
//

import RxSwift
import RxCocoa

final class CategoriesUnitsViewModel {
    enum Route {
        case selected([Category])
    }
    
    private let initialSelected: Driver<[Category]>
    
    private lazy var contentManager = ContentManager()
    
    init(categories: [Category]) {
        initialSelected = BehaviorRelay(value: categories).asDriver()
    }
}

// MARK: Public
extension CategoriesUnitsViewModel {
    struct Input {
        let didTapContinue: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[CategoriesUnitsTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements()
        
        return Output(
            elements: elements,
            route: makeRoute(
                didTapContinue: input.didTapContinue,
                elements: elements
            )
        )
    }
}

// MARK: Private
private extension CategoriesUnitsViewModel {
    func makeElements() -> Driver<[CategoriesUnitsTableElement]> {
        Driver
            .combineLatest(
                contentManager
                    .obtainCategories(for: Localizable.shared.currentLanguage)
                    .asDriver(onErrorJustReturn: []),
                initialSelected
            )
            .map { categories, initialSelected -> [CategoriesUnitsTableElement] in
                categories
                    .map { category -> CategoriesUnitsTableElement in
                        CategoriesUnitsTableElement(
                            category: category,
                            marked: initialSelected.contains(where: { $0.name == category.name })
                        )
                    }
            } 
    }
    
    func makeRoute(
        didTapContinue: Signal<Void>,
        elements: Driver<[CategoriesUnitsTableElement]>
    ) -> Driver<Route> {
        didTapContinue
            .withLatestFrom(elements)
            .map { $0.filter { $0.marked } }
            .compactMap { elements -> Route? in
                let categories = elements.map { $0.category }
                return categories.isEmpty ? nil : Route.selected(categories)
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
