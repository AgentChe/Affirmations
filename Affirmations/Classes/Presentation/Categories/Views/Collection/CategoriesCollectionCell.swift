//
//  CategoriesCollectionCell.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 31.08.2023.
//

import UIKit

final class CategoriesCollectionCell: UICollectionViewCell {
    lazy var categoryImageView = makeCategoryImageView()
    lazy var shadowView = makeShadowView()
    lazy var iconView = makeIconView()
    lazy var nameLabel = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(UIColor.white)
        .font(Fonts.ProximaNova.bold(size: 12.scale))
        .lineHeight(22.scale)
        .textAlignment(.left)
    
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
extension CategoriesCollectionCell {
    func setup(element: CategoriesCollectionElement) {
        categoryImageView.image = UIImage(named: "Category.\(element.category.type)") ?? UIImage(named: "Category.DEFAULT")
        nameLabel.attributedText = element.category.name.attributed(with: attrs)
        
        if element.paid {
            iconView.image = UIImage(named: "Categories.Cell.Paygate")
        } else if element.selected {
            iconView.image = UIImage(named: "Categories.Checked")
        } else {
            iconView.image = nil
        }
    }
}

// MARK: Private
private extension CategoriesCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension CategoriesCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            categoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: categoryImageView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: categoryImageView.trailingAnchor),
            shadowView.topAnchor.constraint(equalTo: categoryImageView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: categoryImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20.scale),
            iconView.heightAnchor.constraint(equalToConstant: 20.scale),
            iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4.scale),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CategoriesCollectionCell {
    func makeCategoryImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeShadowView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
