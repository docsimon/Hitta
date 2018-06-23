//
//  SearchMainController.swift
//  HittaSearch
//
//  Created by doc on 22/06/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SearchNodeController: ASViewController<ASTableNode> {
    
    var activityIndicator: UIActivityIndicatorView!
    let errorManager = ErrorManager()
    var searchData: SearchResult?
    var companiesData: [Company]? {
        if let companies = searchData?.result.companies {
            return companies.company
        }
        return nil
    }
    
    init() {
        super.init(node: ASTableNode())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        node.allowsSelection = false
        node.view.separatorStyle = .none
        node.dataSource = self
        node.delegate = self
        node.leadingScreensForBatching = 2.5
        errorManager.delegate = self
        let viewModel = SearchViewModel()
        viewModel.delegate = self
        viewModel.getSearchData()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        self.activityIndicator = activityIndicator
        let bounds = self.node.frame
        var refreshRect = activityIndicator.frame
        refreshRect.origin = CGPoint(x: (bounds.size.width - activityIndicator.frame.size.width) / 2.0, y: (bounds.size.height - activityIndicator.frame.size.height) / 2.0)
        activityIndicator.frame = refreshRect
        self.node.view.addSubview(activityIndicator)
    }
    
    var screenSizeForWidth: CGSize = {
        let screenRect = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        return CGSize(width: screenRect.size.width * screenScale, height: screenRect.size.width * screenScale)
    }()
    
}

// MARK: ViewModel Protocol
extension SearchNodeController: UpdateControllerProtocol{
    func updateViewController(result: SearchResult) {
        self.searchData = result
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.node.reloadData()
        }
    }
    
    func displayError(errorData: ErrorData) {
        errorManager.displayError(errorTitle: errorData.errorTitle, errorMsg: errorData.errorMsg)
    }
    
    
}

// MARK: Error Protocol
extension SearchNodeController: ErrorControllerProtocol {
    func dismissActivityControl() {
    }
    
    func presentError(alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func fetchData() {
    }
    
    
}

// MARK: Table protocol
extension SearchNodeController: ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return companiesData?.count ?? 0
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let dummyValue = Company(displayName: "Unknown", address: [Address(city: "N/A", street: "N/A")])
        let company = companiesData?[indexPath.row]
        let cellViewModel = CellViewModel(company: company ?? dummyValue)!
        let nodeBlock: ASCellNodeBlock = {
            return SearchTableNodeCell(cellViewModel: cellViewModel)
        }
        
        return nodeBlock
    }
    
    func shouldBatchFetchForCollectionNode(collectionNode: ASCollectionNode) -> Bool {
        return false
    }

}
