//
//  PlanPushAffirmation.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 27.09.2023.
//

import Foundation

struct PlanPushAffirmation: Codable, Hashable {
    let id: String
    let affirmation: String
    let reminder: Reminder
    let trigger: Date
}
