//
//  FoodSelected.swift
//  Calculator
//
//  Created by Роман on 29.08.2022.
//

import Foundation
import RxSwift
import FirebaseDatabase

var foodSelectedSubject = PublishSubject<[FoodSelected]>()
var foodSelectedModel = [FoodSelected]()

struct FoodSelected {
  let ref: DatabaseReference?
  
  let brandName: String?
  let foodName: String?
  let weight: Int?
  let calories: Int?
  
  init(brandName: String, foodName: String, weight: Int, calories: Int) {
    self.brandName = brandName
    self.foodName = foodName
    self.weight = weight
    self.calories = calories
    self.ref = nil
  }
  
  init(snapShot: DataSnapshot) {
    let snapshotValue = snapShot.value as? [String: AnyObject]
    brandName = snapshotValue?["brandName"] as? String ?? ""
    foodName = snapshotValue?["foodName"] as? String ?? ""
    weight = snapshotValue?["weight"] as? Int ?? 0
    calories = snapshotValue?["calories"] as? Int ?? 0
    ref = snapShot.ref
  }
  
  func convertToDictionary() -> Any {
    return ["brandName": brandName as Any, "foodName": foodName as Any, "weight": weight as Any, "calories": calories as Any]
  }
 }











