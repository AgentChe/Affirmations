//
//  LanguageTableElement.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 25.09.2023.
//

final class LanguageTableElement {
    let language: ApplicationLanguage
    var marked: Bool
    
    init(language: ApplicationLanguage, marked: Bool) {
        self.language = language
        self.marked = marked
    }
}
