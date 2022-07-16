//
//  RecentCell.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//

import UIKit

class RecentCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewOnline: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    var user:UsersState?{didSet{self.updateDataOnUI()}}
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBackground.backgroundColor = ThemeManager.manager?.userBackgroundColor
        self.viewBackground.layer.cornerRadius = 10
        self.viewOnline.layer.cornerRadius = 5
    }
    
    func updateDataOnUI() {
        self.lblName.text = user?.name
        self.lblEmail.text = user?.email
        self.viewOnline.backgroundColor = user?.isOnline == false ? .red : .green
        self.imgUser.downlodeImage(urlString: String.getstring(user?.profile_image), placeHolder: self.imgUser.image)
    }
}
