//
//  MainViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 30.08.2023.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    lazy var mainView = MainView()
    
    private lazy var viewModel = MainViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.paygateButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let vc = PaygateViewController.make()
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.categoryButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let vc = CategoriesViewController.make()
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: MainViewModel.Input())
        
        output.activeSubsription
            .drive(Binder(self) { base, activeSubsription in
                base.mainView.paygateButton.isHidden = activeSubsription
            })
            .disposed(by: disposeBag)
        
        output.selectedCategoryName
            .drive(Binder(mainView.categoryButton) { base, name in
                base.setup(categoryName: name)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Public
extension MainViewController {
    static func make() -> MainViewController {
        let vc = MainViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}
