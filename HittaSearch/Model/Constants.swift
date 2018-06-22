//
//  Constants.swift
//  HittaSearch
//
//  Created by doc on 22/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

struct Constants {
    struct HttpStatusCodes{
        static let Codes = [200, 201, 202, 204, 304]
    }
    
    struct ErrorMessages {
        struct DataErrors {
            static let InvalidDataReceived = "The data received is invalid"
        }
    }
}
