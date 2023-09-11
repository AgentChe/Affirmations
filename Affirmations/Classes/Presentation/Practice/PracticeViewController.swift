//
//  PracticeViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 08.09.2023.
//

import UIKit
import RxSwift

final class PracticeViewController: UIViewController {
    lazy var mainView = PracticeView()
    
    private lazy var viewModel = PracticeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable
            .merge(
                mainView.settingsView.closeButton.rx.tap.asObservable(),
                mainView.completeView.doneButton.rx.tap.asObservable(),
                mainView.closeButton.rx.tap.asObservable()
            )
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewDidAppear))
            .take(1)
            .bind(to: Binder(mainView.settingsView) { base, void in
                base.show()
            })
            .disposed(by: disposeBag)
        
        mainView.affirmationsView
            .didComplete
            .emit(to: Binder(mainView.completeView) { base, void in
                base.show()
            })
            .disposed(by: disposeBag)
        
        mainView.affirmationsView
            .tickProgress
            .emit(to: mainView.timeProgressView.rx.progress)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.settingsView.oneMinuteButton.rx.tap.asObservable(),
                mainView.settingsView.fiveMinuteButton.rx.tap.asObservable(),
                mainView.settingsView.tenMinuteButton.rx.tap.asObservable()
            )
            .bind(to: Binder(mainView.settingsView) { base, void in
                base.hide()
            })
            .disposed(by: disposeBag)
        
        let minutes = Observable
            .merge(
                mainView.settingsView.oneMinuteButton.rx.tap.map { 1 },
                mainView.settingsView.fiveMinuteButton.rx.tap.map { 5 },
                mainView.settingsView.tenMinuteButton.rx.tap.map { 10 }
            )
            .asSignal(onErrorSignalWith: .never())
        
        let output = viewModel.configure(input: PracticeViewModel.Input(
            didSelectTime: minutes,
            currentAffirmation: mainView.affirmationsView.currentAffirmation,
            currentIndex: mainView.affirmationsView.index,
            didTapMark: mainView.bookmarkButton.rx.tap.asSignal()
        ))
        
        output.affirmations
            .drive(Binder(mainView.affirmationsView) { base, affirmations in
                base.setup(affirmations: affirmations)
            })
            .disposed(by: disposeBag)
        
        output.marked
            .drive(Binder(self) { base, marked in
                base.bookmark(marked)
            })
            .disposed(by: disposeBag)
        
        output.progress
            .drive(Binder(mainView) { base, progress in
                base.setup(progress: progress)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension PracticeViewController {
    static func make() -> PracticeViewController {
        let vc = PracticeViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension PracticeViewController {
    func bookmark(_ marked: Bool) {
        let image = UIImage(named: marked ? "Practice.Saved" : "Practice.Unsaved")
        mainView.bookmarkButton.setImage(image, for: .normal)
    }
}
