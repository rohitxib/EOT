//
//  GenerateInvoice.swift
//  EyeOnTask
//
//  Created by Mac on 08/05/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

class CommonResponse : Codable {
    var success: Bool?
    var message: String?
    var statusCode: String?
}

class CommonResponsePdf : Codable {
    var success: Bool?
    var message: String?
    var data: ResponsePdf
}

class ResponsePdf : Codable {
    var path: String?
   // var dtf: String?
   // var usrId: String?
}

class LocationListResp : Codable {
    var success: Bool?
    var message: String?
      var data: [LocationList]
    var count: String?
}

class LocationList : Codable {
    var locId: String?
    var stateId: String?
    var location: String?
}
class CommonResponseTimesheetPdf : Codable {
    var success: Bool?
    var message: String?
    var data: TimesheetPdf
}

class TimesheetPdf : Codable {
    var path: String?
   
}
class CommonResponseLeave : Codable {
    var success: Bool?
    var message: String?
    var data: TimesheetPdf
}

class ResponseLeave : Codable {
    var success: Bool?
    var message: String?
    var data: [ResLeave]?
}

class ResLeave : Codable {
    var leaveId: String?
    var reason: String?
    var startDateTime: String?
    var finishDateTime: String?
    var note: String?
    var status: String?
    var leaveType: String?
   
}

class ResponseUserListLeave : Codable {
    var success: Bool?
    var message: String?
    var data: [UserListLeave]?
}

class UserListLeave : Codable {
    var ltId: String?
    var leaveType: String?

}


