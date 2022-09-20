//
//  FoodModel.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

import Foundation
import FirebaseDatabase

// MARK: - Nutritionix
struct Nutritionix: Codable {
  let branded: [Branded]?
  let nutritionixSelf: [SelfElement]?
  let common: [Common]?
  
  enum CodingKeys: String, CodingKey {
    case branded
    case nutritionixSelf = "self"
    case common
  }
}

// MARK: - Branded
struct Branded: Codable {
  let brandName: String?
  let foodName: String?
  let servingUnit, nixBrandID, brandNameItemName: String?
  let servingQty, nfCalories: Int?
  let brandType: Int?
  let nixItemID: String?
  
  enum CodingKeys: String, CodingKey {
    case brandName = "brand_name"
    case brandNameItemName = "brand_name_item_name"
    case brandType = "brand_type"
    case foodName = "food_name"
    case nfCalories = "nf_calories"
    case nixBrandID = "nix_brand_id"
    case nixItemID = "nix_item_id"
    case servingQty = "serving_qty"
    case servingUnit = "serving_unit"
  }
}

// MARK: - Common
struct Common: Codable {
  let foodName: String
  let image: String?
  let tagID, tagName: String?
  
  enum CodingKeys: String, CodingKey {
    case foodName = "food_name"
    case image
    case tagID = "tag_id"
    case tagName = "tag_name"
  }
}

// MARK: - SelfElement
struct SelfElement: Codable {
  let foodName, servingUnit: String?
  let nixBrandID: JSONNull?
  let servingQty, nfCalories: Double?
  let brandName: JSONNull?
  let uuid: String?
  let nixItemID: JSONNull?
  
  enum CodingKeys: String, CodingKey {
    case foodName = "food_name"
    case servingUnit = "serving_unit"
    case nixBrandID = "nix_brand_id"
    case servingQty = "serving_qty"
    case nfCalories = "nf_calories"
    case brandName = "brand_name"
    case uuid
    case nixItemID = "nix_item_id"
  }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
  
  public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
    return true
  }
  
  public var hashValue: Int {
    return 0
  }
  
  public init() {}
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if !container.decodeNil() {
      throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encodeNil()
  }
}

extension Common: Equatable {
  
  static func == (lhs: Common, rhs: Common) -> Bool {
    
    return lhs.foodName == rhs.foodName
  }
  
}

extension Common: Hashable {
  
  func hash(into hasher: inout Hasher) {
    
    hasher.combine(foodName)
  }
  
}

import Foundation

// MARK: - Edamam
struct Edamam: Codable {
    let text: String?
    let parsed: [Parsed]?
    let hints: [Hint]?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case text, parsed, hints
        case links = "_links"
    }
}

// MARK: - Hint
struct Hint: Codable {
    let food: HintFood?
    let measures: [Measure]?
}

// MARK: - HintFood
struct HintFood: Codable {
    let foodID, label: String?
    let nutrients: Nutrients?
    let category: Category?
    let categoryLabel: CategoryLabel?
    let image: String?
    let foodContentsLabel, brand: String?
    let servingSizes: [ServingSize]?
    let servingsPerContainer: Int?

    enum CodingKeys: String, CodingKey {
        case foodID = "foodId"
        case label, nutrients, category, categoryLabel, image, foodContentsLabel, brand, servingSizes, servingsPerContainer
    }
}

enum Category: String, Codable {
    case genericFoods = "Generic foods"
    case genericMeals = "Generic meals"
    case packagedFoods = "Packaged foods"
}

enum CategoryLabel: String, Codable {
    case food = "food"
    case meal = "meal"
}

// MARK: - Nutrients
struct Nutrients: Codable {
    let enercKcal, procnt, fat, chocdf: Double?
    let fibtg: Double?

    enum CodingKeys: String, CodingKey {
        case enercKcal = "ENERC_KCAL"
        case procnt = "PROCNT"
        case fat = "FAT"
        case chocdf = "CHOCDF"
        case fibtg = "FIBTG"
    }
}

// MARK: - ServingSize
struct ServingSize: Codable {
    let uri: String?
    let label: String?
    let quantity: Double?
}

// MARK: - Measure
struct Measure: Codable {
    let uri: String?
    let label: String?
    let qualified: [Qualified]?
}

// MARK: - Qualified
struct Qualified: Codable {
    let qualifiers: [Qualifier]?
}

// MARK: - Qualifier
struct Qualifier: Codable {
    let uri: String?
    let label: Label?
}

enum Label: String, Codable {
    case chopped = "chopped"
    case large = "large"
    case medium = "medium"
    case quartered = "quartered"
    case sliced = "sliced"
    case small = "small"
}

// MARK: - Links
struct Links: Codable {
    let next: Next?
}

// MARK: - Next
struct Next: Codable {
    let title: String?
    let href: String?
}

// MARK: - Parsed
struct Parsed: Codable {
    let food: ParsedFood?
}

// MARK: - ParsedFood
struct ParsedFood: Codable {
    let foodID, label: String?
    let nutrients: Nutrients?
    let category: Category?
    let categoryLabel: CategoryLabel?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case foodID = "foodId"
        case label, nutrients, category, categoryLabel, image
    }
}
