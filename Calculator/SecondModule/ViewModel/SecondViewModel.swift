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

//MARK: - Protocol

protocol SecondViewModelProtocol {
  var isLoading: Driver<Bool> { get }
  var empty: Driver<Bool> { get }
  var content: Driver<[ItemSection<FoodSelected>]> { get }
  var caloriesSum: Driver<Int> { get }
  
  func fetchData()
  func deleteData(text: String)
}

//MARK: - View Model

class SecondViewModel: SecondViewModelProtocol {
  // Internal
  var loadingSubject = PublishSubject<Bool>()
  var isLoading: Driver<Bool> {
    return loadingSubject.asDriver(onErrorJustReturn: false)
  }
  
  var emptySubject = PublishSubject<Bool>()
  var empty: Driver<Bool> {
    return emptySubject.asDriver(onErrorDriveWith: .empty())
  }
  
  var contentSubject = BehaviorSubject<[ItemSection<FoodSelected>]>(value: [ItemSection(header: "", items: [FoodSelected]())])
  var content: Driver<[ItemSection<FoodSelected>]> {
    return contentSubject.asDriver(onErrorDriveWith: .empty())
  }
  
  var caloriesSumSubject = PublishSubject<Int>()
  var caloriesSum: Driver<Int> {
    return caloriesSumSubject.asDriver(onErrorDriveWith: .empty())
  }
  
  // Private
  private var user: AppUser?
  private var ref: DatabaseReference?
  
  private let bag = DisposeBag()
  
  //MARK: - Initializers
  
  init() {
    guard let currentUser = Auth.auth().currentUser else { return }
    user = AppUser(user: currentUser)
    guard let userId = user?.uid else { return }
    ref = Database.database().reference(withPath: "users").child(userId).child("food")
    
    output()
  }
  
  //MARK: - Private Methods
  
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
      .subscribe()
      .disposed(by: bag)
  }
  
  //MARK: - Public Methods
  
  public func fetchData() {
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
  
  public func deleteData(text: String) {
    ref?.child(text).removeValue()
    self.fetchData()
  }
}
