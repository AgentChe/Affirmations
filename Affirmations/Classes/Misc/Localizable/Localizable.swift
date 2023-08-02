//
//  Localizable.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

import Foundation

final class Localizable {
    static let shared = Localizable()
    
    private init() {}
    
    private let currentLanguageKey = "currentLanguage"
    
    var currentLanguage: ApplicationLanguage {
        get {
            let languageKey = UserDefaults.standard.string(forKey: currentLanguageKey)
            if let languageKey = languageKey, let language = ApplicationLanguage(rawValue: languageKey) {
                return language
            }
            return deviceLanguageIfSupported
        }
        
        set {
            let selectedLanguage = availableLanguages.contains(newValue.rawValue) ? newValue.rawValue : defaultLanguage
            UserDefaults.standard.set(selectedLanguage, forKey: currentLanguageKey)
            NotificationCenter.default.post(name: .LanguageDidChange,
                                            object: self,
                                            userInfo: [ApplicationLanguage.userInfoKey: newValue])
        }
    }
}

// MARK: Private
private extension Localizable {
    var defaultLanguage: String {
        let localization = Bundle.main.preferredLocalizations.first { availableLanguages.contains($0) }
        return localization ?? ApplicationLanguage.default.rawValue
    }
    
    var availableLanguages: [String] {
        Bundle.main.localizations
    }
    
    var deviceLanguageIfSupported: ApplicationLanguage {
        let deviceLanguage = Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? ""
        return ApplicationLanguage(rawValue: deviceLanguage) ?? .default
    }
}

// MARK: Private (Additional)
private extension NSNotification.Name {
    static let LanguageDidChange = Notification.Name("LanguageDidChange")
}
