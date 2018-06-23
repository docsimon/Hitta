//
//  SearchTableNodeCell.swift
//  HittaSearch
//
//  Created by doc on 23/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SearchTableNodeCell: ASCellNode {
    
    let companyTitleLabel = ASTextNode()
    let companyDescriptionLabel = ASTextNode()
    
    init(cellViewModel: CellViewModel) {
        super.init()
        companyTitleLabel.attributedText = cellViewModel.format(text: cellViewModel.companyTitle, withSize: Constants.CellLayout.TitleFontSize, withColor: UIColor.black)
        companyDescriptionLabel.attributedText = cellViewModel.format(text: cellViewModel.companyDescription, withSize: Constants.CellLayout.DescriptionFontSize, withColor: UIColor.gray)
        self.automaticallyManagesSubnodes = true

    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
                
        let verticalTextStack = ASStackLayoutSpec.vertical()
        
        verticalTextStack.children = [companyTitleLabel, companyDescriptionLabel]
        verticalTextStack.flexWrap = ASStackLayoutFlexWrap(rawValue: 10)!
        
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.children = []
        
        let imageIcon = ASImageNode()
        let image = UIImage(named: "hitta")
        imageIcon.image = image
        imageIcon.style.preferredSize = CGSize(width: Constants.CellLayout.ImageWidth, height: Constants.CellLayout.ImageHeight)
        
        let spacer = ASLayoutSpec()
        spacer.style.minWidth = ASDimension(unit: .points, value: Constants.CellLayout.DistanceFromImage)
        
        horizontalStack.children = [imageIcon, spacer, verticalTextStack]
        horizontalStack.style.height = ASDimension(unit: .points, value: 55)
       return horizontalStack
    }
}
