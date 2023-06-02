//
//  AppointmentListRes.swift
//  EyeOnTask
//
//  Created by Altab on 11/07/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation

class AppointmentListRes: Codable {
     var success: Bool?
     var message: String?
     var data: [AppointmentListData]?
      var statusCode : String?
     var count: String?
}


class AppointmentListData: Codable {
    var appId: String?
    var adr: String?
    var athr: String?
    var city: String?
    var cltId: String?
    var cnm: String?
    var conId: String?
    var createDate: String?
    var ctry: String?
    var des: String?
    var email: String?
    var inst: String?
    var commonId: String?
    var kpr: [KprData]?
    var label: String?
    var lat: String?
    var lng: String?
    var mob1: String?
    var mob2: String?
    var nm: String?
    var parentId: String?
    var prty: String?
    var quotId: String?
    var schdlFinish: String?
    var schdlStart: String?
    var siteId: String?
    var skype: String?
    var snm: String?
    var state: String?
    var status: String?
    var twitter: String?
    var type: String?
    var updateDate: String?
    var zip: String?
    var isdelete: String?
    var tempId: String?
    var landmark: String?
    var complNote: String?
    var compid : String?
    var JobType: String?
    var quotLabel: String?
    var attachments: String?
//        var adr: String?
//        var athr: String?
//        var city: String?
//        var cltId: String?
//        var cnm: String?
//        var conId: String?
//        var createDate: String?
//        var ctry: String?
//        var des: String?
//        var email: String?
//        var inst: String?
//        var appId: String?
//        var kpr: [KprData]?
//        var label: String?
//        var lat: String?
//        var lng: String?
//        var mob1: String?
//        var mob2: String?
//        var nm: String?
//        var parentId: String?
//        var prty: String?
//        var quotId: String?
//        var schdlFinish: String?
//        var schdlStart: String?
//        var siteId: String?
//        var skype: String?
//        var snm: String?
//        var state: String?
//        var status: String?
//        var twitter: String?
//        var type: String?
//        var updateDate: String?
//        var zip: String?
//        var isdelete: String?
//        var tempId: String?
//        var landmark: String?
//        var complNote: String?
//        var compid : String?
//        var quotLabel: String?
}


class KprData: Codable {
    var usrId : String?
    var status : String?
}


struct CommanListDataModel {
        var adr: String?
        var athr: String?
        var city: String?
        var cltId: String?
        var cnm: String?
        var conId: String?
        var createDate: String?
        var ctry: String?
        var des: String?
        var email: String?
        var inst: String?
        var commonId: String?
        var kpr: [KprData]?
        var label: String?
        var lat: String?
        var lng: String?
        var mob1: String?
        var mob2: String?
        var nm: String?
        var parentId: String?
        var prty: String?
        var quotId: String?
        var schdlFinish: String?
        var schdlStart: String?
        var siteId: String?
        var skype: String?
        var snm: String?
        var state: String?
        var status: String?
        var twitter: String?
        var type: String?
        var updateDate: String?
        var zip: String?
        var isdelete: String?
        var tempId: String?
        var landmark: String?
        var complNote: String?
        var compid : String?
        var JobType: String?
        var quotLabel: String?
        var attachments: String?
        var itemData: String?
        var equArray: String?
   // var itemData :DetailedItemDataForApp?
   // var equArray:equipDataArrayForApp?
    
}

class DetailedItemDataForApp: Codable {
 
    var itemId : String?
    var inm : String?
    
    init(itemId: String?,inm: String?) {
        self.itemId = itemId
        self.inm = inm

    }
}
class equipDataArrayForApp: Codable {
    var equId : String?
    var equnm : String?
    
    init(equId: String?,equnm: String?) {
        self.equId = equId
        self.equnm = equnm

    }
}

