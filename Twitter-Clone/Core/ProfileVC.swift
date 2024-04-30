//
//  ProfileVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 30.04.2024.
//

import UIKit

class ProfileVC: UIViewController {
    
    private let profileTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineCell.reuseID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        navigationItem.title = "Profile"
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(profileTableView)
        profileTableView.frame = view.bounds
        profileTableView.delegate = self
        profileTableView.dataSource = self
        let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: CGFloat.deviceWidth, height: 360))
        profileTableView.tableHeaderView = headerView
    }


}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineCell.reuseID, for: indexPath) as! TimelineCell
        
        return cell
    }
    
    
}
