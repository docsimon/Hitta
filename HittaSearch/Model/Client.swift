//
//  Client.swift
//  HittaSearch
//
//  Created by doc on 21/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

// The Client class takes two initialization paramenter:
// 1. The Session, which is used both for the actual connection and the test
// 2. The request (URLRequest)

// The Client connects to the remote endpoint, fetches the JSON and deserialize it. The result can be a struct with the deserialized data on success, or an error (Result<T> type)

class Client<T: Decodable> {
    
    let session: URLSessionProtocol
    let request: URLRequest
    
    init (session: URLSessionProtocol = URLSession.shared, request: URLRequest){
        self.session = session
        self.request = request
    }
    
    func getData(request: URLRequest, completion: @escaping (_ result: () throws -> T) -> () ){
        
        session.dataTask(with: request, completionHandler: {data, response, error in
            
            // Client Error Check
            guard error == nil else {
                completion(
                    {
                        throw  ErrorType.ClientError(error: error!)
                    }
                )
                return
            }
            
           // Server Error Check
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard let code = statusCode, self.statusCodeIsValid(code: code) else {
                completion(
                    {
                        throw  ErrorType.ServerError(statusCode: statusCode!)
                    }
                )
                return
            }
            
            // Data Error Check
            guard let data = data else {
                completion(
                    {
                        throw  ErrorType.DataError(error: Constants.ErrorMessages.DataErrors.InvalidDataReceived)
                    }
                )
                return
            }
            
            do{
                let parser = Parser<T>(data: data)
                let result = try parser.parse()
                completion(
                    {
                        //return Result.Success(result: result)
                        return result
                    }
                )
            }catch {
                completion (
                    {
                        throw ErrorType.ParsingError(error: error)
                    }
                )
            }
            
        }).resume()
    }
    
}

extension Client {
    // Helper functions
   internal func statusCodeIsValid(code: Int) -> Bool {
        let validCodes = Constants.HttpStatusCodes.Codes
        guard validCodes.contains(code) else {
            return false
        }
        return true
    }
}
