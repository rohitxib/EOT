//
//  SideMenuVC.swift
//  EyeOnTask
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
//import BarcodeScanner
import AVFoundation

class SideMenuVC: UIViewController {

    @IBOutlet weak var settingLbl: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var tableSideMenu: UITableView!
    @IBOutlet weak var lblEyeontask: UILabel!
    @IBOutlet var user_Img: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUseremail: UILabel!
    @IBOutlet weak var versionUpdateLbl: UILabel!
    @IBOutlet var attechmentView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var btnAttechUpdate: UIButton!
    var forequipmentbarcode = ""
    var LinkEquipmentData = [equipDataArray]()
    var uploadImageLoad : UIImage? = nil
    var menus = [SideMenuModel]()
    var languageIndex = 2
    var indicator : UIActivityIndicatorView?
    var  getAuditId : AuditListData?
    var isUserfirstLogin = Bool()
    var arrOFAdminEquipData = [AdminEquipmentList]()
    var arrFilterData = [EquipListDataModel]()
    var localTime = ""
    var fulllocalTime = ""
    var timer = Timer()
    var intCounter = 1
    var CheckOutIntimerOff = Bool()
   
    let lblNameTimer = UILabel(frame: CGRect(x: 175, y: 03, width: 183, height: 40))
    var lblCheckInOutTime = UILabel(frame: CGRect(x: 50, y: 30, width: 183, height: 25))
    var shoeTimeZone = UILabel(frame: CGRect(x: 50, y: 60, width: 190, height: 50))
    var shoeTimeZoneImg = UIImageView(frame: CGRect(x: 7, y: 70, width: 32, height: 32))
    var shoeTimeZonebutton = UIButton(frame: CGRect(x: 0, y: 60, width: 280, height: 50))
    var isAutoCheckoutEnable = true
    var isAutoCheckoutPopUp = false
    var chengOutCheckTime = ""
    var showCheckPoUp = true
    var getCunvertLastCheckInDateTime:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let currentTimeZone = getCurrentTimeZone()
//        print(currentTimeZone)
        

        let tmformate = DateFormate.yyyy_MM_dd_HH_mm_ss_a.rawValue
        let isoDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        
        let currentTime = CheckInandOutCurrentTime(timestamp: Date())
        let lastCheckInTime = getDefaultSettings()?.lastCheckIn
        
        if lastCheckInTime != "" && lastCheckInTime != nil {
            let islastCheckInConvert = (lastCheckInTime != nil) ? createDateTimeForCheckInandOut(timestamp: lastCheckInTime ?? "") : ""
            
            let one = dateFormatter.date(from: currentTime!)
            let two = dateFormatter.date(from: islastCheckInConvert!)
            
            let compareTime = one!.timeIntervalSince(two!)
            
            getCunvertLastCheckInDateTime = Int(compareTime)
            
        }

        let loginUsrTz = getDefaultSettings()?.loginUsrTz
      
        self.shoeTimeZone.text = "\(LanguageKey.timezone_Message) \(loginUsrTz ?? "")"
       
        var activityIndcaterStop = "False"
        UserDefaults.standard.set(activityIndcaterStop, forKey: "activityIndcaterStop")
        
        let checkInOutDuration = getDefaultSettings()?.checkInOutDuration
        
        isAutoCheckoutEnable = compPermissionVisible(permission: compPermission.isAutoCheckoutEnable)
        backGroundView.isHidden = true
        let check = getCheckInId()
        if check != "" {
            
            var timeBool = APP_Delegate.timerCountOneTime
            if timeBool == "False" {
                
                var checkInTime = getLocalTime()
                self.CheckOutIntimerOff = true
                let lastCheckIn = getDefaultSettings()?.lastCheckIn
                if lastCheckIn != "" {
                    let islastCheckInConvert = (lastCheckIn != nil) ? convertTimeStampToString(timestamp: lastCheckIn ?? "", dateFormate: DateFormate.h_mm_a) : ""
                    self.lblCheckInOutTime.text = islastCheckInConvert
                }else{
                    self.lblCheckInOutTime.text = checkInTime
                }
                
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
            }else{
                
                if let check = getCheckInId() {
                    if check == "" {
                        // saveCheckInOutTimeCountWithLogout(checkinId: "false")
                    }else{
                        
                        APP_Delegate.timerCountOneTime = "False"
                        var velue1 = getCheckInOutTimeCountWithLogout()
                        if velue1 == "true" {
                            
                            var checkInTime = getLocalTime()
                            self.CheckOutIntimerOff = true
                            let lastCheckIn = getDefaultSettings()?.lastCheckIn
                            if lastCheckIn != "" {
                                let islastCheckInConvert = (lastCheckIn != nil) ? convertTimeStampToString(timestamp: lastCheckIn ?? "", dateFormate: DateFormate.h_mm_a) : ""
                                self.lblCheckInOutTime.text = islastCheckInConvert
                            }else{
                                self.lblCheckInOutTime.text = checkInTime
                            }
                            
                            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: false)
                        }
                        
                    }
                }
                
            }
        }
        
        getAdminEquipementList()
        settingLbl .text =  LanguageKey.settings
        self.btnUpdate.isHidden = true
        self.pulsate()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.StopActivityIndicator()
        
        
        //============================================================
        // MARK:- AutoCHACKOUT
        //============================================================
        
        if getDefaultSettings()?.isJobLatLngEnable == "0" {
            // H_lattitude.constant = 0.0
        }
        
        if getDefaultSettings()?.isLandmarkEnable == "0" {
            //  H_landmark.constant = 0.0
        }
        
        // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
                 var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
                 duration = updateDefaultTime(duration ?? "01:00")
        let arrOFDurationTime = duration?.components(separatedBy: ":")
        // let currentTime : String? = getDefaultSettings()?.jobCurrentTime // old
        let currentTime : String? = updateDefaultTime(getDefaultSettings()?.jobCurrentTime ?? "01:00")
        if(currentTime != "" && currentTime != nil){
            let arrOFCurntTime = currentTime?.components(separatedBy: ":")
            
            
            let strDate = getSchuStartAndEndDateForAgoTime24(Hrs:Int(arrOFCurntTime![0])!, min: Int(arrOFCurntTime![1])!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
            
            let arr = strDate.0.components(separatedBy: " ")
            
            if arr.count == 2 {
                
                var strTime = arr[0]
                
            }else{
                
                var SiftEndTime:String = getDefaultSettings()?.shiftEndTime ?? ""
                var currentTime:String = arr[0]
                
                //===============================================
                
                let duration11 : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0"
                let arrOFDurationTime1 = duration?.components(separatedBy: ":")
                // let currentTime1 : String? = getDefaultSettings()?.jobCurrentTime // old
                let currentTime1 : String? = updateDefaultTime(getDefaultSettings()?.jobCurrentTime ?? "01:00")
                let arrOFCurntTime1 = currentTime1?.components(separatedBy: ":")
                let strDate1 = getSchuStartAndEndDateForAgoTime(Hrs:Int(arrOFCurntTime1![0])!, min: Int(arrOFCurntTime1![1])!, diffOfHr: Int(arrOFDurationTime1![0])!, diffOfMin: Int(arrOFDurationTime1![1])!)
                let strDate2 = getSchuStartAndEndDateForAgoTimeAfterDay(Hrs:Int(arrOFCurntTime1![0])!, min: Int(arrOFCurntTime1![1])!, diffOfHr: Int(arrOFDurationTime1![0])!, diffOfMin: Int(arrOFDurationTime1![1])!)
                let arrd2 = strDate2.0.components(separatedBy: " ")
                let arrd = strDate1.0.components(separatedBy: " ")
                
                //====================ConverTime==================
                
                let getShiftTime = SiftEndTime
                if getShiftTime != "" {
                    let dateFormatterNew1 = DateFormatter()
                    
                    dateFormatterNew1.dateFormat = "HH:mm"
                    dateFormatterNew1.locale = Locale(identifier: "en_US")
                    let dateNew11 = dateFormatterNew1.date(from:getShiftTime)!
                    
                    let dateFormatter22 = DateFormatter()
                    dateFormatter22.dateFormat = "HH:mm"
                    dateFormatter22.locale = Locale(identifier: "en_US")
                    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
                        if isAutoTimeZone == "0"{
                            dateFormatter22.timeZone = NSTimeZone.local
                        }else{
                            
                            let loginUsrTz = getDefaultSettings()?.loginUsrTz
                            dateFormatter22.timeZone = TimeZone(identifier: loginUsrTz ?? "")
                            
                        }
                    }
                    let afterAddTime10Hr1 = dateFormatter22.string(from: dateNew11)
                    let shiftEndtTimeCurrent = afterAddTime10Hr1 // add Befaure 10 hr
                    
                    //===========
                    
                    let shifendDateNew = "\(arrd[0])" + " \(shiftEndtTimeCurrent)"
                    let currentDateNew = "\(arrd[0])" + " \(currentTime)"
                    
                    let dateFormatterNew = DateFormatter()
                    
                    dateFormatterNew.dateFormat = "dd-MM-yyyy HH:mm"
                    dateFormatterNew.locale = Locale(identifier: "en_US")
                    let dateNew = dateFormatterNew.date(from:shifendDateNew)!
                    
                    let dateFormatter2 = DateFormatter()
                    let dateNew1 = dateNew.addingTimeInterval(600*60)
                    
                    dateFormatter2.dateFormat = "dd-MM-yyyy HH:mm"
                    dateFormatter2.locale = Locale(identifier: "en_US")
                    let afterAddTime10Hr = dateFormatter2.string(from: dateNew1) //add After 10 hr with Date
                    
                    //========
                  
                    if let check = getCheckInId() {
                        if check == "" {
                            // User not check In -
                            print("JUgalCheckOut1")
                            // Remove set DefaultLocal ShiftEnd Time :-
                            let localafterAddTime10Hr = ""
                            UserDefaults.standard.set(localafterAddTime10Hr, forKey: "DefaultShiftEndTm10Hr")
                        }else{
                            
                            if isAutoCheckoutEnable == false {
                                // Auto CheckOut NOT WORKING :-
                                if shiftEndtTimeCurrent <= currentTime {
                                    isAutoCheckoutPopUp = true
                                }else{
                                    isAutoCheckoutPopUp = false
                                }
                                
                            }else{
                                //===NEW Implement 28/03/23=============================================
                                
                                let getLocalShiftEnd10hrTm = UserDefaults.standard.value(forKey: "DefaultShiftEndTm10Hr") as? String ?? ""
                                if getLocalShiftEnd10hrTm == ""{
                                    // Add set DefaultLocal ShiftEnd Time :-
                                    print("JUgalCheckOut")
                                    let locaShiftendTime10Hr = afterAddTime10Hr
                                    UserDefaults.standard.set(locaShiftendTime10Hr, forKey: "DefaultShiftEndTm10Hr")
                                }else{
                                    print("JUgalCheckIn")
                                }
                                let getLocalShiftEnd10hrTm1 = UserDefaults.standard.value(forKey: "DefaultShiftEndTm10Hr") as? String ?? ""
                               // print("get -- \(getLocalShiftEnd10hrTm1)")
                                
                                //====
                                
                                let dateFormatterNew1 = DateFormatter()
                                dateFormatterNew1.dateFormat = "dd-MM-yyyy HH:mm"
                                dateFormatterNew1.locale = Locale(identifier: "en_US")
                                let getLocalShiftEndToDate = dateFormatterNew1.date(from:getLocalShiftEnd10hrTm1)!
                                let currentDateToDate = dateFormatterNew1.date(from:currentDateNew)!
                                //==
                                if getLocalShiftEndToDate.compare(currentDateToDate) == .orderedDescending {
                                     print("First Date is greater then second date")
                                    // Check In Show On Display Side menu

                                }else{
                                    print("First Date is less then second date")
                                    // Check Out Show -
                                    // Remove set DefaultLocal ShiftEnd Time :-

                                    let localafterAddTime10Hr = ""
                                    UserDefaults.standard.set(localafterAddTime10Hr, forKey: "DefaultShiftEndTm10Hr")
                                    saveCheckInId(checkinId: "")
                                    self.CheckOutIntimerOff = false
                                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.StopTime), userInfo: nil, repeats: false)
                                }
                                //====
//                                if getLocalShiftEnd10hrTm1 <= currentDateNew {
//                                    // Check Out Show -
//                                    // Remove set DefaultLocal ShiftEnd Time :-
//                                    print("JUgalCheckInafterTime")
//                                    let localafterAddTime10Hr = ""
//                                    UserDefaults.standard.set(localafterAddTime10Hr, forKey: "DefaultShiftEndTm10Hr")
//                                    saveCheckInId(checkinId: "")
//                                    self.CheckOutIntimerOff = false
//                                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.StopTime), userInfo: nil, repeats: false)
//
//                                }else {
//                                    // Check In Show On Display Side menu
//                                    print("JUgalCheckIn1")
//                                }
                                
                                //=======================================================================
                               
                            }
                        }
                    }
                }
            }
        }
        //================================
        
        // Show and hide Update button ///////
        
        self.navigationController?.isNavigationBarHidden = true
        
        if let setttings = getDefaultSettings(){
            if let latestVersion = Float(setttings.version!){
                let appVersion : Float = Float(String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!))!
                
                if latestVersion > appVersion {
                    self.btnUpdate.isHidden = false
                    self.pulsate()
                }else{
                    self.btnUpdate.isHidden = true
                }
            }else{
                self.btnUpdate.isHidden = true
            }
        }else{
            self.btnUpdate.isHidden = true
        }
        
        APP_Delegate.currentVC = "sidemenu"
        
        let fnm = getUserDetails()?.fnm ?? "Unknown"
        let lnm = getUserDetails()?.lnm ?? "Unknown"
        
        lblUsername.text = fnm + " \(lnm)"
        lblUseremail.text = getUserDetails()?.email ?? ""
        
        let result = SideMenu.getModel()
        menus = result.0
        languageIndex = result.1
        settingLbl.text = LanguageKey.settings
        lblLogout.text = LanguageKey.logout
        self.btnUpdate.setTitle(LanguageKey.update, for: .normal)
        tableSideMenu.alwaysBounceVertical = false
        setVersion()
        tableSideMenu.reloadData()
        
        setProfilePic()
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
    
    func getImageFromUserDefault(key:String) -> UIImage? {
        let imageData = UserDefaults.standard.object(forKey: key) as? Data
        var image: UIImage? = nil
        if let imageData = imageData {
            image = UIImage(data: imageData)
        }
        return image
    }
    
    func setVersion() -> Void {
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "1.0"
        let mess = LanguageKey.eye_on_task_version
        let newString = mess.replacingOccurrences(of: EOT_VAR, with: "\(versionNumber)")
        self.versionUpdateLbl.text = newString
    }

    //================================
    //  MARK: showing And Hiding Background
    //================================
    
    func showBackgroundView() {
        backGroundView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.backGroundView.backgroundColor = UIColor.black
            self.backGroundView.alpha = 0.5
        })
    }
    
    func hideBackgroundView() {
        
        if (attechmentView != nil) {
            attechmentView.removeFromSuperview()
        }
       
        self.backGroundView.isHidden = true
        self.backGroundView.backgroundColor = UIColor.clear
        self.backGroundView.alpha = 1
    }
    
    @IBAction func btnUpDetPressed(_ sender: Any) {
        
        
        
        ShowAlert(title: LanguageKey.new_version , message: AlertMessage.checkVersion, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.update as NSString, style: .alert) { (cancel, update) in
            
            
            if update {
                if let link = URL(string: Constants.APPSTORE_URL) {
                    UIApplication.shared.open(link)
                    self.btnUpdate.isHidden = true
                }
            }
        }
        
    }
    
    @IBAction func attechUpdateBtnActn(_ sender: Any) {
        hideBackgroundView()
    }
    
    
    @IBAction func settingBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogoutPressed(_ sender: Any) {
        self.timer.invalidate()
        ActivityLog(module: Modules.logout.rawValue, message: ActivityMessages.sideMenuLogout)
        
        logoutFromAllEnvirements()
        self.performSegue(withIdentifier: "popLogout", sender: nil)
        if isHaveNetowork() {
            let param = Params()
            param.udId = getUserDetails()?.udId
            serverCommunicator(url: Service.logout, param: param.toDictionary) { (response, success) in
                APP_Delegate.timerCountOneTime = "False"//jugal 03/12/21 code
                
                if let check = getCheckInId() {
                    if check == "" {
                        saveCheckInOutTimeCountWithLogout(checkinId: "false")
                    }else{
                        saveCheckInOutTimeCountWithLogout(checkinId: "true")
                    }
                }
               
            }
        }else{
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
        }
    }
  
    @IBAction func switchToggle(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "permission")
        }else{
            UserDefaults.standard.set(false, forKey: "permission")
        }
    }
    
    // pulsate style of Button  :-
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        btnUpdate.layer.add(pulse, forKey: "pulse")
     
    }
    
    func setProfilePic() -> Void {
        
        DispatchQueue.global().async {
            
            if  getUserDetails()?.img != "" &&   getUserDetails()?.img != nil{
                let combineUrl =  String(format: "%@%@", Service.BaseUrl, (getUserDetails()?.img)!)
                
                DispatchQueue.main.async{
                    self.user_Img.image = UIImage(named: "User");
                }
                let imgUrl = URL(string:combineUrl)
                
                let img = ImageCaching.sharedInterface().getImage(imgUrl?.absoluteString)
                if((img) != nil){
                    DispatchQueue.main.async {
                        self.user_Img.image = img
                    }
                }else{
                    if (imgUrl != nil){
                        if  let data = try? Data(contentsOf: imgUrl!){//make sure your
                            let image = UIImage(data: data)
                            OperationQueue.main.addOperation({
                                if((image) != nil){
                                    self.user_Img.image = image
                                    ImageCaching.sharedInterface().setImage(image, withID: imgUrl?.absoluteString)
                                }
                            })
                        }else{
                            DispatchQueue.main.async{
                                self.user_Img.image = UIImage(named: "User");
                            }
                        }
                    }
                }
            }
        }
    }
   
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as UIView?
        let section    = headerView!.tag
        
        
        switch section {
        case 1:
            APP_Delegate.currentVC = "job"
            
            self.performSegue(withIdentifier: "pushJobs", sender: nil)
            
        case 2:
            APP_Delegate.currentVC = "client"
            self.performSegue(withIdentifier: "pushClient", sender: nil)
            
        case 3:
            
            APP_Delegate.currentVC = "settingVC"
            self.performSegue(withIdentifier: "pushSetting", sender: nil)
          
        case 5 :
         
            if !isHaveNetowork(){
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                return
            }
            APP_Delegate.currentVC = "quote"
            self.performSegue(withIdentifier: "pushQuote", sender: nil)
            
        case 6:
         
            APP_Delegate.currentVC = "auditvc"
            self.performSegue(withIdentifier: "pushAudit", sender: nil)
            
        case 7 :
         
            APP_Delegate.currentVC = "barcode"
            scanBarcode()
            
        case 8:
            if !isHaveNetowork(){
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                return
            }
            APP_Delegate.currentVC = "AdminChatVc"
            self.performSegue(withIdentifier: "pushAdminChat", sender: nil)
            
            
        case 9:
            if !isHaveNetowork(){
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                return
            }
            APP_Delegate.currentVC = "ExpenceVc"
            self.performSegue(withIdentifier: "pushExpence", sender: nil)
            
        case 10:
    
            APP_Delegate.currentVC = "CalenderVC"
            self.performSegue(withIdentifier: "pushCalendar", sender: nil)
            
        case 11:
            if !isHaveNetowork(){
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                return
            }
            APP_Delegate.currentVC = "Equipmentvc"
            self.performSegue(withIdentifier: "pushEquipment", sender: nil)
            
        case 12:
            if !isHaveNetowork(){
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                return
            }
            APP_Delegate.currentVC = "CheckInOutVC"
            self.performSegue(withIdentifier: "CheckInOutPush", sender: nil)
            
            
        case 13:
            if !isHaveNetowork(){
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                return
            }
            APP_Delegate.currentVC = "TimeSheetReportVC"
            self.performSegue(withIdentifier: "timeSheetPush", sender: nil)
            
        case 14:
            if !isHaveNetowork(){
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                return
            }
            APP_Delegate.currentVC = "LeaveUserListVC"
            self.performSegue(withIdentifier: "leaveReportPush", sender: nil)
            
        default:
            if !isHaveNetowork(){
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                return
            }
           
            if indicator == nil{
                
                
                startActivityIndicator(headerView: headerView!)
                getLocationForCheckInOut()
                
            }else{
                
               // print("indicator running")
            }
        }
      
    }
    
    @objc func StopTime() {
        self.intCounter = 0
        self.timer.invalidate()
        self.lblNameTimer.text = "00:00:00"
        self.lblCheckInOutTime.isHidden = true
       // print("Count stop")
        lblNameTimer.isHidden = true
        self.CheckOutIntimerOff == false
    }
    
    @objc func updateCountdown() {
        var TimeCountDoun = APP_Delegate.timerCountOneTime
        
        if  self.CheckOutIntimerOff == true{
          
            if TimeCountDoun == "False" {
                APP_Delegate.timerCountOneTime = "True"
                let checkTime = getCheckInOutTimeCount()
                let lastCheckIn = getDefaultSettings()?.lastCheckIn
              
                let checkInOutDefltTime = getCunvertLastCheckInDateTime
              //  intCounter = checkInOutDefltTime!
                intCounter = checkInOutDefltTime ?? 0
            
                intCounter += 1
                var timerSet = String(format: "%02d:%02d:%02d", intCounter / 3600, (intCounter % 3600) / 60, (intCounter % 3600) % 60)
                lblNameTimer.isHidden = false
                
                self.lblCheckInOutTime.isHidden = false
                // 1
                let string =  timerSet
                let attributedString = NSMutableAttributedString(string: string)
                
                // 2
                let firstAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black]
                let secondAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black,]
                let thirdAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.gray,
                    .font: UIFont.systemFont(ofSize: 10)]
                
                
                // 3
                attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 3))
                attributedString.addAttributes(secondAttributes, range: NSRange(location: 3, length: 3))
                attributedString.addAttributes(thirdAttributes, range: NSRange(location: 6, length: 2))
                
                // 4
                lblNameTimer.attributedText = attributedString
                
                
            }else{
                
                intCounter += 1
                
                saveCheckInOutTimeCount(checkinId:"\(intCounter)")
                var timerSet = String(format: "%02d:%02d:%02d", intCounter / 3600, (intCounter % 3600) / 60, (intCounter % 3600) % 60)
                lblNameTimer.isHidden = false
                self.lblCheckInOutTime.isHidden = false
                
                // 1
                let string =  timerSet
                let attributedString = NSMutableAttributedString(string: string)
                
                // 2
                let firstAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black]
                let secondAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black,]
                let thirdAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.gray,
                    .font: UIFont.systemFont(ofSize: 10)]
                
                
                // 3
                attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 3))//Testing_
                attributedString.addAttributes(secondAttributes, range: NSRange(location: 3, length: 3))//Attributed_
                attributedString.addAttributes(thirdAttributes, range: NSRange(location: 6, length: 2))//Attributed
                
                // 4
                lblNameTimer.attributedText = attributedString
                
            }
            
        }
        
    }
    
    @objc func updateCountdownForLogOut() {
      
        
        if  self.CheckOutIntimerOff == true{
            let checkInOutDefltTime = getCunvertLastCheckInDateTime
//            intCounter = checkInOutDefltTime!
            intCounter = checkInOutDefltTime ?? 0
            intCounter += 1
            
            saveCheckInOutTimeCount(checkinId:"\(intCounter)")
            var timerSet = String(format: "%02d:%02d:%02d", intCounter / 3600, (intCounter % 3600) / 60, (intCounter % 3600) % 60)
            lblNameTimer.isHidden = false
            self.lblCheckInOutTime.isHidden = false
            
            // 1
            let string =  timerSet
            let attributedString = NSMutableAttributedString(string: string)
            
            // 2
            let firstAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black]
            let secondAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,]
            let thirdAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 10)]
            
            // 3
            attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 3))//Testing_
            attributedString.addAttributes(secondAttributes, range: NSRange(location: 3, length: 3))//Attributed_
            attributedString.addAttributes(thirdAttributes, range: NSRange(location: 6, length: 2))//Attributed
            
            // 4
            lblNameTimer.attributedText = attributedString
     
        }
        
    }
    
    
    func scanBarcode() -> Void {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    
    func reloadTable() -> Void {
        let result = SideMenu.getModel()
        menus = result.0
        languageIndex = result.1
        
        DispatchQueue.main.async {
            self.lblLogout.text = LanguageKey.logout
            self.tableSideMenu.reloadData()
        }
    }
    
    func getLocationForCheckInOut() -> Void {
        
        //This location code will work properly only on real iOS device.
        
        if LocationManager.shared.isCheckLocation(){
            LocationManager.shared.isStatus = true
            LocationManager.shared.updateCurrentLocation { (isUpdate) in
                if isUpdate {
                    self.checkInCheckOutService(lat: LocationManager.shared.currentLattitude, lng: LocationManager.shared.currentLongitude)
                }
            }
        }else{
            self.checkInCheckOutService(lat: "0.0", lng: "0.0")
        }
       // self.checkInCheckOutService(lat: LocationManager.shared.currentLattitude, lng: LocationManager.shared.currentLongitude)
    }
    
    
    func checkInCheckOutService(lat:String,lng:String) -> Void {
        if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false) {
            
            if isAutoCheckoutEnable == false {
                let check = getCheckInId()
                if check == "" {
                    
                    // FOR DONO PERMISSION HIDE
                    
                    // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
                             var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
                             duration = updateDefaultTime(duration ?? "01:00")
                    let arrOFDurationTime = duration?.components(separatedBy: ":")
                    
                    // let currentTime : String? = getDefaultSettings()?.jobCurrentTime // old
                    let currentTime : String? = updateDefaultTime(getDefaultSettings()?.jobCurrentTime ?? "01:00")
                    
                    if(currentTime != "" && currentTime != nil){
                        let arrOFCurntTime = currentTime?.components(separatedBy: ":")
                        
                        let strDateTime = getSchuStartAndEndDateForAgoTimeDemo(Hrs:Int(arrOFCurntTime![0])!, min: Int(arrOFCurntTime![1])!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
                        
                        let arrTime = strDateTime.0.components(separatedBy: " ")
                        
                        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                            if enableCustomForm == "0"{
                                self.fulllocalTime =  arrTime[0] + " " + arrTime[1] + " " + arrTime[2]
                                self.localTime = arrTime[1] //+ " " + arrTime[2] // 12 HR FORMATE
                            }else{
                                self.fulllocalTime =  arrTime[0] + " " + arrTime[1]
                                self.localTime = arrTime[1]  // 24 HR FORMATE
                            }
                        }
                    }
                    
                    var checkid : String?
                    if let id = getCheckInId() {
                        if id != "" {
                            checkid = id
                        }
                    }
                    
                    let param = Params()
                    param.usrId = getUserDetails()?.usrId
                    param.time = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.yyyy_MM_dd_HH_mm_ss)
                    param.checkType = (checkid != nil) ? String(CheckType.checkout.rawValue) :  String(CheckType.checkin.rawValue)
                    param.checkId = (checkid != nil) ? checkid! : ""
                    param.lat = lat
                    param.lng = lng
                    
                    serverCommunicator(url: Service.addCheckInOutIime, param: param.toDictionary) { (response, success) in
                        
                        self.StopActivityIndicator()
                        // killLoader()
                        if(success){
                            let decoder = JSONDecoder()
                            if let decodedData = try? decoder.decode(CheckinResponse.self, from: response as! Data) {
                                if decodedData.success == true{
                                    saveCheckInId(checkinId: (decodedData.data?.checkId)!)
                                    LocalTimeSave(checkinId: self.localTime)
                                    fullLocalTimeSave(checkinId: self.fulllocalTime)
                                    
                                    let date = decodedData.data?.lastCheckIn
                                    if (date != "") {
                                        let islastCheckIn = (date != nil) ? convertTimeStampToString(timestamp: date ?? "", dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                                        fullLocalTimeSave(checkinId: islastCheckIn) //"23-09-2022 13:27"
                                    }
                                    DispatchQueue.main.async {
                                        if let check = getCheckInId() {
                                            if check == "" {
                                                APP_Delegate.timerCountOneTime = "True"
                                                self.CheckOutIntimerOff = false
                                                var checkInTime = getLocalTime()
                                                self.lblCheckInOutTime.text = checkInTime
                                                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.StopTime), userInfo: nil, repeats: false)
                                                
                                            }else{
                                                APP_Delegate.timerCountOneTime = "True"
                                                var checkInTime = getLocalTime()
                                                self.CheckOutIntimerOff = true
                                                self.lblCheckInOutTime.text = checkInTime
                                                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int(1.0))) {
                                                    self.updateCountdown()
                                                }
                                              //  self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
                                                
                                            }
                                        }
                                    }
                                    self.reloadTable()
                                    // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                }else{
                                    // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                }
                            }else{
                                ShowError(message: AlertMessage.formatProblem, controller: windowController)
                            }
                        }
                    }
                }else{
                    if isAutoCheckoutPopUp == true {
                        let storyboard = UIStoryboard(name: "CheckInOutAtchment", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "CheckInOutAtchemntVC") as! CheckInOutAtchemntVC
                        
                        vc.showCheckPoUp1 = isAutoCheckoutPopUp
                        vc.callbackAtch = {(modifiedImage,disc,time) in
                            vc.navigationController?.popViewController(animated: true)
                            self.chengOutCheckTime = time
                            
                            // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
                                     var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
                                     duration = updateDefaultTime(duration ?? "01:00")
                            let arrOFDurationTime = duration?.components(separatedBy: ":")
                            
                            // let currentTime : String? = getDefaultSettings()?.jobCurrentTime // old
                            let currentTime : String? = updateDefaultTime(getDefaultSettings()?.jobCurrentTime ?? "01:00")
                            if(currentTime != "" && currentTime != nil){
                                let arrOFCurntTime = currentTime?.components(separatedBy: ":")
                                
                                let strDateTime = getSchuStartAndEndDateForAgoTimeDemo(Hrs:Int(arrOFCurntTime![0])!, min: Int(arrOFCurntTime![1])!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
                                
                                let arrTime = strDateTime.0.components(separatedBy: " ")
                                
                                if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                                    if enableCustomForm == "0"{
                                        self.fulllocalTime =  arrTime[0] + " " + arrTime[1] + " " + arrTime[2]
                                        self.localTime = arrTime[1] //+ " " + arrTime[2] // 12 HR FORMATE
                                    }else{
                                        self.fulllocalTime =  arrTime[0] + " " + arrTime[1]
                                        self.localTime = arrTime[1]  // 24 HR FORMATE
                                    }
                                }
                                
                            }
                            
                            var checkid : String?
                            if let id = getCheckInId() {
                                if id != "" {
                                    checkid = id
                                }
                            }
                            
                            let param = Params()
                            param.usrId = getUserDetails()?.usrId
                            param.time = self.chengOutCheckTime//convertDateToStringForServer(date: Date(), dateFormate: DateFormate.ddMMMyyyy_hh_mm_ss_a)
                            param.checkType = (checkid != nil) ? String(CheckType.checkout.rawValue) :  String(CheckType.checkin.rawValue)
                            param.checkId = (checkid != nil) ? checkid! : ""
                            param.lat = lat
                            param.lng = lng
                            
                            serverCommunicator(url: Service.addCheckInOutIime, param: param.toDictionary) { (response, success) in
                                
                                self.StopActivityIndicator()
                                // killLoader()
                                if(success){
                                    let decoder = JSONDecoder()
                                    if let decodedData = try? decoder.decode(CheckinResponse.self, from: response as! Data) {
                                        if decodedData.success == true{
                                            saveCheckInId(checkinId: (decodedData.data?.checkId)!)
                                            LocalTimeSave(checkinId: self.localTime)
                                            fullLocalTimeSave(checkinId: self.fulllocalTime)
                                            
                                            let date = decodedData.data?.lastCheckIn
                                            if (date != "") {
                                                let islastCheckIn = (date != nil) ? convertTimeStampToString(timestamp: date ?? "", dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                                                fullLocalTimeSave(checkinId: islastCheckIn) //"23-09-2022 13:27"
                                            }
                                            DispatchQueue.main.async {
                                                if let check = getCheckInId() {
                                                    if check == "" {
                                                        APP_Delegate.timerCountOneTime = "True"
                                                        self.CheckOutIntimerOff = false
                                                        var checkInTime = getLocalTime()
                                                        self.lblCheckInOutTime.text = checkInTime
                                                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.StopTime), userInfo: nil, repeats: false)
                                                        
                                                        
                                                    }else{
                                                        APP_Delegate.timerCountOneTime = "True"
                                                        var checkInTime = getLocalTime()
                                                        self.CheckOutIntimerOff = true
                                                        self.lblCheckInOutTime.text = checkInTime
                                                        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int(1.0))) {
                                                            self.updateCountdown()
                                                        }
                                                        //self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
                                                        
                                                    }
                                                }
                                            }
                                            self.reloadTable()
                                            // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                        }else{
                                            // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                        }
                                    }else{
                                        ShowError(message: AlertMessage.formatProblem, controller: windowController)
                                    }
                                }
                            }
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        
                        
                        // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
                                 var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
                                 duration = updateDefaultTime(duration ?? "01:00")
                        let arrOFDurationTime = duration?.components(separatedBy: ":")
                        
                        // let currentTime : String? = getDefaultSettings()?.jobCurrentTime // old
                        let currentTime : String? = updateDefaultTime(getDefaultSettings()?.jobCurrentTime ?? "01:00")
                        if(currentTime != "" && currentTime != nil){
                            let arrOFCurntTime = currentTime?.components(separatedBy: ":")
                            
                            let strDateTime = getSchuStartAndEndDateForAgoTimeDemo(Hrs:Int(arrOFCurntTime![0])!, min: Int(arrOFCurntTime![1])!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
                            
                            let arrTime = strDateTime.0.components(separatedBy: " ")
                            
                            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                                if enableCustomForm == "0"{
                                    self.fulllocalTime =  arrTime[0] + " " + arrTime[1] + " " + arrTime[2]
                                    self.localTime = arrTime[1] //+ " " + arrTime[2] // 12 HR FORMATE
                                }else{
                                    self.fulllocalTime =  arrTime[0] + " " + arrTime[1]
                                    self.localTime = arrTime[1]  // 24 HR FORMATE
                                }
                            }
                            
                        }
                        
                        var checkid : String?
                        if let id = getCheckInId() {
                            if id != "" {
                                checkid = id
                            }
                        }
                        
                        let param = Params()
                        param.usrId = getUserDetails()?.usrId
                        param.time = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.yyyy_MM_dd_HH_mm_ss)
                        param.checkType = (checkid != nil) ? String(CheckType.checkout.rawValue) :  String(CheckType.checkin.rawValue)
                        param.checkId = (checkid != nil) ? checkid! : ""
                        param.lat = lat
                        param.lng = lng
                        
                        serverCommunicator(url: Service.addCheckInOutIime, param: param.toDictionary) { (response, success) in
                            
                            self.StopActivityIndicator()
                            // killLoader()
                            if(success){
                                let decoder = JSONDecoder()
                                if let decodedData = try? decoder.decode(CheckinResponse.self, from: response as! Data) {
                                    if decodedData.success == true{
                                        saveCheckInId(checkinId: (decodedData.data?.checkId)!)
                                        LocalTimeSave(checkinId: self.localTime)
                                        fullLocalTimeSave(checkinId: self.fulllocalTime)
                                        
                                        let date = decodedData.data?.lastCheckIn
                                        if (date != "") {
                                            let islastCheckIn = (date != nil) ? convertTimeStampToString(timestamp: date ?? "", dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                                            fullLocalTimeSave(checkinId: islastCheckIn) //"23-09-2022 13:27"
                                        }
                                        DispatchQueue.main.async {
                                            if let check = getCheckInId() {
                                                if check == "" {
                                                    APP_Delegate.timerCountOneTime = "True"
                                                    self.CheckOutIntimerOff = false
                                                    var checkInTime = getLocalTime()
                                                    self.lblCheckInOutTime.text = checkInTime
                                                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.StopTime), userInfo: nil, repeats: false)
                                                    
                                                    
                                                }else{
                                                    APP_Delegate.timerCountOneTime = "True"
                                                    var checkInTime = getLocalTime()
                                                    self.CheckOutIntimerOff = true
                                                    self.lblCheckInOutTime.text = checkInTime
                                                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int(1.0))) {
                                                        self.updateCountdown()
                                                    }
                                                    //self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
                                                    
                                                }
                                            }
                                        }
                                        self.reloadTable()
                                        // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                    }else{
                                        // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                    }
                                }else{
                                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }else{
                
                // FOR DONO PERMISSION HIDE
                
                // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
                         var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
                         duration = updateDefaultTime(duration ?? "01:00")
                let arrOFDurationTime = duration?.components(separatedBy: ":")
                
                // let currentTime : String? = getDefaultSettings()?.jobCurrentTime // old
                let currentTime : String? = updateDefaultTime(getDefaultSettings()?.jobCurrentTime ?? "01:00")
                
                if(currentTime != "" && currentTime != nil){
                    let arrOFCurntTime = currentTime?.components(separatedBy: ":")
                    
                    let strDateTime = getSchuStartAndEndDateForAgoTimeDemo(Hrs:Int(arrOFCurntTime![0])!, min: Int(arrOFCurntTime![1])!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
                    
                    let arrTime = strDateTime.0.components(separatedBy: " ")
                    
                    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                        if enableCustomForm == "0"{
                            self.fulllocalTime =  arrTime[0] + " " + arrTime[1] + " " + arrTime[2]
                            self.localTime = arrTime[1] //+ " " + arrTime[2] // 12 HR FORMATE
                        }else{
                            self.fulllocalTime =  arrTime[0] + " " + arrTime[1]
                            self.localTime = arrTime[1]  // 24 HR FORMATE
                        }
                    }
                    
                }
                
                var checkid : String?
                if let id = getCheckInId() {
                    if id != "" {
                        checkid = id
                    }
                }
                
                let param = Params()
                param.usrId = getUserDetails()?.usrId
                param.time = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.yyyy_MM_dd_HH_mm_ss)
                param.checkType = (checkid != nil) ? String(CheckType.checkout.rawValue) :  String(CheckType.checkin.rawValue)
                param.checkId = (checkid != nil) ? checkid! : ""
                param.lat = lat
                param.lng = lng
                
                serverCommunicator(url: Service.addCheckInOutIime, param: param.toDictionary) { (response, success) in
                    
                    self.StopActivityIndicator()
                    // killLoader()
                    if(success){
                        let decoder = JSONDecoder()
                        if let decodedData = try? decoder.decode(CheckinResponse.self, from: response as! Data) {
                            if decodedData.success == true{
                                saveCheckInId(checkinId: (decodedData.data?.checkId)!)
                                LocalTimeSave(checkinId: self.localTime)
                                fullLocalTimeSave(checkinId: self.fulllocalTime) //"23-09-2022 13:27"
                                
                                let date = decodedData.data?.lastCheckIn
                                if (date != "") {
                                    let islastCheckIn = (date != nil) ? convertTimeStampToString(timestamp: date ?? "", dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                                    fullLocalTimeSave(checkinId: islastCheckIn) //"23-09-2022 13:27"
                                }
                                
                                DispatchQueue.main.async {
                                    if let check = getCheckInId() {
                                        if check == "" {
                                            APP_Delegate.timerCountOneTime = "True"
                                            self.CheckOutIntimerOff = false
                                            var checkInTime = getLocalTime()
                                            self.lblCheckInOutTime.text = checkInTime
                                            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.StopTime), userInfo: nil, repeats: false)
                                            
                                        }else{
                                            APP_Delegate.timerCountOneTime = "True"
                                            var checkInTime = getLocalTime()
                                            self.CheckOutIntimerOff = true
                                            self.lblCheckInOutTime.text = checkInTime
                                            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int(1.0))) {
                                                self.updateCountdown()
                                            }
                                           // self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
                                            
                                        }
                                    }
                                }
                                self.reloadTable()
                                // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            }else{
                                // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            }
                        }else{
                            ShowError(message: AlertMessage.formatProblem, controller: windowController)
                        }
                    }
                }
            }
            
        }else{
            
            let storyboard = UIStoryboard(name: "CheckInOutAtchment", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CheckInOutAtchemntVC") as! CheckInOutAtchemntVC
            
            vc.showCheckPoUp1 = isAutoCheckoutPopUp
            vc.callbackAtch = {(modifiedImage,disc,time) in
                vc.navigationController?.popViewController(animated: true)
                self.uploadImageLoad = modifiedImage
                self.chengOutCheckTime = time
                // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
                         var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
                         duration = updateDefaultTime(duration ?? "01:00")
                let arrOFDurationTime = duration?.components(separatedBy: ":")
                
                // let currentTime : String? = getDefaultSettings()?.jobCurrentTime // old
                let currentTime : String? = updateDefaultTime(getDefaultSettings()?.jobCurrentTime ?? "01:00")
                if(currentTime != "" && currentTime != nil){
                    let arrOFCurntTime = currentTime?.components(separatedBy: ":")
                    
                    let strDateTime = getSchuStartAndEndDateForAgoTimeDemo(Hrs:Int(arrOFCurntTime![0])!, min: Int(arrOFCurntTime![1])!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
                    
                    let arrTime = strDateTime.0.components(separatedBy: " ")
                    
                    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                        if enableCustomForm == "0"{
                            self.fulllocalTime =  arrTime[0] + " " + arrTime[1] + " " + arrTime[2]
                            self.localTime = arrTime[1] //+ " " + arrTime[2] // 12 HR FORMATE
                        }else{
                            self.fulllocalTime =  arrTime[0] + " " + arrTime[1]
                            self.localTime = arrTime[1]  // 24 HR FORMATE
                        }
                    }
                    
                }
                
                var checkid : String?
                if let id = getCheckInId() {
                    if id != "" {
                        checkid = id
                    }
                }
                
                let yourImage: UIImage = UIImage(named: "default-thumbnail")!
                let param = Params()
                param.usrId = getUserDetails()?.usrId
                let check = getCheckInId()
                if check == "" {
                    param.time = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.yyyy_MM_dd_HH_mm_ss)
                }else{
                    if self.isAutoCheckoutEnable == false {
                        if self.isAutoCheckoutPopUp == true {
                            param.time = self.chengOutCheckTime
                        }else{
                            param.time = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.yyyy_MM_dd_HH_mm_ss)
                        }
                    }else{
                        param.time = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.yyyy_MM_dd_HH_mm_ss)
                    }
                }
                
                param.checkType = (checkid != nil) ? String(CheckType.checkout.rawValue) :  String(CheckType.checkin.rawValue)
                param.checkId = (checkid != nil) ? checkid! : ""
                param.lat = lat
                param.lng = lng
                param.desc = disc
                
                if yourImage == self.uploadImageLoad {
                    
                    serverCommunicator(url: Service.addCheckInOutIime, param: param.toDictionary) { (response, success) in
                        
                        self.StopActivityIndicator()
                        // killLoader()
                        if(success){
                            let decoder = JSONDecoder()
                            if let decodedData = try? decoder.decode(CheckinResponse.self, from: response as! Data) {
                                if decodedData.success == true{
                                    saveCheckInId(checkinId: (decodedData.data?.checkId)!)
                                    LocalTimeSave(checkinId: self.localTime)
                                    fullLocalTimeSave(checkinId: self.fulllocalTime)
                                    
                                    let date = decodedData.data?.lastCheckIn
                                    if (date != "") {
                                        let islastCheckIn = (date != nil) ? convertTimeStampToString(timestamp: date ?? "", dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                                        fullLocalTimeSave(checkinId: islastCheckIn) //"23-09-2022 13:27"
                                    }
                                    DispatchQueue.main.async {
                                        if let check = getCheckInId() {
                                            if check == "" {
                                                APP_Delegate.timerCountOneTime = "True"
                                                self.CheckOutIntimerOff = false
                                                var checkInTime = getLocalTime()
                                                self.lblCheckInOutTime.text = checkInTime
                                                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.StopTime), userInfo: nil, repeats: false)
                                                
                                            }else{
                                                APP_Delegate.timerCountOneTime = "True"
                                                var checkInTime = getLocalTime()
                                                self.CheckOutIntimerOff = true
                                                self.lblCheckInOutTime.text = checkInTime
                                                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int(1.0))) {
                                                    self.updateCountdown()
                                                }
                                               // self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
                                                print("Count start")
                                            }
                                        }
                                    }
                                    self.reloadTable()
                                    // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                }else{
                                    // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                }
                            }else{
                                ShowError(message: AlertMessage.formatProblem, controller: windowController)
                            }
                        }
                    }
                }else{
                    serverCommunicatorUplaodImage(url: Service.addCheckInOutIime, param: param.toDictionary, image: self.uploadImageLoad, imagePath: "attachment", imageName: "") { (response, success) in
                        
                        self.StopActivityIndicator()
                        // killLoader()
                        if(success){
                            let decoder = JSONDecoder()
                            if let decodedData = try? decoder.decode(CheckinResponse.self, from: response as! Data) {
                                if decodedData.success == true{
                                    saveCheckInId(checkinId: (decodedData.data?.checkId)!)
                                    LocalTimeSave(checkinId: self.localTime)
                                    fullLocalTimeSave(checkinId: self.fulllocalTime)
                                    
                                    let date = decodedData.data?.lastCheckIn
                                    if (date != "") {
                                        let islastCheckIn = (date != nil) ? convertTimeStampToString(timestamp: date ?? "", dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                                        fullLocalTimeSave(checkinId: islastCheckIn) //"23-09-2022 13:27"
                                    }
                                    DispatchQueue.main.async {
                                        if let check = getCheckInId() {
                                            if check == "" {
                                                APP_Delegate.timerCountOneTime = "True"
                                                self.CheckOutIntimerOff = false
                                                var checkInTime = getLocalTime()
                                                self.lblCheckInOutTime.text = checkInTime
                                                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.StopTime), userInfo: nil, repeats: false)
                                                
                                            }else{
                                                APP_Delegate.timerCountOneTime = "True"
                                                var checkInTime = getLocalTime()
                                                self.CheckOutIntimerOff = true
                                                self.lblCheckInOutTime.text = checkInTime
                                                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int(1.0))) {
                                                    self.updateCountdown()
                                                }
                                                //self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
                                                
                                            }
                                        }
                                    }
                                    self.reloadTable()
                                    // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                }else{
                                    // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                }
                            }else{
                                ShowError(message: AlertMessage.formatProblem, controller: windowController)
                            }
                        }
                    }
                }
                
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func ShowPopUp () {
        
        let alert = UIAlertController(title: LanguageKey.detail_scan_barcode, message: nil , preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "8-767289-200"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: LanguageKey.done, style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if textField!.text!.count > 0 {
                self.getEquipmentListOfflineBarcodeScanner(barcodeString: textField!.text!)
                //self.getEquipmentListFromBarcodeScanner(barcodeString: textField!.text!)
            }else{
                self.showToast(message: "Please enter valid barcode")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: LanguageKey.cancel, style: .default, handler: nil ))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func getEquipmentListOfflineBarcodeScanner(barcodeString : String) -> Void{
       
        forequipmentbarcode = barcodeString
        var equpDataArrayAudit = [equipDataArray]()
        // var sNo:String = ""
        //let query = "audId = '\(job.audId!)'"
        let isExistAudit = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: nil) as! [AuditOfflineList]
        if isExistAudit.count > 0 {
            equpDataArrayAudit.removeAll()
            
            for audit in isExistAudit {
                for item in (audit.equArray as! [AnyObject]) {
                    
                    if item["barcode"] as? String == barcodeString
                        
                    {
                        
                        
                        var arrTac = [AttechmentArry]()
                        
                        if item["attachments"] != nil {
                            
                            
                            if (item["attachments"] is [AnyObject]) && ((item["attachments"] as! [AnyObject]).count > 0) {
                                let attachments =  item["attachments"] as! [AnyObject]
                                for attechDic in attachments {
                                    arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                                }
                                
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                // equipmentData.append(dic)
                                equpDataArrayAudit.append(dic)
                                // print(equipmentDic.self)
                                
                                // if let dta = item as? equipData {
                                // }
                            }else {
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                // equipmentData.append(dic)
                                equpDataArrayAudit.append(dic)
                            }
                            
                            
                        }else {
                            
                            
                            let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:[], type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                            //
                            equpDataArrayAudit.append(dic)
                        }
                    }
                    
                    
                }
            }
            
        }
        var equpDataArrayJob = [equipDataArray]()
        // var sNo:String = ""
        let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: nil) as! [UserJobList]
        if isExistJob.count > 0 {
            equpDataArrayJob.removeAll()
            // equpDataArray.append(isExistAudit[0].equArray as! AuditOfflineList)
            for job in isExistJob {
                for item in (job.equArray as! [AnyObject]) {
                    
                    if item["barcode"] as? String == barcodeString
                        
                    {
                        
                        
                        var arrTac = [AttechmentArry]()
                        
                        if item["attachments"] != nil {
                            
                            
                            if (item["attachments"] is [AnyObject]) && ((item["attachments"] as! [AnyObject]).count > 0) {
                                let attachments =  item["attachments"] as! [AnyObject]
                                for attechDic in attachments {
                                    arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                                }
                                
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                // equipmentData.append(dic)
                                equpDataArrayJob.append(dic)
                                // print(equipmentDic.self)
                                
                                // if let dta = item as? equipData {
                                // }
                            }else {
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                // equipmentData.append(dic)
                                equpDataArrayJob.append(dic)
                            }
                            
                            
                        }else
                        {
                            
                            
                            let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:[], type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                            equpDataArrayJob.append(dic)
                        }
                        
                    }
                    
                    
                }
            }
        }
        
        
        var arrOFAdminEquipData = [AdminEquipmentList]()
        var arrFilterData = [EquipListDataModel]()
        arrOFAdminEquipData   = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AdminEquipmentList", query: nil) as! [AdminEquipmentList]
        
        if arrOFAdminEquipData.count>0 {
            
            for job in arrOFAdminEquipData {
                
                if job.barcode == barcodeString as String
                {
                    let dic = EquipListDataModel(equId: job.equId, parentId: job.parentId, equnm: job.equnm, cltId: job.cltId, nm: job.nm, mno: job.mno, sno: job.sno, brand: job.brand, rate: job.rate, supId: job.supId, supplier: job.supplier, notes: job.notes, expiryDate: job.expiryDate, manufactureDate: job.manufactureDate, purchaseDate: job.purchaseDate, barcode: job.barcode, isusable: job.isusable, barcodeImg: job.barcodeImg, adr: job.adr, city: job.city, state: job.state, ctry: job.ctry, zip: job.zip, status: job.status, type: job.type, ecId: job.equId, egId: job.egId, ebId: job.ebId, isdelete: job.isdelete, groupName: job.groupName, image: job.image, isDisable: job.isDisable, updateDate: job.updateDate, lastAuditLabel: job.lastAuditLabel, lastAuditDate: job.lastAuditDate, equStatusOnAudit: job.equStatusOnAudit, lastAudit_id: job.lastAudit_id, lastJobLabel: job.lastJobLabel, lastJobDate: job.lastJobDate, equStatusOnJob: job.equStatusOnJob, lastJob_id: job.lastJob_id)
                    
                    arrFilterData.append(dic)
                    
                }
                
                
            }
        }
        
        
        
        let jobBarcode = equpDataArrayJob.filter({$0.barcode == barcodeString})
        let auditBarcode = equpDataArrayAudit.filter({$0.barcode == barcodeString})
        let adminEquipBarcode = arrFilterData.filter({$0.barcode == barcodeString})
        
        if jobBarcode.count != 0 && auditBarcode.count != 0 {
            //2
            let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
            vc.equipmentDetailAudit = equpDataArrayAudit
            vc.equipmentDetailJob = equpDataArrayJob
            vc.barcodeString = barcodeString
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if jobBarcode.count != 0 {
            
            // MARK:- On Line get Equipment By Barcode : -
            
            self.getEquipmentList()
            
            // MARK:- Off Line get Equipment By Barcode : -
            
//            let vc = UIStoryboard(name: "MainAudit", bundle: nil).instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc;
//
//            vc.equipmentDetailJob = equpDataArrayJob
//            vc.barcodeString = barcodeString
//
//            self.navigationController?.isNavigationBarHidden = false
//            self.navigationController?.pushViewController(vc, animated: true)
            
            
        } else if auditBarcode.count != 0 {
            
            if auditBarcode.count>1 {
                
                let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
                vc.equipmentDetailAudit = equpDataArrayAudit
                vc.barcodeString = barcodeString
                
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else{
                
                let vc = UIStoryboard(name: "MainAudit", bundle: nil).instantiateViewController(withIdentifier: "remarkTab") as! RemarkVC;
                vc.isPresented = true
                vc.equipment = equpDataArrayAudit[0]
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }else if adminEquipBarcode.count != 0 {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
            vc.adminEquipment = arrFilterData
            vc.barcodeString = barcodeString
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        else{
            
            self.showToast(message: "Equipment not found")
            
        }
        
    }
    
    //==================================
    // MARK:- Equipement LIST Service methods
    //==================================
    func getAdminEquipementList(){
        
        if !isHaveNetowork() {
            // if self.refreshControl.isRefreshing {
            //   self.refreshControl.endRefreshing()
            // }
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        
        
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getEquipmentList) as? String
        let param = Params()
        
        param.limit = "300"
        param.index = "0"
        param.search = ""
        param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
        
        // limit, index, search, dateTime
        
        
        
        serverCommunicator(url: Service.getEquipmentList, param: param.toDictionary) { (response, success) in
            
            //               DispatchQueue.main.async {
            //                   if self.refreshControl.isRefreshing {
            //                       self.refreshControl.endRefreshing()
            //                   }
            //               }
            
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(AdminEquipListResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data!.count > 0 {
                            //self.equipments = decodedData.data!
                            
                            if !self.isUserfirstLogin {
                                
                                self.saveUserJobsInDataBase(data: decodedData.data!)
                                
                                //Request time will be update when data comes otherwise time won't be update
                                UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getEquipmentList)
                                
                                
                                //self.showDataOnTableView(query: nil) //Show joblist on tableview
                                
                            }else{
                                self.saveAllUserJobsInDataBase(data: decodedData.data!)
                            }
                            
                            DispatchQueue.main.async {
                                //  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                // self.tableView.reloadData()
                                killLoader()
                            }
                        }else{
                            //   print("jugal")
                            //self.equipments.removeAll()
                            DispatchQueue.main.async {
                                // self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                //self.tableView.reloadData()
                            }
                            
                            killLoader()
                        }
                    }else{
                        killLoader()
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        
                        if cancel {
                            showLoader()
                            self.getAdminEquipementList()
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getAdminEquipementList()
                    }
                })
            }
        }
    }
    
    //===========================================
    // MARK:- save offline  in AdminEquipmentList
    //============================================
    
    
    func saveAllUserJobsInDataBase( data : [AdminEquipListData]) -> Void {
        for job in data{
            if(job.isdelete != "0"){
                if (Int(job.status!) != taskStatusType.Cancel.rawValue) &&
                    (Int(job.status!) != taskStatusType.Reject.rawValue) &&
                    (Int(job.status!) != taskStatusType.Closed.rawValue)
                {
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "AdminEquipmentList")
                    userJobs?.setValuesForKeys(job.toDictionary!)
                    // DatabaseClass.shared.saveEntity()
                }
            }
        }
    }
    
    
    func saveUserJobsInDataBase( data : [AdminEquipListData]) -> Void {
        
        for job in data{
            let query = "equId = '\(job.equId!)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AdminEquipmentList", query: query) as! [AdminEquipmentList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                //if Job status Cancel, Reject, Closed so this job is delete from Database
                
                if(job.isdelete == "0") {
                    ChatManager.shared.removeJobForChat(jobId: existingJob.equId!)
                    DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                }else if (Int(job.status!) == taskStatusType.Cancel.rawValue) ||
                            (Int(job.status!) == taskStatusType.Reject.rawValue) ||
                            (Int(job.status!) == taskStatusType.Closed.rawValue)
                {
                    ChatManager.shared.removeJobForChat(jobId: existingJob.equId!)
                    DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                }else{
                    existingJob.setValuesForKeys(job.toDictionary!)
                    // DatabaseClass.shared.saveEntity()
                }
            }else{
                if(job.isdelete != "0") {
                    if (Int(job.status!) != taskStatusType.Cancel.rawValue) &&
                        (Int(job.status!) != taskStatusType.Reject.rawValue) &&
                        (Int(job.status!) != taskStatusType.Closed.rawValue)
                    {
                        let userJobs = DatabaseClass.shared.createEntity(entityName: "AdminEquipmentList")
                        userJobs?.setValuesForKeys(job.toDictionary!)
                        //DatabaseClass.shared.saveEntity()
                        
                        let query = "equId = '\(job.tempId ?? "")'"
                        let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AdminEquipmentList", query: query) as! [AdminEquipmentList]
                        
                        if isExistJob.count > 0 {
                            let existing = isExistJob[0]
                            DatabaseClass.shared.deleteEntity(object: existing, callback: { (_) in})
                        }
                        
                    }
                }
            }
        }
        // getClientListFromDBjob()
        
    }
    
    func saveAllGetDataInDatabase(callback:(Bool)  -> Void) -> Void {
        //  self.count = 0
        DatabaseClass.shared.saveEntity(callback: callback)
    }
    
    //===================================
    // MARK:- Equipement getEquipmentList
    //===================================
    func getEquipmentList(){
        
        if !isHaveNetowork() {
            
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
       // showLoader()
        
        let param = Params()
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getEquipmentList) as? String
        param.limit = "120"
        param.index = "0"
        param.search = ""
        param.activeRecord = "1"
        param.expiry_dtf = ""
        param.expiry_dtt = ""
        param.type = "1"
        param.audId = ""
        param.isParent = "0"
        param.contrId = ""
        param.cltId = ""
        param.barCode = forequipmentbarcode
        print(param.toDictionary)
        serverCommunicator(url: Service.getEquipmentList, param: param.toDictionary) { (response, success) in
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(LinkEquipmentForONlIneRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data!.count > 0 {
                            self.LinkEquipmentData = decodedData.data as! [equipDataArray]
                            DispatchQueue.main.async {
                            let vc = UIStoryboard(name: "MainAudit", bundle: nil).instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc;
                            
                            vc.equipmentDetailJob = self.LinkEquipmentData  //equpDataArrayJob // LinkEquipmentData
                            vc.barcodeString = self.forequipmentbarcode
                            
                            self.navigationController?.isNavigationBarHidden = false
                            self.navigationController?.pushViewController(vc, animated: true)
                           killLoader()
                            }
                    }else{
                        killLoader()
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        
                        if cancel {
                            showLoader()
                            
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        
                    }
                })
            }
            
            
        }
        
    }
    
}
    
    
    //==========================================
    // MARK:- Get getJobStatusList List Service
    //==========================================
    
     func getJobStatusList(){

            let param = Params()
            param.index = "0"
            param.search = ""
            param.limit = "120"
      
            serverCommunicator(url: Service.getJobStatusList, param: param.toDictionary) { (response, success) in
               // killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(JobStatusListRes.self, from: response as! Data) {

                        if decodedData.success == true{
                            self.saveJobStatusList(data: decodedData.data! )
                           
                            
                          //  self.jobStatusArr = decodedData.data as! [JobStatusListResData]
                           
                        }else{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{

                        ShowError(message: AlertMessage.formatProblem, controller: windowController)
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
                }
            }
            
        }

    //===================================================
    // MARK:- Save getJobStatusList data in DataBase
    //===================================================
    
    func saveJobStatusList( data : [JobStatusListResData]) -> Void {
        for jobs in data{
         let query = "id = '\(String(describing: jobs.id ?? ""))'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: query) as! [JobStatusList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                existingJob.setValuesForKeys(jobs.toDictionary!)
               // DatabaseClass.shared.saveEntity()
            }else{
                let userJobs = DatabaseClass.shared.createEntity(entityName: "JobStatusList")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
               // DatabaseClass.shared.saveEntity()
            }
        }
        
         DatabaseClass.shared.saveEntity(callback: { _ in })
        
    }
}

//



extension SideMenuVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let menu = menus[section]
        if menu.id == 3 && menu.isCollaps == true {
            return menu.subMenu.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let menu = menus[section]
        if  (menu.id == 4) {
           
            if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
                if isAutoTimeZone == "0"{
                    return 60.0
                }else{
                    return 110.0
                }
            }
        }else{
            return 50.0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var hightView:CGFloat? = 0
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                hightView = 60
            }else{
                hightView = 110
            }
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: hightView!));
        
        let menu = menus[section]
        
        let theImageView = UIImageView(frame: CGRect(x: 10, y: 12, width: 25, height: 25));
        theImageView.image = UIImage(named: menu.image)
        headerView.addSubview(theImageView)
        
        
        
        // let saprator = UILabel(frame: CGRect(x: 43, y: 49, width: 197, height: 1))
        //  saprator.backgroundColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 0.6)
        // headerView.addSubview(saprator)
        
        let headerTapGesture = UITapGestureRecognizer()
        headerView.tag = menu.id
        headerTapGesture.addTarget(self, action: #selector(sectionHeaderWasTouched(_:)))
        headerView.addGestureRecognizer(headerTapGesture)
        
        if  (menu.id == 4) {
            if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
                if isAutoTimeZone == "0"{
                    // ========FORBOTEMLINE=============
                    shoeTimeZoneImg.isHidden = true
                    shoeTimeZonebutton.isHidden = true
                    shoeTimeZone.isHidden = true
                    let labelLine = UILabel(frame:  CGRect(x: 20, y: 52, width: 2000, height: 0.5))
                    labelLine.backgroundColor = .lightGray
                    labelLine.numberOfLines = 0
                    headerView.addSubview(labelLine)
                }else{
                   
                    
                    // ========FORBOTEMLINE=============
                    shoeTimeZoneImg.isHidden = false
                    shoeTimeZonebutton.isHidden = false
                    shoeTimeZone.isHidden = false
                    let labelLine = UILabel(frame:  CGRect(x: 20, y: 110, width: 2000, height: 0.5))
                    labelLine.backgroundColor = .lightGray
                    labelLine.numberOfLines = 0
                    headerView.addSubview(labelLine)
                }
            }
            
            // ========FORBOTEMLINEImage=============
           
            shoeTimeZoneImg.image = UIImage(named:"TimeZoneImg")
            headerView.addSubview(shoeTimeZoneImg)
            
            // ========FORCHECKINOUTTIME=============
            lblCheckInOutTime.font = UIFont.systemFont(ofSize: 12.0)
            lblCheckInOutTime.textColor = .lightGray
            lblCheckInOutTime.numberOfLines = 0
            headerView.addSubview(lblCheckInOutTime)
            
            // ========SHOWTIMEZONE=============
            shoeTimeZone.font = UIFont.systemFont(ofSize: 12.0)
            shoeTimeZone.textColor = .lightGray
            shoeTimeZone.numberOfLines = 0
           // shoeTimeZone.backgroundColor = .red
            headerView.addSubview(shoeTimeZone)
            
            // ========NAMETIMER=============
            lblNameTimer.font = UIFont.systemFont(ofSize: 15.0)
            lblNameTimer.textColor = UIColor(red:0/255, green:132/255, blue:141/255, alpha: 1)
            lblNameTimer.numberOfLines = 0
            headerView.addSubview(lblNameTimer)
            
            
            // ========LABELNAME=============
            let lblName = UILabel(frame: CGRect(x: 50, y: 03, width: 183, height: 40))
            lblName.text = menu.name
            lblName.font = UIFont.systemFont(ofSize: 15.0)
            lblName.textColor = UIColor(red: 115.0/225.0, green: 125.0/255, blue: 126.0/255.0, alpha: 0.8)
            lblName.numberOfLines = 0
            headerView.addSubview(lblName)
            
            // ========backgroundButtionDisable=============
            shoeTimeZonebutton.backgroundColor = .clear
            headerView.addSubview(shoeTimeZonebutton)
            
        }else{
            let lblName = UILabel(frame: CGRect(x: 50, y: 12, width: 183, height: 25))
            lblName.text = menu.name
            lblName.font = UIFont.systemFont(ofSize: 15.0)
            lblName.textColor = UIColor(red: 115.0/225.0, green: 125.0/255, blue: 126.0/255.0, alpha: 0.8)
            headerView.addSubview(lblName)
        }
        
        if (indicator != nil) && (menu.id == 4) {
            if indicator!.isAnimating{
                
                var isActivityIndStop = ""
                isActivityIndStop = UserDefaults.standard.value(forKey: "activityIndcaterStop") as? String ?? ""
                
                
                if isActivityIndStop == "True" {
                    self.startActivityIndicator(headerView: headerView)
                    self.StopActivityIndicator() // for remove checkin view
                }else{
                    self.startActivityIndicator(headerView: headerView)
                }
                
            }
        }
        
        
        if menu.id == 8 {
            
            let count = ChatManager.shared.userModels.reduce(0) {$0 + Int($1.unreadCount ?? "0")!}
            // print("current count = \(count)")
            //print("side menu user model === \(ChatManager.shared.userModels.count)")
            if count > 0 {
                let countlabel = UILabel(frame: CGRect(x: 210, y: 15, width: 15 + (5*count.description.count), height: 20))
                countlabel.backgroundColor = .red
                countlabel.text = "\(count)"
                countlabel.textColor = .white
                countlabel.layer.cornerRadius = 10.0
                countlabel.layer.masksToBounds = true
                countlabel.textAlignment = .center
                countlabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
                headerView.addSubview(countlabel)
            }
        }
        
        
        headerView.backgroundColor = .white
        
        return headerView
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenu") as! SideMenuCell
        let menu = menus[languageIndex].subMenu as! [languageDetails]
        let language = menu[indexPath.row]
        cell.lblJob.text = language.nativeName
        
        if let currentLang = getCurrentSelectedLanguage(){
            if currentLang == language.nativeName {
                // cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                cell.imgCheck.isHidden = false
            }else{
                // cell.accessoryType = UITableViewCell.AccessoryType.none
                cell.imgCheck.isHidden = true
            }
        }else{
            // cell.accessoryType = UITableViewCell.AccessoryType.none
            cell.imgCheck.isHidden = true
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
      //  showLoader()ji
        
        ShowAlert(title: LanguageKey.confirmation, message: LanguageKey.changeLanguage, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.done as NSString, style: .alert) { (cancel, ok) in
            if ok {
                
                let languageModel : languageDetails = (getDefaultSettings()?.languageList![indexPath.row])!
                
                LanguageManager.shared.setLanguage(filename: languageModel.fileName!, filePath: languageModel.filePath!, languageName: languageModel.nativeName!, version: languageModel.version!, alert: true, callBack: { (success) in
                    if success {
                        self.reloadTable()
                        self.setVersion()
                        killLoader()
                        self.revealViewController()?.revealToggle(animated: true)
                    }
                })
            }
            
            if cancel {
                killLoader()
            }
            
        }
    }
    
    func startActivityIndicator(headerView : UIView) -> Void {
        indicator = UIActivityIndicatorView()
        indicator = UIActivityIndicatorView(frame: CGRect(x: 210, y: 20, width: 10, height: 10))
        indicator!.style = UIActivityIndicatorView.Style.gray
        indicator!.backgroundColor = UIColor.white
        indicator!.hidesWhenStopped = true
        
        DispatchQueue.main.async {
            self.indicator!.startAnimating()
            headerView.addSubview(self.indicator!)
        }
    }
    
    func StopActivityIndicator() -> Void {
        if indicator != nil{
            DispatchQueue.main.async {
                if self.indicator != nil{
                self.indicator!.stopAnimating()
                self.indicator = nil
                }
                    
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let menu = menus[indexPath.row]
        if  (menu.id == 4) {
            return 100.0
        }else{
            return 50.0
        }
        
        // return 50.0
    }
    
}



extension SideMenuVC : BarcodeScannerErrorDelegate, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        //   print(code)
        getEquipmentListOfflineBarcodeScanner(barcodeString: code)
        UserDefaults.standard.set(code, forKey: "barcodeString")
        //  getEquipmentListFromBarcodeScanner(barcodeString: code)
        controller.dismiss(animated: true, completion: {
            controller.reset()
        }
        )
    }
    
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        //  print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
