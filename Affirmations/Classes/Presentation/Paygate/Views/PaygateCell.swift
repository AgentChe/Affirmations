//
//  PaygateCell.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 19.08.2023.
//

import UIKit

final class PaygateCell: UIView {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.regular(size: 14.scale))
        .textAlignment(.left)
        .lineHeight(30.scale)
    
    private var title: String?
    
    init(title: String?) {
        self.title = title
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PaygateCell {
    func update(title: String?) {
        self.title = title
        
        label.attributedText = title?.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension PaygateCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20.scale),
            iconView.heightAnchor.constraint(equalToConstant: 20.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 53.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Paygate.Checked")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = title?.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
