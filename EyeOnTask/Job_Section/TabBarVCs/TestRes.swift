//
//  TestRes.swift
//  EyeOnTask
//
//  Created by mac on 07/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class TestRes: Codable {
    var success: Bool?
    var message: String?
    var data: [TestDetails]
    var count : String?
    var statusCode : String?
}

class TestDetails : Codable {
    var frmId: String?
    var jtId: String?
    var frmnm: String?
    var event : String?
    var tab: String?
    var mandatory : String?
    var totalQues : String?
    var status_code : String?
    var jobid : String?

}


class TestDetailsOffline : Codable {
    var frmId: String?
    var jtId: String?
    var frmnm: String?
    var event : String?
    var tab: String?
    var mandatory : String?
    var totalQues : String?
    var status_code : String?
    var jobid : String?
    
    init(frmId : String?,jtId : String?, frmnm : String?,event : String?,tab : String?,mandatory : String?,totalQues : String?,status_code : String?,jobid : String?){
        
        self.frmId = frmId
        self.jtId = jtId
        self.frmnm = frmnm
        self.event = event
        self.tab = tab
        self.mandatory = mandatory
        self.totalQues = totalQues
        self.status_code = status_code
        self.jobid = jobid
        
    }

}

class TestResAudit: Codable {///
    var success: Bool?
    var message: String?
    var data: [TestDetailsAudit]
    var count : String?
    var statusCode : String?
}
class TestDetailsAudit : Codable {
    var frmId: String?
    var jtId: String?
    var frmnm: String?
    var event : String?
    var tab: String?
    var mandatory : String?
    var totalQues : String?
    var status_code : String?
    var jobid : String?

}

//{"success":true,"data":{"frmId":"125","jtId":"","frmnm":"Custom Field","event":"","smt":"1","mm":"0"}}

class FormDetail: Codable {
    var success: Bool?
    var message: String?
    var data: GetDetail
   // var count : String?
   // var statusCode : String?
}
class GetDetail : Codable {
    var frmId: String?
    var jtId: String?
    var frmnm: String?
    var event : String?
    var smt: String?
    var mm : String?
   

}
//{"success":true,"data":[{"queId":"256","parentId":"-1","parentAnsId":"-1","frmId":"125","des":"675","type":"6","mandatory":"0","frmType":"2","ans":[]}
class getQuestionsByParent: Codable {
    var success: Bool?
    var message: String?
    var data: [getQuestionsBy]
   // var count : String?
   // var statusCode : String?
}
class getQuestionsBy : Codable {
    var queId: String?
    var parentId: String?
    var parentAnsId: String?
    var frmId : String?
    var des: String?
    var type : String?
   var mandatory : String?
   var frmType: String?
   var ans : [QuestionsBy]

}

class QuestionsBy : Codable {
    var key: String?
    var value: String?
    

}

class FormDetailAudit: Codable {
    var success: Bool?
    var message: String?
    var data: GetDetailAudit
   // var count : String?
   // var statusCode : String?
}
class GetDetailAudit : Codable {
    var frmId: String?
    var jtId: String?
    var frmnm: String?
    var event : String?
    var smt: String?
    var mm : String?
    var linkTo : String?
    var auditType : String?
    var equCategory : String?

    
   

}

