//
//  UIDevice+Extension.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 07.02.2023.
//

import Foundation.NSLocale
import UIKit

extension UIDevice {
    static var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    static var appBundleIdentifier: String? {
        Bundle.main.bundleIdentifier
    }
    
    static var idfv: String? {
        UIDevice.current.identifierForVendor?.uuidString
    }
}
