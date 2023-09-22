//
//  SoundsTableView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 22.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class SoundsTableView: UITableView {
    lazy var elements = [SoundsTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<SoundsTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SoundsTableView {
    func setup(elements: [SoundsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<SoundsTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SoundsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: SoundsTableCell.self)) as! SoundsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension SoundsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
        
        guard !elements[indexPath.row].marked else {
            return
        }
        
        elements.enumerated().forEach { index, element in
            element.marked = index == indexPath.row
        }
        
        reloadData()
    }
}

// MARK: Private
private extension SoundsTableView {
    func initialize() {
        register(SoundsTableCell.self, forCellReuseIdentifier: String(describing: SoundsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
