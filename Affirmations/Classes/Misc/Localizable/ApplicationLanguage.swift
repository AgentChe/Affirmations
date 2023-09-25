//
//  ApplicationLanguage.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

import Foundation

enum ApplicationLanguage: String, CaseIterable {
    case arabic = "ar"
    case deutsch = "de"
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case italian = "it"
    case japanese = "ja"
    case korean = "ko"
    case dutch = "nl"
    case portuguese = "pt-PT"
    case russian = "ru"
    case swedish = "sv"
    case thai = "th"
    case turkish = "tr"
    case chinese = "zh"
    case chineseTraditional = "zh-Hant-TW"
    
    static let `default` = ApplicationLanguage.english
    
    static let userInfoKey = "newValue"
    
    static func localized(_ language: ApplicationLanguage) -> String {
        let current = Localizable.shared.currentLanguage
        let languagePath = Bundle.main.path(forResource: current.rawValue, ofType: "lproj")
        let baseLanguagePath = Bundle.main.path(forResource: "Base", ofType: "lproj")
        
        guard let path = (languagePath ?? baseLanguagePath), let bundle = Bundle(path: path) else {
            return ""
        }
        
        let key: String
        
        switch language {
        case .arabic:
            key = "Language.Arabic"
        case .deutsch:
            key = "Language.Deutsch"
        case .english:
            key = "Language.English"
        case .spanish:
            key = "Language.Spanish"
        case .french:
            key = "Language.French"
        case .italian:
            key = "Language.Italian"
        case .japanese:
            key = "Language.Japanese"
        case .korean:
            key = "Language.Korean"
        case .dutch:
            key = "Language.Dutch"
        case .portuguese:
            key = "Language.Portuguese"
        case .russian:
            key = "Language.Russian"
        case .swedish:
            key = "Language.Swedish"
        case .thai:
            key = "Language.Thai"
        case .turkish:
            key = "Language.Turkish"
        case .chinese:
            key = "Language.Chinese"
        case .chineseTraditional:
            key = "Language.ChineseTraditional"
        }
        
        return NSLocalizedString(key, tableName: "Localizable", bundle: bundle, value: key, comment: "")
    }
}
