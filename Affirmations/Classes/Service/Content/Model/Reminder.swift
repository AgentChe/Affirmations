//
//  Reminder.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import Foundation

struct Reminder: Codable, Hashable {
    let id: String
    let created: Date
    let count: Int
    let start: Int
    let end: Int
    let weekSchedule: WeekSchedule
    let sound: Sound
    let categories: [Category]
    let enable: Bool
}
