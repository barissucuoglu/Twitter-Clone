//
//  ProfileVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 30.04.2024.
//

import UIKit

class ProfileVC: UIViewController {
    
    private let statusBar: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.opacity = 0
        return view
    }()
    
    private var isStatusBarHidden = true
    
    private let profileTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineCell.reuseID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureVC()
    }
    
    
    private func configureNavigationController() {
        navigationItem.title = "Profile"
        navigationController?.navigationBar.isHidden = true
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubviews(profileTableView, statusBar)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: CGFloat.deviceWidth, height: 380))
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never
        
        let iphoneModelHeight: CGFloat = view.bounds.height > 800 ? 45 : 20
        
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        statusBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(iphoneModelHeight)
        }

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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            }
        } else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            }
        }
    }
}
