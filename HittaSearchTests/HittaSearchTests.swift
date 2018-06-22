//
//  HittaSearchTests.swift
//  HittaSearchTests
//
//  Created by doc on 21/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import XCTest
@testable import HittaSearch

class HittaSearchTests: XCTestCase {
    
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
    func testGetSearchDataSuccess(){

        // declare the Receiver class
        class Receiver: UpdateControllerProtocol {
            func updateViewController(result: SearchResult) {
                    let companyName = result.result.companies.company[0].displayName
                    let street =  result.result.companies.company[0].address[0].street
                    let city = result.result.companies.company[0].address[0].city
                    XCTAssertTrue(companyName == "Ica Maxi Special AB")
                    XCTAssertTrue(street == "Gamla Flygplatsvägen")
                    XCTAssertTrue(city == "Torslanda")
            }
            func displayError(errorData: ErrorData) {
                
            }
            
        }
        
        // Create an instance of the Receiver
        let receiver = Receiver()
        
        // Create the MockURLSession with mock data
        let statusCode = 200
        let url = URL(string: "https://www.hitta.se")
        let mockResponse = HTTPURLResponse.init(url: url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let mockSession = MockURLSession(data: data, response: mockResponse, error: nil)
        
        // Instantiate the ViewModel
        let viewModel = SearchViewModel()
        viewModel.delegate = receiver
        
        viewModel.getSearchData(session: mockSession)
        
    }
    
    // Testing ViewModel Client Error
    func testGetSearchDataClientError(){
        // declare the Receiver class
        class Receiver: UpdateControllerProtocol {
            func updateViewController(result: SearchResult) {
              
            }
            func displayError(errorData: ErrorData) {
                let errorTitle = errorData.errorTitle
                let errorMsg = errorData.errorMsg
                XCTAssertTrue(errorTitle == Constants.ErrorMessages.ClientErrorTitle)
                XCTAssertTrue(errorMsg == "This is a Client Error")
            }
        }
        
        // Create an instance of the Receiver
        let receiver = Receiver()
        
        // Create the MockURLSession with mock data
        let errorLocalizedDescription = "This is a Client Error"
        let mockError = NSError(domain: "Test Error", code: 0, userInfo: [ NSLocalizedDescriptionKey: errorLocalizedDescription])
        let mockSession = MockURLSession(data: nil, response: nil, error: mockError)
        
        // Instantiate the ViewModel
        let viewModel = SearchViewModel()
        viewModel.delegate = receiver
        viewModel.getSearchData(session: mockSession)
    }
    
    // Testing ViewModel Server Error
    func testGetSearchDataServerError(){
        // declare the Receiver class
        class Receiver: UpdateControllerProtocol {
            func updateViewController(result: SearchResult) {
                
            }
            func displayError(errorData: ErrorData) {
                let errorTitle = errorData.errorTitle
                let errorMsg = errorData.errorMsg
                XCTAssertTrue(errorTitle == Constants.ErrorMessages.ServerErrorTitle)
                XCTAssertTrue(errorMsg == Constants.ErrorMessages.ServerErrorMsg + "404")
            }
        }
        
        // Create an instance of the Receiver
        let receiver = Receiver()
        
        // Create the MockURLSession with mock data
        let url = URL(string: "https://www.hitta.se")
        let statusCode = 404
        let mockResponse = HTTPURLResponse.init(url: url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let mockSession = MockURLSession(data: nil, response: mockResponse, error: nil)
        
        // Instantiate the ViewModel
        let viewModel = SearchViewModel()
        viewModel.delegate = receiver
        viewModel.getSearchData(session: mockSession)
    }
    
    // Testing ViewModel Data Error
    func testGetSearchDataDataError(){
        // declare the Receiver class
        class Receiver: UpdateControllerProtocol {
            func updateViewController(result: SearchResult) {
                
            }
            func displayError(errorData: ErrorData) {
                let errorTitle = errorData.errorTitle
                let errorMsg = errorData.errorMsg
                XCTAssertTrue(errorTitle == Constants.ErrorMessages.DataErrorTitle)
                XCTAssertTrue(errorMsg == Constants.ErrorMessages.InvalidDataReceived)
            }
        }
        
        // Create an instance of the Receiver
        let receiver = Receiver()
        
        // Create the MockURLSession with mock data
        let url = URL(string: "https://www.hitta.se")
        let statusCode = 200
        let mockResponse = HTTPURLResponse.init(url: url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let mockSession = MockURLSession(data: nil, response: mockResponse, error: nil)
        
        // Instantiate the ViewModel
        let viewModel = SearchViewModel()
        viewModel.delegate = receiver
        viewModel.getSearchData(session: mockSession)
    }
    
    // Testing ViewModel Parsing Data Error
    func testGetSearchDataDataParsingError(){
        // declare the Receiver class
        class Receiver: UpdateControllerProtocol {
            func updateViewController(result: SearchResult) {
                
            }
            func displayError(errorData: ErrorData) {
                let errorTitle = errorData.errorTitle
                let errorMsg = errorData.errorMsg
                XCTAssertTrue(errorTitle == Constants.ErrorMessages.DataErrorTitle)
                XCTAssertTrue(errorMsg == "The data couldn’t be read because it isn’t in the correct format.")
            }
        }
        
        // Create an instance of the Receiver
        let receiver = Receiver()
        
        // Create the MockURLSession with mock data
        let mockData = "Invalid json format".data(using: .utf8)
        let url = URL(string: "https://www.hitta.se")
        let statusCode = 200
        let mockResponse = HTTPURLResponse.init(url: url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let mockSession = MockURLSession(data: mockData, response: mockResponse, error: nil)
        
        // Instantiate the ViewModel
        let viewModel = SearchViewModel()
        viewModel.delegate = receiver
        viewModel.getSearchData(session: mockSession)
    }
}

