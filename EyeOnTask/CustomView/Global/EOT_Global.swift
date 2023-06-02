//
//  EOT_Global.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 25/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var authenticationToken : String? = ""
var roundOff : String = "4"
var taxCalculationType = ""
//var strSelectedCondition = ""
let EOT_VAR = "EOT_VAR"
var gpsStatusVariable : GPSstatus?
var batteryLevel: String { String(Int(UIDevice.current.batteryLevel*100))}
var activtiLogArr = [OfflineListArray]()
let context = APP_Delegate.persistentContainer.viewContext //Create context
var attempedCount = Int()
var isCustomFormListSelected = false 
var arrErrorLog = [ErrorsList]()
var ErrorLogSndDataArr = [ErrorLogSndData]()
//=======================================
// Font color
//=======================================
func Color_NormalFont() -> UIColor {
    return UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
}


//=======================================
// Round off function
//=======================================
func roundOff(value : Double) -> String {
    let calculation = String(format: "%.\(roundOff)f", value)
    return calculation
}

//=======================================
// Save Company Settings
//=======================================
func saveDefaultSettings(userDetails : DefaultSettings ) -> Void {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(userDetails) {
        UserDefaults.standard.set(encoded, forKey: "DefSetting")
        UserDefaults.standard.synchronize()
    }
}

//func getEmailTemplate() -> [JobCardTemplat]? {
//    let decoder = JSONDecoder()
//    if let questionData = UserDefaults.standard.data(forKey: "EmailTemplate"){
//        let question = try? decoder.decode([JobCardTemplat].self, from:questionData)
//        return question ?? nil
//    }
//    return nil
//}
//
//func saveEmailTemplate(userDetails : [JobCardTemplat] ) -> Void {
//    let encoder = JSONEncoder()
//    if let encoded = try? encoder.encode(userDetails) {
//        UserDefaults.standard.set(encoded, forKey: "EmailTemplate")
//        UserDefaults.standard.synchronize()
//    }
//}

//=======================================
// Fetch Company Settings
//=======================================
func getDefaultSettings() -> DefaultSettings? {
    let decoder = JSONDecoder()
    if let questionData = UserDefaults.standard.data(forKey: "DefSetting"){
        let question = try? decoder.decode(DefaultSettings.self, from:questionData)
        return question ?? nil
    }
    return nil
}

func removeDefaultSettings() -> Void {
    UserDefaults.standard.removeObject(forKey: "DefSetting")
}



//=======================================
// Save User's Details
//=======================================
func saveUserDetails(userDetails : LoginData ) -> Void {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(userDetails) {
        authenticationToken = userDetails.token
        UserDefaults.standard.set(encoded, forKey: "userinfo")
        UserDefaults.standard.synchronize()
    }
}

//=======================================
// Fetch User's Details
//=======================================
func getUserDetails() -> LoginData? {
    let decoder = JSONDecoder()
    if let questionData = UserDefaults.standard.data(forKey: "userinfo"){
        let question = try? decoder.decode(LoginData.self, from:questionData)
        return question ?? nil
    }
    return nil
}


func getUserDetailsusrId() -> LoginData? {
    let decoder = JSONDecoder()
    if let questionData = UserDefaults.standard.data(forKey: "usrId"){
        let question = try? decoder.decode(LoginData.self, from:questionData)
        return question ?? nil
    }
    return nil
}

func saveUserDetailsusrId(userDetails : String ) -> Void {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(userDetails) {
       // authenticationToken = userDetails.token
        UserDefaults.standard.set(encoded, forKey: "usrId")
        UserDefaults.standard.synchronize()
    }
}

//=======================================
// Save Current Language
//=======================================
func saveCurrentSelectedLanguage(filename:String) {
    UserDefaults.standard.set(filename, forKey: "currentLang")
    UserDefaults.standard.synchronize()
}

func saveCurrentSelectedLanguageCode(filename:String) {
    UserDefaults.standard.set(filename, forKey: "currentLangCod")
    UserDefaults.standard.synchronize()
}

//=======================================
// Get Current Language
//=======================================

func getCurrentSelectedLanguage() -> String? {
    if let languageId = UserDefaults.standard.value(forKey: "currentLang") as? String {
        return languageId
    }else{
        return nil
    }
}

func getCurrentSelectedLanguageCode() -> String? {
    if let languageId = UserDefaults.standard.value(forKey: "currentLangCod") as? String {
        return languageId
    }else{
        return nil
    }
}

func navigateToLoginPage() -> Void {
    DispatchQueue.main.async {
        logoutFromAllEnvirements()
        (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
    }
}

func logoutFromAllEnvirements() -> Void {
   
    
     if (UserDefaults.standard.value(forKey: "login") != nil &&  UserDefaults.standard.value(forKey: "login") as! Bool) == true {
        
        
            NotiyCenterClass.removeBatteryLevelNotifier()
            
            if ChatManager.shared.isFirebaseAuthenticate() {
                
                setGpsStatusOnFirebase(status: GPSstatus.logout)
                //Set user status offline on firebase
                ChatManager.shared.removeAllListeners()
                ChatManager.shared.ref.cancelDisconnectOperations()
                ChatManager.shared.setStatusOffline {
                   ChatManager.shared.SignoutUserFromFirebase() // firebase logout when user logout from the app
                   ChatManager.shared.ref.database.goOffline()
               }
                 
            }
            
            if APP_Delegate.startLocationTask != nil {
                APP_Delegate.startLocationTask?.cancel()
            }
            
            if APP_Delegate.stopLocationTask != nil {
                APP_Delegate.stopLocationTask?.cancel()
                LocationManager.shared.stopTracking() // Stop live tracking when user logout from the app
            }
            
        }
    
     UserDefaults.standard.set(false, forKey: "login")
      //removeDefaultSettings()
     UserDefaults.standard.synchronize()
    
   
}


func setGpsStatusOnFirebase(status : GPSstatus) -> Void {
    if gpsStatusVariable != status {
        gpsStatusVariable = status
        let path = ChatManager.shared.getGPSstatusPathOnFirebase()
        ChatManager.shared.ref.child(path).setValue(status.rawValue)
    }
}

func ActivityLog(module: String, message: String) {
    if let activitylog = getDefaultSettings()?.isActivityLogEnable {
        if activitylog == "1" {
           
            activtiLogArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineListArray", query: nil) as! [OfflineListArray]
            
           // if activtiLogArr.count == 25 {
                
                var parm = [OfflineListArray]()
//                parm["module"] = activtiLogArr[0].module
//                parm["msg"] = activtiLogArr[0].msg
//                parm["device"] = "5"
                var param = ActivityParams(module: module, message: message)
                DatabaseClass.shared.saveActivityOffline(service: Service.insertActivityLog, param: param)
            //}
            
        }
    }
}


//func ActivityLogisArray(module: [String], message: String) {
   // if module.count >= 25 {
       // if let activitylog = getDefaultSettings()?.isActivityLogEnable {
           // if activitylog == "1" {
           //     let param = ActivityParamsArray(module: module, message: message)
          //      DatabaseClass.shared.saveActivityOfflineIsArray(service: Service.insertActivityLog, param: param)
          //  }
      //  }
   // }
    
   
//}

//=======================================
// Save Current serverUrl
//=======================================
func saveCurrentServerUrl(url:String) {
    UserDefaults.standard.set(url, forKey: "serverUrl")
    UserDefaults.standard.synchronize()
}

//=======================================
// Get Current Language
//=======================================
func getCurrentServerUrl() -> String? {
    if let url = UserDefaults.standard.value(forKey: "serverUrl") as? String {
        return url
    }else{
        return nil
    }
}

//=======================================
// Save Current serverUrl
//=======================================
func saveCheckInId(checkinId:String) {
    UserDefaults.standard.set(checkinId, forKey: "checkid")
    UserDefaults.standard.synchronize()
}

func LocalTimeSave(checkinId:String) {
    UserDefaults.standard.set(checkinId, forKey: "localTime")
    UserDefaults.standard.synchronize()
}

func fullLocalTimeSave(checkinId:String) {
    UserDefaults.standard.set(checkinId, forKey: "FulllocalTime")
    UserDefaults.standard.synchronize()
}

func saveCheckInOutTimeCount(checkinId:String) {
    UserDefaults.standard.set(checkinId, forKey: "CheckInOutTimeCount")
    UserDefaults.standard.synchronize()
}

func saveCheckInOutTimeCountWithLogout(checkinId:String) {
    UserDefaults.standard.set(checkinId, forKey: "CheckInOutTimeCountWithLogout")
    UserDefaults.standard.synchronize()
}

//=======================================
// Get Current Language
//=======================================
func getCheckInId() -> String? {
    if let checkinId = UserDefaults.standard.value(forKey: "checkid") as? String {
        return checkinId
    }else{
        return nil
    }
}

func getLocalTime() -> String? {
    if let checkinId = UserDefaults.standard.value(forKey: "localTime") as? String {
        return checkinId
    }else{
        return nil
    }
}

func fullgetLocalTime() -> String? {
    if let checkinId = UserDefaults.standard.value(forKey: "FulllocalTime") as? String {
        return checkinId
    }else{
        return nil
    }
}

func getCheckInOutTimeCount() -> String? {
    if let checkinId = UserDefaults.standard.value(forKey: "CheckInOutTimeCount") as? String {
        return checkinId
    }else{
        return nil
    }
}

func getCheckInOutTimeCountWithLogout() -> String? {
    if let checkinId = UserDefaults.standard.value(forKey: "CheckInOutTimeCountWithLogout") as? String {
        return checkinId
    }else{
        return nil
    }
}

//=======================================
// Save Current Language
//=======================================
func saveDefaultLanugage(lanugage : selectedLanguageDetails) -> Void{
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(lanugage) {
        UserDefaults.standard.set(encoded, forKey: "defLanguage")
        UserDefaults.standard.synchronize()
    }
}

//=======================================
// Get Current Language
//=======================================
func getDefaultLanugage() -> selectedLanguageDetails? {
    let decoder = JSONDecoder()
    if let languageData = UserDefaults.standard.data(forKey: "defLanguage"){
        let lanugage = try? decoder.decode(selectedLanguageDetails.self, from:languageData)
        return lanugage ?? nil
    }
    return nil
}

//=============================================
//Permissions for show and hide some features
//=============================================
func isPermitForShow(permission : permissions) -> Bool {
    // false - Hide,
    // true - Show
    if let isHide = getDefaultSettings()?.rights![0][permission.rawValue] {
        if isHide == 1 {
          return false //isHide
        }else{
            return true //isShow
        }
    }
    return true //isShow
}

//=======================================
//Permissions for items section fields
//=======================================
func compPermissionVisible(permission : compPermission) -> Bool {
    // false - Hide,
    // true - Show
    
    if let dict = getDefaultSettings()?.comp_permission!.filter({$0["moduleId"] == "1"}) {
        if dict.count > 0 {
            if dict[0][permission.rawValue] == "0" {
                return true //isShow
            }else{
                return false //isHide
            }
        }
    }
    
    return true //isHide
}

//=======================================
//for get string with roundoff the value
//=======================================
func getValueFromString(value : String?) -> String {
    if (value != nil) {
        if value == "" {
            return roundOff(value: 0.0)
        } else {
          
            if let result = Double(value ?? "") {
                return roundOff(value: result)
            } else {
                return roundOff(value: 0.0)
            }
        }
    } else {
        return roundOff(value:0.0)
    }
}



//============================
//For calculate total amount
//============================
func calculateAmount(quantity:Double, rate:Double, tax:Double, discount:Double) -> Double {
    
    if (taxCalculationType == "0"){
        let totalAmount = (quantity * rate + quantity * ((rate*tax)/100)) -  quantity * ((rate*discount)/100)
        return totalAmount
    }else{
        // New formula

        let newRate = (rate - ((rate * discount) / 100));
        return quantity * ( newRate + ((newRate * tax) / 100));
    }
}

func calculateAmountFlateDiscount(quantity:Double, rate:Double, tax:Double, discount:Double) -> Double {
    
    if (taxCalculationType == "0"){
        let totalAmount = (quantity * rate + quantity * ((rate*tax)/100)) -  quantity * ((rate*discount)/100)
        return totalAmount
    }else{
        // New formula//disCalculationType

        let newRate = (rate);
        return quantity * ( newRate + ((newRate * tax) / 100)) - discount;
    }
}

//============================
// For calculate total tax
//============================
func calculateTaxAmount(rate:Double,qty:Double, taxRateInPercentage:Double) -> Double {
    let taxAmount = ((rate*taxRateInPercentage)/100)*Double(qty)
    return taxAmount
}

func calculateFlateDiscountAmount(quantity: Double, rate: Double, tax: Double, discount: Double) -> (Double, Double, Double) {
    let interesIncludingTax   = ((quantity * rate) - discount)
    let finalTaxAmount = (interesIncludingTax * tax)/100
    let finalTotalAmount = finalTaxAmount + interesIncludingTax
    let discountAmount =  (rate - discount)
    let rateIncludingTax = ((discountAmount * tax)/100) + rate
    return (rateIncludingTax, finalTaxAmount, finalTotalAmount) // return type is RateIncTxt, tax ammount and total ammount
}

func calculateNormalDiscountAmount(quantity: Double, rate: Double, tax: Double, discount: Double) -> (Double, Double, Double) {
    let taxAmount  = ((quantity * rate) * tax)/100
    let rateIncludingTax =  (taxAmount / quantity) + rate
    let totalAmount = (rateIncludingTax * quantity) - discount
    return (rateIncludingTax, taxAmount, totalAmount) // return type is RateIncTxt, tax ammount and total ammount
}

func calculatePercentageDiscountAmount(quantity: Double, rate: Double, tax: Double, discount: Double) -> (Double, Double, Double) {
    let taxAmount  = ((quantity * rate) * tax)/100
    let rateIncludingTax =  (taxAmount / quantity) + rate
    let amountWithoutDiscount = (rateIncludingTax * discount)/100
    let dicountApplied = rateIncludingTax - amountWithoutDiscount
    let totalAmount = (dicountApplied * quantity)
    return (rateIncludingTax, taxAmount, totalAmount) // return type is RateIncTxt, tax ammount and total ammount
}

//======================================
// For Save files on document directory
//======================================

func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func saveFileInDocumentDirectory(url: String, fileName: String){
    let fileManager = FileManager.default
    let paths = (getDirectoryPath() as NSString).appendingPathComponent(fileName)
    let pdfDoc = NSData(contentsOf:URL(string: url)!)
    fileManager.createFile(atPath: paths as String, contents: pdfDoc as Data?, attributes: nil)
}


func loadFileFromDocumentDirectory(fileName:String) -> String? { // this is return document path
    let fileManager = FileManager.default
    let documentoPath = (getDirectoryPath() as NSString).appendingPathComponent(fileName)
    
    if fileManager.fileExists(atPath: documentoPath){
       return documentoPath
    }
    else {
       // print("document was not found")
        return nil
    }
}


func removeFileFromDocumentDirectory(fileName: String) -> Void {
    let fileManager = FileManager.default
    let documentoPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
    
    if fileManager.fileExists(atPath: documentoPath){
        do {
            try fileManager.removeItem(atPath: documentoPath)
           // print("file Removed")
        } catch {
          //  print("error removing file:", error)
        }
    }else {
       // print("document was not found")
    }
}

//======================================
// For Tap on New job notification
//======================================
func newJobNotificationHandler(notificationDict : [String : Any]?) -> Void {
    killLoader()
    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "jobsvc") as? JobVC
    vc?.isBackButton = true
   
    DispatchQueue.main.async {
        let navCon = NavClientController(rootViewController: vc!)
        navCon.modalPresentationStyle = .fullScreen
        windowController.present(navCon, animated: true, completion: nil)
    }
}

//======================================
// For Tap onSome Archibe job notification
//======================================
func someJobsArchiveJobNotificationHandler(notificationDict : [String : Any]?) -> Void {
    killLoader()
    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "jobsvc") as? JobVC
  
    vc?.someJobArchive = true
    DispatchQueue.main.async {
        let navCon = NavClientController(rootViewController: vc!)
        navCon.modalPresentationStyle = .fullScreen
        windowController.present(navCon, animated: true, completion: nil)
    }
}

//======================================
// For Tap on Admin chat notification
//======================================
func adminChatNotificationHandler(notificationDict : [String : Any]?) -> Void {
    killLoader()
    
    if let dict = notificationDict{
        let storyBoard : UIStoryboard = UIStoryboard(name: "MainJob", bundle:nil)
        
        
        if APP_Delegate.currentJobTab != nil {
            
            if APP_Delegate.currentJobTab?.objOfUserJobList?.jobId == "\(dict["jobId"]!)" {
                
                let  isItem = isPermitForShow(permission: permissions.isItemVisible)
                if isItem {
                    APP_Delegate.currentJobTab?.selectedIndex = 2
                }else{
                    APP_Delegate.currentJobTab?.selectedIndex = 1
                }
                return
            }else{
                ChatManager.shared.listenerForjob?.remove()
                APP_Delegate.currentJobTab!.dismiss(animated: true, completion: nil)
                APP_Delegate.currentJobTab!.navigationController?.popViewController(animated: true)
            }
        }
        
        let arrOFUserData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: nil) as! [UserJobList]
        APP_Delegate.currentJobTab = (storyBoard.instantiateViewController(withIdentifier: "jobTab") as! JobTabController)
        APP_Delegate.currentJobTab!.jobs = arrOFUserData
        
        let query = "jobId = '\(dict["jobId"]!)'"
        let currentJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
        
        if currentJob.count > 0 {
            APP_Delegate.currentJobTab!.objOfUserJobList = currentJob[0]
            APP_Delegate.currentJobTab!.isChatTabSelected = true
            
            DispatchQueue.main.async {
                let navCon = NavClientController(rootViewController: APP_Delegate.currentJobTab!)
                navCon.modalPresentationStyle = .fullScreen
                windowController.present(navCon, animated: true, completion: nil)
            }
        }else{
            
            let mess = AlertMessage.sorryThisJobNoLonger
            let newString = mess.replacingOccurrences(of: EOT_VAR, with: "'\(dict["jobCode"] as! String)'")
            ShowError(message: newString, controller: windowController)
        }
    }
}


//======================================
// For Tap on Client chat notification
//======================================
func clientChatNotificationHandler(notificationDict : [String : Any]?) -> Void {
    
    killLoader()
    if let dict = notificationDict {
        let vc = UIStoryboard.init(name: "MainClientChat", bundle: Bundle.main).instantiateViewController(withIdentifier: "CLIENTCHATE") as? ClientChatVC
        
        let query = "jobId = '\(dict["jobId"]!)'"
        let currentJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
        
        if currentJob.count > 0 {
            vc!.objOfUserJobListInDetail = currentJob[0]
            DispatchQueue.main.async {
                let navCon = NavClientController(rootViewController: vc!)
                navCon.modalPresentationStyle = .fullScreen
                windowController.present(navCon, animated: true, completion: nil)
            }
        }
    }
}


//=========================================
// For Tap on one to one chat notification
//=========================================
func one2oneChatNotificationHandler(notificationDict : [String : Any]?) -> Void {
    
    killLoader()
    if let dict = notificationDict {
        let vc = UIStoryboard.init(name: "MainAdminChat", bundle: Bundle.main).instantiateViewController(withIdentifier: "GROUPCHAT") as? AdminChatVC
        
        let senderId = (dict["senderid"] ?? "") as! String
        
        if ChatManager.shared.userModels.count > 0 {
            let userModel = ChatManager.shared.userModels.filter({$0.user?.usrId == senderId})
            
            if userModel.count > 0 {
                let userDetails = userModel[0]
                if userDetails.isInactive == false {
                    vc?.userData = userDetails
                    DispatchQueue.main.async {
                        let navCon = NavClientController(rootViewController: vc!)
                        navCon.modalPresentationStyle = .fullScreen
                        windowController.present(navCon, animated: true, completion: nil)
                    }
                }else{
                     windowController.showToast(message: LanguageKey.trying_to_chat)
                }
            }
        }else{
            APP_Delegate.appOpenFrom121ChatNotificationUser = senderId
        }
        
    }
}


//======================================
// For Tap on Client chat notification
//======================================

func  AppointmentNotificationHandler () -> Void {
   if APP_Delegate.currentVC == "CalenderVC"  {
        //ShowError(message: "inNotifire", controller: windowController)
        NotiyCenterClass.AppointmentfireRefreshAuditistNotifier(dict: [:])
    }else{
        let vc = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC;
        vc.isNotificationClick = true

        DispatchQueue.main.async {
            let navCon = NavClientController(rootViewController: vc)
            navCon.modalPresentationStyle = .fullScreen
            windowController.present(navCon, animated: true, completion: nil)
        }
    }
}


//======================================
// For Tap on Audit notification
//======================================
func AuditNotificationHandler() -> Void {
    if APP_Delegate.currentVC == "auditvc" || APP_Delegate.currentVC == "barcode" {
       
        NotiyCenterClass.fireRefreshAuditistNotifier(dict: [:])
    }else{
        let vc = UIStoryboard(name: "MainAudit", bundle: nil).instantiateViewController(withIdentifier: "audit") as! AuditVC;
        vc.isNotificationClick = true

        DispatchQueue.main.async {
            let navCon = NavClientController(rootViewController: vc)
            navCon.modalPresentationStyle = .fullScreen
            windowController.present(navCon, animated: true, completion: nil)
        }
    }
}

//======================================
// For Tap on Leave notification
//======================================
func LeaveNotificationHandler() -> Void {
    if APP_Delegate.currentVC == "LeaveUserListVC"  {
      
        NotiyCenterClass.fireRefreshLeaveNotifier(dict: [:])
    }else{
        let vc = UIStoryboard(name: "LeaveReport", bundle: nil).instantiateViewController(withIdentifier: "LeaveUserListVC") as! LeaveUserListVC;
        vc.isNotificationClick = true

        DispatchQueue.main.async {
            let navCon = NavClientController(rootViewController: vc)
            navCon.modalPresentationStyle = .fullScreen
            windowController.present(navCon, animated: true, completion: nil)
        }
    }
}


//=====================
//MARK:- Create Entity
//=====================
func createEntity(entityName : String) -> NSManagedObject? {
    let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
    let newUser = NSManagedObject(entity: entity!, insertInto: context)
   
    return newUser
}

//=====================
//MARK:- FETCH Entity
//=====================
func fetchDataFromDatabse(entityName : String, query : String?) -> Any? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    if let formate = query {
        request.predicate = NSPredicate(format: formate)
    }
    request.returnsObjectsAsFaults = false
    
    do{
        let result = try context.fetch(request)
   
        return result
    }catch {
        
        return nil
    }
}

//=====================
//MARK:- Save Entity
//=====================
func saveEntity(callback:(Bool)  -> Void) -> Void {
    
    if context.hasChanges{
        context.performAndWait({
            do {
                
                try context.save()
                
                callback(true)
            } catch {
                
                callback(true)
                print("error in saving")
            }
        })
    }else{
        callback(true)
    }
 }


//===========================================
//MARK:-saveError
//===========================================

func saveForErrorLog(data: ErrorLogSndData, response : Any?) -> Void {
    attempedCount = attempedCount + 1
    
    if attempedCount == 1 {
        attempedCount = 0
        var responseData = ""
        if let data = response {
            responseData = String(data: data as! Data, encoding: .utf8)!
        }else{
            responseData = errorString
        }
        
        saveInErrorTable(service: data.apis ?? "", params: data.parametres ?? "", response: responseData , time: data.time ?? "")
        context.delete(data)
        DatabaseClass.shared.saveEntity(callback: {isSuccess in
           
        })
    }else{
        //Re-call this method for check if pending requests in Offline Table
        // self.UploadRequests()
        // print("Sync Failed...")
    }
    
}

//===========================================
//MARK:- Sync Error Save in ErrorsList table
//===========================================
func saveInErrorTable(service:String, params:String, response:String, time : String) -> Void {
    
    let formatter = DateFormatter()
    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{
        if enableCustomForm == "0"{
            formatter.dateFormat = "dd-MM-yyyy h:mm a"
        }else{
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
        }
    }

    let stringDate = time
    let dateError = formatter.date(from: stringDate)!
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    let deviceName = UIDevice.modelName
    let iOSVersion = UIDevice.current.systemVersion

    let error = createEntity(entityName: Entities.ErrorsList.rawValue) as! ErrorsList
    error.apiUrl = Service.BaseUrl + service
    error.requestParam = params
    error.response = response
    error.time = dateError
    error.version = "Device Name - \(deviceName), iOS Version - \(iOSVersion), App Version - \(appVersion)"
    saveEntity(callback: { isSuccess in })
    
    uploadErrorsOnServer()
}

func uploadErrorsOnServer() -> Void {
    var errorArry = fetchDataFromDatabse(entityName:Entities.ErrorsList.rawValue, query: nil) as! [ErrorsList]

    if errorArry.count > 0{
      //  showLoader()
        // Sort requests in assending order for upload request according to time (First in First out)
        errorArry = errorArry.sorted(by: {
            $0.time?.compare($1.time!) == .orderedAscending
        })

        let usrId = getUserDetails()?.usrId
        let compId = getUserDetails()?.compId
        let token = (UserDefaults.standard.value(forKey: "deviceToken") as? String) ?? ""
        let data = errorArry [0]
        let param = Params()
        param.apiUrl = data.apiUrl //URL(string: Service.BaseUrl)?.absoluteString//"Send From Setting"//data.apiUrl
        param.requestParam = "UsrId - \(usrId ?? "")," + " CompId - \(compId ?? "")," + " DeviceToken - \(token ?? "")"//data.requestParam
       
        param.response = data.response//data.response
        param.version = data.version


        serverCommunicator(url: Service.errorUpload, param: param.toDictionary, callBack: { (response, success) in

            if (success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ErrorServiceResponse.self, from: response as! Data) {

                  //  killLoader()
                     //   self.showToast(message: "Log Send")
                     

                    arrErrorLog = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ErrorsList", query: nil) as! [ErrorsList]
                    for job in arrErrorLog{
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                     }
                 //   print(" arrErrorLog - \(arrErrorLog.count)")
                    ErrorLogSndDataArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ErrorLogSndData", query: nil) as! [ErrorLogSndData]
                    for job in ErrorLogSndDataArr{
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                     }
                 //   print(" ErrorLogSndDataArr - \(ErrorLogSndDataArr.count)")
                    
                }
            }else{

            }
        })
    }else{
     //   print("Error Log Not Found.")
    }
}



//-

// MARK:- Get Error Log =======================================================
//var arryData = fetchDataFromDatabse(entityName: "ErrorLogSndData", query: nil) as! [ErrorLogSndData]
//let userJobs = DatabaseClass.shared.createEntity(entityName: "ErrorLogSndData") as! ErrorLogSndData
//userJobs.apis = Service.getUserJobListNew
//userJobs.parametres = "[]"
//userJobs.time = currentDatEAndTimeForErrorLog()
//
//DatabaseClass.shared.saveEntity(callback: {_ in
//    DatabaseClass.shared.syncDatabase()
//    self.navigationController?.popViewController(animated: true)
//})
//arryData.append(userJobs)
//let arryData1 = fetchDataFromDatabse(entityName: "ErrorLogSndData", query: nil) as! [ErrorLogSndData]
//if arryData1.count > 0 {
//    let data = arryData1[0]
//    saveForErrorLog(data: data, response: response)
//  }
//==============================================================================
