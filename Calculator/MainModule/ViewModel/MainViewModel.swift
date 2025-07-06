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

//MARK: - Protocol

protocol MainViewModelProtocol {
  var searchObserver: AnyObserver<String> { get }
  var isLoading: Driver<Bool> { get }
  var error: Driver<SearchError?> { get }
  var content: Driver<[ItemSection<Branded>]> { get }
  
  var goSubject: PublishSubject<Branded> { get }
  
  func setupUser()
  func goToDetailed(model: Branded)
}

//MARK: - View Model

class MainViewModel: MainViewModelProtocol {
  // Internal
  var searchSubject = PublishSubject<String>()
  var searchObserver: AnyObserver<String> {
    return searchSubject.asObserver()
  }
  
  var loadingSubject = PublishSubject<Bool>()
  var isLoading: Driver<Bool> {
    return loadingSubject.asDriver(onErrorJustReturn: false)
  }
  
  var errorSubject = PublishSubject<SearchError?>()
  var error: Driver<SearchError?> {
    return errorSubject.asDriver(onErrorJustReturn: SearchError.unkowned)
  }
  
  var contentSubject = PublishSubject<[ItemSection<Branded>]>()
  var content: Driver<[ItemSection<Branded>]> {
    return contentSubject.asDriver(onErrorJustReturn: [])
  }
  
  var goSubject = PublishSubject<Branded>()
  private let networkService: NetworkAPI
  
  // Private
  private var user: AppUser?
  private var ref: DatabaseReference?
  
  private let bag = DisposeBag()
  
  //MARK: - Initializers
  
  init(networkService: NetworkAPI) {
    self.networkService = networkService
    output()
  }
  
  //MARK: - Private Methods
  
  private func output() {
    searchSubject
      .asObservable()
      .distinctUntilChanged()
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .flatMapLatest { [weak self, networkService] term -> Observable<[Branded]> in
        self?.errorSubject.onNext(nil)
        self?.loadingSubject.onNext(true)
        
        return networkService.fetchFood(searchTerm: term)
          .catch { [weak self] error -> Observable<[Branded]> in
            self?.errorSubject.onNext(SearchError.underlyingError(error))
            return Observable.empty()
          }
      }
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
  
  //MARK: - Public Methods
  
  public func goToDetailed(model: Branded) {
    goSubject.onNext(model)
  }
  
  public func setupUser() {
    guard let currentUser = Auth.auth().currentUser else { return }
    user = AppUser(user: currentUser)
    guard let userId = user?.uid else { return }
    ref = Database.database().reference(withPath: "users").child(userId)
  }
}
