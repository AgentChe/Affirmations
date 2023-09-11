//
//  PracticeViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 08.09.2023.
//

import RxSwift
import RxCocoa

final class PracticeViewModel {
    private lazy var contentManager = ContentManager()
    private lazy var profileManager = ProfileManager()
}

// MARK: Public
extension PracticeViewModel {
    struct Input {
        let didSelectTime: Signal<Int>
        let currentAffirmation: Signal<String>
        let currentIndex: Signal<Int>
        let didTapMark: Signal<Void>
    }
    
    struct Output {
        let affirmations: Driver<[String]>
        let marked: Driver<Bool>
        let progress: Driver<String>
        let secondsForAffirmation: Driver<Int>
    }
    
    func configure(input: Input) -> Output {
        let selectedCategory = makeSelectedCategory()
        let gender = makeGender()
        let affirmations = makeAffirmations(
            category: selectedCategory,
            gender: gender
        )
        let elements = makeElements(
            affirmations: affirmations,
            minutes: input.didSelectTime
        )
        let favoritesAffirmations = makeFavoritesAffirmations()
        
        return Output(
            affirmations: elements,
            marked: makeMarked(
                currentAffirmation: input.currentAffirmation,
                favoritesAffirmation: favoritesAffirmations,
                didTapMark: input.didTapMark
            ),
            progress: makeProgress(
                currentIndex: input.currentIndex,
                affirmationsCount: elements.map { $0.count }
            ),
            secondsForAffirmation: makeSecondsForAffirmation(minutes: input.didSelectTime)
        )
    }
}

// MARK: Private
private extension PracticeViewModel {
    func makeSecondsForAffirmation(minutes: Signal<Int>) -> Driver<Int> {
        minutes
            .map { minutes -> Int in
                let totalCount = minutes * 6
                let totalSeconds = minutes * 60
                
                return totalSeconds / totalCount
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeProgress(
        currentIndex: Signal<Int>,
        affirmationsCount: Driver<Int>
    ) -> Driver<String> {
        Driver
            .combineLatest(
                currentIndex.asDriver(onErrorDriveWith: .never()),
                affirmationsCount
            )
            .map { index, count -> String in
                String(format: "Practice.Progress".localized, index + 1, count)
            }
    }
    
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
    
    func makeSelectedCategory() -> Driver<Category> {
        contentManager
            .obtainSelectedCategory(for: Localizable.shared.currentLanguage)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeElements(affirmations: Driver<[String]>, minutes: Signal<Int>) -> Driver<[String]> {
        Driver
            .combineLatest(affirmations, minutes.asDriver(onErrorDriveWith: .never()))
            .map { affirmations, minutes -> [String] in
                let totalCount = minutes * 6
                
                func generate(_ input: [String]) -> [String] {
                    let count = input.count
                    
                    if count >= totalCount {
                        return Array(input.prefix(totalCount))
                    }
                    
                    let diff = totalCount - count
                    
                    var source = affirmations
                    source.shuffle()
                    
                    let result = input + Array(source.prefix(diff))
                    return generate(result)
                }
                
                return generate(affirmations)
            }
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
                    .map { $0.map { $0.message } }
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeFavoritesAffirmations() -> Driver<[String]> {
        contentManager
            .obtainFavoritesAffirmations()
            .map { $0.map { $0.message } }
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
