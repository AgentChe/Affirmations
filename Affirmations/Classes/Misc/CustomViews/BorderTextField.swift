//
//  BorderTextField.swift
//  CarCheckUK
//
//  Created by Андрей Чернышев on 21.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class BorderTextField: PaddingTextField {
    enum FocusState {
        case none, focus
    }
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didChangeFocusTrigger = PublishRelay<FocusState>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension BorderTextField {
    var didChangeFocus: Signal<FocusState> {
        didChangeFocusTrigger
            .asSignal()
            .startWith(.none)
    }
}

// MARK: UITextFieldDelegate
extension BorderTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didChangeFocusTrigger.accept(.focus)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didChangeFocusTrigger.accept(.none)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension BorderTextField {
    func initialize() {
        backgroundColor = UIColor.white
        layer.borderWidth = 1.scale
        layer.cornerRadius = 16.scale
        layer.masksToBounds = true
        
        textPadding = UIEdgeInsets(top: 14.scale, left: 18.scale, bottom: 14.scale, right: 18.scale)
        
        delegate = self
        
        didChangeFocus
            .emit(to: Binder(self) { base, focusState in
                base.update(focusState)
            })
            .disposed(by: disposeBag)
    }
    
    func update(_ focusState: FocusState) {
        switch focusState {
        case .none:
            layer.borderColor = UIColor(integralRed: 237, green: 237, blue: 237).cgColor
        case .focus:
            layer.borderColor = UIColor(integralRed: 239, green: 183, blue: 80).cgColor
        }
    }
}
