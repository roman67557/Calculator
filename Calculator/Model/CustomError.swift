//
//  CustomError.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

enum SearchError: Error {
    case underlyingError(Error)
    case notFound
    case unkowned
}

enum CustomError: Error {
  case error(message: String)
}
