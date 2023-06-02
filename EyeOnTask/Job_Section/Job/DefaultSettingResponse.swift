
//
//  CompanySettingResponse.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 03/05/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

class DefaultSettingResponse: Codable {
    var success: Bool?
    var message: String?
    var data: DefaultSettings?

}

class DefaultSettings: Codable {
    var rights :  [[String:Int]]?
    var code: String?
    var sub: String?
    var des: String?
    var type: String?
    var isGpsEnable: String?
    var usr_compid: String?
    var duration: String?
    var jobCurrentTime: String?
    var jobSchedule: String?
    var isFWgpsEnable: String?
    var trkDuration: String?
    var trkDistance: String?
    var adminIds : [String]?
    var expireStatus: Int?
    var ispaid: String?
    var isHideContact: String?
    var isHideTravelBtn : String?
    var isCustomerEnable: String?
    var lngFileName: String?
    var lat: String?
    var lng: String?
    var comp_permission : [[String:String]]?
    var language : selectedLanguageDetails?
    var languageList : [languageDetails]?
    var forceupdate_version : String?
    var version : String?
    var checkId : String?
    var isJobLatLngEnable : String?
    var numAfterDecimal : String?
    var isLandmarkEnable : String?
    var staticJobId : String?
    var isClientChatEnable : String?
    var isOnetoOneChatEnable : String?
    var trkStartingHour : String?
    var trkEndingHour : String?
    var isActivityLogEnable : String?
    var isExpenseVisible : String?
    var isAppointmentVisible : String?
    var isJobRescheduleOrNot : String?
    var isJobRevisitOrNot : String?
    var isExpenseEnable : String?
    var isSupplierEnable : String?
    var isPurchaseOrderEnable : String?
    var isAppointmentEnable : String?
    var taxCalculationType : String?
    var hsnCodeLable : String?
    var isCustomFormEnable : String?
    var isEquipmentEnable : String?
    var isCustomFieldEnable : String?
    var footerMenu : [footerMenuDetail]?
    var conExtraField1Label : String?
    var conExtraField2Label : String?
    var isContractEnable : String?
    var isFooterMenuEnable : String?
    var isEmailLogEnable : String?
    var isJobItemQuantityFormEnable : String?
    var equipmentStatus:[EquipmentStatus]
    var isItemDeleteEnable : String?
    var isItemEditEnable :String?
    var isRecur : String?
    var equpExtraField1Label : String?
    var equpExtraField2Label : String?
    var isShowRejectStatus : String?
    var isEquipmentAddEnable : String?
    var is24hrFormatEnable : String?
    var ctryCode : String?
    var isCheckInOutDownload : String?
    var isCheckInOutEnableMobile : String?
    var isTimeSheetEnableMobile : String?
    var isLocationEnable : String?
    var confirmationTrigger : [String]?
    var isLeaveAddEnable : String?
    var shiftEndTime : String?
    var isCheckInOutDescAdd : String?
    var isCheckInOutAttAdd : String?
    var disCalculationType : String?
    var isQuotStatusComtEnable : String?
    var isSchedular : String?
    var isAddJobCustomFieldEnable : String?
    var isAddJobRecurEnable:String?
    var isScheduleTextEnable:String?
    var checkInOutDuration : String?
    var conExtraField3Label:String?
    var conExtraField4Label:String?
    var isJobCrteWthDispatch:String?
    var isAutoTimeZone:String?
    var loginUsrTz:String?
    var lastCheckIn:String?
    var locId:String?
}

class EquipmentStatus: Codable{
    var esId : String?
    var statusText : String?
    var updatedate : String?
    var isDefault : String?
    
}

class footerMenuDetail: Codable {
       var menuField : String?
       var odrNo : String?
       var isEnable : String?
}

class selectedLanguageDetails: Codable {
    var fileName : String?
    var filePath : String?
    var isLock : String?
    var isDefault : String?
    var version : String?
}

class languageDetails: Codable {
    var fileName : String?
    var filePath : String?
    var lngId : String?
    var nativeName : String?
    var version : String?
}

class ActivitiLog: Codable {
    var module :String?
    var device: String?
    var msg: String?
}
