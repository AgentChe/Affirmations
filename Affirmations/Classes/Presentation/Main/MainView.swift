//
//  MainView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 30.08.2023.
//

import UIKit
import GoogleMobileAds

final class MainView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var affirmationsView = makeAffirmationsView()
    lazy var paygateButton = makePaygateButton()
    lazy var categoryButton = makeCategoryButton()
    lazy var trainingView = makeTrainingView()
    
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
            affirmationsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            affirmationsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            affirmationsView.topAnchor.constraint(equalTo: topAnchor),
            affirmationsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            paygateButton.widthAnchor.constraint(equalToConstant: 43.scale),
            paygateButton.heightAnchor.constraint(equalToConstant: 43.scale),
            paygateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            paygateButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            categoryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            categoryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale),
            categoryButton.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            trainingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trainingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trainingView.topAnchor.constraint(equalTo: topAnchor),
            trainingView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
    
    func makeAffirmationsView() -> AffirmationsView {
        let view = AffirmationsView()
        view.backgroundColor = UIColor.clear
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
    
    func makeTrainingView() -> TrainingView {
        let view = TrainingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
