//
//  RemindersViewModel.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import RxSwift
import RxCocoa

final class RemindersViewModel {
    enum Route {
        case paygate
        case create
        case edit(Reminder)
        case problem
    }
    
    private lazy var contentManager = ContentManager()
    private lazy var iapManager = IAPManager()
}

// MARK: Public
extension RemindersViewModel {
    struct Input {
        let didChangeEnable: Signal<Reminder>
        let didSelect: Signal<Reminder>
        let didTapButton: Signal<Void>
        let didTapProblem: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[RemindersTableElement]>
        let route: Driver<Route>
        let buttonHidden: Driver<Bool>
        let buttonTitle: Driver<String>
    }
    
    func configure(input: Input) -> Output {
        let authorizationStatus = makeAuthorizationStatus()
        let activeSubscription = makeActiveSubscription()
        let reminders = makeReminders(didChangeEnable: input.didChangeEnable)
        let buttonState = makeButtonState(
            activeSubscription: activeSubscription,
            reminders: reminders
        )
        
        return Output(
            elements: makeElements(
                reminders: reminders,
                authorizationStatus: authorizationStatus
            ),
            route: makeRoute(
                didSelect: input.didSelect,
                didTapButton: input.didTapButton,
                buttonState: buttonState,
                didTapProblem: input.didTapProblem
            ),
            buttonHidden: makeButtonHidden(buttonState: buttonState),
            buttonTitle: makeButtonTitle(buttonState: buttonState)
        )
    }
}

// MARK: Private
private extension RemindersViewModel {
    enum ButtonState {
        case paygate, create, disable
    }
    
    func makeButtonState(
        activeSubscription: Driver<Bool>,
        reminders: Driver<[Reminder]>
    ) -> Driver<ButtonState> {
        Driver
            .combineLatest(activeSubscription, reminders)
            .map { activeSubscription, reminders -> ButtonState in
                activeSubscription ? (reminders.count < 10 ? .create : .disable) : (reminders.count < 2 ? .create : .paygate)
            }
    }
    
    func makeButtonHidden(buttonState: Driver<ButtonState>) -> Driver<Bool> {
        buttonState.map { state -> Bool in
            state == .disable
        }
    }
    
    func makeButtonTitle(buttonState: Driver<ButtonState>) -> Driver<String> {
        buttonState.map { state -> String in
            switch state {
            case .create:
                return "Reminders.AddButton".localized
            case .paygate:
                return "Reminders.UnlockButton".localized
            case .disable:
                return ""
            }
        }
    }
    
    func makeElements(
        reminders: Driver<[Reminder]>,
        authorizationStatus: Driver<PushNotificationsAuthorizationStatus>
    ) -> Driver<[RemindersTableElement]> {
        Driver
            .combineLatest(
                reminders,
                authorizationStatus
            )
            .map { reminders, authorizationStatus -> [RemindersTableElement] in
                var result = [RemindersTableElement]()
                
                if authorizationStatus != .authorized {
                    result.append(.problem)
                }
            
                reminders.forEach { result.append(.reminder($0)) }
            
                return result
            }
    }
    
    func makeReminders(didChangeEnable: Signal<Reminder>) -> Driver<[Reminder]> {
        let action = didChangeEnable
            .flatMapLatest { [weak self] reminder -> Driver<Void> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .add(reminder: reminder)
                    .asDriver(onErrorDriveWith: .never())
                    .flatMapLatest { .never() }
            }
        
        let triggers = Driver
            .merge(
                ContentMediator.shared
                    .didReplaceReminders
                    .startWith(())
                    .asDriver(onErrorDriveWith: .never()),
                
                action
            )
        
        return triggers
            .flatMapLatest { [weak self] void -> Driver<[Reminder]> in
                guard let self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainReminders()
                    .map { reminders -> [Reminder] in
                        reminders.sorted(by: { $0.created.compare($1.created) == .orderedAscending })
                    }
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeRoute(
        didSelect: Signal<Reminder>,
        didTapButton: Signal<Void>,
        buttonState: Driver<ButtonState>,
        didTapProblem: Signal<Void>
    ) -> Driver<Route> {
        let edit = didSelect
            .map { Route.edit($0) }
            .asDriver(onErrorDriveWith: .never())
        let tap = didTapButton
            .withLatestFrom(buttonState)
            .compactMap { state -> Route? in
                switch state {
                case .create:
                    return .create
                case .paygate:
                    return .paygate
                case .disable:
                    return nil
                }
            }
            .asDriver(onErrorDriveWith: .never())
        let problem = didTapProblem
            .map { Route.problem }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(edit, tap, problem)
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PaygateMediator.shared
            .didPurchased
            .startWith(Void())
            .compactMap { [weak self] void -> Bool? in
                self?.iapManager.hasActiveSubscriptions
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeAuthorizationStatus() -> Driver<PushNotificationsAuthorizationStatus> {
        SceneDelegateMediator.shared
            .didBecomeActive
            .startWith(())
            .flatMapLatest { void -> Driver<PushNotificationsAuthorizationStatus> in
                Single<PushNotificationsAuthorizationStatus>
                    .create { single in
                        PushNotificationsManager.shared.retriveAuthorizationStatus { status in
                            single(.success(status))
                        }
                        
                        return Disposables.create()
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
