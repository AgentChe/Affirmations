//
//  ProfileManager.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 01.08.2023.
//

import RxSwift

protocol ProfileManagerProtocol {
    func setup(gender: Gender) -> Single<Void>
    func obtainGender() -> Single<Gender?>
}

final class ProfileManager {
    enum Constants {
        static let genderKey = "profile_manager_gender_key"
    }
}

// MARK: ProfileManagerProtocol
extension ProfileManager: ProfileManagerProtocol {
    func setup(gender: Gender) -> Single<Void> {
        Single<Void>.create { event in
            if let data = try? JSONEncoder().encode(gender) {
                UserDefaults.standard.set(data, forKey: Constants.genderKey)
            }
            
            event(.success(Void()))
            
            ProfileMediator.shared.changed(gender: gender)
            
            ContentWidgetsManager.shared.write(gender: gender)
            
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
