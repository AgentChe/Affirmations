//
//  ContentMediator.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 31.08.2023.
//

import RxSwift
import RxCocoa

final class ContentMediator {
    static let shared = ContentMediator()
    
    private init() {}
    
    private lazy var didChangeSelectedCategoryTrigger = PublishRelay<Void>()
    private lazy var didSaveAffirmationTrigger = PublishRelay<String>()
    private lazy var didUnsaveAffirmationTrigger = PublishRelay<String>()
    private lazy var didReplaceFavoritesTrigger = PublishRelay<Void>()
    private lazy var didCreateAffirmationTrigger = PublishRelay<String>()
    private lazy var didDeleteAffirmationTrigger = PublishRelay<String>()
    private lazy var didReplaceMyTrigger = PublishRelay<Void>()
}

// MARK: Public
extension ContentMediator {
    func changeSelectedCategory() {
        DispatchQueue.main.async {
            Self.shared.didChangeSelectedCategoryTrigger.accept(Void())
        }
    }
    
    func save(affirmation: String) {
        DispatchQueue.main.async {
            Self.shared.didSaveAffirmationTrigger.accept(affirmation)
        }
    }
    
    func unsave(affirmation: String) {
        DispatchQueue.main.async {
            Self.shared.didUnsaveAffirmationTrigger.accept(affirmation)
        }
    }
    
    func replaceFavorites() {
        DispatchQueue.main.async {
            Self.shared.didReplaceFavoritesTrigger.accept(Void())
        }
    }
    
    func create(affirmation: String) {
        DispatchQueue.main.async {
            Self.shared.didCreateAffirmationTrigger.accept(affirmation)
        }
    }
    
    func delete(affirmation: String) {
        DispatchQueue.main.async {
            Self.shared.didDeleteAffirmationTrigger.accept(affirmation)
        }
    }
    
    func replaceMy() {
        DispatchQueue.main.async {
            Self.shared.didReplaceMyTrigger.accept(Void())
        }
    }
    
    var didChangeSelectedCategory: Signal<Void> {
        didChangeSelectedCategoryTrigger.asSignal()
    }
    
    var didSaveAffirmation: Signal<String> {
        didSaveAffirmationTrigger.asSignal()
    }
    
    var didUnsaveAffirmation: Signal<String> {
        didUnsaveAffirmationTrigger.asSignal()
    }
    
    var didReplacedFavorites: Signal<Void> {
        didReplaceFavoritesTrigger.asSignal()
    }
    
    var didCreateAffirmation: Signal<String> {
        didCreateAffirmationTrigger.asSignal()
    }
    
    var didDeleteAffirmation: Signal<String> {
        didDeleteAffirmationTrigger.asSignal()
    }
    
    var didReplacedMy: Signal<Void> {
        didReplaceMyTrigger.asSignal()
    }
}
