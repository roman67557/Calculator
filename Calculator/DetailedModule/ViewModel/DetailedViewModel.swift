//
//  DetailedViewModel.swift
//  Calculator
//
//  Created by Роман on 25.09.2022.
//


import RxSwift
import RxRelay
import RxCocoa
import FirebaseAuth
import FirebaseDatabase

//MARK: - Protocol

protocol DetailedViewModelProtocol {
  
  //MARK: - Properties
  
  var closeRelay: PublishRelay<Bool> { get }
  
  var titleSubject: PublishSubject<String> { get }
  var title: Driver<String> { get }
  
  var caloriesSubject: PublishSubject<String> { get }
  var calories: Driver<String> { get }
  
  //MARK: - Methods
  
  func addModel(weight: Int)
  func getCalories() -> String
}

//MARK: - View Model

class DetailedViewModel: DetailedViewModelProtocol {
  
  //MARK: - Properties
  
  var titleSubject = PublishSubject<String>()
  var title: Driver<String> {
    return titleSubject.asDriver(onErrorDriveWith: .empty())
  }
  
  var caloriesSubject = PublishSubject<String>()
  var calories: Driver<String> {
    return caloriesSubject.asDriver(onErrorDriveWith: .empty())
  }
  
  var closeRelay = PublishRelay<Bool>()
  
  //MARK: - Private Properties
  
  private let model: Branded
  
  private var user: AppUser?
  private var ref: DatabaseReference?
  
  private let bag = DisposeBag()
  
  //MARK: - Initializers
  
  init(model: Branded) {
    self.model = model
    
    output()
    
    guard let currentUser = Auth.auth().currentUser else { return }
    user = AppUser(user: currentUser)
    guard let userId = user?.uid else { return }
    ref = Database.database().reference(withPath: "users").child(userId).child("food")
  }
  
  //MARK: - Private Methods
  
  private func output() {
    
    Observable.just(model)
      .asObservable()
      .subscribe(onNext: { [weak self] branded in
        
        self?.caloriesSubject.onNext("\(branded.nfCalories ?? 0)")
        self?.titleSubject.onNext(branded.foodName ?? "")
      })
      .disposed(by: bag)
  }
  
  //MARK: - Public Methods
  
  public func addModel(weight: Int) {
    
    let calories = weight * (model.nfCalories ?? 0) / 100
    
    let food = FoodSelected(brandName: model.brandName ?? "", foodName: model.foodName ?? "", weight: weight, calories: calories)
    let foodRef = ref?.child(model.foodName?.lowercased() ?? "")
    foodRef?.setValue(food.convertToDictionary())
    
    closeRelay.accept(true)
  }
  
  public func getCalories() -> String {
    
    guard let calories = model.nfCalories else { return Strings.shared.error }
    return "\(calories)"
  }
  
}
