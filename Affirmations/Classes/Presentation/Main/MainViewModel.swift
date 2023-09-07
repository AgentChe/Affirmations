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
    private lazy var profileManager = ProfileManager()
}

// MARK: Public
extension MainViewModel {
    struct Input {
        let didCompleteTraining: Signal<TrainingView.Training>
        let currentAffirmation: Signal<String>
        let didTapMark: Signal<Void>
    }
    
    struct Output {
        let activeSubsription: Driver<Bool>
        let selectedCategoryName: Driver<String>
        let route: Driver<Route>
        let affirmations: Driver<[String]>
        let marked: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let selectedCategory = makeSelectedCategory()
        let gender = makeGender()
        let affirmations = makeAffirmations(
            category: selectedCategory,
            gender: gender
        )
        let favoritesAffirmations = makeFavoritesAffirmations()
        
        return Output(
            activeSubsription: makeActiveSubscription(),
            selectedCategoryName: selectedCategory.map { $0.name },
            route: makeRoute(didCompleteTraining: input.didCompleteTraining),
            affirmations: affirmations,
            marked: makeMarked(
                currentAffirmation: input.currentAffirmation,
                favoritesAffirmation: favoritesAffirmations,
                didTapMark: input.didTapMark
            )
        )
    }
}

// MARK: Private
private extension MainViewModel {
    func makeMarked(
        currentAffirmation: Signal<String>,
        favoritesAffirmation: Driver<[String]>,
        didTapMark: Signal<Void>
    ) -> Driver<Bool> {
        let marked = Driver
            .combineLatest(
                currentAffirmation.asDriver(onErrorDriveWith: .never()),
                favoritesAffirmation
            )
            .map { current, affirmations -> Bool in
                affirmations.contains(current)
            }
        
        let action = didTapMark
            .withLatestFrom(marked)
            .withLatestFrom(currentAffirmation) { ($0, $1) }
            .flatMapLatest { [weak self] (args) -> Driver<Bool> in
                guard let self else {
                    return .never()
                }
                
                let (marked, affirmation) = args
                
                let result = marked ? self.contentManager.unsave(affirmation: affirmation) : self.contentManager.save(affirmation: affirmation)
                return result
                    .asDriver(onErrorDriveWith: .never())
                    .flatMap { void -> Driver<Bool> in .never() }
            }
        
        return Driver
            .merge(marked, action)
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
    
    func makeAffirmations(category: Driver<Category>, gender: Driver<Gender>) -> Driver<[String]> {
        Driver
            .combineLatest(category, gender)
            .flatMapLatest { [weak self] category, gender -> Driver<[String]> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainAffirmations(
                        for: Localizable.shared.currentLanguage,
                        categoryType: category.type,
                        gender: gender.rawValue
                    )
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeFavoritesAffirmations() -> Driver<[String]> {
        contentManager
            .obtainFavoritesAffirmations()
            .asDriver(onErrorDriveWith: .never())
            .flatMap { affirmations -> Driver<[String]> in
                Signal
                    .merge(
                        ContentMediator.shared.didSaveAffirmation.map { ($0, true) },
                        ContentMediator.shared.didUnsaveAffirmation.map { ($0, false) }
                    )
                    .scan(affirmations) { result, signal -> [String] in
                        let (affirmation, save) = signal
                        
                        var affirmations = result
                        
                        switch save {
                        case true:
                            affirmations.append(affirmation)
                        case false:
                            affirmations.removeAll(where: { $0 == affirmation })
                        }
                        
                        return affirmations
                    }
                    .startWith(affirmations)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeGender() -> Driver<Gender> {
        profileManager
            .obtainGender()
            .map { $0 ?? .other }
            .asDriver(onErrorJustReturn: .other)
    }
}
