//
//  NotificationsProblemViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 04.10.2023.
//

import UIKit
import RxSwift

final class NotificationsProblemViewController: UIViewController {
    lazy var mainView = NotificationsProblemView()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.settingsButton.rx.tap
            .bind(to: Binder(self) { base, void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                UIApplication.shared.open(settingsUrl)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension NotificationsProblemViewController {
    static func make() -> NotificationsProblemViewController {
        let vc = NotificationsProblemViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}
