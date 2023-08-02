//
//  ProfileManager.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 01.08.2023.
//

import RxSwift

protocol ProfileManagerProtocol {
    func setup(settings: NotificationSettings) -> Single<Void>
    func obtainSettings() -> Single<NotificationSettings?>
    func setup(gender: Gender) -> Single<Void>
    func obtainGender() -> Single<Gender?>
}

final class ProfileManager {
    enum Constants {
        static let settingsKey = "profile_manager_settings_key"
        static let genderKey = "profile_manager_gender_key"
    }
}

// MARK: ProfileManagerProtocol
extension ProfileManager: ProfileManagerProtocol {
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
    
    func setup(gender: Gender) -> Single<Void> {
        Single<Void>.create { event in
            if let data = try? JSONEncoder().encode(gender) {
                UserDefaults.standard.set(data, forKey: Constants.genderKey)
            }
            
            event(.success(Void()))
            
            return Disposables.create()
        }
    }
    
    func obtainGender() -> Single<Gender?> {
        Single<Gender?>.create { event in
            var gender: Gender?
            
            if let data = UserDefaults.standard.data(forKey: Constants.genderKey) {
                gender = try? JSONDecoder().decode(Gender.self, from: data)
            }
            
            event(.success(gender))
            
            return Disposables.create()
        }
    }
}
