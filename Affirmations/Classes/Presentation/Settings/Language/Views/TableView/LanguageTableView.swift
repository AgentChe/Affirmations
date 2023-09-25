//
//  LanguageTableView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 25.09.2023.
//

import UIKit

final class LanguageTableView: UITableView {
    lazy var elements = [LanguageTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LanguageTableView {
    func setup(elements: [LanguageTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension LanguageTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: LanguageTableCell.self)) as! LanguageTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension LanguageTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !elements[indexPath.row].marked else {
            return
        }
        
        let marked = elements[indexPath.row].language
        
        elements.forEach {
            $0.marked = $0.language == marked
        }
        
//        elements.enumerated().forEach { index, element in
//            element.marked = index == indexPath.row
//        }
        
        reloadData()
    }
}

// MARK: Private
private extension LanguageTableView {
    func initialize() {
        register(LanguageTableCell.self, forCellReuseIdentifier: String(describing: LanguageTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
