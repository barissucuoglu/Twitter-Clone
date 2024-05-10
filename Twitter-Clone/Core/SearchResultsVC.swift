//
//  SearchResultsVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 9.05.2024.
//

import UIKit

class SearchResultsVC: UIViewController {
    
    var users = [TwitterUser]()
    
    private let searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseID)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    
    func updateUsers(with users: [TwitterUser]) {
        self.users = users
        DispatchQueue.main.async { [weak self] in
            self?.searchResultsTableView.reloadData()
        }
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsTableView)
        
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        searchResultsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension SearchResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseID, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.set(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        let profileViewModel = ProfileViewModel(user: user)
        let destVC = ProfileVC(viewModel: profileViewModel)
        present(destVC, animated: true)
    }
    
    
}
