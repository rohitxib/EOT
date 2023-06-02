//
//  ChatManager.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 19/12/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

final class ChatManager {
    // jugal
    
    static let shared = ChatManager()
    var db : Firestore!    //   Firestore.firestore()
    var chatList = [ChatResponseModel]()
    var chatModels = [ChatModel]()
    var userModels = [UserModel]()
    var listenerForjob : ListenerRegistration?
    var listenerForClientMsg : ListenerRegistration?
    var cell : ListenerRegistration?
    var callback: ((ChatResponseModel) -> Void)?
    var clientCallback: ((ChatResponseModel) -> Void)?
    var callbackForUserChat : (() -> Void)?
    var callbackClientBadge: ((Int) -> Void)?
    var alreadyListnerCreated = Bool()
    var currentjobID : String = ""
    var admins = [String]()
    var bgTask : BackgroundTaskManager?
    var alreadyListnerCreatedForNewJob = Bool()
    var ref: DatabaseReference!
    var selfInactiveRef: DatabaseReference!
    var idForuser = ""
   var idarr = ""
    var grpId = ""
    private init() {
        print("Chat initialized")
     }
    
    //=======================
    // MARK:- Configuration
    //=======================
     func configure() -> Void {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            db = Firestore.firestore() // Firestore database reference
            ref = Database.database().reference() // Realtime database reference
            
            // Enable offline data persistence
            let settings = FirestoreSettings()
            settings.isPersistenceEnabled = true
            settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
            db.settings = settings

            
            connectionObserver()
        }
    }
    
    func connectionObserver(){
         let connectedRef = Database.database().reference(withPath: ".info/connected")
         connectedRef.observe(.value, with: { snapshot in
           if snapshot.value as? Bool ?? false {
             print("Firebase Connected")
            if UserDefaults.standard.bool(forKey: "login"){
                 ChatManager.shared.setUserOnlineOnFirebase(isNetworkUpdate: true)
            }
           } else {
             print("Firebase Not connected")
           }
         })
     }
    
    func isFirebaseAuthenticate() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }else{
            return false
        }
    }
    
    
    func createObserverForUsersOnlineStatus(userid : String, callback:@escaping ([String:Any]?) -> ()) -> DatabaseReference
    {
        
        let postRef = ref.child(getUserDetailsPath(userid: userid))
        postRef.observe(DataEventType.value, with: { (snapshot) in
            let userDetails = snapshot.value as? [String:Any]
            callback(userDetails)
        })
        
        return postRef
    }
    
    func createObserverForSelfInactiveStatus(callback:@escaping (Bool) -> ())
    {
        
        selfInactiveRef = ref.child(getInactivePathOnFirebase())
        selfInactiveRef.observe(DataEventType.value, with: { (snapshot) in
            if let value = snapshot.value , ((snapshot.value as? NSNull) == nil){
                let isInactive = value  as! Bool
                callback(isInactive)
            }else{
                callback(false)
            }
        })
        
    }

    
    func createOrSignInUserOnFirebase(email:String, password:String, callback:@escaping (Bool) -> Void) -> Void {
        
        // first of all we check user exist or not , otherwise we will create new user
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if user != nil {
                //print("User already exist on Firebase")
                callback (true)
            }else{
                //print("User is creating on Firebase")
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    
                    if authResult != nil {
                        //print("User has created successfully on Firebase")
                        callback (true)
                    }else{
                        if error != nil {
                            //ShowError(message: error!.localizedDescription, controller: windowController)
                            callback (false)
                        }
                    }
                }
            }
        }
    }
    
    func SignoutUserFromFirebase() -> Void {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
    //=======================
    // MARK:- Online / Offline
    //=======================
    func setStatusOnline() -> Void {
        ref.child(getOnlineOfflinePathOnFirebase()).setValue(1)
        ChatManager.shared.db.collection(getAllUsersPath()).document(fieldworkerIdForFirebase()).setData([ "online": 1], merge: true)
    }
    
 
    
    
    func setStatusOffline(completionSignout: (() -> Void)?) {
          setUserOfflineOnFirebase()
        // ChatManager.shared.db.collection(getAllUsersPath()).document(fieldworkerIdForFirebase()).setData([ "online": 0], merge: true)
        
        
        ChatManager.shared.db.collection(getAllUsersPath()).document(fieldworkerIdForFirebase()).setData([ "online": 0], merge: true) { (error) in
               if completionSignout != nil {
                     completionSignout!()
                 }
        }
    }
    
    func setBatteryStatusOnFirebase(batteryPercentage : String) -> Void {
         ref.child(getBatteryStatusPathOnFirebase()).setValue(batteryPercentage)
    }
    
    func setUserOnlineOnFirebase(isNetworkUpdate : Bool) -> Void {
        ref.child(getOnlineOfflinePathOnFirebase()).setValue(1)
        callOnDisconnectMethod()
        if isNetworkUpdate{
            // this check is very important when user comes offline state to online state because when user goes offline then app send status 'App kill or No network' on server but when user comes online then app check last status from 'gpsStatusVariable' and send on the server,because of this, server's status will change from  'App kill or No network' to other status.
            if let stus = gpsStatusVariable {
                gpsStatusVariable = nil
                setGpsStatusOnFirebase(status: stus)
            }
        }
    }
    
    
    func callOnDisconnectMethod()  {
         ref.child(getOnlineOfflinePathOnFirebase()).onDisconnectSetValue(0)
         ref.child(getGPSstatusPathOnFirebase()).onDisconnectSetValue(GPSstatus.App_killed_or_Internet_off.rawValue)
    }
    
    
    func setUserOfflineOnFirebase() -> Void {
        ref.child(getOnlineOfflinePathOnFirebase()).setValue(0)
    }
    
    //=============================
    // MARK:- Unread Count Management
    //=============================
    func unreadCountZero(jobid:String) -> Void {
        ChatManager.shared.db.collection(getFieldworkerPath(jobId: jobid)).document(fieldworkerIdForFirebase()).setData([ "unread": 0], merge: true)
    }


    func isExistFieldworker(jobid:String) -> Void {
        let docRef =  ChatManager.shared.db.collection(getFieldworkerPath(jobId: jobid)).document(fieldworkerIdForFirebase())
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                 //print("Document is exist")
              } else {
                self.unreadCountZero(jobid: jobid)
                self.clientUnreadCountZero(jobid: jobid)
                //print("Document does not exist")
            }
        }
    }
    
    

    func getAllOfflineUsers(completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        //db.collection("cities").whereField("capital", isEqualTo: true)
        
        ChatManager.shared.db.collection(getAllUsersPath()).whereField("online", isEqualTo: 0).getDocuments { (snapshots, error) in
            if (snapshots?.documents.count)! > 0{
                completion((snapshots?.documents)!)
            }
        }
        
        
        
//        let docRef =  ChatManager.shared.db.collection(getAllUsersPath()).document(fieldworkerId)
//        docRef.getDocument { (snapshot, error) in
//
//            if let data = snapshot?.data(){
//                if (data["online"] as! Int) == 0 {
//                    completion(true)
//                }else{
//                    completion(false)
//                }
//            }else{
//                    completion(false)
//            }
//        }
    }
    
    
    
    func unreadCountIncrease(jobid:String, msg:ChatMessageModel) -> Void {
        ChatManager.shared.db.collection(getFieldworkerPath(jobId: jobid)).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if (querySnapshot?.documents.count)! > 0{
                  // print((querySnapshot?.documents.count)!)
                    
                    let batch = ChatManager.shared.db.batch() //Create batch for update multiple values at a time
              
                    //filter offline users and send pushnotification
                     self.filterOfflineUsers(snapshot: querySnapshot!,msg: msg)
               
                    for document in (querySnapshot?.documents)!{
                        if self.fieldworkerIdForFirebase() != document.documentID{
                            
                            if let count = document.data()["unread"] {
                                let newCount =  (count as! Int) + 1
                                batch.setData(["unread": newCount ], forDocument: document.reference, merge: true)
                            }
                        }
                     }
                    
                    batch.commit() { err in
                        if let err = err {
                            print("Error writing batch \(err)")
                        } else {
                            print("Batch write succeeded.")
                        }
                    }
                }else{
                  
                }
            }
        }
    }

    
    func filterOfflineUsers(snapshot: QuerySnapshot, msg:ChatMessageModel) -> Void {
        
        self.getAllOfflineUsers(completion: { (documents) in
            
            if documents.count > 0 {
                
                let arrOFShowTabForm = documents.filter { (obj) -> Bool in
                    let isExist = snapshot.documents.filter({ (doc) -> Bool in
                        if doc.documentID == obj.documentID {
                            return true
                        }else{
                            return false
                        }
                    })
                    
                    if isExist.count > 0 {
                        return true
                    }else{
                        return false
                    }
                }
                
          
                
                var userArry = [String]()
                for usr in arrOFShowTabForm {
                    if (usr.data()["online"] as! Int) == 0 {
                        let  usrid = usr.documentID.split(separator: "-")[1]
                        userArry.append(String(usrid))
                    }
                }
                
                
                if getUserDetails()?.usrId != nil {
                    if let index = userArry.firstIndex(of: getUserDetails()!.usrId!) {
                        userArry.remove(at: index)
                    }
                }
                
                
                
                
                
                if userArry.count > 0 {
                    
                    //  if isHaveNetowork() {
                    self.sendNotificationFromServer(offlineUsers: userArry,message: msg, notificationType: "")
                   //  self.sendNotificationFromServerAdmin(offlineUsers: userArry,message: msg, notificationType: "")
                  //  }
                }
            }
        })
    }
    //////////////////////////
    func sendNotificationFromServerAdmin(offlineUsers : [String], message : ChatMessageModel, notificationType : String) -> Void {
        var isSwitchOff = ""
              isSwitchOff =   UserDefaults.standard.value(forKey: "ForNotification") as? String ?? ""
        var dict = [String:Any]()
        dict["msg"] = message.toDictionary
        dict["cltId"] = isSwitchOff//offlineUsers
        
        
        serverCommunicator(url: Service.sendNotificationToCpClient, param: dict) { (response, success) in
            killLoader()
            
            if(success){
                  print("Message sent successfully.")
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    ///////////////////////
    func sendNotificationFromServer(offlineUsers : [String], message : ChatMessageModel, notificationType : String) -> Void {

        var dict = [String:Any]()
        dict["msg"] = message.toDictionary
        dict["usrId"] = offlineUsers
        
        
        serverCommunicator(url: Service.sendPushNotification, param: dict) { (response, success) in
            killLoader()
            
            if(success){
                  print("Message sent successfully.")
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    func sendFirebaseNotificationFromServer(offlineUsers : [String], message : ChatNotificationModel, notificationType : String) -> Void {

        var dict = [String:Any]()
        dict["msg"] = message.toDictionary
        dict["notyType"] = notificationType
        dict["usrId"] = offlineUsers
//        dict["grpId"] = ["918","867","875"]//
        
        serverCommunicator(url: Service.sendPushNotification, param: dict) { (response, success) in
            killLoader()
            
            if(success){
                  print("Message sent successfully.")
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    
    
    //=======================
    // MARK:- SEND MESSAGE
    //=======================
   func sendMessage(jobid:String, messageDict : ChatMessageModel) -> Void {
    
    
                   let batch = ChatManager.shared.db.batch() // Create batch
    
                   let message = ChatMessageModel() //Create message
                        message.jobCode = messageDict.jobCode
                        message.jobId = messageDict.jobId
                        message.msg = messageDict.type == "1" ?  messageDict.msg : "\(messageDict.usrnm!) sent a file."
                        message.time = messageDict.time
                        message.usrnm = messageDict.usrnm
    
    
                    //Get job's message path and add message
                    let chatMsg = ChatManager.shared.db.collection(getMessagePath(jobId: jobid)).document()
                        batch.setData(messageDict.toDictionary!, forDocument: chatMsg)
    

                    for admin in admins {
                                // Get admin's path for notification messages add
                                let nycRef : DocumentReference = ChatManager.shared.db.collection(getAllUsersPath()).document("ad-\(admin)").collection("notification").document()
                                batch.setData(message.toDictionary!, forDocument: nycRef)
                    }

    
                       batch.commit() { err in
                          if let err = err {
                            print("Error writing batch \(err)")
                        } else {
                           // print("Batch write succeeded.")
                            self.unreadCountIncrease(jobid: jobid,msg: messageDict)  //Increase unread count for other users
                           
                        }
            }

  
    }
    
    //=======================
    // MARK:- GET MESSAGE
    //=======================
    func getMessages(companyID:String, jobid:String , completion: @escaping (Bool) -> ()){
        
        // getMessagePath
        
        ChatManager.shared.db.collection(getMessagePath(jobId: jobid)).order(by: "time", descending: false).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                self.createListenerForJob(jobid: jobid)
                
                if (querySnapshot?.documents.count)! > 0{
                    for snapshot in (querySnapshot?.documents)!{
                         //self.convertInChatResponseModel(snapshot: snapshot)
                        let message = self.convertInChatResponseModel(snapshot: snapshot)
                        if let msg = message {
                            self.chatList.append(msg)
                        }
                    }
                     completion(true)
                }else{
                       completion(false)
                }
            }
        }
        
   
     }

    
    //=======================
    // MARK:- LISTENER FOR JOB
    //=======================
    func createListenerForJob( jobid:String) -> Void
    {
        var firstMsg = false
        let basicQuery = ChatManager.shared.db.collection(getMessagePath(jobId: jobid)).order(by: "time", descending: true).limit(to: 1)
        listenerForjob = basicQuery.addSnapshotListener(includeMetadataChanges: true) { (snapshot, error)in
            if let error = error {
               // print ("I got an error retrieving restaurants: \(error)")
                return
            }
            guard let snapshot = snapshot else { return }
            
            snapshot.documentChanges.forEach { diff in
                
                
                if (diff.type == .added) {
                    if firstMsg == true {
                        let message = self.convertInChatResponseModel(snapshot: snapshot.documents[0])
                        if let msg = message {
                            if self.callback != nil {
                                if msg.type == "1" || msg.file != "" {
                                    self.callback!(msg)
                                }
                                
                            }
                        }
                    }
                    
                }
                
                
                if (diff.type == .modified) {
                    //print("Modified city: \(diff.document.data())")
                    if firstMsg == true {
                        let message = self.convertInChatResponseModel(snapshot: snapshot.documents[0])
                        if let msg = message {
                            if self.callback != nil {
                                self.callback!(msg)
                            }
                        }
                    }
                    
                   // print("modified msg")
                }
                if (diff.type == .removed) {
                    //  print("Removed city: \(diff.document.data())")
                   // print("removed msg")
                }
            }
            
            
            
            firstMsg = true
            
        }
    }
    
    func createListenerForUnreadCount( jobid:String, adminUnreadHandler:@escaping (Int, Bool) -> (), clientUnreadHandler:@escaping (Int, Bool) -> ()) -> ListenerRegistration {
        let basicQuery = ChatManager.shared.db.collection(getFieldworkerPath(jobId: jobid)).document(fieldworkerIdForFirebase())
        let listener: ListenerRegistration = basicQuery.addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
            if let error = error {
              //  print ("I got an error retrieving restaurants: \(error)")
                return
            }
           
            
            guard let snapshot = snapshot else { return }
            if let data = snapshot.data(){
                if let count = data["unread"] {
                    self.notificationForAdminUnreadCount(count: count, jobid: jobid, completionHandler: adminUnreadHandler)
                }
                
                if let count = data["cltunread"] {
                    self.notificationForClientUnreadCount(count: count, jobid: jobid, completionHandler: clientUnreadHandler)
                }
                
                
            }
        }
        return listener
        
    }
    
    
    func notificationForAdminUnreadCount(count : Any?,jobid:String, completionHandler:@escaping (Int, Bool) -> ()) {
       if (count != nil) && (count is Int) && (count as! Int) > 0{
            if ( jobid != self.currentjobID) {
                ChatManager.shared.db.collection(self.getMessagePath(jobId: jobid)).order(by: "time", descending: true).limit(to: 1).getDocuments(completion: { (querySnapshot, error) in
                    
                    
//                    let state = UIApplication.shared.applicationState
//                    if state == .background {
//                        print("App in Background")
//                        return
//
//                    }
                   // print("count comes")
                    
                    let content = UNMutableNotificationContent()
                    
                    if let documents = querySnapshot?.documents {
                        if documents.count > 0 {
                            var  userDict = querySnapshot?.documents[0].data()
                            userDict!["localNoty"] = "admin"
                            
                            if let username = userDict!["usrnm"] {
                                content.title = "\((userDict!["jobCode"])!)-\((username as! String).capitalizingFirstLetter())"
                            }else{
                                content.title = "Unknown"
                            }
                            
                            if let msg = userDict!["msg"] {
                                content.body = (msg as! String)
                            }else{
                                content.body = ""
                            }
                            
                            if let img = userDict!["file"] {
                                if (img as! String) != "" {
                                    content.body =  "📷 Photo"
                                }
                            }
                            
                            content.userInfo = userDict!
                            content.sound = UNNotificationSound.default
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats: false)
                            let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                        }
                    }
                })
            }
            
            completionHandler(count as! Int, (self.currentjobID == "" || (count as! Int) == 0) ? true : false )
            
        }else{
            completionHandler(0,true )
            
        }

    }
    
    
    func notificationForClientUnreadCount(count : Any?,jobid:String, completionHandler:@escaping (Int, Bool) -> ()) {
        if (count != nil) && (count is Int) && (count as! Int) > 0{
            if ( jobid != self.currentjobID) {
                ChatManager.shared.db.collection(self.getClientMessagePath(jobId: jobid)).order(by: "time", descending: true).limit(to: 1).getDocuments(completion: { (querySnapshot, error) in
                    
//                    let state = UIApplication.shared.applicationState
//                    if state == .background {
//                        print("App in Background")
//                        return
//                    }
                    
                    let content = UNMutableNotificationContent()
                    
                    if let documents = querySnapshot?.documents {
                        if documents.count > 0 {
                            var  userDict = querySnapshot?.documents[0].data()
                            userDict!["localNoty"] = "clt"
                            
                            if let username = userDict!["usrnm"] {
                                content.title = "\((userDict!["jobCode"])!)-\((username as! String).capitalizingFirstLetter())"
                            }else{
                                content.title = "Unknown"
                            }
                            
                            if let msg = userDict!["msg"] {
                                content.body = (msg as! String)
                            }else{
                                content.body = ""
                            }
                            
                            if let img = userDict!["file"] {
                                if (img as! String) != "" {
                                    content.body =  "📷 Photo"
                                }
                            }
                            
                            content.userInfo = userDict!
                            content.sound = UNNotificationSound.default
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats: false)
                            let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                        }
                    }
                })
            }
            
            let cltbadgeCount = count as! Int
            
            if callbackClientBadge != nil {
                callbackClientBadge!(cltbadgeCount)
            }
            
            
            completionHandler(cltbadgeCount, (self.currentjobID == "" || (count as! Int) == 0) ? true : false )
            
        }else{
            completionHandler(0,true )
            
        }
    }
    
    
    
    func removeJobForChat(jobId : String) -> Void {
        let index = self.chatModels.firstIndex(where: { (item) -> Bool in
            if item.jobId == jobId {
                item.closureName = nil
                item.listener?.remove()
                item.clientClosureName = nil
                
                return true
            }
            return false
        })
        
        if let indexNumber = index {
             self.chatModels.remove(at: indexNumber)
        }
    }
   
    
    func removeAllListeners() -> Void {
        for listner in chatModels {
              listner.closureName = nil
              listner.listener?.remove()
              listner.clientClosureName = nil
          }
      
          for user in userModels {
              user.documentListner?.remove()
              user.UserOnlineStatusObserver?.removeAllObservers()
          }
          
          self.alreadyListnerCreated = false
          self.alreadyListnerCreatedForNewJob = false
          self.userModels.removeAll()
          self.chatModels.removeAll()
          self.chatList.removeAll()
        
            if selfInactiveRef != nil {
                selfInactiveRef.removeAllObservers()
            }
        
          ref.removeAllObservers() // all observers remove from this one function of Realtime database
}
    
    
    //=======================
    // MARK:- PATHS
    //=======================
    
    func companyidForFirebase() -> String {
          return "comp-\((getUserDetails()?.compId)!)"
    }
    
    func fieldworkerIdForFirebase() -> String {
          return "usr-\((getUserDetails()?.usrId)!)"
    }
    
    func getOnlineOfflinePathOnFirebase() -> String {
        let serverName = currentRegion()!
        let companyName = (getUserDetails()?.compId)!
        let userid = (getUserDetails()?.usrId)!
        let path = "\(serverName)/cmp\(companyName)/users/usr\(userid)/isOnline"
        return path
    }
    
    func getInactivePathOnFirebase() -> String {
        let serverName = currentRegion()!
        let companyName = (getUserDetails()?.compId)!
        let userid = (getUserDetails()?.usrId)!
        let path = "\(serverName)/cmp\(companyName)/users/usr\(userid)/isInactive"
        return path
    }
    
    
    func getBatteryStatusPathOnFirebase() -> String {
        let serverName = currentRegion()!
        let companyName = (getUserDetails()?.compId)!
        let userid = (getUserDetails()?.usrId)!
        let path = "\(serverName)/cmp\(companyName)/users/usr\(userid)/battery"
        return path
    }
    
    func getUserDetailsPath(userid : String) -> String {
           let serverName = currentRegion()!
           let companyName = (getUserDetails()?.compId)!
           //let userid = (getUserDetails()?.usrId)!
           let path = "\(serverName)/cmp\(companyName)/users/usr\(userid)"
           return path
       }
    
    func getGPSstatusPathOnFirebase() -> String {
         let serverName = currentRegion()!
         let companyName = (getUserDetails()?.compId)!
         let userid = (getUserDetails()?.usrId)!
         let path = "\(serverName)/cmp\(companyName)/users/usr\(userid)/gpsStatus"
         return path
     }
    
    
    func getMessagePath(jobId : String) -> String {
            let msgPath = "\(currentRegion()!)/" + "\(companyidForFirebase())/" + "job/" + "\(jobId)/" + "messages"
            return msgPath
    }
    
    func getFieldworkerPath(jobId : String) -> String {
            let FieldworkerPath = "\(currentRegion()!)/" + "\(companyidForFirebase())/" + "job/" + "\(jobId)/" + "users/"
            return FieldworkerPath
    }
    
    func getJobsPath() -> String {
        let jobsPath = "\(currentRegion()!)/" + "\(companyidForFirebase())/" + "job/"
        return jobsPath
    }
    
    
    func getChatsPath() -> String {
              let jobsPath = "\(currentRegion()!)/" + "\(companyidForFirebase())/" + "chats/"
              return jobsPath
      
          }
    
    func convertInChatResponseModel( snapshot : QueryDocumentSnapshot) -> ChatResponseModel? {
        let decoder = JSONDecoder()
        if let messageData = try? decoder.decode(ChatResponseModel.self, from: snapshot.data().toData!) {
            return messageData
        }
        return nil
    }
    
    
    func getAllUsersPath() -> String {
        let msgPath = "\(currentRegion()!)/" + "\(companyidForFirebase())/" + "users/"
        return msgPath
    }
//    func getAllUsersPathForGroup() -> String {
//        let msgPath = "\(currentRegion()!)/" + "\(companyidForFirebase())/" + "groups/"
//        return msgPath
//    }

    //  MARK:- =======================================PATHS FOR CLIENTCHATS=========================================
    
    
      //===============================================
      // MARK:- Add job Notification for Admin  PATH
      //=============================================
    
    func getAllUsersPathForJob() -> String {
        let msgPath = "\(currentRegion()!)/" + "\(companyidForFirebase())/" + "notifyWeb/"
        return msgPath
    }
    
    func  getClientMessagePathForJob(jobId : String) -> String {
        let msgPath = "\(currentRegion()!)/" + "\(companyidForFirebase())/" + "notifyWeb/" + "ad-\(jobId)/" + "newAssignNotify"
        return msgPath
    }
    
    func sendClientdMessageForJob(jobid:String, messageDict : ChatMessageModelForJob1) -> Void {
        
        
        let batch = ChatManager.shared.db.batch() // Create batch
        let jobCod = ""
        let message = ChatMessageModelForJob1() //Create message
        
        message.usrId = messageDict.usrId
        message.action = messageDict.action
        message.msg = messageDict.msg
        message.usrType = messageDict.usrType
        message.usrNm = messageDict.usrNm
        message.id = messageDict.id
        message.type = messageDict.type
        message.time = messageDict.time
         
        
        //Get job's client message path and add message
        let clientchatMsg = ChatManager.shared.db.collection(getClientMessagePathForJob(jobId: jobid)).document()
        batch.setData(messageDict.toDictionary!, forDocument: clientchatMsg)
        
        for admin in admins {
            // Get admin's path for notification messages add
            let nycRef : DocumentReference = ChatManager.shared.db.collection(getAllUsersPathForJob()).document("ad-\(admin)").collection("newAssignNotify").document()
            batch.setData(message.toDictionary!, forDocument: nycRef)
        }
        
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                // print("Batch write succeeded.")
               
                //self.clientUnreadCountIncrease(jobid: jobid,msg: messageDict)  //ClientIncrease unread count for other users
            }
        }
        

    }
    
    //======================================
    // MARK:- CLIENT PATH
    //======================================
    
    func  getClientMessagePath(jobId : String) -> String {
        let msgPath = "\(currentRegion()!)/" + "\(companyidForFirebase())/" + "job/" + "\(jobId)/" + "cltfwmessages"
        return msgPath
    }

    func clientUnreadCountZero(jobid:String) -> Void {
        ChatManager.shared.db.collection(getFieldworkerPath(jobId: jobid)).document(fieldworkerIdForFirebase()).setData([ "cltunread": 0], merge: true)
    }
    
    func clientUnreadCountIncrease(jobid:String, msg:ChatMessageModel) -> Void {
        ChatManager.shared.db.collection(getFieldworkerPath(jobId: jobid)).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if (querySnapshot?.documents.count)! > 0{
                    // print((querySnapshot?.documents.count)!)
                    
                    let batch = ChatManager.shared.db.batch() //Create batch for update multiple values at a time
                    
                    //filter offline users and send pushnotification
                    self.filterOfflineUsers(snapshot: querySnapshot!,msg: msg)
                    
                    for document in (querySnapshot?.documents)!{
                        if self.fieldworkerIdForFirebase() != document.documentID{
                            
                            if let count = document.data()["cltunread"] {
                                let newCount =  (count as! Int) + 1
                                batch.setData(["cltunread": newCount ], forDocument: document.reference, merge: true)
                            }
                        }
                    }
                    
                    batch.commit() { err in
                        if let err = err {
                            print("Error writing batch \(err)")
                        } else {
                            print("Batch write succeeded(client).")
                        }
                    }
                }else{
                    
                }
            }
        }
    }
    
    /////////////
    
    
//    func isExistClientFieldworker(jobid:String) -> Void {
//        let docRef =  ChatManager.shared.db.collection(getFieldworkerPath(jobId: jobid)).document(fieldworkerIdForFirebase())
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                //print("Document is exist")
//            } else {
//
//                self.clientUnreadCountZero(jobid: jobid)
//                //print("Document does not exist")
//            }
//        }
//    }
    
    func sendClientdMessage(jobid:String, messageDict : ChatMessageModel) -> Void {
        
        
        let batch = ChatManager.shared.db.batch() // Create batch
        
        let message = ChatMessageModel() //Create message
        message.jobCode = messageDict.jobCode
        message.jobId = messageDict.jobId
        message.msg = messageDict.type == "1" ?  messageDict.msg : "\(messageDict.usrnm!) sent a file."
        message.time = messageDict.time
        message.usrnm = messageDict.usrnm
        message.isClientChat = "true"
        
        //Get job's client message path and add message
        let clientchatMsg = ChatManager.shared.db.collection(getClientMessagePath(jobId: jobid)).document()
        batch.setData(messageDict.toDictionary!, forDocument: clientchatMsg)
        
        for admin in admins {
            // Get admin's path for notification messages add
            let nycRef : DocumentReference = ChatManager.shared.db.collection(getAllUsersPath()).document("ad-\(admin)").collection("notification").document()
            batch.setData(message.toDictionary!, forDocument: nycRef)
        }
        
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                // print("Batch write succeeded.")
               
                self.clientUnreadCountIncrease(jobid: jobid,msg: messageDict)  //ClientIncrease unread count for other users
            }
        }
        

    }
    
    

     func getClientMessages(companyID:String, jobid:String , completion: @escaping (Bool) -> ()){
        
        // getClientMessagePath
        
        ChatManager.shared.db.collection(getClientMessagePath(jobId: jobid)).order(by: "time", descending: false).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                self.createClientListenerForJob(jobid: jobid)
                
                if (querySnapshot?.documents.count)! > 0{
                    for snapshot in (querySnapshot?.documents)!{
                        //self.convertInChatResponseModel(snapshot: snapshot)
                        let message = self.convertInChatResponseModel(snapshot: snapshot)
                        if let msg = message {
                            self.chatList.append(msg)
                        }
                    }
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }
        
    }
    
    
    func createClientListenerForJob( jobid:String) -> Void
    {
        var firstMsg = false
        let basicQuery = ChatManager.shared.db.collection(getClientMessagePath(jobId: jobid)).order(by: "time", descending: true).limit(to: 1)
        listenerForClientMsg = basicQuery.addSnapshotListener(includeMetadataChanges: true) { (snapshot, error)in
            if let error = error {
              //  print ("I got an error retrieving restaurants: \(error)")
                return
            }
            guard let snapshot = snapshot else { return }
            
            snapshot.documentChanges.forEach { diff in
                
                
                if (diff.type == .added) {
                    if firstMsg == true {
                        let message = self.convertInChatResponseModel(snapshot: snapshot.documents[0])
                        if let msg = message {
                            if self.clientCallback != nil {
                                if msg.type == "1" || msg.file != "" {
                                    self.clientCallback!(msg)
                                }
                                
                            }
                        }
                    }
                }
                
                
                if (diff.type == .modified) {
                    //print("Modified city: \(diff.document.data())")
                    if firstMsg == true {
                        let message = self.convertInChatResponseModel(snapshot: snapshot.documents[0])
                        if let msg = message {
                            if self.clientCallback != nil {
                                self.clientCallback!(msg)
                            }
                        }
                    }
                }
                if (diff.type == .removed) {
                    //  print("Removed city: \(diff.document.data())")
                }
            }
            
            
            
            firstMsg = true
            
        }
    }
    

    //============================
     // User chat model
     //===========================
 
   
    
     func createNewChatMessagesNode(userid : String) {
         
         self.idForuser = userid
            let dict = ["users" : [(getUserDetails()?.usrId)!,userid]]
         ChatManager.shared.db.collection(self.getAllUsersPath()).addDocument(data: dict)
     }
    

    /////////////////////////////////////////////////////////////////////////////////////////FOR GROUP//////////////////////////////////////////////////////////////////////////////////////////////////////////
    func createNewChatMessagesNodeforGroup(userid : String,arrGrp:Array<Any>) {
       
        let  yy:[String:String] = ["grpId":  "grp-\(userid)"]
        grpId = userid
        var newArr = arrGrp
        var ss = newArr.append(yy)
      
          let dict = ["groups" : newArr] //[(getUserDetails()?.usrId)!,userid]]
        
       // let dict = ["groups" : [(getUserDetails()?.usrId)!,yy]]
           ChatManager.shared.db.collection(self.getAllUsersPath()).addDocument(data: dict)
    }
    
     func createListnerForUserslocation() -> Void {
         
                
        let basicQuery = ChatManager.shared.db.collection(getAllUsersPath()).whereField("users", arrayContains:(getUserDetails()?.usrId)!)
          
         basicQuery.addSnapshotListener(includeMetadataChanges: false) { (snapshot, error) in
             
               if let error = error {
                   //  print ("I got an error retrieving restaurants: \(error)")
                     return
                 }
             
             
             guard let snapshot = snapshot else { return }
             
             snapshot.documentChanges.forEach { diff in
                   
                   if (diff.type == .added) {
                    
                    //print("Document added Data \(diff.document.documentID)")
                    let data = diff.document.data()
                    let userArry = (data["users"] as! Array<String>)
                    let userModel = self.userModels.filter({userArry.contains(($0.user!.usrId)!)})
                         
                     if userModel.count > 0 {
                         let model = userModel[0]
                        //model.documentID = diff.document.documentID
                        if model.documentID == nil {
                           model.documentID = diff.document.documentID
                        }
                     }
                   }
                   
                   
                   if (diff.type == .modified) {
                       print("Modified Data")
                     
                   }
                 
                 
                   if (diff.type == .removed) {
                       print("Removed Data")
                     
                   }
               }
          }
     }
    

    var isSwitchOffe =   UserDefaults.standard.value(forKey: "isTeam") as? String ?? ""
    ///////////////////////////////////////////////////////////////////////////////////////FOR GROUP//////////////////////////////////////////////////////////////////////////////////////////////////////////
    func createListnerForUserslocationForGroup() -> Void {
        
               
       let basicQuery = ChatManager.shared.db.collection(getAllUsersPath()).whereField("groups", arrayContains:(getUserDetails()?.usrId)!)
         
        basicQuery.addSnapshotListener(includeMetadataChanges: false) { [self] (snapshot, error) in
            
              if let error = error {
                   // print ("I got an error retrieving restaurants: \(error)")
                    return
                }
            
            guard let snapshot = snapshot else { return }
            
            snapshot.documentChanges.forEach { diff in
                  
                  if (diff.type == .added) {
                   
                   let data = diff.document.data()
                      
                      let dataDiff = diff.document.documentID
                   let userArry = (data["groups"] as! Array<Any>)
                   
                      var arrUser = [String]()
                      
                      for i in userArry {
                          if let idValue = i as? String {
                              arrUser.append(idValue)
                          }
                          if let usrId = i as? [String:String] {
                              arrUser.append(usrId["grpId"] as! String)
                          }
                      }
//                      let tempusrarray= arrUser as! Array<String>
             
                     // var userModel = self.userModels.filter({arrUser.contains(($0.user!.usrId)!)})
                    
                      var userModel = self.userModels.filter({grpId.contains(($0.user!.usrId)!)})
                      
                      if userModel.count > 0 {
                          let model = userModel[0]
                         //model.documentID = diff.document.documentID
                         if model.documentID == nil {
                            model.documentID = diff.document.documentID
                         }
                      }
                    
                    
                      if (diff.type == .modified) {
                          print("Modified Data")
                      }
                      
                      if (diff.type == .removed) {
                          print("Removed Data")
                          
                      }
                   
                      
//                      let userList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "Users", query: nil) as? [Users]
//                      if userList != nil && userList!.count > 0 {
//                          for user in userList! {
//                              let model = UserModel(from: user)
//                              if model.user?.usrId == self.grpId{
//                                 //let model = tuserModel.user
//                                  print(model.user?.usrId)
//
//                                  if model.documentID == nil {
//                                     model.documentID = diff.document.documentID
//
//                                  }
//
//                                   print("FOR Grup ------------\( model.documentID)")
//                                   var on = model.documentID
//                                   UserDefaults.standard.set(on, forKey: "documentID")
//
//                                  if (diff.type == .modified) {
//                                      print("Modified Data")
//
//                                  }
//
//
//                                  if (diff.type == .removed) {
//                                      print("Removed Data")
//                                  }
//
//                                  print("add karana hai")
//
//                               }
//
//
//
//                          }
//                          }
                      }
                   
                      
                    //  let userModel = self.userModels.contains(getUserDetails()?.usrId)
                   // if userModel.count > 0
                     // {
//                        for myid in userModel {
//                                                if myid.user?.usrId == getUserDetails()?.usrId {
//                                                    userModel[0]  = (myid.user?.usrId)!
//
//                                                }
//                                            }
                      //  let model = userModel[0]
                        
//                        if let docum = model.documentID as? String {
//                            print(docum)
//                            model.documentID = diff.document.documentID
//
//                        }
                       //model.documentID = diff.document.documentID
                      
              }
         }
    }
    

    /////////////////////////////////////////////////////////////////////////////////////////FOR GROUP//////////////////////////////////////////////////////////////////////////////////////////////////////////
        
    func sendUsersMessage(documentId:String, messageDict : ChatUserMessageModel) -> Void {
        //Get job's client message path and add message
        let clientchatMsg = ChatManager.shared.db.collection(getChatsPath()).document(documentId)
        clientchatMsg.setData(["messages": FieldValue.arrayUnion([messageDict.toDictionary!])], merge: true)
    }
     
    
     
     func createListnerForIndividualDocument(documentId : String, documentCallback : @escaping ([String:Any]) -> ()) -> ListenerRegistration {
                
        
        let basicQuery = ChatManager.shared.db.collection(getChatsPath()).document(documentId)
        
        basicQuery.getDocument { (document, error) in
            if let document = document, document.exists {
                //print("document is exist")
            }else{
                basicQuery.setData(["messages": []], merge: true) //set blank data in document in chats
            }
        }
        
        // basicQuery.setData(["messages": []], merge: true) //set blank data in document in chats
        
         let listener : ListenerRegistration = basicQuery.addSnapshotListener { (snapshot, error) in //create listner for chats
             
             if let error = error {
                   // print ("I got an error retrieving restaurants: \(error)")
                    return
                }

                guard let snapshot = snapshot else { return }
             
             if let data = snapshot.data() {
                     documentCallback(data)
                 }
               }
             return listener
         }
     
    
    
    
}


