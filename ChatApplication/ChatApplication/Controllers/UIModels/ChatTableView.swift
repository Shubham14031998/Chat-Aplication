//
//  ChatTableView.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//

import UIKit

class ChatTableView: UITableView {
    // MARK:- objects
    var message:[MessageClass]?
    var messageSection = [MessageGroup]()
    let userState = UsersState(userdata: chatUserDefault.getuserDetails())
    
    //MARK:- func for initialSetup
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
        self.registerNib()
    }
    // MARK:- func for setupUI
    func initialSetup() {
        self.delegate = self
        self.dataSource = self
        
    }
    // MARK:- func for register Nib
    func registerNib() {
        self.register(UINib(nibName: "STextCell", bundle: nil), forCellReuseIdentifier: "STextCell")
        self.register(UINib(nibName: "RTextCell", bundle: nil), forCellReuseIdentifier: "RTextCell")
        self.register(UINib(nibName: "ReceiverAudioCell", bundle: nil), forCellReuseIdentifier: "ReceiverAudioCell")
        self.register(UINib(nibName: "SenderAudioCell", bundle: nil), forCellReuseIdentifier: "SenderAudioCell")
    }
    
    func filterMessageArray() {
        self.messageSection.removeAll()
        var timeStampArray = [String]()
        self.message?.forEach { (message) in
            let date = message.sendingTime.dateFromTimeStamp()
            let dateStr  = date.toString(withFormat: "MM/dd/yyyy")
            timeStampArray.append(dateStr)
        }
        let arr = Array(Set(timeStampArray))
        timeStampArray = arr
        for time in timeStampArray {
            let date1 = Date.dateFromString(date: time, withCurrentFormat: "MM/dd/yyyy")
            let timestamp = date1.toMillis() ?? 0
            var tmpArr = [MessageClass]()
            self.message?.forEach { (message) in
                let date1 = message.sendingTime.dateFromTimeStamp()
                let dateStr1  = date1.toString(withFormat: "MM/dd/yyyy")
                if time == dateStr1 {
                    tmpArr.append(message)
                }
            }
            self.messageSection.append(MessageGroup(time: timestamp, message: tmpArr))
            self.messageSection.sort{ ($0.sendingTime ?? 0 ) < ($1.sendingTime ?? 0) }
            self.layoutIfNeeded()
            self.scrollToBottom()
            self.reloadData()
        }
    }
    
    // MARK:- func for receive Cell
    func receiveMessageOneToOne(receiverId:String?) {
        ChatHalper.shared.receiveMessage(receiverId: String.getstring(receiverId)) { (message) in
            self.message = message
            self.filterMessageArray()
        }
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            if Int.getint(self.messageSection.count) != 0  {
                let arr = self.messageSection.last?.message
                let indexPath = IndexPath(row: (arr?.count ?? 0) - 1, section: (self.messageSection.count)-1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
}
// MARK:- extension of main class for delegate and datasource
extension ChatTableView : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.messageSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageSection[section].message?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messageSection.indices.contains(indexPath.section) == false { return UITableViewCell() }
        let messageObj = self.messageSection[indexPath.section]
        if messageObj.message?.indices.contains(indexPath.row) == false { return UITableViewCell() }
        guard let message = messageObj.message?[indexPath.row] else {return UITableViewCell() }
        return self.returnMessageCell(messageObject: message, indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        view.backgroundColor = .clear
        let headerLabel = UILabel.init(frame: CGRect(x: (UIScreen.main.bounds.width-100)/2, y: 0, width: 100, height: 25))
        headerLabel.backgroundColor = .black
        headerLabel.layer.cornerRadius = 3
        headerLabel.clipsToBounds = true
        headerLabel.textAlignment = .center
        headerLabel.textColor = .white
        headerLabel.font = UIFont.systemFont(ofSize: 10.0)
        view.addSubview(headerLabel)
        if messageSection.indices.contains(section) == false { return UIView() }
        let messageObj = self.messageSection[section]
        let timeStamp = messageObj.sendingTime
        let date1 =  timeStamp?.dateFromTimeStamp()
        if date1?.isToday() ?? false {
            headerLabel.text = "Today"
        }else if date1?.isYesterday() ?? false {
            headerLabel.text = "Yesterday"
        }else {
            let dateStr1  = date1?.toString(withFormat: "dd MMM YYYY")
            headerLabel.text = dateStr1
        }
        return view
    }
}

// MARK:- func for initial cellSetup() or updateCell
extension UITableView {
    func returnMessageCell(messageObject:MessageClass? , indexPath: IndexPath) -> UITableViewCell {
        guard let message = messageObject else {return UITableViewCell()}
        // MARK:- switch For handel case for messages cell
        switch message.messageFrom {
        case .sender:
            switch message.mediaType {
            case .text:
                let text = self.dequeueReusableCell(withIdentifier: "STextCell", for: indexPath) as! STextCell
                text.message = message
                return text
            case .audio:
                let audio = self.dequeueReusableCell(withIdentifier: "SenderAudioCell", for: indexPath) as! SenderAudioCell
                audio.didPlayAudio = { sender in
                    sender.isSelected = !sender.isSelected
                    if sender.isSelected {
                        SKAudioRecordPlay.shared.playAudio(with: message.message ?? "")
                        SKAudioRecordPlay.shared.updateProgressBar = {(progress, timer)in
                            audio.progressBar.progress = timer
                            audio.labelChangeDuration.text = audio.audioTime(timer: Int(progress))
                        }
                    }else {
                        SKAudioRecordPlay.shared.stopPlayer()
                    }
                }
                return audio
            default:
                return UITableViewCell()
            }
        case .receiver :
            switch message.mediaType {
            case .text:
                let text = self.dequeueReusableCell(withIdentifier: "RTextCell", for: indexPath) as! RTextCell
                text.message = messageObject
                return text
            case .audio:
                let audio = self.dequeueReusableCell(withIdentifier: "ReceiverAudioCell", for: indexPath) as! ReceiverAudioCell
                audio.lblName.text = message.senderName
                audio.didPlayAudio = { sender in
                    sender.isSelected = !sender.isSelected
                    if sender.isSelected {
                        SKAudioRecordPlay.shared.playAudio(with: message.message ?? "")
                        SKAudioRecordPlay.shared.updateProgressBar = {(progress, timer)in
                            audio.progressBar.progress = timer
                            audio.lblDuration.text = audio.audioTime(timer: Int(progress))
                        }
                    }else {
                        SKAudioRecordPlay.shared.stopPlayer()
                    }
                }
                return audio
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
}
