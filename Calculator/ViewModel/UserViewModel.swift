//
//  UserViewModel.swift
//  Calculator
//
//  Created by Роман on 05.08.2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import RxSwift
import RxCocoa
import RxDataSources

//MARK: - Protocol

protocol UserViewModelProtocol {
  
  //MARK: - Properties
  
  var userNameSubject: PublishSubject<String> { get }
  var userPhotoSubject: BehaviorSubject<UIImage> { get }
  
  var alertRelay: BehaviorRelay<Bool> { get }
  
  var contentSubject: PublishSubject<[ItemSection<AppUser>]> { get }
  var content: Driver<[ItemSection<AppUser>]> { get }
  
  //MARK: - Methods
  
  func signOut(completion: @escaping ()->())
  func fetchData()
  
  func getPhoto(photo: UIImage)
  func deletePhoto()
}

//MARK: - View Model

class UserViewModel: UserViewModelProtocol {
  
  //MARK: - Properties
  
  var userNameSubject = PublishSubject<String>()
  var userPhotoSubject = BehaviorSubject<UIImage>(value: UIImage(named: "userPhoto") ?? UIImage())
  
  var alertRelay = BehaviorRelay<Bool>(value: false)
  
  var contentSubject = PublishSubject<[ItemSection<AppUser>]>()
  var content: Driver<[ItemSection<AppUser>]> {
    return contentSubject.asDriver(onErrorDriveWith: .empty())
  }
  
  //MARK: - Private Properties
  
  private var user: AppUser?
  private  var databaseRef: DatabaseReference?
  
  private var storageRef: StorageReference?
  
  private let bag = DisposeBag()
  
  //MARK: - Initializers
  
  init() {
    
    guard let currentUser = Auth.auth().currentUser else { return }
    user = AppUser(user: currentUser)
    guard let userId = user?.uid else { return }
    databaseRef = Database.database().reference(withPath: "users").child(userId)
    
    storageRef = Storage.storage().reference().child("avatars").child(user?.uid ?? String()).child("userPhoto")
    
    output()
  }
  
  //MARK: - Private Methods
  
  private func output() {
    
    Observable.combineLatest(userNameSubject, userPhotoSubject)
      .subscribe { [weak self] userName, userPhoto in
        
        var sections: [ItemSection<AppUser>] = []
        
        let user = AppUser(name: userName, photo: "userPhoto")
        
        let section = ItemSection(header: userName, items: [user])
        
        sections.append(section)
        
        self?.contentSubject.onNext(sections)
      }
      .disposed(by: bag)
  }
  
  //MARK: - Public Methods
  
  public func signOut(completion: @escaping ()->()) {
    do {
      try Auth.auth().signOut()
    } catch {
      print(error.localizedDescription)
    }
    completion()
  }
  
  public func fetchData()  {
    
    let maxSize = Int64(10 * 1024 * 1024)
    
    databaseRef?.child("name").observe(.value, with: { [weak self] snapshot in
      
      guard let name = snapshot.value as? String else { return }
      
      self?.userNameSubject.onNext(name)
    })
    
    storageRef?.getData(maxSize: maxSize, completion: { [weak self] data, error in

      guard let imageData = data, let image = UIImage(data: imageData) else {
        
        guard let image = UIImage(named: "userPhoto") else { return }
        self?.userPhotoSubject.onNext(image)
        return
      }

      self?.userPhotoSubject.onNext(image)
    })
  }
  
  public func getPhoto(photo: UIImage) {
    
    guard let imageData = photo.jpegData(compressionQuality: 0.4) else { return }

    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg"

    storageRef?.putData(imageData, metadata: metaData, completion: { [weak self] metaData, error in
      guard let _ = metaData, error == nil else {
        
        errorSubject.onNext(error)
        return
      }

      self?.storageRef?.downloadURL(completion: { url, error in
        guard let url = url, error == nil else {
          
          errorSubject.onNext(error)
          return
        }
        
        self?.databaseRef?.updateChildValues(["photo" : "\(url)"])
        self?.fetchData()
      })
    })
  }
  
  public func deletePhoto() {
    
    storageRef?.delete(completion: { [weak self] error in
      guard error == nil else {
        
        errorSubject.onNext(error)
        return
      }
      self?.fetchData()
    })
  }
  
}
