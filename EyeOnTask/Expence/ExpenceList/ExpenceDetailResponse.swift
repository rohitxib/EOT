//
//  ExpenceDetailResponse.swift
//  EyeOnTask
//
//  Created by Apple on 14/06/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation

class ExpenceDetailResponse: Codable {
     var success: Bool?
     var message: String?
     var data: ExpenceDetail?
}

class ExpenceDetail : Codable {
    var expId: String?
    var jobId: String?
    var cltId: String?
    var usrId: String?
    var name: String?
    var amt: String?
    var dateTime: String?
    var category: String?
    var tag: String?
    var status: String?
    var des: String?
    var jobCode: String?
    var cltName: String?
    var tagName: String?
    var username: String?
    var fnm: String?
    var lnm: String?
    var comment: String?
    var categoryName: String?
    var createdby: String?
    var receipt:[ExpenceRec]?
}

class ExpenceStatusResponse: Codable {
     var success: Bool?
     var message: String?
     var data: [ExpenceStatus]?
     var count: String?
}
class ExpenceStatus : Codable {
    var status: String?
    var changedby: String?
    var dateTime: String?
    var comment: String?
 
}

