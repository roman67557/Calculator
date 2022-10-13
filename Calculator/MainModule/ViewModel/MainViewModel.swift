//
//  MainViewModel.swift
//  Calculator
//
//  Created by Роман on 22.09.2022.
//

import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseDatabase

protocol MainViewModelProtocol {
  
  var searchSubject: PublishSubject<String> { get }
  var searchObserver: AnyObserver<String> { get }
  
  var loadingSubject: PublishSubject<Bool> { get }
  var isLoading: Driver<Bool> { get }
  
  var errorSubject: PublishSubject<SearchError?> { get }
  var error: Driver<SearchError?> { get }
  
  var contentSubject: PublishSubject<[ItemSection<Branded>]> { get }
  var content: Driver<[ItemSection<Branded>]> { get }
  
  var goSubject: PublishSubject<Branded> { get }
  
  func setupUser()
  
  func goToDetailed(model: Branded)
}

class MainViewModel: MainViewModelProtocol {
  
  var networkService: NetworkAPI!
  
  private let bag = DisposeBag()
  
  internal var searchSubject = PublishSubject<String>()
  var searchObserver: AnyObserver<String> {
    return searchSubject.asObserver()
  }
  
  internal var loadingSubject = PublishSubject<Bool>()
  var isLoading: Driver<Bool> {
    return loadingSubject.asDriver(onErrorJustReturn: false)
  }
  
  internal var errorSubject = PublishSubject<SearchError?>()
  var error: Driver<SearchError?> {
    return errorSubject.asDriver(onErrorJustReturn: SearchError.unkowned)
  }
  
  internal var contentSubject = PublishSubject<[ItemSection<Branded>]>()
  var content: Driver<[ItemSection<Branded>]> {
    return contentSubject.asDriver(onErrorJustReturn: [])
  }
  
  var goSubject = PublishSubject<Branded>()
  
  private var user: AppUser?
  private var ref: DatabaseReference?
  
  init() {
    
    output()
  }
  
  private func output() {
    
    searchSubject
      .asObservable()
      .distinctUntilChanged()
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .flatMapLatest({ [unowned self] term -> Observable<[Branded]> in
        
        self.errorSubject.onNext(nil)
        self.loadingSubject.onNext(true)
        
        return networkService.fetchFood(searchTerm: term)
          .catch { [unowned self] error -> Observable<[Branded]> in
            self.errorSubject.onNext(SearchError.underlyingError(error))
            return Observable.empty()
          }
      })
//      .map({ $0.sorted(by: { $0.foodName?.localizedCaseInsensitiveCompare($1.foodName ?? Strings.shared.error) == .orderedAscending }) })
      .map({ [weak self] elements -> [ItemSection<Branded>] in
        var sections: [ItemSection<Branded>] = []
        self?.loadingSubject.onNext(false)
        
        if elements.isEmpty {
          self?.errorSubject.onNext(SearchError.notFound)
        } else {
          elements.forEach { element in
            
            let section = ItemSection(header: "", items: [element])
            sections.append(section)
          }
          self?.contentSubject.onNext(sections)
        }
        return sections
      })
      .subscribe()
      .disposed(by: bag)
  }
  
  func goToDetailed(model: Branded) {
    goSubject.onNext(model)
  }
  
  public func setupUser() {
    
    guard let currentUser = Auth.auth().currentUser else { return }
    user = AppUser(user: currentUser)
    guard let userId = user?.uid else { return }
    ref = Database.database().reference(withPath: "users").child(userId)
  }
  
}
