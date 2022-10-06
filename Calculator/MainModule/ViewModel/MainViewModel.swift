//
//  MainViewModel.swift
//  Calculator
//
//  Created by Роман on 22.09.2022.
//

import RxSwift
import RxCocoa

protocol MainViewModelProtocol {
  
  var searchSubject: PublishSubject<String> { get }
  var searchObserver: AnyObserver<String> { get }
  
  var loadingSubject: PublishSubject<Bool> { get }
  var isLoading: Driver<Bool> { get }
  
  var errorSubject: PublishSubject<SearchError?> { get }
  var error: Driver<SearchError?> { get }
  
  var contentSubject: PublishSubject<[Branded]> { get }
  var content: Driver<[Branded]> { get }
  
  var goSubject: PublishSubject<Branded> { get }
  
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
  
  internal var contentSubject = PublishSubject<[Branded]>()
  var content: Driver<[Branded]> {
    return contentSubject.asDriver(onErrorJustReturn: [])
  }
  
  var goSubject = PublishSubject<Branded>()
  
  init() {
      output()
  }
  
  func output() {
    
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
      .subscribe(onNext: { [unowned self] elements in
        
        self.loadingSubject.onNext(false)
        
        if elements.isEmpty {
          self.errorSubject.onNext(SearchError.notFound)
        } else {
          self.contentSubject.onNext(elements)
        }
      })
      .disposed(by: bag)
  }
  
  func goToDetailed(model: Branded) {
    goSubject.onNext(model)
  }
  
}
