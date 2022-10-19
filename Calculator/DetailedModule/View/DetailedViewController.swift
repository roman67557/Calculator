//
//  DetailedViewController.swift
//  Calculator
//
//  Created by Роман on 25.09.2022.
//

import UIKit
import RxSwift

class DetailedViewController: UIViewController {
  
  //MARK: - Public Properties
  
  public var viewModel: DetailedViewModelProtocol!
  
  //MARK: - Private Properties
  
  private let weightTextField = UITextField()
  private let weightButton = UIButton()
  private let calories = Int()
  private let caloriesView = CaloriesView()
  
  private let bag = DisposeBag()
  
  //MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.prefersLargeTitles = false
    self.navigationItem.title = "Title"
    
    setup()
    setupBindings()
  }
  
  //MARK: - Private Methods
  
  private func setup() {
    
    addSubViews()
    setupColor()
    setupCaloriesView()
    setupWeightTextField()
    setupWeightButton()
    setupConstraints()
  }
  
  private func addSubViews() {
    
    [weightTextField, weightButton, caloriesView].forEach {
      
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func setupColor() {
    view.backgroundColor = .main
  }
  
  private func setupCaloriesView() {
    
    caloriesView.configure(viewModel: viewModel)
  }
  
  private func setupWeightTextField() {
    
    weightTextField.delegate = self
    weightTextField.placeholder = "Введите вес в граммах"
    weightTextField.font = .systemFont(ofSize: 20)
    weightTextField.borderStyle = .roundedRect
    weightTextField.autocorrectionType = .no
    weightTextField.keyboardType = .default
    weightTextField.returnKeyType = .done
    weightTextField.contentVerticalAlignment = .center
    weightTextField.layer.cornerRadius = 15
    weightTextField.autocapitalizationType = .none
  }
  
  private func setupWeightButton() {
    
    weightButton.setTitle(Strings.shared.add, for: .normal)
    weightButton.backgroundColor = .subMain
    weightButton.setTitleColor(.white, for: .normal)
    weightButton.layer.cornerRadius = 8.0
    weightButton.addTarget(self, action: #selector(didAddButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    
    weightTextField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: view.frame.size.height / 12).isActive = true
    weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.size.width / 12).isActive = true
    weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.size.width / 12).isActive = true
    weightTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
    
    weightButton.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 40).isActive = true
    weightButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    weightButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
    weightButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    caloriesView.topAnchor.constraint(equalTo: weightButton.topAnchor, constant: 100).isActive = true
    caloriesView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    caloriesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    caloriesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }
  
  @objc private func didAddButtonTapped(_ sender: UIButton) {
    
    guard weightTextField.text != "" else {
      setupAlert(message: Strings.shared.emptyField)
      return
    }
    guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: weightTextField.text ?? "")) else {
      setupAlert(message: Strings.shared.digitsOnly)
      return 
    }
    guard let weight = weightTextField.text else { return }
    
    viewModel.addModel(weight: Int(weight) ?? 0)
  }
  
  private func setupAlert(message: String) {
    
    let alert = AlertController(title: Strings.shared.error, message: message, preferredStyle: .alert)
    present(alert, animated: true)
  }
  
  private func setupBindings() {
    
    viewModel.titleSubject
      .subscribe(onNext: { [weak self] title in
        
        self?.title = title
      })
      .disposed(by: bag)
  }
  
}

//MARK: - Extensions

extension DetailedViewController: UITextFieldDelegate {
  
  //MARK: - Methods
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    self.view.endEditing(true)
    
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
}


