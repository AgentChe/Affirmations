//
//  OGenderView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

import UIKit

final class OGenderView: OSlideView {
    lazy var imageView = makeImageView()
    lazy var textLabel = makeTextLabel()
    lazy var femaleButton = makeFemaleButton()
    lazy var maleButton = makeMaleButton()
    lazy var otherButton = makeOtherButton()
    lazy var button = makeButton()
    
    private lazy var genderButtons = [
        femaleButton,
        maleButton,
        otherButton
    ]
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        changeEnable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OGenderView {
    func initialize() {
        backgroundColor = UIColor.white
    }
    
    @objc
    func didTapGender(sender: UIButton) {
        guard let genderButton = sender as? OGenderButton else {
            return
        }
        
        genderButtons.forEach { $0.marked = false }
        
        genderButton.marked = true
        
        changeEnable()
    }
    
    func changeEnable() {
        let selected = genderButtons.contains(where: { $0.marked })
        
        button.alpha = selected ? 1 : 0.6
        button.isEnabled = selected
    }
}

// MARK: Make constraints
private extension OGenderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 316.scale),
            imageView.heightAnchor.constraint(equalToConstant: 229.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22.scale),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            femaleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            femaleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            femaleButton.heightAnchor.constraint(equalToConstant: 51.scale),
            femaleButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 37.scale)
        ])
        
        NSLayoutConstraint.activate([
            maleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            maleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            maleButton.heightAnchor.constraint(equalToConstant: 51.scale),
            maleButton.topAnchor.constraint(equalTo: femaleButton.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            otherButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            otherButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            otherButton.heightAnchor.constraint(equalToConstant: 51.scale),
            otherButton.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            button.heightAnchor.constraint(equalToConstant: 51.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OGenderView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Gender")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
            .font(Fonts.ProximaNova.regular(size: 14.scale))
            .lineHeight(18.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Widget.Text".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFemaleButton() -> OGenderButton {
        let view = OGenderButton(title: "Onboarding.Gender.Female".localized)
        view.layer.cornerRadius = 25.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapGender(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeMaleButton() -> OGenderButton {
        let view = OGenderButton(title: "Onboarding.Gender.Male".localized)
        view.layer.cornerRadius = 25.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapGender(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeOtherButton() -> OGenderButton {
        let view = OGenderButton(title: "Onboarding.Gender.Other".localized)
        view.layer.cornerRadius = 25.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapGender(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.ProximaNova.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Onboarding.Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 25.scale
        view.backgroundColor = UIColor(integralRed: 110, green: 204, blue: 169)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
