//
//  SplashView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 17.07.2023.
//

import UIKit

final class SplashView: UIView {
    lazy var imageView = makeImageView()
    
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
private extension SplashView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 229, blue: 242)
    }
}

// MARK: Make constraints
private extension SplashView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 140.scale),
            imageView.heightAnchor.constraint(equalToConstant: 140.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SplashView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Splash.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
