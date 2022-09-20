//
//  NetworkService.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

import RxSwift
import RxCocoa
import Alamofire

class NetworkService: NetworkAPI {
  
  static let shared: NetworkService = NetworkService()
  
  func fetchFood(searchTerm: String) -> Observable<[Branded]> {
    
    let request = request(searchTerm: searchTerm)
    
    return Observable.create { observer -> Disposable in
      
      request
        .validate()
        .responseJSON { result in
          
//          print(result)
          
          switch result.result {
            
          case .success(_):
            
            do {
              
              let nutr = try NetworkService.parsFood(result: result)
              guard let branded = nutr.branded else { return }
              observer.onNext(branded)
            } catch {
              observer.onError(error)
            }
            
          case .failure(let error):
            if let statusCode = result.response?.statusCode {
              
              let reason = CustomError.error(message: "\(statusCode)")
              
              observer.onError(reason)
            }
            observer.onError(error)
          }
          
          
        }
      return Disposables.create()
    }
  }
  
  func request(searchTerm: String) -> DataRequest {
    
    let headers = self.prepareHeaders()
    let params = self.prepareParams(searchTerm: searchTerm)
    let url = self.url()
    
    let request = AF.request(url, method: .get, parameters: params, headers: headers)
//    print(params)
    return request
  }
  
  private func prepareHeaders() -> HTTPHeaders? {
    var headers = HTTPHeaders()
    headers = ["x-app-id":"2ec3db23", "x-app-key":"fbd36347ec69b9bd987ebcca7670689b"]
    return headers
  }
  
  private func prepareParams(searchTerm: String) -> Parameters {
    var params = Parameters()
    
    params["query"] = searchTerm.lowercased()
    params["branded"] = "true"
    
    return params
  }
  
  private func url() -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "trackapi.nutritionix.com"
    components.path = "/v2/search/instant"
    guard let componetsUrlUnwrap = components.url else { return URL(fileURLWithPath: " ") }
    return componetsUrlUnwrap
  }
  
}

extension NetworkService {
  
  static func parsFood(result: AFDataResponse<Any>) throws -> Nutritionix {
    
    guard let data = result.data,
          let food = try? JSONDecoder().decode(Nutritionix.self, from: data) else { throw CustomError.error(message: "Invalid foods JSON") }
    
    return food
  }
  
}
