//
//  ContentPreferencesViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 20.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ContentPreferencesViewController: UIViewController {
    lazy var mainView = ContentPreferencesView()
    
    private lazy var viewModel = ContentPreferencesViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectTrigger = PublishRelay<[Category]>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: ContentPreferencesViewModel.Input(
            didSelect: didSelectTrigger.asSignal()
        ))
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.didSelectAction = { [weak self] in
            guard let self else { return }
            
            let categories = self.mainView.collectionView.elements
                .filter { $0.marked }
                .map { $0.category }
            self.didSelectTrigger.accept(categories)
        }
    }
}

// MARK: Public
extension ContentPreferencesViewController {
    static func make() -> ContentPreferencesViewController {
        let vc = ContentPreferencesViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "ContentPreferences.Title".localized
        return vc
    }
}
