//
//  OWCCollectionView.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 03.08.2023.
//

import UIKit

final class OWCCollectionView: UICollectionView {
    var didSelectAction: (() -> Void)?
    
    lazy var elements = [OWCCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OWCCollectionView {
    func setup(elements: [OWCCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension OWCCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: OWCCollectionCell.self), for: indexPath) as! OWCCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension OWCCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 151.scale, height: 47.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements[indexPath.row].marked.toggle()
        reloadItems(at: [indexPath])
        
        didSelectAction?()
    }
}

// MARK: Private
private extension OWCCollectionView {
    func initialize() {
        register(OWCCollectionCell.self, forCellWithReuseIdentifier: String(describing: OWCCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
