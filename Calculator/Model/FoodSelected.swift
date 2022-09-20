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
  let userId: String
  let ref: DatabaseReference?
  
  let brandName: String?
  let foodName: String?
  let calories: Int?
  
  init(userId: String, brandName: String, foodName: String, calories: Int) {
    self.userId = userId
    self.brandName = brandName
    self.foodName = foodName
    self.calories = calories
    self.ref = nil
  }
  
  init(snapShot: DataSnapshot) {
    let snapshotValue = snapShot.value as? [String: AnyObject]
    userId = snapshotValue?["userId"] as? String ?? ""
    brandName = snapshotValue?["brandName"] as? String ?? ""
    foodName = snapshotValue?["foodName"] as? String ?? ""
    calories = snapshotValue?["calories"] as? Int ?? 0
    ref = snapShot.ref
  }
  
  func convertToDictionary() -> Any {
    return ["userId": userId, "brandName": brandName as Any, "foodName": foodName as Any, "calories": calories ?? 0]
  }
 }











