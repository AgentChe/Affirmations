//
//  CategoriesView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 31.08.2023.
//

import UIKit

final class CategoriesView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var paygateButton = makePaygateButton()
    lazy var collectionView = makeCollectionView()
    
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
private extension CategoriesView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension CategoriesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            closeButton.centerYAnchor.constraint(equalTo: paygateButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 47.scale),
            titleLabel.centerYAnchor.constraint(equalTo: paygateButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            paygateButton.widthAnchor.constraint(equalToConstant: 43.scale),
            paygateButton.heightAnchor.constraint(equalToConstant: 43.scale),
            paygateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            paygateButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            collectionView.topAnchor.constraint(equalTo: paygateButton.bottomAnchor, constant: 2.scale),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CategoriesView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Categories.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
            .font(Fonts.ProximaNova.bold(size: 24.scale))
            .lineHeight(26.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Categories.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePaygateButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Categories.Paygate"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> CategoriesCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160.scale, height: 101.scale)
        layout.minimumLineSpacing = 12.scale
        layout.minimumInteritemSpacing = 12.scale
        
        let view = CategoriesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 13.scale, left: 0, bottom: 13.scale, right: 0)
        view.setContentOffset(CGPoint(x: 0, y: -20.scale), animated: false)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
