//
//  NavigationController.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 13.02.2023.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apply(settings: .default())
        setNavigationBarHidden(true, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        false
    }
}

// MARK: API
extension NavigationController {
    func apply(settings: NavigationControllerSettings) {
        navigationBar.setBackgroundImage(settings.backgroundImage, for: .default)
        navigationBar.shadowImage = settings.shadowImage
        navigationBar.isTranslucent = settings.isTranslucent
        navigationBar.tintColor = settings.tintColor
        navigationBar.titleTextAttributes = settings.titleTextAttrributes
    }
}
