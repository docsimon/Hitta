//
//  Parser.swift
//  HittaSearch
//
//  Created by doc on 22/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

class Parser<T: Decodable>{
    let data: Data
    init (data: Data){
        self.data = data
    }
    
    func parse() throws -> T {
        let jsonDecoder = JSONDecoder()
        do{
            let dataStruct = try jsonDecoder.decode(T.self, from: data)
            return dataStruct
        }catch{
            throw ErrorType.ParsingError(error: error)
        }
    }
}
