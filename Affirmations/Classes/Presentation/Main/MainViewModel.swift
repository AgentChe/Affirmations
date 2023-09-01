//
//  MainViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 30.08.2023.
//

import RxSwift
import RxCocoa

final class MainViewModel {
    enum Route {
        case training(TrainingView.Training)
        case requestReview
    }
    
    enum Constants {
        static let swipeTraining = "main_view_model_swipe_training"
        static let likeTraining = "main_view_model_like_training"
    }
    
    private lazy var iapManager = IAPManager()
    private lazy var contentManager = ContentManager()
}

// MARK: Public
extension MainViewModel {
    struct Input {
        let didCompleteTraining: Signal<TrainingView.Training>
    }
    
    struct Output {
        let activeSubsription: Driver<Bool>
        let selectedCategoryName: Driver<String>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let selectedCategory = makeSelectedCategory()
        
        return Output(
            activeSubsription: makeActiveSubscription(),
            selectedCategoryName: selectedCategory.map { $0.name },
            route: makeRoute(didCompleteTraining: input.didCompleteTraining)
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
    
    func makeRoute(didCompleteTraining: Signal<TrainingView.Training>) -> Driver<Route> {
        let initial = Single<Route>
            .create { event in
                if !UserDefaults.standard.bool(forKey: Constants.swipeTraining) {
                    event(.success(.training(.swipe)))
                } else if !UserDefaults.standard.bool(forKey: Constants.likeTraining) {
                    event(.success(.training(.like)))
                } else if (NumberLaunches().count() % 3 == 0) {
                    event(.success(.requestReview))
                }
                
                return Disposables.create()
            }
            .asDriver(onErrorDriveWith: .never())
        
        let complete = didCompleteTraining
            .compactMap { training -> Route? in
                switch training {
                case .swipe:
                    UserDefaults.standard.set(true, forKey: Constants.swipeTraining)
                    return .training(.like)
                case .like:
                    UserDefaults.standard.set(true, forKey: Constants.likeTraining)
                    return (NumberLaunches().count() % 3 == 0) ? .requestReview : nil
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(initial, complete)
    }
}
