//
//  CategoriesUnitsViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 22.09.2023.
//

import UIKit
import RxSwift

final class CategoriesUnitsViewController: UIViewController {
    lazy var mainView = CategoriesUnitsView()
    
    private let viewModel: CategoriesUnitsViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private let didSelect: ([Category]) -> Void
    
    private init(categories: [Category], didSelect: @escaping ([Category]) -> Void) {
        self.viewModel = CategoriesUnitsViewModel(categories: categories)
        self.didSelect = didSelect
        
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
        
        let output = viewModel.configure(input: CategoriesUnitsViewModel.Input(
            didTapContinue: mainView.button.rx.tap.asSignal()
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
extension CategoriesUnitsViewController {
    static func make(categories: [Category], didSelect: @escaping ([Category]) -> Void) -> CategoriesUnitsViewController {
        let vc = CategoriesUnitsViewController(categories: categories, didSelect: didSelect)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Categories.Title".localized
        return vc
    }
}

// MARK: Private
private extension CategoriesUnitsViewController {
    func route(_ route: CategoriesUnitsViewModel.Route) {
        switch route {
        case .selected(let categories):
            didSelect(categories)
            navigationController?.popViewController(animated: true)
        }
    }
}
