//
//  MainModuleViewController.swift
//  Calculator
//
//  Created by Роман on 22.09.2022.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseDatabase

class MainModuleViewController: UIViewController {
  
  var viewModel: MainViewModelProtocol!
  
  private let searchBar = UISearchBar()
  private let tableView = UITableView()
  private let loadingView: UIActivityIndicatorView? = UIActivityIndicatorView(style: .large)
  private let emptyView: EmptyView? = EmptyView(text: Strings.shared.nothingHaveFound)
  
  private var user: AppUser?
  private var ref: DatabaseReference?
  
  private let bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupBindings()
  }
  
  private func setup() {
    
    tableView.isHidden = false
    emptyView?.isHidden = true
    loadingView?.isHidden = true
    
    setupUser()
    
    setupColor()
    addSubViews()
    setupSearchBar()
    setupTableView()
    setupConstraints()
  }
  
  private func setupUser() {
    
    guard let currentUser = Auth.auth().currentUser else { return }
    user = AppUser(user: currentUser)
    guard let userId = user?.uid else { return }
    ref = Database.database().reference(withPath: "users").child(userId)
  }
  
  private func setupColor() {
    view.backgroundColor = .main
  }
  
  private func addSubViews() {
    
    [tableView, loadingView, emptyView].forEach {
      $0?.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0 ?? UIView())
    }
  }
  
  private func setupSearchBar() {
    
    navigationItem.titleView = searchBar
    searchBar.delegate = self
    searchBar.placeholder = "Введите название продукта..."
    searchBar.barStyle = .default
  }
  
  private func setupTableView() {
    
    tableView.keyboardDismissMode = .onDrag
    tableView.backgroundColor = .main
    tableView.register(FoodTableViewCell.self, forCellReuseIdentifier: FoodTableViewCell.identifier)
  }
  
  private func setupConstraints() {
    
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive  = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    
    loadingView?.topAnchor.constraint(equalTo: view.topAnchor).isActive  = true
    loadingView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    loadingView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    loadingView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    
    emptyView?.topAnchor.constraint(equalTo: view.topAnchor).isActive  = true
    emptyView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    emptyView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    emptyView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }

}

extension MainModuleViewController {
  
  private func setupBindings() {
    
    searchBar.rx.text.orEmpty.bind(to: self.viewModel.searchObserver).disposed(by: bag)
    
    viewModel.isLoading.asDriver().drive(tableView.rx.isHidden).disposed(by: bag)
    
    viewModel.error
      .map({ $0 != nil })
      .drive(tableView.rx.isHidden)
      .disposed(by: bag)
    
    if let loadingView = loadingView {
      
      viewModel.isLoading
        .drive(loadingView.rx.isAnimating)
        .disposed(by: bag)
      
      viewModel.error
        .map({ $0 != nil })
        .drive(loadingView.rx.isHidden)
        .disposed(by: bag)
    }
    
    if let errorView = emptyView {
      
      viewModel.error
        .map({ $0 == nil })
        .drive(errorView.rx.isHidden)
        .disposed(by: bag)
    }
    
    viewModel.content.drive(tableView.rx.items(cellIdentifier: FoodTableViewCell.identifier)) { (index, food: Branded, cell) in
      
      cell.textLabel?.text = food.foodName
    }
    .disposed(by: bag)
    
    tableView.rx.modelSelected(Branded.self)
      .map { [weak self] branded in
        self?.viewModel.goToDetailed(model: branded)
      }
      .subscribe()
      .disposed(by: bag)
  }
  
}

extension MainModuleViewController: UISearchBarDelegate {
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    self.view.endEditing(true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    searchBar.endEditing(true)
  }
  
}
