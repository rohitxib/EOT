//
//  LinkEquipmentRes.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 06/04/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class LinkEquipmentRes: Codable {

    
    var success: Bool?
    var message: String?
    var data: [LinkEquipment]?
    var count: String?
    // var statusCode: String?
}


class LinkEquipment: Codable {
    var equId : String?
    var parentId : String?
    var cltId : String?
    var siteId : String?
    var equnm : String?
    var nm : String?
    var mno : String?
    var sno : String?
    var brand : String?
    var rate : String?
    var supId : String?
    var supplier : String?
    var notes : String?
    var expiryDate : String?
    var manufactureDate : String?
    var purchaseDate : String?
    var barcode : String?
    var isusable : String?
    var barcodeImg : String?
    var adr : String?
    var city : String?
    var state : String?
    var ctry : String?
    var status : String?
    var zip : String?
    var type : String?
    var ecId : String?
    var egId : String?
    var ebId : String?
    var isdelete : String?
    var groupName : String?
    var snm : String?
    var isPart : String?
    var image : String?
    var isDisable : String?
    var lastAuditLabel : String?
    var lastAuditDate : String?
    var equStatusOnAudit : String?
    var lastAudit_id : String?
    var lastJobLabel : String?
    var lastJobDate : String?
    var equStatusOnJob : String?
    var lastJob_id : String?
    var lastAssignUsr: [LastAssignUsr]
    var linkkey : [String]?
}


class LinkEquipmentForONlIneRes: Codable {

    
    var success: Bool?
    var message: String?
    var data: [equipDataArray]?
    var count: String?
    // var statusCode: String?
}


class LastAssignUsr: Codable {
    
    var usrId : String?
    var fnm : String?
    var lnm : String?
}

///


class AuditEquipmentRes: Codable {

    
    var success: Bool?
    var message: String?
    var data: [AuditEquipment]?
    var count: String?
    // var statusCode: String?
}


class AuditEquipment: Codable {
    var equId : String?
}



class ContractEquipmentRes: Codable {

    
    var success: Bool?
    var message: String?
    var data: [ContractEquipment]?
    var count: String?
    // var statusCode: String?
}


class ContractEquipment: Codable {
    var equId : String?
    var parentId : String?
    var isPart : String?
    var equnm : String?
    var mno : String?
    var sno : String?
    var brand : String?
    var status : String?
    var tariffRate : String?
    var expiryDate : String?
    var adr : String?
    var contrId : String?
    var rate : String?
    var qty : String?
    var unit : String?
    var des : String?
    var discount : String?
    var supplierCost : String?
    var taxamnt : String?
    var pno : String?
    var hsncode : String?
    var cemmId : String?
    var tax : [String]?
    var image : String?
    var isDisable : String?

}



//"equId": "545",
//"parentId": "0",
//"isPart": "0",
//"equnm": "Hand",
//"mno": "",
//"sno": "",
//"brand": "Dettol",
//"status": "2332",
//"tariffRate": "0.0000",
//"expiryDate": "",
//"adr": "91 91 Souttar Terrace Terrace",
//"contrId": "734",
//"rate": "0.0000",
//"qty": "1",
//"unit": "",
//"des": "",
//"discount": "",
//"supplierCost": "0.0000",
//"taxamnt": "0.0000",
//"pno": "",
//"hsncode": "",
//"cemmId": "3198",
//"tax": [],
//"image": "uploads\/equipmentImage\/equipment_default.png",
//"isDisable": "0"
