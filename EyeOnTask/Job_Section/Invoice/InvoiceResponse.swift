//
//  InvoiceResponse.swift
//  EyeOnTask
//
//  Created by Mac on 03/04/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation
class loginresponse: Codable {
    var Country: [InvoiceResponse]
    
}

class InvoiceResponse: Codable {
    var success: Bool?
    var message: String?
    var data: InvoiceDetailedData?
    var statusCode : String?
}

class InvoiceDetailedData: Codable {
    var invId : String?
    var parentId : String?
    var compId : String?
    var cltId : String?
    var jobId : String?
    var code : String?
    var nm : String?
    var inv_client_address : String?
    var pro : String?
    var discount : String?
    var total : String?
    var note : String?
    var pono : String?
    var invDate : String?
    var label : String?
    var paid : String?
    var invType : String?
    var duedate : String?
    var shipto : String?
    var createdate : String?
    var cur : String?
    var newItem : [newItemData]?
    var itemData : [DetailedItemData]?
    var shippingItem : [shiping]?
    var isShowInList : String?
    var curSym : String?
    var hsnCodeLable : String?
    var taxCalculationType : String?
    var disCalculationType : String?
    
}

class DetailedItemData: Codable {
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
  var tax : [texDetail]?
  var hsncode : String?
  var pno : String?
  var unit : String?
  var taxamnt : String?
  var jtId : String?
  var supplierCost : String?
  var serialNo  : String?
  var isBillable: String?
  var isBillableChange : String?
  var warrantyType : String?
  var warrantyValue : String?
  var equId : String?
  var partTempId : String?
  var parentId : String?
  var isPartChild : String?
  var isPartParent : String?
    
}
class  texDetail : Codable {
     var ijtmmId : String?
     var ijmmId : String?
     var taxId : String?
     var txRate : String?
     var rate : String?
     var label : String?
}

class shiping: Codable {
    var ijmmId : String?
    var itemId : String?
    var rate : String?
    var inm : String?
    var itype : String?
}

class addressRes: Codable {
    var nm : String?
    var adr : String?
    var city : String?
    var country : String?
    var mob : String?
    var gst : String?
}



struct ItemDic {
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
    var tax : [texDic]?
    var hsncode : String?
    var pno : String?
    var unit : String?
    var taxamnt : String?
    var jtId : String?
    var supplierCost : String?
    var dataType: String?
    var serialNo : String?
    var searchKey: String?
    var isBillable: String?
    var isBillableChange : String?
    var warrantyType : String?
    var warrantyValue : String?
    var equId : String?
    var partTempId : String?
    var parentId : String?
    
}

struct texDic  {
     var ijtmmId : String?
     var ijmmId : String?
     var taxId : String?
     var txRate : String?
     var rate : String?
     var label : String?
}

class Resp:Codable {
    var key : String?
    var value : String?
}
