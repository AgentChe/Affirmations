//
//  SplashViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 17.07.2023.
//

import UIKit
import RxSwift
import RxCocoa
import UserMessagingPlatform

final class SplashViewController: UIViewController {
    lazy var mainView = SplashView()
    
    private lazy var viewModel = SplashViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didRequestConsentTrigger = PublishRelay<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SplashViewModel.Input(
            didRequestConsent: didRequestConsentTrigger.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        requestConsent()
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
    func route(_ route: SplashViewModel.Route) {
        switch route {
        case .onboarding:
            let vc = OnboardingViewController.make()
            UIApplication.shared.keyWindow?.rootViewController = vc
        case .main:
            let nc = NavigationController(rootViewController: MainViewController.make())
            UIApplication.shared.keyWindow?.rootViewController = nc
        }
    }
    
    func requestConsent() {
        let parameters = UMPRequestParameters()
        parameters.tagForUnderAgeOfConsent = false
        
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) { requestConsentError in
            UMPConsentForm.loadAndPresentIfRequired(from: self) { [weak self] loadAndPresentError in
                self?.didRequestConsentTrigger.accept(Void())
            }
        }
    }
}
