//
//  BackupView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 12.09.2023.
//

import UIKit

final class BackupView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var subTitleSeparator = makeSeparator()
    lazy var enableButton = makeEnableButton()
    lazy var enableButtonSeparator = makeSeparator()
    lazy var cell1 = makeCell(text: "Backup.Cell1".localized, separatorHidden: false)
    lazy var cell2 = makeCell(text: "Backup.Cell2".localized, separatorHidden: false)
    lazy var cell3 = makeCell(text: "Backup.Cell3".localized, separatorHidden: false)
    lazy var cell4 = makeCell(text: "Backup.Cell4".localized, separatorHidden: true)
    lazy var confirmDisableView = makeConfirmDisableView()
    
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
private extension BackupView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension BackupView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleSeparator.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            subTitleSeparator.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            subTitleSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleSeparator.heightAnchor.constraint(equalToConstant: 1.scale),
            subTitleSeparator.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            enableButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            enableButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            enableButton.topAnchor.constraint(equalTo: subTitleSeparator.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            enableButtonSeparator.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            enableButtonSeparator.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            enableButtonSeparator.heightAnchor.constraint(equalToConstant: 1.scale),
            enableButtonSeparator.topAnchor.constraint(equalTo: enableButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cell1.topAnchor.constraint(equalTo: enableButtonSeparator.bottomAnchor, constant: 41.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cell4.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cell4.topAnchor.constraint(equalTo: cell3.bottomAnchor),
            cell4.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            confirmDisableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            confirmDisableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            confirmDisableView.topAnchor.constraint(equalTo: topAnchor),
            confirmDisableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BackupView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets.zero
        view.setContentOffset(CGPoint.zero, animated: false)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 113, green: 114, blue: 122))
            .font(Fonts.ProximaNova.regular(size: 12.scale))
            .lineHeight(16.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Backup.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 234, green: 234, blue: 234)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeEnableButton() -> GoogleDriveBackupButton {
        let view = GoogleDriveBackupButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeCell(text: String, separatorHidden: Bool) -> BackupCellView {
        let view = BackupCellView(text: text)
        view.separator.isHidden = separatorHidden
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeConfirmDisableView() -> BackupConfirmDisableView {
        let view = BackupConfirmDisableView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
