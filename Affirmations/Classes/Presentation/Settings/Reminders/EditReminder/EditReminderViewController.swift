//
//  EditReminderViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class EditReminderViewController: UIViewController {
    lazy var mainView = EditReminderView()
    
    private let viewModel: EditReminderViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectCategoriesTrigger = PublishRelay<[Category]>()
    private lazy var didSelectSoundTrigger = PublishRelay<Sound>()
    
    private init(reminder: Reminder?) {
        viewModel = EditReminderViewModel(reminder: reminder)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: EditReminderViewModel.Input(
            didSelectElement: mainView.tableView.didSelect,
            didSelectCategories: didSelectCategoriesTrigger.asSignal(),
            didSelectSound: didSelectSoundTrigger.asSignal(),
            didTapSave: mainView.button.rx.tap.asSignal(),
            didChangeInnerSelection: mainView.tableView.didChangeInnerSelection
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
        
        output.enable
            .drive(Binder(mainView.button) { base, enable in
                base.isEnabled = enable
                base.alpha = enable ? 1 : 0.4
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension EditReminderViewController {
    static func make(reminder: Reminder? = nil) -> EditReminderViewController {
        let vc = EditReminderViewController(reminder: reminder)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "EditReminder.Title".localized
        return vc
    }
}

// MARK: Private
private extension EditReminderViewController {
    func route(_ route: EditReminderViewModel.Route) {
        switch route {
        case .categories(let categories):
            let vc = CategoriesUnitsViewController.make(categories: categories) { [weak self] selected in
                self?.didSelectCategoriesTrigger.accept(selected)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .sound(let sound):
            let vc = SoundsViewController.make(sound: sound) { [weak self] selected in
                self?.didSelectSoundTrigger.accept(selected)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .saved:
            navigationController?.popViewController(animated: true)
        }
    }
}
