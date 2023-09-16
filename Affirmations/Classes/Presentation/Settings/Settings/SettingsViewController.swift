//
//  SettingsViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 11.09.2023.
//

import UIKit
import RxSwift

final class SettingsViewController: UIViewController {
    lazy var mainView = SettingsView()
    
    private lazy var viewModel = SettingsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.didSelect
            .emit(to: Binder(self) { base, element in
                base.select(element: element)
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: SettingsViewModel.Input())
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SettingsViewController {
    static func make() -> SettingsViewController {
        let vc = SettingsViewController()
        vc.navigationItem.title = "Settings.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SettingsViewController {
    func select(element: SettingsTableElement) {
        switch element {
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .route(let route):
            switch route {
            case .gender:
                break
            }
        case .backup:
            let vc = BackupViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
