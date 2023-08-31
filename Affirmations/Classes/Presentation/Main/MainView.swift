//
//  MainView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 30.08.2023.
//

import UIKit

final class MainView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var paygateButton = makePaygateButton()
    lazy var categoryButton = makeCategoryButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension MainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            paygateButton.widthAnchor.constraint(equalToConstant: 43.scale),
            paygateButton.heightAnchor.constraint(equalToConstant: 43.scale),
            paygateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            paygateButton.topAnchor.constraint(equalTo: topAnchor, constant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            categoryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            categoryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale),
            categoryButton.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MainView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Main.Background")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePaygateButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Main.Paygate"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCategoryButton() -> CategoryButton {
        let view = CategoryButton()
        view.layer.cornerRadius = 20.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 110, green: 204, blue: 169).cgColor
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
