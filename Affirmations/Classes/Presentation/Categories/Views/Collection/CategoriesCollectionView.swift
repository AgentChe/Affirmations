//
//  CategoriesCollectionView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 31.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoriesCollectionView: UICollectionView {
    lazy var elements = [CategoriesCollectionElement]()
    
    private lazy var didSelectTrigger = PublishRelay<CategoriesCollectionElement>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CategoriesCollectionView {
    func setup(elements: [CategoriesCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelectElement: Signal<CategoriesCollectionElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension CategoriesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CategoriesCollectionCell.self), for: indexPath) as! CategoriesCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CategoriesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension CategoriesCollectionView {
    func initialize() {
        register(CategoriesCollectionCell.self, forCellWithReuseIdentifier: String(describing: CategoriesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
