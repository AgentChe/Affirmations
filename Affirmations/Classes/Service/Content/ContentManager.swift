//
//  ContentManager.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

import RxSwift

protocol ContentManagerProtocol {
    func obtainWidgetsCategories(for language: ApplicationLanguage) -> Single<[Category]>
    func obtainCategories(for language: ApplicationLanguage) -> Single<[Category]>
    func obtainSelectedCategory(for language: ApplicationLanguage) -> Single<Category?>
    func select(categoryType: String) -> Single<Void>
}

final class ContentManager {
    enum Constants {
        static let selectedCategory = "content_manager_selected_category"
    }
}

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
    
    func obtainCategories(for language: ApplicationLanguage) -> Single<[Category]> {
        Single<[Category]>.create { event in
            guard
                let url = Bundle.main.url(forResource: "info", withExtension: "json", subdirectory: "category/\(language.rawValue)"),
                let data = try? Data(contentsOf: url, options: .mappedIfSafe),
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            let categories = CategoryMapper.categories(from: json)
            event(.success(categories))
            
            return Disposables.create()
        }
    }
    
    func obtainSelectedCategory(for language: ApplicationLanguage) -> Single<Category?> {
        obtainCategories(for: language)
            .map { categories -> Category? in
                let type = UserDefaults.standard.string(forKey: Constants.selectedCategory) ?? "COMMON_TOPICS"
                return categories.first(where: { $0.type == type })
            }
    }
    
    func select(categoryType: String) -> Single<Void> {
        Single<Void>.create { event in
            UserDefaults.standard.set(categoryType, forKey: Constants.selectedCategory)
            
            event(.success(Void()))
            
            ContentMediator.shared.changeSelectedCategory()
            
            return Disposables.create()
        }
    }
}
