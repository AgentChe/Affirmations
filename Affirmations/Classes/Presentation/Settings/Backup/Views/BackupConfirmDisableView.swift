//
//  BackupConfirmDisableView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 12.09.2023.
//

import UIKit

final class BackupConfirmDisableView: UIView {
    lazy var container = makeContainer()
    lazy var closeButton = makeCloseButton()
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var textLabel = makeTextLabel()
    lazy var disableButton = makeDisableButton()
    lazy var cancelButton = makeCancelButton()
    
    private lazy var verticalConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension BackupConfirmDisableView {
    func show() {
        isHidden = false
        
        verticalConstraint.isActive = false
        verticalConstraint = container.centerYAnchor.constraint(equalTo: centerYAnchor)
        verticalConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self?.layoutIfNeeded()
        })
    }
    
    func hide() {
        verticalConstraint.isActive = false
        verticalConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        verticalConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backgroundColor = UIColor.black.withAlphaComponent(0)
            self?.layoutIfNeeded()
        }, completion: { [weak self] result in
            self?.isHidden = true
        })
    }
}

// MARK: Make constraints
private extension BackupConfirmDisableView {
    func makeConstraints() {
        verticalConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -46.scale),
            verticalConstraint
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 32.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 32.scale),
            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.scale),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 186.scale),
            imageView.heightAnchor.constraint(equalToConstant: 184.scale),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 46.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            disableButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            disableButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            disableButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 24.scale),
            disableButton.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            cancelButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            cancelButton.topAnchor.constraint(equalTo: disableButton.bottomAnchor, constant: 8.scale),
            cancelButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24.scale),
            cancelButton.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension BackupConfirmDisableView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 10.scale
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Backup.ConfirmDisable.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Backup.ConfirmDisable.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 31, green: 32, blue: 36))
            .font(Fonts.ProximaNova.extraBold(size: 16.scale))
            .lineHeight(19.36.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Backup.ConfirmDisable.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 73, green: 74, blue: 80))
            .font(Fonts.ProximaNova.regular(size: 12.scale))
            .lineHeight(16.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Backup.ConfirmDisable.Text".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeDisableButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 110, green: 204, blue: 169))
            .font(Fonts.ProximaNova.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Backup.ConfirmDisable.Disable".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = UIColor(integralRed: 110, green: 204, blue: 169).cgColor
        view.layer.borderWidth = 1.scale
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCancelButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 110, green: 204, blue: 169))
            .font(Fonts.ProximaNova.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Backup.ConfirmDisable.Cancel".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
