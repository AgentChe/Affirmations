//
//  AffirmationsView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 05.09.2023.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds

final class AffirmationsView: UIView {
    lazy var backgroundView = makeBackgroundView()
    
    enum Element {
        case affirmation(String, Int)
        case banner(Int)
        
        var index: Int {
            switch self {
            case let .affirmation(_, index):
                return index
            case .banner(let index):
                return index
            }
        }
        
        var isBanner: Bool {
            switch self {
            case .affirmation:
                return false
            case .banner:
                return true
            }
        }
    }
    
    lazy var bannerView: GADBannerView = {
        let view = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: 300.scale, height: 50.scale)))
        view.adUnitID = GlobalDefinitions.AdMob.bannerId
        view.delegate = self
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var affirmations = [String]()
    
    private lazy var currentView = UIView()
    private lazy var currentElement = Element.affirmation("", 0) {
        didSet {
            changedElementTrigger.accept(currentElement)
        }
    }
    
    private lazy var panGesture = UIPanGestureRecognizer()
    
    private lazy var changedElementTrigger = BehaviorRelay(value: currentElement)
    
    private lazy var attrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.bold(size: 21.scale))
        .lineHeight(26.scale)
        .textAlignment(.center)
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var bannerIsReceived = false
    
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
extension AffirmationsView {
    func setup(affirmations: [String]) {
        currentView.removeFromSuperview()
        currentView = UIView()
        
        self.affirmations = affirmations
        self.affirmations.shuffle()
        
        setupFirstAffirmation()
    }
    
    var changedElement: Signal<Element> {
        changedElementTrigger.asSignal(onErrorSignalWith: .never())
    }
}

// MARK: GADBannerViewDelegate
extension AffirmationsView: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerIsReceived = true
    }
}

// MARK: Private
private extension AffirmationsView {
    enum Direction {
        case up, down
        
        var upIndex: Int {
            switch self {
            case .up:
                return 1
            case .down:
                return -1
            }
        }
    }
    
    func initialize() {
        isUserInteractionEnabled = true
        addGestureRecognizer(panGesture)
        
        panGesture.rx.event
            .bind(to: Binder(self) { base, event in
                switch event.state {
                case .changed:
                    base.moveView(at: event.translation(in: base).y)
                case .ended:
                    base.moveToCenter()
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupFirstAffirmation() {
        guard let affirmation = affirmations.first else {
            return
        }
        
        currentElement = .affirmation(affirmation, 0)
        
        let label = makeLabel(affirmation: affirmation)
        label.frame.origin = CGPoint(x: 32.scale, y: bounds.height / 2 - label.bounds.height / 2)
        addSubview(label)
       
        currentView = label
    }
    
    func moveView(at y: CGFloat) {
        if (y > -150.scale) && (y < 150.scale) {
            currentView.frame.origin.y = (bounds.height / 2 - currentView.bounds.height / 2 + y)
        } else {
            panGesture.isEnabled = false
            panGesture.isEnabled = true
            
            let args = (y >= 150) ? (bounds.height, Direction.down) : (-currentView.bounds.height, Direction.up)
            let toY = args.0
            let direction = args.1
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self else { return }
                
                self.currentView.frame.origin.y = toY
            }, completion: { [weak self] result in
                guard let self else { return }
                
                self.currentView.removeFromSuperview()
                self.currentView = UIView()
                
                self.nextElement(direction: direction)
                self.nextView(direction: direction)
            })
        }
    }
    
    func moveToCenter() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            self.currentView.frame.origin.y = self.bounds.height / 2 - self.currentView.bounds.height / 2
        })
    }
    
    func nextElement(direction: Direction) {
        var nextIndex: Int {
            switch currentElement {
            case let .affirmation(_, index):
                return index + direction.upIndex
            case let .banner(index):
                return index + direction.upIndex
            }
        }
        
        // TODO: проверка наличия подписки
        if affirmations.indices.contains(nextIndex) {
            if (nextIndex != 0) && ((nextIndex % 5) == 0) && !currentElement.isBanner && bannerIsReceived {
                currentElement = .banner(currentElement.index)
            } else {
                currentElement = .affirmation(affirmations[nextIndex], nextIndex)
            }
        } else {
            affirmations.shuffle()
            if let affirmation = affirmations.first {
                currentElement = .affirmation(affirmation, 0)
            }
        }
    }
    
    func nextView(direction: Direction) {
        let x: CGFloat
        
        switch currentElement {
        case let .affirmation(affirmation, _):
            currentView = makeLabel(affirmation: affirmation)
            x = 32.scale
        case .banner:
            currentView = bannerView
            x = 37.5.scale
        }
        
        var y: CGFloat {
            switch direction {
            case .up:
                return bounds.height
            case .down:
                return -currentView.bounds.height
            }
        }
        
        currentView.frame.origin = CGPoint(x: x, y: y)
        
        addSubview(currentView)
        
        moveToCenter()
    }
    
    func makeLabel(affirmation: String) -> UILabel {
        let label = UILabel()
        label.frame.size = CGSize(width: 311.scale, height: CGFloat.greatestFiniteMagnitude)
        label.numberOfLines = 0
        label.attributedText = affirmation.attributed(with: attrs)
        label.sizeToFit()
        label.frame.size.width = 311.scale
        return label
    }
}

// MARK: Make constraints
private extension AffirmationsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AffirmationsView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Main.Background")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
