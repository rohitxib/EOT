//
//  AddJobRes.swift
//  EyeOnTask
//
//  Created by mac on 27/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class AddJobRes: Codable {
    var success: Bool?
    var message: String?
    var data: [AddJobResData]?
}

class AddJobResData: Codable {
    var jobId: String?
    var label: String?
    var schdlFinish: String?
    var schdlStart : String?
    var tagData : [TagData]?
}

class TagData: Codable {
    var tagId : String?
    var tnm : String?
}

class AddjobRes:Codable {
var success:Bool?
var message:String?
var data :dataDetail?


}

class dataDetail:Codable {
var kpr:String?
var cnm:String?
var snm:String?
var twitter:String?
var skype:String?
var fax:String?
var chatUser:[ChatUer]?
var lat:String?
var lng:String?
var tempId:String?
var jobId:String?
var schdlStart:String?
var schdlFinish:String?
var tagData:[[String : String]]?
var label:String?
var scheduleDisplayText:String?

}


class GetShiftListResp:Codable {
var success:Bool?
var message:String?
var data :[getUserLeaveData]?
}

class getUserLeaveData: Codable {
var shiftId:String?
var shiftNm:String?
var isDefault:String?
var shiftStartTime:String?
var shiftEndTime:String?
}

class ChatUer: Codable {
var usrId:String?
var isactive:String?
var usertype:String?
var fnm:String?
var lnm:String?
var img:String?

}

class AddAudRes: Codable {
    var success: Bool?
    var message: String?
    var data: [AddAudResData]?
}

class AddAudResData: Codable {
    var kpr: String?
    var cnm: String?
    var lat: String?
    var lng : String?
    var audId: String?
    var tempId: String?
    var label: String?
    var schdlFinish: String?
    var schdlStart : String?
    var tagData : [AudTagData]?
}

class AudTagData: Codable {
    var tagId : String?
    var tnm : String?
}
