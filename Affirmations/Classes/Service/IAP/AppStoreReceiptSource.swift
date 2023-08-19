//
//  AppStoreReceiptSource.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 19.08.2023.
//

import Foundation

final class AppStoreReceiptSource {
    func appStoreReceiptData() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }

        return try? Data(contentsOf: url)
    }
    
    func appStoreReceipt(parser: AppStoreReceiptParserProtocol = AppStoreReceiptParser()) -> AppStoreReceipt? {
        guard let data = appStoreReceiptData() else {
            return nil
        }
        
        return try? parser.parse(from: data)
    }
}
