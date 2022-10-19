//
//  UserInfoTableViewCell.swift
//  Calculator
//
//  Created by Роман on 13.10.2022.
//

import UIKit
import RxSwift

class UserInfoTableViewCell: UITableViewCell {
  
  static let identifier = "UserInfoTableViewCell"
  
  private let profileImageView = UIImageView()
  private let profileLabel = UILabel()
  
  private var viewModel: UserViewModelProtocol?
  
  private let bag = DisposeBag()
  
  private func setup() {
    
    addSubViews()
    setupProfilePhotoImageView()
    setupLabel()
    setupConstraints()
  }
  
  private func addSubViews() {

    [profileImageView, profileLabel].forEach {

      $0.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview($0)
    }
  }
  
  private func setupProfilePhotoImageView() {
    
    profileImageView.clipsToBounds = true
    profileImageView.isUserInteractionEnabled = true
    
    profileImageView.backgroundColor = .systemGray6
    profileImageView.layer.cornerRadius = 100
    profileImageView.contentMode = .scaleAspectFill
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    tapGestureRecognizer.numberOfTapsRequired = 1
    
    profileImageView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  private func setupLabel() {
    
    profileLabel.font = profileLabel.font.withSize(25)
    profileLabel.textAlignment = .center
  }
  
  private func setupConstraints() {
    
    profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
    profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    
    profileLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
    profileLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    profileLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true
    profileLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor).isActive = true
  }
  
  @objc func imageTapped(_ sender: UITapGestureRecognizer) {
    
    viewModel?.alertRelay.accept(true)
  }
  
  private func setupBindings() {
    
    viewModel?.userPhotoSubject
      .subscribe(onNext: { [weak self] userImage in
        self?.profileImageView.image = userImage
      })
      .disposed(by: bag)
  }
  
}

extension UserInfoTableViewCell {
  
  public func configure(with model: AppUser, and viewModel: UserViewModelProtocol) {
    
    setup()
    setupBindings()
    
    self.profileLabel.text = model.name
    self.viewModel = viewModel
    
//    self.contentView.layer.cornerRadius = cornerRadius
//    self.contentView.layer.borderColor = UIColor.borderColor
//    self.contentView.layer.borderWidth = borderWidth
    
    self.accessoryType = .none
    self.selectionStyle = .none
//    self.contentView.backgroundColor = .main
    self.backgroundColor = .main
    
    
  }
  
}
