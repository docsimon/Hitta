//
//  Constants.swift
//  HittaSearch
//
//  Created by doc on 22/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    // MARK: HTTP Response codes
    
    struct HttpStatusCodes{
        static let Codes = [200, 201, 202, 204, 304]
    }
    
    // MARK: Errors
    struct ErrorMessages {
        static let InvalidDataReceived = "The data received is invalid"
        static let DataErrorTitle = "Data Error"
        static let ClientErrorTitle = "Client Error"
        static let ServerErrorTitle = "Server Error"
        static let ServerErrorMsg = "Status code: "
        static let UrlErrorTitle = "Url Error"
        static let UrlErrorMsg = "Cannot create URL from the string"
        static let UnknownErrorTitle = "Unknown Error"
        static let UnknownErrorFrom = "Id: "
        
    }
    
    // MARK: API
    struct APIs {
        static let baseUrl = "https://api.hitta.se/search/v7/app/combined/within/57.840703831916%3A11.728156448084002%2C57.66073920808401%3A11.908121071915998/?range.to=51&range.from=1&geo.hint=57.75072152%3A11.81813876&sort.order=relevance&query=ica"
    }
    
    // MARK: Error buttons
    struct UIViews {
        struct  ErrorView {
            static let dismissButton = "Dismiss"
            static let reloadButton = "Reload"
        }
    }
    
    // MARK: Cell layout
    struct CellLayout {
        static let DistanceFromImage: CGFloat = 5
        static let ImageHeight: CGFloat = 50
        static let ImageWidth: CGFloat = 50
        static let TitleFontSize: CGFloat = 15
        static let DescriptionFontSize: CGFloat = 14
    }
}
