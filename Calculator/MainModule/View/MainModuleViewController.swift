//
//  MainModuleViewController.swift
//  Calculator
//
//  Created by Роман on 22.09.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainModuleViewController: UIViewController {
  
  //MARK: - Public Properties
  
  public var viewModel: MainViewModelProtocol!
  
  //MARK: - Private Properties
  
  private let searchBar = UISearchBar()
  private let loadingView: UIActivityIndicatorView? = UIActivityIndicatorView(style: .large)
  private let emptyView = EmptyView(text: Strings.shared.nothingHaveFound)
  
  private var tableView = UITableView()
    private let dataSource = RxTableViewSectionedReloadDataSource<ItemSection<Branded>>(
        configureCell: { _, tableView, indexPath, model -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.identifier, for: indexPath) as? FoodTableViewCell

            cell?.configure(with: model)
            return cell ?? UITableViewCell()
        }
    )
  
  private let bag = DisposeBag()
  
  //MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupBindings()
  }
  
  //MARK: - Private Methods
  
  private func setup() {
    viewModel.setupUser()
    
    addSubViews()
    setupColor()
    setupHiddenViews()
    setupSearchBar()
    setupTableView()
    setupConstraints()
  }
  
  private func addSubViews() {
    [tableView, loadingView, emptyView].forEach {
      $0?.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0 ?? UIView())
    }
  }
  
  private func setupColor() {
    view.backgroundColor = .main
  }
  
  private func setupHiddenViews() {
    tableView.isHidden = false
    emptyView.isHidden = true
    loadingView?.isHidden = true
  }
  
  private func setupSearchBar() {
    navigationItem.titleView = searchBar
    searchBar.delegate = self
    searchBar.placeholder = "Введите название продукта..."
    searchBar.barStyle = .default
  }
  
  private func setupTableView() {
    tableView.keyboardDismissMode = .onDrag
    tableView.separatorStyle = .none
    tableView.backgroundColor = .main
    tableView.register(FoodTableViewCell.self, forCellReuseIdentifier: FoodTableViewCell.identifier)
    
    tableView.rx.rowHeight.onNext(tableViewCellHeight)
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
    
    emptyView.topAnchor.constraint(equalTo: view.topAnchor).isActive  = true
    emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }
  
  private func setupBindings() {
      searchBar.rx.text.orEmpty
          .bind(to: viewModel.searchObserver)
          .disposed(by: bag)
      
    viewModel.isLoading.asDriver()
          .drive(tableView.rx.isHidden)
          .disposed(by: bag)
    
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
    
    viewModel.error
      .map({ $0 == nil })
      .drive(emptyView.rx.isHidden)
      .disposed(by: bag)
    
    viewModel.content
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: bag)
    
      tableView.rx.itemSelected
          .subscribe { [weak self] indexPath in
              self?.tableView.deselectRow(at: indexPath, animated: true)
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

//MARK: - Extensions

extension MainModuleViewController: UISearchBarDelegate {
  
  //MARK: - Methods
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    self.emptyView.endEditing(true)
    self.tableView.endEditing(true)
    self.searchBar.endEditing(true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
}
