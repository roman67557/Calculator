//
//  SecondViewModel.swift
//  Calculator
//
//  Created by Роман on 25.09.2022.
//

import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseDatabase

protocol SecondViewModelProtocol {
  
  var loadingSubject: PublishSubject<Bool> { get }
  var isLoading: Driver<Bool> { get }
  
  var emptySubject: PublishSubject<Bool> { get }
  var empty: Driver<Bool> { get }
  
  var contentSubject: PublishSubject<[FoodSelected]> { get }
  var content: Driver<[FoodSelected]> { get }
  
  var caloriesSumSubject: PublishSubject<Int> { get }
  var caloriesSum: Driver<Int> { get }
  
  func fetchData()
  func deleteData(indexPath: IndexPath, cellText: String)
}

class SecondViewModel: SecondViewModelProtocol {
  
  private var user: AppUser?
  private var ref: DatabaseReference?
  
  private let bag = DisposeBag()
  
  internal var loadingSubject = PublishSubject<Bool>()
  var isLoading: Driver<Bool> {
    return loadingSubject.asDriver(onErrorJustReturn: false)
  }
  
  internal var emptySubject = PublishSubject<Bool>()
  var empty: Driver<Bool> {
    return emptySubject.asDriver(onErrorDriveWith: .empty())
  }
  
  internal var contentSubject = PublishSubject<[FoodSelected]>()
  var content: Driver<[FoodSelected]> {
    return contentSubject.asDriver(onErrorDriveWith: .empty())
  }
  
  var caloriesSumSubject = PublishSubject<Int>()
  var caloriesSum: Driver<Int> {
    return caloriesSumSubject.asDriver(onErrorDriveWith: .empty())
  }
  
  init() {
    
    guard let currentUser = Auth.auth().currentUser else { return }
    user = AppUser(user: currentUser)
    guard let userId = user?.uid else { return }
    ref = Database.database().reference(withPath: "users").child(userId).child("food")
    
    output()
  }
  
  private func output() {
    
    foodSelectedSubject
      .subscribe { [weak self] elements in
        
        if elements.isEmpty {
          self?.emptySubject.onNext(false)
          self?.loadingSubject.onNext(true)
          self?.caloriesSumSubject.onNext(0)
        } else {
          
          self?.emptySubject.onNext(true)
          self?.loadingSubject.onNext(true)
          self?.contentSubject.onNext(elements)
          
          var caloriesSum = 0
          for item in elements {
            caloriesSum += item.calories ?? 0
          }
          self?.caloriesSumSubject.onNext(caloriesSum)
        }
      }
      .disposed(by: bag)
    
//    foodSelectedSubject
//      .asObservable()
//      .subscribe(onNext: { [weak self] foodSelected in
//        var caloriesSum = 0
//        for item in foodSelected {
//          caloriesSum += item.calories ?? 1
//        }
//        self?.caloriesSumSubject.onNext(caloriesSum)
//      })
//      .disposed(by: bag)
  }
  
  func fetchData() {
    
    ref?.observe(.value, with: { snapshot in
      var foodSelected = [FoodSelected]()
      for item in snapshot.children {
        let food = FoodSelected(snapShot: item as? DataSnapshot ?? DataSnapshot())
        foodSelected.append(food)
      }
      foodSelectedModel = foodSelected
      foodSelectedSubject.onNext(foodSelectedModel)
    })
  }
  
  func deleteData(indexPath: IndexPath, cellText: String) {
    
    foodSelectedModel.remove(at: indexPath.row)
    
    ref?.child(cellText).removeValue()
    
    foodSelectedSubject.onNext(foodSelectedModel)
  }
  
}
