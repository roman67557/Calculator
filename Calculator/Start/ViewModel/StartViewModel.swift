//
//  StartViewModel.swift
//  Calculator
//
//  Created by Роман on 26.07.2022.
//

import RxRelay
import RxCocoa

protocol StartViewModelProtocol {
  
  var loginButtonRelay: PublishRelay<ControlEvent<Void>> { get }
  var registrationButtonRelay: PublishRelay<ControlEvent<Void>> { get }
}

class StartViewModel: StartViewModelProtocol {
  
  var loginButtonRelay = PublishRelay<ControlEvent<Void>>()
  var registrationButtonRelay = PublishRelay<ControlEvent<Void>>()
}
