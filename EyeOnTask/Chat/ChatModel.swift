//
//  ChatModel.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 10/01/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import Firebase
class ChatModel: NSObject {

    var jobId : String?
    var count : Int = 0
    var clientCount : Int = 0
    var closureName: ((Int) -> Void)?
    var clientClosureName: ((Int) -> Void)?
    var listener : ListenerRegistration?
    var totelCount = 0
    //var Clientlistener : ListenerRegistration?
    var cell : TaskTableViewCell?
    
    
     init(from Job: UserJobList) {
        super.init()
        
        self.jobId = Job.jobId

       var newjobid = ""
        
        //Check
        
         if getDefaultSettings()?.staticJobId != "" &&  getDefaultSettings()?.staticJobId != nil {
             
             if Float(getDefaultSettings()!.staticJobId ?? "")! > Float(Job.jobId!)! {
                 newjobid = "\((Job.label)!)-\((Job.jobId)!)"
             }else{
                 newjobid = Job.jobId!
             }
             
             ChatManager.shared.isExistFieldworker(jobid: newjobid) // for chat
             
             
             let listenerForJob = ChatManager.shared.createListenerForUnreadCount(jobid: newjobid, adminUnreadHandler: { (adminCount, updateUI) in

                 self.count = adminCount
                 self.showingTotelBadgeOnCell()

                 if self.closureName != nil && updateUI ==  true {
                    self.closureName!(self.count)
                 }

             }) { (clientCount, updateUI) in

                     self.clientCount = clientCount
                     self.showingTotelBadgeOnCell()
                     if self.clientClosureName != nil && updateUI ==  true {
                         self.clientClosureName!(self.clientCount)
                     }
             }
             

             listener =  listenerForJob // for chat
             
         }
  

    }
    
    // Totel batch count of job and client chats :-
    func showingTotelBadgeOnCell() {
        
        self.totelCount = self.count + self.clientCount
        
        if let currentCell = self.cell {
            DispatchQueue.main.async {
                if self.totelCount > 0{
                    currentCell.lblBadge.text = "\(self.totelCount)"
                    currentCell.lblBadge.isHidden = false
                }else{
                    currentCell.lblBadge.isHidden = true
                }
            }
        }
        
    }
}
