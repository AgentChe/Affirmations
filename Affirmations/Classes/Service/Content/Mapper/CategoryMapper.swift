//
//  CategoryMapper.swift
//  Affirmations
//
//  Created by Андрей Чернышев on 02.08.2023.
//

enum CategoryMapper {
    static func widgetsCategories(from json: [String: Any]) -> [Category] {
        guard
            let categoriesArray = json["categories"] as? [[String: Any]],
            let tags = json["tags"] as? [String] else {
            return []
        }
        
        let categories = categoriesArray.compactMap { json -> Category? in
            guard
                let type = json["type"] as? String,
                let name = json["name"] as? String
            else {
                return nil
            }
            
            return Category(
                type: type,
                name: name,
                free: true
            )
        }
        
        return categories.filter { category -> Bool in
            tags.contains(where: { $0 == category.type })
        }
    }
}
