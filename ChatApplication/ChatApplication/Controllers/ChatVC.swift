//
//  ChatVC.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//


import UIKit
import Foundation
import iRecordView


class ChatVC: UIViewController, RecordViewDelegate {
    // MARK:- objects
    @IBOutlet weak var bottonOfChat: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var messages: ChatTableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var recordButton: RecordButton!
    
    
    var receiver:UsersState?
    let userDetails = UsersState(userdata: chatUserDefault.getuserDetails())
    var audioPlayRecord = SKAudioRecordPlay.shared
    
    // MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblName.text = self.receiver?.name
        self.viewHeader.backgroundColor = ThemeManager.headerBackgroundColor
        self.view.backgroundColor = ThemeManager.backgroundColor
        self.messages.receiveMessageOneToOne(receiverId: receiver?.userId)
        self.setupRecordView()
    }
    
    @IBAction func tappedOnBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendImage(_ sender: UIButton) {
        if self.txtMessage.text?.isEmpty ?? true {return}
        let message = MessageClass()
        message.receiverId = self.receiver?.userId
        message.mediaType = .text
        message.receiverName = self.receiver?.name
        message.message = self.txtMessage.text
        ChatHalper.shared.sendMessage(messageDic: message)
        self.txtMessage.text = nil
    }
}
// MARK:- extension for media picker
extension ChatVC  {
    
    func setupRecordView() {
        let recordView = RecordView()
        recordView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordView)
        recordView.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: -20).isActive = true
        recordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        recordView.bottomAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: -20).isActive = true
        recordButton.recordView = recordView
        recordView.delegate = self
    }
    
    func onFinished(duration: CGFloat) {
        //user finished recording
        let urlInString = self.audioPlayRecord.audioUrl?.absoluteString ?? ""
        SKAudioRecordPlay.shared.finishRecording()
        guard let url = URL(string: urlInString) else { return }
        print("onFinished \(duration)")
        let message = MessageClass()
        message.receiverId = self.receiver?.userId
        message.mediaType = .audio
        message.receiverName = self.receiver?.name
        // SKAudioRecordPlay.shared.playLocalSound(url: url.absoluteString)
        ChatHalper.shared.uploadFileOnServer(recorderUrl: url, message: message)
    }
    func onStart() {
        //start recording
        print("onStart")
        self.audioPlayRecord.audioRecorder = nil
        self.audioPlayRecord.startRecording()
    }
    
    func onCancel() {
        //when users swipes to delete the Record
        print("onCancel")
    }
}
