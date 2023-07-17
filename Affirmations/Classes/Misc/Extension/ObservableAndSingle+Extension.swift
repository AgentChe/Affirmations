//
//  ObservableAndSingleExtension.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 29.03.2022.
//

import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        map { _ -> Void in
            Void()
        }
    }
    
    func materialize(with retryTrigger: Observable<Void>) -> Observable<Event<Element>> {
        materialize()
            .flatMap { event -> Observable<Event<Element>> in
                guard let error = event.error else {
                    return .just(event)
                }
                
                let second: Observable<Event<Element>> = .error(error)
                return .just(event).concat(second)
            }
            .retry { $0.flatMap { _ in retryTrigger }}
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    func mapToVoid() -> Single<Void> {
        map { _ -> Void in
            Void()
        }
    }
}
