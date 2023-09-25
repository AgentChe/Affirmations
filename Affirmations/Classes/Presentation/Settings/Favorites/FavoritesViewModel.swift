//
//  FavoritesViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 25.09.2023.
//

import RxSwift
import RxCocoa

final class FavoritesViewModel {
    enum Route {
        case menu(Affirmation)
    }
    
    private lazy var contentManager = ContentManager()
}

// MARK: Public
extension FavoritesViewModel {
    struct Input {
        let didTapMenu: Signal<Affirmation>
        let didRemove: Signal<Affirmation>
    }
    
    struct Output {
        let elements: Driver<[Affirmation]>
        let route: Driver<Route>
        let isEmpty: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements(didRemove: input.didRemove)
        
        return Output(
            elements: elements,
            route: makeRoute(didTapMenu: input.didTapMenu),
            isEmpty: elements.map { $0.isEmpty }.startWith(false)
        )
    }
}

// MARK: Private
private extension FavoritesViewModel {
    func makeElements(didRemove: Signal<Affirmation>) -> Driver<[Affirmation]> {
        let remove = didRemove
            .flatMapLatest { [weak self] affirmation -> Driver<Affirmation> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .unsave(affirmation: affirmation.message)
                    .asDriver(onErrorDriveWith: .never())
                    .map { affirmation }
            }
        
        return contentManager
            .obtainFavoritesAffirmations()
            .asDriver(onErrorJustReturn: [])
            .flatMapLatest { affirmations -> Driver<[Affirmation]> in
                remove
                    .scan(affirmations) { array, remove -> [Affirmation] in
                        var result = array
                        result.removeAll(where: { $0.message == remove.message })
                        return result
                    }
                    .startWith(affirmations)
            }
    }
    
    func makeRoute(didTapMenu: Signal<Affirmation>) -> Driver<Route> {
        didTapMenu
            .map { Route.menu($0) }
            .asDriver(onErrorDriveWith: .never())
    }
}
