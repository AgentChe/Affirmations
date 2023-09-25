//
//  LanguageViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 25.09.2023.
//

import UIKit
import RxSwift

final class LanguageViewController: UIViewController {
    lazy var mainView = LanguageView()
    
    private lazy var viewModel = LanguageViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let didTapContinue = mainView.button.rx.tap
            .compactMap { [weak self] in
                self?.mainView.tableView.elements.first(where: { $0.marked })?.language
            }
            .asSignal(onErrorSignalWith: .never())
        
        let output = viewModel.configure(input: LanguageViewModel.Input(
            didTapContinue: didTapContinue
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
    }
}

// MARK: Public
extension LanguageViewController {
    static func make() -> LanguageViewController {
        let vc = LanguageViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Language.Title".localized
        return vc
    }
}

// MARK: Private
private extension LanguageViewController {
    func route(_ route: LanguageViewModel.Route) {
        switch route {
        case .confirm(let language):
            let alert = UIAlertController(
                title: nil,
                message: "Language.Confirm.Text".localized,
                preferredStyle: .alert
            )
            let yesAction = UIAlertAction(title: "Language.Confirm.Yes".localized, style: .default) { action in
                Localizable.shared.currentLanguage = language
                exit(0)
            }
            let noAction = UIAlertAction(title: "Language.Confirm.No".localized, style: .cancel)
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true)
        }
    }
}
