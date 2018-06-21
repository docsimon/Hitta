//
//  URLSessionProtocol.swift
//  HittaSearch
//
//  Created by doc on 21/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation


// I need this protocol to use a mock session to inject into the Client class
// in order to test error and mock data

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)-> URLSessionDataTaskProtocol
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?)-> Void)-> URLSessionDataTaskProtocol
    
}


extension URLSession: URLSessionProtocol {
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task = URLSession.shared.dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
        return task as URLSessionDataTaskProtocol
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?)->Void)-> URLSessionDataTaskProtocol{
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
        return task as URLSessionDataTaskProtocol
    }
}
