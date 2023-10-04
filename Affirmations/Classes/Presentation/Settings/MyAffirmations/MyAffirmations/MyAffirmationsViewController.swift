//
//  MyAffirmationsViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 25.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class MyAffirmationsViewController: UIViewController {
    lazy var mainView = MyAffirmationsView()
    
    private lazy var viewModel = MyAffirmationsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didRemoveTrigger = PublishRelay<Affirmation>()
    private lazy var didSaveTrigger = PublishRelay<Affirmation>()
    private lazy var didCreateTrigger = PublishRelay<String>()
    private lazy var didEditTrigger = PublishRelay<Affirmation>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView
            .didMenuTapped
            .emit(to: Binder(self) { base, affirmation in
                base.menuTapped(affirmation: affirmation)
            })
            .disposed(by: disposeBag)
        
        mainView.addButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.openAddAffirmation()
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: MyAffirmationsViewModel.Input(
            didTapRemove: didRemoveTrigger.asSignal(),
            didTapSave: didSaveTrigger.asSignal(),
            didCreate: didCreateTrigger.asSignal(),
            didEdit: didEditTrigger.asSignal()
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.isEmpty
            .drive(Binder(mainView) { base, isEmpty in
                base.emptyView.isHidden = !isEmpty
                base.tableView.isHidden = isEmpty
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension MyAffirmationsViewController {
    static func make() -> MyAffirmationsViewController {
        let vc = MyAffirmationsViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "MyAffirmations.Title".localized
        return vc
    }
}

// MARK: Private
private extension MyAffirmationsViewController {
    func menuTapped(affirmation: Affirmation) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "MyAffirmations.ToFavorites".localized, style: .default) { [weak self] action in
            self?.didSaveTrigger.accept(affirmation)
        }
        alert.addAction(saveAction)
        
        let shareAction = UIAlertAction(title: "Favorites.Share".localized, style: .default) { [weak self] action in
            let item = String(format: "%@\n\n%@", affirmation.message, GlobalDefinitions.appStoreUrl)
            
            let controller = UIActivityViewController(activityItems: [item], applicationActivities: nil)
            self?.present(controller, animated: true)
        }
        alert.addAction(shareAction)
        
        let editAction = UIAlertAction(title: "MyAffirmations.Edit".localized, style: .default) { [weak self] action in
            self?.openAddAffirmation(affirmation)
        }
        alert.addAction(editAction)
        
        let removeAction = UIAlertAction(title: "Favorites.Remove".localized, style: .destructive) { [weak self] action in
            self?.didRemoveTrigger.accept(affirmation)
        }
        alert.addAction(removeAction)
        
        let cancelAction = UIAlertAction(title: "Backup.ConfirmDisable.Cancel".localized, style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func openAddAffirmation(_ affirmation: Affirmation? = nil) {
        let vc = AddAffirmationViewController.make(affirmation: affirmation, didCreate: { [weak self] message in
            self?.didCreateTrigger.accept(message)
        }, didEdit: { [weak self] affirmation in
            self?.didEditTrigger.accept(affirmation)
        })
        present(vc, animated: false)
    }
}
