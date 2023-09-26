//
//  AddAffirmationViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 26.09.2023.
//

import UIKit
import RxSwift

final class AddAffirmationViewController: UIViewController {
    lazy var mainView = AddAffirmationView()

    private lazy var disposeBag = DisposeBag()

    private let mode: Mode
    private let didCreate: (String) -> Void
    private let didEdit: (Affirmation) -> Void
    
    private init(
        mode: Mode,
        didCreate: @escaping (String) -> Void,
        didEdit: @escaping (Affirmation) -> Void
    ) {
        self.mode = mode
        self.didCreate = didCreate
        self.didEdit = didEdit

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.saveButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.mainView.textField.resignFirstResponder()
                base.buttonTapped()
            })
            .disposed(by: disposeBag)
        
        let dismissGesture = UITapGestureRecognizer()
        mainView.isUserInteractionEnabled = true
        mainView.addGestureRecognizer(dismissGesture)
        dismissGesture.rx.event
            .bind(to: Binder(self) { base, event in
                base.mainView.textField.resignFirstResponder()
                base.animateDismiss { [weak self] in
                    self?.dismiss(animated: false)
                }
            })
            .disposed(by: disposeBag)

        fillIfNeeded()
        didChangeText()
        mainView.textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        mainView.textField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateShow()
    }
}

// MARK: Make
extension AddAffirmationViewController {
    static func make(
        affirmation: Affirmation? = nil,
        didCreate: @escaping (String) -> Void,
        didEdit: @escaping (Affirmation) -> Void
    ) -> AddAffirmationViewController {
        var mode: Mode {
            guard let affirmation else {
                return .create
            }
            
            return .edit(affirmation)
        }
        let vc = AddAffirmationViewController(
            mode: mode,
            didCreate: didCreate,
            didEdit: didEdit
        )
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension AddAffirmationViewController {
    enum Mode {
        case create
        case edit(Affirmation)
    }
    
    func buttonTapped() {
        let message = mainView.textField.text ?? ""
        
        switch mode {
        case .create:
            animateDismiss { [weak self] in
                self?.dismiss(animated: false) {
                    self?.didCreate(message)
                }
            }
        case .edit(let affirmation):
            let new = Affirmation(
                id: affirmation.id,
                message: message,
                date: affirmation.date
            )
            animateDismiss { [weak self] in
                self?.dismiss(animated: false) {
                    self?.didEdit(new)
                }
            }
        }
    }
    
    func animateShow() {
        mainView.containerYConstraint.isActive = false
        mainView.containerYConstraint = mainView.container.topAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor, constant: 8.scale)
        mainView.containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0.6
            self?.mainView.layoutIfNeeded()
        })
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        mainView.containerYConstraint.isActive = false
        mainView.containerYConstraint = mainView.container.topAnchor.constraint(equalTo: mainView.bottomAnchor)
        mainView.containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
    
    func fillIfNeeded() {
        guard case let .edit(affirmation) = mode else {
            return
        }
        
        mainView.textField.text = affirmation.message
    }
    
    @objc
    func didChangeText() {
        let count = mainView.textField.text?.count ?? 0
        
        let enable = (count > 0) && (count <= 1000)
        mainView.saveButton.isEnabled = enable
        mainView.saveButton.alpha = enable ? 1 : 0.4
        
        mainView.update(count: count)
    }
}
