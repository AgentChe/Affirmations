//
//  OWCCollectionElement.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 03.08.2023.
//

final class OWCCollectionElement {
    let category: Category
    var marked: Bool
    
    init(category: Category, marked: Bool = false) {
        self.category = category
        self.marked = marked
    }
}
