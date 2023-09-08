//
//  Affirmation.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 07.09.2023.
//

import Foundation

struct Affirmation: Codable, Hashable {
    let id: Int
    let message: String
    let date: Date
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.message == rhs.message
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(message)
    }
}
