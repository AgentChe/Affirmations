//
//  FavoritesTableCell.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 25.09.2023.
//

import UIKit

final class FavoritesTableCell: UITableViewCell {
    var didTapMenu: (() -> Void)?
    
    lazy var affirmationLabel = makeLabel()
    lazy var dateLabel = makeLabel()
    lazy var menuButton = makeMenuButton()
    
    private lazy var affirmationAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.bold(size: 14.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
    private lazy var dateAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 189, green: 189, blue: 189))
        .font(Fonts.ProximaNova.regular(size: 14.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        return formatter
    }()
    
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
extension FavoritesTableCell {
    func setup(affirmation: Affirmation) {
        affirmationLabel.attributedText = affirmation.message.attributed(with: affirmationAttrs)
        
        let date = dateFormatter.string(from: affirmation.date)
        dateLabel.attributedText = date.attributed(with: dateAttrs)
    }
}

// MARK: Private
private extension FavoritesTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func menuTapped() {
        didTapMenu?()
    }
}

// MARK: Make constraints
private extension FavoritesTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            affirmationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            affirmationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -47.scale),
            affirmationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11.scale)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -47.scale),
            dateLabel.topAnchor.constraint(equalTo: affirmationLabel.bottomAnchor, constant: 5.scale),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.scale)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 5.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 33.scale),
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            menuButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension FavoritesTableCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Favorites.Menu"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
