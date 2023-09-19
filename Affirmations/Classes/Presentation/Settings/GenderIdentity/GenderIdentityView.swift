//
//  GenderIdentityView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 19.09.2023.
//

import UIKit

final class GenderIdentityView: UIView {
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var femaleButton = makeFemaleButton()
    lazy var maleButton = makeMaleButton()
    lazy var otherButton = makeOtherButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension GenderIdentityView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension GenderIdentityView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            femaleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            femaleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            femaleButton.heightAnchor.constraint(equalToConstant: 51.scale),
            femaleButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            maleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            maleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            maleButton.heightAnchor.constraint(equalToConstant: 51.scale),
            maleButton.topAnchor.constraint(equalTo: femaleButton.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            otherButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            otherButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            otherButton.heightAnchor.constraint(equalToConstant: 51.scale),
            otherButton.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension GenderIdentityView {
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
            .font(Fonts.ProximaNova.regular(size: 14.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "GenderIdentity.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFemaleButton() -> OGenderButton {
        let view = OGenderButton(gender: .female)
        view.layer.cornerRadius = 25.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMaleButton() -> OGenderButton {
        let view = OGenderButton(gender: .male)
        view.layer.cornerRadius = 25.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOtherButton() -> OGenderButton {
        let view = OGenderButton(gender: .other)
        view.layer.cornerRadius = 25.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
