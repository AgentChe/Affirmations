//
//  CategoriesUnitsTableView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 22.09.2023.
//

import UIKit

final class CategoriesUnitsTableView: UITableView {
    lazy var elements = [CategoriesUnitsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CategoriesUnitsTableView {
    func setup(elements: [CategoriesUnitsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CategoriesUnitsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: CategoriesUnitsTableCell.self)) as! CategoriesUnitsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension CategoriesUnitsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elements[indexPath.row].marked.toggle()
        
        reloadData()
    }
}

// MARK: Private
private extension CategoriesUnitsTableView {
    func initialize() {
        register(CategoriesUnitsTableCell.self, forCellReuseIdentifier: String(describing: CategoriesUnitsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
