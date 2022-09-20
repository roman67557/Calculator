//
//  NetworkAPI.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.

import RxSwift
import RxCocoa

protocol NetworkAPI {
  
  func fetchFood(searchTerm: String) -> Observable<[Branded]>
}
