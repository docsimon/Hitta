//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by doc on 22/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import XCTest

class NetworkingTests: XCTestCase {
    
    func testLoadingDataFromLocalJson(){
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "Hitta", withExtension: "json") else {
            XCTFail("No file found")
            return
        }
        do {
            let _ = try Data(contentsOf: url)
        }catch {
            XCTFail("Serialized data received is invalid")
        }
    }
}
