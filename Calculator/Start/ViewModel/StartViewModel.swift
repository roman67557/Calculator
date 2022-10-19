//
//  StartViewModel.swift
//  Calculator
//
//  Created by Роман on 26.07.2022.
//

import RxRelay
import RxCocoa

//MARK: - Protocol

protocol StartViewModelProtocol {
  
  //MARK: - Properties
  
  var loginButtonRelay: PublishRelay<ControlEvent<Void>> { get }
  var registrationButtonRelay: PublishRelay<ControlEvent<Void>> { get }
}

//MARK: - View Model

class StartViewModel: StartViewModelProtocol {
  
  //MARK: - Properties
  
  var loginButtonRelay = PublishRelay<ControlEvent<Void>>()
  var registrationButtonRelay = PublishRelay<ControlEvent<Void>>()
}
