//
//  AppDelegate.swift
//  EyeOnTask
//
//  Created by Apple on 03/05/18.
//  Copyright © 2018 Hemant. All rights reserved.


import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications

//import Firebase
@UIApplicationMain

 class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate {
   // let APPDelegate = UIApplication.shared.delegate as! AppDelegate
    var leaveNoti = ""
    var leaveNotiRes = ""
    var auditNoti = ""
    var auditNotiRes = ""
    var appoinmentNoti = ""
    var appoinmentRes = ""
    var jobNoti = ""
    var jobRes = ""
    var timerCountOneTime = ""
    var window: UIWindow?
    var arrOfctrs = [Any]()
    var arrOfstates = [Any]()
    //var arrOftags = [tagElements]()
    var arrOFCustomForm = [TestDetails]()
    var isCustomFormBack = false
    var mainArr = [CustomDataRes]()
     var mainArrCustomFormTblCellImages = [CellImageAtIndexPath]() // by rohit
    var isRegPopNoti = false
    var apiCallFirstTime = true
    var isLastTwoDaysBadge : Bool?
    let industries = [[ "id" : "1", "name" : "Accounting" ],
                      [ "id" : "2", "name" : "Advertising" ],
                      [ "id" : "3", "name" : "Biotechnology" ],
                      [ "id" : "4", "name" : "Communications" ],
                      [ "id" : "5", "name" : "Consulting" ]];
    var currentVC = ""
    var startLocationTask : DispatchWorkItem?
    var stopLocationTask : DispatchWorkItem?
    var currentJobTab : JobTabController?
    var isOnlyLogin = false
    var appOpenFrom121ChatNotificationUser : String?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("🔯🌠🔯🌠🔯🌠🔯🌠\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)🔯🌠🔯🌠")
        
    //--------Remove Back button Title--------------------------------------
        // UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIDocumentPickerViewController.self]).tintColor = UIColor.red
         hideBackButtonText()
        
    //--------Remove Badge Icon--------------------------------------
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //--------Check Network--------------------------------------
          //  StartNetworkMonitoring()
     
        //Initialize fireStore
         ChatManager.shared.configure()
        // LanguageManager.shared
        setupIQKeyboardManager()
        
        //===========================Json Read ==================
        arrOfctrs = getJson(fileName: "countries")["countries"] as! [Any]
        arrOfstates =  getJson(fileName: "states")["states"] as! [Any]
        
        //Check Authentication
        if let userDetails = getUserDetails() {
            authenticationToken = userDetails.token
        }

        UINavigationBar.appearance().barTintColor = headerGreenColor()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:Font.ColabBold(fontSize: 20.0)]
        UINavigationBar.appearance().isTranslucent = false

        if #available(iOS 13.0, *) {
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = headerGreenColor()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:Font.ColabBold(fontSize: 20.0)]
            //UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:Font.ColabBold(fontSize: 20.0)]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance =  UINavigationBar.appearance().standardAppearance
        } else {
            // Fallback on earlier versions
        }
      
        //-----------Notification Enable-----------------
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in

                // If granted comes true you can enabled features based on authorization.
                guard granted else { return }
                DispatchQueue.main.async {
                      application.registerForRemoteNotifications()
                  }
            }
      
        return true
    }
 
    func setupIQKeyboardManager() -> Void {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        //IQKeyboardManager.shared.shouldHidePreviousNext = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
   
    func hideBackButtonText() -> () {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        UINavigationBar.appearance().tintColor = .white
    }
    
    func hideBackButtonTextPdf() -> () {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
        UINavigationBar.appearance().tintColor = .blue
    }
    
    func showBackButtonText() -> () {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UINavigationBar.appearance().tintColor = .white
    }
    
    func showBackButtonTextPdf() -> () {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
        UINavigationBar.appearance().tintColor = .blue
    }
    
    func showBackButtonTextForFileMan() -> () {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
        UINavigationBar.appearance().tintColor = .blue
    }
    
    //===================================
    // MARK:- Notification Methods
    //===================================
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
       
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      //  print("i am not available in simulator \(error)")
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
       
        if let isAlreadyLogin = UserDefaults.standard.value(forKey: "login") {
            let notyData = notification.request.content.userInfo
            let data = notyData["otherdata"] as? [String : Any]
            
            print(" get NotyDat forground ============  \(notyData)")
           
            if (data != nil) && (isAlreadyLogin as! Bool) == true {
                if(data!["notyType"] as? String == "removeFW"){ // when get remove fieldworker
                    let dict:[String: Any] = ["data": data ?? ""]
                    if(self.isRegPopNoti){
                        NotiyCenterClass.firePopToJobVCNotifier(dict: dict)
                    }else{
                        NotiyCenterClass.fireJobRemoveNotifier(dict: dict)
                    }
                }
                
                if(data!["notyType"] as? String == "someJobArchivedOrUnarchived"){ // when multipla job archive by admin side
                    NotiyCenterClass.fireRefreshsomeJobArchivedOrUnarchived(dict: [:])
                }
                
                if(data!["notyType"] as? String == "newJob"){ // when assign new job
                    NotiyCenterClass.fireRefreshJobListNotifier(dict: [:])
                }
            }
        }
        
        completionHandler([.badge, .alert, .sound])
    }
    
    
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         
         if let isAlreadyLogin = UserDefaults.standard.value(forKey: "login") {
             if (isAlreadyLogin as! Bool) == true {
                 
                 let notyData =  response.notification.request.content.userInfo
                 if  let data = notyData["otherdata"] as? [String : Any] {
                    
                     print(" get NotyDat background ============  \(notyData)")
                     
                     if(data["notyType"] as? String == "removeFW"){ // when remove fieldworker
                         if APP_Delegate.currentVC == "job" {
                             let dict:[String: Any] = ["data": data]
                             if(self.isRegPopNoti){
                                 NotiyCenterClass.firePopToJobVCNotifier(dict: dict)
                             }else{
                                 NotiyCenterClass.fireJobRemoveNotifier(dict: dict)
                             }
                         }else{
                             newJobNotificationHandler(notificationDict: [:])
                         }
                     }
                     
                     if(data["notyType"] as? String == "newJob") || (data["notyType"] as? String == "updateJob") {
                         // when assign new job and update job
                         
                         jobNoti = data["JobCode"] as! String
                         APP_Delegate.jobRes = jobNoti
                         if APP_Delegate.currentVC == "job" {
                             NotiyCenterClass.fireRefreshJobListNotifier(dict: [:])
                         }else{
                             newJobNotificationHandler(notificationDict: [:])
                         }
                     }
                     
                     if (data["notyType"] as? String == "someJobArchivedOrUnarchived"){
                   
                         someJobsArchiveJobNotificationHandler(notificationDict: [:])
                     }
                     
                     if(data["notyType"] as? String == "chat"){ // when get Admin chat push notification
                         adminChatNotificationHandler(notificationDict: data)
                     }
                    
                     if(data["notyType"] as? String == "newAudit") || (data["notyType"] as? String == "updateAudit"){
                         auditNoti = data["JobCode"] as! String
                         APP_Delegate.auditNotiRes = auditNoti
                         AuditNotificationHandler()
                 
                     }
                     
                     if(data["notyType"] as? String == "newLeave") || (data["notyType"] as? String == "updateLeave"){
                         leaveNoti = data["JobCode"] as! String
                         APP_Delegate.leaveNotiRes = leaveNoti
                         LeaveNotificationHandler()
                     }
                     
                     if(data["notyType"] as? String == "newAppointment") || (data["notyType"] as? String == "updateAppointment"){
                         appoinmentNoti = data["JobCode"] as! String
                         APP_Delegate.appoinmentRes = appoinmentNoti
                         AppointmentNotificationHandler ()
                     }
                     
                     if(data["notyType"] as? String == "one2one"){ // when get Admin chat push notification
                         one2oneChatNotificationHandler(notificationDict: data)
                     }
                 
                 }else{
                     
                     // when get local notification from firebase for Admin
                     if notyData["localNoty"] != nil && (notyData["localNoty"] as! String) == "admin" {
                         adminChatNotificationHandler(notificationDict: notyData as? [String : Any])
                     }
                     
                     // when get local notification from firebase for Client
                     if notyData["localNoty"] != nil && (notyData["localNoty"] as! String) == "clt" {
                         clientChatNotificationHandler(notificationDict: notyData as? [String : Any])
                     }
                 }
             }
         }
         completionHandler()
     }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
//        if (UserDefaults.standard.value(forKey: "login") != nil &&  UserDefaults.standard.value(forKey: "login") as! Bool) == true {
//            //print("Chat Offline")
//            ChatManager.shared.setStatusOffline()
//        }
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
         //print("Enter background")
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
          APP_Delegate.timerCountOneTime = "True"
       // print("EnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        APP_Delegate.timerCountOneTime = "True"
        //  print("EnterForeground")
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
         StartNetworkMonitoring()
        APP_Delegate.timerCountOneTime = "False"
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        //--------Remove Badge Icon--------------------------------------
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
         // UserDefaults.standard.set(false, forKey: "login")
          StopNetowrkMonitoring()
          //print("Enter terminate  ")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
//        let container = NSPersistentContainer(name: "EyeOnTask")
        let container = NSPersistentContainer(name: "EyeOnTask")
           
               let storeDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
               let url = storeDirectory.appendingPathComponent("EyeOnTask.sqlite")
               let description = NSPersistentStoreDescription(url: url)
               description.shouldInferMappingModelAutomatically = true
               description.shouldMigrateStoreAutomatically = true
               container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        
            if context.hasChanges{
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
}

