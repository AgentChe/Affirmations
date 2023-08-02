//
//  ApplicationLanguage.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

import Foundation

enum ApplicationLanguage: String {
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
}
