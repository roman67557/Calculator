//
//  RegistrationViewModel.swift
//  Calculator
//
//  Created by Роман on 27.07.2022.
//

import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseDatabase

protocol RegistrationViewModelProtocol {
  
  var isRegistered: PublishSubject<Bool> { get }
  
  func registration(name: String, email: String, password: String, completion: @escaping () -> ())
}

class RegistrationViewModel: RegistrationViewModelProtocol {
  
  var ref: DatabaseReference?
  var isRegistered = PublishSubject<Bool>()
  
  init() {
      output()
  }
  
  func output() {
    ref = Database.database().reference(withPath: "users")
  }
  
  func registration(name: String, email: String, password: String, completion: @escaping () -> ()) {
    
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
      
      guard error == nil, user != nil else {
        completion()
        return
      }
      
      guard let userId = user?.user.uid, let email = user?.user.email else { return }
      let userRef = self?.ref?.child(userId)
      userRef?.setValue(["email": email, "name": name])
      
      self?.isRegistered.onNext(true)
    }
  }

}
