//
//  ONSView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 31.07.2023.
//

import UIKit

class ONSView: UIView {
    var changedValue: ((Int) -> Void)?
    
    lazy var placeholderLabel = makePlaceholderLabel()
    lazy var minusButton = makeButton()
    lazy var valueLabel = makeLabel()
    lazy var plusButton = makeButton()
    
    var values = [Int]()
    var value = 0
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
        .font(Fonts.ProximaNova.bold(size: 16.scale))
        .lineHeight(18.scale)
        .textAlignment(.center)
    
    init(values: [Int] = [], value: Int = 0) {
        self.values = values
        self.value = value
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        valueLabel.attributedText = formattedValue.attributed(with: valueAttrs)
        
        let hasPrevious: Bool = {
            guard let index = values.firstIndex(of: value) else {
                return false
            }
            
            let previousIndex = index - 1
            
            return values.indices.contains(previousIndex)
        }()
        minusButton.isEnabled = hasPrevious
        minusButton.setImage(UIImage(named: hasPrevious ? "Onboarding.NS.Minus.Enable" : "Onboarding.NS.Minus.Disable"), for: .normal)
        
        let hasNext: Bool = {
            guard let index = values.firstIndex(of: value) else {
                return false
            }
            
            let nextIndex = index + 1
            
            return values.indices.contains(nextIndex)
        }()
        plusButton.isEnabled = hasNext
        plusButton.setImage(UIImage(named: hasNext ? "Onboarding.NS.Plus.Enable" : "Onboarding.NS.Plus.Disable"), for: .normal)
    }
    
    var placeholder: String { "" }
    
    var formattedValue: String { "" }
}

// MARK: Private
private extension ONSView {
    func initialize() {
        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
    }
    
    @objc
    func didTapMinus() {
        guard let index = values.firstIndex(of: value) else {
            return
        }
        
        let previousIndex = index - 1
        
        guard values.indices.contains(previousIndex) else {
            return
        }
        
        value = values[previousIndex]
        
        update()
        
        changedValue?(value)
    }
    
    @objc
    func didTapPlus() {
        guard let index = values.firstIndex(of: value) else {
            return
        }
        
        let nextIndex = index + 1
        
        guard values.indices.contains(nextIndex) else {
            return
        }
        
        value = values[nextIndex]
        
        update()
        
        changedValue?(value)
    }
}

// MARK: Make constraints
private extension ONSView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 36.scale),
            plusButton.heightAnchor.constraint(equalToConstant: 36.scale),
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14.scale),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: 36.scale),
            minusButton.heightAnchor.constraint(equalToConstant: 36.scale),
            minusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -115.scale),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ONSView {
    func makePlaceholderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
            .font(Fonts.ProximaNova.regular(size: 14.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = placeholder.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
