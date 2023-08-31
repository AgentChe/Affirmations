//
//  CategoryButton.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 31.08.2023.
//

import UIKit

final class CategoryButton: UIButton {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(UIColor(integralRed: 110, green: 204, blue: 169))
        .font(Fonts.ProximaNova.bold(size: 14.scale))
        .textAlignment(.left)
        .lineHeight(17.05.scale)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CategoryButton {
    func setup(categoryName: String) {
        label.attributedText = categoryName.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension CategoryButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 16.scale),
            iconView.heightAnchor.constraint(equalToConstant: 16.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 45.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CategoryButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Main.Category")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
