//
//  SenderAudioCell.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//


import UIKit
import AVFoundation
import AVKit

class SenderAudioCell: UITableViewCell {
    
    
    //MARK:- Outlets & Variable
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var viewChatBox: UIView!
    @IBOutlet weak var buttonPlayPause: UIButton!
    @IBOutlet weak var labelChangeDuration: UILabel!
    
    var didPlayAudio:((UIButton) -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        didPlayAudio?(sender)
    }
    
    //MARK:- to update data in cell
    func audioTime(timer:Int) -> String{
        let minutes = Int(timer) / 60 % 60
        let seconds = Int(timer) % 60
        return String(format:"%02i:%02i", Int.getint(minutes), Int.getint(seconds < 0 ? 0 : seconds))
    }
}
