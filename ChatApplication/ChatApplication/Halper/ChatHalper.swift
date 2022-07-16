//
//  ChatHalper.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//

import UIKit
import Firebase
import Foundation
import FirebaseStorage

class ChatHalper {
    
    //MARK:- Object for Chat Halper
    static let shared = ChatHalper()
    var messageReference    = Database.database().reference().child(ChatParameter.Message)
    var userReference       = Database.database().reference().child(ChatParameter.UserState)
    var messageclass        = [MessageClass]()
    var users               = [UsersState]()
    
    //MARK:- Function For Send message one to one Chat
    func sendMessage(messageDic:MessageClass) {
        let userState = UsersState(userdata: chatUserDefault.getuserDetails())
        if String.getstring(userState.userId) == ChatParameter.emptyString {
            println("User Id Is empty please check you save the details in chatUser Default or not. Shubham Kaliyar")
            return
        }
        if String.getstring(messageDic.receiverId) == ChatParameter.emptyString {
            println("Receiver id is empty please check you fill the receiver id in message on to send message or not. Shubham Kaliyar")
            return
        }
        let messageNode = self.createNode(senderId: userState.userId ?? "", receiverId: messageDic.receiverId ?? "")
        let sendReference = messageReference.child(messageNode).childByAutoId()
        messageDic.uid = sendReference.key
        messageDic.senderId = userState.userId
        messageDic.senderName = userState.name
        let message = messageDic.createDictonary(objects: messageDic)
        println("send message to node \(messageNode) with key \(sendReference.key ?? "") with message \(message)")
        sendReference.setValue(chatSharedInstanse.getDictionary(message))
    }
    
    //MARK:- Func For Receive Message for One To One Chat
    func receiveMessage(receiverId:String , message:@escaping (_ result: [MessageClass]?) -> ()) -> Void {
        let userState = UsersState(userdata: chatUserDefault.getuserDetails())
        if String.getstring(userState.userId) == ChatParameter.emptyString {
            println("User Id Is empty please check you save the details in chatUser Default or not.")
            return
        }
        if String.getstring(receiverId) == ChatParameter.emptyString {
            println("Receiver id is empty please check you send the receiver id or not .")
            return
        }
        let messageNode = self.createNode(senderId: userState.userId ?? "", receiverId: receiverId)
        messageReference.child(messageNode).observe(.value) { [weak self] (snapshot) in
            self?.messageclass.removeAll()
            if snapshot.exists() {
                let messages = chatSharedInstanse.getDictionary(snapshot.value)
                messages.forEach {(key, value) in
                    let dic = chatSharedInstanse.getDictionary(value)
                    self?.messageclass.append(MessageClass(uid: String.getstring(key), messageData: dic))
                    self?.messageclass.sort{ $0.sendingTime < $1.sendingTime }
                }
            }
            message(self?.messageclass)
        }
    }
    
    //MARK:- Func For Check User State For Online And Ofline State and Submit Data on Firebase On Self Node
    func onlineState(state: String) {
        var  userDetails = chatUserDefault.getuserDetails()
        let userID = String.getstring(userDetails[ChatParameter.userId])
        if userID == ChatParameter.emptyString {
            println(ChatParameter.alertmessage)
            return
        }
        let timeStamp = String.getstring(Int(Date().timeIntervalSince1970 * 1000))
        userDetails[ChatParameter.OnlineState] = String.getstring(state)
        userDetails[ChatParameter.timeStamp] = String.getstring(timeStamp)
        userReference.child(userID).updateChildValues(chatSharedInstanse.getDictionary(userDetails))
    }
    
    // MARK:- func for retrive All Users From Firebase
    func receiveAllUsers(users:@escaping (_ result: [UsersState]?) -> ()) -> Void{
        userReference.observe(.value) { [weak self](snapshot) in
            self?.users.removeAll()
            if snapshot.exists() {
                let usersDetails = chatSharedInstanse.getDictionary(snapshot.value)
                usersDetails.forEach {(key, value) in
                    let details = chatSharedInstanse.getDictionary(value)
                    let userState = UsersState(userdata: details)
                    let userDetails = chatUserDefault.getuserDetails()
                    let userID = String.getstring(userDetails[ChatParameter.userId])
                    if userID != userState.userId { self?.users.append(userState) }
                    self?.users = self?.users.uniqueArray(map: {$0.userId}) ?? []
                    users(self?.users)
                }
            }
        }
    }
    // MARK:- create node function
    func createNode(senderId:String, receiverId:String) -> String {
        if senderId.isEmpty { return receiverId }
        return senderId > receiverId ? "\(senderId)_\(receiverId)" : "\(receiverId)_\(senderId)"
    }
    
    // MARK:-  func for upload file on server
    func uploadFileOnServer(recorderUrl: URL,message: MessageClass) {
        let riversRef = Storage.storage().reference().child("\(Date().timeIntervalSince1970).mp3")
        do {
            let audioData = try Data(contentsOf: recorderUrl)
            riversRef.putData(audioData, metadata: nil){ (data, error) in
                if error == nil{
                    riversRef.downloadURL {url, error in
                        guard let downloadURL = url else { return }
                        message.message = downloadURL.absoluteString
                        ChatHalper.shared.sendMessage(messageDic: message)
                    }
                }
                else {
                    print(error?.localizedDescription ?? "")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

func println(_ message:Any) {
    print("\n\n\n$$$$$$$$$$$$$$$  \(message) $$$$$$$$$$$$$$$")
}
