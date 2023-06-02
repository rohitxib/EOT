//
//  SubcriptionRes.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 11/08/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation


//{"success":true,"message":"before_expire_subscription_to_admin","data":{"amount":"0","month":"2","currency":"51","numAdmin":"0","numUser":"0","offer":"","offtype":"","comp_expirydate":"1750031999","usr_type":"1","planId":"3","paymentStatus":"0","requestType":"3"},"transVar":{"exp_date":"15-Jun-2025"}}

class SubcriptionResponse: Codable {
    var success: Bool?
    var message: String?
    var data: SubcriptionData?
    var count: String?
    var statusCode: String?
    var transVar : TransVar?
}


class SubcriptionData: Codable {
    var amount : String?
    var month : String?
    var currency : String?
    var numAdmin : String?
    var numUser : String?
    var offer : String?
    var offtype : String?
    var comp_expirydate : String?
    var usr_type : String?
    var planId : String?
    var paymentStatus : String?
    var requestType : String?
    var count:String?
  
}
class TransVar: Codable {
 var exp_date: String?
}
