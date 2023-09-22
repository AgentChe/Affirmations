//
//  SoundsViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 22.09.2023.
//

import RxSwift
import RxCocoa

final class SoundsViewModel {
    enum Route {
        case selected(Sound)
        case play(String)
    }
    
    private let initialSelected: Driver<Sound>
    
    init(sound: Sound) {
        initialSelected = BehaviorRelay(value: sound).asDriver()
    }
}

// MARK: Public
extension SoundsViewModel {
    struct Input {
        let didTapContinue: Signal<Void>
        let didSelect: Signal<SoundsTableElement>
    }
    
    struct Output {
        let elements: Driver<[SoundsTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements()
        
        return Output(
            elements: elements,
            route: makeRoute(
                didTapContinue: input.didTapContinue,
                elements: elements,
                didSelect: input.didSelect
            )
        )
    }
}

// MARK: Private
private extension SoundsViewModel {
    func makeElements() -> Driver<[SoundsTableElement]> {
        initialSelected
            .map { selected -> [SoundsTableElement] in
                Sound.allCases
                    .map { sound -> SoundsTableElement in
                        SoundsTableElement(
                            sound: sound,
                            marked: selected == sound
                        )
                    }
            }
    }
    
    func makeRoute(
        didTapContinue: Signal<Void>,
        elements: Driver<[SoundsTableElement]>,
        didSelect: Signal<SoundsTableElement>
    ) -> Driver<Route> {
        let selected = didTapContinue
            .withLatestFrom(elements)
            .compactMap {
                $0.first(where: { $0.marked })?.sound
            }
            .map { Route.selected($0) }
            .asDriver(onErrorDriveWith: .never())
        let play = didSelect
            .compactMap { $0.sound.file }
            .map { Route.play($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(selected, play)
    }
}
