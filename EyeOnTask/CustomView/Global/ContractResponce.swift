//
//  ContractResponce.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 09/11/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class ContractResponce: Codable {

 
        var success: Bool?
        var count: String?
        var data: [ContractListData]
        var message : String?
        
    }

    class ContractListData : Codable{
        var tempId: String?
        var contrId: String?
        var label: String?
        var amount: String?
        var type: String?
        var payType: String?
        var startDate: String?
        var endDate: String?
        var status: String?
        var nm: String?
        var remainingAmt: String?
        var cltId: String?
        var paidAmt: String?
        var invAmount: String?
        var ccId: String?
        var catgy: String?
        var isdelete: String?
        
    }

    
    
//{"success":true,"message":"","data":[{"contrId":"705","label":"CON-41","amount":"122.0000","type":"1","payType":"1","startDate":"1604918931","endDate":"1605005332","status":"1","nm":"jugalcon","remainingAmt":null,"cltId":"10240","paidAmt":"0.0000","invAmount":"0.0000","ccId":"0","catgy":"","isdelete":"1"}],"count":"1"}
