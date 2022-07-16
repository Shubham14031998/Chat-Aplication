//
//  ResentsUsersVC.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//


import UIKit

class ResentsUsersVC: UIViewController {
    /// objects
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var usersTableView: RecentTableView!
    
    /// life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatHalper.shared.receiveAllUsers { users in
            self.usersTableView.users = users
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewHeader.backgroundColor = ThemeManager.headerBackgroundColor
    }
}
