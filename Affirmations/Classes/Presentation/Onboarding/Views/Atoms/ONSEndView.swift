//
//  ONSEndView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 01.08.2023.
//

import UIKit

final class ONSEndView: ONSView {
    override var placeholder: String {
        "Onboarding.NotificationsSettings.End".localized
    }
    
    override var formattedValue: String {
        "\(value):00"
    }
}

// MARK: Public
extension ONSEndView {
    func setup(start: Int) {
        let range = (start + 1)...24
        values = Array(range)
        
        if !values.contains(value) {
            value = values.last ?? 1
        }
        
        update()
    }
}
