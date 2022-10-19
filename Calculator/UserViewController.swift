//
//  UserViewController.swift
//  Calculator
//
//  Created by Роман on 05.08.2022.
//

import UIKit
import RxSwift
import RxDataSources
import Photos
import PhotosUI

class UserViewController: UIViewController {
  
  //MARK: - Public Properties

  public var viewModel: UserViewModelProtocol!
  
  //MARK: - Private Properties
  
  private let loadingView = UIActivityIndicatorView(style: .large)
  
  private let tableView = UITableView()
  private var dataSource: RxTableViewSectionedReloadDataSource<ItemSection<AppUser>>?
  
  private let bag = DisposeBag()
  
  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = RxTableViewSectionedReloadDataSource<ItemSection<AppUser>>(configureCell: { (_, tableView, indexPath, model) -> UITableViewCell in
      
      if indexPath.row == 0 {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identifier, for: indexPath) as? UserInfoTableViewCell
        
        cell?.configure(with: model, and: self.viewModel)
        return cell ?? UITableViewCell()
      }
      return UITableViewCell()
    })
    
    setup()
    setupBindings()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    viewModel.fetchData()
  }

}

extension  UserViewController {
  
  //MARK: - Private Methods

  private func setup() {

    self.view.backgroundColor = .main
    
    addSubViews()
    setupTableView()
    setupRightBarButtonItem()
    setupConstraints()
  }

  private func addSubViews() {

    [tableView, loadingView].forEach {

      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func setupTableView() {
    
    tableView.separatorStyle = .none
    tableView.backgroundColor = .main
    tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.identifier)
    
    tableView.rx.rowHeight.onNext(350)
  }
  
  private func setupRightBarButtonItem() {
    
    let rightBarItem = UIBarButtonItem(image: .logout, style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
    self.navigationItem.setRightBarButton(rightBarItem, animated: true)
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
    
    guard let dataSource = dataSource else { return }
    
    viewModel.alertRelay
      .subscribe { [weak self] bool in
        guard bool == true else { return }
        self?.setupAlert()
      }
      .disposed(by: bag)
    
    viewModel.content.asDriver().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
  }
  
  @objc private func didRightBarButtonItemTapped(_ sender: Any) {
    
    loadingView.startAnimating()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
      self?.viewModel.signOut {
        self?.loadingView.stopAnimating()
      }
    }
  }
  
  private func setupAlert() {
    
    let alert = UIAlertController(title: "Фото профиля", message: "Выберите фото для своего профиля", preferredStyle: .actionSheet)
    
    let photoAction = UIAlertAction(title: "Выбрать фото", style: .default) { [weak self] action in
      if #available(iOS 14, *) {
        self?.setupPHPicker()
      } else {
        self?.setupUIPicker()
      }
    }
    
    let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] action in
      self?.viewModel.deletePhoto()
    }
    
    let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
    alert.addAction(photoAction)
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    present(alert, animated: true)
  }
  
}

//MARK: - Extensions

extension UserViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  //MARK: - Private Methods
  
  @available(iOS 14.0, *)
  private func setupPHPicker() {
    
    var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
    phPickerConfig.selectionLimit = 1
    phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
    let photoView = PHPickerViewController(configuration: phPickerConfig)
    photoView.delegate = self
    self.present(photoView, animated: true)
  }
  
  @available(iOS 14.0, *)
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true, completion: .none)
    results.forEach { result in
      result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
        guard let image = reading as? UIImage, error == nil else { return }
        DispatchQueue.main.async {
          self.viewModel.getPhoto(photo: image)
        }
      }
    }
  }
  
  private func setupUIPicker() {
    
    let pickerView = UIImagePickerController()
    pickerView.sourceType = .photoLibrary
    pickerView.delegate = self
    present(pickerView, animated: true)
  }
  
  func imagePicker(_ imagePicker: UIImagePickerController, didSelect image: UIImage) {
    self.viewModel.getPhoto(photo: image)
    imagePicker.dismiss(animated: true)
  }
  
}
