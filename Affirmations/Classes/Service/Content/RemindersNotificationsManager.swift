//
//  RemindersNotificationsManager.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 23.09.2023.
//

import UserNotifications
import RxSwift

final class RemindersNotificationsManager {
    static let shared = RemindersNotificationsManager()
    
    private lazy var contentManager = ContentManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var center = UNUserNotificationCenter.current()
    
    private init() {}
}

// MARK: Public
extension RemindersNotificationsManager {
    func register() {
        makePlan()
            .bind(to: Binder(self) { base, plans in
                let sorted = plans.sorted(by: { $0.trigger.compare($1.trigger) == .orderedAscending })
                base.register(plans: sorted)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension RemindersNotificationsManager {
    func register(plans: [PlanPushAffirmation]) {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        
        let calendar = Calendar.current
        
        plans.forEach { plan in
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(plan.reminder.sound).mp3"))
            content.body = plan.affirmation
            
            let components = calendar.dateComponents([.year, .month, .weekOfMonth, .weekday, .hour, .minute], from: plan.trigger)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: plan.id,
                content: content,
                trigger: trigger
            )
            
            center.add(request)
        }
    }
    
    func makePlan() -> Observable<[PlanPushAffirmation]> {
        makeData()
            .map { data -> [PlanPushAffirmation] in
                let (reminders, affirmations) = data
                
                var messages = affirmations.map { $0.message }
                messages.shuffle()
                
                func get() -> String {
                    if messages.isEmpty {
                        var messages = affirmations.map { $0.message }
                        messages.shuffle()
                    }
                    
                    if messages.isEmpty {
                        return ""
                    }
                    
                    return messages.removeFirst()
                }
                
                var calendar = Calendar.current
                calendar.firstWeekday = 1
                
                var result = [PlanPushAffirmation?]()
                
                let currentDate = Date()
                
                func make(reminder: Reminder, weekday: Int) {
                    var components = calendar.dateComponents([.year, .month, .weekOfMonth], from: currentDate)
                    components.weekday = weekday
                    components.minute = 0
                    components.hour = reminder.start
                    
                    let startDate = calendar.date(from: components)
                    
                    components.hour = reminder.end
                    
                    let endDate = calendar.date(from: components)
                    
                    guard var startDate, let endDate else {
                        return
                    }
                    
                    var interval: Int {
                        guard reminder.count > 1 else {
                            return (reminder.end - reminder.start) * 60 + 1
                        }
                        
                        return ((reminder.end - reminder.start) * 60 / (reminder.count - 1))
                    }
                    
                    while startDate <= endDate {
                        if startDate >= currentDate {
                            let plan = PlanPushAffirmation(
                                id: UUID().uuidString,
                                affirmation: get(),
                                reminder: reminder,
                                trigger: startDate
                            )
                            result.append(plan)
                        }
                        
                        if let nextTrigger = calendar.date(byAdding: .day, value: 7, to: startDate) {
                            let plan = PlanPushAffirmation(
                                id: UUID().uuidString,
                                affirmation: get(),
                                reminder: reminder,
                                trigger: nextTrigger
                            )
                            result.append(plan)
                        }
                        
                        startDate = calendar.date(byAdding: .minute, value: interval, to: startDate) ?? endDate
                    }
                }
                
                reminders.forEach { reminder in
                    if reminder.weekSchedule.su {
                        make(reminder: reminder, weekday: 1)
                    }
                    if reminder.weekSchedule.mo {
                        make(reminder: reminder, weekday: 2)
                    }
                    if reminder.weekSchedule.tu {
                        make(reminder: reminder, weekday: 3)
                    }
                    if reminder.weekSchedule.we {
                        make(reminder: reminder, weekday: 4)
                    }
                    if reminder.weekSchedule.th {
                        make(reminder: reminder, weekday: 5)
                    }
                    if reminder.weekSchedule.fr {
                        make(reminder: reminder, weekday: 6)
                    }
                    if reminder.weekSchedule.sa {
                        make(reminder: reminder, weekday: 7)
                    }
                }
                
                return result
                    .compactMap { $0 }
            }
    }
    
    func makeData() -> Observable<([Reminder], [Affirmation])> {
        Observable
            .combineLatest(
                makeGender(),
                makeLanguage(),
                makeReminders()
            )
            .flatMapLatest { [weak self] gender, language, reminders -> Observable<([Reminder], [Affirmation])> in
                guard let self else {
                    return .never()
                }
                
                let join = reminders
                    .compactMap { reminder -> Single<[Affirmation]> in
                        let join = reminder
                            .categories
                            .compactMap { category -> Single<[Affirmation]> in
                                self.contentManager
                                    .obtainAffirmations(
                                        for: language,
                                        categoryType: category.type,
                                        gender: gender.rawValue
                                    )
                            }
                        return Single
                            .zip(join)
                            .map { array -> [Affirmation] in
                                array.reduce([]) { $0 + $1 }
                            }
                    }
                let affirmations = Single
                    .zip(join)
                    .map { array -> [Affirmation] in
                        array.reduce([]) { $0 + $1 }
                    }
                    .asObservable()
                
                return Observable
                    .combineLatest(
                        Observable<[Reminder]>.just(reminders),
                        affirmations
                    )
                    .map { ($0, $1) }
            }
    }
    
    func makeReminders() -> Observable<[Reminder]> {
        ContentMediator.shared
            .didReplaceReminders
            .startWith(())
            .asObservable()
            .flatMapLatest { [weak self] void -> Observable<[Reminder]> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainReminders()
                    .map { $0.filter { $0.enable } }
                    .asObservable()
            }
    }
    
    func makeLanguage() -> Observable<ApplicationLanguage> {
        ProfileMediator.shared
            .didChangeLanguage
            .startWith(Localizable.shared.currentLanguage)
            .asObservable()
    }
    
    func makeGender() -> Observable<Gender> {
        let initial = profileManager
            .obtainGender()
            .compactMap { $0 }
            .asObservable()
        let update = ProfileMediator.shared
            .didChangeGender
            .asObservable()
        
        return Observable
            .merge(initial, update)
    }
}
