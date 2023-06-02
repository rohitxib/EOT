//
//  ItemGetListRes.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 21/08/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation



class ItemGetListRes: Codable {
    var success: Bool?
    var message: String?
    var data: [itemListInfo]?
    var groupData:[String]?
    var count: String?
}

class itemListInfo: Codable {
    var itemId: String?
    var inm: String?
    var ijmmId: String?
    var pno: String?
    var groupId: String?
    var rate: String?
    var discount: String?
    var qty: String?
    var itemType: String?
    var dataType: String?
    var des: String?
    var taxamnt: String?
    var jtId: String?
    var hsncode: String?
    var unit: String?
    var supplierCost : String?
    var tax : [tax]?
    var isBillable: String?
    var isBillableChange : String?
    var warrantyType : String?
    var warrantyValue : String?
    var partTempId : String?
    var parentId : String?
    var serialNo : String?//jug11
   
    
}


class ItemGetListResList: Codable {
    var success: Bool?
    var message: String?
    var data: [itemListInfoList]?
    var count: String?
}



class itemListInfoList: Codable {
   
    var inm: String?
    var rate: String?
    var qty: String?
  
}
