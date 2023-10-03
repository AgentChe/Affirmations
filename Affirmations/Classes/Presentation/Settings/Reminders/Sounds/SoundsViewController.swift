//
//  SoundsViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 22.09.2023.
//

import UIKit
import RxSwift
import AVFoundation

final class SoundsViewController: UIViewController {
    lazy var mainView = SoundsView()
    
    private let viewModel: SoundsViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private var player: AVAudioPlayer?
    
    private let didSelect: (Sound) -> Void
    
    private init(sound: Sound, didSelect: @escaping (Sound) -> Void) {
        self.viewModel = SoundsViewModel(sound: sound)
        self.didSelect = didSelect
        
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
        
        let output = viewModel.configure(input: SoundsViewModel.Input(
            didTapContinue: mainView.button.rx.tap.asSignal(),
            didSelect: mainView.tableView.didSelect
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
    }
}

// MARK: Public
extension SoundsViewController {
    static func make(sound: Sound, didSelect: @escaping (Sound) -> Void) -> SoundsViewController {
        let vc = SoundsViewController(sound: sound, didSelect: didSelect)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "EditReminder.Sound".localized
        return vc
    }
}

// MARK: Private
private extension SoundsViewController {
    func route(_ route: SoundsViewModel.Route) {
        switch route {
        case .selected(let sound):
            didSelect(sound)
            navigationController?.popViewController(animated: true)
        case .play(let file):
            stop()
            play(soundName: file)
        }
    }
    
    func play(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            return
        }
        
        player = try? AVAudioPlayer(contentsOf: url)
        
        player?.play()
    }
    
    func stop() {
        player?.stop()
        player = nil
    }
}
