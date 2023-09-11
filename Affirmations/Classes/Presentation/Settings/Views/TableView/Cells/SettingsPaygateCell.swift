//
//  SettingsPaygateCell.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 11.09.2023.
//

import UIKit

final class SettingsPaygateCell: UITableViewCell {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsPaygateCell {
    func initialize() {
        backgroundColor = UIColor(integralRed: 245, green: 247, blue: 249)
        contentView.backgroundColor = UIColor(integralRed: 245, green: 247, blue: 249)
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SettingsPaygateCell {
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
private extension SettingsPaygateCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Settings.Paygate")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
            .font(Fonts.ProximaNova.regular(size: 18.scale))
            .lineHeight(26.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Settings.Paygate".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
