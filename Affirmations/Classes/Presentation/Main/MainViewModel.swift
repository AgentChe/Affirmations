//
//  MainViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 30.08.2023.
//

import RxSwift
import RxCocoa

final class MainViewModel {
    private lazy var iapManager = IAPManager()
    private lazy var contentManager = ContentManager()
}

// MARK: Public
extension MainViewModel {
    struct Input {}
    
    struct Output {
        let activeSubsription: Driver<Bool>
        let selectedCategoryName: Driver<String>
    }
    
    func configure(input: Input) -> Output {
        let selectedCategory = makeSelectedCategory()
        
        return Output(
            activeSubsription: makeActiveSubscription(),
            selectedCategoryName: selectedCategory.map { $0.name }  
        )
    }
}

// MARK: Private
private extension MainViewModel {
    func makeActiveSubscription() -> Driver<Bool> {
        PaygateMediator.shared
            .didPurchased
            .startWith(Void())
            .compactMap { [weak self] void -> Bool? in
                self?.iapManager.hasActiveSubscriptions
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeSelectedCategory() -> Driver<Category> {
        ContentMediator.shared
            .didChangeSelectedCategory
            .startWith(())
            .flatMapLatest { [weak self] void -> Driver<Category> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainSelectedCategory(for: Localizable.shared.currentLanguage)
                    .compactMap { $0 }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
