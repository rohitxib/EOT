//
//  CustomFormResponse.swift
//  EyeOnTask
//
//  Created by mac on 07/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class CustomFormResponse: Codable {
    var success: Bool?
    var message: String?
    var data: [CustomFormDetals]
    var count : String?
    var statusCode : String?
    
    init(succ: Bool, mess: String , data : Array<Codable>? , count : String , statusCode: String?) {
        self.success = succ
        self.message = mess
        self.data =  data as! [CustomFormDetals]
        self.count = count
        self.statusCode = statusCode
    }
    
}

class CustomFormDetals : Codable {
    
    // For Get Job List
    var queId: String?
    var parentId: String?
    var parentAnsId: String?
    var frmId : String?
    var des: String?
    var type : String?
    var mandatory : String?
    var opt : [OptDetals]?
    var ans : [AnsDetals]?
    var frmType:String?
    
    init(queId: String?, parentId: String? , parentAnsId :String? , frmId :String?, des :String?,type :String?, mandatory :String?, frmType:String?,opt: Array<Codable>? , ans:  Array<Codable>?) {
        self.queId = queId
        self.parentId = parentId
        self.parentAnsId = parentAnsId
        self.frmId = frmId
        self.des = des
        self.type = type
        self.mandatory = mandatory
        self.opt = opt as?[OptDetals]
        self.ans = ans as?[AnsDetals]
        self.frmType = frmType
    }
    
}

class OptDetals : Codable {
    var key: String?
    var questions: [QuestionsDetails]?
    var value: String?
    var optHaveChild : String?
    init(key: String?, questions:  Array<Codable>?, value :String?, optHaveChild :String?) {
        self.key = key
        self.questions = questions as? [QuestionsDetails]
        self.value = value
        self.optHaveChild = optHaveChild
    }
   
}

class QuestionsDetails : Codable {
}


class AnsDetals : Codable {
    var key: String?
    var value: String?
    var layer: String?
    init(key: String?, value :String?, layer :String?) {
        self.key = key
        self.value = value
        self.layer = layer
    }
    func initWith(ansDetails:ansDetails) {
        self.key = ansDetails.key
        self.value = ansDetails.value
        self.layer = ansDetails.layer
    }
    
}
   


