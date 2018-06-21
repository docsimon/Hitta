//
//  MockURLSession.swift
//  HittaSearch
//
//  Created by doc on 21/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

class MockURLSession: URLSessionProtocol  {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?){
        self.data = data
        self.response = response
        self.error = error
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        completionHandler(data, response, error)
        return URLSessionDataTaskMock()
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        completionHandler(data, response, error)
        return URLSessionDataTaskMock()
    }
}
