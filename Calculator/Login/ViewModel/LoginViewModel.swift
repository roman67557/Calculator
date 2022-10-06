//
//  LoginViewModel.swift
//  Calculator
//
//  Created by Роман on 22.09.2022.
//

import RxSwift
import FirebaseAuth
import FirebaseDatabase

protocol LoginvViewModelPorotcol {
  
  func signIn(email: String, password: String, completion: @escaping () -> ())
}

class LoginViewModel: LoginvViewModelPorotcol {
  
  var ref: DatabaseReference?
  var isSigned = PublishSubject<Bool>()
  
  init() {
    output()
  }
  
  func output() {
    ref = Database.database().reference(withPath: "users")
  }
  
  func signIn(email: String, password: String, completion: @escaping () -> ()) {
    
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
      
      guard error == nil, user != nil else {
        completion()
        return
      }
      
//      guard let userId = user?.user.uid, let email = user?.user.email else { return }
//      let userRef = self?.ref?.child(userId)
//      userRef?.setValue(["email": email, "name": name])
      
      self?.isSigned.onNext(true)
    }
  }
}
