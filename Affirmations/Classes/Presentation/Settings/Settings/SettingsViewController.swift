//
//  SettingsViewController.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 11.09.2023.
//

import UIKit
import RxSwift
import MessageUI

final class SettingsViewController: UIViewController {
    lazy var mainView = SettingsView()
    
    private lazy var viewModel = SettingsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.didSelect
            .emit(to: Binder(self) { base, element in
                base.select(element: element)
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: SettingsViewModel.Input())
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SettingsViewController {
    static func make() -> SettingsViewController {
        let vc = SettingsViewController()
        vc.navigationItem.title = "Settings.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: MFMailComposeViewControllerDelegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: Private
private extension SettingsViewController {
    func select(element: SettingsTableElement) {
        switch element {
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .route(let route):
            switch route {
            case .gender:
                let vc = GenderIdentityViewController.make()
                navigationController?.pushViewController(vc, animated: true)
            case .contentPreferences:
                let vc = ContentPreferencesViewController.make()
                navigationController?.pushViewController(vc, animated: true)
            case .reminders:
                let vc = RemindersViewController.make()
                navigationController?.pushViewController(vc, animated: true)
            case .language:
                let vc = LanguageViewController.make()
                navigationController?.pushViewController(vc, animated: true)
            case .favorites:
                let vc = FavoritesViewController.make()
                navigationController?.pushViewController(vc, animated: true)
            case .myAffirmations:
                let vc = MyAffirmationsViewController.make()
                navigationController?.pushViewController(vc, animated: true)
            case .review:
                review()
            case .share:
                share()
            case .privacyPolicy:
                open(path: GlobalDefinitions.privacyPolicy)
            case .termsAndConditions:
                open(path: GlobalDefinitions.termsOfUse)
            }
        case .backup:
            let vc = BackupViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func review() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let messageFormat = "ID: %@ \n OS: %@ \n Version: %@ \n Device: %@ \n"
        let message = String(format: messageFormat,
                             UIDevice.idfv?.uppercased() ?? "",
                             UIDevice.current.systemVersion,
                             UIDevice.appVersion ?? "",
                             UIDevice.current.model)
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([GlobalDefinitions.supportEmail])
        mail.setMessageBody(message, isHTML: false)
        present(mail, animated: true)
    }
    
    func share() {
        guard let url = URL(string:"https://apps.apple.com/us/app/positive-affirmations-daily/id6462790105") else {
            return
        }
        
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(controller, animated: true)
    }
    
    func open(path: String) {
        guard let url = URL(string: path) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}
