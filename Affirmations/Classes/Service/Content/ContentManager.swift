//
//  ContentManager.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

import RxSwift

protocol ContentManagerProtocol {
    func obtainWidgetsCategories(for language: ApplicationLanguage) -> Single<[Category]>
}

final class ContentManager {}

// MARK: ContentManagerProtocol
extension ContentManager: ContentManagerProtocol {
    func obtainWidgetsCategories(for language: ApplicationLanguage) -> Single<[Category]> {
        Single<[Category]>.create { event in
            guard
                let url = Bundle.main.url(forResource: "info", withExtension: "json", subdirectory: "category/\(language.rawValue)"),
                let data = try? Data(contentsOf: url, options: .mappedIfSafe),
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            let categories = CategoryMapper.widgetsCategories(from: json)
            event(.success(categories))
            
            return Disposables.create()
        }
    }
}
