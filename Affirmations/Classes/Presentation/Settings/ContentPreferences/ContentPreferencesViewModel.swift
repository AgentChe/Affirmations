//
//  ContentPreferencesViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 20.09.2023.
//

import RxSwift
import RxCocoa

final class ContentPreferencesViewModel {
    private lazy var contentManager = ContentManager()
}

// MARK: Public
extension ContentPreferencesViewModel {
    struct Input {
        let didSelect: Signal<[Category]>
    }
    
    struct Output {
        let elements: Driver<[OWCCollectionElement]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(didSelect: input.didSelect)
        )
    }
}

// MARK: Private
private extension ContentPreferencesViewModel {
    func makeElements(didSelect: Signal<[Category]>) -> Driver<[OWCCollectionElement]> {
        let categories = contentManager
            .obtainWidgetsCategories(for: Localizable.shared.currentLanguage)
            .asDriver(onErrorJustReturn: [])
        let selectedInitial = contentManager
            .obtainSelectedWidgetsCategories()
            .asDriver(onErrorJustReturn: [])
        let updated = didSelect
            .flatMapLatest { [weak self] categories -> Driver<[Category]> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .saveSelectedWidgets(categories: categories)
                    .map { categories }
                    .asDriver(onErrorJustReturn: [])
            }
        let selected = Driver.merge(selectedInitial, updated)
        
        return Driver
            .combineLatest(categories, selected)
            .map { categories, selected -> [OWCCollectionElement] in
                categories.map { category -> OWCCollectionElement in
                    OWCCollectionElement(
                        category: category,
                        marked: selected.contains(where: { $0.name == category.name })
                    )
                }
            }
    }
}
