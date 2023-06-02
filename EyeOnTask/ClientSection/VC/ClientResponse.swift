//
//  ClientResponse.swift
//  EyeOnTask
//
//  Created by mac on 05/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class ClientResponse: Codable {
    var success: Bool?
    var count: String?
    var data: [ClientListData]
    var message : String?
    var statusCode : String?
}

class ClientListData : Codable{
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
    var isdelete: String?
    var mob1: String?
    var mob2: String?
    var nm: String?
    var note: String?
    var pymtType: String?
    var siteId: String?
    var snm: String?
    var state: String?
    var tinNo: String?
    var lastcontsycTime: String?
    var lastSitesycTime: String?
    var tempId: String?
    var referral: String?
    var comp_name : String?
    var lat: String?
    var lng : String?
}

