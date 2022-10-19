//
//  LoginViewModel.swift
//  Calculator
//
//  Created by Роман on 22.09.2022.
//

import RxSwift
import FirebaseAuth
import FirebaseDatabase

//MARK: - Protocol

protocol LoginvViewModelPorotcol {
  
  func signIn(email: String, password: String, completion: @escaping () -> ())
}

//MARK: - View Model

class LoginViewModel: LoginvViewModelPorotcol {
  
  //MARK: - Properties
  
  var ref: DatabaseReference?
  var isSigned = PublishSubject<Bool>()
  
  //MARK: - Initializers
  
  init() {
    output()
  }
  
  //MARK: - Private Methods
  
  private func output() {
    ref = Database.database().reference(withPath: "users")
  }
  
  //MARK: - Public Methods
  
  public func signIn(email: String, password: String, completion: @escaping () -> ()) {
    
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
      
      guard error == nil, user != nil else {
        
        errorSubject.onNext(error)
        completion()
        return
      }
      
      self?.isSigned.onNext(true)
    }
  }
  
}
