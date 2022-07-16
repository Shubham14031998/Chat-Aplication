//
//  RTextCell.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//


import UIKit

class RTextCell: UITableViewCell {
    @IBOutlet weak var txtMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var message:MessageClass?{didSet{ self.updateCell() }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateCell() {
        self.lblName.text = message?.senderName
        self.txtMessage.text = message?.message
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
