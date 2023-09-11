//
//  PracticeAffirmationsView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 11.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class PracticeAffirmationsView: UIView {
    private lazy var affirmations = [String]()
    private lazy var secondsForAffirmation = Float(10)
    
    private lazy var panGesture = UIPanGestureRecognizer()
    private lazy var tapGesture = UITapGestureRecognizer()
    
    private lazy var currentView = UIView()
    private lazy var currentIndex = 0 {
        didSet {
            guard affirmations.indices.contains(currentIndex) else {
                return
            }
            
            currentAffirmationTrigger.accept(affirmations[currentIndex])
            currentIndexTrigger.accept(currentIndex)
        }
    }
    private lazy var currentTick = Float(0) {
        didSet {
            guard secondsForAffirmation > 0 else {
                return
            }
            
            let progress = currentTick / secondsForAffirmation
            tickProgressTrigger.accept(progress)
        }
    }
    
    private lazy var attrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.bold(size: 21.scale))
        .lineHeight(26.scale)
        .textAlignment(.center)
    
    private lazy var didCompleteTrigger = PublishRelay<Void>()
    private lazy var currentAffirmationTrigger = PublishRelay<String>()
    private lazy var currentIndexTrigger = PublishRelay<Int>()
    private lazy var tickProgressTrigger = PublishRelay<Float>()
    
    private lazy var disposeBag = DisposeBag()
    
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PracticeAffirmationsView {
    func setup(affirmations: [String]) {
        currentView.removeFromSuperview()
        currentView = UIView()
        
        self.affirmations = affirmations
        
        setupFirstAffirmation()
        startTimer()
    }
    
    func setup(secondsForAffirmation: Int) {
        self.secondsForAffirmation = Float(secondsForAffirmation)
    }
    
    var didComplete: Signal<Void> {
        didCompleteTrigger.asSignal()
    }
    
    var currentAffirmation: Signal<String> {
        currentAffirmationTrigger.asSignal()
    }
    
    var index: Signal<Int> {
        currentIndexTrigger.asSignal()
    }
    
    var tickProgress: Signal<Float> {
        tickProgressTrigger.asSignal()
    }
}

// MARK: Private
private extension PracticeAffirmationsView {
    enum Direction {
        case left, right
        
        var upIndex: Int {
            switch self {
            case .left:
                return 1
            case .right:
                return -1
            }
        }
    }
    
    func initialize() {
        isUserInteractionEnabled = true
        addGestureRecognizer(panGesture)
        addGestureRecognizer(tapGesture)
        
        panGesture.rx.event
            .bind(to: Binder(self) { base, event in
                switch event.state {
                case .changed:
                    base.moveView(at: event.translation(in: base).x)
                case .ended:
                    base.moveToCenter()
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .compactMap { [weak self] gesture -> CGFloat? in
                guard let self else {
                    return nil
                }
                
                let touchPoint = gesture.location(in: self)
                
                let leftArea = CGRect(x: 0, y: 0, width: self.bounds.width / 2, height: self.bounds.height)
                let rightArea = CGRect(x: self.bounds.width / 2, y: 0, width: self.bounds.width / 2, height: self.bounds.height)
                
                if leftArea.contains(touchPoint) {
                    return 100.scale
                } else if rightArea.contains(touchPoint) {
                    return -100.scale
                }
                
                return nil
            }
            .bind(to: Binder(self) { base, x in
                base.moveView(at: x)
            })
            .disposed(by: disposeBag)
    }
    
    func setupFirstAffirmation() {
        guard let affirmation = affirmations.first else {
            return
        }
        
        currentIndex = 0
        
        let label = makeLabel(affirmation: affirmation)
        label.frame.origin = CGPoint(x: 32.scale, y: bounds.height / 2 - label.bounds.height / 2)
        addSubview(label)
       
        currentView = label
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            if self.currentTick == self.secondsForAffirmation {
                self.moveView(at: -100.scale)
            } else {
                self.currentTick += 1
            }
        }
    }
    
    func moveView(at x: CGFloat) {
        if (x > -50.scale) && (x < 50.scale) {
            currentView.frame.origin.x = 32.scale + x
        } else {
            panGesture.isEnabled = false
            panGesture.isEnabled = true
            
            let args = (x >= 50) ? (bounds.width, Direction.right) : (-currentView.bounds.width, Direction.left)
            let toX = args.0
            let direction = args.1
            
            if nextElement(direction: direction) {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    guard let self else { return }
                    
                    self.currentView.frame.origin.x = toX
                }, completion: { [weak self] result in
                    guard let self else { return }
                    
                    self.currentView.removeFromSuperview()
                    self.currentView = UIView()
                    
                    self.nextView(direction: direction)
                })
            } else {
                moveToCenter()
            }
        }
    }
    
    func moveToCenter() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            self.currentView.frame.origin.x = 32.scale
        })
    }
    
    func nextElement(direction: Direction) -> Bool {
        let nextIndex = currentIndex + direction.upIndex
        
        if affirmations.indices.contains(nextIndex) {
            currentIndex = nextIndex
            
            currentTick = 0
            
            return true
        } else if nextIndex > 0 {
            didCompleteTrigger.accept(Void())
            
            timer?.invalidate()
            timer = nil
            
            return false
        }
        
        return false
    }
    
    func nextView(direction: Direction) {
        guard affirmations.indices.contains(currentIndex) else {
            return
        }
        
        currentView = makeLabel(affirmation: affirmations[currentIndex])
        
        let y = bounds.height / 2 - currentView.bounds.height / 2
        
        var x: CGFloat {
            switch direction {
            case .left:
                return bounds.width
            case .right:
                return -currentView.bounds.width
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
