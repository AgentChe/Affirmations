//
//  PracticeView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 08.09.2023.
//

import UIKit

final class PracticeView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var affirmationsView = makeAffirmationsView()
    lazy var headerView = makeHeaderView()
    lazy var closeButton = makeCloseButton()
    lazy var timeProgressView = makeTimeProgressView()
    lazy var progressLabel = makeProgressLabel()
    lazy var bookmarkButton = makeBookmarkButton()
    lazy var settingsView = makeSettingsView()
    lazy var completeView = makeCompleteView()
    
    private lazy var progressAttrs = TextAttributes()
        .textColor(UIColor.white)
        .font(Fonts.ProximaNova.regular(size: 14.scale))
        .lineHeight(16.scale)
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PracticeView {
    func setup(progress: String) {
        progressLabel.attributedText = progress.attributed(with: progressAttrs)
    }
}

// MARK: Make constraints
private extension PracticeView {
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
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.bottomAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 32.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 32.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            timeProgressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            timeProgressView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16.scale),
            timeProgressView.heightAnchor.constraint(equalToConstant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.topAnchor.constraint(equalTo: timeProgressView.bottomAnchor, constant: 19.scale)
        ])
        
        NSLayoutConstraint.activate([
            bookmarkButton.widthAnchor.constraint(equalToConstant: 40.scale),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 40.scale),
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bookmarkButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -78.scale : -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            settingsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingsView.topAnchor.constraint(equalTo: topAnchor),
            settingsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            completeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            completeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            completeView.topAnchor.constraint(equalTo: topAnchor),
            completeView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PracticeView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Main.Background")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAffirmationsView() -> PracticeAffirmationsView {
        let view = PracticeAffirmationsView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHeaderView() -> GradientView {
        let view = GradientView()
        view.gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.6).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor
        ]
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Practice.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTimeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.layer.cornerRadius = 2.scale
        view.layer.masksToBounds = true
        view.trackTintColor = UIColor.black.withAlphaComponent(0.2)
        view.progressTintColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBookmarkButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSettingsView() -> PracticeSettingsView {
        let view = PracticeSettingsView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCompleteView() -> PracticeCompleteView {
        let view = PracticeCompleteView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
