//
//  AddClientResponse.swift
//  EyeOnTask
//
//  Created by mac on 14/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class AddClientResponse: Codable {
    var success: Bool?
    var count: String?
    var data: AddClientDetails
    var  message : String?
}


class AddClientTndstryResponse: Codable {
    var success: Bool?
    var count: String?
    var data: [IndClientDetails]
    var message : String?
}

class IndClientDetails : Codable{
   var industryId: String?
   var industryName: String?
   var isDefault: String?
}


class AddClientDetails : Codable{
    var accid: String?
    var acctype: String?
    var adr: String?
    var city: String?
    var cltId: String?
    var cnm: String?
    var conId: String?
    var ctry: String?
    var email: String?
    var gstNo: String?
    var industry: String?
    var isactive: String?
    var mob1: String?
    var mob2: String?
    var nm: String?
    var note: String?
    var pymtType: String?
    var siteId: String?
    var snm: String?
    var state: String?
    var tinNo: String?
    var referral: String?
   var comp_name : String?
    
}

class getReferenceListResponse: Codable {
    var success: Bool?
    var count: String?
    var data: [getReferenceListDetails]
   // var  message : String?
}

class getReferenceListDetails : Codable{
    var refName: String?
     var refId: String?
     var isDefault: String?
}



class getCompanySettingsResponse: Codable {
    var success: Bool?
    var count: String?
    var data: getCompanySettingsDetails
   // var  message : String?
}

class getCompanySettingsDetails : Codable{
    var city: String?
    var state: String?
    var ctry: String?
    var ctryCode: String?
    var gstNo: String?
    var gstLabel: String?
    var tinNo: String?
    var tinLabel: String?
  
}

//"city": "indore",
//        "state": "21",
//        "ctry": "101",
//        "ctryCode": "+91",
//
//    "gstNo": "100110",
//        "gstLabel": "GST No1",
//        "tinNo": "512455",
//        "tinLabel": "TIN No1",
