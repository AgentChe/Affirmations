//
//  Category.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

struct Category: Codable, Hashable {
    let type: String
    let name: String
    let free: Bool
}

// MARK: Public
extension Category {
    var sort: Int {
        switch type.uppercased() {
        case "COMMON_TOPICS":
            return 1
        case "PERSONAL_GROWTH":
            return 2
        case "STRESS_AND_ANXIETY":
            return 3
        case "BODY_POSITIVITY":
            return 4
        case "POSITIVE_THINKING":
            return 5
        case "LOVE_RELATIONSHIPS":
            return 6
        case "HAPPINESS":
            return 7
        case "GRATITUDE":
            return 8
        default:
            return 100
        }
    }
}
