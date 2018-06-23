//
//  CellViewModel.swift
//  HittaSearch
//
//  Created by doc on 22/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit

// The CellViewModel class has the responsibility of update the cell of the table, with the required item


class CellViewModel{
    
    let companyTitle: String!
    let companyDescription: String!
    
    init?(company: Company) {
        companyTitle = company.displayName
        guard companyTitle.isEmpty == false else {
            return nil
        }
        
        guard company.address.count > 0 else {
            return nil
        }
        
        companyDescription = company.address[0].street + ", " + company.address[0].city
    }
    
    func format(text: String, withSize size: CGFloat, withColor color: UIColor) -> NSAttributedString {
        let attributes = [
            NSAttributedStringKey.foregroundColor : color,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        return attributedText
    }
}
