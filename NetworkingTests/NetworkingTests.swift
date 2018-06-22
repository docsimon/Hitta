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
    
    var data: Data?
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "Hitta", withExtension: "json") else {
            XCTFail("No file found")
            return
        }
        do {
            let tmpData = try Data(contentsOf: url)
            data = tmpData
        }catch {
            XCTFail("Serialized data received is invalid")
        }
        
    }
    
    
    
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
    
    func testSuccessParsing(){
        
        guard let data = data else {
            XCTFail("Data input is invalid")
            return
        }
        
        let parser = Parser<SearchResult>(data: data)
        do {
            let searchResult = try parser.parse()
            let companyName = searchResult.result.companies.company[0].displayName
            let street = searchResult.result.companies.company[0].address[0].street
            let city = searchResult.result.companies.company[0].address[0].city
            
            XCTAssertTrue(companyName == "Ica Maxi Special AB")
            XCTAssertTrue(street == "Gamla Flygplatsvägen")
            XCTAssertTrue(city == "Torslanda")
            
        }
        catch{
            XCTFail(error.localizedDescription)
        }
        
    }
    
    // Making the Parser thrown
    func testUnsuccessfullParsing(){
        struct MockDecodable: Decodable {
            let testItem: String
        }
        guard let data = data else {
            XCTFail("Data input is invalid")
            return
        }
        let parser = Parser<MockDecodable>(data: data)
        do {
            let _ = try parser.parse()
            XCTFail("The function didn't thrown. That's bad")
        }
        catch{
            // Function successfully threw
        }
    }
    
    // Testing the Client
    
    func testClientReturnsValidResult(){
        
        // Create the MockURLSession with mock data
        let apiUrl = URL(string: "https://www.hitta.se")!
        let request = URLRequest(url: apiUrl)
        let statusCode = 200
        let mockResponse = HTTPURLResponse.init(url: apiUrl, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let mockSession = MockURLSession(data: data, response: mockResponse, error: nil)
        
        
        let expectation = XCTestExpectation(description: "Testing Mock Client Session")
        let client = Client<SearchResult>(session: mockSession, request: request)
        client.getData(completion: { resultClosure in
            do {
                let searchResult = try resultClosure()
                
                
               
                let companyName = searchResult.result.companies.company[0].displayName
                    let street = searchResult.result.companies.company[0].address[0].street
                    let city = searchResult.result.companies.company[0].address[0].city
                    XCTAssertTrue(companyName == "Ica Maxi Special AB")
                    XCTAssertTrue(street == "Gamla Flygplatsvägen")
                    XCTAssertTrue(city == "Torslanda")
                
            }catch {
                XCTFail("Shouldn't fail here \(error.localizedDescription)")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Testing if the Client return a client error
    func testClientReturnsAClientError(){
        
        // Create the MockURLSession with mock data
        let apiUrl = URL(string: "https://www.hitta.se")!
        let request = URLRequest(url: apiUrl)
        let errorLocalizedDescription = "This is a Client error test"
        let mockError = NSError(domain: "Test Error", code: 0, userInfo: [ NSLocalizedDescriptionKey: errorLocalizedDescription])
        let mockSession = MockURLSession(data: nil, response: nil, error: mockError)
        
        
        let expectation = XCTestExpectation(description: "Testing Mock Client Session")
        let client = Client<SearchResult>(session: mockSession, request: request)
        client.getData(completion: { resultClosure in
            do {
                let _ = try resultClosure()
                XCTFail("Shouldn't reach this point")
            }catch ErrorType.ClientError(let clientError){
                XCTAssertTrue(clientError.localizedDescription == "This is a Client error test")
            }catch {
                XCTFail("Shouldn't reach this point")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    //Testing Server Error
    func testClientReturnsAServerError(){
        
        // Create the MockURLSession with mock data
        let apiUrl = URL(string: "https://www.hitta.se")!
        let request = URLRequest(url: apiUrl)
        let statusCode = 404
        let mockResponse = HTTPURLResponse.init(url: apiUrl, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let mockSession = MockURLSession(data: nil, response: mockResponse, error: nil)
        
        let expectation = XCTestExpectation(description: "Testing Mock Client Session")
        let client = Client<SearchResult>(session: mockSession, request: request)
        client.getData(completion: { resultClosure in
            do {
                let _ = try resultClosure()
                XCTFail("Shouldn't reach this point")
            }catch ErrorType.ServerError(let code){
                XCTAssertTrue(code == statusCode)
            }catch {
                XCTFail("Shouldn't reach this point")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    //Testing Data Error
    func testClientReturnsDataError(){
        
        // Create the MockURLSession with mock data
        let apiUrl = URL(string: "https://www.hitta.se")!
        let request = URLRequest(url: apiUrl)
        let statusCode = 200
        let mockResponse = HTTPURLResponse.init(url: apiUrl, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let mockSession = MockURLSession(data: nil, response: mockResponse, error: nil)
        
        let expectation = XCTestExpectation(description: "Testing Mock Client Session")
        let client = Client<SearchResult>(session: mockSession, request: request)
        client.getData(completion: { resultClosure in
            do {
                let _ = try resultClosure()
                XCTFail("Shouldn't reach this point")
            }catch ErrorType.DataError(let wrongDataMsg){
                XCTAssertTrue(wrongDataMsg == Constants.ErrorMessages.InvalidDataReceived)
            }catch {
                XCTFail("Shouldn't reach this point")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Testing the Client if the Parser throws
    func testClientReturnsNotValidResult(){
        
        // Create the MockURLSession with mock data
        let apiUrl = URL(string: "https://www.hitta.se")!
        let request = URLRequest(url: apiUrl)
        let statusCode = 200
        let mockResponse = HTTPURLResponse.init(url: apiUrl, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        
        let mockData = "This is not the correct json format".data(using: .utf8)
        let mockSession = MockURLSession(data: mockData, response: mockResponse, error: nil)
        
        
        let expectation = XCTestExpectation(description: "Testing Mock Client Session")
        let client = Client<SearchResult>(session: mockSession, request: request)
        client.getData(completion: { resultClosure in
            do {
                let _ = try resultClosure()
                
                XCTFail("Shouldn't reach this point")
                
            }catch {
                XCTAssert(true, "Should fail with error here: \(error.localizedDescription)")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testStatuCodeFunctionIsValid(){
        // Valid test
        let apiUrl = URL(string: "https://www.hitta.se")!
        let request = URLRequest(url: apiUrl)
        let client = Client<SearchResult>(request: request)
        let code = 200
        let isValid = client.statusCodeIsValid(code: code)
        XCTAssertTrue(isValid)
       
    }
    
    func testStatuCodeFunctionIsNotValid(){
        // Not Valid test
        let apiUrl = URL(string: "https://www.hitta.se")!
        let request = URLRequest(url: apiUrl)
        let client = Client<SearchResult>(request: request)
        let code = 404
        let isValid = client.statusCodeIsValid(code: code)
        XCTAssertFalse(isValid)
    }
}
