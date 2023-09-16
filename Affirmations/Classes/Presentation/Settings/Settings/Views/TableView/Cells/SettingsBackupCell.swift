//
//  SettingsBackupCell.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 12.09.2023.
//

import UIKit

final class SettingsBackupCell: UITableViewCell {
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    
    private lazy var titleAttrs = TextAttributes()
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
extension SettingsBackupCell {
    func setup(element: Bool) {
        iconView.image = UIImage(named: element ? "Settings.Backup.Enable" : "Settings.Backup.Disable")
        
        let title = element ? "Settings.Backup.Enable" : "Settings.Backup.Disable"
        titleLabel.attributedText = title.localized.attributed(with: titleAttrs)
    }
}

// MARK: Private
private extension SettingsBackupCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SettingsBackupCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 61.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 61.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale),
            subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsBackupCell {
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
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 189, green: 189, blue: 189))
            .font(Fonts.ProximaNova.regular(size: 14.scale))
            .lineHeight(16.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Settings.Backup.Text".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
