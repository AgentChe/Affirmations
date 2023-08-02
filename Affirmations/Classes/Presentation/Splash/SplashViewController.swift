//
//  SplashViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 17.07.2023.
//

import UIKit
import RxSwift

final class SplashViewController: UIViewController {
    lazy var mainView = SplashView()
    
    private lazy var viewModel = SplashViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SplashViewModel.Input())
        
        output.route
            .drive(Binder(self) { base, route in
                base.goTo(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}

// MARK: Private
private extension SplashViewController {
    func goTo(_ route: SplashViewModel.Route) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.route(route)
        }
    }
    
    func route(_ route: SplashViewModel.Route) {
        switch route {
        case .onboarding:
            let vc = OnboardingViewController.make()
            UIApplication.shared.keyWindow?.rootViewController = vc
        case .main:
            break // TODO
        }
    }
}
