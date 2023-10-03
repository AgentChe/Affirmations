//
//  SettingsRouteCell.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 11.09.2023.
//

import UIKit

final class SettingsRouteCell: UITableViewCell {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.regular(size: 18.scale))
        .lineHeight(26.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsRouteCell {
    func setup(element: SettingsRoute) {
        let (icon, text) = element.data
        
        iconView.image = icon
        label.attributedText = text.attributed(with: attrs)
    }
}

// MARK: Private
private extension SettingsRouteCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SettingsRouteCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 26.scale),
            iconView.heightAnchor.constraint(equalToConstant: 26.scale),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 61.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsRouteCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

// MARK: Additional
private extension SettingsRoute {
    var data: (UIImage?, String) {
        switch self {
        case .gender:
            return (UIImage(named: "Settings.GenderIdentity"), "GenderIdentity.Title".localized)
        case .contentPreferences:
            return (UIImage(named: "Settings.ContentPreferences"), "ContentPreferences.Title".localized)
        case .reminders:
            return (UIImage(named: "Settings.Reminders"), "Reminders.Title".localized)
        case .language:
            return (UIImage(named: "Settings.Language"), "Language.Title".localized)
        case .favorites:
            return (UIImage(named: "Settings.Favorites"), "Favorites.Title".localized)
        case .myAffirmations:
            return (UIImage(named: "Settings.MyAffirmations"), "MyAffirmations.Settings.Title".localized)
        case .review:
            return (UIImage(named: "Settings.Review"), "Settings.Review".localized)
        case .share:
            return (UIImage(named: "Settings.Share"), "Favorites.Share".localized)
        case .privacyPolicy:
            return (UIImage(named: "Settings.PrivacyPolicy"), "Onboarding.Welcome.PrivacyPolicy".localized)
        case .termsAndConditions:
            return (UIImage(named: "Settings.TermsAndConditions"), "Onboarding.Welcome.TermsOfUse".localized)
        }
    }
}
