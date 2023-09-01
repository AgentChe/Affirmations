//
//  TrainingView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 01.09.2023.
//

import UIKit
import Lottie

final class TrainingView: UIView {
    enum Training {
        case swipe, like
        
        var animationName: String {
            switch self {
            case .swipe:
                return "animation_swipe"
            case .like:
                return "animation_like"
            }
        }
        
        var text: String {
            switch self {
            case .swipe:
                return "Main.Training.Swipe".localized
            case .like:
                return "Main.Training.Like".localized
            }
        }
    }
    
    lazy var container = makeContainer()
    lazy var animationView = makeAnimationView()
    lazy var label = makeLabel()
    lazy var button = makeButton()
    
    private(set) var training: Training?
    
    private lazy var attrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.bold(size: 18.scale))
        .textAlignment(.center)
        .lineHeight(22.scale)
    
    private lazy var centerYConstraint = NSLayoutConstraint()
    
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
extension TrainingView {
    func show(training: Training) {
        self.training = training
        
        animationView.animation = LottieAnimation.named(training.animationName)
        animationView.play()
        label.attributedText = training.text.attributed(with: attrs)
        
        isHidden = false
        
        centerYConstraint.isActive = false
        centerYConstraint = container.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerYConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self?.layoutIfNeeded()
        })
    }
    
    func hide(completion: @escaping (Training?) -> (Void)) {
        animationView.stop()
        
        centerYConstraint.isActive = false
        centerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        centerYConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backgroundColor = UIColor.black.withAlphaComponent(0)
            self?.layoutIfNeeded()
        }, completion: { [weak self] result in
            self?.isHidden = true
            completion(self?.training)
        })
    }
}

// MARK: Private
private extension TrainingView {
    func initialize() {
        backgroundColor = UIColor.black
        isHidden = true
    }
}

// MARK: Make constraints
private extension TrainingView {
    func makeConstraints() {
        centerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38.scale),
            centerYConstraint
        ])
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 153.scale),
            animationView.heightAnchor.constraint(equalToConstant: 139.scale),
            animationView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            animationView.topAnchor.constraint(equalTo: container.topAnchor, constant: 35.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 191.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -91.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14.scale),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14.scale),
            button.heightAnchor.constraint(equalToConstant: 51.scale),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -21.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TrainingView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 10.scale
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAnimationView() -> LottieAnimationView {
        let view = LottieAnimationView()
        view.backgroundColor = UIColor.clear
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.ProximaNova.bold(size: 18.scale))
        
        let view = UIButton()
        view.layer.cornerRadius = 25.scale
        view.backgroundColor = UIColor(integralRed: 110, green: 204, blue: 169)
        view.setAttributedTitle("Main.Training.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
