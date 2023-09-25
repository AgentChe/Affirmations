//
//  SettingsTableElement.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 11.09.2023.
//

enum SettingsTableElement {
    case paygate
    case route(SettingsRoute)
    case backup(enable: Bool)
}

enum SettingsRoute {
    case gender
    case contentPreferences
    case reminders
    case language
}
