//
//  OWidgetView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

import UIKit

final class OWidgetView: OSlideView {
    lazy var headerView = makeImageView(named: "Onboarding.Widget.Image")
    lazy var textLabel = makeTextLabel()
    lazy var cameraView = makeImageView(named: "Onboarding.Widget.Camera")
    lazy var clockView = makeImageView(named: "Onboarding.Widget.Clock")
    lazy var mailView = makeImageView(named: "Onboarding.Widget.Mail")
    lazy var notesView = makeImageView(named: "Onboarding.Widget.Notes")
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OWidgetView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension OWidgetView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalToConstant: 328.scale),
            headerView.heightAnchor.constraint(equalToConstant: 211.scale),
            headerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22.scale),
            textLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 7.scale)
        ])
        
        NSLayoutConstraint.activate([
            cameraView.widthAnchor.constraint(equalToConstant: 50.scale),
            cameraView.heightAnchor.constraint(equalToConstant: 50.scale),
            cameraView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            cameraView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            clockView.widthAnchor.constraint(equalToConstant: 50.scale),
            clockView.heightAnchor.constraint(equalToConstant: 50.scale),
            clockView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 112.scale),
            clockView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            mailView.widthAnchor.constraint(equalToConstant: 50.scale),
            mailView.heightAnchor.constraint(equalToConstant: 50.scale),
            mailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 198.scale),
            mailView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            notesView.widthAnchor.constraint(equalToConstant: 50.scale),
            notesView.heightAnchor.constraint(equalToConstant: 50.scale),
            notesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 284.scale),
            notesView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            button.heightAnchor.constraint(equalToConstant: 51.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OWidgetView {
    func makeImageView(named: String) -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: named)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
            .font(Fonts.ProximaNova.regular(size: 14.scale))
            .lineHeight(18.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Widget.Text".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.ProximaNova.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Onboarding.Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 25.scale
        view.backgroundColor = UIColor(integralRed: 110, green: 204, blue: 169)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
