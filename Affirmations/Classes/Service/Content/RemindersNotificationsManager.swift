//
//  RemindersNotificationsManager.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 23.09.2023.
//

import UserNotifications
import RxSwift
import RxCocoa

final class RemindersNotificationsManager {
    static let shared = RemindersNotificationsManager()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var center = UNUserNotificationCenter.current()
    
    private init() {}
}

// MARK: Public
extension RemindersNotificationsManager {
    enum Constants {
        static let affirmations = "reminders_notifications_manager_affirmations_key"
    }
    
    func register() {
        Signal
            .combineLatest(
                Signal.merge(
                    ContentMediator.shared
                        .didAddedReminder,
                    ContentMediator.shared
                        .didChangedReminder
                ),
                ProfileMediator.shared
                    .didChangeGender,
                ProfileMediator.shared
                    .didChangeLanguage
            )
            .flatMapLatest { reminder, gender, language -> Signal<[Affirmation]> in
                let requests = reminder.categories
                    .map {
                        Self.shared.contentManager
                            .obtainAffirmations(for: language, categoryType: $0.type, gender: gender.rawValue)
                    }
                
                return Single
                    .zip(requests)
                    .map { array -> [Affirmation] in
                        let joined = array.reduce([]) { $0 + $1 }
                        let set = Set(joined)
                        return Array(set)
                    }
                    .asSignal(onErrorJustReturn: [])
            }
            .emit(to: Binder(self) { base, affirmations in
                
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension RemindersNotificationsManager {
    func add(reminder: Reminder, affirmations: [Affirmation]) {
        guard reminder.enable else { return }
        
        var source = affirmations
        source.shuffle()
        
        for i in 0...(reminder.count - 1) {
            if source.isEmpty {
                source = affirmations
                source.shuffle()
            }
            
            let affirmation = source.removeFirst()
            
            let content = UNMutableNotificationContent()
            content.body = affirmation.message
            if let soundFile = reminder.sound.file {
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(soundFile).mp3"))
            }
            
//            ((21 - 9) * 60  / (10 - 1)) =  80 (минут)
            

        }
        
        
//        var dateMatching: DateComponents {
//            switch event.repeatMode {
//            case .never:
//                return calendar.dateComponents([.hour, .minute, .day, .month, .year], from: event.date)
//            case .daily:
//                return calendar.dateComponents([.hour, .minute], from: event.date)
//            case .weekly:
//                return calendar.dateComponents([.hour, .minute, .weekday], from: event.date)
//            case .monthly:
//                return calendar.dateComponents([.hour, .minute, .day, .weekOfMonth], from: event.date)
//            case .yearly:
//                return calendar.dateComponents([.hour, .minute, .day, .month, .month], from: event.date)
//            }
//        }
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: repeats)
//
//        let request = UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)
//        center.add(request)
    }
    
    func delete(reminderId: String) {
        center.removeDeliveredNotifications(withIdentifiers: [reminderId])
        center.removePendingNotificationRequests(withIdentifiers: [reminderId])
    }
}
