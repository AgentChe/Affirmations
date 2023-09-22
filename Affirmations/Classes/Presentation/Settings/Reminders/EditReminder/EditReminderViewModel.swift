//
//  EditReminderViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import RxSwift
import RxCocoa

final class EditReminderViewModel {
    enum Route {
        case categories([Category])
        case sound(Sound)
        case saved
    }
    
    private let reminder: Reminder?
    private let settings: EditReminderSettings
    private let schedule: EditReminderSchedule
    
    private lazy var contentManager = ContentManager()
    
    init(reminder: Reminder?) {
        self.reminder = reminder
        self.settings = EditReminderSettings(
            count: reminder?.count ?? 0,
            start: reminder?.start ?? 15,
            end: reminder?.end ?? 16
        )
        self.schedule = EditReminderSchedule(selectedDays: [
            reminder?.weekSchedule.su == true ? .su : nil,
            reminder?.weekSchedule.mo == true ? .mo : nil,
            reminder?.weekSchedule.tu == true ? .tu : nil,
            reminder?.weekSchedule.we == true ? .we : nil,
            reminder?.weekSchedule.th == true ? .th : nil,
            reminder?.weekSchedule.fr == true ? .fr : nil,
            reminder?.weekSchedule.sa == true ? .sa : nil
        ].compactMap { $0 })
    }
}

// MARK: Public
extension EditReminderViewModel {
    struct Input {
        let didSelectElement: Signal<EditReminderTableElement>
        let didSelectCategories: Signal<[Category]>
        let didSelectSound: Signal<Sound>
        let didTapSave: Signal<Void>
        let didChangeInnerSelection: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[EditReminderTableElement]>
        let route: Driver<Route>
        let enable: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let selectedCategories = input.didSelectCategories
            .asDriver(onErrorJustReturn: [])
            .startWith(reminder?.categories ?? [])
        let selectedSound = input.didSelectSound
            .asDriver(onErrorDriveWith: .never())
            .startWith(reminder?.sound ?? .not)
        
        return Output(
            elements: makeElements(
                selectedCategories: selectedCategories,
                selectedSound: selectedSound
            ),
            route: makeRoute(
                didSelectElement: input.didSelectElement,
                selectedCategories: selectedCategories,
                selectedSound: selectedSound,
                didTapSave: input.didTapSave
            ),
            enable: makeEnable(
                didChangeInnerSelection: input.didChangeInnerSelection,
                selectedCategories: selectedCategories
            )
        )
    }
}

// MARK: Private
private extension EditReminderViewModel {
    func makeEnable(
        didChangeInnerSelection: Signal<Void>,
        selectedCategories: Driver<[Category]>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(
                didChangeInnerSelection.asDriver(onErrorDriveWith: .never()),
                selectedCategories
            )
            .map { [weak self] _, categories -> Bool in
                guard let self else {
                    return false
                }
                
                return !self.schedule.selectedDays.isEmpty && !categories.isEmpty
            }
    }
    
    func makeElements(
        selectedCategories: Driver<[Category]>,
        selectedSound: Driver<Sound>
    ) -> Driver<[EditReminderTableElement]> {
        Driver
            .combineLatest(
                selectedCategories,
                selectedSound
            )
            .map { [weak self] categories, sound -> [EditReminderTableElement] in
                guard let self else {
                    return []
                }
                
                return [
                    .categories(categories),
                    .settings(self.settings),
                    .schedule(self.schedule),
                    .sound(sound)
                ]
            }
    }
    
    func makeRoute(
        didSelectElement: Signal<EditReminderTableElement>,
        selectedCategories: Driver<[Category]>,
        selectedSound: Driver<Sound>,
        didTapSave: Signal<Void>
    ) -> Driver<Route> {
        let selected = didSelectElement
            .asDriver(onErrorDriveWith: .never())
            .compactMap { element -> Route? in
                switch element {
                case .categories(let categories):
                    return .categories(categories)
                case .sound(let sound):
                    return .sound(sound)
                default:
                    return nil
                }
            }
        
        let save = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(selectedCategories)
            .withLatestFrom(selectedSound) { ($0, $1) }
            .flatMapLatest { [weak self] args -> Driver<Route> in
                guard let self else {
                    return .never()
                }
                
                let (categories, sound) = args
                
                let schedule = WeekSchedule(
                    su: self.schedule.selectedDays.contains(where: { $0 == .su }),
                    mo: self.schedule.selectedDays.contains(where: { $0 == .mo }),
                    tu: self.schedule.selectedDays.contains(where: { $0 == .tu }),
                    we: self.schedule.selectedDays.contains(where: { $0 == .we }),
                    th: self.schedule.selectedDays.contains(where: { $0 == .th }),
                    fr: self.schedule.selectedDays.contains(where: { $0 == .fr }),
                    sa: self.schedule.selectedDays.contains(where: { $0 == .sa })
                )
                
                let reminder = Reminder(
                    id: self.reminder?.id ?? UUID().uuidString,
                    created: self.reminder?.created ?? Date(),
                    count: self.settings.count,
                    start: self.settings.start,
                    end: self.settings.end,
                    weekSchedule: schedule,
                    sound: sound,
                    categories: categories,
                    enable: reminder?.enable ?? true
                )
                
                return self.contentManager
                    .add(reminder: reminder)
                    .map { Route.saved }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(selected, save)
    }
}
