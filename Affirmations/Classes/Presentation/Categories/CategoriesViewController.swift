//
//  CategoriesViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 31.08.2023.
//

import UIKit
import RxSwift

final class CategoriesViewController: UIViewController {
    lazy var mainView = CategoriesView()
    
    private lazy var viewModel = CategoriesViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.route(.dismiss)
            })
            .disposed(by: disposeBag)
        
        mainView.paygateButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.route(.paygate)
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: CategoriesViewModel.Input(
            didSelectElement: mainView.collectionView.didSelectElement
        ))
        
        output.activeSubscription
            .drive(Binder(self) { base, activeSubsription in
                base.mainView.paygateButton.isHidden = activeSubsription
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
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
extension CategoriesViewController {
    static func make() -> CategoriesViewController {
        let vc = CategoriesViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension CategoriesViewController {
    func route(_ route: CategoriesViewModel.Route) {
        switch route {
        case .dismiss:
            dismiss(animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .alert(let text):
            let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK".localized, style: .cancel)
            alert.addAction(okAction)
            
            present(alert, animated: true)
        }
    }
}
