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
    private lazy var didCreateAffirmationTrigger = PublishRelay<Affirmation>()
    private lazy var didEditAffirmationTrigger = PublishRelay<Affirmation>()
    private lazy var didDeleteAffirmationTrigger = PublishRelay<String>()
    private lazy var didReplaceMyTrigger = PublishRelay<Void>()
    private lazy var didReplaceRemindersTrigger = PublishRelay<Void>()
    private lazy var didChangedReminderTrigger = PublishRelay<Reminder>()
    private lazy var didAddedReminderTrigger = PublishRelay<Reminder>()
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
    
    func create(affirmation: Affirmation) {
        DispatchQueue.main.async {
            Self.shared.didCreateAffirmationTrigger.accept(affirmation)
        }
    }
    
    func edit(affirmation: Affirmation) {
        DispatchQueue.main.async {
            Self.shared.didEditAffirmationTrigger.accept(affirmation)
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
    
    func replaceReminders() {
        DispatchQueue.main.async {
            Self.shared.didReplaceRemindersTrigger.accept(Void())
        }
    }
    
    func change(reminder: Reminder) {
        DispatchQueue.main.async {
            Self.shared.didChangedReminderTrigger.accept(reminder)
        }
    }
    
    func add(reminder: Reminder) {
        DispatchQueue.main.async {
            Self.shared.didAddedReminderTrigger.accept(reminder)
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
    
    var didCreateAffirmation: Signal<Affirmation> {
        didCreateAffirmationTrigger.asSignal()
    }
    
    var didEditAffirmation: Signal<Affirmation> {
        didEditAffirmationTrigger.asSignal()
    }
    
    var didDeleteAffirmation: Signal<String> {
        didDeleteAffirmationTrigger.asSignal()
    }
    
    var didReplacedMy: Signal<Void> {
        didReplaceMyTrigger.asSignal()
    }
    
    var didReplaceReminders: Signal<Void> {
        didReplaceRemindersTrigger.asSignal()
    }
    
    var didChangedReminder: Signal<Reminder> {
        didChangedReminderTrigger.asSignal()
    }
    
    var didAddedReminder: Signal<Reminder> {
        didAddedReminderTrigger.asSignal()
    }
}
