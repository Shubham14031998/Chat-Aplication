//
//  ReceiverAudioCell.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//


import UIKit
import UIKit
import AVFoundation
import AVKit

class ReceiverAudioCell: UITableViewCell {
    
    //MARK:- Outlets & Variable
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var viewChatBox: UIView!
    @IBOutlet weak var buttonPlayPause: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    var didPlayAudio:((UIButton) -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.progressBar.progress = 0.0
    }
    
    //MARK:- to update data in cell
    func audioTime(timer:Int) -> String{
        let minutes = Int(timer) / 60 % 60
        let seconds = Int(timer) % 60
        return String(format:"%02i:%02i", Int.getint(minutes), Int.getint(seconds < 0 ? 0 : seconds))
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        didPlayAudio?(sender)
    }
}
