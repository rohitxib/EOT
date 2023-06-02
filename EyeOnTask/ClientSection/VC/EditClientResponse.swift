//
//  EditClientResponse.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 14/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation

class EditClientResp: Codable {
    var success: Bool?
    var data: [EditClientDetails]
    var message : String?
}

class EditClientDetails :  Codable{
    var accid: String?
    var acctype: String?
    var adr: String?
    var city: String?
    var cltId: String?
    var cnm: String?
    var conId: String?
    var ctry: String?
    var email: String?
    var gstNo: String?
    var industry: String?
    var isactive: String?
    var mob1: String?
    var mob2: String?
    var nm: String?
    var note: String?
    var pymtType: String?
    var siteId: String?
    var snm: String?
    var state: String?
    var tinNo: String?
    var referral: String?
     var comp_name : String?
    
    init(accid: String, acctype : String , adr : String,city: String, cltId : String , cnm : String,conId: String, ctry : String , email : String,gstNo: String, industry : String , isactive : String,mob1 : String , mob2 : String, nm : String,note : String , pymtType : String,siteId : String,snm : String , state : String , tinNo : String, referral : String , comp_name : String) {
        self.accid = accid
        self.acctype = acctype
        self.adr =  adr
        self.city = city
        self.cltId = cltId
        self.cnm =  cnm
        self.conId = conId
        self.ctry = ctry
        self.email =  email
        self.gstNo =  gstNo
        self.industry = industry
        self.isactive = isactive
        self.mob1 =  mob1
        self.mob2 =  mob2
        self.nm = nm
        self.note = note
        self.pymtType =  pymtType
        self.siteId = siteId
        self.snm = snm
        self.state =  state
        self.tinNo =  tinNo
         self.referral =  referral
        self.comp_name =  comp_name
    }
}
