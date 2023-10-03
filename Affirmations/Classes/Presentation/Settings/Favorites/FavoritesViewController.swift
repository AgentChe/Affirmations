//
//  FavoritesViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 25.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoritesViewController: UIViewController {
    lazy var mainView = FavoritesView()
    
    private lazy var viewModel = FavoritesViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didRemoveTrigger = PublishRelay<Affirmation>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: FavoritesViewModel.Input(
            didTapMenu: mainView.tableView.didMenuTapped,
            didRemove: didRemoveTrigger.asSignal()
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
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
extension FavoritesViewController {
    static func make() -> FavoritesViewController {
        let vc = FavoritesViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Favorites.Title".localized
        return vc
    }
}

// MARK: Private
private extension FavoritesViewController {
    func route(_ route: FavoritesViewModel.Route) {
        switch route {
        case .menu(let affirmation):
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let shareAction = UIAlertAction(title: "Favorites.Share".localized, style: .default) { [weak self] action in
                let items = [
                    affirmation.message + "\n\n",
                    URL(string: GlobalDefinitions.appStoreUrl)!
                ] as [Any]
                let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self?.present(controller, animated: true)
            }
            alert.addAction(shareAction)
            
            let removeAction = UIAlertAction(title: "Favorites.Remove".localized, style: .destructive) { [weak self] action in
                self?.didRemoveTrigger.accept(affirmation)
            }
            alert.addAction(removeAction)
            
            let cancelAction = UIAlertAction(title: "Backup.ConfirmDisable.Cancel".localized, style: .cancel)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    }
}
