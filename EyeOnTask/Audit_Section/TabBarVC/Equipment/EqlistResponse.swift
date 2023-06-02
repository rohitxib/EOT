//
//  EqlistResponse.swift
//  EyeOnTask
//
//  Created by Mojave on 15/11/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

class EqListResponse: Codable {
    var success: Bool?
    var message: String?
    var data: [EquipementListData]?
    var count: String?
    var statusCode: String?
}

class EquipementListData: Codable {
    //var equId : String?
    var equnm : String?
    var mno : String?
    var sno : String?
    var audId : String?
    var location : String?
    var remark : String?
    var changeBy : String?
    var status : String?
    var updateData : String?
    var createDate : String?
    var equId : String?
    var lat : String?
    var lng : String?
}


class getEquipmentStatusRes: Codable {
    var success: Bool?
    var message: String?
    var data: [getEquipmentStatusDate]?
    var count: String?
   
}

class getEquipmentStatusDate: Codable {
    
    var esId : String?
    var statusText : String?
    var updatedate : String?
    
}


// FOR JOB STATUS :-

class JobStatusListRes: Codable {
    var success: Bool?
    var message: String?
    var data: [JobStatusListResData]?
}

class JobStatusListResData: Codable {
    
    var jcsId : String?
    var id : String?
    var text : String?
    var des : String?
    var url : String?
    var pinUrl : String?
    var color : String?
    var createdate : String?
    var updatedate : String?
    var isDefault : String?
    var isStatusShow : String?
    var isFwSelect : String?
}
