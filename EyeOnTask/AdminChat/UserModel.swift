//
//  UserModel.swift
//  EyeOnTask
//
//  Created by Hemant's mac on 06/04/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class UserModel: NSObject {
    
    //user's details
    var user : Users?
    var fullName : String?
    var isTeam : String?
    var yourArray = [Users]()
    var usrIdvelue: String?
    // for online offline information
    var UserOnlineStatusObserver : DatabaseReference?
    var callbackForisOnline: ((Bool) -> Void)?
    var isOnline = false
    var isInactive = false
    var cell : AdminListCell?
  //  var senderNaam = : String?
    // for chat purpose
    var documentListner : ListenerRegistration?
    var lastSeen : String?
    var lastMessage : String?
    var lastMessageTime : String?
    var messages = [ChatUserMessageModel]()
    var unreadCount : String?
    var isMessagesloaded = false
    var callbackForNewSnapshotDocument: (() -> Void)?
    var callbackForUserInactive: (() -> Void)?
    var callbackForScreenNavigation: (() -> Void)?
    var isChatting = false
    var documentID : String? { //FIRST TIME ANE PR NILL AYEGI ID
           didSet{
            createListnerForDocument()
            
            if callbackForScreenNavigation != nil {
                callbackForScreenNavigation!()
            }
            
           }
       }
    
    
    //Initialisation method
    init(from user: Users) {
        super.init()
        
        self.user = user
        
        self.fullName = trimString(string: "\(self.user?.fnm ?? "") \(self.user?.lnm ?? "")")
        self.isTeam = trimString(string: "\(self.user?.isTeam ?? "")")
        self.usrIdvelue = trimString(string: "\(self.user?.usrId ?? "")")
        //senderNaam =  = trimString(string: "\(self.user?.usrId ?? "")")
        //yourArray = (self.user?.teamMemId) as! [Users]
//        for i in self.user!.teamMemId  as! [AnyObject] {
//            print(i)
////             let UsrId = i["usrId"] as? String
////                print(UsrId)
//
//        }
        var dd = self.user?.teamMemId
        //teamMemId
        print()
        
        UserOnlineStatusObserver = ChatManager.shared.createObserverForUsersOnlineStatus(userid: self.user!.usrId!) {(userDetails) in
                    
            if let user = userDetails {
                if user["isOnline"] != nil  {
                   self.isOnline = user["isOnline"] as! Bool
                   if self.cell != nil {
                       self.cell?.isOnlineView.isHidden = self.isOnline ? false : true
                   }
               }
               
               if user["isInactive"] != nil  {
                   self.isInactive = user["isInactive"] as! Bool
                    if self.isInactive {
                        self.documentListner?.remove()
                        self.documentListner = nil
                        self.cell = nil
                        
                        if self.callbackForUserInactive != nil {
                            self.callbackForUserInactive!()
                        }
                    }else{
                        if self.documentID != nil {
                            self.createListnerForDocument()
                        }
                    }
               }else {
                        if self.documentID != nil {
                            self.createListnerForDocument()
                        }
                }
            }
         }
    }
//    func createUsersModelsWithFirestoreListner() -> Void {
//        yourArray = DatabaseClass.shared.fetchDataFromDatabse(entityName: "Users", query: nil) as! [Users]
//    }
    
    func createListnerForDocument() -> Void {
        
        
        if documentListner != nil || self.isInactive { //Document listner will not create if document listner already created or user has inactive from admin side
            return
        }
        

         documentListner = ChatManager.shared.createListnerForIndividualDocument(documentId: documentID!, documentCallback: { (document) in
            let array = (document["messages"] as! Array<[String:Any]>)
            if array.count > 0 {
                
                if !self.isMessagesloaded {
                           self.isMessagesloaded = true
                           self.messages = array.map({ ChatUserMessageModel(messageDict: $0)}) // add all messages in messages array
                           self.lastMessage = self.getlastMessage()
                           if APP_Delegate.isLastTwoDaysBadge ?? false  { // when app install first time then we are showing before two days all messages count
                               let beforeTwoDayDate = getTwoDaysAgoTimeStamp()
                               let filtered = self.messages.filter({ $0.createdAt! >= beforeTwoDayDate })
                               let readMessages = array.count - filtered.count
                               self.user?.readcount = String(readMessages)
                               self.unreadCount = "\(filtered.count)"
                           }else{
                               let count = array.count - Int(self.user?.readcount ?? "0")!
                               self.unreadCount = "\(count)"
                           }
                }else{
                    
                    let Count = array.count - self.messages.count // check undelivered messages
                    let lastUnreadElements = Array(array.suffix(Count)) //get undelivered messages
                    lastUnreadElements.forEach({self.messages.append(ChatUserMessageModel(messageDict: $0))}) // append undelivered msgs
                    self.lastMessage = self.getlastMessage() // get last message string for show the user in notification and chatscreen
                    
                    if (self.messages.last?.senderId == self.user?.usrId) && (self.isChatting == false) {
                          self.unreadCount = "\(Int(self.unreadCount ?? "0")! + Count)"
                          self.sendlocalNotification(message: self.lastMessage!)
                          if self.cell != nil {
                              self.cell?.lblBadge.isHidden = false
                              self.cell?.lblLastSeen.isHidden = true
                              self.cell?.lblBadge.text = self.unreadCount
                              self.cell?.lblLastMessage.text = self.lastMessage
                          }
                      }else{
                        self.user?.readcount = "\(Int(self.user?.readcount ?? "0")! + Count)"  // all read when user active on chat screen
                      }
                }
               
                
                self.lastMessageTime = self.messages.last?.createdAt
                if self.callbackForNewSnapshotDocument != nil {
                    self.callbackForNewSnapshotDocument!()
                }
                
            }else{
                if !self.isMessagesloaded {
                  self.isMessagesloaded = true
                }
            }
         })
    }
    
    
    func getlastMessage() -> String {
        let lastMsgModel =  self.messages.last
        if let document = lastMsgModel?.doc {
            if isPngJpgJpegImage(fileExtention: URL(string: document)!.fileExtention()) {
                return "📷  Photo"
            }else{
                return "📎  Attachment"}
        }else{
            return lastMsgModel?.content ?? ""
        }
    }
    
    func sendlocalNotification(message : String) -> Void {
        
        let dict : [String : Any] = [ "otherdata" : [ "msg": message,
                                                    "msgUrl": "",
                                                    "senderid": self.user?.usrId,
                                                    "usrnm": self.fullName,
                                                    "notyType" : "one2one"
          ]]
        
          let content = UNMutableNotificationContent()
        content.title = self.fullName ?? "Unknown"
        content.body = message
        content.userInfo = dict
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats: false)
        let request = UNNotificationRequest(identifier: "UserChat", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
}
