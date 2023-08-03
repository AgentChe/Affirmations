//
//  OWCCollectionCell.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 03.08.2023.
//

import UIKit

final class OWCCollectionCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(UIColor.white)
        .font(Fonts.ProximaNova.regular(size: 16.scale))
        .lineHeight(19.49.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    private lazy var deselectedAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.regular(size: 16.scale))
        .lineHeight(19.49.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    
    private lazy var selectedContainerColor = UIColor(integralRed: 110, green: 204, blue: 169)
    private lazy var deselectedContainerColor = UIColor(integralRed: 245, green: 247, blue: 249)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OWCCollectionCell {
    func setup(element: OWCCollectionElement) {
        container.backgroundColor = element.marked ? selectedContainerColor : deselectedContainerColor
        
        let attrs = element.marked ? selectedAttrs : deselectedAttrs
        label.attributedText = element.category.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension OWCCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension OWCCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OWCCollectionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 23.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
