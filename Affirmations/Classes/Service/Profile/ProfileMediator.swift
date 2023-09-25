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
    private lazy var didChangeLanguageTrigger = PublishRelay<ApplicationLanguage>()
    
    private init() {}
}

// MARK: Public
extension ProfileMediator {
    func changed(gender: Gender) {
        didChangeGenderTrigger.accept(gender)
    }
    
    func changed(language: ApplicationLanguage) {
        didChangeLanguageTrigger.accept(language)
    }
    
    var didChangeGender: Signal<Gender> {
        didChangeGenderTrigger.asSignal()
    }
    
    var didChangeLanguage: Signal<ApplicationLanguage> {
        didChangeLanguageTrigger.asSignal()
    }
}
