//
//  Models.swift
//  HW-3.2-DY
//
//  Created by Denis Yarets on 11/11/2023.
//

import Foundation

// MARK: Enums
enum Links: String {
    case main
    case postRequest
    
    var url: String {
        switch self {
        case .main:
            "https://www.fruityvice.com/api/fruit/all"
        case .postRequest:
            "https://jsonplaceholder.typicode.com/posts"
        }
    }
}

// MARK: Structs
struct Fruit: Codable {
    
    static let empty = Fruit(name: "404", id: 404, family: "404", order: "404", genus: "404", nutritions: Nutrition.empty)
    
    let name: String
    let id: Int
    let family: String
    let order: String
    let genus: String
    let nutritions: Nutrition
    
    var description: String {
        "\(name) is a fruit of \(family) family\n\(nutritions.description)"
    }
}

struct Nutrition: Codable {
    
    static let empty = Nutrition(calories: 404, fat: 404, sugar: 404, carbohydrates: 404, protein: 404)
    
    let calories: Double
    let fat: Double
    let sugar: Double
    let carbohydrates: Double
    let protein: Double
    
    var description: String {
        "Nutrition facts:\nCalories: \(calories) kKal\nFat: \(fat) g\nSugar: \(sugar) g\nCarbohydrated: \(carbohydrates) g\nProtein: \(protein) g"
    }
}

// MARK: Adapters
struct FruitAdapter: Decodable {
    let name: String
    let id: Int
    let family: String
    let order: String
    let genus: String
    let calories: String
    let fat: String
    let sugar: String
    let carbohydrates: String
    let protein: String

    enum CodingKeys: String, CodingKey {
        case name, id, family, order, genus
        case calories = "nutritions[calories]"
        case fat = "nutritions[fat]"
        case sugar = "nutritions[sugar]"
        case carbohydrates = "nutritions[carbohydrates]"
        case protein = "nutritions[protein]"
    }
}

extension Fruit {
    
    static func convertAdapter(from adapter: FruitAdapter) -> Fruit {
        let nutritions = Nutrition(
            calories: Double(adapter.calories) ?? 404,
            fat: Double(adapter.fat) ?? 404,
            sugar: Double(adapter.sugar) ?? 404,
            carbohydrates: Double(adapter.carbohydrates) ?? 404,
            protein: Double(adapter.protein) ?? 404
        )
        return Fruit(
            name: adapter.name,
            id: adapter.id,
            family: adapter.family,
            order: adapter.order,
            genus: adapter.genus,
            nutritions: nutritions
        )
    }
    
}

// MARK: ConvertibleFromJSONDictionary
protocol ConvertibleFromJSONDictionary {
    static func convertSingle(from jsonDictionary: Any) -> Self
    static func convertArray(from jsonDictionary: Any) -> [Self]
}

extension Fruit: ConvertibleFromJSONDictionary {
    
    static func convertSingle(from jsonDictionary: Any) -> Fruit {
        return Fruit.empty
    }
    
    static func convertArray(from jsonDictionary: Any) -> [Fruit] {
        guard let jsonDictionary = jsonDictionary as? [[String: Any]] else {
            print("Unable to match jsonDictionary as [String: Double]")
            return []
        }
    
        return jsonDictionary.compactMap {
            Fruit(
                name: $0["name"] as? String ?? "404",
                id: $0["id"] as? Int ?? 404,
                family: $0["family"] as? String ?? "404",
                order: $0["order"] as? String ?? "404",
                genus: $0["genus"] as? String ?? "404",
                nutritions: Nutrition.convertSingle(from: $0["nutritions"] ?? Nutrition.empty)
            )
        }
    }
    
}

extension Nutrition: ConvertibleFromJSONDictionary {
    static func convertSingle(from jsonDictionary: Any) -> Nutrition {
        guard let jsonDictionary = jsonDictionary as? [String: Double],
              !jsonDictionary.isEmpty
        else {
            print("Unable to match jsonDictionary as [String: Double] or it's empty")
            return Nutrition.empty
        }
        return Nutrition(
            calories: jsonDictionary["calories"] ?? 404,
            fat: jsonDictionary["fat"] ?? 404,
            sugar: jsonDictionary["sugar"] ?? 404,
            carbohydrates: jsonDictionary["carbohydrates"] ?? 404,
            protein: jsonDictionary["protein"] ?? 404
        )
    }
    
    static func convertArray(from jsonDictionary: Any) -> [Nutrition] {
        return []
    }
    
}
