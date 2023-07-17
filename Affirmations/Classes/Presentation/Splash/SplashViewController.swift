//
//  SplashViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 17.07.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    lazy var mainView = SplashView()
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Public
extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}
