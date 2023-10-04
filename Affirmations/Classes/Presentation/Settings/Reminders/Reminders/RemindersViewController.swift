//
//  RemindersViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import UIKit
import RxSwift

final class RemindersViewController: UIViewController {
    lazy var mainView = RemindersView()
    
    private lazy var viewModel = RemindersViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: RemindersViewModel.Input(
            didChangeEnable: mainView.tableView.didChangeEnable,
            didSelect: mainView.tableView.didSelect,
            didTapButton: mainView.button.rx.tap.asSignal(),
            didTapProblem: mainView.tableView.didTapProblem
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.buttonHidden
            .drive(Binder(mainView) { base, hidden in
                base.button(hidden: hidden)
            })
            .disposed(by: disposeBag)
        
        output.buttonTitle
            .drive(Binder(mainView) { base, title in
                base.setup(buttonTitle: title)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension RemindersViewController {
    static func make() -> RemindersViewController {
        let vc = RemindersViewController()
        vc.navigationItem.title = "Reminders.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension RemindersViewController {
    func route(_ route: RemindersViewModel.Route) {
        switch route {
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .create:
            let vc = EditReminderViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .edit(let reminder):
            let vc = EditReminderViewController.make(reminder: reminder)
            navigationController?.pushViewController(vc, animated: true)
        case .problem:
            let vc = NotificationsProblemViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
