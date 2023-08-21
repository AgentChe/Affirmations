//
//  PaygateViewController.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 26.08.2021.
//

import UIKit
import RxSwift

final class PaygateViewController: UIViewController {
    lazy var mainView = PaygateView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = PaygateViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel
            .configure(input: .init(
                didTapBuy: mainView.buyButton.rx.tap
                    .map { GlobalDefinitions.Paygate.productId },
                didTapRestore: mainView.restoreButton.rx.tap
                    .asObservable()
            ))
        
        output.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(Binder(self) { base, errorMessage in
                base.show(errorMessage: errorMessage)
            })
            .disposed(by: disposeBag)
        
        output.purchased
            .emit(to: Binder(self) { base, void in
                PaygateMediator.shared.purchased()
                
                base.dismiss()
            })
            .disposed(by: disposeBag)
        
        output.price
            .drive(Binder(mainView.cell4) { base, price in
                base.update(title: String(format: "Paygate.Cell4".localized, price))
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss()
            })
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension PaygateViewController {
    static func make() -> PaygateViewController {
        let vc = PaygateViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension PaygateViewController {
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
        
        [
            mainView.cell1, mainView.cell2, mainView.cell3, mainView.cell4, mainView.restoreButton, mainView.buyButton
        ].forEach { $0.isHidden = activity }
    }
    
    func show(errorMessage: String) {
        let alert = UIAlertController(
            title: nil,
            message: errorMessage,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK".localized,
            style: .cancel
        )
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func dismiss() {
        dismiss(animated: true) {
            PaygateMediator.shared.closed()
        }
    }
}
