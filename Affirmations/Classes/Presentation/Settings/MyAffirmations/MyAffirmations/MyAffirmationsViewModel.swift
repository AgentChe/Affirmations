//
//  MyAffirmationsViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 25.09.2023.
//

import RxSwift
import RxCocoa

final class MyAffirmationsViewModel {
    private lazy var contentManager = ContentManager()
}

// MARK: Public
extension MyAffirmationsViewModel {
    struct Input {
        let didTapRemove: Signal<Affirmation>
        let didTapSave: Signal<Affirmation>
        let didCreate: Signal<String>
        let didEdit: Signal<Affirmation>
    }
    
    struct Output {
        let elements: Driver<[Affirmation]>
        let isEmpty: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements(
            didRemove: input.didTapRemove,
            didCreate: input.didCreate,
            didEdit: input.didEdit,
            didTapSave: input.didTapSave
        )
        
        return Output(
            elements: elements,
            isEmpty: elements.map { $0.isEmpty }.startWith(false)
        )
    }
}

// MARK: Private
private extension MyAffirmationsViewModel {
    enum Action {
        case remove(Affirmation)
        case create(Affirmation)
        case edit(Affirmation)
    }
    
    func makeElements(
        didRemove: Signal<Affirmation>,
        didCreate: Signal<String>,
        didEdit: Signal<Affirmation>,
        didTapSave: Signal<Affirmation>
    ) -> Driver<[Affirmation]> {
        let remove = didRemove
            .flatMapLatest { [weak self] affirmation -> Driver<Action> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .delete(affirmation: affirmation.message)
                    .asDriver(onErrorDriveWith: .never())
                    .map { .remove(affirmation) }
            }
        
        let create = didCreate
            .flatMapFirst { [weak self] affirmation -> Driver<Action> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .create(affirmation: affirmation)
                    .asDriver(onErrorDriveWith: .never())
                    .map { .create($0) }
            }
        
        let save = didTapSave
            .flatMapLatest { [weak self] affirmation -> Driver<Action> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .save(affirmation: affirmation.message)
                    .asDriver(onErrorDriveWith: .never())
                    .flatMap { void -> Driver<Action> in
                        .never()
                    }
            }
        
        let edit = didEdit
            .flatMapLatest { [weak self] affirmation -> Driver<Action> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .edit(affirmation: affirmation)
                    .asDriver(onErrorDriveWith: .never())
                    .map { .edit($0) }
            }
        
        let action = Driver
            .merge(remove, create, save, edit)
        
        return contentManager
            .obtainMyAffirmations()
            .asDriver(onErrorJustReturn: [])
            .flatMapLatest { affirmations -> Driver<[Affirmation]> in
                action
                    .scan(affirmations) { array, action -> [Affirmation] in
                        var result = array
                        
                        switch action {
                        case .remove(let affirmation):
                            result.removeAll(where: { $0.message == affirmation.message })
                        case .create(let affirmation):
                            result.append(affirmation)
                        case .edit(let affirmation):
                            if let index = result.firstIndex(where: { $0.id == affirmation.id }) {
                                result[index] = affirmation
                            }
                        }
                        
                        return result
                    }
                    .startWith(affirmations)
                    .map { affirmations -> [Affirmation] in
                        affirmations.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                    }
            }
    }
}
