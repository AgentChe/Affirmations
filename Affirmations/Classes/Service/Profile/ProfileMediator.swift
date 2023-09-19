//
//  ProfileMediator.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 19.09.2023.
//

import RxSwift
import RxCocoa

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private lazy var didChangeGenderTrigger = PublishRelay<Gender>()
    
    private init() {}
}

// MARK: Public
extension ProfileMediator {
    func changed(gender: Gender) {
        didChangeGenderTrigger.accept(gender)
    }
    
    var didChangeGender: Signal<Gender> {
        didChangeGenderTrigger.asSignal()
    }
}
