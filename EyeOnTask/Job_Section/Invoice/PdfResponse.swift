//
//  PdfResponse.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 02/05/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

class PdfResponse : Codable {
    var success: Bool?
    var message: String?
    var data: PdfData?
}

class PdfData: Codable {
    var path : String?
}

class JobCardTemplatesRs : Codable {
    var success: Bool?
    var message: String?
    var data: [JobCardTemplat]?
}

class JobCardTemplat: Codable {
    var tempJson1 : TempJsonData?
    var jcTempId : String?
}

class TempJsonData: Codable {
    var clientDetails : [InvDetailData]?
}

class InvDetailData: Codable {
    var inputValue : String?
}

class InvoiceTemplateRs : Codable {
    var success: Bool?
    var message: String?
    var data: [JobCardTemplat1]?
}

class JobCardTemplat1: Codable {
    var tempJson1 : TempJsonData1?
    var invTempId : String?
}

class TempJsonData1: Codable {
    var invDetail : [InvDetailData1]?
}

class InvDetailData1: Codable {
    var inputValue : String?
}

class QuotaTemplateRs : Codable {
    var success: Bool?
    var message: String?
    var data: [JobCardTemplat2]?
}

class JobCardTemplat2: Codable {
    var tempJson1 : TempJsonData2?
    var quoTempId : String?
}

class TempJsonData2: Codable {
    var quoDetail : [InvDetailData2]?
}

class InvDetailData2: Codable {
    var inputValue : String?
}

class getJobCompletionDetailRs: Codable {
    var success: Bool?
    var message: String?
    var data : [getJobCompletionDetailData]?
}

class getJobCompletionDetailData: Codable {
    
    var travel_loginTime : String?
    var tarvel_logoutTime : String?
    var loginTime : String?
    var logoutTime : String?
    var travel_pauseTime : String?
    var pauseTime : String?
    
}

