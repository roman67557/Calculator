//
//  UserViewModel.swift
//  Calculator
//
//  Created by Роман on 05.08.2022.
//

import FirebaseAuth

protocol UserViewModelProtocol {
  
  func signOut()
}

class UserViewModel: UserViewModelProtocol {
  
  func signOut() {
    do {
      try Auth.auth().signOut()
    } catch {
      print(error.localizedDescription)
    }
  }
  
}
