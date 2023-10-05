//
//  Provider.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 20.09.2023.
//

import WidgetKit

struct Provider: TimelineProvider {
    private let placeholder = AffirmationEntry(date: Date(), text: "I am proud of how hard I try.")
    
    func placeholder(in context: Context) -> AffirmationEntry {
        placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (AffirmationEntry) -> Void) {
        completion(placeholder)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<AffirmationEntry>) -> Void) {
        var entries = [AffirmationEntry]()

        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: Date())
        let nextMidnight = calendar.date(byAdding: .day, value: 1, to: midnight)!

        for offset in 0 ..< 48 {
            let entry = AffirmationEntry(
                date: calendar.date(byAdding: .minute, value: offset * 30, to: midnight)!,
                text: ContentWidgetsManager.shared.affirmation()
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}
