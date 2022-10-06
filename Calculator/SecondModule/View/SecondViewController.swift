//
//  SecondViewController.swift
//  Calculator
//
//  Created by Роман on 25.09.2022.
//

import UIKit
import RxSwift

class SecondViewController: UIViewController {
  
  private let bag = DisposeBag()
  
  var viewModel: SecondViewModelProtocol!
  
  private let tableView = UITableView()
  private let loadingView = UIActivityIndicatorView(style: .large)
  private let emptyView = EmptyView(text: Strings.shared.empty)
  private let totalCaloriesView = TotalCaloriesView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupBindings()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.fetchData()
  }
  
  private func setup() {
    
    tableView.isHidden = false
    totalCaloriesView.isHidden = false
    loadingView.isHidden = false
//    loadingView.isAnimating = true
    emptyView.isHidden = true
    
    addSubViews()
    setupColor()
    setupTotalCaloriesView()
    setupTableView()
    setupConstraints()
  }
  
  private func addSubViews() {
    
    [tableView, emptyView, loadingView, totalCaloriesView].forEach {
      
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func setupColor() {
    self.view.backgroundColor = .main
  }
  
  private func setupTotalCaloriesView() {

    totalCaloriesView.configure(viewModel: viewModel)
  }
  
  private func setupTableView() {
    
    tableView.backgroundColor = .main
    tableView.register(FoodSelectedTableViewCell.self, forCellReuseIdentifier: FoodSelectedTableViewCell.identifier)
  }
  
  private func setupConstraints() {
    
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: totalCaloriesView.topAnchor).isActive = true
    
    totalCaloriesView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    totalCaloriesView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    totalCaloriesView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
    totalCaloriesView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    
    emptyView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }

}

extension SecondViewController {
  
  func setupBindings() {
    
    viewModel.empty
      .drive(emptyView.rx.isHidden)
      .disposed(by: bag)
    
    viewModel.isLoading
      .map({ !$0 })
      .drive(loadingView.rx.isHidden)
      .disposed(by: bag)
    
    viewModel.isLoading
      .map({ !$0 })
      .drive(loadingView.rx.isAnimating)
      .disposed(by: bag)
    
    viewModel.empty
      .map({ !$0 })
      .drive(totalCaloriesView.rx.isHidden)
      .disposed(by: bag)
    
    viewModel.empty
      .map({ !$0 })
      .drive(tableView.rx.isHidden)
      .disposed(by: bag)
    
    viewModel.caloriesSum
      .drive(self.totalCaloriesView.rx.caloriesSum)
      .disposed(by: bag)
    
    viewModel.content.asDriver().drive(tableView.rx.items(cellIdentifier: FoodSelectedTableViewCell.identifier)) { (index, model: FoodSelected, cell) in
      
      cell.textLabel?.text = model.foodName
      cell.detailTextLabel?.text = "\(model.weight ?? 0)г/\(model.calories ?? 0)ккал"
    }
    .disposed(by: bag)
    
    tableView.rx.itemDeleted
      .map { [weak self] indexPath in
        guard let cellText = self?.tableView.cellForRow(at: indexPath)?.textLabel?.text?.lowercased() else { return }
        self?.viewModel.deleteData(indexPath: indexPath, cellText: cellText)
      }
      .subscribe()
      .disposed(by: bag)
  }
  
}
