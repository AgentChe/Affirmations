//
//  NavigationControllerSettings.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 13.02.2023.
//

import UIKit

struct NavigationControllerSettings {
    let backgroundImage: UIImage
    let shadowImage: UIImage
    let isTranslucent: Bool
    let tintColor: UIColor
    let titleTextAttrributes: [NSAttributedString.Key: Any]
}

// MARK: Make
extension NavigationControllerSettings {
    static func `default`() -> NavigationControllerSettings {
        NavigationControllerSettings(backgroundImage: UIImage(),
                                     shadowImage: UIImage(),
                                     isTranslucent: true,
                                     tintColor: UIColor.black,
                                     titleTextAttrributes: TextAttributes()
                                        .textColor(UIColor.black)
                                        .font(Fonts.ProximaNova.bold(size: 20.scale))
                                        .textAlignment(.center)
                                        .dictionary)
    }
}
