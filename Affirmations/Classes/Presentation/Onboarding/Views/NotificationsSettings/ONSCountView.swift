//
//  ONSCountView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 01.08.2023.
//

import UIKit

final class ONSCountView: ONSView {
    override var placeholder: String {
        "Onboarding.NotificationsSettings.Count".localized
    }
    
    override var formattedValue: String {
        "\(value)x"
    }
}

// MARK: Public
extension ONSCountView {
    func setup(diffInHours: Int) {
        let range = 1...(60 * diffInHours)
        values = Array(range)
        
        if !values.contains(value) {
            value = 10
        }
        
        update()
    }
}
