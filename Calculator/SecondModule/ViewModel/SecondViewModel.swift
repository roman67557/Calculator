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
  
  var contentSubject: BehaviorSubject<[ItemSection<FoodSelected>]> { get }
  var content: Driver<[ItemSection<FoodSelected>]> { get }
  
  var caloriesSumSubject: PublishSubject<Int> { get }
  var caloriesSum: Driver<Int> { get }
  
  func fetchData()
  func deleteData(text: String)
}

class SecondViewModel: SecondViewModelProtocol {
  
  private var user: AppUser?
  private var ref: DatabaseReference?
  
  internal var loadingSubject = PublishSubject<Bool>()
  var isLoading: Driver<Bool> {
    return loadingSubject.asDriver(onErrorJustReturn: false)
  }
  
  internal var emptySubject = PublishSubject<Bool>()
  var empty: Driver<Bool> {
    return emptySubject.asDriver(onErrorDriveWith: .empty())
  }
  
  internal var contentSubject = BehaviorSubject<[ItemSection<FoodSelected>]>(value: [ItemSection(header: "", items: [FoodSelected]())])
  var content: Driver<[ItemSection<FoodSelected>]> {
    return contentSubject.asDriver(onErrorDriveWith: .empty())
  }
  
  var caloriesSumSubject = PublishSubject<Int>()
  var caloriesSum: Driver<Int> {
    return caloriesSumSubject.asDriver(onErrorDriveWith: .empty())
  }
  
  private let bag = DisposeBag()
  
  init() {
    
    guard let currentUser = Auth.auth().currentUser else { return }
    user = AppUser(user: currentUser)
    guard let userId = user?.uid else { return }
    ref = Database.database().reference(withPath: "users").child(userId).child("food")
    
    output()
  }
  
  private func output() {
    
    foodSelectedSubject
      .map({ [weak self] elements -> [ItemSection<FoodSelected>] in
        var sections: [ItemSection<FoodSelected>] = []
        
        if elements.isEmpty {
          self?.emptySubject.onNext(false)
          self?.loadingSubject.onNext(true)
        } else {
          
          self?.emptySubject.onNext(true)
          self?.loadingSubject.onNext(true)
          
          var caloriesSum = 0
          
          elements.forEach { element in
            
            let section = ItemSection(header: "", items: [element])
            
            caloriesSum += element.calories ?? 0
            sections.append(section)
          }
          
          self?.caloriesSumSubject.onNext(caloriesSum)
          self?.contentSubject.onNext(sections)
        }
        return sections
      })
//      .subscribe { [weak self] elements in
//
//        if elements.isEmpty {
//          self?.emptySubject.onNext(false)
//          self?.loadingSubject.onNext(true)
//        } else {
//
//          self?.emptySubject.onNext(true)
//          self?.loadingSubject.onNext(true)
//          self?.contentSubject.onNext(elements)
//
//          var caloriesSum = 0
//          for item in elements {
//            caloriesSum += item.calories ?? 0
//          }
//          self?.caloriesSumSubject.onNext(caloriesSum)
//        }
//      }
      .subscribe()
      .disposed(by: bag)
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
  
  func deleteData(text: String) {
    
//    foodSelectedModel.remove(at: indexPath.section)

    ref?.child(text).removeValue()
    self.fetchData()
//    foodSelectedSubject.onNext(foodSelectedModel)
  }
  
}
