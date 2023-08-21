//
//  PaygateView.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 26.08.2021.
//

import UIKit

final class PaygateView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var imageView = makeImageView()
    lazy var textLabel = makeTextLabel()
    lazy var cell1 = makeCell(number: 1)
    lazy var cell2 = makeCell(number: 2)
    lazy var cell3 = makeCell(number: 3)
    lazy var cell4 = makeCell(number: 4)
    lazy var restoreButton = makeRestoreButton()
    lazy var buyButton = makeBuyButton()
    lazy var preloader = makePreloader()
    
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
private extension PaygateView {
    func initialize() {
        backgroundColor = UIColor.white
    }
    
    @objc
    func textDidTap(sender: UITapGestureRecognizer) {
        guard
            let label = sender.view as? UILabel,
            let text = label.text as NSString?
        else {
            return
        }
        
        let privacyPolicyRange = text.range(of: "Paygate.PrivacyPolicy".localized)
        let termsOfUseRange = text.range(of: "Paygate.TermsOfUse".localized)
        
        if sender.didTapAttributedTextInLabel(label: label, inRange: privacyPolicyRange) {
            open(path: GlobalDefinitions.privacyPolicy)
        }
        
        if sender.didTapAttributedTextInLabel(label: label, inRange: termsOfUseRange) {
            open(path: GlobalDefinitions.termsOfUse)
        }
    }
    
    func open(path: String) {
        guard let url = URL(string: path) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}

// MARK: Make constraints
private extension PaygateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 50.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 309.scale),
            imageView.heightAnchor.constraint(equalToConstant: 186.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 62.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22.scale),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell4.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            restoreButton.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -9.scale)
        ])
        
        NSLayoutConstraint.activate([
            buyButton.widthAnchor.constraint(equalToConstant: 309.scale),
            buyButton.heightAnchor.constraint(equalToConstant: 51.scale),
            buyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            buyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: restoreButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: restoreButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 143, green: 146, blue: 157))
            .font(Fonts.ProximaNova.regular(size: 14.scale))
            .lineHeight(18.scale)
            .textAlignment(.center)
        let linkAttrs = TextAttributes()
            .textColor(UIColor(integralRed: 110, green: 204, blue: 169))
            .font(Fonts.ProximaNova.regular(size: 14.scale))
            .lineHeight(18.scale)
            .textAlignment(.center)

        let privacyPolicy = "Paygate.PrivacyPolicy".localized
        let termsOfUse = "Paygate.TermsOfUse".localized
        let text = "Paygate.Text".localized
        
        let result = NSMutableAttributedString(attributedString: text.attributed(with: attrs))
        
        let privacyPolicyRange = NSString(string: text).range(of: privacyPolicy)
        result.addAttributes(linkAttrs.dictionary, range: privacyPolicyRange)
        
        let termsOfUseRange = NSString(string: text).range(of: termsOfUse)
        result.addAttributes(linkAttrs.dictionary, range: termsOfUseRange)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textDidTap(sender:)))
        
        let view = UILabel()
        view.attributedText = result
        view.numberOfLines = 0
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(number: Int) -> PaygateCell {
        let view = PaygateCell(title: "Paygate.Cell\(number)".localized)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRestoreButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 43, green: 63, blue: 98))
            .font(Fonts.ProximaNova.bold(size: 14.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.Restore".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBuyButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.ProximaNova.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Paygate.Buy".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor(integralRed: 110, green: 204, blue: 169)
        view.layer.cornerRadius = 25.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = .medium
        view.color = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
