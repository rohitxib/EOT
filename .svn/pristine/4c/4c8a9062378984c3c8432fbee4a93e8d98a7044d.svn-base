//
//  AddClientResponse.swift
//  EyeOnTask
//
//  Created by mac on 11/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class AccountTypeName: Codable {
    var success: Bool?
    var message: String?
    var data: [accountTypeDetails]
    var count : String?
    var statusCode : String?
    
    init(succ: Bool, mess: String , data : Array<Codable>? , count : String , statusCode: String?) {
        self.success = succ
        self.message = mess
        self.data =  data as! [accountTypeDetails]
        self.count = count
        self.statusCode = statusCode
    }
}

class accountTypeDetails : Codable {

    // For Get Job List
    var accId: String?
    var compId: String?
    var type: String?
  
    
    
    init(accId: String,compId: String,type: String){
        
        self.accId = accId
        self.compId = compId
        self.type = type
        
        
    }
}



