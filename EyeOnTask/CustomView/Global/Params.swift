//
//  Params.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 31/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation


class ActivityParams : Codable {
    var device: String?
    var module: String?
    var msg: String?
    
    
    convenience init(module : String, message : String) {
        self.init()
        self.device = "5"
        self.module = module
        self.msg = message
    }
    
}

class ActivityParamsArray : Codable {
    var device: String?
    var module: [String]?
    var msg: String?
    
    
    convenience init(module : [String], message : String) {
        self.init()
        self.device = "5"
        self.module = module
        self.msg = message
    }
    
}

class ParamsContect : Codable {
    
    
    var tempId: String?
    var conId: String?
    var cltId: String?
    var cnm: String?
    var email : String?
    var mob1 : String?
    var mob2 : String?
    var fax: String?
    var twitter: String?
    var skype: String?
    var def: String?
    var compId: String?
    var siteId: [String]?
    var snm: String?
    var extraField1: String?
    var extraField2: String?
    var extraField3: String?
    var extraField4: String?
    var notes: String?
    var isactive : String?

}


class Params : Codable {
    var isAddAttachAsCompletionNote: Int?
    var usrManualDoc:URL?
    var dayNum: String?
    var weekNum:String?
    var mode:String?
    var startDate:String?
    var interval:String?
    var endDate:String?
    var numberOfOcurrences:String?
    var endRecurMode:String?
    var weekDays:[String]?
    var occurDay:String?
    var isCallFromCurrent:String?
    var duration:String?
    var timezone:String?
    var lngId:String?
    var mob:String?
    var localId:String?
    var planId:String?
    var apiCode: String?
    var code : String?
    var email: String?
    var pass: String?
    var key: String?
    var devType: String?
    var device_Type : String?
    var audId : String?
    var username : String?
    var apiurl: String?
    var comp_name :String?
    var location: String?
    var remark: String?
    var equId: String?
    var isJob:String?
    var devName: String?
    var appVersion: String?
    var osVersion: String?
    var docNm: String?
    var auditType : String?
    var devId: String?
    var usrId: String?
    var msg : String?
    var isAddContact : String?
    var udId: String?
    var limit: String?
    var index: String?
    var search: String?
    var op: String?
    var np : String?
    var cc : String?
    var apiRequestFrom: String?
    var isEmailSendOrNot : Bool?
    var linkTo :String?
    var tempId:String?
    var answer : [CustomDataRes]?
    var isInvPdfSend : String?
    var parentId: String?
    var queId: String?
    var ansId: String?
    var compId: String?
    var cltId: String?
    var siteId: String? 
    var conId: String?
    var quotId: String?
    var jtId : [jtIdParam]?
    var isdelete : String?
    var des: String?
    var type: String?
    var prty: String?
    var status: String?
    var athr: String?
    var kpr: String?
    var stripLink : stripLinkData?
    var schdlStart: String?
    var schdlFinish: String?
    var inst: String?
    var nm: String?
    var lnm: String?
    var cnm: String?
    var snm: String?
    var mob1: String?
    var mob2: String?
    var adr: String?
    var city: String?
    var state: String?
    var ctry: String?
    var zip: String?
    var memIds: [String]?
    var clientForFuture: String?
    var siteForFuture: String?
    var contactForFuture: String?
    var pymtType: String?
    var gstNo: String?
    var tinNo: String?
    var industry: String?
    var note: String?
    var fax: String?
    var twitter: String?
    var skype: String?
    var def : String?
    var isactive : String?
    var jobId : String?
    var dateTime : String?
    var rating : String?
    var tagData : [[String : String]]?
    var updateDate : String?
    var title : String?
    var landmark : String?
    var term : String?
    var industryName : String?
    var lat: String?
    var lng: String?
    var itemId: String?
    var time: String?
    var btryStatus: String?
    var dataType: String?
    var moduleType : String?
    var apiUrl : String?
    var requestParam : String?
    var response : String?
    var version : String?
    var frmId : String?
    var invId: String?
    var searchKey: String?
    var serialNo: String?
    var activeRecord: String?
    var showInvoice: String?
    var complNote: String?
    var discount: String?
    var total: String?
    var paid: String?
    var pono: String?
    var invDate: String?
    var dueDate: String?
    var newItem: [newItemData]?
    var itemData: [itemData]?
    var equipData: [equArray]?
    var groupByData: [groupData]?
    var answerArray: [[String:String]]?
    var changeState: String?
    var cur: String?
    var pro: String?
    var invType: String?
    var isItemOrTitle: String?
    var isShowInList: String?
    var inv_client_address: String?
    var hsncode : String?
    var pno : String?
    var unit : String?
    var taxamnt : String?
    var shipto : String?
    var isMobile : Int?
    var attachCount : String?
    var amt: String?
    var ref: String?
    var paytype: String?
    var paydate: String?
    var documentId :[String]?
    var isMailSentToClt : String?
    var message: String?
    var subject: String?
    var to: String?
    var bcc: String?
    var from: String?
    var fromnm: String?
    var expId:String?
    var erId:String?
    var receipt:String?
    var checkType: String?
    var checkId: String?
    var  comment: String?
    var isJobCardPdfSend :String?
    var dtf : String?
    var dtt : String?
    var assignByUser : String?
    var forMobile :  String?
    var iqmmId: [String]?
    var barCode : String?
    var latLongData : [LocationObject]?
    var jaId : String?
    var locId : String?
    var module : String?
    var device : String?
    var name : String?
    var category : String?
    var tag : String?
    var categoryName : String?
    var referral: String?
    var installedDate: String?
    var isIncludingTeam : String?
    var appId : String?
    var label: String?
    var contrId: String?
    var attachments: String?
    var leadId: String?
    var appDoc: [String]?
    var atechmentType : String?
    var docUrl : URL?
    var ijmmId:[String]?
    var groupData :[groupData]?
    var pdfPath : String?
    var equnm : String?
    var brand : String?
    var mno : String?
    var sno : String?
    var supplier : String?
    var expiryDate : String?
    var ecId : String?
    var manufactureDate : String?
    var purchaseDate : String?
    var rate : String?
    var egId : String?
    var isPart : String?
    var notes : String?
    var isBarcodeGenerate : String?
    var isParent : String?
    var expiry_dtf : String?
    var expiry_dtt : String?
    var extraField1 : String?
    var extraField2 : String?
    var isBillable: String?
    var isBillableChange : String?
    var reason :  String?
    var startDateTime :  String?
    var finishDateTime :  String?
    var isCallFromBackward : String?
    var desc : String?
    var attachment : String?
    var warrantyType : String?
    var warrantyValue : String?
    var warrantyStartDate : String?
    var techId : String?
    var rplacedEquId : String?
    var isEquReplaced : String?
    var servIntvalType : String?
    var servIntvalValue : String?
    var equStatus : String?
    var isCondition : String?
    var usrFor : String?
    var logType : String?
    var completionDetail :[LocationObject1]?
    var statusComment : String?
    var scheduleDisplayText : String?
    var partTempId : String?
    var isPartChild : String?
    var isPartParent : String?
    var conExtraField1Label : String?
    var conExtraField2Label : String?
    var conExtraField3Label : String?
    var conExtraField4Label : String?
    var extraField3 : String?
    var extraField4 : String?
    var apiCallFrom : String?
    var isFilterBy : String?
    var searchType : String?
    var srtType : String?
    var ltId : String?
    var equipmentbarcode: String?
    var tagArray : [[String : String]]?
    var isProformaInv : String?
}

class customData:Codable{
    
    var queId: String?
    var frmId : String?
    var type : String?
    var ans : [ansData]?
   
}

class ansData:Codable {
    var key: String?
    var value: String?
    
}


class newItemData: Codable {
    var itemId : String?
    var inm : String?
    var ides : String?
    var qty : String?
    var rate : String?
    var discount : String?
    var itype : String?
    var tax : [texDetail]?
    var isItemOrTitle: String?
    var amount: String?
    var hsncode : String?
    var pno : String?
    var unit : String?
    var taxamnt : String?
    var jtId : String?
    var supplierCost : String?
    var serialNo : String?
    var searchKey: String?
    var dataType : String?
    var isBillable: String?
    var isBillableChange : String?
    var warrantyType : String?
    var warrantyValue : String?
    var partTempId : String?
   var parentId : String?
}

class equArray: Codable {
    var equId : String?
    var equnm : String?
    var mno : String?
    var sno : String?
    var audId : String?
    var remark : String?
    var changeBy : String?
    var status : String?
    var updateData : String?
    var lat : String?
    var lng : String?
    var location : String?
    var contrid : String?
    var attachments:[AttechmentArry]?
}

class itemData: Codable {
    var itemId : String?
    var inm : String?
    var ides : String?
    var desc : String?
    var des : String?
    var jobId : String?
    var qty : String?
    var rate : String?
    var discount : String?
    var type : String?
    var isGroup : String?
    var tax : [taxData]?
    var hsncode : String?
    var pno : String?
    var unit : String?
    var taxamnt : String?
    var supplierCost : String?
    var jtId : String?
    var dataType: String?
    var isGrouped : String?
    var ijmmId : String?
    var itemType : String?
    var serialNo : String?
    var searchKey: String?
    var isBillable: String?
    var isBillableChange : String?
    var warrantyType : String?
    var warrantyValue : String?
    var equId : String?
    var isPartChild : String?
    var isPartParent : String?
}


class equipementData: Codable {
    var equId : String?
    var equnm : String?
    var mno : String?
    var sno : String?
    var audId : String?
    var remark : String?
    var changeBy : String?
    var status : String?
    var updateData : String?
    var lat : String?
    var lng : String?
    var location : String?
    var contrid : String?
    var equStatus : String?
    var attachments:[AttechmentArry]?
    
}

class taxData: Codable {
    var taxId : String?
    var rate : String?
    var txRate : String?
    var ijmmId : String?
    var tagId : String?
    var tnm : String?
    
}

class TagArr: Codable {
    var tagId : String?
    var tnm : String?
    init(tagId: String,tnm: String){
        self.tagId = tagId
        self.tnm = tnm
    }
}

class groupData: Codable {
    var gnm : String?
    var rate : String?
    var qty : String?
    var discount : String?
}


class jtIdParam: Codable {
    var jtId: String?
    var title: String?
    var labour: String?
    
}

class siteIdParam: Codable {
    var siteId: String?
    var title: String?
    // var labour: String?
}


class LocationObject : Codable {
    //{"btryStatus":"44","datetime":"1577466240","lat":"22.68455932000001","lng":"75.82566356000518"}
    var btryStatus : String?
    var dateTime : String?
    var lat : Double?
    var lng : Double?
    
    
    init(battery:String,dateTime : String, lat : Double, lng : Double ) {
        self.btryStatus = battery
        self.dateTime = dateTime
        self.lat = lat
        self.lng = lng
    }
}




