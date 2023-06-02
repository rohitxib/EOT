//
//  EnumClass.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 30/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation


enum Entities : String , CaseIterable  {
    case ClientContactList = "ClientContactList"
    case ClientList = "ClientList"
    case ClientSitList = "ClientSitList"
    case FieldWorkerDetails = "FieldWorkerDetails"
    case OfflineList = "OfflineList"
    case UserAccType = "UserAccType"
    case UserJobList = "UserJobList"
    case UserJobTittleNm = "UserJobTittleNm"
    case ErrorsList = "ErrorsList"
    case TagsList = "TagsList"
    case Users = "Users"
    case AppointmentList = "AppointmentList"
    case AuditOfflineList = "AuditOfflineList"
}


//[1 - Not Started, 2 - Accepted, 3 - Reject , 4 - Cancel, 5 - Travelling, 6 - Break, 7 - In Progress , 8 - Pending, 9 - Completed and 10- Closed]
enum taskStatusType : Int , CaseIterable  {
    case New = 1
    case Accepted
    case Reject
    case Cancel
    case Travelling
    case Break
    case InProgress
    case JobBreak
    case Completed
    case Closed
    case Multi
    case OnHold
    case Start
    case Reschedule
    case Revisit

}


enum taskStatusTypeForDispatch : Int , CaseIterable  {
    case Dispatched = 1
    case Accepted
    case Reject
    case Cancel
    case Travelling
    case Break
    case InProgress
    case JobBreak
    case Completed
    case Closed
    case Multi
    case OnHold
    case Start
    case Reschedule
    case Revisit

}

enum taskStatusTypeAudit : Int , CaseIterable  {
    case New = 1
    case Accepted
    case Reject
    case Cancel
    case Travelling
    case Break
    case InProgress
    case OnHold
    case Completed
    case Closed
    case Multi
    case JobBreak
    case Start
    case Reschedule
    case Revisit
    
}


enum QuoteStatusType : Int , CaseIterable  {
    
    case New = 1
    case Approve = 2
    case Reject = 3
    case OnHold = 8
    case Sent = 9
    case RevisedRequest = 10

    
}

enum GPSstatus : Int , CaseIterable {
    case Still = 1
    case Walk = 2
    case Travel = 3
    case GPS_OFF = 4
    case DeviceGPS_Permission_Issue = 5
    case Admin_Permission_Issue = 6
    case Time_Expire = 7
    case App_killed_or_Internet_off = 8
    case logout = 9
}



enum ConditionType : Int , CaseIterable  {
    case Good = 1
    case Poor = 2
    case Replace = 3
    //1- Good, 2- Bad
}


//[1 - Low , 2 - Medium, 3 - High and 4 - Urgent]
enum taskPriorities : Int , CaseIterable  {
    case Low = 1
    case Medium
    case High
    //case Urgent
}
enum equipmentFilterStatus : Int , CaseIterable  {
    case RemarkAdd
    case NoRemarkAdd
    
}

enum expenceStatus : Int , CaseIterable  {
    case ClaimReimbuserment = 1
    case Approved
    case Reject
    case Paid
    case Open
}

enum expenceStatus1 : Int , CaseIterable  {
    case New = 1
    case Approved
    case Reject
  //  case Paid
   // case Open
}

enum taxType : Int , CaseIterable  {
    case DELAY = 1
    case WRITING_CHARGE
    case LOAD_TAX
    case SGST
    case GST
}

enum invoiceType : Int , CaseIterable  {
    case ITEM = 1
    case FIELDWORKER
    case SERVICE
}

enum CheckType : Int , CaseIterable  {
    case checkin = 1
    case checkout
}


enum permissions : String, CaseIterable {
    case isClientVisible = "isClientVisible"
    case isPaymentVisible = "isPaymentVisible"
    case isItemVisible = "isItemVisible"
    case isInvoiceVisible = "isInvoiceVisible"
    case isQuoteVisible = "isQuoteVisible"
    case isJobAddOrNot = "isJobAddOrNot"
    case isLandmarkEnable = "isLandmarkEnable"
    case isAuditVisible = "isAuditVisible"
    case isClientChatEnable = "isClientChatEnable"
    case isExpenseVisible = "isExpenseVisible"
    case isAppointmentVisible = "isAppointmentVisible"
    case isJobRevisitOrNot = "isJobRevisitOrNot"
    case isJobRescheduleOrNot = "isJobRescheduleOrNot"
    case isCustomFormEnable = "isCustomFormEnable"
    case isEquipmentEnable = "isEquipmentEnable"
    case isCustomFieldEnable = "isCustomFieldEnable"
    case isItemDeleteEnable = "isItemDeleteEnable"
    case isItemEditEnable = "isItemEditEnable"
    case isRecur = "isRecur"
    case equpExtraField1Label = "equpExtraField1Label"
    case equpExtraField2Label = "equpExtraField2Label"
    case isShowRejectStatus = "isShowRejectStatus"
    case isEquipmentAddEnable = "isEquipmentAddEnable"
    case is24hrFormatEnable = "is24hrFormatEnable"
    case ctryCode = "ctryCode"
    case isCheckInOutDownload = "isCheckInOutDownload"
    case isCheckInOutEnableMobile = "isCheckInOutEnableMobile"
    case isTimeSheetEnableMobile = "isTimeSheetEnableMobile"
    case isLocationEnable = "isLocationEnable"
    case isLeaveAddEnable = "isLeaveAddEnable"
    case shiftEndTime = "shiftEndTime"
    case isCheckInOutAttAdd = "isCheckInOutAttAdd"
    case isCheckInOutDescAdd = "isCheckInOutDescAdd"
    case isQuotStatusComtEnable = "isQuotStatusComtEnable"
    case isAddJobRecurEnable = "isAddJobRecurEnable"
    case isSchedular = "isSchedular"
    case isAddJobCustomFieldEnable = "isAddJobCustomFieldEnable"
    case isScheduleTextEnable = "isScheduleTextEnable"
    case conExtraField1Label = "conExtraField1Label"
    case conExtraField2Label = "conExtraField2Label"
    case conExtraField3Label = "conExtraField3Label"
    case conExtraField4Label = "conExtraField4Label"
    case checkInOutDuration = "checkInOutDuration"
    case isEmailLogEnable = "isEmailLogEnable"
    case isJobCrteWthDispatch = "isJobCrteWthDispatch"
    case isAutoTimeZone = "isAutoTimeZone"
    case loginUsrTz = "loginUsrTz"
    
}

//-------------------------------------------------------
// create by dharmendra gour on 20/03/2021

enum daySelectType : Int , CaseIterable  {
    case Monday = 1
    case Tuesday
    case Wednesday
    case Thuresday
    case Friday
    case Saturday
    case Sunday
    
}

enum weekSelectType : Int , CaseIterable  {
    case First = 1
    case Second
    case Third
    case Fourth
    case Last
    
}

//var Cash = LanguageKey.cash
//var Cheque = LanguageKey.cheque
//var CreditCardre = LanguageKey.credit_card
//var DebitCard  = LanguageKey.cr_debt_card
//var WireTransfer  = LanguageKey.wire_transfer
//var Paypal  = LanguageKey.paypal
//var Stripe  = LanguageKey.stripe


struct PaymentType {
    static let Cash = (name:"\(LanguageKey.cash)" , value:1)
    static let Cheque =  (name:"\(LanguageKey.cheque)" , value:2)
    static let CreditCard =  (name:"\( LanguageKey.credit_card)" , value:3)
    static let DebitCard =  (name:"\( LanguageKey.Debit_card)" , value:4)
    static let WireTransfer =  (name:"\( LanguageKey.wire_transfer)" , value:5)
    static let Paypal =  (name:"\(LanguageKey.paypal)" , value:6)
   // static let DirectDeposit =  (name:"Direct Deposit" , value:7)
    static let Stripe =  (name:"\(LanguageKey.stripe)" , value:8)
}


enum DateRange : String, CaseIterable {
    
  //  ["Today","Yesterday","Last 7 Days","Last 30 Days","This Month","Last Month","Custom Range"]
    //[.Today, .Yesterday, .Last7Days, .Last30Days, .ThisMonth, .LastMonth, .CustomRange]
    case Today = "Today"
    case Yesterday = "Yesterday"
    case Last7Days = "Last 7 Days"
    case Last30Days = "Last 30 Days"
    case ThisMonth = "This Month"
    case LastMonth = "Last Month"
    case CustomRange = "Custom Range"
}

enum compPermission : String, CaseIterable {
    case moduleId = "moduleId"
    case description = "description"
    case discount = "discount"
    case rate = "rate"
    case tax = "tax"
    case amount = "amount"
    case hsncode = "hsncode"
    case unit = "unit"
    case taxamnt = "taxamnt"
    case pno = "pno"
    case shipto = "shipto"
    case isItemEnable = "isItemEnable"
    case supplierCost = "supplierCost"
    case serialNo = "serialNo"
    case equpHistory = "equpHistory"
    case cltWorkHistory = "cltWorkHistory"
    case isJcSignEnable = "isJcSignEnable"
    case isEquipmentAddEnable = "isEquipmentAddEnable"
    case isJobCardEnableMobile = "isJobCardEnableMobile"
    case isCheckInOutDownload = "isCheckInOutDownload"
    case isTimeSheetEnableMobile = "isTimeSheetEnableMobile"
    case isLocationEnable = "isLocationEnable"
    case isQuoteNoShowOnJob = "isQuoteNoShowOnJob"
    case isQuoteNoShowOnAppointment = "isQuoteNoShowOnAppointment"
    case isRateIncludingTax = "isRateIncludingTax"
    case isAutoCheckoutEnable = "isAutoCheckoutEnable"
    case isCompNmShowMobile = "isCompNmShowMobile"
    case isCompAdrShowFirstMobile = "isCompAdrShowFirstMobile"
    case isEditJobAndTravelTime = "isEditJobAndTravelTime"
    
    
   
}

//module name -> 1-login, 2-client, 3-site, 4-contact, 5-job, 6-quaotation, 7-user, 8-contract, 9-item, 10-inventory, 11-logout, 12-invoice, 13-audit, 14-equipment, 15-dashboard, 16-schedular, 17-map, 18-reports, 19-setting, 20-project
enum Modules : String, CaseIterable {
    case login = "1"
    case client = "2"
    case site = "3"
    case contact = "4"
    case job = "5"
    case quaotation = "6"
    case user = "7"
    case contract = "8"
    case item = "9"
    case inventory = "10"
    case logout = "11"
    case invoice = "12"
    case audit = "13"
    case equipment = "14"
    case dashboard = "15"
    case schedular = "16"
    case map = "17"
    case reports = "18"
    case setting = "19"
    case project = "20"

}

//==============================
// MARK:- Get Task Status Image
//==============================
func taskStatus(taskType : taskStatusType) -> (String, UIImage, UIImage){
    switch taskType {
    case .JobBreak:
        return ( "JobBreak Task",UIImage(named: "job_break")!,UIImage(named: "whiteJobBreak_Task")!)
    case .New:
        return ( "New Task",UIImage(named: "New_Task")!,UIImage(named: "whiteNew_Task")!)
    case .Accepted:
        return ( "Accepted Task",UIImage(named: "Accepted_task")!,UIImage(named: "white_Accepted")!)
    case .Reject:
        return ( "Reject Task",UIImage(named: "Rejected_task")!,UIImage(named: "whiteRejected")!)
    case .Cancel:
        return ( "Cancel Task",UIImage(named: "cancel_task")!,UIImage(named: "whitecancel")!)
    case .Travelling:
        return ( "Travelling Task",UIImage(named: "Travelling_task")!,UIImage(named: "whiteTravelling")!)
    case .Break:
        return ( "Break Task",UIImage(named: "break_task")!,UIImage(named: "whitebreak")!)
    case .InProgress:
        return ( "In Progress Task",UIImage(named: "In_progress_task")!,UIImage(named: "inprogress_white")!)
    case .OnHold:
        return ( "On Hold Task",UIImage(named: "Pending_task")!,UIImage(named: "whitePendng")!)
    case .Completed:
        return ( "Completed Task",UIImage(named: "Complete_task")!,UIImage(named: "whiteComplete")!)
    case .Closed:
        return ( "Closed Task",UIImage(named: "closed_task")!,UIImage(named: "whiteclosed")!)
    default :
        return ( "Multi Task",UIImage(named: "Multi_task")!,UIImage(named: "whiteMulti_task")!)
    }
}


func taskStatusForDispatch(taskType : taskStatusTypeForDispatch) -> (String, UIImage, UIImage){
    switch taskType {
    case .JobBreak:
        return ( LanguageKey.job_break,UIImage(named: "job_break")!,UIImage(named: "whiteJobBreak_Task")!)
    case .Dispatched:
        return ( LanguageKey.dispatch,UIImage(named: "New_Task")!,UIImage(named: "whiteNew_Task")!)
    case .Accepted:
        return ( LanguageKey.accepted,UIImage(named: "Accepted_task")!,UIImage(named: "white_Accepted")!)
    case .Reject:
        return ( LanguageKey.reject,UIImage(named: "Rejected_task")!,UIImage(named: "whiteRejected")!)
    case .Cancel:
        return ( LanguageKey.cancel,UIImage(named: "cancel_task")!,UIImage(named: "whitecancel")!)
    case .Travelling:
        return ( LanguageKey.travelling,UIImage(named: "Travelling_task")!,UIImage(named: "whiteTravelling")!)
    case .Break:
        return ( LanguageKey.breaks,UIImage(named: "break_task")!,UIImage(named: "whitebreak")!)
    case .InProgress:
        return ( LanguageKey.In_progress,UIImage(named: "In_progress_task")!,UIImage(named: "inprogress_white")!)
    case .OnHold:
        return ( LanguageKey.new_on_hold,UIImage(named: "Pending_task")!,UIImage(named: "whitePendng")!)
    case .Completed:
        return ( LanguageKey.completed,UIImage(named: "Complete_task")!,UIImage(named: "whiteComplete")!)
    case .Closed:
        return ( LanguageKey.close,UIImage(named: "closed_task")!,UIImage(named: "whiteclosed")!)
    default :
        return (LanguageKey.multi_status,UIImage(named: "Multi_task")!,UIImage(named: "whiteMulti_task")!)
    }
}

func taskStatusAudit(taskType : taskStatusTypeAudit) -> (String, UIImage, UIImage){
    switch taskType {
    case .JobBreak:
        return ( "JobBreak Task",UIImage(named: "job_break")!,UIImage(named: "whiteJobBreak_Task")!)
    case .New:
        return ( "New Task",UIImage(named: "New_Task")!,UIImage(named: "whiteNew_Task")!)
    case .Accepted:
        return ( "Accepted Task",UIImage(named: "Accepted_task")!,UIImage(named: "white_Accepted")!)
    case .Reject:
        return ( "Reject Task",UIImage(named: "Rejected_task")!,UIImage(named: "whiteRejected")!)
    case .Cancel:
        return ( "Cancel Task",UIImage(named: "cancel_task")!,UIImage(named: "whitecancel")!)
    case .Travelling:
        return ( "Travelling Task",UIImage(named: "Travelling_task")!,UIImage(named: "whiteTravelling")!)
    case .Break:
        return ( "Break Task",UIImage(named: "break_task")!,UIImage(named: "whitebreak")!)
    case .InProgress:
        return ( "In Progress Task",UIImage(named: "In_progress_task")!,UIImage(named: "inprogress_white")!)
    case .OnHold:
        return ( "On Hold Task",UIImage(named: "Pending_task")!,UIImage(named: "whitePendng")!)
    case .Completed:
        return ( "Completed Task",UIImage(named: "Complete_task")!,UIImage(named: "whiteComplete")!)
    case .Closed:
        return ( "Closed Task",UIImage(named: "closed_task")!,UIImage(named: "whiteclosed")!)
    default :
        return ( "Multi Task",UIImage(named: "Multi_task")!,UIImage(named: "whiteMulti_task")!)
    }
}

func quoteStatus(taskType : QuoteStatusType) -> (String, UIImage){
    switch taskType {
    case .New:
        return ( "New",UIImage(named: "New_Task")!)
    case .Reject:
        return ( "Reject",UIImage(named: "Rejected_task")!)
    case .OnHold:
        return ( "On Hold",UIImage(named: "Pending_task")!)
    case .Approve:
        return ( "Approve",UIImage(named: "Accepted_task")!)
    case .Sent:
        return ( "Sent",UIImage(named: "Sent")!)
    default:
        return ( "Revised Request",UIImage(named: "Revised-request")!)
    }
}

func expenceStatusDetails(taskType : expenceStatus) -> (String, UIImage, UIImage){
    switch taskType {
    case .ClaimReimbuserment:
       return ( "Claim Reimbuserment",UIImage(named: "Claim reimbusement_50")!,UIImage(named: "Claim reimbusement_50")!)
          case .Approved:
              return ( "Approved",UIImage(named: "Complete_task")!,UIImage(named: "whiteComplete")!)
          case .Reject:
              return ( "Reject",UIImage(named: "Reject")!,UIImage(named: "whiteRejected")!)
          case .Paid:
              return ( "Paid",UIImage(named: "Paid")!,UIImage(named: "whitePendng")!)
          default:
              return ( "Open",UIImage(named: "Open")!,UIImage(named: "Openw")!)

    }
}

func expenceStatusDetails1(taskType : expenceStatus1) -> (String, UIImage, UIImage){
    switch taskType {
    case .New:
        return ( "New",UIImage(named: "New_Task")!,UIImage(named: "Claim reimbusement_50")!)
    case .Approved:
        return ( "Approved",UIImage(named: "Complete_task")!,UIImage(named: "whiteComplete")!)
    default:
        return ( "Reject",UIImage(named: "Reject")!,UIImage(named: "whiteRejected")!)
         
    }
}


func equipmentFilter(taskType : equipmentFilterStatus) -> (String, UIImage, UIImage){
    switch taskType {

    case .RemarkAdd:
        return ( LanguageKey.remarked,UIImage(named: "New_Task")!,UIImage(named: "whiteNew_Task")!)
    default:
        return ( LanguageKey.unremarked,UIImage(named: "New_Task")!,UIImage(named: "whiteNew_Task")!)
         
    }
}


//================================
// MARK:- Get Task Priority Image
//================================
func taskPriorityImage(Priority : taskPriorities) -> (String, UIImage){
    switch Priority {
    case .Low:
        return ("Low",UIImage(named: "status_low")!)
    case .Medium:
        return ("Medium",UIImage(named: "status_medium")!)
    default:
        return ("High",UIImage(named: "status_high")!)
    }
}

//enum taskStatusTypes : String , CaseIterable  {
//    case New = ""
//    case Accepted = "Accepted"
//    case Reject
//    case Cancel
//    case Travelling
//    case Break
//    case InProgress
//    case JobBreak = "Job Break"
//    case Completed
//    case Closed
//    case Multi
//    case OnHold
//    case Start
//    case Reschedule
//    case Revisit
//
//}
//
