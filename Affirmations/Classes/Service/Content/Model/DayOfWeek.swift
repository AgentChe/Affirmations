//
//  DayOfWeek.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 01.08.2023.
//

enum DayOfWeek: Codable, Hashable, CaseIterable {
    case su, mo, tu, we, th, fr, sa
    
    var localized: String {
        switch self {
        case .su:
            return "Reminders.Su".localized
        case .mo:
            return "Reminders.Mo".localized
        case .tu:
            return "Reminders.Tu".localized
        case .we:
            return "Reminders.We".localized
        case .th:
            return "Reminders.Th".localized
        case .fr:
            return "Reminders.Fr".localized
        case .sa:
            return "Reminders.Sa".localized
        }
    }
}
