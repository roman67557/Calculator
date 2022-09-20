//
//  appUser.swift
//  Calculator
//
//  Created by Роман on 29.08.2022.
//

import Foundation
import FirebaseAuth

struct AppUser {
  
  let uid: String
  let email: String
  
  init(user: User) {
    self.uid = user.uid
    self.email = user.email ?? ""
  }
}
