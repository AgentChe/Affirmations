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
    
    var didChangeSelectedCategory: Signal<Void> {
        didChangeSelectedCategoryTrigger.asSignal()
    }
    
    var didSaveAffirmation: Signal<String> {
        didSaveAffirmationTrigger.asSignal()
    }
    
    var didUnsaveAffirmation: Signal<String> {
        didUnsaveAffirmationTrigger.asSignal()
    }
}
