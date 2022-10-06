//
//  UserViewController.swift
//  Calculator
//
//  Created by Роман on 05.08.2022.
//

import UIKit
import RxSwift

class UserViewController: UIViewController {

  var viewModel: UserViewModelProtocol!

  private let tableView = UITableView()
  private let loadingView = UIActivityIndicatorView(style: .large)
  
  private let bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
    setupBindings()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    viewModel.fetchData()
  }

}

extension  UserViewController {

  private func setup() {

    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.view.backgroundColor = .main
    
    addSubViews()
    setupTableView()
    setupConstraints()
  }

  private func addSubViews() {

    [tableView, loadingView].forEach {

      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }

  private func setupTableView() {

    tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
    tableView.register(ExitTableViewCell.self, forCellReuseIdentifier: ExitTableViewCell.identifier)
    tableView.backgroundColor = .main

    tableView.delegate = self
    tableView.dataSource = self
  }

  private func setupConstraints() {

    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

    loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }
  
  private func setupBindings() {
    
    viewModel.userNameSubject
      .subscribe(onNext: { [weak self] userName in
        self?.navigationItem.title = "Привет, \(userName)!"
      })
      .disposed(by: bag)
  }
  
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

     return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if indexPath.row == 0 {

      let cell1 = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath)


      return cell1
    } else if indexPath.row == 1 {

      let cell2 = tableView.dequeueReusableCell(withIdentifier: ExitTableViewCell.identifier, for: indexPath)


      return cell2
    }

    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    if indexPath.row == 1 {
      loadingView.startAnimating()
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in

        self?.viewModel.signOut()
        self?.loadingView.stopAnimating()
      }
    }
  }
  
}


