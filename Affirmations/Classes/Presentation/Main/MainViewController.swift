//
//  MainViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 30.08.2023.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds

final class MainViewController: UIViewController {
    lazy var mainView = MainView()
    
    private lazy var viewModel = MainViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didCompleteTrainingTrigger = PublishRelay<TrainingView.Training>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.paygateButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let vc = PaygateViewController.make()
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.categoryButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let vc = CategoriesViewController.make()
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.trainingView
            .button.rx.tap
            .bind(to: Binder(self) { base, void in
                base.mainView.trainingView.hide { training in
                    if let training {
                        base.didCompleteTrainingTrigger.accept(training)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        mainView.affirmationsView.changedElement
            .emit(to: Binder(self) { base, element in
                base.current(element: element)
            })
            .disposed(by: disposeBag)
        
        let currentAffirmation = mainView.affirmationsView.changedElement
            .compactMap {
                switch $0 {
                case let .affirmation(affirmation, _):
                    return affirmation
                default:
                    return nil
                }
            }
        
        let output = viewModel.configure(input: MainViewModel.Input(
            didCompleteTraining: didCompleteTrainingTrigger.asSignal(),
            currentAffirmation: currentAffirmation,
            didTapMark: mainView.bookmarkButton.rx.tap.asSignal()
        ))
        
        output.activeSubsription
            .drive(Binder(self) { base, activeSubsription in
                base.mainView.paygateButton.isHidden = activeSubsription
            })
            .disposed(by: disposeBag)
        
        output.selectedCategoryName
            .drive(Binder(mainView.categoryButton) { base, name in
                base.setup(categoryName: name)
            })
            .disposed(by: disposeBag)
        
        output.marked
            .drive(Binder(self) { base, marked in
                base.bookmark(marked)
            })
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewDidAppear))
            .take(1)
            .flatMapLatest { _ in output.route }
            .asDriver(onErrorDriveWith: .never())
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewDidAppear))
            .take(1)
            .flatMapLatest { _ in output.affirmations }
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(mainView.affirmationsView) { base, affirmations in
                base.setup(affirmations: affirmations)
            })
            .disposed(by: disposeBag)
        
        mainView.affirmationsView.bannerView.rootViewController = self
        mainView.affirmationsView.bannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Public
extension MainViewController {
    static func make() -> MainViewController {
        let vc = MainViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension MainViewController {
    func route(_ route: MainViewModel.Route) {
        switch route {
        case .training(let training):
            mainView.trainingView.show(training: training)
        case .requestReview:
            RequestReview.request()
        }
    }
    
    func current(element: AffirmationsView.Element) {
        [
            mainView.shareButton,
            mainView.bookmarkButton,
            mainView.startButton
        ].forEach { $0.isHidden = element.isBanner }
    }
    
    func bookmark(_ marked: Bool) {
        let image = UIImage(named: marked ? "Main.Saved" : "Main.Unsaved")
        mainView.bookmarkButton.setImage(image, for: .normal)
    }
}
