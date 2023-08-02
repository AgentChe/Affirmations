//
//  StringExtension.swift
//  CarCheckUK
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation
import CommonCrypto

extension String {
    static func choosePluralForm(byNumber: Int, one: String, two: String, many: String) -> String {
        var result = many
        let number = byNumber % 100
        
        if (number < 10 || number >= 20) {
            if (number % 10 == 1) {
                result = one
            }
            if (number % 10 > 1 && number % 10 < 5) {
                result = two
            }
        }
        return result
    }
    
    var localized: String {
        let language = Localizable.shared.currentLanguage
        let languagePath = Bundle.main.path(forResource: language.rawValue, ofType: "lproj" )
        let baseLanguagePath = Bundle.main.path(forResource: "Base", ofType: "lproj")
        let path = languagePath ?? baseLanguagePath
        
        let notLocalizedValue = "NOT LOCALIZED"
        if let path = path, let bundle = Bundle(path: path) {
            return NSLocalizedString(self, tableName: "Localizable", bundle: bundle, value: self, comment: "")
        } else {
            return notLocalizedValue
        }
    }
}
