//
//  UserViewController.swift
//  Calculator
//
//  Created by Роман on 05.08.2022.
//

import UIKit
import RxSwift
import Photos
import PhotosUI

class UserViewController: UIViewController {

  var viewModel: UserViewModelProtocol!
  
  private let loginButton = UIButton()
  
  private let loadingView = UIActivityIndicatorView(style: .large)
  private let imageView = UIImageView()
  private let profileLabel = UILabel()
  
  private let bag = DisposeBag()

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

}

extension  UserViewController {

  private func setup() {

    self.view.backgroundColor = .main
    
    addSubViews()
    setuploginButton()
    setupProfilePhotoImageView()
    setupLabel()
    setupConstraints()
  }

  private func addSubViews() {

    [loginButton, imageView, profileLabel, loadingView].forEach {

      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }

  private func setupProfilePhotoImageView() {
    
    imageView.clipsToBounds = true
    imageView.isUserInteractionEnabled = true
    
    imageView.backgroundColor = .systemGray6
    imageView.layer.cornerRadius = 100
    imageView.contentMode = .scaleAspectFill
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    tapGestureRecognizer.numberOfTapsRequired = 1
    
    imageView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  private func setuploginButton() {
    
    loginButton.setTitle(Strings.shared.loginButtonString, for: .normal)
    loginButton.backgroundColor = .subMain
    loginButton.setTitleColor(.white, for: .normal)
    loginButton.layer.cornerRadius = 8.0
    loginButton.addTarget(self, action: #selector(didLoginButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupLabel() {
    
    profileLabel.font = profileLabel.font.withSize(25)
    profileLabel.textAlignment = .center
  }

  private func setupConstraints() {
    
    loginButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    loginButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    loginButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
    loginButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    
    imageView.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.size.width / 2).isActive = true
    imageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 4).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    
    profileLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
    profileLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    profileLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    profileLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
    
    loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }
  
  private func setupBindings() {
    
    viewModel.userNameSubject
      .subscribe(onNext: { [weak self] userName in
        self?.profileLabel.text = userName
      })
      .disposed(by: bag)
    
    viewModel.userPhotoSubject
      .subscribe(onNext: { [weak self] userPhoto in
        self?.imageView.image = userPhoto
      })
      .disposed(by: bag)
  }
  
  @objc func imageTapped(_ sender: UITapGestureRecognizer) {
     setupAlert()
  }
  
  @objc private func didLoginButtonTapped(_ sender: Any) {
    
    viewModel.signOut()
  }
  
}

extension UserViewController {
  
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

extension UserViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
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
  
  //  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  //
  //    if indexPath.row == 1 {
  //      loadingView.startAnimating()
  //      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
  //
  //        self?.viewModel.signOut()
  //        self?.loadingView.stopAnimating()
  //      }
  //    }
  //  }
  
  
  
  
}
