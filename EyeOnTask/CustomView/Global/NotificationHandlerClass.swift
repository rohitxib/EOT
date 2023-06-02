//
//  NotificationHandlerClass.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 11/02/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation


enum NotificationType : String {
    case AdminChat = "admin"
    case ClientChat = "clt"
    case localNotification = "localNoty"
    case NewAudit = "newAudit"
    case UpdateAudit = "updateAudit"
    case NewJob = "newJob"
    case RemoveFieldworker = "removeFW"
}


class NotificationHandlerClass {
    static let shared = NotificationHandlerClass()
    
    
    //============================================
     //MARK:- Initialize NotificationHandlerClass
     //===========================================
     private init() {
        // print("initialized NotificationHandlerClass")
     }
    
    
    func notificationType(notyType : NotificationType) -> Void {
        
        
        
        
    }
    
    
    
}
