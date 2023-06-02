//
//  AdminEquipmentListRes.swift
//  EyeOnTask
//
//  Created by Altab on 19/11/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation


class AdminEquipListResponse: Codable {
    var success: Bool?
    var message: String?
    var data: [AdminEquipListData]?
    var count: String?
    
}

//t.png","isDisable":"0","lastAuditLabel":"AUD-119","lastAuditDate":"1604071773","EquStatusOnAudit":"1038","lastAudit_id":"94478","lastJobLabel":"","lastJobDate":"","EquStatusOnJob":"","lastJob_id”:””},"count":"265"


class AdminEquipListData: Codable {
    var equId: String?
    var parentId: String?
    var equnm: String?
    var cltId: String?
   // var clt_name: String?
    var nm: String?
    var mno: String?
    var sno: String?
    var brand: String?
    var rate: String?
    var supId: String?
    var supplier: String?
    var notes: String?
    var expiryDate: String?
    var tempId: String?
    var manufactureDate: String?
    var purchaseDate: String?
    var barcode: String?
    var isusable: String?
    var barcodeImg: String?
    var adr: String?
    var city: String?
    var state: String?
    var ctry: String?
    var zip: String?
    var status: String?
    var type: String?
    var ecId: String?
    var egId: String?
    var ebId: String?
    var isdelete: String?
    var groupName: String?
    
    var image: String?
    var isDisable: String?
    var updateDate: String?
    var lastAuditLabel: String?
    var equStatusOnAudit: String?
    var lastAuditDate: String?
    var lastAudit_id: String?
    var lastJobLabel: String?
    var lastJobDate: String?
    var equStatusOnJob : String?
    var lastJob_id:String?
}


struct EquipListDataModel: Codable {
    var equId: String?
    var parentId: String?
    var equnm: String?
    var cltId: String?
   // var clt_name: String?
    var nm: String?
    var mno: String?
    var sno: String?
    var brand: String?
    var rate: String?
    var supId: String?
    var supplier: String?
    var notes: String?
    var expiryDate: String?
    //var tempId: String?
    var manufactureDate: String?
    var purchaseDate: String?
    var barcode: String?
    var isusable: String?
    var barcodeImg: String?
    var adr: String?
    var city: String?
    var state: String?
    var ctry: String?
    var zip: String?
    var status: String?
    var type: String?
    var ecId: String?
    var egId: String?
    var ebId: String?
    var isdelete: String?
    var groupName: String?
    
    var image: String?
    var isDisable: String?
    var updateDate: String?
    var lastAuditLabel: String?
    
    var lastAuditDate: String?
    var equStatusOnAudit: String?
    var lastAudit_id: String?
    var lastJobLabel: String?
    var lastJobDate: String?
    var equStatusOnJob : String?
    var lastJob_id:String?
    var usrManualDoc : String?




    
}
