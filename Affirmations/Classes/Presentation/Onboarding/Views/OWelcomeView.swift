//
//  OWelcomeView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 30.07.2023.
//

import UIKit

final class OWelcomeView: OSlideView {
    lazy var imageView = makeImageView()
    lazy var appNameLabel = makeAppNameLabel()
    lazy var textLabel = makeTextLabel()
    lazy var rulesLabel = makeRulesLabel()
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OWelcomeView {
    func initialize() {
        backgroundColor = UIColor.white
    }
    
    @objc
    func rulesDidTap(sender: UITapGestureRecognizer) {
        guard
            let label = sender.view as? UILabel,
            let text = label.text as NSString?
        else {
            return
        }
        
        let privacyPolicyRange = text.range(of: "Onboarding.Welcome.PrivacyPolicy".localized)
        let termsOfUseRange = text.range(of: "Onboarding.Welcome.TermsOfUse".localized)
        
        if sender.didTapAttributedTextInLabel(label: label, inRange: privacyPolicyRange) {
            open(path: GlobalDefinitions.privacyPolicy)
        }
        
        if sender.didTapAttributedTextInLabel(label: label, inRange: termsOfUseRange) {
            open(path: GlobalDefinitions.termsOfUse)
        }
    }
    
    func open(path: String) {
        guard let url = URL(string: path) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}

// MARK: Make constraints
private extension OWelcomeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 145.scale),
            imageView.heightAnchor.constraint(equalToConstant: 136.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 78.scale : 30.scale)
        ])

        NSLayoutConstraint.activate([
            appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            appNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 55.scale)
        ])

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            textLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 17.scale)
        ])

        NSLayoutConstraint.activate([
            rulesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            rulesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            rulesLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -12.scale)
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
private extension OWelcomeView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Onboarding.Welcome")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAppNameLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
            .font(Fonts.ProximaNova.bold(size: 24.scale))
            .lineHeight(29.23.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Affirmation".attributed(with: attrs)
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
        view.attributedText = "Onboarding.Welcome.Text".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRulesLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 143, green: 146, blue: 157))
            .font(Fonts.ProximaNova.regular(size: 12.scale))
            .lineHeight(16.scale)
            .textAlignment(.center)
        let linkAttrs = TextAttributes()
            .textColor(UIColor(integralRed: 110, green: 204, blue: 169))
            .font(Fonts.ProximaNova.regular(size: 12.scale))
            .lineHeight(16.scale)
            .textAlignment(.center)

        let privacyPolicy = "Onboarding.Welcome.PrivacyPolicy".localized
        let termsOfUse = "Onboarding.Welcome.TermsOfUse".localized
        let rules = String(format: "Onboarding.Welcome.Rules".localized, privacyPolicy, termsOfUse)
        
        let result = NSMutableAttributedString(attributedString: rules.attributed(with: attrs))
        
        let privacyPolicyRange = NSString(string: rules).range(of: privacyPolicy)
        result.addAttributes(linkAttrs.dictionary, range: privacyPolicyRange)
        
        let termsOfUseRange = NSString(string: rules).range(of: termsOfUse)
        result.addAttributes(linkAttrs.dictionary, range: termsOfUseRange)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rulesDidTap(sender:)))
        
        let view = UILabel()
        view.attributedText = result
        view.numberOfLines = 0
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.ProximaNova.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Onboarding.Welcome.Button".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 25.scale
        view.backgroundColor = UIColor(integralRed: 110, green: 204, blue: 169)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
