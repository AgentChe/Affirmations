//
//  OGenderButton.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

import UIKit

final class OGenderButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    let gender: Gender
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(UIColor.white)
        .font(Fonts.ProximaNova.regular(size: 18.scale))
    private lazy var deselectedAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.regular(size: 18.scale))
    
    init(gender: Gender) {
        self.gender = gender
        
        super.init(frame: .zero)
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OGenderButton {
    var title: String {
        switch gender {
        case .male:
            return "Onboarding.Gender.Male".localized
        case .female:
            return "Onboarding.Gender.Female".localized
        case .other:
            return "Onboarding.Gender.Other".localized
        }
    }
    
    func update() {
        let attrs = marked ? selectedAttrs : deselectedAttrs
        setAttributedTitle(title.attributed(with: attrs), for: .normal)
        
        backgroundColor = marked ? UIColor(integralRed: 110, green: 204, blue: 169) : UIColor(integralRed: 245, green: 247, blue: 249)
    }
}
