//
//  EditReminderTableView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class EditReminderTableView: UITableView {
    lazy var elements = [EditReminderTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<EditReminderTableElement>()
    private lazy var didChangeSettingsTrigger = PublishRelay<Void>()
    private lazy var didChangeScheduleTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension EditReminderTableView {
    func setup(elements: [EditReminderTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<EditReminderTableElement> {
        didSelectTrigger.asSignal()
    }
    
    var didChangeSettings: Signal<Void> {
        didChangeSettingsTrigger.asSignal()
    }
    
    var didChangeSchedule: Signal<Void> {
        didChangeScheduleTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension EditReminderTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .categories(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: EditReminderCategoriesCell.self), for: indexPath) as! EditReminderCategoriesCell
            cell.setup(element: element)
            return cell
        case .settings(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: EditReminderSettingsCell.self), for: indexPath) as! EditReminderSettingsCell
            cell.setup(element: element)
            cell.didChange = { [weak self] in
                self?.didChangeSettingsTrigger.accept(Void())
            }
            return cell
        case .schedule(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: EditReminderScheduleCell.self), for: indexPath) as! EditReminderScheduleCell
            cell.setup(element: element)
            cell.didChange = { [weak self] in
                self?.didChangeScheduleTrigger.accept(Void())
            }
            return cell
        case .sound(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: EditReminderSoundCell.self), for: indexPath) as! EditReminderSoundCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension EditReminderTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .schedule:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension EditReminderTableView {
    func initialize() {
        register(EditReminderCategoriesCell.self, forCellReuseIdentifier: String(describing: EditReminderCategoriesCell.self))
        register(EditReminderSettingsCell.self, forCellReuseIdentifier: String(describing: EditReminderSettingsCell.self))
        register(EditReminderScheduleCell.self, forCellReuseIdentifier: String(describing: EditReminderScheduleCell.self))
        register(EditReminderSoundCell.self, forCellReuseIdentifier: String(describing: EditReminderSoundCell.self))
        
        dataSource = self
        delegate = self
    }
}
