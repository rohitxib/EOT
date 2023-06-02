//
//  AddAudit.swift
//  EyeOnTask
//
//  Created by Altab on 18/12/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class AddAudit: UIViewController,UITextFieldDelegate , OptionViewDelegate, UITextViewDelegate {
     
    
    
    @IBOutlet weak var customTblView: UITableView!
    @IBOutlet weak var contrectTxtFld: FloatLabelTextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchDropDwnView: UIView!
    @IBOutlet weak var searchBackBtn: UIButton!
    
    
    @IBOutlet weak var H_lattitude: NSLayoutConstraint!
    
    @IBOutlet weak var latitued: UITextField!
    @IBOutlet weak var longitued: UITextField!
    
    @IBOutlet weak var btnDonebgView: UIButton!
    @IBOutlet weak var btnCancelbgView: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblAddTags: UILabel!
    @IBOutlet weak var lblSchedulStart: UILabel!
    @IBOutlet weak var lblScheduleEnd: UILabel!
    
    
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet var container_view: UIView!
    
    @IBOutlet var txtfldJobTitle: UITextField!
    @IBOutlet var txtfld_JobDesc: UITextField!
    @IBOutlet var txtfld_JobPriority: UITextField!
    @IBOutlet var txtfld_JobInstruction: UITextField!
    @IBOutlet var txtfld_Client: UITextField!
    @IBOutlet var txtfld_Contact: UITextField!
    @IBOutlet var txtfld_MobNo: UITextField!
    @IBOutlet var txtfld_AltMobNo: UITextField!
    @IBOutlet var txtfld_Email: UITextField!
    @IBOutlet var txtfld_SiteName: UITextField!
    @IBOutlet var txtfld_Address: UITextField!
    @IBOutlet var txtfld_City: UITextField!
    @IBOutlet var txtfld_PostalCode: UITextField!
    @IBOutlet var txtfld_State: UITextField!
    @IBOutlet var txtfld_Country: UITextField!
    @IBOutlet var taxFieldAddTags: FloatLabelTextField!
    @IBOutlet var txtfld_FieldWorker: UITextField!
    @IBOutlet var tagView: ASJTagsView!
    @IBOutlet var dateAndTimePicker: UIDatePicker!
    @IBOutlet var lbl_EndSchTime: UILabel!
    @IBOutlet var lbl_EndSchDate: UILabel!
    @IBOutlet var lbl_SrtSchTime: UILabel!
    @IBOutlet var lbl_SrtSchDate: UILabel!
    @IBOutlet weak var txt_landmark: FloatLabelTextField!
    @IBOutlet var bgViewOfPicker: UIView!
    @IBOutlet var scroll_View: UIScrollView!
    var FltWorkerId = [String]()
    var ContractArray = [ContractListData]()
    @IBOutlet var tagVw_OFTag: ASJTagsView!
    @IBOutlet weak var H_landmark: NSLayoutConstraint!
    @IBOutlet var lbl_AssignTo: UILabel!
    @IBOutlet var btnClient: UIButton!
    @IBOutlet var btnSitName: UIButton!
    @IBOutlet var btnContact: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var H_JobDes: NSLayoutConstraint!
    @IBOutlet weak var H_CustomView: NSLayoutConstraint!
    // @IBOutlet weak var customField_H: NSLayoutConstraint!
    
    var appoinmentDateAudit:Bool = false
    var discpFirstTittle:Bool = false
    var imagePicker = UIImagePickerController()
    /////////////////////////////////auditcustomfielf/////////////////////////////////////
    var txtFieldData : String?
    var selectedTxtField : UITextField?
    //////////////////////////////////////////////////////////////////////////////////////////////
    var optionalVw : OptionalView?
    var isOpenOptionalView = false
    let arrOfPriroty = ["Low" , "Medium" , "High"]
    var arrClintList = [ClientList]()
    var FltArrClintList = [ClientList]()
    var FltContractListt = [ContractList]()
    var arrContractList = [ContractList]()///////////////////
    var arrOffldWrkData = [FieldWorkerDetails]()
    var FltArrOffldWrkData = [FieldWorkerDetails]()
    var arrOfShowData = [Any]()
    var arra = [Any]()
    var ss = [Any]()
    var searcharraisbol = false
    var searcharra = [Any]()
    var arrOfaddTags = [[String : String]]()
    var params = [String: Any]()
    var sltDropDownBtnTag : Int!
    var sltTxtField = UITextField()
    
    //  let datePicker = UIDatePicker()
    var isStartScheduleBtn : Bool!
    let cellReuseIdentifier = "cell"
    let param = Params()
    var isClintFutUser  = false
    var isSitFutUser  = false
    var isContactFutUser  = false
    var isClear  = false
    var callbackForJobVC: ((Bool) -> Void)?
    var clientSelf = false
    var ArrContrect = [ContractList]()
    
    var contryCode = ""
    
    var customVCArr = [CustomDataRes]()
    var arrOfShowData11 = [CustomFormDetals]()
    var arrOfShowDatas : GetDetail?
    var sltQuestNo : String?
    var txtViewData : String?
    
    var imgArr = [ImageModel]()
    var stringToHtml = ""
    var stringToHtmlOnlyText = ""
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard touches.first != nil else { return }
            
            DispatchQueue.main.async {
                self.removeOptionalView()
            }
        }
        

        override func viewDidLoad() {
            
            if ContractArray.count == 0{
                self.H_CustomView.constant = 0
            }else{
                self.H_CustomView.constant = 500
            }
            
           // self.customField_H.constant = 800
            super.viewDidLoad()
            contrectTxtFld.isEnabled = false
            textView.delegate = self
                 textView.text = LanguageKey.audit_desc
                 textView.textColor = UIColor.lightGray
            
          if let cntryCode = getDefaultSettings()?.ctryCode
                   {
                       contryCode = cntryCode
                   }

      
            
         //   if let langCode = getCurrentSelectedLanguageCode() {
                   if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                             if enableCustomForm == "0"{
                               dateAndTimePicker.locale = Locale.init(identifier: "en_US")
                             }else{
                               dateAndTimePicker.locale = Locale.init(identifier: "en_gb")
                             }
                         }
                   
                  //dateAndTimePicker.locale = Locale(identifier: langCode)
             //  }
            
            getFormDetail()
            
            ss = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
           // self.btnSitName.isUserInteractionEnabled = true
              arra = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
             self.searchDropDwnView.isHidden = true
            self.searchBackBtn.isHidden = true
    //        tableView.rowHeight = UITableView.automaticDimension
    //        tableView.estimatedRowHeight = 165
           
            self.setUpMethod()
            
            LocationManager.shared.startTracking()
            
            IQKeyboardManager.shared.enable = false
            self.registorKeyboardNotification()
            self.getClintListFrmDB()
            //getcontractFrmDB()
            getJobTittle()
            getFieldWorkerList()
            getTagListService()
             contractSynch()
            getClientSink()
            getClientSiteSink()
            getClientContactSink()
            
//            if let langCode = getCurrentSelectedLanguageCode() {
//                dateAndTimePicker.locale = Locale(identifier: langCode)
//            }
            
            DispatchQueue.main.async {
                self.createTags(strName: (getUserDetails()?.fnm)!, view: self.tagView)
                self.txtfldJobTitle.text = getUserDetails()?.fnm
               //  param.memIds = getUserDetails()?.usrId
            }
            
            
            self.FltWorkerId.append((getUserDetails()?.usrId)!)
            
            setLocalization()
            
            ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobsAdd)
         }
        
        func setLocalization() -> Void {
            self.navigationItem.title = LanguageKey.title_add_audit
            //LanguageKey.title_add_job
            
            taxFieldAddTags.placeholder = LanguageKey.add_tag
            txtfld_FieldWorker.placeholder = LanguageKey.add_fieldworker
            txtfld_Contact.placeholder = LanguageKey.contact_name
            txtfld_Email.placeholder = LanguageKey.email
            txtfld_MobNo.placeholder = LanguageKey.mob_no
            txtfld_AltMobNo.placeholder = LanguageKey.alt_mobile_number
            txtfldJobTitle.placeholder = "\(LanguageKey.auditors1) *"
            txtfld_JobDesc.placeholder = LanguageKey.audit_desc
            //txtfld_JobPriority.text = LanguageKey.medium
            txtfld_JobInstruction.placeholder = LanguageKey.audit_instr
            txtfld_Client.placeholder = "\(LanguageKey.client_name) *"
            txtfld_SiteName.placeholder = LanguageKey.site_name
            txtfld_Address.placeholder = "\(LanguageKey.address) *"
            txtfld_City.placeholder = LanguageKey.city
            txtfld_PostalCode.placeholder = LanguageKey.postal_code
            txtfld_Country.placeholder = "\(LanguageKey.country) *"
            txtfld_State.placeholder = "\(LanguageKey.state) *"
            latitued.placeholder = LanguageKey.latitude
            longitued.placeholder = LanguageKey.longitued
            contrectTxtFld.placeholder = LanguageKey.contract
            lbl_AssignTo.text = "\(LanguageKey.assign_to)"
            lblSchedulStart.text = LanguageKey.shdl_start
            lblScheduleEnd.text = LanguageKey.shdl_end
            lblAddTags.text = LanguageKey.tags
            btnDonebgView.setTitle(LanguageKey.done , for: .normal)
            btnCancelbgView.setTitle(LanguageKey.cancel , for: .normal)
            btnSubmit.setTitle(LanguageKey.create_audit , for: .normal)
            btnAdd.setTitle(LanguageKey.add , for: .normal)
            btnClear.setTitle(LanguageKey.clear , for: .normal)
            btnClient.setTitle(LanguageKey.save_for_future_use , for: .normal)
            btnContact.setTitle(LanguageKey.save_for_future_use , for: .normal)
            btnSitName.setTitle(LanguageKey.add_new_site , for: .normal)
           // txtfld_JobPriority.placeholder = LanguageKey.job_priority
            txt_landmark.placeholder = LanguageKey.landmark_addjob
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super .viewWillAppear(animated)
            
            

            
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            IQKeyboardManager.shared.enable = true
            self.removeKeyboardNotification()
        }
        
        @IBAction func searchBackBtn(_ sender: Any) {
            
            self.searchDropDwnView.isHidden = true
                   self.searchBackBtn.isHidden = true
        }
        
        @IBAction func clearButtonTapped(_ sender: Any) {
            isClear = true
            DispatchQueue.main.async {
                self.lbl_SrtSchTime.text =  "00:00"
                self.lbl_SrtSchDate.text =  "dd-MM-yyyy"
                self.lbl_EndSchTime.text =  "00:00"
                self.lbl_EndSchDate.text =  "dd-MM-yyyy"
            }
        }
   
    func setUpMethod(){
        
        if getDefaultSettings()?.isJobLatLngEnable == "0" {
            H_lattitude.constant = 0.0
        }
        
        if getDefaultSettings()?.isLandmarkEnable == "0" {
            H_landmark.constant = 0.0
        }
        
        
        // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
        var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
        duration = updateDefaultTime(duration ?? "01:00")
        let arrOFDurationTime = duration?.components(separatedBy: ":")
        
        // let currentTime : String? = getDefaultSettings()?.jobCurrentTime // old
        let currentTime : String? = updateDefaultTime(getDefaultSettings()?.jobCurrentTime ?? "01:00")
        if(currentTime != "" && currentTime != nil){
            let arrOFCurntTime = currentTime?.components(separatedBy: ":")
            let strDate = getSchuStartAndEndDateForAgoTime(Hrs:Int(arrOFCurntTime![0])!, min: Int(arrOFCurntTime![1])!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
            
            let arr = strDate.0.components(separatedBy: " ")
            
            if arr.count == 2 {
                
                var isdateFormt = ""
                isdateFormt =   UserDefaults.standard.value(forKey: "clickDate") as? String ?? ""
                
                var persimissionOn = ""
                persimissionOn =   UserDefaults.standard.value(forKey: "persimissionOn") as? String ?? ""
                
                if appoinmentDateAudit == true{
                    
                    if  persimissionOn == "On"{
                        lbl_SrtSchDate.text = isdateFormt
                        lbl_SrtSchTime.text = arr[1]
                    }else{
                        lbl_SrtSchDate.text = arr[0]
                        lbl_SrtSchTime.text = arr[1]
                        lbl_EndSchDate.text = arr[0]
                    }
                    
                }else{
                    lbl_SrtSchDate.text = arr[0]
                    lbl_SrtSchTime.text = arr[1]
                    lbl_EndSchDate.text = arr[0]
                }
                
            }else{
                var isdateFormt = ""
                isdateFormt =   UserDefaults.standard.value(forKey: "clickDate") as? String ?? ""
                
                var persimissionOn = ""
                persimissionOn =   UserDefaults.standard.value(forKey: "persimissionOn") as? String ?? ""
                
                if appoinmentDateAudit == true{
                    
                    if  persimissionOn == "On"{
                        lbl_SrtSchDate.text = isdateFormt
                    }else{
                        lbl_SrtSchDate.text = arr[0]
                    }
                    
                }else{
                    lbl_SrtSchDate.text = arr[0]
                }
                
                lbl_SrtSchTime.text = arr[1] + " " + arr[2]
                lbl_EndSchDate.text = arr[0]
            }
            
            let arrOfEndDate = strDate.1.components(separatedBy: " ")
            if arrOfEndDate.count == 2 {
                var isdateFormt = ""
                isdateFormt =   UserDefaults.standard.value(forKey: "clickDate") as? String ?? ""
                
                var persimissionOn = ""
                persimissionOn =   UserDefaults.standard.value(forKey: "persimissionOn") as? String ?? ""
                
                if appoinmentDateAudit == true{
                    
                    if  persimissionOn == "On"{
                        lbl_EndSchDate.text = isdateFormt
                        lbl_EndSchTime.text = arrOfEndDate[1]
                    }else{
                        lbl_EndSchDate.text = arrOfEndDate[0]
                        lbl_EndSchTime.text = arrOfEndDate[1]
                    }
                    
                }else{
                    lbl_EndSchDate.text = arrOfEndDate[0]
                    lbl_EndSchTime.text = arrOfEndDate[1]
                }
                
            }else{
                
                var isdateFormt = ""
                isdateFormt =   UserDefaults.standard.value(forKey: "clickDate") as? String ?? ""
                
                var persimissionOn = ""
                persimissionOn =   UserDefaults.standard.value(forKey: "persimissionOn") as? String ?? ""
                
                if appoinmentDateAudit == true{
                    
                    if  persimissionOn == "On"{
                        lbl_EndSchDate.text = isdateFormt
                    }else{
                        lbl_EndSchDate.text = arrOfEndDate[0]
                    }
                    
                }else{
                    lbl_EndSchDate.text = arrOfEndDate[0]
                }
                
                
                //lbl_EndSchDate.text = arrOfEndDate[0]
                lbl_EndSchTime.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
            }
            
        }else{
            let adminSchTime : String? = getDefaultSettings()?.jobSchedule
            if(adminSchTime != "" && adminSchTime != nil){
                // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
                var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
                duration = updateDefaultTime(duration ?? "01:00")
                let arrOFDurationTime = duration?.components(separatedBy: ":")
                
                let strDate = getSchStartandEndDateAndTimeForSchDate(timeInterval: (getDefaultSettings()?.jobSchedule)!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
                
                
                let arr = strDate.0.components(separatedBy: " ")
                if arr.count == 2 {
                    lbl_SrtSchDate.text = arr[0]
                    lbl_SrtSchTime.text = arr[1]
                    lbl_EndSchDate.text = arr[0]
                }else{
                    lbl_SrtSchDate.text = arr[0]
                    lbl_SrtSchTime.text = arr[1] + " " + arr[2]
                    lbl_EndSchDate.text = arr[0]
                }
              
                let arrOfEndDate = strDate.1.components(separatedBy: " ")
                if arrOfEndDate.count == 2 {
                    lbl_EndSchDate.text = arrOfEndDate[0]
                    lbl_EndSchTime.text = arrOfEndDate[1]
                }else{
                    lbl_EndSchDate.text = arrOfEndDate[0]
                    lbl_EndSchTime.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
                }
            }
        }
        
    }
        

        //=====================================
        //MARK:- Registor Keyboard Notification
        //=====================================
        func registorKeyboardNotification(){
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        }
        
        
        //=====================================
        //MARK:- Remove Keyboard Notification
        //=====================================
        func removeKeyboardNotification(){

            NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardDidShowNotification,object: nil)
             NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardDidHideNotification,object: nil)
        }
        
        func setInitialFramOfPickerView(){
             DispatchQueue.main.async {
            let frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 240.0)
                self.bgViewOfPicker.frame = frame
            }
        }

        func showDateAndTimePicker(){
           // self.dateAndTimePicker.minimumDate = Date()
            self.bgViewOfPicker.isHidden = false
            UIView.animate(withDuration: 0.2)  {
                let frame = CGRect(x: 0, y: self.view.frame.size.height - 240, width: self.view.frame.size.width, height: 240)
                self.bgViewOfPicker.frame = frame

            }
        }
        
        @IBAction func addBtnAction(_ sender: Any) {
            ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.validFieldWorker, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
            
            self.txtfld_FieldWorker.text = ""
        }
        
        @IBAction func addBtnOfTads(_ sender: Any) {
            self.scroll_View.isScrollEnabled = true
            let trimValue = self.taxFieldAddTags.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimValue == "" {
               // ShowError(message: AlertMessage.addTag, controller: windowController)
                return
            }
            
            
            let isExist =  arrOfaddTags.contains{ ( dict : [String : String]) -> Bool in
               
                if dict["tnm"] == trimValue?.capitalizingFirstLetter(){
                    return true
                }
                return false
            }
            if(!isExist){
                self.tagVw_OFTag.addTag(trimValue!.capitalizingFirstLetter(), withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: true)
                /*let dict = ["tagId" : String(arrOfaddTags.count + 1),
                            "tnm" : trimValue]*/
             let savedTagList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TagsList", query: nil) as! [TagsList]
                var dict : [String : String]?
                if let idx = savedTagList.firstIndex(where: { $0.tnm ==  trimValue }){
                    dict = ["tagId" : savedTagList[idx].tagId!,
                            "tnm" : trimValue!.capitalizingFirstLetter()]
                }else{
                     dict = ["tagId" : "",
                             "tnm" : trimValue!.capitalizingFirstLetter()]
                }
                
                
               
                arrOfaddTags.append(dict! )
                self.tagVw_OFTag.deleteBlock = {(tagText : String ,idx : Int) -> Void in
                    self.tagVw_OFTag.deleteTag(at: idx)
                    self.arrOfaddTags.remove(at: idx)
                }
            }
      
            self.taxFieldAddTags.text = ""
        }
        

        @IBAction func btnScheduleStrtAction(_ sender: Any) {
            removeOptionalView()
            isStartScheduleBtn = true
            self.bgViewOfPicker.isHidden = false
            self.showDateAndTimePicker()
        }
        
        @IBAction func btnScheduleEndAction(_ sender: Any) {
            removeOptionalView()
            isStartScheduleBtn = false
            self.bgViewOfPicker.isHidden = false
            self.showDateAndTimePicker()
        }
        
        
        func convetStrDateIntoDate(strDate : String) -> Date{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.locale = Locale(identifier: "en_US")
            let date = dateFormatter.date(from: strDate)
            return date!
            
        }
        
        @IBAction func btnSaveAction(_ sender: Any) {
            
            isClear = false
            
            self.bgViewOfPicker.isHidden = true
            let date = self.dateAndTimePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy h:mm a"
            formatter.timeZone = TimeZone.current
            
           if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                if enableCustomForm == "0"{
                    formatter.dateFormat = "dd-MM-yyyy h:mm a"
                }else{
                    formatter.dateFormat = "dd-MM-yyyy HH:mm"
                }
            }
            
            if let langCode = getCurrentSelectedLanguageCode() {
                formatter.locale = Locale(identifier: langCode)
            }
            
            let strDate = formatter.string(from: date)
            if(isStartScheduleBtn){
                let arr = strDate.components(separatedBy: " ")
                
                if arr.count == 2 {
                    lbl_SrtSchDate.text = arr[0]
                    lbl_SrtSchTime.text = arr[1]
                }else{
                    lbl_SrtSchDate.text = arr[0]
                    lbl_SrtSchTime.text = arr[1] + " " + arr[2]
                }
                
               
                
            }else{
                let schStartDate = self.lbl_SrtSchDate.text! + " " +  self.lbl_SrtSchTime.text!
                

                if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                    if enableCustomForm == "0"{
                        let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy)
                        if(value == "orderedDescending"){
                            ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                        }else{
                            let arr = strDate.components(separatedBy: " ")
                            
                            if arr.count == 2 {
                                lbl_EndSchDate.text = arr[0]
                                lbl_EndSchTime.text = arr[1]
                            }else{
                                lbl_EndSchDate.text = arr[0]
                                lbl_EndSchTime.text = arr[1] + " " + arr[2]
                            }
                        }
                    }else{
                        let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy_HH_mm)
                        if(value == "orderedDescending"){
                            ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                        }else{
                            let arr = strDate.components(separatedBy: " ")
                            
                            if arr.count == 2 {
                                lbl_EndSchDate.text = arr[0]
                                lbl_EndSchTime.text = arr[1]
                            }else{
                                lbl_EndSchDate.text = arr[0]
                                lbl_EndSchTime.text = arr[1] + " " + arr[2]
                            }
                        }
                    }
                    }
                
                
                
            }
        }
        
        @IBAction func btnCancelAction(_ sender: Any) {
            self.bgViewOfPicker.isHidden = true
        }
       
        
        //==========================
    //MARK:- Get Country Json
    //==========================
        
        func getCountry() -> NSArray {
            return getJson(fileName: "countries")["countries"] as! NSArray
        }
        
        func getStates() -> NSArray {
            return getJson(fileName: "states")["states"] as! NSArray
        }
        
        @IBAction func refresh(_ sender: Any) {
        }
        @IBAction func jobPriority_Btn(_ sender: Any) {
        }
        @IBAction func txtfldClientBtn(_ sender: Any) {
        }
        
        @IBAction func txtfldcontact_Btn(_ sender: Any) {
        }
        @IBAction func txtfld_siteBtn(_ sender: Any) {
        }
        @IBAction func txtfld_stateBtn(_ sender: Any) {
        }
        @IBAction func txtfld_countryBtn(_ sender: Any) {
        }
        @IBAction func scheduleStartBtn(_ sender: Any) {
            //showDatePicker()
        }
        @IBAction func schedulestartTimeBtn(_ sender: Any) {
        }
        @IBAction func schedeuleEndBtn(_ sender: Any) {
            
        }
        @IBAction func scheduleEndTimeBtn(_ sender: Any) {
        }
        
        @IBAction func btnSubmitClickAction(_ sender: Any) {
            
            let trimmClintNm  = trimString(string: self.txtfld_Client.text!)
            let trimmAdr = trimString(string: self.txtfld_Address.text!)
            let trimmMobNo = trimString(string: self.txtfld_MobNo.text!)
            let trimmAltMobNo = trimString(string: self.txtfld_AltMobNo.text!)
            let trimmEmail = trimString(string: self.txtfld_Email.text!)
            
            let trimmAltSite = trimString(string: self.txtfld_SiteName.text!)
            let trimmContact = trimString(string: self.txtfld_Contact.text!)
            
//            let jobPrty = getPriortyRawValueAccordingToText(txt: (txtfld_JobPriority.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
            
            if trimmEmail.count > 0 {
                if !isValidEmail(testStr: trimmEmail)  {
                    ShowError(message: AlertMessage.validEmailId, controller: windowController)
                    return
                }
            }
            
            
            if (trimmMobNo.count > 0) && (trimmMobNo.count < 8) {
                ShowError(message: AlertMessage.validMobile, controller: windowController)
                    return
                }
            
            
            if trimmAltMobNo.count > 0 && trimmAltMobNo.count < 8  {
                ShowError(message: AlertMessage.validAlMobileNo, controller: windowController)
                    return
                }
            
            
           // self.addAudit()
            
           // if(param.jtId != nil && param.jtId!.count > 0){

                        if (trimmClintNm != ""){
//                              if (trimmContact != ""){
//                                  if (trimmAltSite != ""){
                            
                            
                            if(trimmAdr != ""){
                                if(param.ctry != nil) && (param.ctry != ""){
                                    if(param.state != nil) && (param.state != ""){
                                        
                                        if !isHaveNetowork() {
                                            if imgArr.count > 0 {
                                                
                                                ShowError(message: LanguageKey.offline_feature_alert, controller: windowController)
                                                
                                            }else{
                                               self.addAudit()
                                            }
                                        }else{
                                           self.AuditOnlineApiCalling()
                                        }
                                    
                                    } else {
                                        ShowError(message: AlertMessage.validState, controller: windowController)
                                    }
                                } else {
                                    ShowError(message: AlertMessage.selectCountry, controller: windowController)
                                }
                                } else {
                                        ShowError(message: AlertMessage.validAddress, controller: windowController)
                                    }
//                                } else {
//                                    ShowError(message: "Please enter Site", controller: windowController)
//                                }
//                            } else {
//                                ShowError(message: "Please enter Contact", controller: windowController)
//                            }
                        } else {
                            ShowError(message: AlertMessage.clientName, controller: windowController)
                        }
              // }
        }
        
        @IBAction func btnActionMethod(_ sender: UIButton) {
          //  self.sltDropDownBtnTag  = sender.tag
           // self.callMethodforOpenDwop(tag: sender.tag)
            
        }
        
        @IBAction func showTags(_ sender: UIButton) {
            self.sltDropDownBtnTag  = sender.tag
            self.callMethodforOpenDwop(tag: sender.tag)
        }
        
        
        
        func callMethodforOpenDwop(tag : Int){
            if(self.optionalVw != nil){
                self.removeOptionalView()
                  return
            }
        
            switch tag {
            case 0:
                
    //            if(self.optionalVw == nil){
    //                arra = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
    //                arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
    //                if(arrOfShowData.count > 0){
                        self.searchDropDwnView.isHidden = false
                               self.searchBackBtn.isHidden = false
                        self.searchTxtFld.text = ""
                           searcharraisbol = false
    //
    //                    self.openDwopDown( txtField: self.txtfldJobTitle, arr: arrOfShowData)
    //                }else{
    //                    ShowError(message: AlertMessage.noJobTitleAvailable , controller: windowController)
    //                }
    //            }else{
    //                self.removeOptionalView()
    //            }
    //

                break
            case 1:
                
                self.openDwopDown( txtField: self.txtfld_JobPriority, arr: arrOfPriroty)
                break
            case 2:
               // self.openDwopDown( txtField: self.txtfld_Client, arr: arrClintList)

               // if(btnClient.imageView?.image == UIImage(named: "arrowdown")){
                if(self.param.cltId != nil && self.param.cltId != ""){
                    self.openDwopDown( txtField: self.txtfld_Client, arr: arrClintList)

                }else{
                    param.cltId = nil
                    param.nm = self.txtfld_Client.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    if(btnClient.imageView?.image == UIImage(named: "BoxOFUncheck")){
                        self.btnClient.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
                      
                        self.isClintFutUser = true
                    }else{
                        self.btnClient.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        self.isClintFutUser = false

                    }
                }
                break
            case 3:
                if(self.txtfld_Client.text?.isEmpty)!{
                    self.removeOptionalView()
                    break
                }
                
              //  if(btnContact.imageView?.image == UIImage(named: "arrowdown")){
                
                if(self.param.conId != nil && self.param.conId != ""){
                    
                  //  FltArrClintList = self.filterArrUsingpredicate(txtFid: txtfld_Client, txt: txtfld_Client.text! , range : nil , arr : arrClintList, predecateIdentity: "nm") as! [ClientList]
                 //   self.openDwopDown( txtField: self.txtfld_Contact, arr: FltArrClintList)

                    if(param.cltId != nil){
                        let query = "cltId = '\(param.cltId!)'"
                        arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
                        if(arrOfShowData.count > 0){
                            self.openDwopDown( txtField: self.txtfld_Contact, arr: arrOfShowData)
                            
                        }
                    }

                }else{
                    param.conId = nil
                    param.cnm = self.txtfld_Contact.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    if(btnContact.imageView?.image == UIImage(named: "BoxOFUncheck")){
                        self.btnContact.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
                     
                        self.isContactFutUser = true
                    }else{
                        self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        self.isContactFutUser = false
                        
                    }
                }
               
                break
            case 4:
                if(self.txtfld_Client.text?.isEmpty)!{
                    self.removeOptionalView()
                    break
                }
              //  if(btnSitName.imageView?.image == UIImage(named: "arrowdown")){
                if(self.param.siteId != nil && self.param.siteId != ""){
    //                FltArrClintList = self.filterArrUsingpredicate(txtFid: txtfld_Client, txt: txtfld_Client.text! , range : nil , arr : arrClintList, predecateIdentity: "nm") as! [ClientList]
    //                self.openDwopDown( txtField: self.txtfld_SiteName, arr:FltArrClintList)
                                         self.btnSitName.isUserInteractionEnabled = false
                                         self.btnSitName.isHidden = true
                                         self.txtfld_SiteName.text = ""
                                         self.isSitFutUser = true
                    
                    if(param.cltId != nil){
                        let query = "cltId = '\(param.cltId!)'"
                        arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
                         self.btnSitName.isHidden = true
                        if(arrOfShowData.count > 0){
                           // self.openDwopDown( txtField: self.txtfld_SiteName, arr: arrOfShowData)
                            
                        }
                    }
                }else{
                    param.siteId = ""
                    param.snm = self.txtfld_SiteName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    if(btnSitName.imageView?.image == UIImage(named: "BoxOFUncheck")){
                       // self.btnSitName.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
                        self.btnSitName.isUserInteractionEnabled = true
                        self.btnSitName.isHidden = true
                        self.isSitFutUser = true
                         self.txtfld_SiteName.isUserInteractionEnabled = true
                    }else{
                      //  self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        self.btnSitName.isUserInteractionEnabled = true
                           self.btnSitName.isHidden = true
                        self.txtfld_SiteName.isUserInteractionEnabled = true
                        self.isSitFutUser = false
                    }
                }
           
                break
            case 5:
                
                if(self.optionalVw == nil){
                    let namepredicate: NSPredicate = NSPredicate(format:"self.name == %@", self.txtfld_Country.text! )
                    let arr = getCountry().filtered(using: namepredicate)
                    if(arr.count > 0){
                        let dict = (arr[0] as? [String : Any])
                        let serchCourID = dict?["id"]
                        let bPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                        arrOfShowData =  getStates().filtered(using: bPredicate)
                        self.openDwopDown( txtField: self.txtfld_State, arr: arrOfShowData)
                    }
                    
                    
                }else{
                    self.removeOptionalView()
                    
                }
                
                break
            case 6://Country
                
                if(self.optionalVw == nil){
                    //  self.reradJson()
                    arrOfShowData = getJson(fileName: "countries")["countries"] as! [Any]
                    self.openDwopDown( txtField: self.txtfld_Country, arr: arrOfShowData)
                    
                }else{
                    self.removeOptionalView()
                }
                
                break
            case 7 :
                if(self.optionalVw == nil){
                  self.arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
                    if(arrOfShowData.count > 0){
                        self.openDwopDown(txtField: self.txtfld_FieldWorker, arr: self.arrOfShowData)
                    }
    //                else{
    //                    ShowError(message: AlertMessage.noFieldWorkerAvailable , controller: windowController)
    //                }
                }else{
                    self.removeOptionalView()

                }
                
            case 8 :
                
                if(self.optionalVw == nil){
                    self.arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TagsList", query: nil) as! [TagsList]
                    if(arrOfShowData.count > 0){
                        self.openDwopDown(txtField: self.taxFieldAddTags, arr: self.arrOfShowData)
                    }else{
                        ShowError(message: AlertMessage.noTagAvailable , controller: windowController)
                    }
                }else{
                    self.removeOptionalView()
                    
                }
    //            if(self.optionalVw == nil){
    //
    //                self.arrOfShowData =  APP_Delegate.arrOftags
    //               // if(self.arrOfShowData.count > 0){
    //                    self.openDwopDown(txtField: self.taxFieldAddTags, arr: self.arrOfShowData)
    //               // }else{
    //                  //  ShowError(message: "No Tag Available" , controller: windowController)
    //                //}
    //            }else{
    //                self.removeOptionalView()
    //
    //            }
            default:
                return
            }
        }
        
        func openDwopDown(txtField : UITextField , arr : [Any]) {
            if (optionalVw == nil){
                self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
                let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
                self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height), width: self.view.frame.size.width - 20, height: CGFloat((arr.count > 5) ? 150 : arr.count*38)))
                self.optionalVw?.delegate = self
                self.view.addSubview( self.optionalVw!)
                 self.scroll_View.isScrollEnabled = false
               
                self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                        self.removeOptionalView()
                   }
                    
                
                // self.optionalVw = nil
            }else{
                DispatchQueue.main.async {
                    self.removeOptionalView()
                }
            }
            
       }
        
        
        func openDwopDownForConstantHeight(txtField : UITextField , arr : [Any]) {
            if (optionalVw == nil){
                self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
                let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
                self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height), width: self.view.frame.size.width - 20, height: 100))
                self.optionalVw?.delegate = self
                self.view.addSubview( self.optionalVw!)
                self.scroll_View.isScrollEnabled = false
                
                self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                    self.removeOptionalView()
                }
                
                
                // self.optionalVw = nil
            }else{
                DispatchQueue.main.async {
                    self.removeOptionalView()
                }
            }
            
        }
       
        
        
        func removeOptionalView(){
            if optionalVw != nil {
                self.optionalVw?.removeFromSuperview()
                self.optionalVw = nil
                self.scroll_View.isScrollEnabled = true
                self.FltArrClintList.removeAll()
            }
       }
        
        func getArrForOptionalView( ) -> [Any]{
            switch self.sltDropDownBtnTag {
            case 0:
                 return arrOfShowData
            case 1:
                 return arrOfPriroty
            case 2:
                return FltArrClintList.count != 0 ? FltArrClintList : arrClintList
            case 3:
                return arrOfShowData
            case 4:
                return arrOfShowData
            case 5:
                return arrOfShowData
            case 6:
                return arrOfShowData
            case 7:
                return  arrOfShowData
            case 8:
                return  arrOfShowData
            case 9:
                return  ArrContrect
            default:
                return [""]
            }
         }
    //====================================================
    //MARK:- OptionView Delegate Methods
    //====================================================
        func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return getArrForOptionalView().count
        }
        
        func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
       
            
            if(cell == nil){
                cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
            }
            
            cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
            cell?.backgroundColor = .clear
            //cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
            cell?.textLabel?.textColor = UIColor.darkGray
            
            switch self.sltDropDownBtnTag {
            case 0:
    //            let jobTittleListData  =  arrOfShowData[indexPath.row] as? UserJobTittleNm
    //
    ////            let isExist = param.jtId?.contains{$0.jtId == jobTittleListData?.jtId}
    ////
    ////            if isExist! {
    ////                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
    ////            }else {
    ////                cell?.accessoryType = UITableViewCell.AccessoryType.none
    ////            }
    //
    //
    //            _ =  param.jtId?.contains{ ( arry : jtIdParam) -> Bool in
    //                if arry.jtId == jobTittleListData?.jtId{
    //                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
    //                    return true
    //                }else{
    //                    cell?.accessoryType = UITableViewCell.AccessoryType.none
    //                    return false
    //                }
    //            }
    //
    //            cell?.textLabel?.text = jobTittleListData?.title?.capitalizingFirstLetter()
                break
            case 1:
                 cell?.textLabel?.text = arrOfPriroty[indexPath.row].capitalizingFirstLetter()
                 break
                
            case 2:
               let clintList = self.FltArrClintList.count != 0 ? self.FltArrClintList[indexPath.row] : arrClintList[indexPath.row]
               
               cell?.textLabel?.text = clintList.nm?.capitalizingFirstLetter()
                break
                
            case 3:
                let cltAllContactList  =  arrOfShowData[indexPath.row] as? ClientContactList
                cell?.textLabel?.text = cltAllContactList?.cnm?.capitalizingFirstLetter()
                break
                
            case 4:
                let cltAllSiteList  =  arrOfShowData[indexPath.row] as? ClientSitList
                cell?.textLabel?.text = cltAllSiteList?.snm?.capitalizingFirstLetter()
                break
                
            case 5:
                if(arrOfShowData.count > 0){
                     cell?.textLabel?.text =  ((arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
                }
                break
                
            case 6:
                if(arrOfShowData.count > 0){
                        cell?.textLabel?.text =  ((arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
                }
           
                break
                
            case 7:
                cell?.textLabel?.text = (self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.fnm?.capitalizingFirstLetter()
                break
            case 8:
                cell?.textLabel?.text = (self.arrOfShowData[indexPath.row] as? TagsList)?.tnm?.capitalizingFirstLetter()
                break
            case 9:
                let cltAllSiteList  =  ArrContrect[indexPath.row].nm //arrOfShowData[indexPath.row] as? ContractList
                cell?.textLabel?.text = cltAllSiteList?.capitalizingFirstLetter()
              
                break
            default: break
                
            }
            return cell!
            
        }
        
        func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            switch self.sltDropDownBtnTag {
            case 0:
    //            let objOfArr = self.arrOfShowData[indexPath.row] as? UserJobTittleNm
    //
    //            if param.jtId == nil {
    //                param.jtId = [jtIdParam]()
    //            }
    //
    //            let jt = jtIdParam()
    //            jt.jtId = objOfArr?.jtId
    //            jt.title = objOfArr?.title
    //
    //            let isExist =  param.jtId?.contains{ ( arry : jtIdParam) -> Bool in
    //                if arry.jtId == jt.jtId{
    //                    return true
    //                }
    //                return false
    //            }
    //
    //            if !isExist!{
    //                 param.jtId?.append(jt)
    //            }else{
    //                let objIndex : Int? = param.jtId?.firstIndex(where: { (jtData : jtIdParam) -> Bool in
    //                    if jt.jtId == jtData.jtId{
    //                        return true
    //                    }else{
    //                        return false
    //                    }
    //                })
    //                if (objIndex != nil){
    //                    param.jtId?.remove(at: objIndex!)
    //                }
    //            }
    //
    //            if (param.jtId != nil && param.jtId!.count > 0) {
    //
    //                var strTitle = ""
    //                for jtid in param.jtId! {
    //                    if strTitle == ""{
    //                        strTitle = jtid.title ?? ""
    //                    }else{
    //                        strTitle = "\(strTitle), \(jtid.title ?? "")"
    //
    //                    }
    //                    DispatchQueue.main.async {
    //                        self.txtfldJobTitle.text = strTitle
    //                    }
    //
    //                }
    //            }else{
    //                self.txtfldJobTitle.text = ""
    //            }

                break
            case 1:
                self.txtfld_JobPriority.text = self.arrOfPriroty[indexPath.row]
                break
            case 2:
                   let objOfArr = self.FltArrClintList.count != 0 ? self.FltArrClintList[indexPath.row] : arrClintList[indexPath.row]
                   self.txtfld_Client.text = objOfArr.nm
                   param.nm = objOfArr.nm
                   param.cltId = objOfArr.cltId
                   //self.btnClient.setImage(UIImage(named: "arrowdown"), for: .normal)
                   self.btnSitName.isHidden = false
                 //  self.btnClient.isHidden = true
                   self.txtfld_SiteName.isUserInteractionEnabled = true

                   let query = "cltId = '\(objOfArr.cltId!)' AND def = '1'"

                   //For Contact
                   let arrOfContNm = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
                   if(arrOfContNm.count > 0){
                    let contact = arrOfContNm[0]
                    self.txtfld_Contact.text = contact.cnm
                    param.conId = contact.conId
                    //self.btnContact.setImage(UIImage(named: "arrowdown"), for: .normal)
                   // self.btnContact.isHidden = false
                    self.btnContact.isHidden = true
                
                    txtfld_MobNo.text = contact.mob1
                    txtfld_AltMobNo.text = contact.mob2
                    txtfld_Email.text = contact.email
                    stringToHtmlFormate()
                   }else{
                    self.txtfld_Contact.text = ""
                    param.conId = nil
                   // self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                    self.btnContact.isHidden = true
                    txtfld_MobNo.text = ""
                    txtfld_AltMobNo.text = ""
                    txtfld_Email.text = ""
                   }
                   
                   //For Site
                   let arrOfSiteNm = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
                     if(arrOfSiteNm.count > 0){
                         let site = arrOfSiteNm[0]
                         self.txtfld_SiteName.text = site.snm
                         param.siteId = site.siteId
    //                   self.btnSitName.setImage(UIImage(named: "arrowdown"), for: .normal)
                        self.btnSitName.isHidden = true
                        self.txtfld_SiteName.isUserInteractionEnabled = false
                        //self.btnSitName.isHidden = true
                        
                        txtfld_City.text = site.city
                        txtfld_Address.text = site.adr
                        txtfld_PostalCode.text = site.zip
                        latitued.text = site.lat
                        longitued.text = site.lng
                        
                        let ctrsname = filterStateAccrdToCountry(serchCourID: (site.ctry)!, searchPredicate: "id", arr: getCountry() as! [Any])
                        let statename = filterStateAccrdToCountry(serchCourID: (site.state)!, searchPredicate: "id", arr: getStates() as! [Any])
                        txtfld_Country.text = ctrsname.count != 0 ? (ctrsname[0] as? [String : Any])!["name"] as? String  : ""
                        txtfld_State.text = statename.count != 0 ? (statename[0] as? [String : Any])!["name"] as? String : ""
                        
                        param.ctry = ctrsname.count>0 ? site.ctry : ""
                        param.state = statename.count>0 ? site.state : ""
                  
                     }else{
                        self.txtfld_SiteName.text = ""
                        param.siteId = nil
                        //self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        self.btnSitName.isHidden = true
                        txtfld_City.text = ""
                        txtfld_Address.text = ""
                        txtfld_PostalCode.text = ""
                        txtfld_Country.text = ""
                        txtfld_State.text = ""
                        param.ctry = nil
                        param.state = nil
                        
                       }
                   
               
                break
            case 3: // Contact
                let cltAllContactList  =  arrOfShowData[indexPath.row] as? ClientContactList
                self.txtfld_Contact.text = cltAllContactList?.cnm
                param.cnm = cltAllContactList?.cnm
                param.conId = cltAllContactList?.conId
                self.btnContact.isHidden = true
                txtfld_MobNo.text = cltAllContactList?.mob1 != nil ? cltAllContactList?.mob1 : ""
                txtfld_AltMobNo.text = cltAllContactList?.mob2 != nil ? cltAllContactList?.mob2 : ""
                txtfld_Email.text = cltAllContactList?.email != nil ? cltAllContactList?.email : ""
                
                break
            case 4: // Site
                let cltAllSieList  =  arrOfShowData[indexPath.row] as? ClientSitList
                self.txtfld_SiteName.text = cltAllSieList?.snm
                param.siteId = cltAllSieList?.siteId
                param.snm = cltAllSieList?.snm
                self.btnSitName.isHidden = true
                txtfld_City.text = cltAllSieList?.city != nil ? cltAllSieList?.city : ""
                txtfld_Address.text = cltAllSieList?.adr != nil ? cltAllSieList?.adr : ""
                txtfld_PostalCode.text = cltAllSieList?.zip != nil ? cltAllSieList?.zip : ""
                break
            case 5: // For State
                self.txtfld_State.text =  (arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String
                param.state = (arrOfShowData[indexPath.row] as? [String : Any])?["id"] as? String
                self.removeOptionalView()
                break
            case 6: // For Country
                self.txtfld_Country.text = (arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String
                let countryID = (arrOfShowData[indexPath.row] as? [String : Any])?["id"] as? String
                param.ctry = countryID
                let idPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", countryID! )
                let arrOfstate =  getStates().filtered(using: idPredicate)
                self.txtfld_State.text = (arrOfstate[0] as? [String : Any])?["name"] as? String
                param.state = (arrOfstate[0] as? [String : Any])?["id"] as? String
                self.removeOptionalView()
                break
            case 7:
                
              let isExist = self.FltWorkerId.contains(((self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.usrId)!)
                if(!isExist){
                    createTags(strName: ((self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.fnm)!, view: self.tagView)
                    self.FltWorkerId.append(((self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.usrId)!)
                }
                self.txtfld_FieldWorker.text = ""
                break
                
                case 8:
                    self.scroll_View.isScrollEnabled = true
                    
            
                    let sltTagsNM = (self.arrOfShowData[indexPath.row] as? TagsList)?.tnm?.capitalizingFirstLetter()


                    let isExist =  arrOfaddTags.contains{ ( dict : [String : String]) -> Bool in

                        if dict["tnm"] == sltTagsNM?.capitalizingFirstLetter(){
                            return true
                        }
                        return false
                    }
                    if(!isExist){
                        self.tagVw_OFTag.addTag(sltTagsNM!.capitalizingFirstLetter(), withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: true)
                        /*let dict = ["tagId" : String(arrOfaddTags.count + 1),
                         "tnm" : trimValue]*/
                        
                        let dict = ["tagId" : (self.arrOfShowData[indexPath.row] as? TagsList)?.tagId,
                                    "tnm" : sltTagsNM?.capitalizingFirstLetter()]
                        
                        arrOfaddTags.append(dict as! [String : String])
                        self.tagVw_OFTag.deleteBlock = {(tagText : String ,idx : Int) -> Void in
                            self.tagVw_OFTag.deleteTag(at: idx)
                            self.arrOfaddTags.remove(at: idx)
                        }
                    }
                    
                    self.taxFieldAddTags.text = ""
                break
                
                case 9:
                    
                    self.contrectTxtFld.text = ArrContrect[indexPath.row].nm
                        param.contrId =  ArrContrect[indexPath.row].contrId

               // break
//                case 10:
//                               if discpFirstTittle == false {
//                                    self.textView.text = ""
//                                     discpFirstTittle = true
//                               }
                
                
            default: break
                
            }
                  self.removeOptionalView()
        }
        
        func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 38.0
        }
        
        func filterStateAccrdToCountry(serchCourID : String, searchPredicate : String , arr : [Any])-> [Any]{
            let bPredicate: NSPredicate = NSPredicate(format:"self.%@ == %@", searchPredicate ,serchCourID )
            return (arr as NSArray).filtered(using: bPredicate)
            
        }
        
    //====================================================
    //MARK:-  Create Tags
    //====================================================
        func createTags(strName : String , view : ASJTagsView){
            view.addTag(strName, withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: true)
               view.deleteBlock = {(tagText : String ,idx : Int) -> Void in
               view.deleteTag(at: idx)
              self.FltWorkerId.remove(at: idx)
            }
        }
        
    //====================================================
    //MARK:- TxtField Delegate Methods
    //====================================================

        func openDropDownWhenKeyBordappere(){
            
          if self.sltTxtField.isEqual(txtfld_Client){
                self.removeOptionalView()
                self.openDwopDown( txtField: self.txtfld_Client, arr: arrClintList)
            }else if self.sltTxtField.isEqual(txtfld_Contact){
                self.removeOptionalView()
                if(param.cltId != nil){
                    let query = "cltId = '\(param.cltId!)'"
                    arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
                    if(arrOfShowData.count > 0){
                        self.openDwopDown( txtField: self.txtfld_Contact, arr: arrOfShowData)
                        
                    }else{
                        self.btnContact.isHidden = false
                        self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                    }
                }
            }else if self.sltTxtField.isEqual(txtfld_SiteName){
                self.removeOptionalView()
                if(param.cltId != nil){
                    let query = "cltId = '\(param.cltId!)'"
                    arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
                    if(arrOfShowData.count > 0){
                        self.btnSitName.isHidden = true
                        //self.openDwopDown( txtField: self.txtfld_SiteName, arr: arrOfShowData)
                        
                    }else{
                        self.btnSitName.isHidden = false
                        self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                    }
                }
                
            }else if self.sltTxtField.isEqual(txtfld_Country) {
           // self.txtfld_Country.text = ""
             self.txtfld_State.isEnabled = true
                self.removeOptionalView()
                arrOfShowData = getJson(fileName: "countries")["countries"] as! [Any]
                self.openDwopDown( txtField: self.txtfld_Country, arr: arrOfShowData)
            
                
                
            }else if self.sltTxtField.isEqual(txtfld_State){
            //self.txtfld_State.text = ""
            if(txtfld_Country.text == nil || txtfld_Country.text == ""){
                self.txtfld_State.isEnabled = false
                ShowError(message: AlertMessage.selectCountry, controller: self)
                return
              }
                self.removeOptionalView()
                let namepredicate: NSPredicate = NSPredicate(format:"self.name == %@", self.txtfld_Country.text! )
                let arr = getCountry().filtered(using: namepredicate)
                if(arr.count > 0){
                    let dict = (arr[0] as? [String : Any])
                    let serchCourID = dict?["id"]
                    let bPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                    arrOfShowData =  getStates().filtered(using: bPredicate)
                    self.openDwopDown( txtField: self.txtfld_State, arr: arrOfShowData)
                }
          }else if self.sltTxtField.isEqual(taxFieldAddTags) {
            self.removeOptionalView()
             self.arrOfShowData  = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TagsList", query: nil) as! [TagsList]

            //self.arrOfShowData = APP_Delegate.arrOftags
            self.openDwopDown( txtField: self.taxFieldAddTags, arr: self.arrOfShowData)
            
            
          }else if self.sltTxtField.isEqual(contrectTxtFld) {
            self.removeOptionalView()
             self.arrOfShowData  = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TagsList", query: nil) as! [TagsList]

            //self.arrOfShowData = APP_Delegate.arrOftags
            self.openDwopDown( txtField: self.contrectTxtFld, arr: self.arrOfShowData)
            
            
          }else{
                self.removeOptionalView()
            }
            
        }

        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            
            /////////////////////////auditcustomfield//////////////////////////
            
                textField.resignFirstResponder()
            ////////////////////////////////////////////////////////////////////////////
            
            self.removeOptionalView()
            
            if(self.sltTxtField.isEqual(txtfld_Client)){
                self.btnClient.isHidden = true
                self.btnContact.isHidden = true
                self.btnSitName.isHidden = true
                self.param.cltId = nil
                self.param.conId = nil
                self.param.siteId = nil
                self.param.nm = ""
                self.param.cnm = ""
                self.param.snm = ""
                txtfld_MobNo.text = ""
                txtfld_AltMobNo.text = ""
                txtfld_Email.text = ""
                txtfld_City.text = ""
                txtfld_Address.text = ""
                txtfld_Contact.text = ""
                txtfld_SiteName.text = ""
                txtfld_PostalCode.text = ""
                txtfld_Country.text = ""
                txtfld_State.text = ""
                param.ctry = nil
                param.state = nil
                
            }else if(self.sltTxtField.isEqual(txtfld_Contact)){
                self.btnContact.isHidden = true
                self.param.conId = nil
                self.param.cnm = ""
                
                
            }else if(self.sltTxtField.isEqual(txtfld_SiteName)){
                self.btnSitName.isHidden = true
                self.param.siteId = nil
                self.param.snm = ""
                
                
            }
            
            textField.text = ""
            return true
        }
        

    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //          self.sltTxtField = textField
    //          self.sltDropDownBtnTag = textField.tag
    //        if(self.sltTxtField.isEqual(txtfld_Country)){
    //            txtfld_Country.text = ""
    //        } else if self.sltTxtField.isEqual(txtfld_State){
    //            txtfld_State.text = ""
    //        }
    //          self.removeOptionalView()
    //    }
          func textViewDidBeginEditing(_ textView: UITextView) {
                if textView.text == LanguageKey.audit_desc {
                             textView.text = nil
                             textView.textColor = UIColor.lightGray
                         }
       
            }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            
            /////////////////////////auditcustomfield//////////////////////////
            
               selectedTxtField = textField
                textField.text = ""
            ////////////////////////////////////////////////////////////////////////////
            
            self.sltTxtField = textField
            self.sltDropDownBtnTag = textField.tag
            if(self.sltTxtField.isEqual(txtfld_Country)){
                txtfld_Country.text = ""
                param.ctry = nil
            } else if self.sltTxtField.isEqual(txtfld_State){
                txtfld_State.text = ""
                param.state = nil
            }
            self.removeOptionalView()
            if txtfld_MobNo.text!.isEmpty {
                       txtfld_MobNo.text = contryCode + txtfld_MobNo.text!
                       txtfld_MobNo.textColor = UIColor.lightGray
                   }
                   if txtfld_AltMobNo.text!.isEmpty {
                       txtfld_AltMobNo.text = contryCode + txtfld_AltMobNo.text!
                       txtfld_AltMobNo.textColor = UIColor.lightGray
                   }
        }
        
       
        
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            /////////////////////////auditcustomfield//////////////////////////
                    
            self.txtFieldData  = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            ////////////////////////////////////////////////////////////////////////////
            
            
             self.sltDropDownBtnTag = textField.tag
            let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            
           
            if (textField == txtfld_PostalCode) {
                             
                             if (string != "") && (textField.text?.count)! > 7 {
                                 return false
                             }
                   }
                   
            
            if (textField == txtfld_MobNo) || (textField == txtfld_AltMobNo){
                
                if (string != "") && (textField.text?.count)! > 14 {
                    return false
                }
                
                let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
            
            if (textField == latitued) || (textField == longitued){
                let insensitiveCount = result.lowercased().filter{ $0 == Character(String(".").lowercased())}
                if insensitiveCount.count > 1 {
                    return false
                }
             
                
                let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
                
            }
            
            if (textField == taxFieldAddTags){
                if result.count > 0 {
                    btnAdd.isUserInteractionEnabled = true
                    btnAdd.alpha = 1
                }else{
                    btnAdd.isUserInteractionEnabled = false
                    btnAdd.alpha = 0.4
                    
                }
            }
            
            
            

            
            switch self.sltDropDownBtnTag {
            case 0:
                
    //             let bPredicate: NSPredicate = NSPredicate(format: "self.title beginswith[c] '%@'", result)
    //             let arrAlljobTittle = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
    //
    //            arrOfShowData = (arrAlljobTittle as NSArray).filtered(using: bPredicate)
    //            self.openDwopDown( txtField: self.txtfldJobTitle, arr: arrOfShowData)
    //
    //            DispatchQueue.main.async{
    //                if(self.arrOfShowData.count > 0){
    //                    self.optionalVw?.isHidden = false
    //                    self.optionalVw?.table_View?.reloadData()
    //                }else{
    //                    self.optionalVw?.isHidden = true
    //                }
    //            }
             //   self.searchDropDwnView.isHidden = false
                     //  self.searchBackBtn.isHidden = false
                break
            case 2:
                self.clientSelf = true
                
                txtfld_MobNo.text = ""
                txtfld_AltMobNo.text = ""
                txtfld_Email.text = ""
                txtfld_City.text = ""
                txtfld_Address.text = ""
                txtfld_Contact.text = ""
                txtfld_SiteName.text = ""
                txtfld_PostalCode.text = ""
                txtfld_Country.text = ""
                txtfld_State.text = ""
                param.ctry = nil
                param.state = nil


                FltArrClintList = self.filterArrUsingpredicate(txtFid: textField, txt: string , range : range , arr : arrClintList, predecateIdentity: "nm") as! [ClientList]
                if(self.optionalVw == nil){
                 self.openDwopDown( txtField: self.txtfld_Client, arr: FltArrClintList)
                }
                 self.optionalVw?.isHidden = false
                DispatchQueue.main.async{
                    if(self.FltArrClintList.count > 0){
                        
                        // self.btnClient.isHidden = true
                        //  self.btnClient.isHidden = false
                        self.btnContact.isHidden = true
                        self.btnSitName.isHidden = false
                        
                        self.btnClient.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        self.param.cltId = nil
                        self.param.nm = result
                        self.param.siteId = nil
                        self.param.snm = self.txtfld_SiteName.text
                        self.txtfld_SiteName.text = "self"
                        self.txtfld_SiteName.isUserInteractionEnabled = false
                        self.param.conId = nil
                        self.param.cnm = self.txtfld_Contact.text
                        self.txtfld_Contact.text = "self"
                        //                    self.btnClient.setImage(UIImage(named: "arrowdown"), for: .normal)
                        //                    self.btnContact.setImage(UIImage(named: "arrowdown"), for: .normal)
                        //                    self.btnSitName.setImage(UIImage(named: "arrowdown"), for: .normal)
                        //                    self.btnClient.isHidden = false
                        //                    self.btnContact.isHidden = false
                        self.btnSitName.isHidden = false
                        self.optionalVw?.table_View?.reloadData()
                    }else{
                        if(result != ""){ // When Txtfield emprt remove dropdown buttton
                            self.removeOptionalView()
                            //                      self.btnClient.isHidden = false
                            //                        self.btnContact.isHidden = false
                            self.btnSitName.isHidden = false
                            self.btnClient.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                            //self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                            //self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                            self.param.cltId = nil
                            self.param.nm = result
                            
                            self.param.conId = nil
                            self.param.cnm = ""
                            self.btnContact.isHidden = true
                            
                            // self.param.cnm = self.txtfld_Contact.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                            self.param.siteId = nil
                            self.param.snm = self.txtfld_SiteName.text
                            self.txtfld_SiteName.text = "self"
                            self.btnSitName.isHidden = true
                            self.txtfld_SiteName.isUserInteractionEnabled = true
                        }else{
                            self.removeOptionalView()
                            self.param.cltId = nil
                            self.param.siteId = nil
                            self.param.conId = nil
                            self.param.nm = ""
                            self.param.cnm = ""
                            self.param.snm = ""
                            self.btnClient.isHidden = true
                            self.btnContact.isHidden = true
                            self.btnSitName.isHidden = true
                        }
                    }
                }
                break
            case 3:
                
                txtfld_MobNo.text = ""
                txtfld_AltMobNo.text = ""
                txtfld_Email.text = ""
                
                if let arr = param.cltId?.components(separatedBy: "-"){
                    if(param.cltId != nil && param.cltId != "" && arr[0] != "Client"){
                        
                        
                        let query = "cltId = '\(param.cltId!)'"
                        let arrOFFltcontctList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
                        let bPredicate: NSPredicate = NSPredicate(format: "self.cnm beginswith[c] %@", result)
                        arrOfShowData = (arrOFFltcontctList as NSArray).filtered(using: bPredicate)
                        if(arrOfShowData.count > 0){
                            if(self.optionalVw == nil){
                                self.openDwopDown( txtField: self.txtfld_Contact, arr: arrOfShowData)
                            }
                            DispatchQueue.main.async{
                                //                        self.btnContact.isHidden = false
                                //                        self.btnContact.setImage(UIImage(named: "arrowdown"), for: .normal)
                                // self.btnContact.isHidden = true
                                self.btnContact.isHidden = false
                                self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                                self.param.conId = nil
                                self.param.cnm = result
                                self.optionalVw?.table_View?.reloadData()
                            }
                        }else{
                            if(result != ""){
                                self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                                self.btnContact.isHidden = false
                                param.conId = nil
                                param.cnm = result
                                self.removeOptionalView()
                            }else{
                                self.btnContact.isHidden = true
                                param.conId = nil
                                param.cnm = ""
                                self.removeOptionalView()
                            }
                            
                        }
                        
                        
                    }else{
                        self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        self.btnContact.isHidden = false
                        param.conId = nil
                        param.cnm = result
                    }
                }else{
                    param.conId = nil
                    param.cnm = result
                }
                
                break
            case 4:
                
                txtfld_City.text = ""
                txtfld_Address.text = ""
                txtfld_PostalCode.text = ""
                txtfld_Country.text = ""
                txtfld_State.text = ""
                param.ctry = nil
                param.state = nil
                
                
                if let arr = param.cltId?.components(separatedBy: "-"){
                    if(param.cltId != nil && param.cltId != "" && arr[0] != "Client"){
                        
                        let query = "cltId = '\(param.cltId!)'"
                        let arrOfSiteNm = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
                        let bPredicate: NSPredicate = NSPredicate(format: "self.snm beginswith[c] %@", result)
                        arrOfShowData = (arrOfSiteNm as NSArray).filtered(using: bPredicate)
                        if(arrOfShowData.count > 0){
                            if(self.optionalVw == nil){
                                // self.openDwopDown( txtField: self.txtfld_SiteName, arr: arrOfShowData)
                            }
                            DispatchQueue.main.async{
                                //                                self.btnSitName.isHidden = false
                                //                                self.btnSitName.setImage(UIImage(named: "arrowdown"), for: .normal)
                                //self.btnSitName.isHidden = true
                                
                                //   self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                                self.btnSitName.isHidden = true
                                self.param.siteId = nil
                                self.param.snm = result
                                self.optionalVw?.table_View?.reloadData()
                            }
                        }else{
                            if(result != ""){
                                //   self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                                self.btnSitName.isHidden = true
                                param.siteId = nil
                                param.snm = result
                                self.removeOptionalView()
                            }else{
                                self.btnSitName.isHidden = true
                                param.siteId = nil
                                param.snm = ""
                                self.removeOptionalView()
                            }
                            
                        }
                        
                    }else{
                        self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        self.btnSitName.isHidden = false
                        param.siteId = nil
                        param.snm = result
                    }
                    
                }
                param.snm = self.txtfld_SiteName.text
                break
            case 5: // State
                
                let namepredicate: NSPredicate = NSPredicate(format:"self.name = %@", txtfld_Country.text! )
                let arr = getCountry().filtered(using: namepredicate)
                if(arr.count > 0){
                    self.optionalVw?.isHidden = false
                    let dict = (arr[0] as? [String : Any])
                    let serchCourID = dict?["id"]
                    let idPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                    let arrOfstate =  getStates().filtered(using: idPredicate)
                    let bPredicate: NSPredicate = NSPredicate(format: "self.name beginswith[c] %@", result)
                    arrOfShowData =  ((arrOfstate as NSArray).filtered(using: bPredicate))
                    if(self.optionalVw == nil){
                        self.openDwopDownForConstantHeight( txtField: self.txtfld_State, arr: arrOfShowData)
                    }
                }
                DispatchQueue.main.async{
                    if(self.arrOfShowData.count > 0){
                        self.optionalVw?.isHidden = false
                        self.optionalVw?.table_View?.reloadData()
                    }else{
                        self.optionalVw?.isHidden = true
                    }
                }
                
                break
            case 6: // Country
                
                let bPredicate: NSPredicate = NSPredicate(format: "self.name beginswith[c] %@", result)
                arrOfShowData =  getCountry().filtered(using: bPredicate)
                if(self.optionalVw == nil){
                    self.openDwopDownForConstantHeight( txtField: self.txtfld_Country, arr: arrOfShowData)
                }
                DispatchQueue.main.async{
                    if(self.arrOfShowData.count > 0){
                        self.optionalVw?.isHidden = false
                        self.optionalVw?.table_View?.reloadData()
                    }else{
                        self.optionalVw?.isHidden = true
                    }
                }
                break
            case 7 :
                
                let bPredicate: NSPredicate = NSPredicate(format: "self.fnm beginswith[c] '%@'", result)
                
                let allFldWorkerNm = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
                arrOfShowData =  (allFldWorkerNm as NSArray).filtered(using: bPredicate)
                if(self.optionalVw == nil){
                    self.openDwopDown( txtField: self.txtfld_FieldWorker, arr: arrOfShowData)
                }
                DispatchQueue.main.async{
                    if(self.arrOfShowData.count > 0){
                        self.optionalVw?.isHidden = false
                        self.optionalVw?.table_View?.reloadData()
                    }else{
                        self.optionalVw?.isHidden = true
                    }
                }
                break
                
            case 15 :
                //                let bPredicate: NSPredicate = NSPredicate(format: "self.title beginswith[c] " , result)
                //                       let  filterTitles = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm] //(arrOfTitles as NSArray).filtered(using: bPredicate) as! [UserJobTittleNm]
                //                 arra =  (filterTitles as NSArray).filtered(using: bPredicate)
                //                       if(self.arra.count > 0){
                //                           DispatchQueue.main.async {
                //                           // self.searchTxtFld.text = arra
                //                              // self.openDwopDown(txtField: self.txtItem, arr: self.filterTitles)
                //                           }
                //                       }else{
                //                          // self.removeOptionalView()
                //                       }
                //
                
                
                searcharra = arra.filter( { (rafflePrograms: Any) -> Bool in
                    return (rafflePrograms as AnyObject).title?.lowercased().range(of: result.lowercased()) != nil
                })
                if result == ""{
                    searcharraisbol = false
                }else{
                    searcharraisbol = true
                }
                self.tableView.reloadData()
                
                break
            case 8 :
                
                //            arrOfShowData =  APP_Delegate.arrOftags.filter({ (tag : tagElements) -> Bool in
                //                let stringMatch = tag.tnm?.lowercased().range(of: result.lowercased())
                //                return stringMatch != nil ? true : false
                //            })
                
                
                let bPredicate: NSPredicate = NSPredicate(format: "self.tnm beginswith[c] '%@'", result)
                
                let allTags = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TagsList", query: nil) as! [TagsList]
                arrOfShowData =  (allTags as NSArray).filtered(using: bPredicate)
                
                
                if(self.optionalVw == nil){
                    
                    self.openDwopDown( txtField: self.taxFieldAddTags, arr: arrOfShowData)
                }
                DispatchQueue.main.async{
                    if(self.arrOfShowData.count > 0){
                        self.optionalVw?.isHidden = false
                        self.optionalVw?.table_View?.reloadData()
                    }else{
                        self.removeOptionalView()
                    }
                }
                
                break
            case 9 :
                
                //            arrOfShowData =  APP_Delegate.arrOftags.filter({ (tag : tagElements) -> Bool in
                //                let stringMatch = tag.tnm?.lowercased().range(of: result.lowercased())
                //                return stringMatch != nil ? true : false
                //            })
                
                
                let bPredicate: NSPredicate = NSPredicate(format: "self.tnm beginswith[c] '%@'", result)
                
                let allTags = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TagsList", query: nil) as! [TagsList]
                arrOfShowData =  (allTags as NSArray).filtered(using: bPredicate)
                
                
                if(self.optionalVw == nil){
                    
                    self.openDwopDown( txtField: self.taxFieldAddTags, arr: arrOfShowData)
                }
                DispatchQueue.main.async{
                    if(self.arrOfShowData.count > 0){
                        self.optionalVw?.isHidden = false
                        self.optionalVw?.table_View?.reloadData()
                    }else{
                        self.removeOptionalView()
                    }
                }
                
                break
                
            default:
                
                break
            }
            
            
            
            return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
              self.txtViewData  = (textView.text as NSString).replacingCharacters(in: range, with: text)
              if(self.txtViewData?.trimmingCharacters(in: .whitespaces) == ""){
                  textView.textColor = UIColor.lightGray
              }else{
                  textView.textColor = UIColor.black
              }
              return true
          }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 15 || textField.tag == 0 || textField.tag == 2 || textField.tag == 8 || textField.tag == 9 || textField.tag == 5 || textField.tag == 6 || textField.tag == 4 || textField.tag == 3 {
         //   print("nothing to print")
        }else  if arrOfShowData11.count > 0 {
            
                 let customFormDetals = arrOfShowData11[textField.tag]
                 let opt = OptDetals(key: "0", questions: nil, value: textField.text, optHaveChild: nil)
                 let layer = String(format: "%d.1", (textField.tag + 1))
                 self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals as! CustomFormDetals)
           }
        
       }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        
        func filterArrUsingpredicate(txtFid : UITextField? , txt : String , range : NSRange? , arr : [Any] , predecateIdentity : String) -> [Any]{
            
            let predicateStr: NSString;
            if(txtFid != nil && range != nil){
                 predicateStr =
                    (txtFid!.text as NSString?)!.replacingCharacters(in: range!, with: txt) as NSString
            }else{
                predicateStr = txt as NSString
            }
            
            let bPredicate: NSPredicate = NSPredicate(format: "self.%@ contains[c] %@", predecateIdentity ,predicateStr)
        
                return (arr as NSArray).filtered(using: bPredicate)
        }
        
        
        func getPriortyRawValueAccordingToText(txt : String) -> Int{
            switch txt {
            case "Low" :
                return taskPriorities.Low.rawValue
            case "Medium" :
                return taskPriorities.Medium.rawValue
            case "High" :
                return taskPriorities.High.rawValue
            default:
                 return 0
            }
        }
        
   
        
        func getTempIdForNewJob(newId : Int) -> String {

            return "Job-\(String(describing: getUserDetails()?.usrId ?? ""))-\(getCurrentTimeStamp())"
        }
        

        func addAudit(){
            
                let temp = getTempIdForNewJob(newId: 0)
            
            
            
            params["tempId"] = temp
            params["audId"] = temp
            params["conId"] =  param.conId == nil ? "" :  param.conId
            params["siteId"] = param.siteId == nil ? "" : param.siteId
            params["adr"] = self.txtfld_Address.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            params["athr"] = getUserDetails()?.usrId

           
            
            params["city"] = self.txtfld_City.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if clientSelf == true {
               
                params["cnm"] = param.cltId == "" ? param.nm : ""//self.txtfld_Contact.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                params["nm"] =   param.cltId == "" ? param.nm : ""//self.txtfld_Client.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                params["snm"] = param.siteId == nil ? param.snm : ""
                
            }else{
                params["cltId"] = param.cltId == nil ? "" : param.cltId
                params["cnm"] = (param.conId == "" ?  (param.cnm == "" ? "self" : param.cnm) : "")
                params["nm"] =  param.cltId == "" ? param.nm : ""
                params["snm"] = param.siteId == "" ? param.snm : ""
            }
            
//            if clientSelf == true {
//               params["cnm"] = self.txtfld_Contact.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//               params["nm"] =  self.txtfld_Client.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//               params["snm"] = param.siteId == nil ? param.snm : ""
//                
//            }else{
//               params["cltId"] = param.cltId == nil ? "" : param.cltId
//               params["cnm"] = (param.conId == "" ?  (param.cnm == "" ? "self" : param.cnm) : "")
//               params["nm"] =  param.cltId == "" ? param.nm : ""
//               params["snm"] = param.siteId == "" ? param.snm : ""
//            }
            //param.snm = param.siteId == "" ? param.snm : ""

            params["des"] =  txtfld_JobDesc.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            params["email"] = self.txtfld_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            params["inst"] = self.txtfld_JobInstruction.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            params["kpr"] = FltWorkerId.count == 0 ? "" : (FltWorkerId.count == 1 ? FltWorkerId[0] : "")
            params["mob1"] = self.txtfld_MobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            params["mob2"] = self.txtfld_AltMobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            params["parentId"] = ""
           // params["snm"] = param.siteId == "" ? param.snm : ""
        
            params["status"] = "1"
            params["type"] = FltWorkerId.count == 0 ? "1"  : (FltWorkerId.count == 1 ? "1" : "2")// no
            params["zip"] = self.txtfld_PostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
          
            
                let schStartDate = String(format: "%@ %@",  (self.lbl_SrtSchDate.text == nil ? "" : self.lbl_SrtSchDate.text! ) , (self.lbl_SrtSchTime.text == nil ? "" : self.lbl_SrtSchTime.text!))
                let schEndDate = String(format: "%@ %@",  (self.lbl_EndSchDate.text == "" ? "" : self.lbl_EndSchDate.text!) , (self.lbl_EndSchTime.text == "" ? "" : self.lbl_EndSchTime.text!) )
                
                
                var schTime12 = ""
                var endTime12 = ""
                
            if isClear == false{
                
                if schStartDate == "dd-MM-yyyy 00:00"{
                    ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectStartDate, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                    return
                }
                
                if schEndDate == "dd-MM-yyyy 00:00"{
                    ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectEndDate, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                    return
                }
                
                
                let value = compareTwodate(schStartDate:schStartDate , schEndDate: schEndDate, dateFormate: DateFormate.dd_MM_yyyy)
                if(value == "orderedDescending") || (value == "orderedSame"){
                    ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                    return
                }
                else{
                    
                    let dateFormatter = DateFormatter()
                    
                    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                        if enableCustomForm == "0"{
                            dateFormatter.dateFormat = "h:mm a"
                        }else{
                            dateFormatter.dateFormat = "HH:mm"
                        }
                    }
                 //   dateFormatter.dateFormat = "h:mm a"
                    if let langCode = getCurrentSelectedLanguageCode() {
                        dateFormatter.locale = Locale(identifier: langCode)
                    }
                    let date = dateFormatter.date(from: self.lbl_SrtSchTime.text!)
                    dateFormatter.dateFormat = "HH:mm:ss"
                    schTime12 = dateFormatter.string(from: date!)
                    //print(schTime12)
                    
                    
                    let dateFormatter1 = DateFormatter()
                    
                    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                        if enableCustomForm == "0"{
                            dateFormatter1.dateFormat = "h:mm a"
                        }else{
                            dateFormatter1.dateFormat = "HH:mm"
                        }
                    }
                   // dateFormatter1.dateFormat = "h:mm a"
                    if let langCode = getCurrentSelectedLanguageCode() {
                        dateFormatter1.locale = Locale(identifier: langCode)
                    }
                    let date1 = dateFormatter1.date(from: self.lbl_EndSchTime.text!)
                    dateFormatter1.dateFormat = "HH:mm:ss"
                    endTime12 = dateFormatter1.string(from: date1!)
                    //print(endTime12)
                    
                    params["schdlStart"] = isClear ? "" : (self.lbl_SrtSchDate.text! + " " + schTime12)
                    params["schdlFinish"] = isClear ? "" : (self.lbl_EndSchDate.text! + " " + endTime12)
                    
                    var schdlStart = isClear ? "" : (self.lbl_SrtSchDate.text! + " " + schTime12)
                    var schdlFinish = isClear ? "" : (self.lbl_EndSchDate.text! + " " + endTime12)
                    //2018-08-09 15:27:00
                    
    //
                    if schdlStart != "" {
                        params["schdlStart"] = convertDateStringToTimestamp(dateString: schdlStart)
                    }
                    
                    if schdlFinish != "" {
                        params["schdlFinish"] = convertDateStringToTimestamp(dateString: schdlFinish)
                    }
                }
            }else{
                params["schdlStart"] = ""
                params["schdlFinish"] = ""
            }
            
         
            params["tagData"] = arrOfaddTags.count == 0 ? [] : arrOfaddTags
            params["lat"] = latitued.text
            params["lng"] = longitued.text
            params["landmark"] = trimString(string: txt_landmark.text!)
            
            
            var questions: [[String:Any]] = []
            
            for array in customVCArr {
                
                var subDict: [String: Any] = [:]
                var subArray: [[String: String]] = []
                
                for array2 in array.ans! {
                    var dict: [String: String] = [:]
                    dict["key"] = array2.key
                    dict["value"] = array2.value
                    subArray.append(dict)
                }
                
                subDict["frmId"] = array.frmId
                subDict["queId"] = array.queId
                subDict["type"] = array.type
                subDict["ans"] = subArray
                questions.append(subDict)
                
            }
            
             params ["answerArray"] = questions //convertIntoJSONString(arrayObject: questions)
            
       
            let isExist = self.FltWorkerId.contains((getUserDetails()?.usrId)!)
            if(isExist){
                let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
                userJobs?.setValuesForKeys(params)
                DatabaseClass.shared.saveEntity(callback: {_ in
                    if self.callbackForJobVC != nil {
                        self.callbackForJobVC!(true)
                    }
                })
            }else{
 
            }
            
            
            if isClear {
                params["schdlStart"] =  ""
                params["schdlFinish"] =  ""
            }else{
                
                params["schdlStart"] = convertDateToStringForServerAddJob(dateStr: (self.lbl_SrtSchDate.text! + " " + schTime12))
                params["schdlFinish"] = convertDateToStringForServerAddJob(dateStr: (self.lbl_EndSchDate.text! + " " + endTime12))
            }
            
            
          //  params["nm"] =  param.cltId == "" ? param.nm : ""
            params["compId"] = getUserDetails()?.compId
            params["memIds"] =  (FltWorkerId.count == 0 ? [] : (FltWorkerId.count == 1 ? [] : FltWorkerId))
            params["clientForFuture"] =  isClintFutUser ? "1" : "0"
            //param.siteForFuture = (isSitFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
            params["contactForFuture"] = (isContactFutUser ? "1" : ( isClintFutUser ? "1" : "0"))

            
            params["dateTime"] =  currentDateTime24HrsFormate()
          //  print(params)
            var dict =  param.toDictionary
                       var ids = [String]()

                       let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
                       userJobs.apis = Service.addAudit
                       userJobs.parametres = params.toString
                       userJobs.time = Date()
                       
                       DatabaseClass.shared.saveEntity(callback: {_ in
                           DatabaseClass.shared.syncDatabase()
                           self.navigationController?.popViewController(animated: true)
                       })
            //
            //////////////////////////////////////////
//            let temp = getTempIdForNewJob(newId: 0)
//           param.tempId = temp
//            param.audId = temp
//               param.conId =  param.conId == nil ? "" :  param.conId
//               param.siteId = param.siteId == nil ? "" : param.siteId
//            param.adr = self.txtfld_Address.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.athr = getUserDetails()?.usrId
//            param.city = self.txtfld_City.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            if clientSelf == true {
//            param.cnm = self.txtfld_Contact.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.nm =  self.txtfld_Client.text?.trimmingCharacters(in: .whitespacesAndNewlines)//param.cltId == "" ? param.nm : ""
//            }else{
//            param.cnm = (param.conId == "" ?  (param.cnm == "" ? "self" : param.cnm) : "")
//
//            param.nm =  param.cltId == "" ? param.nm : ""
//            }
//            //param.snm = param.siteId == "" ? param.snm : ""
//
//            param.des =  txtfld_JobDesc.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.email = self.txtfld_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.inst = self.txtfld_JobInstruction.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.kpr = FltWorkerId.count == 0 ? "" : (FltWorkerId.count == 1 ? FltWorkerId[0] : "")
//            param.mob1 = self.txtfld_MobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.mob2 = self.txtfld_AltMobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.parentId = ""
//            param.snm = param.siteId == "" ? param.snm : ""
//            param.status = "1"
//            param.type = FltWorkerId.count == 0 ? "1"  : (FltWorkerId.count == 1 ? "1" : "2")// no
//            param.zip = self.txtfld_PostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//
//
//                let schStartDate = String(format: "%@ %@",  (self.lbl_SrtSchDate.text == nil ? "" : self.lbl_SrtSchDate.text! ) , (self.lbl_SrtSchTime.text == nil ? "" : self.lbl_SrtSchTime.text!))
//                let schEndDate = String(format: "%@ %@",  (self.lbl_EndSchDate.text == "" ? "" : self.lbl_EndSchDate.text!) , (self.lbl_EndSchTime.text == "" ? "" : self.lbl_EndSchTime.text!) )
//
//
//                var schTime12 = ""
//                var endTime12 = ""
//
//            if isClear == false{
//
//                if schStartDate == "dd-MM-yyyy 00:00"{
//                    ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectStartDate, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
//                    return
//                }
//
//                if schEndDate == "dd-MM-yyyy 00:00"{
//                    ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectEndDate, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
//                    return
//                }
//
//
//                let value = compareTwodate(schStartDate:schStartDate , schEndDate: schEndDate, dateFormate: DateFormate.dd_MM_yyyy)
//                if(value == "orderedDescending") || (value == "orderedSame"){
//                    ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
//                    return
//                }
//                else{
//
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "h:mm a"
//                    if let langCode = getCurrentSelectedLanguageCode() {
//                        dateFormatter.locale = Locale(identifier: langCode)
//                    }
//                    let date = dateFormatter.date(from: self.lbl_SrtSchTime.text!)
//                    dateFormatter.dateFormat = "HH:mm:ss"
//                    schTime12 = dateFormatter.string(from: date!)
//                    //print(schTime12)
//
//
//                    let dateFormatter1 = DateFormatter()
//                    dateFormatter1.dateFormat = "h:mm a"
//                    if let langCode = getCurrentSelectedLanguageCode() {
//                        dateFormatter1.locale = Locale(identifier: langCode)
//                    }
//                    let date1 = dateFormatter1.date(from: self.lbl_EndSchTime.text!)
//                    dateFormatter1.dateFormat = "HH:mm:ss"
//                    endTime12 = dateFormatter1.string(from: date1!)
//                    //print(endTime12)
//
//                    param.schdlStart = isClear ? "" : (self.lbl_SrtSchDate.text! + " " + schTime12)
//                    param.schdlFinish = isClear ? "" : (self.lbl_EndSchDate.text! + " " + endTime12)
//
//                    //2018-08-09 15:27:00
//
//    //
//                    if param.schdlStart != "" {
//                        param.schdlStart = convertDateStringToTimestamp(dateString: param.schdlStart!)
//                    }
//
//                    if param.schdlFinish != "" {
//                        param.schdlFinish = convertDateStringToTimestamp(dateString: param.schdlFinish!)
//                    }
//                }
//            }else{
//                param.schdlStart = ""
//                param.schdlFinish = ""
//            }
//
//
//            param.tagData = arrOfaddTags.count == 0 ? [] : arrOfaddTags
//            param.lat = latitued.text
//            param.lng = longitued.text
//            param.landmark = trimString(string: txt_landmark.text!)
//
//            let isExist = self.FltWorkerId.contains((getUserDetails()?.usrId)!)
//            if(isExist){
//                let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
//                userJobs?.setValuesForKeys(param.toDictionary!)
//                DatabaseClass.shared.saveEntity(callback: {_ in
//                    if self.callbackForJobVC != nil {
//                        self.callbackForJobVC!(true)
//                    }
//                })
//            }else{
//
//            }
//
//
//            if isClear {
//                param.schdlStart =  ""
//                param.schdlFinish =  ""
//            }else{
//
//                param.schdlStart = convertDateToStringForServerAddJob(dateStr: (self.lbl_SrtSchDate.text! + " " + schTime12))
//                param.schdlFinish = convertDateToStringForServerAddJob(dateStr: (self.lbl_EndSchDate.text! + " " + endTime12))
//            }
//
//
//
//            param.compId = getUserDetails()?.compId
//            param.memIds =  (FltWorkerId.count == 0 ? [] : (FltWorkerId.count == 1 ? [] : FltWorkerId))
//            param.clientForFuture =  isClintFutUser ? "1" : "0"
//            //param.siteForFuture = (isSitFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
//            param.contactForFuture = (isContactFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
//
//
//            param.dateTime =  currentDateTime24HrsFormate()
//
//
//
//         //   print(param.toDictionary)
//            var dict =  param.toDictionary
//            var ids = [String]()
//
//            let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
//            userJobs.apis = Service.addAudit
//            userJobs.parametres = dict?.toString
//            userJobs.time = Date()
//
//            DatabaseClass.shared.saveEntity(callback: {_ in
//                DatabaseClass.shared.syncDatabase()
//                self.navigationController?.popViewController(animated: true)
//            })
            
        }
    
    func AuditOnlineApiCalling(){
        
        let temp = getTempIdForNewJob(newId: 0)
        
        params["tempId"] = temp
        params["audId"] = temp
      //  params["conId"] =  param.conId == nil ? "" :  param.conId
        params["siteId"] = param.siteId == nil ? "" : param.siteId
        params["adr"] = self.txtfld_Address.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        params["athr"] = getUserDetails()?.usrId
        params["conId"] =  param.conId == nil ? "" :  param.conId
        
        
        params["city"] = self.txtfld_City.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        if clientSelf == true {
//            parm["conId"] = param.conId == nil ? "" : param.conId
//            parm["nm"] =  param.cltId == "" ? param.nm : ""//self.txtfld_Client.text?.trimmingCharacters(in: .whitespacesAndNewlines)//param.cltId == "" ? param.nm : ""
//            parm["siteId"] = param.siteId == nil ? "" : param.siteId
//            parm["snm"] = param.siteId == nil ? param.snm : ""
//
//        }else{
//            parm["cnm"] = (param.conId == "" ? (param.cnm == "" ? "self" : param.cnm) : "")
//            parm["nm"] = param.cltId == "" ? param.nm : ""
//            parm["siteId"] = param.siteId == nil ? "" : param.siteId
//            parm["snm"] = param.siteId == "" ? param.snm : ""
//        }

        
        
        
        
        if clientSelf == true {
           
            params["cnm"] = param.cltId == "" ? param.nm : ""//self.txtfld_Contact.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            params["nm"] =   param.cltId == "" ? param.nm : ""//self.txtfld_Client.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            params["snm"] = param.siteId == nil ? param.snm : ""
            
        }else{
            params["cltId"] = param.cltId == nil ? "" : param.cltId
            params["cnm"] = (param.conId == "" ?  (param.cnm == "" ? "self" : param.cnm) : "")
            params["nm"] =  param.cltId == "" ? param.nm : ""
            params["snm"] = param.siteId == "" ? param.snm : ""
        }
        //param.snm = param.siteId == "" ? param.snm : ""
//        if self.stringToHtml != "" {
//            params["des"] = self.stringToHtml
//        }else{
//            params["des"] = self.textView.text
//        }
        
        
        if self.stringToHtml != "" {
            params["des"] = self.stringToHtml
        }else{
            
            if self.textView.text == "Job Description" {
                params["des"] = ""
            }else{
                 stringToHtmlFormateWithOutImage()
                params["des"] = "<p>\(self.textView.text ?? "")</p>"
                    
            }
           
        }
        
       // params["des"] = self.stringToHtml //txtfld_JobDesc.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        params["email"] = self.txtfld_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        params["inst"] = self.txtfld_JobInstruction.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        params["kpr"] = FltWorkerId.count == 0 ? "" : (FltWorkerId.count == 1 ? FltWorkerId[0] : "")
        params["mob1"] = self.txtfld_MobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        params["mob2"] = self.txtfld_AltMobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        params["parentId"] = ""
        // params["snm"] = param.siteId == "" ? param.snm : ""
        
        params["status"] = "1"
        params["type"] = FltWorkerId.count == 0 ? "1"  : (FltWorkerId.count == 1 ? "1" : "2")// no
        params["zip"] = self.txtfld_PostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let schStartDate = String(format: "%@ %@",  (self.lbl_SrtSchDate.text == nil ? "" : self.lbl_SrtSchDate.text! ) , (self.lbl_SrtSchTime.text == nil ? "" : self.lbl_SrtSchTime.text!))
        let schEndDate = String(format: "%@ %@",  (self.lbl_EndSchDate.text == "" ? "" : self.lbl_EndSchDate.text!) , (self.lbl_EndSchTime.text == "" ? "" : self.lbl_EndSchTime.text!) )
        
        
        var schTime12 = ""
        var endTime12 = ""
        
        if isClear == false{
            
            if schStartDate == "dd-MM-yyyy 00:00"{
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectStartDate, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                return
            }
            
            if schEndDate == "dd-MM-yyyy 00:00"{
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectEndDate, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                return
            }
            
            
            let value = compareTwodate(schStartDate:schStartDate , schEndDate: schEndDate, dateFormate: DateFormate.dd_MM_yyyy)
            if(value == "orderedDescending") || (value == "orderedSame"){
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                return
            }
            else{
                
                let dateFormatter = DateFormatter()
                
                if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                    if enableCustomForm == "0"{
                        dateFormatter.dateFormat = "h:mm a"
                    }else{
                        dateFormatter.dateFormat = "HH:mm"
                    }
                }
                //   dateFormatter.dateFormat = "h:mm a"
                if let langCode = getCurrentSelectedLanguageCode() {
                    dateFormatter.locale = Locale(identifier: langCode)
                }
                let date = dateFormatter.date(from: self.lbl_SrtSchTime.text!)
                dateFormatter.dateFormat = "HH:mm:ss"
                schTime12 = dateFormatter.string(from: date!)
                //print(schTime12)
                
                
                let dateFormatter1 = DateFormatter()
                
                if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                    if enableCustomForm == "0"{
                        dateFormatter1.dateFormat = "h:mm a"
                    }else{
                        dateFormatter1.dateFormat = "HH:mm"
                    }
                }
                // dateFormatter1.dateFormat = "h:mm a"
                if let langCode = getCurrentSelectedLanguageCode() {
                    dateFormatter1.locale = Locale(identifier: langCode)
                }
                let date1 = dateFormatter1.date(from: self.lbl_EndSchTime.text!)
                dateFormatter1.dateFormat = "HH:mm:ss"
                endTime12 = dateFormatter1.string(from: date1!)
                //print(endTime12)
                
                params["schdlStart"] = isClear ? "" : (self.lbl_SrtSchDate.text! + " " + schTime12)
                params["schdlFinish"] = isClear ? "" : (self.lbl_EndSchDate.text! + " " + endTime12)
                
                var schdlStart = isClear ? "" : (self.lbl_SrtSchDate.text! + " " + schTime12)
                var schdlFinish = isClear ? "" : (self.lbl_EndSchDate.text! + " " + endTime12)
                //2018-08-09 15:27:00
                
                //
                if schdlStart != "" {
                    params["schdlStart"] = convertDateStringToTimestamp(dateString: schdlStart)
                }
                
                if schdlFinish != "" {
                    params["schdlFinish"] = convertDateStringToTimestamp(dateString: schdlFinish)
                }
            }
        }else{
            params["schdlStart"] = ""
            params["schdlFinish"] = ""
        }
        
        var tagDataids : [[String:Any]] = []
        let titlesDataids  = arrOfaddTags.count == 0 ? [] : arrOfaddTags
        
        for title in titlesDataids {
            tagDataids.append((title as [String : Any] ) )
            
            
        }
        
        
        params["tagData"] = convertIntoJSONString(arrayObject: tagDataids)//arrOfaddTags.count == 0 ? [] : arrOfaddTags
        params["lat"] = latitued.text
        params["lng"] = longitued.text
        params["landmark"] = trimString(string: txt_landmark.text!)
        
        
        var questions: [[String:Any]] = []
        
        for array in customVCArr {
            
            var subDict: [String: Any] = [:]
            var subArray: [[String: String]] = []
            
            for array2 in array.ans! {
                var dict: [String: String] = [:]
                dict["key"] = array2.key
                dict["value"] = array2.value
                subArray.append(dict)
            }
            
            subDict["frmId"] = array.frmId
            subDict["queId"] = array.queId
            subDict["type"] = array.type
            subDict["ans"] = subArray
            questions.append(subDict)
            
        }
        
        params ["answerArray"] = questions //convertIntoJSONString(arrayObject: questions)
        
        
        let isExist = self.FltWorkerId.contains((getUserDetails()?.usrId)!)
        if(isExist){
            let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
            userJobs?.setValuesForKeys(params)
            DatabaseClass.shared.saveEntity(callback: {_ in
                if self.callbackForJobVC != nil {
                    self.callbackForJobVC!(true)
                }
            })
        }else{
            
        }
        
        
        if isClear {
            params["schdlStart"] =  ""
            params["schdlFinish"] =  ""
        }else{
            
            params["schdlStart"] = convertDateToStringForServerAddJob(dateStr: (self.lbl_SrtSchDate.text! + " " + schTime12))
            params["schdlFinish"] = convertDateToStringForServerAddJob(dateStr: (self.lbl_EndSchDate.text! + " " + endTime12))
        }
        
        
        //  params["nm"] =  param.cltId == "" ? param.nm : ""
        params["compId"] = getUserDetails()?.compId
        params["memIds"] =  (FltWorkerId.count == 0 ? [] : (FltWorkerId.count == 1 ? [] : FltWorkerId))
        params["clientForFuture"] =  isClintFutUser ? "1" : "0"
        //param.siteForFuture = (isSitFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
        params["contactForFuture"] = (isContactFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
        params["dateTime"] =  currentDateTime24HrsFormate()
        
        // let image = images
         print(params)
       
        
        showLoader()
        // print(imgArr.count)
        serverCommunicatorUplaodImageInArrayForInputField(url: Service.addAudit, param: params, images: imgArr , imagePath:"ja[]") { (response, success) in
            killLoader()
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AddAudRes.self, from: response as! Data) {
                    // self.navigationController?.popToRootViewController(animated: true)
                    if decodedData.success == true{
                        
                        DispatchQueue.main.async {
                            killLoader()
                            self.navigationController?.popToRootViewController(animated: true)
                            self.showToast(message:LanguageKey.euipment_remark_update)
                            // self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    
                    // ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
        
    }
    
    //====================================================//
    // convert string to html formate
    //====================================================//
    func stringToHtmlFormateWithOutImage(){
        let finalText = self.textView.attributedText
        
     //   DispatchQueue.global(qos: .background).async {
            self.stringToHtmlOnlyText = finalText!.toHtml() ?? ""
            let urlPaths = self.stringToHtml.imagePathsFromHTMLString()
            //print(urlPaths)// get all images fake paths
            
            for (index,model) in self.imgArr.enumerated() {
            let imageId = "_jobAttSeq_\(index)_"
                if imageId != "" {
                     self.stringToHtmlOnlyText = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
                }
      //  self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
            }
            
            //print(self.stringToHtml)
            
            DispatchQueue.main.async {
                  killLoader()
                print("Successfully converted string to HTML")
            }
       // }
    }
        
        func convertIntoJSONString(arrayObject: [Any]) -> String? {

            do {
                let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
                if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    return jsonString as String
                }
                
            } catch let error as NSError {
              //  print("Array convertIntoJSON - \(error.description)")
            }
            return nil
        }
    //=====================================
    // MARK:- Get Job Tittle  Service
    //=====================================
        
        func getJobTittle(){
            /*
             compId -> Company id
             limit -> limit
             index -> index value
             search -> search value
             dateTime -> date time

     */
            if !isHaveNetowork() {
                return
            }
        
            let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getJobTitleList) as? String
            
            let param = Params()
            param.compId = getUserDetails()?.compId
            param.limit = ""
            param.index = "0"
            param.search = ""
            param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""

            serverCommunicator(url: Service.getJobTitleList, param: param.toDictionary) { (response, success) in
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(ViewControllerResponse.self, from: response as! Data) {
                        if decodedData.success == true{
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getJobTitleList)
                            if decodedData.data?.count != 0 {
                                self.saveUserJobsTittleNmInDataBase(data: decodedData.data!)
                              
                            }
                        }else{
                            //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            
                                killLoader()
                                if let code =  decodedData.statusCode{
                                    if(code == "401"){
                                        ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                            if (Ok){
                                                DispatchQueue.main.async {
                                                    (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                                }
                                            }
                                        })
                                    }
                                }else{
                                    ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                }
                            }
                        
                    
                    }else{
                        //ShowAlert(title: "formate problem", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertControllerStyle.alert, callback: {_,_ in})
                    }
                }else{
                    //ShowAlert(title: "Network Error", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertControllerStyle.alert, callback: {_,_ in})
                }
            }
        }
        
        //==============================
        // MARK:- Save data in DataBase
        //==============================
        func saveUserJobsTittleNmInDataBase( data : [jobTittleListData]) -> Void {
            for jobs in data{
                let query = "jtId = '\(jobs.jtId!)'"
                let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: query) as! [UserJobTittleNm]
                if isExist.count > 0 {
                    let existingJob = isExist[0]
                    existingJob.setValuesForKeys(jobs.toDictionary!)
                    //DatabaseClass.shared.saveEntity()
                }else{
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "UserJobTittleNm")
                    userJobs?.setValuesForKeys(jobs.toDictionary!)
                   // DatabaseClass.shared.saveEntity()
                }
            }
            
             DatabaseClass.shared.saveEntity(callback: {_ in})
        }
        
        
        //=====================================
        // MARK:- Get Field Worker List Service
        //=====================================
        
        func getFieldWorkerList(){
            /*
             compId -> company id
             limit -> limit (No. of rows)
             index -> index value
             search -> search value
             */
            
            if !isHaveNetowork() {
                return
            }
            let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getFieldWorkerList) as? String

            let param = Params()
            param.compId = getUserDetails()?.compId
            param.limit = "120"
            param.index = "0"
            param.search = ""
            param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
            
        
            
            serverCommunicator(url: Service.getFieldWorkerList, param: param.toDictionary) { (response, success) in
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(FldWorkerData.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getFieldWorkerList)
                                if decodedData.data?.count != 0 {
                                    self.saveUserFieldWorkerNmInDataBase(data: decodedData.data!)
                                    
                                }
                        }else{
                            
                            killLoader()
                            if let code =  decodedData.statusCode{
                                if(code == "401"){
                                    ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                        if (Ok){
                                            DispatchQueue.main.async {
                                                (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                            }
                                        }
                                    })
                                }
                            }else{
                                ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            }
                        }
                    }else{
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    }
                }else{
                   //ShowError(message: "Please try again!", controller: windowController)
                }
            }
        }
        

        //==============================
        // MARK:- Save data in DataBase
        //==============================
    
        func saveUserFieldWorkerNmInDataBase( data : [FldWorkerDetailsList] ) -> Void {
            
            for jobs in data{
                let query = "usrId = '\(jobs.usrId!)'"
                let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: query) as! [FieldWorkerDetails]
                if isExist.count > 0 {
                    let existingJob = isExist[0]
                    existingJob.setValuesForKeys(jobs.toDictionary!)
                   // DatabaseClass.shared.saveEntity()
                }else{
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "FieldWorkerDetails")
                    userJobs?.setValuesForKeys(jobs.toDictionary!)
                   // DatabaseClass.shared.saveEntity()
                }
            }
            
            DatabaseClass.shared.saveEntity(callback: { _ in})
        }
        
        
        //=====================================
        // MARK:- get All Added Tags
        //=====================================
        
        func getTagListService(){
            
            if !isHaveNetowork() {
                return
            }
            
            /*
             "compId -> Company id
             limit -> limit
             index -> index value
             search -> search value"
             */
            let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.jobTagList) as? String

            let param = Params()
            param.compId = getUserDetails()?.compId
            param.limit = "120"
            param.index = "0"
            param.search = ""
            param.dateTime = ""//lastRequestTime ?? ""

            serverCommunicator(url: Service.jobTagList, param: param.toDictionary) { (response, success) in
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(tagListResponse.self, from: response as! Data) {
                        if decodedData.success == true{
                            killLoader()
                        UserDefaults.standard.set(CurrentDateTime(), forKey: Service.jobTagList)
                                if decodedData.data?.count != 0 {
                                     self.saveTagsNmInDataBase(data: decodedData.data!)
                                }
                        }else{
                            killLoader()
                            if let code =  decodedData.statusCode{
                                if(code == "401"){
                                    ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                        if (Ok){
                                            DispatchQueue.main.async {
                                                (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                            }
                                        }
                                    })
                                }
                            }else{
                                ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            }
                        }
                    }else{
                        
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    }
                }else{
                    killLoader()
                    ShowAlert(title: errorString, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                        if cancelButton {
                            showLoader()
                            self.getTagListService()
                        }
                    })
                }
            }
        }
        
        func saveTagsNmInDataBase( data : [tagElements]) -> Void {
            
            for jobs in data{
                let query = "tagId = '\(jobs.tagId!)'"
                let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TagsList", query: query) as! [TagsList]
                if isExist.count > 0 {
                    let existingJob = isExist[0]
                    existingJob.setValuesForKeys(jobs.toDictionary!)
                   // DatabaseClass.shared.saveEntity()
                }else{
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "TagsList")
                    userJobs?.setValuesForKeys(jobs.toDictionary!)
                    //DatabaseClass.shared.saveEntity()
                }
            }
              DatabaseClass.shared.saveEntity(callback: { _ in})
        }

        //=======================
        // MARK:- Other methods
        //=======================
        func getcontractFrmDB() -> Void {
            let query = "isactive = 1"
            arrContractList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ContractList", query: query) as! [ContractList]
            FltContractListt = arrContractList
        }
        
        //=======================
          // MARK:- Other methods
          //=======================
          func getClintListFrmDB() -> Void {
              let query = "isactive = 1"
              arrClintList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as! [ClientList]
              FltArrClintList = arrClintList
          }
        
        
        
        //=====================================
        // MARK:- Get Clint List Service
        //=====================================
        
        func getClientSink(){
            /*
             "compId -> company id
             limit -> limit (No. of rows)
             index -> index value
             search -> search value
             isactive ->0 - deactive clients,1 - active clients, no value - all clients "
             */
            
            if !isHaveNetowork() {
                return
            }
            
            let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientSink) as? String
            
            let param = Params()
            param.compId = getUserDetails()?.compId
            param.limit = "120"
            param.index = "0"
            param.search = ""
            param.isactive = ""
            param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
            
            
            serverCommunicator(url: Service.getClientSink, param: param.toDictionary) { (response, success) in
                if(success){
                    let decoder = JSONDecoder()

                    if let decodedData = try? decoder.decode(ClientResponse.self, from: response as! Data) {
                        if decodedData.success == true{
                            
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSink)
                            if decodedData.data.count > 0 {
                                self.saveClintInDataBase(data: decodedData.data)
                                self.getClintListFrmDB()
                            }else{
                               
                            }
                        }else{
                           // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            
                                killLoader()
                                if let code =  decodedData.statusCode{
                                    if(code == "401"){
                                        ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                            if (Ok){
                                                DispatchQueue.main.async {
                                                    (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                                }
                                            }
                                        })
                                    }
                                }else{
                                    ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                }
                            }
                        }
            else{
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
                }
            }
        }
        
        
       
        
        //==============================
        // MARK:- Save data in DataBase
        //==============================
        func saveClintInDataBase( data : [ClientListData]) -> Void {
            
            for jobs in data{
                let query = "cltId = '\(jobs.cltId!)'"
                let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as! [ClientList]
                if isExist.count > 0 {
                    if(jobs.isdelete == "0"){
                        let existingJob = isExist[0]
                        DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                        
                    }else{
                        let existingJob = isExist[0]
                        existingJob.setValuesForKeys(jobs.toDictionary!)
                        //DatabaseClass.shared.saveEntity()
                    }
                    
                }else{
                    if(jobs.isdelete != "0"){
                        let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientList")
                        userJobs?.setValuesForKeys(jobs.toDictionary!)
                       // DatabaseClass.shared.saveEntity()
                    }
                }
            }
             DatabaseClass.shared.saveEntity(callback: { _ in})
        }

        
        //=====================================
        // MARK:- Get Clint Sit List  Service
        //=====================================
        
        func getClientSiteSink(){
            /*
             compId-> company id
             limit->limit
             index->index
             dateTime->date time (only for update)
             */
            
            if !isHaveNetowork() {
                return
            }
            
            let param = Params()
            let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientSiteSink) as? String
            
            param.compId = getUserDetails()?.compId
            param.limit = "120"
            param.index = ""
            param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
            
            
            serverCommunicator(url: Service.getClientSiteSink, param: param.toDictionary) { (response, success) in
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(SiteVCResp.self, from: response as! Data) {
                        if decodedData.success == true{
                            
                            if decodedData.data.count > 0 {
                                self.saveSiteInDataBase(data: decodedData.data)
                            }
                            
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSiteSink)
                         }else{
                                killLoader()
                                if let code =  decodedData.statusCode{
                                    if(code == "401"){
                                        ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                            if (Ok){
                                                DispatchQueue.main.async {
                                                    (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                                }
                                            }
                                        })
                                    }
                                }else{
                                    ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                }
                            }
                    }else{
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    }
                }else{
                    //  ShowAlert(title: "Network Error", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertControllerStyle.alert, callback: {_,_ in})
                }
            }
            // }
        }
        
        //==============================
        // MARK:- Save data in DataBase
        //==============================
        func saveSiteInDataBase( data : [SiteVCRespDetails] ) -> Void {
            for jobs in data{
                let query = "siteId = '\(jobs.siteId!)'"
                let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
                if isExist.count > 0 {
                    if(jobs.isdelete == "0"){
                        let existingJob = isExist[0]
                        DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                    }else{
                        let existingJob = isExist[0]
                        existingJob.setValuesForKeys(jobs.toDictionary!)
                       // DatabaseClass.shared.saveEntity()
                    }
                }else{
                    if(jobs.isdelete != "0"){
                        let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
                        userJobs?.setValuesForKeys(jobs.toDictionary!)
                       // DatabaseClass.shared.saveEntity()
                    }
                }
            }

            DatabaseClass.shared.saveEntity(callback: { _ in})

        }
        
        
        
        //=====================================
        // MARK:- Get Contact List  Service
        //=====================================
        
        func getClientContactSink(){
            /*
             compId-> company id
             limit->limit
             index->index
             dateTime->date time (only for update)
             */
            
            if !isHaveNetowork() {
                return
            }
            
            let param = Params()
            let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientContactSink) as? String
            
            param.compId = getUserDetails()?.compId
            param.limit = "120"
            param.index = ""
            param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
            
            serverCommunicator(url: Service.getClientContactSink, param: param.toDictionary) { (response, success) in
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(ContactResps.self, from: response as! Data) {
                        if decodedData.success == true{
                            
                            DatabaseClass.shared.saveEntity(callback: { _ in
                                
                                if decodedData.data.count > 0 {
                                    self.saveUserContactInDataBase(data: decodedData.data)
                                }
                                
                                //Request time will be update when data comes otherwise time won't be update
                                UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientContactSink)
                                
                            })
                        
                        }else{
                            //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            
                                killLoader()
                                if let code =  decodedData.statusCode{
                                    if(code == "401"){
                                        ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                            if (Ok){
                                                DispatchQueue.main.async {
                                                    (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                                }
                                            }
                                        })
                                    }
                                }else{
                                    ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                }
                            }
                    
                    }else{
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
                }
            }
            //  }
        }
        
        //==============================
        // MARK:- Save contact data in DataBase //ContractList
        //==============================
        func saveUserContactInDataBase( data : [ContactRespsDetails]) -> Void {
            
            for jobs in data{
                let query = "conId = '\(jobs.conId!)'"
                let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
                if isExist.count > 0 {
                    
                    if(jobs.isdelete == "0"){
                        let existingJob = isExist[0]
                        DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                    }else{
                        let existingJob = isExist[0]
                        existingJob.setValuesForKeys(jobs.toDictionary!)
                        //DatabaseClass.shared.saveEntity()
                    }
                    
                }else{
                    if(jobs.isdelete != "0"){

                        let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientContactList")
                        userJobs?.setValuesForKeys(jobs.toDictionary!)
                        //DatabaseClass.shared.saveEntity()
                    }
                }
            }
            
             DatabaseClass.shared.saveEntity(callback: { _ in})
            
        }
        
        //========================================
        //MARK:-  Stop Copy Paste of Numbers Filed
        //========================================
        
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            if txtfld_MobNo.isFirstResponder || txtfld_AltMobNo.isFirstResponder || txtfld_PostalCode.isFirstResponder {
                DispatchQueue.main.async(execute: {
                    (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
                })
                return false
            }
            
            return super.canPerformAction(action, withSender: sender)
        }
        
        
        
        
        //========================================
        //MARK:-  Key Board notification method
        //========================================
        @objc func keyboardWillShow(notification: NSNotification) {
            
            
            
            if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                let userInfo = notification.userInfo!
                var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
                keyboardFrame = self.view.convert(keyboardFrame, from: nil)
                
                var visibleRect = self.view.frame;
                visibleRect.size.height -= keyboardFrame.size.height + 30;
                
                var frameFrmScrollView = self.sltTxtField.convert(self.sltTxtField.bounds, to:self.scroll_View)
                frameFrmScrollView.origin.y += 150.0  // 150 DropDown Height

                var frameFrmView = self.sltTxtField.convert(self.sltTxtField.bounds, to:self.view)
                frameFrmView.origin.y += (150.0 + self.sltTxtField.frame.size.height + 20)
                
                if(visibleRect.size.height <= frameFrmView.origin.y){
                        let scrollPoint = CGPoint(x: 0.0, y: ((frameFrmScrollView.origin.y + frameFrmScrollView.size.height) - visibleRect.size.height) + 20)
                        self.scroll_View.setContentOffset(scrollPoint, animated: true)
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 0.2 Time Delay
                    self.openDropDownWhenKeyBordappere()
                    
                }
            }
        }
        
        @objc func keyboardWillHide(notification: NSNotification) {
            self.removeOptionalView()
        }
        
        
           //==============================
           // MARK:- Save data in DataBase
           //==============================
           func contractSynch( data : [ContractListData]) -> Void {
            
            
            
             for job in data{
                                 let query = "contrId = '\(job.contrId!)'"
                                 let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ContractList", query: query) as! [ContractList]
 //   print(isExist)
                              //  let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
                              //  userJobs?.setValuesForKeys(job.toDictionary!)
                                //DatabaseClass.shared.saveEntity()
                                 if isExist.count > 0 {
                                     let existingJob = isExist[0]
                                     //if Job status Cancel, Reject, Closed so this job is delete from Database

                                     if(job.isdelete == "0") {
                                         ChatManager.shared.removeJobForChat(jobId: existingJob.contrId!)
                                         DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                                     }else if (Int(job.status!) == taskStatusType.Cancel.rawValue) ||
                                         (Int(job.status!) == taskStatusType.Reject.rawValue) ||
                                         (Int(job.status!) == taskStatusType.Closed.rawValue)
                                     {
                                         ChatManager.shared.removeJobForChat(jobId: existingJob.contrId!)
                                         DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                                     }else{
                                         existingJob.setValuesForKeys(job.toDictionary!)
            //                        DatabaseClass.shared.saveEntity(callback: {_ in
            //
            //                        })
                                    }
                                 }else{
                                     if(job.isdelete != "0") {
                                         if (Int(job.status!) != taskStatusType.Cancel.rawValue) &&
                                             (Int(job.status!) != taskStatusType.Reject.rawValue) &&
                                             (Int(job.status!) != taskStatusType.Closed.rawValue)
                                         {
                                             let userJobs = DatabaseClass.shared.createEntity(entityName: "ContractList")
                                             userJobs?.setValuesForKeys(job.toDictionary!)
                                //    print(userJobs)
            //                                 //DatabaseClass.shared.saveEntity()

                                             let query = "contrId = '\(job.tempId ?? "")'"
                                             let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ContractList", query: query) as! [ContractList]
 //  print(isExistJob)
                                             if isExistJob.count > 0 {
                                                 let existing = isExistJob[0]
                                                 DatabaseClass.shared.deleteEntity(object: existing, callback: { (_) in})
                                             }

                                         }
                                     }
                                 }
                             }
                               getClientListFromDBjob()
               
    //           for jobs in data{
    //               let query = "contrId = '\(jobs.contrId!)'"
    //               let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ContractList", query: query) as! [ContractList]
    //               if isExist.count > 0 {
    //                   if(jobs.isdelete == "0"){
    //                       let existingJob = isExist[0]
    //                       DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
    //
    //                   }else{
    //                       let existingJob = isExist[0]
    //                       existingJob.setValuesForKeys(jobs.toDictionary!)
    //                       //DatabaseClass.shared.saveEntity()
    //                   }
    //
    //               }else{
    //                   if(jobs.isdelete != "0"){
    //                       let userJobs = DatabaseClass.shared.createEntity(entityName: "ContractList")
    //                       userJobs?.setValuesForKeys(jobs.toDictionary!)
    //                      // DatabaseClass.shared.saveEntity()
    //                   }
    //               }
    //           }
    //            DatabaseClass.shared.saveEntity(callback: { _ in})
             getClientListFromDBjob()
            
        }
        ///////////////
        
        func getClientListFromDBjob() -> Void {


                        showDataOnTableView(query : nil)

                    }
        func showDataOnTableView(query : String?) -> Void {
                    ArrContrect = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ContractList", query: query) as! [ContractList]
        //    print(ArrContrect)
                   if ArrContrect.count != 0 {
                      // self.createSection ()
                   }else{
                       DispatchQueue.main.async {
    //                       if(self.arrOfFilterDict1.count != 0){
    //                           self.arrOfFilterDict1.removeAll()
    //                       }
                           self.tableView.reloadData()
                         //  self.hideloader()

                     }
                   }
                   
                   DispatchQueue.main.async {
                       //self.lblNoJob.isHidden = self.arrOFUserData1.count > 0 ? true : false
                   }
               }
        //==================================
        // MARK:- Get contractSynch Service
        //==================================
        
        func contractSynch(){
       getClientListFromDBjob()
    //getClientListFromDBjob()
                          let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.contractSynch) as? String
                          let param = Params()
                          param.limit = "120"
                          param.index = "0"
                          param.search = ""
                          param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
                 
                          serverCommunicator(url: Service.contractSynch, param: param.toDictionary) { (response, success) in
                              killLoader()
                              if(success){
                                  let decoder = JSONDecoder()
                                  if let decodedData = try? decoder.decode(ContractResponce.self, from: response as! Data) {
                                      
                                      if decodedData.success == true{
                                        //  print("\(decodedData)")
                                         self.ContractArray = decodedData.data as! [ContractListData]
                                                    
                                        UserDefaults.standard.set(CurrentDateTime(), forKey: Service.contractSynch)
                                         if decodedData.data.count > 0 {
                                                   self.contractSynch(data: decodedData.data)
                                            
                                                   //self.getcontractFrmDB()
                                                }else{
                                                                
                                            }
                                          
                                      }else{
                                          ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                      }
                                  }else{
                                      
                                      ShowError(message: AlertMessage.formatProblem, controller: windowController)
                                  }
                              }else{
                                  //ShowError(message: "Please try again!", controller: windowController)
                              }
                          }
                          
                    }
    
    @IBAction func btnImageAction(_ sender: Any) {
        
        if !isHaveNetowork(){
            ShowError(message: LanguageKey.offline_feature_alert, controller: windowController)
        }else{
            openGallery()
        }
        
    }
    
    
    func openGallery(){
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: LanguageKey.please_select, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: LanguageKey.cancel , style: .cancel) { _ in
            
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        
        
        let camera = UIAlertAction(title: LanguageKey.camera, style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera;
                self.imagePicker.allowsEditing = false
                APP_Delegate.showBackButtonText()
                self.present(self.imagePicker, animated: true, completion: {
                   // self.textView.text = ""
                    //self.imgView.isHidden = true
                    // self.HightTopView.constant = 55
                    
                })
            }
        }
        
        let gallery = UIAlertAction(title: LanguageKey.gallery, style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                showLoader()
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = false
                APP_Delegate.showBackButtonText()
                self.present(self.imagePicker, animated: true, completion: {
                     // self.textView.text = ""
                    //self.imgView.isHidden = true
                    //self.HightTopView.constant = 55
                    
                })
            }
        }
        
        actionSheetControllerIOS8.addAction(gallery)
        actionSheetControllerIOS8.addAction(camera)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
        
    }


    ////MARK:- UITableView
     extension AddAudit : UITableViewDelegate, UITableViewDataSource{
        
func getQuestionsByParentId(patmid:String){
                  
                            showLoader()
                            let param = Params()
                             param.ansId =  "-1"
                             param.frmId = patmid  //as! String//"125" //ass //objOFTestVC?.frmId
                            // param.usrId = getUserDetails()?.usrId
                             param.audId = ""//self.objOfUserJobList.jobId
                      
                      serverCommunicator(url: Service.getQuestionsByParentId, param: param.toDictionary) { (response, success) in
                          
                          killLoader()
                          if(success){
                              let decoder = JSONDecoder()
                     
                              if let decodedData = try? decoder.decode(CustomFormResponse.self, from: response as! Data) {
                                  
                                  if decodedData.success == true{
                                      
                                      if decodedData.data.count > 0 {
                                          DispatchQueue.main.async {
                                             // self.lbl_AlertMess.isHidden = true
                                             // self.footerView.isHidden = false

                                              self.arrOfShowData11 = decodedData.data
                                              self.customTblView.reloadData()
                                          }
                                          
                                      }else{
                                          if self.arrOfShowData.count == 0{
                                              DispatchQueue.main.async {
                                                  //self.customField_H.constant = 400
                                                  self.customTblView.isHidden = true
                                                  //self.lbl_AlertMess.isHidden = false
                                                  //self.footerView.isHidden = true
                                              }
                                          }
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
           
        
        func getFormDetail(){


                            let param = Params()

                            param.frmId = ""
                            param.type = "3"
                           // param.dateTime = lastRequestTime ?? ""

                            serverCommunicator(url: Service.getFormDetail, param: param.toDictionary) { (response, success) in
                                if(success){
                                    let decoder = JSONDecoder()

                    

                                    if let decodedData = try? decoder.decode(FormDetail.self, from: response as! Data) {

                                        if decodedData.success == true{

                //
                                                  self.arrOfShowDatas = decodedData.data
                                                                                       //  self.ant = decodedData.data.frmId!
                                                                                // self.ant.append(decodedData.data.frmId)
                                                                                 
                                               self.getQuestionsByParentId(patmid: decodedData.data.frmId!)
                                                                                // UserDefaults.standard.set(decodedData.data.frmId, forKey: "frm")
                                                                                // print(self.ass)
           
                                        }else{
                                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                        }
                                    }else{
                                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                                    }
                                }else{
                                    //ShowError(message: "Please try again!", controller: windowController)
                                }
                            }
                        }
           
                       @objc func btnSltDateActionMethod(btn: UIButton){//Perform actions here
           
                           let indexPath = IndexPath(row: btn.tag, section: 0)
                           let cell: fifthTableViewCell = self.customTblView.cellForRow(at: indexPath) as! fifthTableViewCell
           
           
                           let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
                           var sltDate : Date?
                           let dateMode : UIDatePicker.Mode = cell.type == "5" ? .date : cell.type == "6" ? .time : .dateAndTime
                           alert.addDatePicker(mode: dateMode, date: Date(), minimumDate: nil, maximumDate: nil) { date in
                               sltDate = date
                           }
           
                           let doneAction = UIAlertAction(title: LanguageKey.done, style: .default, handler:
                           {
                               (alert: UIAlertAction!) -> Void in
                               cell.lbl_Ans.textColor = UIColor.black
           
           
                                let selectedDate = sltDate != nil ? sltDate! : Date()
           
                                 let displayDateFormate : DateFormate = cell.type == "5" ? DateFormate.dd_MMM_yyyy : cell.type == "6" ? DateFormate.h_mm_a : DateFormate.ddMMMyyyy_hh_mma
                               cell.lbl_Ans.text =  convertDateToStringForServer(date:selectedDate, dateFormate:displayDateFormate)
           
                               let customFormDetals = self.arrOfShowData11[indexPath.row]
           
                               let ans_server_formate = convertDateToStringForServer(date:selectedDate, dateFormate:DateFormate.yyyy_MM_dd_HH_mm_ss)
           
                               let opt = OptDetals(key: "0", questions: nil, value: ans_server_formate, optHaveChild: nil)
                               let layer = String(format: "%d.1", (indexPath.row + 1))
                               self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                           })
           
                           let cancelAction = UIAlertAction(title: LanguageKey.cancel, style: .cancel, handler:
                           {(alert: UIAlertAction!) -> Void in
                               sltDate = nil
                           })
           
                           alert.addAction(doneAction)
                           alert.addAction(cancelAction)
                           self.present(alert, animated: true, completion: nil)
                       }
           
           
           
                   func saveDataIntoTempArray(isAdded  : Bool , layer  : String? ,optDetail : OptDetals , customFormDetals : CustomFormDetals){
           
           
                            let dictData = CustomDataRes()
                                        dictData.queId = customFormDetals.queId
                                        dictData.type = customFormDetals.type
                                        dictData.isAdded = isAdded
                                       // dictData.layer = layer
                                        dictData.ans = [ansDetails]()
           
                                        let dictData1 = ansDetails()
           
                                        if optDetail.value != "" {
                                           // let dictData1 = ansDetails()
                                            dictData1.key = optDetail.key
                                            dictData1.value = trimString(string: optDetail.value!)
                                            dictData1.layer = layer
                                            dictData.ans?.append(dictData1)
                                        }
           
           
                              if let idx = self.customVCArr.firstIndex(where: { $0.queId ==  customFormDetals.queId }){
                                  let objOfCusArr  = self.customVCArr[idx]
           
           
                                  let isExist = objOfCusArr.ans?.firstIndex(where: { $0.key == optDetail.key })
           
           
                                  if (isExist != nil){
           
                                      if optDetail.value == "" {
                                          objOfCusArr.ans?.remove(at: 0)
                                      }else{
                                          objOfCusArr.ans?[0].value = optDetail.value
                                      }
           
                                      // print(objOfCusArr.ans?.count)
                                  }else{
           
                                      if optDetail.value != "" {
                                          objOfCusArr.ans?.append(dictData1)
                                      }
           
           
                                      //print(objOfCusArr.ans?.count)
                                  }
                              }else{
                                  self.customVCArr.append(dictData)
                              }
                          }
           
                   @objc func tapOnTermAndConditionButton(sender: UIButton) {
                     //  print(sender.tag)
           
           
                       var isSelected = "0"
           
                       if sender.currentImage == UIImage(named: "BoxOFCheck") {
                           sender.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                           isSelected = "0"
                       }else{
                           sender.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
                           isSelected = "1"
                       }
           
                       let customFormDetals = arrOfShowData11[sender.tag]
           
           
                       let layer = String(format: "%d.1", (sender.tag + 1))
                      let opt = OptDetals(key:"0", questions: nil, value: isSelected, optHaveChild: nil)
           
           
                       self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
           
           
               //        for obj in customFormDetals.ans!{
               //
               //            let layer = String(format: "%d.1", (sender.tag + 1))
               //            let opt = OptDetals(key: obj.key, questions: nil, value: isSelected, optHaveChild: nil)
               //            self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
               //        }
           
           
                   }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var cellToReturn = UITableViewCell() // Dummy value
                if tableView == self.tableView {
                    
                    return  ss.count
                 
                    
                } else if tableView == self.customTblView {
                       return  arrOfShowData11.count
                   // print(arrOfShowData11.count)
                    
                }
                
            return  ss.count + arrOfShowData11.count
         }

         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            var cellToReturn = UITableViewCell() // Dummy value
                     if tableView == self.tableView {
                        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
                            
                                     cell?.backgroundColor = .clear
                                     //cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
                          

                                   if(cell == nil){
                                       cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
                                   }

                              let jobTittleListData  = ss[indexPath.row] as? FieldWorkerDetails// searcharraisbol ? searcharra[indexPath.row] as?
                               

                                          cell?.textLabel?.text = jobTittleListData?.fnm
                                          cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
                                          cell?.textLabel?.textColor = UIColor.darkGray
                                 return cell!
                                     cellToReturn = cell!
            
            }
            
             else if tableView == self.customTblView {
                        
                       
                                       let customFormDetals = arrOfShowData11[indexPath.row]
                    
                                       if customFormDetals.type == "3"{ //checkBox
                                         //  let cell: FirstTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "firstCustomCell") as! FirstTableViewCell?)!
                                           let cell: FirstTableViewCell = (self.customTblView.dequeueReusableCell(withIdentifier:"firstCustomCell") as! FirstTableViewCell?)!
                                           cell.numberlbl.text =  "\(indexPath.row + 1)."

                                           if customFormDetals.mandatory == "1"{
                                               cell.questionLbl.text = "\(customFormDetals.des ?? "") *"
                                           }else{
                                               cell.questionLbl.text = customFormDetals.des
                                           }

                                           let height = cell.questionLbl.text?.height(withConstrainedWidth: cell.questionLbl.frame.size.width, font: UIFont.systemFont(ofSize: 15.0))
                                           let frame = CGRect(x: 0, y: Int(height! + 20), width: Int(windowController.view.frame.size.width-32), height: ((customFormDetals.opt?.count)!*40))

                                           cell.lbl_Qust_B.constant = CGFloat((((customFormDetals.opt?.count)!*40)))

                                           //For Already selected ans
                                       if(customFormDetals.ans != nil && customFormDetals.ans?.isEmpty != true){
                                           for obj in customFormDetals.ans!{

                                                   let layer : String?
                                                   let idx = customFormDetals.opt?.firstIndex(where: { $0.key == obj.key})


                                               if idx != nil{
                                                   if(sltQuestNo == "" || sltQuestNo == nil){
                                                       layer =   String(format: "%d.%d", (indexPath.row + 1) ,(idx! + 1))
                                                   }else{
                                                       layer =  String(format: "%@.%d.%d", sltQuestNo! ,(indexPath.row + 1),(idx! + 1))
                                                   }

                                                   // let opt = OptDetals(key: obj.key, questions: nil, value: obj.value, optHaveChild: nil)
                                                   let opt = OptDetals(key: obj.key, questions: nil, value: obj.value, optHaveChild: nil)
                                                   self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                                               }


                                               }
                                           }

                                         cell.addSubTblView(frame: frame, ShowData: customFormDetals.opt, alreadyGivnAns: customFormDetals.ans , selection: { (success , result , sltIdx) in
                                               if(success){
                                                //  print("SuccessFull")

                                                   if(self.sltQuestNo == "" || self.sltQuestNo == nil){
                                                       self.sltQuestNo =   String(format: "%d.%d", (indexPath.row + 1) ,(sltIdx))
                                                   }else{
                                                       self.sltQuestNo =  String(format: "%@.%d.%d", self.sltQuestNo! , indexPath.row + 1 ,sltIdx)
                                                   }

                                                   //Save Data into Temp Array
                                                   self.saveDataIntoTempArray(isAdded: true, layer: self.sltQuestNo! , optDetail: (result as? OptDetals)!, customFormDetals: customFormDetals)

                           //                        if (result as? OptDetals)!.optHaveChild == "1" {
                           //                            self.getQuestionsByParentIdWhenAnsClick(optDetails: result as? OptDetals)
                           //                        }

                                               }else{

                                                   if(self.sltQuestNo != nil){
                                                       if((self.sltQuestNo?.count)! > 3){
                                                           let name: String = self.sltQuestNo!
                                                           let endIndex = name.index(name.endIndex, offsetBy: -4)
                                                           self.sltQuestNo = String(name[..<endIndex]) //name.substring(to: endIndex)
                                                       }
                                                   }



                                                   //Delete Value From Main Array when Deselect any options
                                                   for (index,obj) in APP_Delegate.mainArr.enumerated(){
                                                       if let idx = obj.ans?.firstIndex(where: { $0.key == (result as? OptDetals)?.key}){
                                                           let diSelectObj = APP_Delegate.mainArr[index]
                                                           // let str = diSelectObj.layer
                                                           let str = diSelectObj.ans![idx].layer
                                                           APP_Delegate.mainArr =  APP_Delegate.mainArr.filter({ (obj) -> Bool in
                                                               obj.ans = obj.ans?.filter({ (ansobj) -> Bool in
                                                                   if(ansobj.layer?.hasPrefix(str!))!{
                                                                       return false
                                                                   }else{
                                                                       return true
                                                                   }
                                                               })

                                                               if(obj.ans?.count !=  0){
                                                                   return true
                                                               }else{
                                                                   return false
                                                               }
                                                           })

                                                       }

                                                   }

                                                 //Delete Value From CustomArray Array when Deselect any options
                                                   for (index,obj) in self.customVCArr.enumerated(){
                                                       if let idx = obj.ans?.firstIndex(where: { $0.key == (result as? OptDetals)?.key}){
                                                           let diSelectObj = self.customVCArr[index]
                                                          // let str = diSelectObj.layer
                                                           let str = (diSelectObj.ans![idx]).layer
                                                           self.customVCArr =  self.customVCArr.filter({ (obj) -> Bool in
                                                             obj.ans = obj.ans?.filter({ (ansobj) -> Bool in
                                                                   if(ansobj.layer?.hasPrefix(str!))!{
                                                                        return false //remove
                                                                   }else{
                                                                       return true
                                                                   }
                                                               })

                                                               if(obj.ans?.count !=  0){
                                                                    return true
                                                               }else{
                                                                    return false // Remove
                                                               }
                                                           })

                                                       }

                                                   }




                                                   //Delete Value From CustomArray Array when Deselect any options
                                                   for (index,obj) in APP_Delegate.mainArr.enumerated(){
                                                       if let idx = obj.ans?.firstIndex(where: { $0.key == (result as? OptDetals)?.key}){
                                                           let diSelectObj = APP_Delegate.mainArr[index]
                                                           // let str = diSelectObj.layer
                                                           let str = diSelectObj.ans![idx].layer
                                                           APP_Delegate.mainArr =  APP_Delegate.mainArr.filter({ (obj) -> Bool in
                                                              obj.ans = obj.ans?.filter({ (ansobj) -> Bool in
                                                                   if(ansobj.layer?.hasPrefix(str!))!{
                                                                       return false
                                                                   }else{
                                                                       return true
                                                                   }
                                                               })

                                                               if(obj.ans?.count !=  0){
                                                                   return true
                                                               }else{
                                                                   return false
                                                               }
                                                           })
                                                       }

                                                   }

                                               }
                                           })

                                return cell
                                        
                                         } else if customFormDetals.type == "2"{ //TextArea

                                           let cell: ThirdTableViewCell = (self.customTblView.dequeueReusableCell(withIdentifier: "thirdCustomCell") as! ThirdTableViewCell?)!



                                           if customFormDetals.mandatory == "1"{
                                               cell.lbl_Qstn.text = "\(customFormDetals.des ?? "") *"
                                           }else{
                                               cell.lbl_Qstn.text = customFormDetals.des
                                           }
                                           cell.txtView.tag = indexPath.row
                                           cell.txtView.delegate = self
                                           cell.numberlbl.text =   "\(indexPath.row + 1)."



                                           //For Already slt ans
                                           if(customFormDetals.ans != nil && customFormDetals.ans?.isEmpty != true){
                                               cell.txtView.textColor = UIColor.black
                                               cell.txtView.text = customFormDetals.ans![0].value!
                                               for obj in customFormDetals.ans!{
                                                   let layer = String(format: "%d.1", (indexPath.row + 1))
                                                   let opt = OptDetals(key: obj.key, questions: nil, value: obj.value, optHaveChild: nil)
                                                   self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                                               }
                                           }
                                               return cell

                                       }else if customFormDetals.type == "1"{ //Text
                                           let cell: SecondTableViewCell = (self.customTblView.dequeueReusableCell(withIdentifier: "secondCustomCell") as! SecondTableViewCell?)!


                                           if customFormDetals.mandatory == "1"{
                                               cell.lbl_Qstn.text = "\(customFormDetals.des ?? "") *"
                                           }else{
                                               cell.lbl_Qstn.text = customFormDetals.des
                                           }

                                           cell.txt_Field.tag = indexPath.row
                                           cell.txt_Field.delegate = self
                                           cell.numberlbl.text =   "\(indexPath.row + 1)."

                                           //For Already slt ans
                                           if(customFormDetals.ans != nil && customFormDetals.ans?.isEmpty != true) {
                                           cell.txt_Field.textColor = UIColor.black
                                           cell.txt_Field.text = customFormDetals.ans![0].value
                                               for obj in customFormDetals.ans!{
                                                   let layer = String(format: "%d.1", (indexPath.row + 1))
                                                   let opt = OptDetals(key: obj.key, questions: nil, value: obj.value, optHaveChild: nil)
                                                   self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                                               }
                                              }



                                           return cell
                                         } else if customFormDetals.type == "4"{ //DropDown
                                           let cell: fourthTableViewCell = (self.customTblView.dequeueReusableCell(withIdentifier: "fourthCustomCell") as! fourthTableViewCell?)!

                                           cell.numberlbl.text =   "\(indexPath.row + 1)."
                                           if customFormDetals.mandatory == "1"{
                                               cell.lbl_Qstn.text = "\(customFormDetals.des ?? "") *"
                                           }else{
                                               cell.lbl_Qstn.text = customFormDetals.des
                                           }
                                           cell.arrOFShowData = customFormDetals.opt!


                                           //For Already slt ans
                                           if(customFormDetals.ans != nil && customFormDetals.ans?.isEmpty != true){
                                               cell.sltItem =  customFormDetals.ans![0].value
                                               cell.lbl_Ans.textColor = UIColor.black
                                               cell.lbl_Ans.text =  customFormDetals.ans![0].value

                                               for obj in customFormDetals.ans!{
                                                   let layer : String?
                                                   if let idx = customFormDetals.opt?.firstIndex(where: { $0.key == obj.key}){
                                                       if(sltQuestNo == "" || sltQuestNo == nil){
                                                           layer =   String(format: "%d.%d", (indexPath.row + 1) ,(idx + 1))
                                                       }else{
                                                           layer =  String(format: "%@.%d.%d", sltQuestNo! ,(indexPath.row + 1),(idx + 1))
                                                       }

                                                       let opt = OptDetals(key: obj.key, questions: nil, value: obj.value, optHaveChild: nil)
                                                       self.saveDataIntoTempArray(isAdded: true, layer: layer, optDetail: opt , customFormDetals: customFormDetals)
                                                   }


                                               }

                                           }else{
                                               cell.sltItem =  LanguageKey.select_option
                                               cell.lbl_Ans.textColor =  UIColor.lightGray
                                               cell.lbl_Ans.text =  LanguageKey.select_option
                                           }

                                           cell.callBack = {(success : Bool ,result : OptDetals , sltIdx : Int) -> Void in
                                               if(success){

                                                   cell.lbl_Ans.textColor = UIColor.black
                                                   cell.lbl_Ans.text = result.value
                                                   cell.sltItem = cell.lbl_Ans.text


                                                   if(self.sltQuestNo == "" || self.sltQuestNo == nil){
                                                       self.sltQuestNo =   String(format: "%d.%d", (indexPath.row + 1) ,(sltIdx))
                                                   }else{
                                                       self.sltQuestNo =  String(format: "%@.%d.%d", self.sltQuestNo!,(indexPath.row + 1) ,sltIdx)
                                                   }

                                                   if let idx = self.customVCArr.firstIndex(where: { $0.queId == customFormDetals.queId }){
                                                       self.customVCArr.remove(at: idx)
                               //                        print(self.customVCArr)
                               //                        print(self.customVCArr.count)
                                                   }

                                                   //Save Data into Temp Array
                                                   self.saveDataIntoTempArray(isAdded: true, layer: self.sltQuestNo! , optDetail: result , customFormDetals: customFormDetals)

                           //                        if result.optHaveChild == "1" {
                           //                            self.getQuestionsByParentIdWhenAnsClick(optDetails: result )
                           //                        }


                                               }else{
                                                   cell.sltItem = LanguageKey.select_option
                                                   cell.lbl_Ans.text = LanguageKey.select_option
                                                  // self.sltQuestNo = ""
                                                   if(self.sltQuestNo != nil && self.sltQuestNo != ""){
                                                       if((self.sltQuestNo?.count)! > 3){
                                                           let name: String = self.sltQuestNo!
                                                           let endIndex = name.index(name.endIndex, offsetBy: -4)
                                                           self.sltQuestNo = String(name[..<endIndex]) //name.substring(to: endIndex)
                                                         //  print(name)      // "Dolphin"
                                                           //print(self.sltQuestNo) // "Dolph"
                                                       }
                                                   }


                                                   //Delete Value From CustomArray Array when Deselect any options
                                                   for (index,obj) in APP_Delegate.mainArr.enumerated(){
                                                       if let idx = obj.ans?.firstIndex(where: { $0.key == (result as OptDetals).key}){
                                                           let diSelectObj = APP_Delegate.mainArr[index]
                                                           // let str = diSelectObj.layer
                                                           let str = (diSelectObj.ans![idx] as ansDetails).layer
                                                           APP_Delegate.mainArr =  APP_Delegate.mainArr.filter({ (obj) -> Bool in
                                                               obj.ans = obj.ans?.filter({ (ansobj) -> Bool in
                                                                   if(ansobj.layer?.hasPrefix(str!))!{
                                                                       return false
                                                                   }else{
                                                                       return true
                                                                   }
                                                               })

                                                               if(obj.ans?.count !=  0){
                                                                   return true
                                                               }else{
                                                                   return false
                                                               }
                                                           })
                                                           //print(APP_Delegate.mainArr.count)

                                                       }

                                                   }

                                                 //Delete Value From CustomArray Array when Deselect any options
                                                   for (index,obj) in self.customVCArr.enumerated(){
                                                       if let idx = obj.ans?.firstIndex(where: { $0.key == (result as OptDetals).key}){
                                                           let diSelectObj = self.customVCArr[index]
                                                           // let str = diSelectObj.layer
                                                           let str = (diSelectObj.ans![idx] as ansDetails).layer
                                                           self.customVCArr =  self.customVCArr.filter({ (obj) -> Bool in
                                                               obj.ans = obj.ans?.filter({ (ansobj) -> Bool in
                                                                   if(ansobj.layer?.hasPrefix(str!))!{
                                                                       return false
                                                                   }else{
                                                                       return true
                                                                   }
                                                               })

                                                               if(obj.ans?.count !=  0){
                                                                   return true
                                                               }else{
                                                                   return false
                                                               }
                                                           })
                                                          // print(self.customVCArr.count)

                                                       }

                                                   }
                                                 }
                                             }
                                           return cell
                                       } else if customFormDetals.type == "8"{

                                           let cell: sixthTableViewCell = (self.customTblView.dequeueReusableCell(withIdentifier: sixthTableViewCell.identifier) as! sixthTableViewCell?)!


                                           cell.lblTerms.text =  "\(indexPath.row + 1)."

                           //                             if customFormDetals.mandatory == "1"{
                           //                                 cell.lblTerms.text = "\(customFormDetals.des ?? "") *"
                           //                             }else{
                           //                                 cell.lblTerms.text = customFormDetals.des
                           //                             }
                                           cell.btnCheckBox.tag = indexPath.row

                                           cell.btnCheckBox.addTarget(self, action: #selector(tapOnTermAndConditionButton(sender:)), for: .touchUpInside)


                                           if(customFormDetals.ans != nil && customFormDetals.ans?.isEmpty != true) {
                                               if customFormDetals.ans![0].value == "1" {
                                                   cell.btnCheckBox.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
                                               }else{
                                                   cell.btnCheckBox.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                                               }
                                           }

                                           return cell


                                       }
                                       else if customFormDetals.type == "9" {
                                           let cell: sixthTableViewCell = (self.customTblView.dequeueReusableCell(withIdentifier: sixthTableViewCell.identifier) as! sixthTableViewCell?)!
                                            cell.lblTerms.text =  "\(indexPath.row + 1)."
                                            cell.btnCheckBox.isHidden = true

                                            if customFormDetals.mandatory == "1"{
                                                cell.lblTerms.text = "\(customFormDetals.des ?? "") *"
                                            }else{
                                                cell.lblTerms.text = customFormDetals.des
                                            }

                                            return cell
                                       }

                                       else {
                                           let cell: fifthTableViewCell = (self.customTblView.dequeueReusableCell(withIdentifier: "fifthCustomCell") as! fifthTableViewCell?)!
                                           cell.btnSltDate.addTarget(self, action: #selector(btnSltDateActionMethod(btn:)), for: .touchUpInside)
                                           cell.btnSltDate.tag = indexPath.row
                                           cell.numberlbl.text =   "\(indexPath.row + 1)."
                                           cell.type = customFormDetals.type ?? "5"

                                           let title : String = customFormDetals.type == "5" ? LanguageKey.date : customFormDetals.type == "6" ? LanguageKey.time : LanguageKey.datetime
                                           cell.lbl_Ans.text = title


                                           if customFormDetals.mandatory == "1"{
                                               cell.lbl_Qstn.text = "\(customFormDetals.des ?? "") *"
                                           }else{
                                               cell.lbl_Qstn.text = customFormDetals.des
                                           }


                                           //For Already slt ans
                                           if(customFormDetals.ans != nil && customFormDetals.ans?.isEmpty != true){
                                             //  cell.sltItem =  customFormDetals.ans![0].value
                                               cell.lbl_Ans.textColor = UIColor.black

                                               let dateFormate : DateFormate = customFormDetals.type == "5" ? DateFormate.dd_MMM_yyyy : customFormDetals.type == "6" ? DateFormate.h_mm_a : DateFormate.ddMMMyyyy_hh_mma

                                               cell.lbl_Ans.text = timeStampToDateFormate(timeInterval: customFormDetals.ans![0].value!, dateFormate: dateFormate.rawValue)
                                               for obj in customFormDetals.ans!{
                                                   let layer = String(format: "%d.1", (indexPath.row + 1))
                                                   let opt = OptDetals(key: obj.key, questions: nil, value: timeStampToDateFormate(timeInterval: obj.value!, dateFormate: dateFormate.rawValue) , optHaveChild: nil)
                                                   self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                                               }
                                           }


                                           return cell
                                       }


                         // cellToReturn = cell
                      }

                     return cellToReturn
            
                                        
         }

         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let objOfArr = searcharraisbol ? searcharra[indexPath.row] as? UserJobTittleNm : arra[indexPath.row] as? UserJobTittleNm

           //   let jobTittleListData  = ss[indexPath.row] as? FieldWorkerDetails
          //  param.memIds = jobTittleListData?.usrId
//    if param.jtId == nil {
//        param.jtId = [jtIdParam]()
//    }
//
//    let jt = jtIdParam()
//    jt.jtId = objOfArr?.jtId
//    jt.title = objOfArr?.title
//
//    let isExist =  param.jtId?.contains{ ( arry : jtIdParam) -> Bool in
//        if arry.jtId == jt.jtId{
//            return true
//        }
//        return false
//    }
//
//    if !isExist!{
//         param.jtId?.append(jt)
//    }else{
//        let objIndex : Int? = param.jtId?.firstIndex(where: { (jtData : jtIdParam) -> Bool in
//            if jt.jtId == jtData.jtId{
//                return true
//            }else{
//                return false
//            }
//        })
//        if (objIndex != nil){
//            param.jtId?.remove(at: objIndex!)
//        }
//    }
//
//    if (param.jtId != nil && param.jtId!.count > 0) {
//
//        var strTitle = ""
//        for jtid in param.jtId! {
//            if strTitle == ""{
//                strTitle = jtid.title ?? ""
//            }else{
//                strTitle = "\(strTitle), \(jtid.title ?? "")"
//
//            }
//            DispatchQueue.main.async {
//                self.txtfldJobTitle.text = strTitle
//            }
//
//        }
//    }else{
//        self.txtfldJobTitle.text = ""
//    }
//
//            tableView.reloadData()
//
//            self.searchDropDwnView.isHidden = true
//                  self.searchBackBtn.isHidden = true
            }


         func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return UITableView.automaticDimension
         }


}

//=================================
//MARK: View controller Extension
//=================================
extension AddAudit: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getTempIdForNewAttechment(newId : Int) -> String {
        
        return "\(getCurrentTimeStamp())"
        
    }
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        self.addImageInline(image: (info[.originalImage] as? UIImage)!)


        let imgStruct = ImageModel(img: (info[.originalImage] as? UIImage)?.resizeImage(targetSize: CGSize(width: 200.0, height: 200.0)), id: getTempIdForNewAttechment(newId: 0))
        imgArr.append(imgStruct)
        self.H_JobDes.constant = self.H_JobDes.constant+100



        stringToHtmlFormate()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Did cancel")
           killLoader()
        //self.H_JobDes.constant = 50
        picker.dismiss(animated: true, completion: nil)
    }

    //=================================
    //MARK: Other methods
    //=================================
    func addImageInline(image: UIImage) {
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        //images.append(image)
        let oldwidth: CGFloat = textAttachment.image?.size.width ?? 0

        let scaleFactor = oldwidth/150 // resize image
        textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)

        textView.textStorage.insert(attrStringWithImage, at: textView.selectedRange.location)
    }

    //====================================================//
    // convert string to html formate
    //====================================================//
    func stringToHtmlFormate(){
        let finalText = self.textView.attributedText
        
        DispatchQueue.global(qos: .background).async {
            self.stringToHtml = finalText!.toHtml() ?? ""
            let urlPaths = self.stringToHtml.imagePathsFromHTMLString()
            //print(urlPaths)// get all images fake paths
            
            for (index,pathInside) in urlPaths.enumerated() {
                let imageId = "_jobAttSeq_\(index)_"
                if imageId != "" {
                    self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
                }
            }
            //            for (index,model) in self.imgArr.enumerated() {
            //                let imageId = "_jobAttSeq_\(index)_"
            //                if imageId != "" {
            //                     self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
            //                }
            //              //  self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
            //            }
            
            //print(self.stringToHtml)
            
            DispatchQueue.main.async {
                killLoader()
                print("Successfully converted string to HTML")
            }
        }
    }
}
