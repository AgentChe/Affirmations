//
//  FavoritesTableView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 25.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoritesTableView: UITableView {
    lazy var elements = [Affirmation]()
    
    private lazy var didMenuTappedTrigger = PublishRelay<Affirmation>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension FavoritesTableView {
    func setup(elements: [Affirmation]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didMenuTapped: Signal<Affirmation> {
        didMenuTappedTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension FavoritesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withIdentifier: String(describing: FavoritesTableCell.self)) as! FavoritesTableCell
        cell.setup(affirmation: element)
        cell.didTapMenu = { [weak self] in
            self?.didMenuTappedTrigger.accept(element)
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension FavoritesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension FavoritesTableView {
    func initialize() {
        register(FavoritesTableCell.self, forCellReuseIdentifier: String(describing: FavoritesTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
