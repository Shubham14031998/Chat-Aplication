//
//  STextCell.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//


import UIKit

class STextCell: UITableViewCell {
    
    /// objects
    @IBOutlet weak var txtMessage: UILabel!
    var message:MessageClass?{didSet{ self.updateCell() }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// func update Message
    func updateCell() {
        self.txtMessage.text = message?.message
    }
}
