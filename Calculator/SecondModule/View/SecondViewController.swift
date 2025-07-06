//
//  SecondViewController.swift
//  Calculator
//
//  Created by Роман on 25.09.2022.
//

import UIKit
import RxSwift
import RxDataSources

class SecondViewController: UIViewController {
  
  //MARK: - Public Properties
  
  var viewModel: SecondViewModelProtocol!
  
  //MARK: - Private Properties
  
  private let tableView = UITableView()
  private let dataSource = RxTableViewSectionedReloadDataSource<ItemSection<FoodSelected>>(configureCell: { _, tableView, indexPath, model -> UITableViewCell in
    
    let cell = tableView.dequeueReusableCell(withIdentifier: FoodSelectedTableViewCell.identifier, for: indexPath) as? FoodSelectedTableViewCell
    
    cell?.configure(with: model)
    return cell ?? UITableViewCell()
  })
  
  private let loadingView = UIActivityIndicatorView(style: .large)
  private let emptyView = EmptyView(text: Strings.shared.empty)
  private let totalCaloriesView = TotalCaloriesView()
  
  private let bag = DisposeBag()
  
  //MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupBindings()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    viewModel.fetchData()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  //MARK: - Private Methods
  
  private func setup() {
    tableView.isHidden = false
    totalCaloriesView.isHidden = false
    loadingView.isHidden = false
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
    tableView.separatorStyle = .none
    tableView.backgroundColor = .main
    tableView.register(FoodSelectedTableViewCell.self, forCellReuseIdentifier: FoodSelectedTableViewCell.identifier)
    
    tableView.rx.rowHeight.onNext(tableViewCellHeight)
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
  
  private func setupBindings() {
    viewModel.empty
      .drive(emptyView.rx.isHidden)
      .disposed(by: bag)
    
    viewModel.isLoading
      .map { !$0 }
      .drive(loadingView.rx.isHidden)
      .disposed(by: bag)
    
    viewModel.isLoading
      .map { !$0 }
      .drive(loadingView.rx.isAnimating)
      .disposed(by: bag)
    
    viewModel.empty
      .map { !$0 }
      .drive(totalCaloriesView.rx.isHidden)
      .disposed(by: bag)
    
    viewModel.empty
      .map { !$0 }
      .drive(tableView.rx.isHidden)
      .disposed(by: bag)
    
    viewModel.caloriesSum
      .drive(self.totalCaloriesView.rx.caloriesSum)
      .disposed(by: bag)
    
    viewModel.content.asDriver().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
    
    tableView.rx.modelDeleted(FoodSelected.self)
      .map { [weak self] foodSelected in
        guard let text = foodSelected.foodName?.lowercased() else { return }
        self?.viewModel.deleteData(text: text)
      }
      .subscribe()
      .disposed(by: bag)
  }
  
}

