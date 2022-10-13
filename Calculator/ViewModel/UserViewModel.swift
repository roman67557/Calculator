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

protocol UserViewModelProtocol {
  
  var userNameSubject: PublishSubject<String> { get }
  var userPhotoSubject: BehaviorSubject<UIImage> { get }
  
  func signOut()
  func fetchData()
  
  func getPhoto(photo: UIImage)
  func deletePhoto()
}

class UserViewModel: UserViewModelProtocol {
  
  var userNameSubject = PublishSubject<String>()
  var userPhotoSubject = BehaviorSubject<UIImage>(value: UIImage(named: "userPhoto") ?? UIImage())
  
  var user: AppUser?
  var databaseRef: DatabaseReference?
  
  var storageRef: StorageReference?
  
  init() {
    
    guard let currentUser = Auth.auth().currentUser else { return }
    user = AppUser(user: currentUser)
    guard let userId = user?.uid else { return }
    databaseRef = Database.database().reference(withPath: "users").child(userId)
    
    storageRef = Storage.storage().reference().child("avatars").child(user?.uid ?? String()).child("userPhoto")
  }
  
  public func signOut() {
    do {
      try Auth.auth().signOut()
    } catch {
      print(error.localizedDescription)
    }
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
      guard let _ = metaData else {
        return
      }

      self?.storageRef?.downloadURL(completion: { url, error in
        guard let url = url else {
          return
        }
        self?.databaseRef?.updateChildValues(["photo" : "\(url)"])
        self?.fetchData()
      })
    })
  }
  
  public func deletePhoto() {
    
    storageRef?.delete(completion: { [weak self] error in
      guard error == nil else { return }
      self?.fetchData()
    })
  }
  
  func saveData() {
    
    let date = Date()
    
    DispatchQueue.global()
  }
  
}
