//
//  LoginVC.swift
//  EyeOnTask
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import CoreLocation
@available(iOS 13.0, *)
class LoginVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, SWRevealViewControllerDelegate {

    var isForgot: Bool = false
    
    var staticLabelFwKeyValData: String?
    var UserJobListArr = [UserJobList]()
    var CustomAnsArr = [CustomAns]()
    var jobStatusListArr = [JobStatusList]()
    var CustomFormNmListArr = [CustomFormNmList]()
    var arrOfflineTax = [TaxList]()
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var btnShowHidePass: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnUseAnother: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var btnAlreadyForgtPass: UIButton!
    @IBOutlet weak var btnBackLoginForgtPss: UIButton!
    @IBOutlet weak var btnSubmitForgtPass: UIButton!
    @IBOutlet weak var lblDecForgtPass: UILabel!
    @IBOutlet weak var lblPassRecForgtPass: UILabel!
    @IBOutlet weak var lblForgotPass: UILabel!
    @IBOutlet weak var lbldecMultcom: UILabel!
    @IBOutlet weak var btnBacktoLoginConfrm: UIButton!
    @IBOutlet weak var btnResetPassConfrm: UIButton!
    @IBOutlet weak var lblPassRecConfrm: UILabel!
    @IBOutlet weak var lblConfirmPass: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancelMltCom: UIButton!
    @IBOutlet weak var btnDontHavekey: UIButton!
    @IBOutlet weak var btnBackloginkey: UIButton!
    @IBOutlet weak var btnResetPassKey: UIButton!
    @IBOutlet weak var lblPlsenterPassReset: UILabel!
    @IBOutlet weak var lblPasswordRecKey: UILabel!
    @IBOutlet weak var lblEnterkey: UILabel!
    @IBOutlet weak var btnRememberMe: UIButton!
    @IBOutlet var imgVw_checklMark: UIImageView!
    @IBOutlet var userTxtfld: UITextField!
    @IBOutlet var passwrdTxtfld: UITextField!
    @IBOutlet var forgetPswdView: UIView!
    @IBOutlet var frgtPswdBackgrndView: UIView!
    @IBOutlet var txtFieldForgotPass: UITextField!
    @IBOutlet var multipleCompanyView: UIView!
    @IBOutlet var forgotPasswordKeyView: UIView!
    @IBOutlet var frgtpswdKey: UITextField!
    @IBOutlet var confrmPswdView: UIView!
    @IBOutlet var cnfPswdTxtfld: UITextField!
    @IBOutlet var newPswdTxtfld: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logo_Height: NSLayoutConstraint!
    @IBOutlet weak var logo_width: NSLayoutConstraint!
    @IBOutlet weak var logo_Y: NSLayoutConstraint!
    
    var subcriptionData:SubcriptionResponse?
    var buttonIsSelected = false
    var forgotView_Y : CGFloat?
    var insertEmail : String?
    var usrerId: String?
    var currentCompanyCode: String? = ""
    var companies = [String]()
    var selectedCompanyIndex : Int = 0
    var multiCompanyArr = ["one", "Two", "Three"]
    var selectedElement = [Int : String]()


    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var pswdView: UIView!
    @IBOutlet weak var emailDisplayLbl: UILabel!
    @IBOutlet weak var btnDsplayEmail: UIButton!
    
    
    //========================================================
    // MARK:- Initial methods
    //========================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(firstUrl)
        
      //  UserDefaults.standard.set(firstUrl, forKey: "RedisUrl")
        //UserDefaults.standard.set(true, forKey: "myFirstLoging")
        
     
        pswdView.isHidden = true
       
        frgtPswdBackgrndView.isHidden = true
        self.forgetPswdView.isHidden = true

        forgotView_Y =  self.forgetPswdView.frame.origin.y
        self.forgetPswdView.frame.origin.y -= forgotView_Y! + self.forgetPswdView.frame.size.height
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                self.navigationController?.isNavigationBarHidden = true
                APP_Delegate.apiCallFirstTime = true

                 NotiyCenterClass.removeRefreshJobListNotifier(vc: self)
                 NotiyCenterClass.removeJobRemoveNotifier(vc: self)
        
                DatabaseClass.shared.isSync = false
              //  ChatManager.shared.removeAllListeners()
                
                pswdView.isHidden = true
                userView.isHidden = false
                // authenticationToken = ""
                // emailDisplayLbl.text = getUserDetails()?.username
                

                if UIScreen.main.sizeType == .iPhone4 {
                    self.logo_width.constant = 60
                    self.logo_Height.constant = 60
                    self.logo_Y.constant = 45
                }
        
                if UIScreen.main.sizeType == .iPhone5 {
                    self.logo_width.constant = 70
                    self.logo_Height.constant = 70
                    self.logo_Y.constant = 25
                  
                   
                }
        
                 if UIScreen.main.sizeType == .iPhoneSE {
                    self.logo_Y.constant = 20
                  }
        
                if UIScreen.main.sizeType == .iPhoneX {
                    self.logo_Y.constant = 10
                 }
        
        
                 if UIDevice.current.hasNotch {
                    self.logo_Y.constant = 110
                 }
                
                
                currentCompanyCode = ""
                
                let username =  UserDefaults.standard.value(forKey: "username") as? String
               // let password = UserDefaults.standard.value(forKey: "password") as? String
        
                if let usernm = username {
                    emailDisplayLbl.text = " \(usernm)        "
                }else{
                    emailDisplayLbl.text = ""
                }
        
        
                
               // DispatchQueue.main.async{
                     let isSelected = UserDefaults.standard.value(forKey: "isSelected") as? Bool
                      let isAlreadyLogin = UserDefaults.standard.value(forKey: "login") as? Bool
        
        
                    if  (currentRegion() != nil && isAlreadyLogin != nil && isAlreadyLogin == true) || (currentRegion() != nil && isSelected != nil && isSelected == true)  {
                        
                       // if isSelected != nil && isSelected == true{
                            self.btnRememberMe.isSelected = true
                            self.btnRememberMe.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
                            self.userTxtfld.text = UserDefaults.standard.value(forKey: "username") as? String
                            self.passwrdTxtfld.text = UserDefaults.standard.value(forKey: "password") as? String
                       // }
                        
                        self.pswdView.isHidden = false
                        self.userView.isHidden = true
                        
                        if (UserDefaults.standard.value(forKey: "apiUrl") != nil) && ((UserDefaults.standard.value(forKey: "apiUrl") as! String) != ""){
                            Service.BaseUrl = UserDefaults.standard.value(forKey: "apiUrl") as! String
                        }else{
                            //Here is set main url
                            let  trimmedUserNmStr  = self.userTxtfld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                            if trimmedUserNmStr?.lowercased() == TEST_USER_NAME {
                                setTesterUser()
                            }else{
                                setLiveUser()
                            }
                            
                            Service.BaseUrl = mainUrl()
                        }
                        
                        if let isAlreadyLogin = UserDefaults.standard.value(forKey: "login") {
                            if (isAlreadyLogin as! Bool) == true {
                            
                                    showLoader()
                             
                        
                                if let url = getCurrentServerUrl() {
                                    Service.BaseUrl = url as String
                                }
                                
                                    
                                let defaultPage = UserDefaults.standard.value(forKey: "defaultPage") as? String
                                if  defaultPage != nil {
                                    if defaultPage == "Audit"{
                                        DispatchQueue.main.async {
                                            self.performSegue(withIdentifier: "AuditReveal", sender: self)
                                        }
                                        
                                        
                                        
                                    } else if defaultPage == "Jobs"{
                                        
                                        DispatchQueue.main.async {
                                            
                                          
                                                self.performSegue(withIdentifier: "RevealView", sender: self)
                                           
                                            
                                        }
                                    }else if defaultPage == "Calendar"{
                                        
                                        
                                        DispatchQueue.main.async {
                                            if isPermitForShow(permission: permissions.isAppointmentVisible) == true{
                                            self.performSegue(withIdentifier: "CalenderReveal", sender: self)
                                            }else{
                                                self.performSegue(withIdentifier: "RevealView", sender: self)
                                            }
                                        
                                            
                                        }
                                    } else if defaultPage == "Quote"{
                                        
                                        
                                        DispatchQueue.main.async {
                                            
                                            self.performSegue(withIdentifier: "QuotReveal", sender: self)
                                            
                                        }
                                        
                                        
                                    }else if defaultPage == "Chats"{
                                        
                                        
                                        DispatchQueue.main.async {
                                            
                                            self.performSegue(withIdentifier: "ChatReveal", sender: self)
                                            
                                        }
                                    }else if defaultPage == "Clients"{
                                        
                                        DispatchQueue.main.async {
                                            
                                            self.performSegue(withIdentifier: "ClientReveal", sender: self)
                                        }
                                    }else if defaultPage == "Expenses"{
                                        
                                        DispatchQueue.main.async {
                                            self.performSegue(withIdentifier: "ExpenceReveal", sender: self)
                                        }
                                    }
                                    
                                }else {
                                    DispatchQueue.main.async {
                                        
                                  
                                        self.performSegue(withIdentifier: "RevealView", sender: self)
                                            
                                     
                                        //self.performSegue(withIdentifier: "CalenderReveal", sender: self)
                                    }
                                }
                                
                                
                            }
                        }
                        
                        
                        
                    }else{
                        self.btnRememberMe.isSelected = false
                        self.btnRememberMe.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        self.userTxtfld.text = ""
                        self.passwrdTxtfld.text = ""
                        
                        self.pswdView.isHidden = true
                        self.userView.isHidden = false
                        
                        //Here is set main url
                        Service.BaseUrl = mainUrl()
                        
                    }
             
        
   }
    
    override func viewDidAppear(_ animated: Bool) {
                self.navigationController?.isNavigationBarHidden = true
            }
    func deleteAllStoredData( callback : (Bool) -> Void) {
        
        UserDefaults.standard.removeObject(forKey: Service.getUserJobListNew)
        UserDefaults.standard.removeObject(forKey: Service.getAuditList)
        UserDefaults.standard.removeObject(forKey: Service.getClientSink)
        UserDefaults.standard.removeObject(forKey: Service.getClientSiteSink)
        UserDefaults.standard.removeObject(forKey: Service.getClientContactSink)
        UserDefaults.standard.removeObject(forKey: Service.getFieldWorkerList)
        UserDefaults.standard.removeObject(forKey: Service.getJobTitleList)
        UserDefaults.standard.removeObject(forKey: Service.getAccType)
        UserDefaults.standard.removeObject(forKey: Service.jobTagList)
        UserDefaults.standard.removeObject(forKey: Service.groupUserListForChat)
        UserDefaults.standard.removeObject(forKey: Service.getAppoinmentList)
        UserDefaults.standard.removeObject(forKey: "checkid")
        UserDefaults.standard.removeObject(forKey: "defLanguage")
         removeDefaultSettings()
        UserDefaults.standard.synchronize()
        
        //APP_Delegate.arrOftags.removeAll()
        APP_Delegate.arrOfctrs.removeAll()
        APP_Delegate.arrOfstates.removeAll()
     
        
            DatabaseClass.shared.deleteAllRecords { (success) in
                if success{
                    callback(true)
                }
            }
  
    }
    

    @IBAction func showpass(_ sender: Any) {
        
        buttonIsSelected = !buttonIsSelected
        updateOnOffButton()
      
    }
    
    func updateOnOffButton() {
        if buttonIsSelected {
            btnShowHidePass.setImage(UIImage(named: "eyePassword"), for: .normal)
            self.passwrdTxtfld.isSecureTextEntry = false
            //showEyePass
//            btnShowHidePass.setImage(UIImage(named: "showEyePass"), for: .normal)
//            self.passwrdTxtfld.isSecureTextEntry = true
            
           
        }else{
              //showEyePass
            btnShowHidePass.setImage(UIImage(named: "showEyePass"), for: .normal)
            self.passwrdTxtfld.isSecureTextEntry = true
        }
    }
    
    @IBAction func tapOnForgotBackground(_ sender: Any) {
         removeForgotAlert()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkMarkBtnAction(_ sender: Any) {
        if btnRememberMe.isSelected {
            btnRememberMe.isSelected = false
            btnRememberMe.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
        }else{
            btnRememberMe.isSelected = true
            btnRememberMe.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
          return true
    }
    
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
//
//            if segue.identifier == "RevealView"{
//                let destinationVC = segue.destination as! JobVC
//                destinationVC.isFirstLogin = true
//                }
//}

    
    //========================================================
    // MARK:- Forgot Password
    //========================================================
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
           showForgotAlert()
    }
    
    
    @IBAction func cancelAlert(_ sender: Any) {
       removeForgotAlert()
    }
    @IBAction func registerActBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SignUpVc")as! SignUpVc
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func showForgotAlert() -> Void {
        self.frgtPswdBackgrndView.isHidden = false
        self.forgetPswdView.isHidden = false
        txtFieldForgotPass.text = ""
        UIView.animate(withDuration: 0.2, animations: {
            self.frgtPswdBackgrndView.backgroundColor = UIColor.black
            self.frgtPswdBackgrndView.alpha = 0.5
        })
        UIView.animate(withDuration: 1.0, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [], animations: {
            //self.forgetPswdView.center.y += self.view.bounds.width
            self.forgetPswdView.frame.origin.y += self.forgotView_Y! + self.forgetPswdView.frame.size.height
        }, completion: nil)
    }
    
    
    func removeForgotAlert() -> Void {
        
        currentCompanyCode = ""
        
        self.forgetPswdView.isHidden = true
        //self.forgetPswdView.frame.origin.y -= forgotView_Y! + self.forgetPswdView.frame.size.height
        self.frgtPswdBackgrndView.isHidden = true
        //self.forgetPswdView.isHidden = true
        self.frgtPswdBackgrndView.backgroundColor = UIColor.clear
        self.frgtPswdBackgrndView.alpha = 1
        // self.resetView.removeFromSuperview()
        
        //self.forgotPasswordKeyView.removeFromSuperview()
        self.forgotPasswordKeyView.isHidden = true
        
        //self.confrmPswdView.removeFromSuperview()
        self.confrmPswdView.isHidden = true
        //self.multipleCompanyView.isHidden = true
        self.multipleCompanyView.removeFromSuperview()
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        
        let  trimmedUserNmStr  = userTxtfld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let  trimmedPassStr  = passwrdTxtfld.text?.trimmingCharacters(in: .whitespacesAndNewlines)


            if trimmedPassStr != "" {
                self.userTxtfld.resignFirstResponder()
                self.passwrdTxtfld.resignFirstResponder()
                
               // currentCompanyCode  = ""
                isForgot = false
                self.login(username: trimmedUserNmStr!, password: trimmedPassStr!)
            }
            else{

                ShowAlert(title: "", message: AlertMessage.enterPassword, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})

            }
    }
 
    //==========================
    // MARK:- Login Service
    //==========================
    func login(username : String , password : String){
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
           
            killLoader()
            return
        }
        
        showLoader()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let deviceName = UIDevice.modelName
        let iOSVersion = UIDevice.current.systemVersion
        
        let param = Params()
        param.email = username
        param.pass = password
        param.devType = "2"
        param.devId = (UserDefaults.standard.value(forKey: "deviceToken") as? String) ?? ""
        param.devName = deviceName
        param.appVersion = appVersion
        param.osVersion = iOSVersion
       
        serverCommunicator(url: Service.signin, param: param.toDictionary) { (response, success) in
            if success {
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(loginResponse.self, from: response as! Data) {
                    
                    
                    if decodedData.success == false {
                        killLoader()
                        ShowAlert(title: LanguageKey.login_error, message: getServerMsgFromLanguageJson(key: decodedData.message!)! , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                        return
                    }
                  
                    if decodedData.success == true{
                        
                        if (decodedData.data[0].staticLabelFwKeyVal != "") && (decodedData.data[0].staticLabelFwKeyVal != nil) {
                            
                            self.staticLabelFwKeyValData = decodedData.data[0].staticLabelFwKeyVal!.replacingOccurrences(of: "\\", with: "")
                            
                            UserDefaults.standard.set(self.staticLabelFwKeyValData, forKey: "staticLabelFwKeyVal")
                            
                        }
                        
                        // Save remember me boolean
                        DispatchQueue.main.async {
                            let isSelected = self.btnRememberMe.isSelected
                            UserDefaults.standard.set( isSelected ? true : false, forKey: "isSelected")
                            
                            UserDefaults.standard.setValue(username, forKey: "username")
                            UserDefaults.standard.setValue(password, forKey: "password")
                            
                        }
                    
                        let appVersion : Float = Float(String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!))!
                        if let ver = decodedData.data[0].forceupdate_version {
                            if let forceVersion = Float(ver){
                                if forceVersion > appVersion{
                                    killLoader()
                                    
                                    self.showUpdateAlert(isCancel: false)
                                    return
                                }
                            }
                        }
                        
                        
                        let checkDate = UserDefaults.standard.value(forKey: "versionCheckDt") as? Date
                        
                        if (checkDate == nil) {
                            if let latestVersion = Float(decodedData.data[0].version!) {
                                if latestVersion > appVersion {
                                    UserDefaults.standard.set(Date(), forKey: "versionCheckDt")
                                    killLoader()
                                    return
                                }
                            }
                        }else{
                            let currentdat = CurrentLocalDate()
                            let previoursdt = convertInlocalDate(date: checkDate!)
                            
                            if previoursdt.compare(currentdat) == .orderedAscending {
                                // print("First Date is smaller then second date")
                                if let latestVersion = Float(decodedData.data[0].version!){
                                    if latestVersion > appVersion{
                                        UserDefaults.standard.set(Date(), forKey: "versionCheckDt")
                                        killLoader()
                                        return
                                    }
                                }
                            }
                        }
                        
                        
                        saveCurrentServerUrl(url: Service.BaseUrl) //save server url for autologin
                        
                        let previousEmail = getUserDetails()?.username
                        let previousCompany = UserDefaults.standard.value(forKey: "PreviousCompany") as? String ?? ""
                        
                        saveUserDetails(userDetails : decodedData.data[0]) // Save user's details
                        
                        UserDefaults.standard.set(true, forKey: "isFirstLogin")
                        UserDefaults.standard.set(true, forKey: "isFirstTimeLogin")
                        // For show only one time 'location disable error' when we change job status
                        
                        
                        
                        //If user is previous then we won't clear the database and login
                        if (decodedData.data[0].username == previousEmail) && (previousCompany == "" || previousCompany == decodedData.data[0].cc) {
                            
                            //set previous company in defaultMemory
                            UserDefaults.standard.set(self.currentCompanyCode!, forKey: "PreviousCompany")
                            UserDefaults.standard.synchronize()
                            
                            self.currentCompanyCode = ""
                            
                            //remove popup window
                            self.multipleCompanyCancelBtn((Any).self)
                            self.getAllCompanySettings()
                            
                            
                        }else{
                            
                            //remove popup window
                            let localafterAddTime10Hr = ""
                            UserDefaults.standard.set(localafterAddTime10Hr, forKey: "DefaultShiftEndTm10Hr")
                            self.multipleCompanyCancelBtn((Any).self)
                            
                            //Check if any data added in OFFLINE table in Database
                            let arryData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineList", query: nil) as! [OfflineList]
                            
                            if arryData.count > 0 {
                                ShowAlert(title:LanguageKey.warning  , message: AlertMessage.clearOfflinePendings, controller: windowController, cancelButton: LanguageKey.clear as NSString, okButton: LanguageKey.cancel as NSString, style: .alert, callback: { (clear, cancel) in
                                    if (clear){
                                        DispatchQueue.main.async{
                                            DatabaseClass.shared.deleteEntityWithName(EntityName: Entities.OfflineList.rawValue, callback: {(isDeleted) in
                                                if isDeleted {
                                                    
                                                    self.arrOfflineTax = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TaxList", query: nil) as! [TaxList]
                                                    
                                                    
                                                    for job in self.arrOfflineTax{
                                                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                                    }
                                                    
                                                    self.CustomFormNmListArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "CustomFormNmList", query: nil) as! [CustomFormNmList]
                                                    
                                                    
                                                    for job in self.CustomFormNmListArr{
                                                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                                    }
                                                    
                                                    self.jobStatusListArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
                                                    
                                                    
                                                    for job in self.jobStatusListArr{
                                                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                                    }
                                                    
                                                    self.UserJobListArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: nil) as! [UserJobList]
                                                    
                                                    // print(self.UserJobListArr)
                                                    for job in self.UserJobListArr{
                                                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                                    }
                                                    
                                                    self.prepareDataForNavigateToJobVC()
                                                    
                                                }
                                            })
                                            
                                        }
                                    }else{
                                        killLoader()
                                    }
                                })
                                return
                            }else{
                                DispatchQueue.main.async{
                                    
                                    self.arrOfflineTax = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TaxList", query: nil) as! [TaxList]
                                    
                                    
                                    for job in self.arrOfflineTax{
                                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                    }
                                    
                                    self.CustomFormNmListArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "CustomFormNmList", query: nil) as! [CustomFormNmList]
                                    
                                    
                                    for job in self.CustomFormNmListArr{
                                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                    }
                                    
                                    self.jobStatusListArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
                                    
                                    
                                    for job in self.jobStatusListArr{
                                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                    }
                                    
                                    self.UserJobListArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: nil) as! [UserJobList]
                                    
                                    //  print(self.UserJobListArr)
                                    for job in self.UserJobListArr{
                                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                    }
                                }
                                self.prepareDataForNavigateToJobVC()
                                
                            }
                        }
                    }else{
                        killLoader()
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    killLoader()
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                killLoader()
                ShowError(message: errorString, controller: windowController)
            }
        }
    }
    
    
    func showUpdateAlert(isCancel :  Bool) -> Void {
        
        self.currentCompanyCode = ""
        
        //remove popup window
        self.multipleCompanyCancelBtn((Any).self)
        
        if isCancel {
            ShowAlert(title: LanguageKey.new_version , message: AlertMessage.checkVersion, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.update as NSString, style: .alert) { (cancel, update) in
                if update {
                    if let link = URL(string: Constants.APPSTORE_URL) {
                        UIApplication.shared.open(link)
                    }
                }
            }
        }else{
            ShowAlert(title: LanguageKey.new_version, message: AlertMessage.checkVersion, controller: windowController, cancelButton: LanguageKey.update as NSString, okButton: nil, style: .alert) { (update, nil) in
                if update {
                    if let link = URL(string: Constants.APPSTORE_URL) {
                        UIApplication.shared.open(link)
                    }
                }
            }
        }
    }
    
    
    func prepareDataForNavigateToJobVC() -> Void {
      killLoader()
        //set previous company in defaultMemory
        UserDefaults.standard.set(self.currentCompanyCode!, forKey: "PreviousCompany")
        UserDefaults.standard.synchronize()
        
        self.currentCompanyCode = ""
        
        self.deleteAllStoredData(callback: { (success) in
            if success {
                APP_Delegate.isLastTwoDaysBadge = true
                //Save Value For ProgressBar
                UserDefaults.standard.set(true, forKey: "ShowProgressBarOnce")
                self.navigateToJobVC()
            }
        })
    }
    
    func navigateToJobVC() -> Void {
        killLoader()
        APP_Delegate.isOnlyLogin = true
        UserDefaults.standard.set(true, forKey: "login")
        UserDefaults.standard.set("1", forKey: "myFirstLoging")
        
        ActivityLog(module:Modules.login.rawValue , message: ActivityMessages.login)
        
        
        let defaultPage = UserDefaults.standard.value(forKey: "defaultPage") as? String
        if  defaultPage != nil {
            if defaultPage == "Audit"{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "AuditReveal", sender: self)
                }
                
                
            } else if defaultPage == "Jobs"{
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "RevealView", sender: self)
                    
                }
            }else if defaultPage == "Calendar"{
                
                
                DispatchQueue.main.async {
                    if isPermitForShow(permission: permissions.isAppointmentVisible) == true{
                    self.performSegue(withIdentifier: "CalenderReveal", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "RevealView", sender: self)
                    }
                }
            } else if defaultPage == "Quote"{
                
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "QuotReveal", sender: self)
                    
                }
                
                
            }else if defaultPage == "Chats"{
                
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "ChatReveal", sender: self)
                    
                }
            }else if defaultPage == "Clients"{
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "ClientReveal", sender: self)
                }
            }else if defaultPage == "Expenses"{
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ExpenceReveal", sender: self)
                }
            }
            
        }else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "RevealView", sender: self)
                
                // self.performSegue(withIdentifier: "CalenderReveal", sender: self)
            }
        }
        
    }
    
    
    //========================================================
    // MARK:- Call SerVice For Forgot Password
    //========================================================
    /*
     email -> email
     */
    
    @IBAction func btnNextAction(_ sender: Any) {
         let  trimmedFrgtPswdStr  = txtFieldForgotPass.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (self.txtFieldForgotPass.text?.isEmpty)! {
            ShowError(message: AlertMessage.enterUserName, controller: windowController)
        }
        else {
            
            if (trimmedFrgtPswdStr?.count)! >= 3 {
                txtFieldForgotPass.resignFirstResponder()
                showLoader()
                self.insertEmail = self.txtFieldForgotPass.text
                //self.removeForgotAlert()
                isForgot = true
                self.forgotPassword(email: self.txtFieldForgotPass.text!)
            } else {
                ShowError(message: AlertMessage.enterValidEmail, controller: windowController)
            }
        }
    
    }
    
    @IBAction func alreadyHaveKeyBtn(_ sender: Any) {
        if (self.txtFieldForgotPass.text?.isEmpty)! {
            ShowError(message: AlertMessage.enterUserName, controller: windowController)
        } else {
            
            self.insertEmail = self.txtFieldForgotPass.text
            
            self.forgetPswdView.isHidden = true
            self.frgtPswdBackgrndView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.frgtPswdBackgrndView.backgroundColor = UIColor.black
                self.frgtPswdBackgrndView.alpha = 0.5
            })
            view.addSubview(forgotPasswordKeyView)
            self.forgotPasswordKeyView.isHidden = false
            self.frgtpswdKey.text = ""
            forgotPasswordKeyView.center = CGPoint(x: frgtPswdBackgrndView.frame.width / 2, y: frgtPswdBackgrndView.frame.height / 2)
        }
    }
    @IBAction func dontHaveKeyBtn(_ sender: Any) {
        
        self.forgotPasswordKeyView.isHidden = true
        self.frgtPswdBackgrndView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.frgtPswdBackgrndView.backgroundColor = UIColor.black
            self.frgtPswdBackgrndView.alpha = 0.5
        })
        self.view.addSubview(forgetPswdView)
        self.forgetPswdView.isHidden = false
        self.txtFieldForgotPass.text = ""
        forgetPswdView.center = CGPoint(x: frgtPswdBackgrndView.frame.width / 2, y: frgtPswdBackgrndView.frame.height / 2)
    }
    
    func forgotPassword(email : String){
        
        let param = Params()
       // param.email = email
        param.username = email
        param.cc = currentCompanyCode
        
        serverCommunicator(url: Service.forgotPassword, param: param.toDictionary) { (response, success) in
            
            killLoader()
            
            if(success){
                let decoder = JSONDecoder()
                
                // for handle company details when Fieldworker added in multiple companies
                if let decodedData = try? decoder.decode(emailResponse.self, from: response as! Data) {

                    if decodedData.success == false {
                        //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)

                        if (decodedData.data?.cCode?.count)! > 0 {
                            self.companies = (decodedData.data?.cCode!)!
                            self.selectedCompanyIndex = 0
                            self.currentCompanyCode = self.companies[0]

                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.showMultiplePopup()
                                self.forgetPswdView.isHidden = true
                            }
                        }else{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                        return
                    }
                }

                if let decodedData = try? decoder.decode(forgotPassResponse.self, from: response as! Data) {
                    // print(decodedData)
                    
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            
                            self.currentCompanyCode = ""
                            self.multipleCompanyView.isHidden = true
                            
                            self.forgetPswdView.isHidden = true
                            
                            self.frgtPswdBackgrndView.isHidden = false
                            UIView.animate(withDuration: 0.2, animations: {
                                self.frgtPswdBackgrndView.backgroundColor = UIColor.black
                                self.frgtPswdBackgrndView.alpha = 0.5
                            })
                            self.view.addSubview(self.forgotPasswordKeyView)
                            self.frgtpswdKey.text = ""
                            self.forgotPasswordKeyView.isHidden = false
                            self.forgotPasswordKeyView.center = CGPoint(x: self.frgtPswdBackgrndView.frame.width / 2, y: self.frgtPswdBackgrndView.frame.height / 2)
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                 ShowError(message: errorString, controller: windowController)
            }
        }
    }
    
    @IBAction func frgtPswdKeyBtn(_ sender: Any) {
        if (self.frgtpswdKey.text?.isEmpty)! {
            ShowError(message: AlertMessage.enterKey, controller: windowController)
        }  else {
            showLoader()
            self.forgotPasswordKey(key: self.frgtpswdKey.text!)
        }
    }
    
    
    @IBAction func backToLoginForgotPswd(_ sender: Any) {
        removeForgotAlert()
    }
    
    @IBAction func backToLoginEnterKey(_ sender: Any) {
        removeForgotAlert()
    }
    
    @IBAction func backToLoginConnfirmPswdBtn(_ sender: Any) {
        removeForgotAlert()
    }
    
    @IBAction func confPswdsubmitBtn(_ sender: Any) {
        
        if ((self.newPswdTxtfld.text?.isEmpty)! || (self.cnfPswdTxtfld.text?.isEmpty)! )  {
            ShowError(message: AlertMessage.enterPassword, controller: windowController)
        }
        else if (self.newPswdTxtfld.text == self.cnfPswdTxtfld.text)
        {
            showLoader()
            
            self.forgotPasswordReset(pass: self.newPswdTxtfld.text!)
            
        } else {
            ShowError(message: AlertMessage.passwordNotMatch , controller: windowController)
        }
        
    }
   
    func showMultiplePopup() -> Void {
        showBackgroundView()
        self.multipleCompanyView.isHidden = false
        view.addSubview(multipleCompanyView)
        multipleCompanyView.center = CGPoint(x: frgtPswdBackgrndView.frame.width / 2, y: frgtPswdBackgrndView.frame.height / 2)
    }
    
    @IBAction func OKBtn(_ sender: Any) {
        if isForgot {
            showLoader()
            self.forgotPassword(email: self.txtFieldForgotPass.text!)
        }else{
            DispatchQueue.main.async {
                self.multipleCompanyView.removeFromSuperview()
                self.pswdView.isHidden = false
                self.frgtPswdBackgrndView.isHidden = true
                self.userView.isHidden = true
            }
        }
    }
    
    @IBAction func multipleCompanyCancelBtn(_ sender: Any) {
        DispatchQueue.main.async {
            self.multipleCompanyView.isHidden = true
            self.frgtPswdBackgrndView.isHidden = true
        }
    }
    
    func showBackgroundView() {
        
        self.frgtPswdBackgrndView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.frgtPswdBackgrndView.backgroundColor = UIColor.black
            self.frgtPswdBackgrndView.alpha = 0.5
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:MultipleClientTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "cell") as! MultipleClientTableViewCell
        cell.companyLbl.text = companies[indexPath.row]
        
        cell.selectionStyle = .none
        if selectedCompanyIndex == indexPath.row {
            cell.imgRadioButton.image = UIImage.init(named: "radio-selected")
        } else {
            cell.imgRadioButton.image = UIImage.init(named: "radio_unselected")
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCompanyIndex  = indexPath.row
        currentCompanyCode = companies[selectedCompanyIndex]
        //this company code save for login when app re-launch
        UserDefaults.standard.set(self.currentCompanyCode, forKey: "currentCompany")
        tableView.reloadData()
    }
   
    
    func didToggleRadioButton(_ indexPath: IndexPath) {
        let section = indexPath.section
        let data = multiCompanyArr[indexPath.row]
        if let previousItem = selectedElement[section] {
            if previousItem == data {
                selectedElement.removeValue(forKey: section)
                return
            }
        }
        selectedElement.updateValue(data, forKey: section)
    }
    
    func forgotPasswordKey(key: String) {
        let param = Params()
        //param.email = insertEmail
        param.username = insertEmail
        param.key = key
       
        param.username = insertEmail
    
        serverCommunicator(url: Service.forgotPasswordKey, param: param.toDictionary) { (response, success) in
            
            killLoader()
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(forgotPasswordKeyResponse.self, from: response as! Data) {
                   // print(decodedData)
                    
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            self.usrerId = decodedData.usrId
                            //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            
                            self.forgotPasswordKeyView.isHidden = true
                            
                            self.frgtPswdBackgrndView.isHidden = false
                            UIView.animate(withDuration: 0.2, animations: {
                                self.frgtPswdBackgrndView.backgroundColor = UIColor.black
                                self.frgtPswdBackgrndView.alpha = 0.5
                            })
                            self.confrmPswdView.isHidden = false
                            self.view.addSubview(self.confrmPswdView)
                            self.newPswdTxtfld.text = ""
                            self.cnfPswdTxtfld.text = ""
                            self.confrmPswdView.center = CGPoint(x: self.frgtPswdBackgrndView.frame.width / 2, y: self.frgtPswdBackgrndView.frame.height / 2)
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                //ShowError(message: AlertMessage.formatProblem, controller: windowController)
            }
        }
    }
    
    func forgotPasswordReset(pass : String) {
        
        
        let param = Params()
        param.usrId = usrerId
        param.pass = pass
        
        serverCommunicator(url: Service.forgotPasswordReset, param: param.toDictionary) { (response, success) in
            
            killLoader()
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(forgotPassResetRespponse.self, from: response as! Data) {
                  //  print(decodedData)
                    
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            
                            
                            self.usrerId = decodedData.usrId
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            
                            self.confrmPswdView.isHidden = true
                            self.forgetPswdView.isHidden = true
                            self.frgtPswdBackgrndView.isHidden = true
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    
//    func changePassword(op : String, np : String) {
//        
//        
//        let param = Params()
//        param.usrId = usrerId
//        param.op = op
//        param.np = np
//        
//        serverCommunicator(url: Service.changePassword, param: param.toDictionary) { (response, success) in
//            
//            killLoader()
//            
//            if(success){
//                let decoder = JSONDecoder()
//                if let decodedData = try? decoder.decode(changePasswordResponse.self, from: response as! Data) {
//                    print(decodedData)
//                    
//                    if decodedData.success == true{
//                        DispatchQueue.main.async{
//                            
//                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
//                        }
//                    }else{
//                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
//                    }
//                }else{
//                    ShowAlert(title: "formate problem", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertControllerStyle.alert, callback: {_,_ in})
//                }
//            }else{
//                //ShowError(message: "Please try again!", controller: windowController)
//            }
//        }
//    }

    //======================================================
    // MARK: Send Lat Lng & Btry Status
    //======================================================
    
    func sendLatLngBatryStats(latitude: String, longitude : String,  batteryStatus : String) {
        
        
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.lat = latitude
        param.lng = longitude
        param.btryStatus = batteryStatus
            
            serverCommunicator(url: Service.getLocationUpdate, param: param.toDictionary) { (response, success) in
                
                killLoader()
                
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(LatLngResponse.self, from: response as! Data) {
                        //  print(decodedData)
                        
                        if decodedData.success == true{
                            DispatchQueue.main.async{
                                
                                
                                //self.usrerId = decodedData.usrId
                                ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                
                                self.confrmPswdView.isHidden = true
                                self.forgetPswdView.isHidden = true
                                self.frgtPswdBackgrndView.isHidden = true
                            }
                        }else{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
                }
        }
    }

    
    @IBAction func useanotherBtn(_ sender: Any) {
        pswdView.isHidden = true
        userView.isHidden = false
        
        //Here is set main url
       
        
        userTxtfld.text = ""
        passwrdTxtfld.text = ""
    }
    
    
    @IBAction func nextBtn(_ sender: Any) {
        
        btnShowHidePass.setImage(UIImage(named: "showEyePass"), for: .normal)
        self.passwrdTxtfld.isSecureTextEntry = true
        userTxtfld.resignFirstResponder()
        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            }
            return
        }


        if userTxtfld.text != ""  {
            let  trimmedUserNmStr  = userTxtfld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
             if trimmedUserNmStr?.lowercased() == TEST_USER_NAME {
                setTesterUser()
            }else{
                setLiveUser()
            }
            Service.BaseUrl = mainUrl()
            
            if (trimmedUserNmStr?.count)! >= 3 {
            
                showLoader()
                let param = Params()
                param.email = trimmedUserNmStr
                serverCommunicator(url: Service.getApiUrl, param: param.toDictionary) { (response, success) in
                    
                    killLoader()
                    
                    if success {
                        let decoder = JSONDecoder()
                        
                        // for handle company details when Fieldworker added in multiple companies
                        if let decodedData = try? decoder.decode(emailResponse.self, from: response as! Data) {
                            
                            if decodedData.success == true {
                                self.companies = (decodedData.data?.cCode!)!
                                UserDefaults.standard.set(decodedData.data?.email, forKey: "emailFirstLogin")
                              
                                
//=========================================================================================================================================
// MARK :-  this url set for use whole app for the replacement of BaseUrl
//=========================================================================================================================================
                                
                UserDefaults.standard.set(decodedData.data?.apiurl, forKey: "apiUrl") // :- FOR STAGING
                // UserDefaults.standard.set( "https://sg1.eyeontask.com/en/eotServices/", forKey: "apiUrl")  // :- FOR sg1
               // UserDefaults.standard.set( "http://192.168.88.2:8435/eotServices/", forKey: "apiUrl")  //:- FOR 192
                                
//=========================================================================================================================================
                                
                                
                                Service.BaseUrl = UserDefaults.standard.value(forKey: "apiUrl") as! String
                                setRegion(region: (decodedData.data?.region)!)
                                
                                if self.companies.count > 1 {
                                    self.selectedCompanyIndex = 0
                                    self.currentCompanyCode = self.companies[0]
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                        self.showMultiplePopup()
                                        self.forgetPswdView.isHidden = true
                                    }
                                }else{
                                    self.selectedCompanyIndex = 0
                                    self.currentCompanyCode = self.companies[0]
                                    
                                    //this company code save for login when app re-launch
                                    UserDefaults.standard.set(self.currentCompanyCode, forKey: "currentCompany")
                                    
                                    DispatchQueue.main.async {
                                        self.pswdView.isHidden = false
                                        self.frgtPswdBackgrndView.isHidden = true
                                        self.userView.isHidden = true
                                    }
                                }
                                DispatchQueue.main.async {
                                    
                                    if let usernm = decodedData.data?.email {
                                        self.emailDisplayLbl.text = " \(usernm)        "
                                    }else{
                                        self.emailDisplayLbl.text = ""
                                    }
                                    
                                    
                                }
                            }else{
                                ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            }
                            return
                        }
                    }else{
                        ShowError(message: errorString, controller: windowController)
                    }
                }
            }
            else{
                if (trimmedUserNmStr! == "") {
                    ShowAlert(title: "", message: AlertMessage.enterUserName, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
                    return
                }else{
                    ShowAlert(title: "", message: AlertMessage.enterValidEmail, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
                    return
                }
            }
        } else {
            
            ShowAlert(title: "", message: AlertMessage.enterUserName, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
            return
        }
        
        
    }
    
    //=====================================
    // MARK:- get All Company Settings
    //=====================================
    
    func getAllCompanySettings(){
        
       // ChatManager.shared.ref.database.goOnline() // make sure online realtime database
        
        let param = Params()
        param.usrId = getUserDetails()!.usrId
        param.devType = "2"
     
        serverCommunicator(url: Service.getMobileDefaultSettings, param: param.toDictionary) { (response, success) in
            
            if success {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(DefaultSettingResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        
                     //   saveCheckInId(checkinId: (decodedData.data?.checkId)!) //Save checkin id in Local
                        
                      //  saveDefaultSettings(userDetails: decodedData.data!) // Save All Default Settings in Local
                        
                      //  self.processForCreateNode() // Intailise firebase
                        
//                        if let round = getDefaultSettings()?.numAfterDecimal{ //This is round off digit for invoice
//                            roundOff = round
//                        }
                        let expireStatusCheck = decodedData.data!
                        if expireStatusCheck.expireStatus == 0
                        {
                            let subscriptionShow = "On"
                            UserDefaults.standard.set(subscriptionShow, forKey: "subscriptionOn")
                            self.getSubscriptionData()
                        }else{
                            killLoader()
                            self.navigateToJobVC()
                            let subscriptionShow = "Off"
                            UserDefaults.standard.set(subscriptionShow, forKey: "subscriptionOn")
                            
                        }
                        
//                        let existingDefLanguage = getDefaultLanugage()
//                        if (decodedData.data?.language?.isLock == "1") || (existingDefLanguage == nil) || (existingDefLanguage?.fileName != decodedData.data?.language!.fileName) || (existingDefLanguage?.version != decodedData.data?.language!.version){
//
//                            var langName = ""
//
//                            if let language  = decodedData.data!.languageList?.filter({$0.fileName == decodedData.data!.language?.fileName!}) {
//                                langName = (language as [languageDetails])[0].nativeName!
//                            }
//
//                            LanguageManager.shared.setLanguage(filename: (decodedData.data?.language!.fileName)!, filePath: (decodedData.data?.language!.filePath)!, languageName: langName, version: (decodedData.data?.language!.version)!, alert: false, callBack: { (success) in
//                                if success {
//                                    //killLoader()
//                                    saveDefaultLanugage(lanugage: (decodedData.data?.language)!)
//                                    //self.setLocalization()
//                                    // APP_Delegate.isLanguageChanged = true
//                                    //  self.performSegue(withIdentifier: "RevealView", sender: self)
//                                }
//                            })
//                        }
//
                        
//                        let appVersion : Float = Float(String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!))!
//                        if let ver = decodedData.data!.forceupdate_version {
//                            if let forceVersion = Float(ver){
//                                if forceVersion > appVersion{
//                                    killLoader()
//                                    navigateToLoginPage()
//
//                                    self.showUpdateAlert(isCancel: false)
//                                    return
//                                }
//                            }
//                        }
                        
                        
                        
//                        let checkDate = UserDefaults.standard.value(forKey: "versionCheckDt") as? Date
//
//                        if (checkDate == nil) {
//                            if let latestVersion = Float(decodedData.data!.version!) {
//                                if latestVersion > appVersion {
//                                    UserDefaults.standard.set(Date(), forKey: "versionCheckDt")
//                                    killLoader()
//                                }
//                            }
//                        }else{
//                            let currentdat = CurrentLocalDate()
//                            let previoursdt = convertInlocalDate(date: checkDate!)
//
//                            if previoursdt.compare(currentdat) == .orderedAscending {
//                                // print("First Date is smaller then second date")
//                                if let latestVersion = Float(decodedData.data!.version!){
//                                    if latestVersion > appVersion{
//                                        UserDefaults.standard.set(Date(), forKey: "versionCheckDt")
//                                        killLoader()
//                                    }
//                                }
//                            }
//                        }
                        
                        
                        
                       // ChatManager.shared.admins = (decodedData.data!.adminIds)!
                        
                        
                        DispatchQueue.main.async {
//                            if isPermitForShow(permission: permissions.isJobAddOrNot) == true {
//                                self.btnAddJob.isHidden = false
//                            }else{
//                                self.btnAddJob.isHidden = true
//                            }
                        }
                        
//
//                        if !APP_Delegate.isOnlyLogin { // when user autologin then call this AutoLogin activity url otherwise not called
//                            ActivityLog(module:Modules.login.rawValue , message: ActivityMessages.autoLogin)
//                        }else{
//                            APP_Delegate.isOnlyLogin = false
//                        }
//
                      //  ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.joblist)
                        
                    }else{
                        //self.processForCreateNode() // Intailise firebase
                    }
                }else{
                    killLoader()
                }
            }else {
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getAllCompanySettings()
                    }
                })
            }
        }
    }
    
    func  getSubscriptionData() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            //  hideloader()
            return
        }
        
        
        
        //            showLoader()
        //            let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.groupUserListForChat) as? String
        //            let param = Params()
        //            param.limit = ContentLimit
        //            param.index = "\(count)"
        //            param.search = ""
        //            param.dateTime = lastRequestTime ?? ""
        
        let param = Params()
        param.compId = getUserDetails()?.compId
      //  print("API ----------------------------------------------------------------------- getSubscriptionData")
        // print(param.toDictionary)
        serverCommunicator(url: Service.getSubscriptionData, param: param.toDictionary) { (response, success) in
            // killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(SubcriptionResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        self.subcriptionData = decodedData
                        
                        DispatchQueue.main.async {
                            
                            // self.forgetPswdView.isHidden = true
//                            self.showBackgroundView()
//                            self.view.addSubview(self.subcriptionView)
//                            self.lblSubcriptionMsg.text = getServerMsgFromLanguageJson(key: decodedData.message ?? "")//self.subcriptionData?.message
//                            self.lblContact.text = LanguageKey.please_contact_admin //"Please contact your Adminitrator"
//                            self.subcriptionView.isHidden = false
//                            self.subcriptionView.center = CGPoint(x: self.backgroundView.frame.width / 2, y: self.backgroundView.frame.height / 2)
                        }
                        
                    }else{
                        
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        
                    }
                }else{
                 //   ShowAlert(title: "", message: "Subscription Expired Please contact your Eyeontask Super administrator.", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    //        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    killLoader()
                    ShowAlert(title: "", message:"Subscription Expired Please contact your Eyeontask Super administrator." , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                        if (Ok){
                            DispatchQueue.main.async {
                                //(UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                            }
                        }
                    })
                }
            }else{
                //ShowError(message: AlertMessage.formatProblem, controller: windowController)
            }
        }
    }
    
}
//======================================================
// MARK: For hiding keyboard
//======================================================

func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
{
    textField.resignFirstResponder()
    return true;
}







