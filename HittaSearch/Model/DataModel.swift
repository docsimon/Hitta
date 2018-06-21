//
//  DataModel.swift
//  HittaSearch
//
//  Created by doc on 21/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

// Error Enum

enum ErrorType: Error {
    case ClientError(error: Error)
    case ServerError(statusCode: Int)
    case DataError(error: String)
    case ParsingError(error: String)
    case DefaultError(error: String)
}

// Result Type

enum Result<T> {
    case Success(result: T)
    case Error(errorType: ErrorType)
}
