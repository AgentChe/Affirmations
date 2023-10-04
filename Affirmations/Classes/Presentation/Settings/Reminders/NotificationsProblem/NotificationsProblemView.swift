//
//  NotificationsProblemView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 04.10.2023.
//

import UIKit

final class NotificationsProblemView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var settingsButton = makeSettingsButton()
    
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
private extension NotificationsProblemView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 249, green: 249, blue: 249)
    }
}

// MARK: Make constraints
private extension NotificationsProblemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 325.scale : 191.scale),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 383.scale : 225.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 59.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 58.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 56.scale),
            settingsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension NotificationsProblemView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "NotificationsProblem.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 51, green: 51, blue: 51))
            .font(Fonts.ProximaNova.bold(size: 23.scale))
            .lineHeight(38.23.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "NotificationsProblem.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 103, green: 105, blue: 132))
            .font(Fonts.ProximaNova.regular(size: 20.scale))
            .lineHeight(23.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "NotificationsProblem.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSettingsButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 93, green: 97, blue: 252))
            .font(Fonts.ProximaNova.bold(size: 13.scale))
        
        let view = UIButton()
        view.setAttributedTitle("NotificationsProblem.SettingsButton".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor(integralRed: 231, green: 232, blue: 255)
        view.layer.cornerRadius = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
