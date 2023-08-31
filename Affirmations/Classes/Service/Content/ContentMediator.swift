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
}

// MARK: Public
extension ContentMediator {
    func changeSelectedCategory() {
        DispatchQueue.main.async {
            Self.shared.didChangeSelectedCategoryTrigger.accept(Void())
        }
    }
    
    var didChangeSelectedCategory: Signal<Void> {
        didChangeSelectedCategoryTrigger.asSignal()
    }
}
