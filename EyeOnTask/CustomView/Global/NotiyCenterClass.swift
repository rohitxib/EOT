//
//  NotiyCenterClass.swift
//  EyeOnTask
//
//  Created by mac on 31/08/18.
//  Copyright © 2018 Hemant. All rights reserved.
//



import UIKit

class NotiyCenterClass: NSObject {
    
    //=============
    //registerJobRemoveNotifier
    //=============
    class func registerJobRemoveNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "JobRemove"), object: nil)
    }
    
    
    class func fireJobRemoveNotifier(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "JobRemove"), object: nil, userInfo: dict)
    }
    
    class func removeJobRemoveNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("JobRemove"), object: nil)
    }
    
    
    //=====================
    //registerBatteryLevel
    //=====================
    
    class func registerBatteryLevelNotifier() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(NotiyCenterClass.batteryLevelDidChange(_:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    }
    
    class func removeBatteryLevelNotifier() -> Void {
        NotificationCenter.default.removeObserver(self, name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    }
    
    @objc class func batteryLevelDidChange(_ notification: Notification) {
       // print("Battery level status changed = \(batteryLevel)")
        ChatManager.shared.setBatteryStatusOnFirebase(batteryPercentage:batteryLevel )
    }
    
    
    //=============
    //registerAuditRemoveNotifier
    //=============
    class func registerJAuditRemoveNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "AuditRemove"), object: nil)
    }
    
    
    class func fireAuditRemoveNotifier(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AuditRemove"), object: nil, userInfo: dict)
    }
    
    class func removeAuditRemoveNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("AuditRemove"), object: nil)
    }
    
//    //====================
//    //registerJobChatNotifier
//    //====================
//    class func registerNotiHandlerNotifier(vc : Any, selector : Selector) -> Void {
//        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "NotiHandler"), object: nil)
//    }
//
//
//    class func fireNotiHandlerNotifier(dict:[String: Any]) -> Void {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotiHandler"), object: nil, userInfo: dict)
//    }
//
//    class func removeNotiHandlerNotifier(vc : Any) -> Void {
//        NotificationCenter.default.removeObserver(vc, name: Notification.Name("NotiHandler"), object: nil)
//    }
//
//    //==========================
//    //registerclientChatNotifier
//    //=========================
//    class func registerCltNotiHandlerNotifier(vc : Any, selector : Selector) -> Void {
//        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "CltNotiHandler"), object: nil)
//    }
//
//
//    class func fireCltNotiHandlerNotifier(dict:[String: Any]) -> Void {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CltNotiHandler"), object: nil, userInfo: dict)
//    }
//
//    class func removeCltNotiHandlerNotifier(vc : Any) -> Void {
//        NotificationCenter.default.removeObserver(vc, name: Notification.Name("CltNotiHandler"), object: nil)
//    }
    
    //=========================================================
    //if Audit Refresh then pop to equipment refresh Notifire
    //=========================================================
    
    class func registerRefreshEquipmentListNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "refreshEquipmentList"), object: nil)
    }
    
    
    class func fireRefreshEquipmentListNotifier(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshEquipmentList"), object: nil, userInfo: dict)
    }
    
    
    class func removeRefreshEquipmentListNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("refreshEquipmentList"), object: nil)
    }
    
    //============================================
    //if Audit Refresh then pop to jobvc Notifire
    //============================================
    
    class func registerRefreshAuditListNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "refreshAuditList"), object: nil)
    }
    
    
    class func fireRefreshAuditistNotifier(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAuditList"), object: nil, userInfo: dict)
    }
    
  
    class func removeRefreshAuditListNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("refreshAuditList"), object: nil)
    }
    
    
    class func registerRefreshLeaveNotifier(vc : Any, selector : Selector) -> Void {
          NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "refreshLeave"), object: nil)
      }
    
    class func fireRefreshLeaveNotifier(dict:[String: Any]) -> Void {
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshLeave"), object: nil, userInfo: dict)
      }
  
    class func AppointmentregisterRefreshAuditListNotifier(vc : Any, selector : Selector) -> Void {
           NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "refreshAppointment"), object: nil)
       }
    
    class func AppointmentfireRefreshAuditistNotifier(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAppointment"), object: nil, userInfo: dict)
    }
    //============================================
    //if Job remove then pop to jobvc Notifire
    //============================================
    
    class func registerPopToJobVCNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "PopToJobVC"), object: nil)
    }
    
    
    class func firePopToJobVCNotifier(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PopToJobVC"), object: nil, userInfo: dict)
    }
    
    
    class func removePopToJobVCNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("PopToJobVC"), object: nil)
    }
    
    
    //============================================
    //if Job Refresh then pop to jobvc Notifire
    //============================================
    
    class func addJobRefreshJobList(vc : Any, selector : Selector) -> Void {
           NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "addJobRefreshJobList"), object: nil)
       }
       
       class func addJobRefreshJobList(dict: [String: Any]) -> Void {
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addJobRefreshJobList"), object: nil, userInfo: dict)
       }
    
    class func fireRefreshJobListNotifier(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fireRefreshJobListNotifier"), object: nil, userInfo: dict)
    }
    
    class func fireRefreshJobListNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "fireRefreshJobListNotifier"), object: nil)
    }
    
    class func registerRefreshJobListNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "refreshJobList"), object: nil)
    }
    
    class func someJobArchivedOrUnarchived(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "someJobArchivedOrUnarchived"), object: nil)
    }
    
  
    class func fireRefreshsomeJobArchivedOrUnarchived(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "someJobArchivedOrUnarchived"), object: nil, userInfo: dict)
    }
    
    class func multiplaJobsArcivetNotifier(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshJobList"), object: nil, userInfo: dict)
    }
    
    
    class func removeRefreshJobListNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("refreshJobList"), object: nil)
    }
    
    //============================================
    //if Job remove then pop to Quote Notifire
    //============================================
    
    class func registerRefreshQuoteListNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "refreshQuoteList"), object: nil)
    }
    
    
    class func fireRefreshQuoteListNotifier(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshQuoteList"), object: nil, userInfo: dict)
    }
    
    
    class func removeRefreshQuoteListNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("refreshQuoteList"), object: nil)
    }
    
    class func fireRefreshInvoiceAmount(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fireRefreshInvoiceAmount"), object: nil, userInfo: dict)
    }
    
    class func fireRefreshInvoiceAmount(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "fireRefreshInvoiceAmount"), object: nil)
    }
    
}
