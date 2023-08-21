//
//  PaygateMediator.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 06.03.2023.
//

import RxSwift
import RxCocoa

final class PaygateMediator {
    static let shared = PaygateMediator()
    
    private lazy var didPurchasedTrigger = PublishRelay<Void>()
    private lazy var didPaygateClosedTrigger = PublishRelay<Void>()
    
    private init() {}
}

// MARK: Public
extension PaygateMediator {
    func purchased() {
        DispatchQueue.main.async {
            Self.shared.didPurchasedTrigger.accept(Void())
        }
    }
    
    func closed() {
        DispatchQueue.main.async {
            Self.shared.didPaygateClosedTrigger.accept(Void())
        }
    }
}

// MARK: Triggers
extension PaygateMediator {
    var didPurchased: Signal<Void> {
        didPurchasedTrigger.asSignal()
    }
    
    var didPaygateClosed: Signal<Void> {
        didPaygateClosedTrigger.asSignal()
    }
}
