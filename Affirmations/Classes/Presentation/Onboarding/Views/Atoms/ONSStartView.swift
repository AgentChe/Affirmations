//
//  ONSStartView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 01.08.2023.
//

import UIKit

final class ONSStartView: ONSView {
    override var placeholder: String {
        "Onboarding.NotificationsSettings.Start".localized
    }
    
    override var formattedValue: String {
        "\(value):00"
    }
}

// MARK: Public
extension ONSStartView {
    func setup(end: Int) {
        let range = 0...(end - 1)
        values = Array(range)
        
        if !values.contains(value) {
            value = values.last ?? 1
        }
        
        update()
    }
}
