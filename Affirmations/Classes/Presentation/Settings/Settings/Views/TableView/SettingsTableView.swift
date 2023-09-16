//
//  SettingsTableView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 11.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsTableView: UITableView {
    lazy var elements = [SettingsTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<SettingsTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsTableView {
    func setup(elements: [SettingsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<SettingsTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SettingsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .paygate:
            return dequeueReusableCell(withIdentifier: String(describing: SettingsPaygateCell.self), for: indexPath)
        case .route(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsRouteCell.self), for: indexPath) as! SettingsRouteCell
            cell.setup(element: element)
            return cell
        case .backup(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsBackupCell.self), for: indexPath) as! SettingsBackupCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SettingsTableView {
    func initialize() {
        register(SettingsPaygateCell.self, forCellReuseIdentifier: String(describing: SettingsPaygateCell.self))
        register(SettingsRouteCell.self, forCellReuseIdentifier: String(describing: SettingsRouteCell.self))
        register(SettingsBackupCell.self, forCellReuseIdentifier: String(describing: SettingsBackupCell.self))
        
        dataSource = self
        delegate = self
    }
}
