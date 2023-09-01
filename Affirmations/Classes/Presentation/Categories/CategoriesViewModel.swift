//
//  CategoriesViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 31.08.2023.
//

import RxSwift
import RxCocoa

final class CategoriesViewModel {
    enum Route {
        case dismiss
        case paygate
        case alert(String)
    }
    
    private lazy var iapManager = IAPManager()
    private lazy var contentManager = ContentManager()
    private lazy var profileManager = ProfileManager()
}

// MARK: Public
extension CategoriesViewModel {
    struct Input {
        let didSelectElement: Signal<CategoriesCollectionElement>
    }
    
    struct Output {
        let activeSubscription: Driver<Bool>
        let elements: Driver<[CategoriesCollectionElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let activeSubscription = makeActiveSubscription()
        let categories = makeCategories()
        let selectedCategory = makeSelectedCategory()
        
        return Output(
            activeSubscription: activeSubscription,
            elements: makeElements(
                categories: categories,
                activeSubscription: activeSubscription,
                selectedCategory: selectedCategory
            ),
            route: makeRoute(didSelectElement: input.didSelectElement)
        )
    }
}

// MARK: Private
private extension CategoriesViewModel {
    func makeRoute(didSelectElement: Signal<CategoriesCollectionElement>) -> Driver<Route> {
        didSelectElement
            .flatMapLatest { [weak self] element -> Driver<Route> in
                guard let self else {
                    return .never()
                }
                
                if element.paid {
                    return .just(.paygate)
                } else {
                    return self.profileManager
                        .obtainGender()
                        .flatMap { gender -> Single<Route> in
                            self.contentManager
                                .obtainAffirmations(
                                    for: Localizable.shared.currentLanguage,
                                    categoryType: element.category.type,
                                    gender: (gender ?? .other).rawValue
                                )
                                .flatMap { affirmations -> Single<Route> in
                                    if affirmations.isEmpty {
                                        switch element.category.type {
                                        case "MY":
                                            return .just(.alert("Categories.Alert.My".localized))
                                        case "FAVORITES":
                                            return .just(.alert("Categories.Alert.Favorites".localized))
                                        default:
                                            return .just(.alert("Categories.Alert.Other".localized))
                                        }
                                    } else {
                                        return self.contentManager
                                            .select(categoryType: element.category.type)
                                            .map { Route.dismiss }
                                    }
                                }
                        }
                        .asDriver(onErrorDriveWith: .never())
                }
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
    
    func makeElements(
        categories: Driver<[Category]>,
        activeSubscription: Driver<Bool>,
        selectedCategory: Driver<Category?>
    ) -> Driver<[CategoriesCollectionElement]> {
        Driver
            .combineLatest(categories, activeSubscription, selectedCategory)
            .map { categories, activeSubscription, selectedCategory -> [CategoriesCollectionElement] in
                categories.map { category -> CategoriesCollectionElement in
                    CategoriesCollectionElement(
                        category: category,
                        selected: category.type == selectedCategory?.type,
                        paid: activeSubscription ? false : !category.free
                    )
                }
            }
    }
    
    func makeCategories() -> Driver<[Category]> {
        contentManager
            .obtainCategories(for: Localizable.shared.currentLanguage)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSelectedCategory() -> Driver<Category?> {
        contentManager
            .obtainSelectedCategory(for: Localizable.shared.currentLanguage)
            .asDriver(onErrorJustReturn: nil)
    }
}
