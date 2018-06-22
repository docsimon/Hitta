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
    case ParsingError(error: Error)
    case DefaultError(error: String)
}

// Result Type

enum Result<T> {
    case Success(result: T)
    // future cases
    
}

// Json Data Structure

struct SearchResult: Decodable {
    let result: ResultJson
}

struct ResultJson: Decodable {
    let companies: Companies
}

struct Companies: Decodable {
    let company: [Company]
}

struct Company: Decodable {
    let displayName: String
    let address: [Address]
}

struct Address: Decodable {
    let city: String
    let street: String
}
