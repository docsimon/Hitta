//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by doc on 22/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import XCTest
@testable import HittaSearch

class NetworkingTests: XCTestCase {
    
    // Check if the local json file is loaded correctly
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
    
    //Check if the Mock session returns the expected values
    func testMockURLSessionReturnsValues(){
        
        // Create the MockURLSession with mock data
        let mockData = "This is a test".data(using: .utf8)
        let url = URL(string: "https://www.hitta.se")
        let statusCode = 200
        let errorLocalizedDescription = "This is a test"
        let mockResponse = HTTPURLResponse.init(url: url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let mockError = NSError(domain: "Test Error", code: 0, userInfo: [ NSLocalizedDescriptionKey: errorLocalizedDescription])
        let mockSession = MockURLSession(data: mockData, response: mockResponse, error: mockError)
        
        // Test if the mock data are returned from the custom dataTask
        let request = URLRequest(url: url!)
        let expectation = XCTestExpectation(description: "Testing Mock Session")
        mockSession.dataTask(with: request, completionHandler: { data, response, error in
            
            // Checking if the error is the one I expect
            guard let error = (error as NSError?), error == mockError, error.domain == "Test Error" else {
                XCTFail("The error is not the expected one")
                return
            }
            
            // Checking if the response is the one I expect
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                XCTFail("The response is not the expected one")
                return
            }
            
            // Checking if data id the one I expect
            guard let data = data, data == mockData, String(data: data, encoding: .utf8) == "This is a test" else {
                XCTFail("The data is not the expected one")
                return
            }
            
            expectation.fulfill()
        }).resume()
        wait(for: [expectation], timeout: 5.0)
    }
}
