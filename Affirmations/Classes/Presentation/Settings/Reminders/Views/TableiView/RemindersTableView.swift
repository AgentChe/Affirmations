//
//  RemindersTableView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 21.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class RemindersTableView: UITableView {
    lazy var elements = [Reminder]()
    
    private lazy var didChangeEnableTrigger = PublishRelay<Reminder>()
    private lazy var didSelectTrigger = PublishRelay<Reminder>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RemindersTableView {
    func setup(elements: [Reminder]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didChangeEnable: Signal<Reminder> {
        didChangeEnableTrigger.asSignal()
    }
    
    var didSelect: Signal<Reminder> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension RemindersTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withIdentifier: String(describing: RemindersTableCell.self)) as! RemindersTableCell
        cell.setup(element: element)
        cell.didChangeEnable = { [weak self] in
            guard let self else { return }
            
            if let index = self.elements.firstIndex(where: { $0.id == element.id }) {
                let updated = self.elements[index].toggleEnable()
                self.elements[index] = updated
                
                self.didChangeEnableTrigger.accept(updated)
            }
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension RemindersTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension RemindersTableView {
    func initialize() {
        register(RemindersTableCell.self, forCellReuseIdentifier: String(describing: RemindersTableCell.self))
        
        dataSource = self
        delegate = self
    }
}

// MARK: Additional
private extension Reminder {
    func toggleEnable() -> Reminder {
        Reminder(
            id: id,
            created: created,
            count: count,
            start: start,
            end: end,
            weekSchedule: weekSchedule,
            sound: sound,
            categories: categories,
            enable: !enable
        )
    }
}
