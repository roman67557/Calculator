//
//  UserViewModel.swift
//  Calculator
//
//  Created by Роман on 05.08.2022.
//

import FirebaseAuth
import FirebaseDatabase
import RxSwift
import RxCocoa

protocol UserViewModelProtocol {
  
  var userNameSubject: PublishSubject<String> { get }
  
  func signOut()
  func fetchData()
}

class UserViewModel: UserViewModelProtocol {
  
  var userNameSubject = PublishSubject<String>()
  
  var user: AppUser?
  var ref: DatabaseReference?
  
  init() {
    
    guard let currentUser = Auth.auth().currentUser else { return }
    user = AppUser(user: currentUser)
    guard let userId = user?.uid else { return }
    ref = Database.database().reference(withPath: "users").child(userId)
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func fetchData()  {
    
    ref?.child("name").observe(.value, with: { [weak self] snapshot in
      
      guard let name = snapshot.value as? String else { return }
      
      self?.userNameSubject.onNext(name)
    })
  }
  
}
