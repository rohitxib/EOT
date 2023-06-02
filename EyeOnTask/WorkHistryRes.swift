//
//  WorkHistryRes.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 22/03/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class WorkHistryRes: Codable {
    var success: Bool?
    var message: String?
    var data: [AuditHWorkHistry]?
    var count: String?
   
}


class AuditHWorkHistry: Codable {
    
    var audId : String?
    var parentId : String?
    var cltId : String?
    var siteId : String?
    var conId : String?
    var contrId : String?
    var label : String?
    var nm : String?
    var cnm : String?
    var snm : String?
    var des : String?
    var type : String?
    var prty : String?
    var kpr : String?
    var schdlStart : String?
    var schdlStartTime : String?
    var schdlFinish : String?
    var schdlFinishTime : String?
    var inst : String?
    var status : String?
    var email : String?
    var mob1 : String?
    var mob2 : String?
    var adr : String?
    var city : String?
    var state : String?
    var ctry : String?
    var zip : String?
    var createDate : String?
    var updateDate : String?
    var lat : String?
    var lng : String?
    var compid : String?
    var landmark : String?
    var feedCount : String?
     var attachCount : String?
    // var tagData : [String]?
     var auditor : [AudrtHistry]?

}

class AudrtHistry: Codable {
     
     var usrId : String?
    
}

////////////
class WorkHistryJobRes: Codable {
    var success: Bool?
    var message: String?
    var data: [JobHWorkHistry]?
    var count: String?
   
}


class JobHWorkHistry: Codable {
    var title : String?
    var jobId : String?
    //  var parentId : String?
    var label : String?
    // var des : String?
    // var type : String?
    var status : String?
    
    var prty : String?
    //  var kpr : String?
     var snm : String?
    //    var des : String?
    //    var type : String?
    //    var prty : String?
    //    var kpr : String?
    var schdlStart : String?
    // var schdlStartTime : String?
    // var schdlFinish : String?
    // var schdlFinishTime : String?
    var adr : String?
    //var invId : String?
    //    var nm : String?
    //    var cnm : String?
    //    var conId : String?
    //    var mob1 : String?
    //    var mob2 : String?
    //    var city : String?
    //    var state : String?
    //    var ctry : String?
    //    var zip : String?
    //    var paid : String?
    //    var total : String?
    //    var lisJobInvoicedng : String?
    //    var isJobProformaInvoice : String?
    //    var feedCount : String?
    //    var attachCount : String?
    //    var cltId : String?
    //    var isRecur :String?
    //    var moduleType : String?
    //    var contrId : String?
    // var isChildJob :String?
    // var jtId : [JtId]?
    // var tagData : [String]?
    // var is_completionNotes : String?
    // var keeper : [KeeperH]?
}

class JtId: Codable {
    
    var jtId : String?
    var title : String?
    var labour : String?
    
}
class KeeperH: Codable {
    
    var usrId : String?
}


/////////

class WorkHistryAppoinmentRes: Codable {
    var success: Bool?
    var message: String?
    var data: [AppoinmentHWorkHistry]?
    var count: String?
   
}


class AppoinmentHWorkHistry: Codable {
    
    var appId : String?
    var parentId : String?
    var nm : String?
    var snm : String?
    var label : String?
    var des : String?
    
    var type : String?
    var status : String?
    //    var snm : String?
    //    var des : String?
    //    var type : String?
    //    var prty : String?
    //    var kpr : String?
    var prty : String?
    var schdlStart : String?
    var schdlStartTime : String?
    var schdlFinish : String?
    var schdlFinishTime : String?
    var inst : String?
    //var invId : String?
   // var cnm : String?
    var email : String?
    var mob1 : String?
    var mob2 : String?
    var city : String?
    var state : String?
    var ctry : String?
    var zip : String?
    var createDate : String?
    var updateDate : String?
    var lat : String?
    var lng : String?
    var adr : String?
    var compid : String?
    var landmark : String?
    var attachCount : String?
    var kpr : [kpr]?
}
//
class kpr: Codable {
    var usrId : String?
}
