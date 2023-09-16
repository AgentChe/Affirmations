//
//  BackupViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 12.09.2023.
//

import UIKit
import RxSwift

final class BackupViewController: UIViewController {
    lazy var mainView = BackupView()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activeSubscriptions = PaygateMediator.shared
            .didPurchased
            .startWith(Void())
            .map { IAPManager().hasActiveSubscriptions }
            .asDriver(onErrorDriveWith: .never())
        
        let enabled = Backup.shared.isSignIn
            .asDriver(onErrorDriveWith: .never())
        
        enabled
            .drive(mainView.enableButton.switchView.rx.isOn)
            .disposed(by: disposeBag)
        
        mainView.enableButton.rx.tap
            .withLatestFrom(activeSubscriptions)
            .withLatestFrom(enabled) { ($0, $1) }
            .bind(to: Binder(self) { base, args in
                let (activeSubscriptions, enabled) = args
                
                switch enabled {
                case true:
                    base.mainView.confirmDisableView.show()
                case false:
                    if !activeSubscriptions {
                        let vc = PaygateViewController.make()
                        base.present(vc, animated: true)
                    } else {
                        Backup.shared.signIn(presenting: base)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        mainView.confirmDisableView
            .disableButton.rx.tap
            .bind(to: Binder(Backup.shared) { base, void in
                base.signOut()
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.confirmDisableView.cancelButton.rx.tap.asObservable(),
                mainView.confirmDisableView.closeButton.rx.tap.asObservable(),
                mainView.confirmDisableView.disableButton.rx.tap.asObservable()
            )
            .bind(to: Binder(mainView.confirmDisableView) { base, void in
                base.hide()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension BackupViewController {
    static func make() -> BackupViewController {
        let vc = BackupViewController()
        vc.navigationItem.title = "Backup.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}
