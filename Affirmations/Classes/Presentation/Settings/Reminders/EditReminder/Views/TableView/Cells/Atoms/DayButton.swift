//
//  DayButton.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import UIKit

final class DayButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    let day: DayOfWeek
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(UIColor.white)
        .font(Fonts.ProximaNova.regular(size: 14.scale))
    private lazy var deselectedAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.regular(size: 14.scale))
    
    init(day: DayOfWeek) {
        self.day = day
        
        super.init(frame: .zero)
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = max(bounds.width, bounds.height) / 2
    }
}

// MARK: Private
private extension DayButton {
    func update() {
        let attrs = marked ? selectedAttrs : deselectedAttrs
        setAttributedTitle(day.localized.attributed(with: attrs), for: .normal)
        
        backgroundColor = marked ? UIColor(integralRed: 110, green: 204, blue: 169) : UIColor.clear
        
        layer.borderWidth = marked ? 0 : 1.scale
        layer.borderColor = marked ? UIColor.clear.cgColor : UIColor(integralRed: 110, green: 204, blue: 169).cgColor
    }
}
