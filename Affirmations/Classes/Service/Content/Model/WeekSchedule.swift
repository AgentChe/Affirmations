//
//  WeekSchedule.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 01.08.2023.
//

struct WeekSchedule: Codable, Hashable {
    let su: Bool
    let mo: Bool
    let tu: Bool
    let we: Bool
    let th: Bool
    let fr: Bool
    let sa: Bool
}

extension WeekSchedule {
    init(selectedDays: [DayOfWeek]) {
        su = selectedDays.contains(where: { $0 == .su })
        mo = selectedDays.contains(where: { $0 == .mo })
        tu = selectedDays.contains(where: { $0 == .tu })
        we = selectedDays.contains(where: { $0 == .we })
        th = selectedDays.contains(where: { $0 == .th })
        fr = selectedDays.contains(where: { $0 == .fr })
        sa = selectedDays.contains(where: { $0 == .sa })
    }
}
