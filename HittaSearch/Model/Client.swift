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

// The Client connects to the remote endpoint, fetches the JSON and deserialize it. THe result can be a struct with the deserialized data on success, or an error

class Client {
    
    let session: URLSessionProtocol
    let request: URLRequest
    
    init (session: URLSessionProtocol = URLSession.shared, request: URLRequest){
        self.session = session
        self.request = request
    }
    
    func getData(request: URLRequest, completion: (_ result: () throws -> Result<Any>) -> Void ){
        
        session.dataTask(with: request, completionHandler: {data, result, error in
            
        })
    }
    
}
