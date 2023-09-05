//
//  GlobalDefinitions.swift
//  CarCheckUK
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

final class GlobalDefinitions {
    enum Paygate {
        static let productId = "i.am.com.affirmation.monthly_trial"
    }
    
    enum AdMob {
        static var bannerId: String {
            #if DEBUG
                return "ca-app-pub-3940256099942544/2934735716"
            #else
                return "ca-app-pub-4531217591721437/6844383675"
            #endif
        }
    }
    
    static let privacyPolicy = "https://navisapps.com/affirmations/privacy.html"
    static let termsOfUse = "https://navisapps.com/affirmations/terms.html"
}
