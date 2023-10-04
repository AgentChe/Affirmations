//
//  ContentManager.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

import RxSwift

protocol ContentManagerProtocol {
    func add(reminder: Reminder) -> Single<Void>
    func delete(reminders: [Reminder]) -> Single<Void>
    func obtainReminders() -> Single<[Reminder]>
    func obtainWidgetsCategories(for language: ApplicationLanguage) -> Single<[Category]>
    func saveSelectedWidgets(categories: [Category]) -> Single<Void>
    func obtainSelectedWidgetsCategories() -> Single<[Category]>
    func obtainCategories(for language: ApplicationLanguage) -> Single<[Category]>
    func obtainSelectedCategory(for language: ApplicationLanguage) -> Single<Category?>
    func select(categoryType: String) -> Single<Void>
    func obtainAffirmations(for language: ApplicationLanguage, categoryType: String, gender: String) -> Single<[Affirmation]>
    func save(affirmation: String) -> Single<Void>
    func unsave(affirmation: String) -> Single<Void>
    func replace(favorites: [Affirmation]) -> Single<Void>
    func obtainFavoritesAffirmations() -> Single<[Affirmation]>
    func create(affirmation: String) -> Single<Affirmation>
    func delete(affirmation: String) -> Single<Void>
    func edit(affirmation: Affirmation) -> Single<Affirmation>
    func replace(my: [Affirmation]) -> Single<Void>
    func obtainMyAffirmations() -> Single<[Affirmation]>
}

final class ContentManager {
    enum Constants {
        static let selectedCategory = "content_manager_selected_category"
        static let favoritesAffirmations = "content_manager_favorites_affirmations"
        static let myAffirmations = "content_manager_my_affirmations"
        static let selectedWidgetsCategories = "content_manager_selected_widgets_categories"
        static let reminders = "content_manager_reminders"
    }
}

// MARK: ContentManagerProtocol
extension ContentManager: ContentManagerProtocol {
    func add(reminder: Reminder) -> Single<Void> {
        Single<Void>.create { single in
            var reminders = [Reminder]()
            
            if let data = UserDefaults.standard.data(forKey: Constants.reminders) {
                if let decoded = try? JSONDecoder().decode([Reminder].self, from: data) {
                    reminders = decoded
                }
            }
            
            var personalChange: (Reminder) -> Void
            
            if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                reminders[index] = reminder
                personalChange = ContentMediator.shared.change(reminder:)
            } else {
                reminders.append(reminder)
                personalChange = ContentMediator.shared.add(reminder:)
            }
            
            if let data = try? JSONEncoder().encode(reminders) {
                UserDefaults.standard.set(data, forKey: Constants.reminders)
            }
            
            single(.success(Void()))
            
            ContentMediator.shared.replaceReminders()
            personalChange(reminder)
            
            return Disposables.create()
        }
    }
    
    func delete(reminders: [Reminder]) -> Single<Void> {
        Single<Void>.create { single in
            var objects = [Reminder]()
            
            if let data = UserDefaults.standard.data(forKey: Constants.reminders) {
                if let decoded = try? JSONDecoder().decode([Reminder].self, from: data) {
                    objects = decoded
                }
            }
            
            objects.removeAll(where: { reminder -> Bool in
                reminders.contains(where: { $0.id == reminder.id })
            })
            
            if let data = try? JSONEncoder().encode(objects) {
                UserDefaults.standard.set(data, forKey: Constants.reminders)
            }
            
            single(.success(Void()))
            
            ContentMediator.shared.replaceReminders()
            
            return Disposables.create()
        }
    }
    
    func obtainReminders() -> Single<[Reminder]> {
        Single<[Reminder]>.create { single in
            var reminders = [Reminder]()
            
            if let data = UserDefaults.standard.data(forKey: Constants.reminders) {
                if let decoded = try? JSONDecoder().decode([Reminder].self, from: data) {
                    reminders = decoded
                }
            }
            
            single(.success(reminders))
            
            return Disposables.create()
        }
    }
    
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
    
    func saveSelectedWidgets(categories: [Category]) -> Single<Void> {
        Single<Void>.create { single in
            if let data = try? JSONEncoder().encode(categories) {
                UserDefaults.standard.set(data, forKey: Constants.selectedWidgetsCategories)
            }
            
            single(.success(Void()))
            
            ContentWidgetsManager.shared.write(categories: categories)
            
            return Disposables.create()
        }
    }
    
    func obtainSelectedWidgetsCategories() -> Single<[Category]> {
        Single<[Category]>.create { single in
            var categories = [Category]()
            
            if let data = UserDefaults.standard.data(forKey: Constants.selectedWidgetsCategories) {
                if let decoded = try? JSONDecoder().decode([Category].self, from: data) {
                    categories = decoded
                }
            }
            
            single(.success(categories))
            
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
                return categories.first(where: { $0.type == type }) ?? categories.first(where: { $0.type == "COMMON_TOPICS" })
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
    
    func obtainAffirmations(for language: ApplicationLanguage, categoryType: String, gender: String) -> Single<[Affirmation]> {
        switch categoryType {
        case "MY":
            return obtainMyAffirmations()
        case "FAVORITES":
            return obtainFavoritesAffirmations()
        default:
            return affirmations(for: language, categoryType: categoryType, gender: gender)
        }
    }
    
    func save(affirmation: String) -> Single<Void> {
        Single<Void>.create { event in
            var favorites: Set<Affirmation> = []
            
            if let data = UserDefaults.standard.data(forKey: Constants.favoritesAffirmations) {
                if let decoded = try? JSONDecoder().decode(Set<Affirmation>.self, from: data) {
                    favorites = decoded
                }
            }
            
            let maxId = favorites.max(by: { $0.id < $1.id })?.id ?? 0
            
            favorites.insert(Affirmation(
                id: maxId + 1,
                message: affirmation,
                date: Date()
            ))
            
            if let data = try? JSONEncoder().encode(favorites) {
                UserDefaults.standard.set(data, forKey: Constants.favoritesAffirmations)
            }
            
            event(.success(Void()))
            
            ContentMediator.shared.save(affirmation: affirmation)
            
            return Disposables.create()
        }
    }
    
    func unsave(affirmation: String) -> Single<Void> {
        Single<Void>.create { event in
            var favorites: Set<Affirmation> = []
            
            if let data = UserDefaults.standard.data(forKey: Constants.favoritesAffirmations) {
                if let decoded = try? JSONDecoder().decode(Set<Affirmation>.self, from: data) {
                    favorites = decoded
                }
            }
            
            if let index = favorites.firstIndex(where: { $0.message == affirmation }) {
                favorites.remove(at: index)
            }
            
            if let data = try? JSONEncoder().encode(favorites) {
                UserDefaults.standard.set(data, forKey: Constants.favoritesAffirmations)
            }
            
            event(.success(Void()))
            
            ContentMediator.shared.unsave(affirmation: affirmation)
            
            return Disposables.create()
        }
    }
    
    func replace(favorites: [Affirmation]) -> Single<Void> {
        Single<Void>.create { event in
            if let data = try? JSONEncoder().encode(favorites) {
                UserDefaults.standard.set(data, forKey: Constants.favoritesAffirmations)
            }
            
            event(.success(Void()))
            
            ContentMediator.shared.replaceFavorites()
            
            return Disposables.create()
        }
    }
    
    func obtainFavoritesAffirmations() -> Single<[Affirmation]> {
        Single<[Affirmation]>.create { event in
            var favorites: Set<Affirmation> = []
            
            if let data = UserDefaults.standard.data(forKey: Constants.favoritesAffirmations) {
                if let decoded = try? JSONDecoder().decode(Set<Affirmation>.self, from: data) {
                    favorites = decoded
                }
            }
            
            let array = Array(favorites)
            
            event(.success(array))
            
            return Disposables.create()
        }
    }
    
    func create(affirmation: String) -> Single<Affirmation> {
        Single<Affirmation>.create { event in
            var my = [Affirmation]()
            
            if let data = UserDefaults.standard.data(forKey: Constants.myAffirmations) {
                if let decoded = try? JSONDecoder().decode([Affirmation].self, from: data) {
                    my = decoded
                }
            }
            
            let maxId = my.max(by: { $0.id < $1.id })?.id ?? 0
            
            let object = Affirmation(
                id: maxId + 1,
                message: affirmation,
                date: Date()
            )
            
            my.append(object)
            
            if let data = try? JSONEncoder().encode(my) {
                UserDefaults.standard.set(data, forKey: Constants.myAffirmations)
            }
            
            event(.success(object))
            
            ContentMediator.shared.create(affirmation: object)
            
            return Disposables.create()
        }
    }
    
    func delete(affirmation: String) -> Single<Void> {
        Single<Void>.create { event in
            var my = [Affirmation]()
            
            if let data = UserDefaults.standard.data(forKey: Constants.myAffirmations) {
                if let decoded = try? JSONDecoder().decode([Affirmation].self, from: data) {
                    my = decoded
                }
            }
            
            if let index = my.firstIndex(where: { $0.message == affirmation }) {
                my.remove(at: index)
            }
            
            if let data = try? JSONEncoder().encode(my) {
                UserDefaults.standard.set(data, forKey: Constants.myAffirmations)
            }
            
            event(.success(Void()))
            
            ContentMediator.shared.delete(affirmation: affirmation)
            
            return Disposables.create()
        }
    }
    
    func edit(affirmation: Affirmation) -> Single<Affirmation> {
        Single<Affirmation>.create { event in
            var my = [Affirmation]()
            
            if let data = UserDefaults.standard.data(forKey: Constants.myAffirmations) {
                if let decoded = try? JSONDecoder().decode([Affirmation].self, from: data) {
                    my = decoded
                }
            }
            
            if let index = my.firstIndex(where: { $0.id == affirmation.id }) {
                my[index] = affirmation
            }
            
            if let data = try? JSONEncoder().encode(my) {
                UserDefaults.standard.set(data, forKey: Constants.myAffirmations)
            }
            
            event(.success(affirmation))
            
            ContentMediator.shared.edit(affirmation: affirmation)
            
            return Disposables.create()
        }
    }
    
    func replace(my: [Affirmation]) -> Single<Void> {
        Single<Void>.create { event in
            if let data = try? JSONEncoder().encode(my) {
                UserDefaults.standard.set(data, forKey: Constants.myAffirmations)
            }
            
            event(.success(Void()))
            
            ContentMediator.shared.replaceMy()
            
            return Disposables.create()
        }
    }
    
    func obtainMyAffirmations() -> Single<[Affirmation]> {
        Single<[Affirmation]>.create { event in
            var my = [Affirmation]()
            
            if let data = UserDefaults.standard.data(forKey: Constants.myAffirmations) {
                if let decoded = try? JSONDecoder().decode([Affirmation].self, from: data) {
                    my = decoded
                }
            }
            
            event(.success(my))
            
            return Disposables.create()
        }
    }
}

// MARK: Private
private extension ContentManager {
    func affirmations(for language: ApplicationLanguage, categoryType: String, gender: String) -> Single<[Affirmation]> {
        Single<[Affirmation]>.create { event in
            guard
                let url = Bundle.main.url(forResource: categoryType.lowercased(), withExtension: "txt", subdirectory: "category/\(language.rawValue)/\(gender)"),
                let result = try? String(contentsOf: url)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            let strings = result.split(separator: "\r\n").map { String($0) }
            let affirmations = strings.enumerated().map { index, string -> Affirmation in
                Affirmation(
                    id: index,
                    message: string,
                    date: Date()
                )
            }
            event(.success(affirmations))
            
            return Disposables.create()
        }
    }
}
