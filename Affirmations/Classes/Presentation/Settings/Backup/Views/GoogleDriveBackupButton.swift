//
//  GoogleDriveBackupButton.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 12.09.2023.
//

import UIKit

final class GoogleDriveBackupButton: UIButton {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    lazy var switchView = makeSwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension GoogleDriveBackupButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -78.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            switchView.widthAnchor.constraint(equalToConstant: 50.scale),
            switchView.heightAnchor.constraint(equalToConstant: 32.scale),
            switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension GoogleDriveBackupButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Backup.GoogleDrive")
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
            .font(Fonts.ProximaNova.regular(size: 18.scale))
            .lineHeight(26.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.isUserInteractionEnabled = false
        view.attributedText = "Backup.Button".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSwitch() -> UISwitch {
        let view = UISwitch()
        view.tintColor = UIColor(integralRed: 217, green: 217, blue: 217)
        view.onTintColor = UIColor(integralRed: 14, green: 203, blue: 92)
        view.thumbTintColor = UIColor.white
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
