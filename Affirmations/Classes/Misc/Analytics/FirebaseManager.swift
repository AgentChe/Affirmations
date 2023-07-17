//
//  FirebaseManager.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 07.02.2023.
//

import Firebase

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    private init() {}
}

// MARK: Public
extension FirebaseManager {
    func initialize() {
        FirebaseApp.configure()
    }
    
    func setup(apnsToken: Data?) {
        Messaging.messaging().apnsToken = apnsToken
    }
    
    func fcmToken() -> String? {
        Messaging.messaging().fcmToken
    }
    
    func logEvent(name: String, parameters: [String: Any] = [:]) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
