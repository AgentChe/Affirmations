//
//  CategoriesUnitsTableElement.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 22.09.2023.
//

final class CategoriesUnitsTableElement {
    let category: Category
    var marked: Bool
    
    init(category: Category, marked: Bool) {
        self.category = category
        self.marked = marked
    }
}
