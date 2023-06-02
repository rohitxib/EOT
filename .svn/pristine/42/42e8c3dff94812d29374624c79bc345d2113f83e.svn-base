//
//  EditContactResp.swift
//  EyeOnTask
//
//  Created by mac on 13/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class EditContactResp: Codable {
    
        var success: Bool?
        var count: String?
        var data: EditContactDetails
        var message : String?
        
    init(succ: Bool, count : String , data : EditContactDetails? ,message : String ) {
            self.success = succ
            self.count = count
           self.data =  data! 
            self.message = message
        }
}

class EditContactDetails :  Codable{
    var cnm: String?
    var conId: String?
    var def: String?
    var email: String?
    var fax: String?
    var mob1: String?
    var mob2: String?
    var skype: String?
    var twitter: String?
    
    init(cnm: String,conId: String,def: String, email: String,fax: String,mob1: String,mob2: String,skype: String,twitter: String){
        
        self.cnm = cnm
        self.conId = conId
        self.def = def
        self.email = email
        self.fax = fax
        self.mob1 = mob1
        self.mob2 = mob2
        self.skype = skype
        self.twitter = twitter
        
    }
    
}
