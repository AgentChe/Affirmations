//
//  Provider.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 20.09.2023.
//

import WidgetKit

struct Provider: TimelineProvider {
    private let placeholder = AffirmationEntry(date: Date(), text: ContentWidgetsManager.shared.affirmation())
    
    func placeholder(in context: Context) -> AffirmationEntry {
        placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (AffirmationEntry) -> Void) {
        completion(placeholder)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<AffirmationEntry>) -> Void) {
        let entry = AffirmationEntry(date: Date(), text: ContentWidgetsManager.shared.affirmation())
        completion(Timeline(entries: [entry], policy: .atEnd))
    }
}
