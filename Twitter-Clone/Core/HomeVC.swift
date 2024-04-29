//
//  HomeVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 29.04.2024.
//

import UIKit

class HomeVC: UIViewController {
    
    private let timelineTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineCell.reuseID)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(timelineTableView)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        
        timelineTableView.frame = view.bounds
    }
    

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineCell.reuseID, for: indexPath) as! TimelineCell
//        cell.textLabel?.text = "Tweet"
        return cell
    }
    
    
}
