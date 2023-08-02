//
//  NotificationSettings.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 01.08.2023.
//

struct NotificationSettings: Codable, Hashable {
    let count: Int
    let start: Int
    let end: Int
    let weekSchedule: WeekSchedule
}
