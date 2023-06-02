//
//  ResEquipmentHistry.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 13/03/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import Foundation

class ResEquipmentHistry: Codable {
    var success: Bool?
    var message: String?
    var data: [AllEquipment]?
    var count: String?
   
}


class AllEquipment: Codable {
    
    var audId : String?
    var label : String?
    var type : String?
    var status : String?
    var nm : String?
    var adr : String?
    var kpr : String?
    var schdlStart : String?
    var schdlStartTime : String?
    var schdlFinish : String?
    var schdlFinishTime : String?
    var isRemark : String?
    var datetime : String?
    var remarkStatus : String?
    var statusText : String?
    var remark : String?
    var location : String?
    var contrid : String?
    var moduleId : String?
    var auditor : [Audrt]?
    var attachments : [Attachment]?

}

class Audrt: Codable {
     
     var usrId : String?
    
}
class Attachment: Codable {
     
       var attachmentId : String?
       var audId : String?
       var deleteTable : String?
       var image_name : String?
       var userId : String?
       var attachFileName : String?
       var attachThumnailFileName : String?
       var attachFileActualName : String?
       var docNm : String?
       var des : String?
       var createdate : String?
    
}


class AllEquipmentService: Codable {
    var success: Bool?
    var message: String?
    var data: [AllEquipmtser]?
    var count: String?
   
}


class AllEquipmtser: Codable {
    
    var audId : String?
    var label : String?
    var type : String?
    var status : String?
    var nm : String?
    var adr : String?
    var kpr : String?
    var schdlStart : String?
    var schdlStartTime : String?
    var schdlFinish : String?
    var schdlFinishTime : String?
    var isRemark : String?
    var datetime : String?
    var remarkStatus : String?
    var statusText : String?
    var remark : String?
    var location : String?
    var contrid : String?
    var moduleId : String?
    var auditor : [AudrtSer]?
    var jtId : [JtIdSer]?
    var attachments : [AttachmentSer]?


}


class AudrtSer: Codable {
     
     var usrId : String?
    
}

class JtIdSer: Codable {
     
     var jtId : String?
     var title : String?
     var labour : String?
    
}

class AttachmentSer: Codable {
     
       var attachmentId : String?
       var audId : String?
       var deleteTable : String?
       var image_name : String?
       var userId : String?
       var attachFileName : String?
       var attachThumnailFileName : String?
       var attachFileActualName : String?
       var docNm : String?
       var des : String?
       var createdate : String?
    
}

class EquipmentAuditDetail: Codable {
    var success: Bool?
    var message: String?
    var data: AuditDetailData?
   // var count: String?
   
}

class AuditDetailData: Codable {
    
    
    var audId : String?
    var parentId : String?
    var label : String?
  //  var contrLabel: String?
   // var contrType: String?
    var cltId : String?
    var siteId : String?
    var conId : String?
    var des : String?
    var type : String?
    var prty : String?
    var status : String?
    var kpr : String?
    var athr :String?
    var schdlStart : String?
    var schdlFinish : String?
    var inst : String?
    var nm : String?
    var cnm : String?
    var snm : String?
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
    var remark : String?
    var contrId : String?
    var recurType : String?
    var isRecur : String?
    var auditType : String?
   // var isChildJob: String?
    var auditor : [Auditer]?
    var feedCount : String?
    var equipmentCount : String?
    var attachmentCount : String?
   // var  equCategory: [String]?
    var tagData: [String]?
    
    
    class Auditer : Codable {
        var  usrId : String?
        var  status : String?
    }
}

class EquipmentServiceData: Codable {
    var success: Bool?
    var message: String?
    var data: ServiceDetailData?
 
   
}

class ServiceDetailData: Codable {
    
    var complNote : String?
    var jobId : String?
    var contrId : String?
  //  var contrLabel : String?
   // var contrType: String?
    var parentId: String?
    var cltId : String?
    var siteId : String?
    var conId : String?
    var leadId : String?
   // var leadLabel : String?
    var label : String?
    var des : String?
    var type : String?
    var prty :String?
    var status : String?
    var kpr : String?
    var athr : String?
    var schdlStart : String?
    var schdlFinish : String?
    var inst : String?
    var nm : String?
    var cnm : String?
    var snm : String?
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
    var recurType : String?
    var isRecur : String?
    var landmark : String?
    var isAutoAssignEnable: String?
    var quotId : String?
  //  var quotLabel : String?
    var signature : String?
    var datetime : String?
    var  mailSentDatetime : String?
   // var jtId : [String]?//////////////
    var equipmentCount : String?
    //  var isChildJob : String?
    var gstNo : String?
    var tinNo : String?
    //var cltAcctType : [String]?
   // var keeper : [Keeper]?////////////////
  //  var tagData : [String]?
    
   // var chatUser : [ChatUser]/////////////////////////
    
    var  feedCount : String?
    var attachCount : String?
    var cur : String?
    // var canInvoiceCreated : String?
    // var isJobHaveCompletionDetail : String?
   // var equType : String?
    //var billingSummary : [BillingSummary]?///////////
    
}

class BillingSummary: Codable {
    
    var cur : String?
    var invId : String?
    var paid : String?
     var total : String?
}

class Keeper: Codable {
    
    var usrId : String?
    var status : String?
    var img : String?
}

class ChatUser: Codable {
    
    
    var usrId : String?
    var isactive : String?
    var usertype : String?
    var fnm : String?
    var lnm : String?
    var img : String?
}

////////////
//{"success":true,"message":"appoint_found","data":{"appId":"95838","contrId":"0","type":"1","cltId":"10043","leadId":"182","siteId":"10418","conId":"0","label":"APP-130","des":"Jiiiii","status":"12","kpr":[{"usrId":"470","status":"12"}],"nm":"aaa","snm":"self","schdlStart":"1614074700","schdlFinish":"1614078300","cnm":null,"email":"","mob1":"","mob2":"","adr":"jgjh","city":"","state":"21","ctry":"101","zip":"","landmark":"","tempId":"Appointment-470-1614074758","quotId":null,"quotLabel":null,"jobId":"95854","jobLabel":"job-538","attachCount":"0","attachments":[]}}


class ApppinmentDetailDataHstry: Codable {
    var success: Bool?
    var message: String?
    var data:ApppinmentDetailData?
 
   
}

class ApppinmentDetailData: Codable {
    
    var appId : String?
    var contrId : String?
    var type : String?
    var cltId : String?
    var leadId: String?
    var siteId: String?
    var conId : String?
    var label : String?
    var des : String?
    var status : String?
    var leadLabel : String?
    var nm : String?
    var snm : String?
    var schdlStart : String?
    var schdlFinish :String?
    var cnm : String?
    var email : String?
    var mob1 : String?
    var mob2 : String?
    var adr : String?
    var city : String?
    var state : String?
    var ctry : String?
    var zip : String?
    var landmark : String?
    var tempId : String?
    var quotId : String?
    var quotLabel : String?
    var jobId : String?
    var jobLabel : String?
   // var attachCount : String?
  //  var attachments : [String]?
//    var kpr : [Kpr]?
    
}
class Kpr: Codable {
    var usrId : String?
    var status : String?
}


class UserManualData: Codable{
    var success : Bool?
    var message : String?
    var data : String?
}
