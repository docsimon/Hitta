//
//  SearchViewModel.swift
//  HittaSearch
//
//  Created by doc on 22/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

// The SearchViewModel mediate between the Model and the View, takes responsibility for
// fetching remote data, update the UI and formatting text.


protocol UpdateControllerProtocol: class, RoutingErrorProtocol {
    func updateViewController(result: SearchResult)
}

class SearchViewModel{
    
    weak var delegate: UpdateControllerProtocol?
    
    func getSearchData(session: URLSessionProtocol = URLSession.shared){
        
        guard let url = URL(string: Constants.APIs.baseUrl) else {
            let errorData = ErrorData(errorTitle: Constants.ErrorMessages.UrlErrorTitle, errorMsg: Constants.ErrorMessages.UrlErrorMsg)
            delegate?.displayError(errorData: errorData)
            return
        }
        let request = URLRequest(url: url)
        let client = Client<SearchResult>(session: session, request: request)
        client.getData(completion: { resultClosure in
            do{
                let result = try resultClosure()
                self.delegate?.updateViewController(result: result)
            }catch ErrorType.ClientError(let clientError){
                let errorData = ErrorData(errorTitle: Constants.ErrorMessages.ClientErrorTitle, errorMsg: clientError.localizedDescription)
                self.delegate?.displayError(errorData: errorData)
            }catch ErrorType.ServerError(let statusCode){
                let errorData = ErrorData(errorTitle: Constants.ErrorMessages.ServerErrorTitle, errorMsg: Constants.ErrorMessages.ServerErrorMsg + "\(statusCode)")
                self.delegate?.displayError(errorData: errorData)
            }catch ErrorType.DataError(let dataErrorString){
                let errorData = ErrorData(errorTitle: Constants.ErrorMessages.DataErrorTitle, errorMsg: dataErrorString)
                self.delegate?.displayError(errorData: errorData)
            }catch ErrorType.ParsingError(let error){
                let errorData = ErrorData(errorTitle: Constants.ErrorMessages.DataErrorTitle, errorMsg: error.localizedDescription)
                self.delegate?.displayError(errorData: errorData)
            }
            catch{
                let errorData = ErrorData(errorTitle: Constants.ErrorMessages.UnknownErrorTitle, errorMsg: error.localizedDescription + Constants.ErrorMessages.UnknownErrorFrom + "1001")
                self.delegate?.displayError(errorData: errorData)
            }
        })
        
    }
    
}
