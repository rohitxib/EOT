//
//  Service.swift
//  EyeOnTask
//
//  Created by Apple on 18/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

var errorString : String = ""
var testerUser = true
var TEST_USER_NAME = "john1"
var errorCount = 0
func mainUrl() -> String {
    
    
    //====================================================================
    // MARK:- FOR STSGING - TEST URL :-
    //====================================================================
    
    //let baseUrl : String = "https://staging.eyeontask.com/eotServices/"
    
    //====================================================================
    // MARK:- FOR LIVE URL :-
    //====================================================================
    
    let  baseUrl = "https://www.eyeontask.com/eotServices/"
   
    
    //====================================================================
    // MARK:- FOR 103 - TEST URL :-
    //====================================================================
    
    //let baseUrl : String = "http://192.168.88.2:8435/eotServices/"
    
    
    return baseUrl
}

func setTesterUser() {
    testerUser = true
}

func setLiveUser() {
    testerUser = false
}

public  class Service {
    
    //==============
    //Base URL
    //===============
    
    //Error String
    static var BaseUrl : String = mainUrl()
    
    //==============
    //Services
    //==============
    
    static let signin : String = "AuthenticationController/mobileLogin" //"AuthenticationController/login"
    static let errorUpload : String = "AuthenticationController/errorLogMail"
    static let forgotPassword : String = "AuthenticationController/forgotPassword"
    static let forgotPasswordKey: String = "AuthenticationController/forgotPasswordKey"
    static let changePassword : String = "UserController/changePassword"
    static let forgotPasswordReset : String = "AuthenticationController/forgotPasswordReset"
    
    // static let getApiUrl : String = "RedisController/getApiUrl"
    static let  getApiUrl = "AuthenticationController/getApiUrl"
    static let  getMobileDefaultSettings = "AuthenticationController/getMobileDefaultSettings"
    static let  addCompany = "AuthenticationController/addCompany"
    static let  verifyEmail = "AuthenticationController/verifyEmail"
    static let  verifyCompanyCode = "AuthenticationController/verifyCompanyCode"
    static let  resendVerificationCode = "AuthenticationController/resendVerificationCode"
    static let  setCompanyDefaultSetting = "CompanyController/setCompanyDefaultSetting"
    // static let  login = "AuthenticationController/login"
    
    //Audit section API's
    static let getAuditEquipmentList : String = "AssetsController/getAuditEquipmentList"
    static let getupdateAuditEquipment = "AssetsController/updateAuditEquipment"
    static let getAuditList : String = "AssetsController/getAuditUserList"
    static let uploadAuditDocument : String = "AssetsController/uploadAuditDocument"
    static let getAuditAttachments : String = "AssetsController/getAuditAttachmentApi"
    static let addAuditFeedback : String = "AssetsController/addAuditReport"
    static let addAudit : String = "AssetsController/addAudit"
    static let generateBarcodeUsingGivenCode : String = "AssetsController/generateBarcodeUsingGivenCode"
    static let changeAuditStatus : String = "AssetsController/changeAuditStatus"
    
    
    //Job section API's
    static let getUserJobListNew : String = "JobController/getUserJobListNew"
    static let getEquipmentList : String = "AssetsController/getEquipmentList"
    static let getJobList : String = "JobController/getUserJobList"
    static let addJob : String = "JobController/addJob"
    static let getJobTitleList : String = "JobController/getJobTitleList"
    static let changeJobStatus : String = "JobController/changeJobStatus"
    static let addFeedback : String = "JobController/addJobFeedback"
    static let JobStatusHistory : String = "JobController/getJobStatusHistoryMobile"
    static let jobTagList : String = "JobController/getTagList"
    static let setCompletionNotes : String = "jobController/setCompletionNotes"
    static let getSubscriptionData : String = "companyController/getSubscriptionData"
    static let updateJobSchedule : String = "JobController/updateJobSchedule"
    static let getFormDetail : String = "JobController/getFormDetail"
    static let addEquipment : String = "AssetsController/addLinkEquFromMob"
    static let contractSynch : String = "ContractController/contractSynch"
    static let sendJobCardEmailTemplate : String = "JobController/sendJobCardEmailTemplate"
    static let getJobCardEmailTemplate : String = "JobController/getJobCardEmailTemplate"
    static let getEquAuditSchedule : String = "AssetsController/getEquAuditSchedule"
    static let getAuditDetail : String = "AssetsController/getAuditDetail"
    static let getJobDetail : String = "JobController/getJobDetail"
    static let getAdminJobList : String = "JobController/getAdminJobList"
    static let getAuditAdminList : String = "AssetsController/getAuditAdminList"
    static let getAppointmentAdminList : String = "LeadController/getAppointmentAdminList"
    static let getAppointmentDetail : String = "LeadController/getAppointmentDetail"
    static let addAuditEquipment : String = "AssetsController/addAuditEquipment"
    static let getContractEquipmentList : String = "ContractController/getContractEquipmentList"
    static let uploadEquUsrManualDoc : String = "AssetsController/uploadEquUsrManualDoc"
    static let uploadJobCardSign : String = "jobController/uploadJobCardSign"
    static let deleteDocument : String = "JobController/deleteDocument"
    static let getShiftList : String = "CompanyController/getShiftList"
    static let getJobCardTemplates : String = "JobController/getJobCardTemplates"
    static let getInvoiceTemplates : String =  "InvoiceController/getInvoiceTemplates"
    static let getQuotaTemplates : String =  "QuotationController/getQuotaTemplates"
    static let getEquipmentStatus : String =  "AssetsController/getEquipmentStatus"
    static let getAllEquipmentItems : String =  "JobController/getAllEquipmentItems"
    static let addEquipmentUsingItem : String =  "AssetsController/addEquipmentUsingItem"
    static let getJobStatusList : String =  "jobController/getJobStatusList"
    
    
    //Client section API's
    static let getClientSink : String = "CompanyController/getClientSink"
    static let getFieldWorkerList : String = "UserController/getFieldWorkerList"
    static let getAccType : String = "CompanyController/getCompanyAccountTypeList"
    static let addClient : String = "CompanyController/addClient"
    static let getClientContactSink : String = "CompanyController/getClientContactSink"
    static let updateClientContact : String = "CompanyController/updateClientContact"
    static let getClientSiteSink : String = "CompanyController/getClientSiteSink"
    static let updateClientSite : String = "CompanyController/updateClientSite"
    static let updateClient : String = "CompanyController/updateClient"
    static let addClientSite : String = "CompanyController/addClientSite"
    static let addClientContact : String = "CompanyController/addClientContact"
    static let logout : String = "UserController/logout"
    
    //GroupChat section API's
    static let groupUserListForChat : String = "UserController/groupUserListForChat"
    
    //CustomForm
    static let getCustomFormNmList : String = "JobController/getFormList"
    static let getQuestionsByParentId: String = "JobController/getQuestionsByParentId"
    static let addAnswer: String = "JobController/addAnswer"
    static let addSignatureAndDoc: String = "JobController/addAnswerWithAttachment"
    
    //Documents
    static let getDocumentsList : String = "JobController/getJobAttachments"
    static let uploadDocument : String = "JobController/uploadDocument"
    static let updateDocument : String = "JobController/updateJobDocument"
    
    // Location Update
    static let getLocationUpdate : String = "UserController/addFWlatlong"
    static let postMultipleLocationUpdate : String = "UserController/addFWlatlong2"
    static let sendPushNotification : String = "UserController/sendNotificationToUser"
    static let getEquBrandList : String = "AssetsController/getEquBrandList"
    static let sendNotificationToCpClient : String = "UserController/sendNotificationToCpClient"
    
    
    // Invoice  InvoiceController/updateInvoice
    static let getItemParts : String = "InvoiceController/getItemParts"
    static let getInvoiceDetail : String = "InvoiceController/getInvoiceDetail"
    static let getItemsList : String = "InvoiceController/getItemList"
    static let updateInvoice : String = "InvoiceController/updateInvoice"
    static let addInvoice : String = "InvoiceController/addInvoice"
    static let getTaxList : String = "CompanyController/getTaxList"
    static let invoicePaymentRecieve : String = "InvoiceController/invoicePaymentRecieve"
    static let sendInvoiceEmailTemplate : String = "InvoiceController/sendInvoiceEmailTemplate"
    static let getInvoiceEmailTemplate : String = "InvoiceController/getInvoiceEmailTemplate"
    static let generateInvoicePDF : String = "InvoiceController/generateInvoicePDF"
    static let getCompanySettings : String = "CompanyController/getCompanySettingDetails"
    static let generateInvoice : String = "InvoiceController/generateInvoice"
    static let addCheckInOutIime : String = "UserController/addCheckInOutIime"
    static let deleteItemFromJob : String = "JobController/deleteItemFromJob"
    static let addItemOnJob : String = "JobController/addItemOnJob"
    static let updateItemInJobMobile : String = "JobController/updateItemInJobMobile"
    static let getItemFromJob : String = "JobController/getItemFromJob"
    static let updateResourceOnJob : String = "jobController/updateResourceOnJob"
    static let getInvoiceDetailMobile : String = "InvoiceController/getInvoiceDetailMobile"
    static let updateItemQuantity : String = "JobController/updateItemQuantity"
    static let addInvoiceForMobile : String = "InvoiceController/addInvoiceForMobile"
    
    //Quotation
    static let getAdminQuoteList : String = "QuotationController/getAdminQuoteList"
    static let getQuoteDetailForMobile : String  = "QuotationController/getQuoteDetailForMobile"
    static let addUpdateQuotationForMobile : String  = "QuotationController/addUpdateQuotationForMobile"
    static let addQuotItemForMobile : String  = "QuotationController/addQuotItemForMobile"
    static let convertQuotationToJob : String  = "QuotationController/convertQuotationToJob"
    static let getQuotationEmailTemplate : String = "QuotationController/getQuotationEmailTemplate"
    static let sendQuotationEmailTemplate : String = "QuotationController/sendQuotationEmailTemplate"
    static let generateQuotPDF : String = "QuotationController/generateQuotPDF"
    static let updateQuotItemForMobile : String = "QuotationController/updateQuotItemForMobile"
    static let deleteQuotItemForMobile : String = "QuotationController/deleteQuotItemForMobile"
    static let getEquipmentInfoByBarcode : String = "AssetsController/getEquipmentInfoByBarcode"
    static let getQuatSetting : String = "CompanyController/getQuatSetting"
    
    //One to One chat
    static let uploadChatDocument : String = "UserController/uploadChatDocument"
    
    // User activity log api
    static let insertActivityLog : String = "UserController/insertActivityLog"
    
    //Expence module
    
    static let getEquGroupList : String = "AssetsController/getEquGroupList"
    static let getEquCategoryList : String = "AssetsController/getEquCategoryList"
    static let getCategoryList : String = "ExpenseController/getCategoryList"
    static let addExpense : String = "ExpenseController/addExpense"
    static let getExpenseList : String = "ExpenseController/getExpenseList"
    static let getExpenseDetail : String = "ExpenseController/getExpenseDetail"
    static let updateExpense : String = "ExpenseController/updateExpense"
    static let getExpenseStatus : String = "ExpenseController/getExpenseStatus"
    static let getExpenseTagList : String = "ExpenseController/getExpenseTagList"
    static let deleteExpenseReceipt : String = "ExpenseController/deleteExpenseReceipt"
    
    // Add Appoiment
    static let addAppointment : String = "LeadController/addAppointment"
    static let getAppoinmentList : String = "LeadController/getAppointmentUserList"
    static let uploadAppointmentDocument : String = "LeadController/updateAppointment"
    static let getAppointmentDocument : String = "LeadController/getAppointmentDetail"
    static let updateAppointment : String = "LeadController/updateAppointment"
    static let getIndustryList : String = "CompanyController/getIndustryList"
    static let uploadAppmtDocument : String = "LeadController/uploadAppmtDocument"
    static let generateJobDocumentPDF : String = "JobController/generateJobDocumentPDF"
    static let getJobDocEmailTemplate : String = "JobController/getJobDocEmailTemplate"
    static let sendJobDocEmailTemplate : String = "JobController/sendJobDocEmailTemplate"
    static let generateJobCardPDF : String = "JobController/generateJobCardPDF"
    
    // Recur Api section
    static let DailyJobRecurrenceResult : String = "RecurController/DailyJobRecurrenceResult"
    static let weeklyJobRecurrenceResult : String = "RecurController/weeklyJobRecurrenceResult"
    static let MonthlyjobRecurrenceResult : String = "RecurController/MonthlyjobRecurrenceResult"
    static let deleteRecur : String = "RecurController/deleteRecur"
    
    // Download PDF
    static let generateCheckInOutPDF : String = "UserController/generateCheckInOutPDF"
    static let generateUserTimesheetPDF : String = "UserController/generateUserTimesheetPDF"
    
    // getLocationList Text UserController/generateUserTimesheetPDF
    static let getLocationList : String = "CompanyController/getLocationList"
    static let getReferenceList : String = "CompanyController/getReferenceList"
    
    // Leave
    static let addLeave : String = "UserController/addLeave"
    static let getUserLeaveList : String = "UserController/getUserLeaveList"
    static let getPurchaseOrderList : String = "PurchaseOrderController/getPurchaseOrderList"
    static let getLeaveTypeList : String = "UserController/getLeaveTypeList"
    
    // Complation Detail
    static let getJobCompletionDetail : String = "JobController/getJobCompletionDetailForIos"//"JobController/getJobCompletionDetail"
    static let addCompletionDetail : String = "JobController/addCompletionDetail"
    static let getSupplierList : String = "SupplierController/getSupplierList"
    
    
}

//====================
//Post Sevice method
//====================

func serverCommunicator(url:String , param:Dictionary<String, Any>?,callBack : @escaping (Any?, Bool) -> Void) {
    guard let url1 = URL(string: Service.BaseUrl+url) else { return }
    
    if DebugModePrint() {
        
        //==========================================================================================================
        //  MARK:- FOR API name chack :- //j
        //==========================================================================================================
       // print(url1)
        //==========================================================================================================
        
    }
    
    if isHaveNetowork() {
        
        var request = URLRequest(url: url1)
        request.httpMethod = "POST"
        request.addValue("appli cation/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
            }else{
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")
                
            }
        }
        //request.addValue("https://us1.eyeontask.com", forHTTPHeaderField: "Origin")
        let origne = url1.host
        request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
        request.timeoutInterval = 80
        
        if param != nil {
            request.httpBody =  try? JSONSerialization.data(withJSONObject: param!)
        }
        
        callRequest(request: request, callBack: callBack) // Send request to CallRequest method
        
    }else{
        killLoader()
    
            errorString = AlertMessage.checkNetwork
       
        //increaseErrorCount(callBack: callBack, data: nil)
        callBack(nil , false)
    }
}

func callRequest(request : URLRequest, callBack : @escaping (Any?, Bool) -> Void) -> Void {
    //Call Request and Handle data, response and error
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        guard error == nil else {
            errorString = (error?.localizedDescription)!
            increaseErrorCount(callBack: callBack, data: data)
            return
        }
        
        guard let data = data else {
            errorString = AlertMessage.formatProblem
            increaseErrorCount(callBack: callBack, data: nil)
            return
        }
        
        
        if DebugModePrint() {
            //Data convert in string for check actual response (Use this code if use die on server)
            let returnData = String(data: data, encoding: .utf8)
            
            
            //========================================================================================================
            // MARK:- FOR CHECK API RESPONCE ON CONCOL SCREEN :- //j
            //========================================================================================================
            
            //  print("Result == \(returnData ?? "")")
            
            //========================================================================================================
            
        }
        
        
        do {
            guard let anyObj = (try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]) else {
                print("Could not get JSON from response as Dictionary")
                increaseErrorCount(callBack: callBack, data: nil)
                return
            }
            
            if  (anyObj )["statusCode"] != nil && ((anyObj )["statusCode"] as! String == "401"){
                killLoader()
                ShowAlert(title: getServerMsgFromLanguageJson(key: ((anyObj )["message"] as! String)), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                    if (Ok){
                        if errorCount > 0 {
                            errorCount = 0
                        }
                        navigateToLoginPage()
                    }
                })
                return
            }
            
            
            if errorCount > 0 {
                errorCount = 0
            }
            
            callBack(data , true)
        } catch {
            errorString = AlertMessage.formatProblem
            increaseErrorCount(callBack: callBack, data: nil)
            //callBack(data , false)
        }
    }
    task.resume()
}


//=====================================
//Post Sevice method with IMAGE UPLOAD
//=====================================
func serverCommunicatorUplaodImageInArray( url:String, param:Dictionary<String, Any>?,images:[UIImage]?, imagePath:String, callBack : @escaping (Any?, Bool) -> Void){
    
    if isHaveNetowork() {
        var body = Data()
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        
        if let paramDict = param {
            for (key, value) in paramDict {
                body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
        
        
        if let imageArray = images {
            if imageArray.count > 0 {
                for image in imageArray {
                    var imageData : Data?
                    imageData = image.jpegData(compressionQuality: 0.5)
                    
                    if (imageData != nil) {
                        body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                        body.append(Data("Content-Disposition: form-data; name=\"\(imagePath)\"; filename=\"imageAp.jpeg\"\r\n".utf8))
                        body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
                        body.append(imageData!)
                        body.append(Data("\r\n".utf8))
                    }
                    body.append(Data("--\(BoundaryConstant)--\r\n".utf8))
                }
            }
        }
        
        
        
        
        //Request for Service
        guard let url1 = URL(string: Service.BaseUrl+url) else { return }
        
        //        if DebugModePrint() {
        //            print(url1)
        //        }
        
        var request = URLRequest(url: url1)
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
            }else{
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")
                
            }
        }
        let origne = url1.host
        request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
        
        callRequest(request: request, callBack: callBack) // Send request to CallRequest method
    }else{
        killLoader()
        errorString = AlertMessage.checkNetwork
        callBack(nil , false)
    }
}


func serverCommunicatorUplaodImageAppoiment( url:String, param:Dictionary<String, Any>?,images:Data?, imagePath:String , docUrl: String?, callBack : @escaping (Any?, Bool) -> Void){
    
    if isHaveNetowork() {
        var body = Data()
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        var dict = Data()
        if let paramDict = param {
            for (key, value) in paramDict {
                
                
                if key == "memIds" {
                    if let str:[String] = value as? [String]{
                        // to convert [String] to data
                        dict = Data(buffer: UnsafeBufferPointer(start: str, count: str.count))
                        // to retrive [String] from data
                        let arr2 = dict.withUnsafeBytes {
                            Array(UnsafeBufferPointer<String>(start: $0, count: dict.count/MemoryLayout<String>.stride))
                        }
                        //jprint(arr2)//jj
                        body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                        body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                        body.append(Data("\(arr2)\r\n".utf8))
                    }
                }
                else {
                    body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                    body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                    body.append(Data("\(value)\r\n".utf8))
                }
            }
        }
        
      
        guard let url1 = URL(string: Service.BaseUrl+url) else { return }
     
        var request = URLRequest(url: url1)
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
            }else{
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")
                
            }
        }
        let origne = url1.host
        request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
        
        callRequest(request: request, callBack: callBack) // Send request to CallRequest method
    }else{
        killLoader()
        errorString = AlertMessage.checkNetwork
        callBack(nil , false)
    }
}

//========================================================
//Post Sevice method with IMAGE UPLOAD uploadJobCardSign
//========================================================
func serverCommunicatorUplaodJobCardSignImage( url:String, param:Dictionary<String, Any>?,image:UIImage?, imagePath:String, imageName: String, callBack : @escaping (Any?, Bool) -> Void){
    
    if isHaveNetowork() {
        var body = Data()
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        
        
        if let paramDict = param {
            for (key, value) in paramDict {
                body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
        
        
        
        //Convert Image to Data formate
        if image != nil {
            var imageData : Data?
            if let img = image{
                imageData = img.jpegData(compressionQuality: 0.5)
            }
            
            if (imageData != nil) {
                body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(imagePath)\"; filename=\"\(imageName).png\"\r\n".utf8))
                body.append(Data("Content-Type: image/png\r\n\r\n".utf8))
                body.append(imageData!)
                body.append(Data("\r\n".utf8))
            }
            body.append(Data("--\(BoundaryConstant)--\r\n".utf8))
        }
        
        //Request for Service
        guard let url1 = URL(string: Service.BaseUrl+url) else { return }
        
        //        if DebugModePrint() {
        //            print(url1)
        //        }
        
        var request = URLRequest(url: url1)
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
            }else{
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")
                
            }
        }
        let origne = url1.host
        request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
        
        callRequest(request: request, callBack: callBack) // Send request to CallRequest method
    }else{
        killLoader()
        errorString = AlertMessage.checkNetwork
        callBack(nil , false)
    }
}

//=====================================
//Post Sevice method with IMAGE UPLOAD
//=====================================
func serverCommunicatorUplaodImage( url:String, param:Dictionary<String, Any>?,image:UIImage?, imagePath:String, imageName: String, callBack : @escaping (Any?, Bool) -> Void){
    
    if isHaveNetowork() {
        var body = Data()
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        
        
        if let paramDict = param {
            for (key, value) in paramDict {
                body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
        
        
        //Convert Image to Data formate
        if image != nil {
            var imageData : Data?
            if let img = image{
                imageData = img.jpegData(compressionQuality: 0.5)
            }
            
            if (imageData != nil) {
                body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(imagePath)\"; filename=\"\(imageName).jpeg\"\r\n".utf8))
                body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
                body.append(imageData!)
                body.append(Data("\r\n".utf8))
            }
            body.append(Data("--\(BoundaryConstant)--\r\n".utf8))
        }
        
        //Request for Service
        guard let url1 = URL(string: Service.BaseUrl+url) else { return }
        
        var request = URLRequest(url: url1)
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
            }else{
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")
                
            }
        }
            let origne = url1.host
            request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
        
        callRequest(request: request, callBack: callBack) // Send request to CallRequest method
    }else{
        killLoader()
        errorString = AlertMessage.checkNetwork
        callBack(nil , false)
    }
}
//*****created  by rohit
func serverCommunicatorUplaodSignatureAndAttachmen( url:String, param:Dictionary<String, Any>?,imageSig:UIImage?,imageAtchmnt:UIImage?, signaturePath:String,atchmntPath:String,callBack : @escaping (Any?, Bool) -> Void){
    
    if isHaveNetowork() {
        let boundary = UUID().uuidString //"----------V2ymHFg03ehbqgZCaKO6jy"
        guard let url1 = URL(string: Service.BaseUrl+url) else { return }
        let origne = url1.host
        var request = URLRequest(url: url1)
        request.httpMethod = "POST"
        request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
            }else{
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")
                
            }
        }
        request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //
        var data = Data()
        if param != nil{
            for(key, value) in param!{
                data.append("--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                if key == "answer"{
                    do {//param!["answer"]
                        let ansDatatry = try JSONSerialization.data(withJSONObject: value , options: JSONSerialization.WritingOptions())
                        data.append(ansDatatry)
                        data.append(Data("\r\n".utf8))
                    } catch let error {
                       // print("error while creating post request -> \(error.localizedDescription)")
                    }
                }else{
                    data.append("\(value)\r\n".data(using: .utf8)!)
                }
            }
            data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        }
       
        var images = [Data]()
        if imageSig != nil  {
            if let img = imageSig, let data = img.jpegData(compressionQuality: 0.5) {
                images.append(data)
            }
        }
        if imageAtchmnt != nil, imageAtchmnt != nil  {
            if let img = imageAtchmnt, let data = img.jpegData(compressionQuality: 0.5) {
                images.append(data)
            }
        }

        for (index,imdata) in images.enumerated() {
        
            if index == 0 {
                data.append("--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(signaturePath)\"; filename=\"IMG_0001.png\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                data.append(imdata)
                data.append(Data("\r\n".utf8))
            } else {
                data.append("--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(atchmntPath)\"; filename=\"image_1675862695353.png\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                data.append(imdata)
                data.append(Data("\r\n".utf8))
            }
        }
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = data
        callRequest(request: request, callBack: callBack) // Send request to CallRequest method
    }else{
        killLoader()
        errorString = AlertMessage.checkNetwork
        callBack(nil , false)
    }
}
//
//MARK:- MultipleImages upload created by Rohit -
func serverCommunicatorUplaodSignatureAndAttachment(stringUrl:String, method:String,parameters:[String:Any]?,imageSig:[ImageModel]?,imageAtchmnt:[ImageModel]?, signaturePath:String,atchmntPath:String, completion: @escaping(Data?, Error?, Bool)->Void) {
    // boundary setup
    let boundary = "----------V2ymHFg03ehbqgZCaKO6jy"
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    guard let url = URL(string: Service.BaseUrl+stringUrl) else { return }
    let origne = url.host
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
    request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
        }else{
            let loginUsrTz = getDefaultSettings()?.loginUsrTz
            request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")

        }
    }
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
// parameter encoding
    var data = Data()
    if parameters != nil{
        for(key, value) in parameters!{
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            if key == "answer"{
                do {
                    let ansDatatry = try JSONSerialization.data(withJSONObject: value , options: JSONSerialization.WritingOptions())
                    data.append(ansDatatry)
                    data.append(Data("\r\n".utf8))
                } catch let error {
                    print("error while creating post request -> \(error.localizedDescription)")
                }
            }else{
                data.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
    }

    
    if let imageArray = imageSig {
        if imageArray.count > 0 {
            for (index,image) in imageArray.enumerated() {
                var imageData : Data?
                imageData = image.img!.jpegData(compressionQuality: 0.5)
                let imageFileName = "signature_\(index).png"
                
                if (imageData != nil) {
                   
                               data.append("--\(boundary)\r\n".data(using: .utf8)!)
                                data.append("Content-Disposition: form-data; name=\"\(signaturePath)\"; filename=\"\(imageFileName)\"\r\n".data(using: .utf8)!)
                                data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                               data.append(imageData!)
                                data.append(Data("\r\n".utf8))
                }
            }
        }
    }
    if let imageArray = imageAtchmnt {
        if imageArray.count > 0 {
            for (index,image) in imageArray.enumerated() {
                var imageData : Data?
                imageData = image.img!.jpegData(compressionQuality: 0.5)
                let imageFileName = "attachment_\(index).png"
                
                if (imageData != nil) {
                   
                               data.append("--\(boundary)\r\n".data(using: .utf8)!)
                                data.append("Content-Disposition: form-data; name=\"\(atchmntPath)\"; filename=\"\(imageFileName)\"\r\n".data(using: .utf8)!)
                                data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                               data.append(imageData!)
                                data.append(Data("\r\n".utf8))
                }
            }
        }
    }
    
    data.append("--\(boundary)--\r\n".data(using: .utf8)!)
    session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
        if let checkResponse = response as? HTTPURLResponse{
            if checkResponse.statusCode == 200 {
                print(String(data: data!, encoding: .utf8))
                guard let data = data, let jes1 = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments]) else {
                    completion(nil, error, false)
                    return
                }
                print(String(data: data, encoding: .utf8))
                completion(data, nil, true)
            } else {
                guard let data = data, let _ = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    completion(nil, error, false)
                    return
                }
                completion(data, nil, false)
            }
        } else {
            guard let data = data, let _ = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completion(nil, error, false)
                if let checkResponse = response as? HTTPURLResponse{
                }
                return
            }
            completion(data, nil, false)
        }
    }).resume()
}


// created by dharmendra -


func serverCommunicatorUplaodImageInArrayForInputField( url:String, param:Dictionary<String, Any>?,images:[ImageModel]?, imagePath:String, callBack : @escaping (Any?, Bool) -> Void){
    
    if isHaveNetowork() {
        var body = Data()
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        
        if let paramDict = param {
            for (key, value) in paramDict {
                body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
        
        
        if let imageArray = images {
            if imageArray.count > 0 {
                for (index,image) in imageArray.enumerated() {
                    var imageData : Data?
                    imageData = image.img!.jpegData(compressionQuality: 0.5)
                    //                let fullName: String = image.id!
                    //                   let fullNameArr = fullName.components(separatedBy: "_image_")
                    //                print(fullNameArr)
                    print(image.id!)
                    let imageFileName = "jobAttSeq_\(index).png"
                    if (imageData != nil) {
                        body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                        body.append(Data("Content-Disposition: form-data; name=\"\(imagePath)\"; filename=\"\(imageFileName)\"\r\n".utf8))
                        body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
                        body.append(imageData!)
                        body.append(Data("\r\n".utf8))
                    }
                    body.append(Data("--\(BoundaryConstant)--\r\n".utf8))
                }
            }
        }
        
        
        
        
        //Request for Service
        guard let url1 = URL(string: Service.BaseUrl+url) else { return }
        
        //        if DebugModePrint() {
        //            print(url1)
        //        }
        
        var request = URLRequest(url: url1)
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
        
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
            }else{
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")
                
            }
        }
        
        
        let origne = url1.host
        request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
        
        callRequest(request: request, callBack: callBack) // Send request to CallRequest method
    }else{
        killLoader()
        errorString = AlertMessage.checkNetwork
        callBack(nil , false)
    }
}



func serverCommunicatorUplaodMultipalImage( url:String, param:Dictionary<String, Any>?, imageName: String, callBack : @escaping (Any?, Bool) -> Void){
    
    if isHaveNetowork() {
        var body = Data()
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        
        
        if let paramDict = param {
            for (key, value) in paramDict {
                
                if value is UIImage {
                    var imageData : Data?
                    imageData = (value as! UIImage).jpegData(compressionQuality: 0.5)
                    
                    if (imageData != nil) {
                        body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                        body.append(Data("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(imageName).jpeg\"\r\n".utf8))
                        body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
                        body.append(imageData!)
                        body.append(Data("\r\n".utf8))
                    }
                    body.append(Data("--\(BoundaryConstant)--\r\n".utf8))
                }else{
                    body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                    body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                    body.append(Data("\(value)\r\n".utf8))
                }
                
            }
        }
        
        
        //Request for Service
        guard let url1 = URL(string: Service.BaseUrl+url) else { return }
        
        //                if DebugModePrint() {
        //                    print(url1)
        //                }
        
        var request = URLRequest(url: url1)
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
            }else{
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")
                
            }
        }
        let origne = url1.host
        request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
        
        callRequest(request: request, callBack: callBack) // Send request to CallRequest method
    }else{
        killLoader()
        errorString = AlertMessage.checkNetwork
        callBack(nil , false)
    }
}


func serverCommunicatorUplaodDocuments( url:String, param:Dictionary<String, Any>?,docUrl:URL, DocPathOnServer:String, docName: String, callBack : @escaping (Any?, Bool) -> Void){
    
    if isHaveNetowork() {
        
        var body = Data()
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        
        
        if let paramDict = param {
            for (key, value) in paramDict {
                body.append(Data("--\(BoundaryConstant)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
        
        
        
        //Convert Image to Data formate
        let filename = docUrl.lastPathComponent
        let splitName = filename.split(separator: ".")
        let filetype = splitName.last!
        let mimeType = mimeTypeForPath(path: docUrl)
        
        
        body.append(Data("--\(BoundaryConstant)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"\(DocPathOnServer)\"; filename=\"\(docName).\(filetype)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        
        
        do {
            let imgData = try Data(contentsOf: docUrl as URL)
            body.append(imgData)
        }
        catch {
            // can't load image data
        }
        
        //body.append(try Data(contentsOf: docUrl as URL))
        body.append(Data("\r\n".utf8))
        body.append(Data("--\(BoundaryConstant)--\r\n".utf8))
        
        //Request for Service
        guard let url1 = URL(string: Service.BaseUrl+url) else { return }
        //        if DebugModePrint() {
        //            print(url1)
        //        }
        
        var request = URLRequest(url: url1)
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
            }else{
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")
                
            }
        }
        let origne = url1.host
        request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
        
        callRequest(request: request, callBack: callBack) // Send request to CallRequest method
    }else{
        killLoader()
        errorString = AlertMessage.checkNetwork
        callBack(nil , false)
    }
}



func increaseErrorCount(callBack : @escaping (Any?, Bool) -> Void, data:Data?) -> Void {
    // Note : if get simutaniously 3 times error from any API than we automatically navigate to login page
    errorCount = errorCount + 1
    if errorCount > 2 {
        ShowAlert(title: AlertMessage.formatProblem, message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
            if (Ok){
                killLoader()
                navigateToLoginPage()
            }
        })
    }else{
        callBack(data , false)
    }
}


func mimeTypeForPath(path: URL) -> String {
    let pathExtension = path.pathExtension
    
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
        if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
            return mimetype as String
        }
    }
    return "application/octet-stream"
}

/*
 var baseUrl = ""
 if  testerUser {
 baseUrl = "https:staging.eyeontask.com/eotServices/"
 }else{
 baseUrl = "https:www.eyeontask.com/eotServices/"
 }
 
 */
