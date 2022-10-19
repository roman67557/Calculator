//
//  CustomError.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

import Foundation

enum SearchError: Error {
    case underlyingError(Error)
    case notFound
    case unkowned
}

enum CustomError: Error, LocalizedError {
  case error(message: String)
  
    public var errorDescription: String? {
        switch self {
        case .error(message: let message):
          return NSLocalizedString(message, comment: Strings.shared.error)
        }
    }
  
}
