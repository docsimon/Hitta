//
//  URLSessionDataTaskProtocol.swift
//  HittaSearch
//
//  Created by doc on 21/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol{
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}
