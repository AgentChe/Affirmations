//
//  ContentManager.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 01.08.2023.
//

import RxSwift

protocol ContentManagerProtocol {
    func setup(settings: NotificationSettings) -> Single<Void>
    func obtainSettings() -> Single<NotificationSettings?>
}

final class ContentManager {
    enum Constants {
        static let settingsKey = "content_manager_settings_key"
    }
}

// MARK: ContentManagerProtocol
extension ContentManager: ContentManagerProtocol {
    func setup(settings: NotificationSettings) -> Single<Void> {
        Single<Void>.create { event in
            if let data = try? JSONEncoder().encode(settings) {
                UserDefaults.standard.set(data, forKey: Constants.settingsKey)
            }
            
            event(.success(Void()))
            
            return Disposables.create()
        }
    }
    
    func obtainSettings() -> Single<NotificationSettings?> {
        Single<NotificationSettings?>.create { event in
            var settings: NotificationSettings?
            
            if let data = UserDefaults.standard.data(forKey: Constants.settingsKey) {
                settings = try? JSONDecoder().decode(NotificationSettings.self, from: data)
            }
            
            event(.success(settings))
            
            return Disposables.create()
        }
    }
}
