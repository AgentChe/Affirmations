//
//  ContentWidgetsManager.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 20.09.2023.
//

import Foundation

final class ContentWidgetsManager {
    static let shared = ContentWidgetsManager()
    
    private init() {}
}

// MARK: Public
extension ContentWidgetsManager {
    func sharedContainerURL() -> URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.affirmations.widgets")
    }
    
    func write(gender: Gender) {
        guard
            let url = sharedContainerURL()?.appendingPathComponent("gender.json"),
            let data = try? JSONEncoder().encode(gender)
        else {
            return
        }
        
        try? data.write(to: url)
    }
    
    func write(categories: [Category]) {
        guard
            let url = sharedContainerURL()?.appendingPathComponent("categories.json"),
            let data = try? JSONEncoder().encode(categories)
        else {
            return
        }
        
        try? data.write(to: url)
    }
    
    func affirmation() -> String {
        guard
            let categoryType = categories.randomElement()?.type,
            let genderType = gender?.rawValue,
            let url = Bundle.main.url(
                forResource: categoryType.lowercased(),
                withExtension: "txt",
                subdirectory: "category/\(Localizable.shared.currentLanguage.rawValue)/\(genderType)"
            ),
            let result = try? String(contentsOf: url)
        else {
            return "Unknown"
        }
        
        let strings = result.split(separator: "\r\n").map { String($0) }
        return strings.randomElement() ?? "Unknown"
    }
}

// MARK: Private
private extension ContentWidgetsManager {
    var gender: Gender? {
        guard
            let url = sharedContainerURL()?.appendingPathComponent("gender.json"),
            let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        
        return try? JSONDecoder().decode(Gender.self, from: data)
    }
    
    var categories: [Category] {
        guard
            let url = sharedContainerURL()?.appendingPathComponent("categories.json"),
            let data = try? Data(contentsOf: url)
        else {
            return []
        }
        
        let array = try? JSONDecoder().decode([Category].self, from: data)
        return array ?? []
    }
}
