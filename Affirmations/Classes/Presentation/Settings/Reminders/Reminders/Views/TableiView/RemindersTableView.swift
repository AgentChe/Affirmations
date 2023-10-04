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
    lazy var elements = [RemindersTableElement]()
    
    private lazy var didTapProblemTrigger = PublishRelay<Void>()
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
    func setup(elements: [RemindersTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didChangeEnable: Signal<Reminder> {
        didChangeEnableTrigger.asSignal()
    }
    
    var didTapProblem: Signal<Void> {
        didTapProblemTrigger.asSignal()
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
        switch elements[indexPath.row] {
        case .problem:
            return dequeueReusableCell(withIdentifier: String(describing: RemindersTableProblemCell.self), for: indexPath)
        case .reminder(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RemindersTableCell.self)) as! RemindersTableCell
            cell.setup(element: element)
            cell.didChangeEnable = { [weak self] in
                guard let self else { return }
                
                let updated = element.toggleEnable()
                
                if self.elements.indices.contains(indexPath.row) {
                    self.elements[indexPath.row] = .reminder(updated)
                }
                
                self.didChangeEnableTrigger.accept(updated)
            }
            return cell
        }
        
    }
}

// MARK: UITableViewDelegate
extension RemindersTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .problem:
            didTapProblemTrigger.accept(Void())
        case .reminder(let reminder):
            didSelectTrigger.accept(reminder)
        }
    }
}

// MARK: Private
private extension RemindersTableView {
    func initialize() {
        register(RemindersTableProblemCell.self, forCellReuseIdentifier: String(describing: RemindersTableProblemCell.self))
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
