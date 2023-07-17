//
//  Fonts.swift
//  CarCheckUK
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: ProximaNova
    struct ProximaNova {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "ProximaNova-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "ProximaNova-Regular", size: size)!
        }
        
        static func extraBold(size: CGFloat) -> UIFont {
            UIFont(name: "ProximaNova-ExtraBold", size: size)!
        }
    }
}
