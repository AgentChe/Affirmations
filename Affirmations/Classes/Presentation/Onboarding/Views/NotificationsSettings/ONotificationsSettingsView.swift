//
//  ONotificationsSettingsView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 31.07.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ONotificationsSettingsView: OSlideView {
    lazy var imageView = makeImageView()
    lazy var textLabel = makeTextLabel()
    lazy var countView = makeCountView()
    lazy var starView = makeStartView()
    lazy var endView = makeEndView()
    lazy var button = makeButton()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var contentManager = ContentManager()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        
        button.rx.tap
            .flatMapLatest { [weak self] void -> Driver<Category> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainCategories(for: Localizable.shared.currentLanguage)
                    .compactMap { categories -> Category? in
                        categories.first(where: { $0.type == "COMMON_TOPICS" })
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
            .flatMapLatest { [weak self] category -> Driver<Void> in
                guard let self = self else {
                    return .never()
                }
                
                let schedule = WeekSchedule(
                    su: false,
                    mo: true,
                    tu: true,
                    we: true,
                    th: true,
                    fr: true,
                    sa: false
                )
                
                let reminder = Reminder(
                    id: UUID().uuidString,
                    created: Date(),
                    count: self.countView.value,
                    start: self.starView.value,
                    end: self.endView.value,
                    weekSchedule: schedule,
                    sound: .not,
                    categories: [category],
                    enable: true
                )
                
                return self.contentManager
                    .add(reminder: reminder)
                    .asDriver(onErrorDriveWith: .never())
            }
            .asDriver(onErrorDriveWith: .never())
            .drive(Binder(self) { base, void in
                base.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ONotificationsSettingsView {
    func initialize() {
        backgroundColor = UIColor.white
        
        starView.changedValue = { [weak self] value in
            self?.endView.setup(start: value)
            self?.changeCountValues()
        }
        endView.changedValue = { [weak self] value in
            self?.starView.setup(end: value)
            self?.changeCountValues()
        }
        
        changeCountValues()
    }
    
    func changeCountValues() {
        let diffInHours = endView.value - starView.value
        countView.setup(diffInHours: diffInHours)
    }
}

// MARK: Make constraints
private extension ONotificationsSettingsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 288.scale),
            imageView.heightAnchor.constraint(equalToConstant: 228.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            countView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            countView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            countView.heightAnchor.constraint(equalToConstant: 55.scale),
            countView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 19.scale)
        ])
        
        NSLayoutConstraint.activate([
            starView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            starView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            starView.heightAnchor.constraint(equalToConstant: 55.scale),
            starView.topAnchor.constraint(equalTo: countView.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            endView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            endView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            endView.heightAnchor.constraint(equalToConstant: 55.scale),
            endView.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 5.scale)
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
private extension ONotificationsSettingsView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Onboarding.NS.Image")
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
        view.attributedText = "Onboarding.NotificationsSettings.Text".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCountView() -> ONSCountView {
        let view = ONSCountView()
        view.backgroundColor = UIColor(integralRed: 245, green: 247, blue: 249)
        view.layer.cornerRadius = 5.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStartView() -> ONSStartView {
        let view = ONSStartView(values: Array(0...9), value: 9)
        view.backgroundColor = UIColor(integralRed: 245, green: 247, blue: 249)
        view.layer.cornerRadius = 5.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEndView() -> ONSEndView {
        let view = ONSEndView(values: Array(10...24), value: 10)
        view.backgroundColor = UIColor(integralRed: 245, green: 247, blue: 249)
        view.layer.cornerRadius = 5.scale
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
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
