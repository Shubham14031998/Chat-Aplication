//
//  RecentTableView.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//

import Foundation
import UIKit
class RecentTableView: UITableView {
    var users:[UsersState]?{didSet{self.reloadData()}}
    // MARK:- life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDelegate()
    }
    func setDelegate() {
        self.register(UINib(nibName: "RecentCell", bundle: nil), forCellReuseIdentifier: "RecentCell")
        self.delegate = self
        self.dataSource = self
    }
    
}
// MARK:- cextension of main class for CollectionView
extension RecentTableView : UITableViewDelegate   , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getNumberOfRow(numberofRow: users?.count, message: "Searching Users...")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users?[indexPath.row]
        let cell = self.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath) as! RecentCell
        cell.user = user
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users?[indexPath.row]
        let nextvc = ChatVC.instantiate(fromAppStoryboard: .Chat)
        nextvc.receiver = user
        self.parentViewController?.navigationController?.pushViewController(nextvc, animated: true)
    }
}
