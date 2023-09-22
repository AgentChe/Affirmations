//
//  EditReminderTableElement.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

enum EditReminderTableElement {
    case categories([Category])
    case settings(EditReminderSettings)
    case schedule(EditReminderSchedule)
    case sound(Sound)
}

final class EditReminderSettings {
    var count: Int
    var start: Int
    var end: Int
    
    init(
        count: Int,
        start: Int,
        end: Int
    ) {
        self.count = count
        self.start = start
        self.end = end
    }
}

final class EditReminderSchedule {
    var selectedDays: [DayOfWeek]
    
    init(selectedDays: [DayOfWeek]) {
        self.selectedDays = selectedDays
    }
}
