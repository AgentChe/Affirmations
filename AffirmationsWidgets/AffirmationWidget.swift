//
//  AffirmationWidget.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 20.09.2023.
//

import SwiftUI
import WidgetKit

struct AffirmationWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "AffirmationWidget", provider: Provider()) { entry in
            GeometryReader { geometry in
                ZStack {
                    Image("AffirmationWidget")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text(entry.text)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .supportedFamilies([.systemMedium])
    }
}
