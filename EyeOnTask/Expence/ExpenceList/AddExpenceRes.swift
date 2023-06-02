//
//  AddExpenceRes.swift
//  EyeOnTask
//
//  Created by Apple on 14/06/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation


class AddExpenceRes: Codable {
     var success: Bool?
     var message: String?
     var data: [AddExpence]?
}


class AddExpence: Codable {
     var expId: String?
     var jobId: String?
     var cltId: String?
     var name : String?
     var amt: String?
     var dateTime: String?
     var category : String?
     var tag: String?
     var status: String?
     var des : String?
     var receipt:[ExpenceRec]?
}

class ExpenceRec: Codable {
    
      var receipt : String?
      var erId : String?
}

class getCategoryRes: Codable {
     var success: Bool?
     var message: String?
     var data: [AddExpence]?

}

class getCategoryRs: Codable {
     var success: Bool?
     var message: String?
     var data: [AddExpencee]?
     var count: String?

}

class AddExpencee: Codable {
      var ecId: String?
      var name:String?

}

class addClientRs: Codable {
     var success: Bool?
     var message: String?
     var data: addClient1?
    

}
class addClient1: Codable {
      var cltId: String?
      var nm:  String?

}


class gettagRs: Codable {
     var success: Bool?
     var message: String?
     var data: [AddExpenceeTag]?
     var count: String?

}

class AddExpenceeTag: Codable {
      var etId: String?
      var name:String?

}
class UpdateItemQuantity: Codable {
     var success: Bool?
     var message: String?
     var data: [ItemQuantity]?
   

}


class ItemQuantity: Codable {
      var ijmmId: String?
      var qty:String?

}

class EquGroupListg: Codable {
     var success: Bool?
     var message: String?
     var data: [EquGroupLists]?
     var count: String?

}
// {success: true, data: [{ebId: "19", name: "sony"}], count: "1"}
class EquGroupLists: Codable {
      var egId: String?
      var equ_group:String?

}
class EquBrangListg: Codable {
     var success: Bool?
     var message: String?
     var data: [EquBrandLists]?
     var count: String?

}

class EquBrandLists: Codable {
      var ebId: String?
      var name:String?
      var  supId : String?
      var  supName:  String?

}

class EquCltListg: Codable {
     var success: Bool?
     var message: String?
     var data: [EquCltLists]?
     var count: String?

}

class EquCltLists: Codable {
      var ecId: String?
      var equ_cate:String?

}



class getSupplierListRes: Codable {
     var success: Bool?
     var message: String?
     var data: [getSupplierListData]?
     var count: String?

}

class getSupplierListData: Codable {
      var supId: String?
      var supName:String?
     

}

