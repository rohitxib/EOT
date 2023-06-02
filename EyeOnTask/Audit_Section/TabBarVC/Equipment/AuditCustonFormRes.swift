//
//  AuditCustonFormRes.swift
//  EyeOnTask
//
//  Created by Altab on 30/11/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation

class AuditCustomFormResponse: Codable {
    var success: Bool?
    var message: String?
    var data: [AuditCustomFormDetals]
    var count : String?
    var statusCode : String?
    
    init(succ: Bool, mess: String , data : Array<Codable>? , count : String , statusCode: String?) {
        self.success = succ
        self.message = mess
        self.data =  data as! [AuditCustomFormDetals]
        self.count = count
        self.statusCode = statusCode
    }
    
}

class AuditCustomFormDetals : Codable {
    
    // For Get Job List
    var queId: String?
    var parentId: String?
    var parentAnsId: String?
    var frmId : String?
    var des: String?
    var type : String?
    var mandatory : String?
    var frmType : String?
    var ans : [AnsDetals]?

    
    init(queId: String?, parentId: String? , parentAnsId :String? , frmId :String?, des :String?,type :String?, mandatory :String?,frmType: String? , ans:  Array<Codable>?) {
        self.queId = queId
        self.parentId = parentId
        self.parentAnsId = parentAnsId
        self.frmId = frmId
        self.des = des
        self.type = type
        self.mandatory = mandatory
        self.frmType = frmType 
        self.ans = ans as?[AnsDetals]
    }
    
}
