//
//  OWidgetCategoriesView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class OWidgetCategoriesView: OSlideView {
    lazy var imageView = makeImageView()
    lazy var textLabel = makeTextLabel()
    lazy var collectionView = makeCollectionView()
    lazy var button = makeButton()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        changeEnable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OWidgetCategoriesView {
    func initialize() {
        backgroundColor = UIColor.white
        
        contentManager
            .obtainWidgetsCategories(for: Localizable.shared.currentLanguage)
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(collectionView) { base, categories in
                base.setup(elements: categories.sorted(by: { $0.sort < $1.sort }).map { OWCCollectionElement(category: $0) })
            })
            .disposed(by: disposeBag)
        
        button.rx.tap
            .flatMapLatest { [weak self] elements -> Single<Void> in
                guard let self else {
                    return .never()
                }
                
                let categories = self.collectionView.elements
                    .filter { $0.marked }
                    .map { $0.category }
                
                return self.contentManager
                    .saveSelectedWidgets(categories: categories)
            }
            .bind(to: Binder(self) { base, void in
                base.onNext()
            })
            .disposed(by: disposeBag)
        
        collectionView.didSelectAction = { [weak self] in
            self?.changeEnable()
        }
    }
    
    func changeEnable() {
        let enable = collectionView.elements.contains(where: { $0.marked })
        button.isEnabled = enable
        button.alpha = enable ? 1 : 0.6
    }
}

// MARK: Make constraints
private extension OWidgetCategoriesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 239.scale),
            imageView.heightAnchor.constraint(equalToConstant: 242.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22.scale),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 2.scale),
            collectionView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -2.scale)
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
private extension OWidgetCategoriesView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Onboarding.WidgetCategories")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
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
        view.attributedText = "Onboarding.WidgetCategories.Text".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> OWCCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 6.scale
        layout.minimumInteritemSpacing = 8.scale
        
        let view = OWCCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 10.scale, left: 26.scale, bottom: 10.scale, right: 26.scale)
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
