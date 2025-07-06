//
//  appUser.swift
//  Calculator
//
//  Created by Роман on 29.08.2022.
//

import Foundation
import FirebaseAuth

struct AppUser {
  let uid: String?
  let email: String?
  
  var name: String?
  var photo: String?
  
  var summary: [Summary]?
  
  init(user: User) {
    self.uid = user.uid
    self.email = user.email ?? ""
  }
  
  init(name: String, photo: String) {
    
    self.name = name
    self.photo = photo
    
    self.uid = nil
    self.email = nil
  }
  
  func convertToDictionary() -> Any {
    return ["uid": uid as Any, "email": email as Any, "name": name as Any]
  }

}

struct Summary {
  
  
}
