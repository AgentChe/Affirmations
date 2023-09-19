//
//  GenderIdentityViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 19.09.2023.
//

import UIKit
import RxSwift

final class GenderIdentityViewController: UIViewController {
    lazy var mainView = GenderIdentityView()
    
    private lazy var viewModel = GenderIdentityViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let genderButtons = [
            mainView.femaleButton,
            mainView.maleButton,
            mainView.otherButton
        ]
        
        let didSelect = Observable
            .merge(
                mainView.femaleButton.rx.tap
                    .compactMap { [weak self] in self?.mainView.femaleButton.gender },
                mainView.maleButton.rx.tap
                    .compactMap { [weak self] in self?.mainView.maleButton.gender },
                mainView.otherButton.rx.tap
                    .compactMap { [weak self] in self?.mainView.otherButton.gender }
            )
            .asSignal(onErrorSignalWith: .never())
        
        
        let output = viewModel.configure(input: GenderIdentityViewModel.Input(
            didSelect: didSelect
        ))
        
        output.gender
            .drive(Binder(self) { base, gender in
                genderButtons.forEach { $0.marked = $0.gender == gender }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension GenderIdentityViewController {
    static func make() -> GenderIdentityViewController {
        let vc = GenderIdentityViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "GenderIdentity.Title".localized
        return vc
    }
}
