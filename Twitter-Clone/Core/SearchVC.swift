//
//  SearchVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 29.04.2024.
//

import UIKit

class SearchVC: UIViewController {
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsVC())
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search with @usernames"
        return searchController
    }()
    
    private let viewModel: SearchViewModel
    
    private let promptLabel = TTitleLabel(textAlignment: .center, fontSize: 32)
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC() {
        view.addSubview(promptLabel)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        promptLabel.text = "Search for users and get connected"
        promptLabel.numberOfLines = 0
        promptLabel.textColor = .placeholderText
        
        promptLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
    }

}


extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchResultsVC,
        let query = searchController.searchBar.text else { return }
        viewModel.search(with: query.lowercased()) { users in
            resultsVC.updateUsers(with: users)
        }
        
    }
}

