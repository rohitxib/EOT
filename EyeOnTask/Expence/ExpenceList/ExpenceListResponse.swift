//
//  ExpenceListResponse.swift
//  EyeOnTask
//
//  Created by Hemant's mac on 08/05/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation

class ExpenceListResponse: Codable {
     var success: Bool?
     var message: String?
     var data: [Expence]?
     var count : String?
}


class Expence: Codable {
     var expId: String?
     var name: String?
     var amt: String?
     var dateTime : String?
     var category: String?
     var tag: String?
     var status: String?
     var des : String?
}



class getAllEquipmentItemsRes: Codable {
     var success: Bool?
     var message: String?
     var data: [AllEquipmentItemsData]?
     var count : String?
}

class AllEquipmentItemsData: Codable {
    var ijmmId : String?
    var itemId : String?
    var jobId : String?
    var groupId : String?
    var type : String?
    var des : String?
    var itype : String?
    var label : String?
    var inm : String?
    var qty : String?
    var rate : String?
    var discount : String?
    var amount : String?
   // var tax : [texDic]?
    var hsncode : String?
    var pno : String?
    var unit : String?
    var taxamnt : String?
    var jtId : String?
    var supplierCost : String?
    var dataType: String?
    var serialNo  : String?
    var searchKey: String?
    var isBillable: String?
    var isBillableChange : String?
    var warrantyType : String?
    var warrantyValue : String?

}


//{"success":true,"message":"data_found","data":[{"ijmmId":"66454","itemId":"9503","groupId":"0","dataType":"1","rate":"0.0000","qty":"1","discount":"0.00","inm":"new1581","des":"","itemType":"1","hsncode":"","pno":"","unit":"","taxamnt":"0.0000","supplierCost":"0.0000","jtId":"0","serialNo":"","itemConvertCount":"0","isBillableChange":"1","parentId":"0","isLabourParent":"","labourTempId":"","taxType":"0","orderNo":"0","warrantyType":"0","warrantyValue":"","isLabourChild":"","tax":[{"ijtmmId":"62728","ijmmId":"66454","taxId":"74","rate":"0.00","label":"sgst indore","taxComponents":[]},{"ijtmmId":"62729","ijmmId":"66454","taxId":"76","rate":"0.00","label":"south tax","taxComponents":[{"taxId":"79","label":"tax1","percentage":"10"},{"taxId":"80","label":"tax2","percentage":"8"}]},{"ijtmmId":"62730","ijmmId":"66454","taxId":"69","rate":"0.00","label":"Tax01","taxComponents":[{"taxId":"70","label":"tax01","percentage":"10"},{"taxId":"71","label":"tax02","percentage":"15"}]},{"ijtmmId":"62731","ijmmId":"66454","taxId":"81","rate":"0.00","label":"a1","taxComponents":[]},{"ijtmmId":"62732","ijmmId":"66454","taxId":"73","rate":"0.00","label":"TAX11","taxComponents":[]},{"ijtmmId":"62733","ijmmId":"66454","taxId":"75","rate":"0.00","label":"sgst bang","taxComponents":[]}],"isBillable":"1","displayOnJob":0}],"groupData":[]}
