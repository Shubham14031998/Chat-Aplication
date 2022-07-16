//
//  FirebaseModels.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//

import Foundation
import UIKit

let chatSharedInstanse = ChatSharedClass.sharedInstance
let chatUserDefault = UserDefaults.standard
//MARK:- Class for messgaes For Chat Halper
class MessageClass {
    var uid:String?
    var senderId :String?
    var senderName :String?
    var receiverId :String?
    var receiverName :String?
    var message:String?
    var sendingTime =  Int()
    var isOnline = Int()
    var mediaType:messageType?
    var messageFrom:MessageFrom?
    var userDetails = chatUserDefault.getuserDetails()
    init() { }
    init(uid :String , messageData:[String:Any]) {
        self.userDetails         = chatUserDefault.getuserDetails()
        self.uid                 = String.getstring(uid)
        self.senderId            = String.getstring(messageData[ChatParameter.senderId])
        self.senderName          = String.getstring(messageData[ChatParameter.senderName])
        self.receiverId          = String.getstring(messageData[ChatParameter.receiverId])
        self.receiverName        = String.getstring(messageData[ChatParameter.receiverName])
        self.message             = String.getstring(messageData[ChatParameter.content])
        self.sendingTime         = Int.getint(messageData[ChatParameter.timeStamp])
        self.messageFrom         = String.getstring(messageData[ChatParameter.senderId]) == String.getstring(userDetails[ChatParameter.userId]) ? .sender : .receiver
        //MARK:- Switch for media type
        switch  String.getstring(messageData[ChatParameter.mediaType]) {
        case "text":
            self.mediaType = .text
        case "photos":
            self.mediaType = .photos
        case "audio":
            self.mediaType = .audio
        default:
            self.mediaType = .text
        }
    }
    func createDictonary (objects:MessageClass?) -> Dictionary<String , Any> {
        let params : [String:Any] = [
            ChatParameter.uid                       : objects?.uid ?? "",
            ChatParameter.senderId                  : objects?.senderId ?? "" ,
            ChatParameter.senderName                : objects?.senderName ?? "",
            ChatParameter.receiverId                : objects?.receiverId  ?? "",
            ChatParameter.receiverName              : objects?.receiverName ?? "",
            ChatParameter.content                   : objects?.message ?? "",
            ChatParameter.timeStamp                 : String(Int(Date().timeIntervalSince1970 * 1000)),
            ChatParameter.mediaType                 : objects?.mediaType?.rawValue ?? "",
        ]
        return params
    }
}

//MARK:- Class for User Information
class UsersState {
    var userId :String?
    var name :String?
    var first_name:String?
    var last_name:String?
    var email:String?
    var mobile_number:String?
    var profile_image:String?
    var deviceID:String?
    var isOnline :Bool?
    var isSelected = false
    init() {}
    
    init(userdata:[String:Any]) {
        self.userId            = String.getstring(userdata[ChatParameter.userId])
        self.first_name        = String.getstring(userdata[ChatParameter.firstName])
        self.last_name         = String.getstring(userdata[ChatParameter.lastName])
        self.email             = String.getstring(userdata[ChatParameter.email])
        self.name              = String.getstring(userdata[ChatParameter.name])
        self.mobile_number     = String.getstring(userdata[ChatParameter.mobileNumber])
        self.profile_image     = String.getstring(userdata[ChatParameter.profileImage])
        self.isOnline          = String.getstring(userdata[ChatParameter.isOnline]) == "1"
        self.deviceID          = String.getstring(userdata[ChatParameter.deviceID])
    }
    func createDictonary (objects:UsersState?) -> Dictionary<String , Any> {
        let params : [String:Any] = [
            ChatParameter.userId                      : objects?.userId ?? "",
            ChatParameter.name                        : objects?.name ?? "" ,
            ChatParameter.email                        : objects?.email ?? "" ,
            ChatParameter.profileImage                : objects?.profile_image ?? "",
            ChatParameter.deviceID                    : UIDevice.current.identifierForVendor?.uuidString ?? "",
            ChatParameter.mobileNumber                : objects?.mobile_number ?? ""
        ]
        return params
    }
}

enum messageType:String {
    case text
    case photos
    case audio
    
}
enum MessageFrom:String {
    case sender , receiver
}


class MessageGroup {
    var sendingTime:Int?
    var message:[MessageClass]?
    init(time:Int? , message:[MessageClass]?) {
        self.sendingTime = time
        self.message = message
    }
}
