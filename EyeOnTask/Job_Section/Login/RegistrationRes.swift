//
//  RegistrationRes.swift
//  EyeOnTask
//
//  Created by Altab on 03/11/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation

class RegistrationResponse: Codable {
    var success:Bool?
    var message:String?
    var transVar:Email?
    
}

class Email:Codable{
    var to:String?
}


class EmailVerify: Codable {
    var success:Bool?
    var message:String?
    var data:[String]?
    
}

//class Email:Codable{
//    var to:String?
//}



//{"success":true,"message":"","data":[]}

//{"success":true,"message":"success_reg_code_sent","transvar":{"to":"kx@zui.com"}}
