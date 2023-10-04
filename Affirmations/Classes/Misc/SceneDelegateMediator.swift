//
//  SceneDelegateMediator.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 04.10.2023.
//

import RxSwift
import RxCocoa

final class SceneDelegateMediator {
    static let shared = SceneDelegateMediator()
    
    private lazy var didBecomeActiveTrigger = PublishRelay<Void>()
    
    private init() {}
}

// MARK: Public
extension SceneDelegateMediator {
    func becomeActive() {
        didBecomeActiveTrigger.accept(Void())
    }
    
    var didBecomeActive: Signal<Void> {
        didBecomeActiveTrigger.asSignal()
    }
}
