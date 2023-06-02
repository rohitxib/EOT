//
//  AuditListResponse.swift
//  EyeOnTask
//
//  Created by Mojave on 12/11/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

class AuditListResponse: Codable {
    var success: Bool?
    var message: String?
    var data: [AuditListData]?
    var count: String?
    var statusCode: String?
}


class AuditListData: Codable {
    var audId : String?
    var parentId : String?
    var label : String?
    var des : String?
    var type : String?
    var prty : String?
    var status : String?
    var kpr : String?
    var athr : String?
    var schdlStart : String?
    var schdlFinish : String?
    var inst : String?
    var cnm : String?
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
    var isdelete: String?
    var tempId: String?
    var tagData : [tagDataArray]?
    var equArray:[equipDataArray]?
    var auditType:String?
    var equCategory:[String]?
    var cltId:String?
    var conId:String?
    var contrId:String?
    var snm:String?
    var nm:String?
    var attachCount:String?
    
}

class equipDataArray: Codable {
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
    var type : String?
    var brand : String?
    var expiryDate : String?
    var manufactureDate : String?
    var purchaseDate : String?
    var barcode : String?
    var equipment_group : String?
    var image : String?
    var rate : String?
    var supId : String?
    var supplier : String?
    var cltId : String?
    var nm : String?
    var statusText : String?
    var category : String?
    var parentId : String?
    var ecId : String?
    var equComponent : [equComponant]?
    var notes : String?
    var isPart : String?
    var extraField1 : String?
    var extraField2 : String?
    var usrManualDoc : String?
    var snm : String?
    var datetime : String?
    var installedDate : String?
    var servIntvalType : String?
    var servIntvalValue : String?
    var equStatus : String?
    var statusUpdateDate : String?
    
    
    init(equId : String?,equnm : String?, mno : String?,sno : String?,audId : String?,remark : String?,changeBy : String?,status : String?,updateData : String?,lat : String?,lng : String?,location : String?,contrid : String? ,attachments:[AttechmentArry]?,type : String?,brand : String?,expiryDate : String?,manufactureDate : String?,purchaseDate : String?,barcode : String?,equipment_group : String?,image : String?,rate : String?,supId : String?,supplier : String?,cltId : String?,nm : String?,statusText : String?,category : String?,parentId : String?,ecId : String?,equComponent : [equComponant]? ,notes : String?,isPart : String? ,extraField1 : String?,extraField2 : String?,usrManualDoc : String?,snm : String?,datetime : String? ,installedDate : String?,servIntvalType : String? ,servIntvalValue : String?,equStatus : String? ,statusUpdateDate : String?){
        
        self.equId = equId
        self.equnm = equnm
        self.mno = mno
        self.sno = sno
        self.audId = audId
        self.remark = remark
        self.changeBy = changeBy
        self.status = status
        self.updateData = updateData
        self.lat = lat
        self.lng = lng
        self.location = location
        self.contrid = contrid
        self.attachments = attachments
        self.type = type
        self.brand = brand
        self.expiryDate = expiryDate
        self.manufactureDate = manufactureDate
        self.purchaseDate = purchaseDate
        self.barcode = barcode
        self.equipment_group = equipment_group
        self.image = image
        self.rate = rate
        self.supId = supId
        self.supplier = supplier
        self.cltId = cltId
        self.nm = nm
        self.statusText = statusText
        self.category = category
        self.parentId = parentId
        self.ecId = ecId
        self.equComponent = equComponent
        self.isPart = isPart
        self.usrManualDoc = usrManualDoc
        self.extraField1 = extraField1
        self.extraField2 = extraField2
        self.snm = snm
        self.datetime = datetime
        self.installedDate = installedDate
        self.servIntvalType = servIntvalType
        self.servIntvalValue = servIntvalValue
        self.equStatus = equStatus
        self.statusUpdateDate = statusUpdateDate
    }
}


class equComponant:Codable{
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
    var type : String?
    var brand : String?
    var expiryDate : String?
    var manufactureDate : String?
    var purchaseDate : String?
    var barcode : String?
    var equipment_group : String?
    var image : String?
    var rate : String?
    var supId : String?
    var supplier : String?
    var cltId : String?
    var nm : String?
    var statusText : String?
    var category : String?
    var parentId : String?
    var ecId : String?
    var notes : String?
    var isPart : String?
    var usrManualDoc : String?
    var extraField1 : String?
    var extraField2 : String?
    var snm : String?
    var datetime : String?
    var installedDate : String?
    var servIntvalType : String?
    var servIntvalValue : String?
    var equStatus : String?
    var statusUpdateDate : String?
    
    init(equId : String?,equnm : String?, mno : String?,sno : String?,audId : String?,remark : String?,changeBy : String?,status : String?,updateData : String?,lat : String?,lng : String?,location : String?,contrid : String?,type : String?, brand : String?,expiryDate : String?,manufactureDate : String?,purchaseDate : String?,barcode : String?,equipment_group : String?,image : String?,rate : String?,supId : String?,supplier : String?,cltId : String?,nm : String?,statusText : String?,category : String?,parentId : String?,ecId : String?,notes : String?, isPart : String?,usrManualDoc : String?,extraField1 : String? ,extraField2 : String?,snm : String?,datetime : String?,installedDate : String?,servIntvalType : String? ,servIntvalValue : String?,equStatus : String? ,statusUpdateDate : String?){
        
        self.equId = equId
        self.equnm = equnm
        self.mno = mno
        self.sno = sno
        self.audId = audId
        self.remark = remark
        self.changeBy = changeBy
        self.status = status
        self.updateData = updateData
        self.lat = lat
        self.lng = lng
        self.location = location
        self.contrid = contrid
      //  self.attachments:[AttechmentArry]?
        self.type = type
        self.brand = brand
        self.expiryDate = expiryDate
        self.manufactureDate = manufactureDate
        self.purchaseDate = purchaseDate
        self.barcode = barcode
        self.equipment_group = equipment_group
        self.image = image
        self.rate = rate
        self.supId = supId
        self.supplier = supplier
        self.cltId = cltId
        self.nm = nm
        self.statusText = statusText
        self.category = category
        self.parentId = parentId
        self.ecId = ecId
        self.notes = notes
        self.isPart = isPart
        self.usrManualDoc = usrManualDoc
        self.extraField1 = extraField1
        self.extraField2 = extraField2
        self.snm = snm
        self.datetime = datetime
        self.installedDate = installedDate
        self.servIntvalType = servIntvalType
        self.servIntvalValue = servIntvalValue
        self.equStatus = equStatus
        self.statusUpdateDate = statusUpdateDate
    }
    
}


class AttechmentArry: Codable {
    var attachmentId:String?
    var audId:String?
    var deleteTable:String?
    var image_name:String?
    var userId:String?
    var attachFileName:String?
    var attachThumnailFileName:String?
    var attachFileActualName:String?
    var docNm:String?
    var des:String?
    var createdate:String?
    init(attachmentId : String?,audId : String?, deleteTable : String?,image_name : String?,userId : String?,attachFileName : String?,attachThumnailFileName : String?,attachFileActualName : String?,docNm : String?,des : String?,createdate : String?){
        
        self.attachmentId = attachmentId
        self.audId = audId
        self.deleteTable = deleteTable
        self.image_name = image_name
        //self.audId = audId
        self.userId = userId
        self.attachFileName = attachFileName
        self.attachThumnailFileName = attachThumnailFileName
        self.attachFileActualName = attachFileActualName
        self.docNm = docNm
        self.des = des
        self.createdate = createdate
        
    }
    
}



class equipDataArrayNoRemark: Codable {
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
    var attachments:[AttechmentArryNoRemark]?
    var type : String?
    var brand : String?
    var expiryDate : String?
    var manufactureDate : String?
    var purchaseDate : String?
    var barcode : String?
    var equipment_group : String?
    var image : String?
    var rate : String?
    var supId : String?
    var supplier : String?
    var cltId : String?
    var nm : String?
    var statusText : String?
    var category : String?
    var parentId : String?
    var ecId : String?
    var equComponent : [equComponantNoRemark]?
    var notes : String?
    var isPart : String?
    var extraField1 : String?
    var extraField2 : String?
    var usrManualDoc : String?
    var snm : String?
    var datetime : String?
    var installedDate : String?
    var servIntvalType : String?
    var servIntvalValue : String?
    var equStatus : String?
    var statusUpdateDate : String?
    
    
    init(equId : String?,equnm : String?, mno : String?,sno : String?,audId : String?,remark : String?,changeBy : String?,status : String?,updateData : String?,lat : String?,lng : String?,location : String?,contrid : String? ,attachments:[AttechmentArryNoRemark]?,type : String?,brand : String?,expiryDate : String?,manufactureDate : String?,purchaseDate : String?,barcode : String?,equipment_group : String?,image : String?,rate : String?,supId : String?,supplier : String?,cltId : String?,nm : String?,statusText : String?,category : String?,parentId : String?,ecId : String?,equComponent : [equComponantNoRemark]? ,notes : String?,isPart : String? ,extraField1 : String?,extraField2 : String?,usrManualDoc : String?,snm : String?,datetime : String? ,installedDate : String?,servIntvalType : String? ,servIntvalValue : String?,equStatus : String? ,statusUpdateDate : String?){
        
        self.equId = equId
        self.equnm = equnm
        self.mno = mno
        self.sno = sno
        self.audId = audId
        self.remark = remark
        self.changeBy = changeBy
        self.status = status
        self.updateData = updateData
        self.lat = lat
        self.lng = lng
        self.location = location
        self.contrid = contrid
        self.attachments = attachments
        self.type = type
        self.brand = brand
        self.expiryDate = expiryDate
        self.manufactureDate = manufactureDate
        self.purchaseDate = purchaseDate
        self.barcode = barcode
        self.equipment_group = equipment_group
        self.image = image
        self.rate = rate
        self.supId = supId
        self.supplier = supplier
        self.cltId = cltId
        self.nm = nm
        self.statusText = statusText
        self.category = category
        self.parentId = parentId
        self.ecId = ecId
        self.equComponent = equComponent
        self.isPart = isPart
        self.usrManualDoc = usrManualDoc
        self.extraField1 = extraField1
        self.extraField2 = extraField2
        self.snm = snm
        self.datetime = datetime
        self.installedDate = installedDate
        self.servIntvalType = servIntvalType
        self.servIntvalValue = servIntvalValue
        self.equStatus = equStatus
        self.statusUpdateDate = statusUpdateDate
    }
}


class equComponantNoRemark:Codable{
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
    var attachments:[AttechmentArryNoRemark]?
    var type : String?
    var brand : String?
    var expiryDate : String?
    var manufactureDate : String?
    var purchaseDate : String?
    var barcode : String?
    var equipment_group : String?
    var image : String?
    var rate : String?
    var supId : String?
    var supplier : String?
    var cltId : String?
    var nm : String?
    var statusText : String?
    var category : String?
    var parentId : String?
    var ecId : String?
    var notes : String?
    var isPart : String?
    var usrManualDoc : String?
    var extraField1 : String?
    var extraField2 : String?
    var snm : String?
    var datetime : String?
    var installedDate : String?
    var servIntvalType : String?
    var servIntvalValue : String?
    var equStatus : String?
    var statusUpdateDate : String?
    
    init(equId : String?,equnm : String?, mno : String?,sno : String?,audId : String?,remark : String?,changeBy : String?,status : String?,updateData : String?,lat : String?,lng : String?,location : String?,contrid : String?,type : String?, brand : String?,expiryDate : String?,manufactureDate : String?,purchaseDate : String?,barcode : String?,equipment_group : String?,image : String?,rate : String?,supId : String?,supplier : String?,cltId : String?,nm : String?,statusText : String?,category : String?,parentId : String?,ecId : String?,notes : String?, isPart : String?,usrManualDoc : String?,extraField1 : String? ,extraField2 : String?,snm : String?,datetime : String?,installedDate : String?,servIntvalType : String? ,servIntvalValue : String?,equStatus : String? ,statusUpdateDate : String?){
        
        self.equId = equId
        self.equnm = equnm
        self.mno = mno
        self.sno = sno
        self.audId = audId
        self.remark = remark
        self.changeBy = changeBy
        self.status = status
        self.updateData = updateData
        self.lat = lat
        self.lng = lng
        self.location = location
        self.contrid = contrid
      //  self.attachments:[AttechmentArry]?
        self.type = type
        self.brand = brand
        self.expiryDate = expiryDate
        self.manufactureDate = manufactureDate
        self.purchaseDate = purchaseDate
        self.barcode = barcode
        self.equipment_group = equipment_group
        self.image = image
        self.rate = rate
        self.supId = supId
        self.supplier = supplier
        self.cltId = cltId
        self.nm = nm
        self.statusText = statusText
        self.category = category
        self.parentId = parentId
        self.ecId = ecId
        self.notes = notes
        self.isPart = isPart
        self.usrManualDoc = usrManualDoc
        self.extraField1 = extraField1
        self.extraField2 = extraField2
        self.snm = snm
        self.datetime = datetime
        self.installedDate = installedDate
        self.servIntvalType = servIntvalType
        self.servIntvalValue = servIntvalValue
        self.equStatus = equStatus
        self.statusUpdateDate = statusUpdateDate
    }
    
}


class AttechmentArryNoRemark: Codable {
    var attachmentId:String?
    var audId:String?
    var deleteTable:String?
    var image_name:String?
    var userId:String?
    var attachFileName:String?
    var attachThumnailFileName:String?
    var attachFileActualName:String?
    var docNm:String?
    var des:String?
    var createdate:String?
    init(attachmentId : String?,audId : String?, deleteTable : String?,image_name : String?,userId : String?,attachFileName : String?,attachThumnailFileName : String?,attachFileActualName : String?,docNm : String?,des : String?,createdate : String?){
        
        self.attachmentId = attachmentId
        self.audId = audId
        self.deleteTable = deleteTable
        self.image_name = image_name
        //self.audId = audId
        self.userId = userId
        self.attachFileName = attachFileName
        self.attachThumnailFileName = attachThumnailFileName
        self.attachFileActualName = attachFileActualName
        self.docNm = docNm
        self.des = des
        self.createdate = createdate
        
    }
    
}





//struct equipmentDic {
//   var equId : String?
//   var equnm : String?
//   var mno : String?
//   var sno : String?
//   var audId : String?
//   var remark : String?
//   var changeBy : String?
//   var status : String?
//   var updateData : String?
//   var lat : String?
//   var lng : String?
//   var location : String?
//   var contrid : String?
//}



class EquipModel: Codable {
    var success:Bool?
    var message:String?
    var data:[AttechmentArry]?
    var count : String?
    var statusCode  :String?
}

class barcodeAuditResponse: Codable {
    var success: Bool?
    var message: String?
    // var data: EquipementListData?
    var data : equipDataArray?
    var count: String?
    var statusCode: String?
}

class equipDataPartArray {
    var equeDic : equipDataArray?
    var equePartArr: [equipDataArray]?
    
    init(equId : equipDataArray?,equePartArr: [equipDataArray]?){
        
        self.equeDic = equId
        self.equePartArr = equePartArr
    }
}

class equipDataPartArrayNew {
    
    var equePartArr: [equipDataArray]?
    
    init(equePartArr: [equipDataArray]?){
        
        self.equePartArr = equePartArr
    }
}

class equipDataArrayItem {
    
    var equePartArrItme: [ItemDic]?
    
    init(equePartArrItme: [ItemDic]?){
        
        self.equePartArrItme = equePartArrItme
    }
}
