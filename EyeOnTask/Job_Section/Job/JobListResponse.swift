//
//  JobListResponse.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 30/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation


class jobListResponse: Codable {
    var success: Bool?
    var message: String?
    var data: [jobListData]?
    var count: String?
    var statusCode: String?
}


class jobListData: Codable {
    var adr: String?
    var athr: String?
    var city: String?
    var cltId: String?
   // var clt_name: String?
    var cnm: String?
    var conId: String?
    var contrId: String?
    var createDate: String?
    var ctry: String?
    var des: String?
    var email: String?
    var inst: String?
    var jobId: String?
    var jtId: [jtIdArray]?
    var kpr: String?
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
    var tagData: [tagDataArray]?
    var twitter: String?
    var type: String?
    var updateDate: String?
    var zip: String?
    var isdelete: String?
    var tempId: String?
    var landmark: String?
    var complNote: String?
    var canInvoiceCreated: Int?
    var itemData : [DetailedItemData]?
    var equArray:[equipDataArray]?
    var recurData:[RecurDataArray]?
    var recurType:String?
    var attachCount: String?
    var signature: String?
    var locId : String?
    var quotLabel : String?
    var isJobInvoiced : String?
    var pono : String?
    var poId : String?
    var desWithoutHtml : String?
    var disCalculationType : String?
}

class RecurDataArray: Codable{
    var message: String?
    var transVar: TransVarData?
    init(message: String?,transVar: TransVarData?) {
        self.message = message
        self.transVar = transVar
    }
}

class TransVarData: Codable{
    var interval: String?
    var occurences: String?
    var occur_days: String?
    var mode: String?
    var endRecurMode: String?
    var startDate: String?
    var endDate: String?
    var single_or_multi : String?
    var week_num:String?
    var day_num:String?
    init(interval: String?,occurences: String?,occur_days: String?,mode: String?,endRecurMode: String?,startDate: String?,endDate: String?,single_or_multi:String?,week_num:String?,day_num:String?
    ) {
        self.interval = interval
        self.occurences = occurences
        self.occur_days = occur_days
        self.mode = mode
        self.endDate = endDate
        self.startDate = startDate
        self.single_or_multi = single_or_multi
        self.endRecurMode = endRecurMode
        self.week_num = week_num
        self.day_num = day_num
    }
 
}



class PurchaseOrderResp: Codable {
    var success: Bool?
    var message: String?
    var data: [PurchaseOrderData]?
    var count: String?
   // var statusCode: String?
}


class PurchaseOrderData: Codable {
    var poId: String?
    var poNum: String?
   
    
}




class jtIdArray: Codable {
    var jtId: String?
    var title: String?
}


class tagDataArray: Codable {
    var tagId: String?
    var tnm: String?
}

