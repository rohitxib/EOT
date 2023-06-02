//
//  AddQuoteVC.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 30/07/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddQuoteVC: UIViewController, UITextFieldDelegate, UITextViewDelegate , OptionViewDelegate {
    
    @IBOutlet weak var partLblStatusTxtFld: UILabel!
    @IBOutlet weak var H_status_Nots: NSLayoutConstraint!
    @IBOutlet weak var txtfld_Status_Nots: FloatLabelTextField!
    @IBOutlet weak var txtView_H: NSLayoutConstraint!
    @IBOutlet weak var txtViewDes: UITextView!
    @IBOutlet weak var H_lattitude: NSLayoutConstraint!
    @IBOutlet weak var latitued: UITextField!
    @IBOutlet weak var longitued: UITextField!
    @IBOutlet weak var btnDonebgView: UIButton!
    @IBOutlet weak var btnCancelbgView: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblSchedulStart: UILabel!
    @IBOutlet weak var lblScheduleEnd: UILabel!
    @IBOutlet var txtfldJobTitle: UITextField!
    @IBOutlet var txtfld_JobDesc: UITextField!
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
    @IBOutlet var txtfld_FieldWorker: UITextField!
    @IBOutlet var dateAndTimePicker: UIDatePicker!
    @IBOutlet weak var lblnote: UILabel!
    @IBOutlet var lbl_EndSchDate: UILabel!
    @IBOutlet var lbl_SrtSchDate: UILabel!
    @IBOutlet var bgViewOfPicker: UIView!
    @IBOutlet var scroll_View: UIScrollView!
    @IBOutlet var btnClient: UIButton!
    @IBOutlet var btnSitName: UIButton!
    @IBOutlet var btnContact: UIButton!
    @IBOutlet weak var lblTermsAndCondition: UILabel!
    @IBOutlet weak var txtViewTermsAndCondition: UITextView!
    @IBOutlet weak var txtfld_status: FloatLabelTextField!
    @IBOutlet weak var hideStatusField: NSLayoutConstraint!
    @IBOutlet weak var txtNote: UITextView!

    var imagePicker = UIImagePickerController()
    var imgArr = [ImageModel]()
    var stringToHtml = ""
    var optionalVw : OptionalView?
    var isOpenOptionalView = false
    let arrOfPriroty = ["Low" , "Medium" , "High"]
    var arrClintList = [ClientList]()
    var FltArrClintList = [ClientList]()
    var arrOffldWrkData = [FieldWorkerDetails]()
    var FltArrOffldWrkData = [FieldWorkerDetails]()
    var arrOfShowData = [Any]()
    var arrOfaddTags = [[String : String]]()
    var sltDropDownBtnTag : Int!
    var sltTxtField = UITextField()
    var sltTxtView : UITextView?
    var isStartScheduleBtn : Bool!
    let cellReuseIdentifier = "cell"
    let param = Params()
    var isClintFutUser  = false
    var isSitFutUser  = false
    var isContactFutUser  = false
    var isClear  = false
    var callbackForQuoteInvVC: ((Bool) -> Void)?
    var invDate : String = ""
    var dueDate : String = ""
    var quoteDetailData : QuotationDetailData?
    var boolQuat = false
    var aadquote : CommanListDataModel?
    var isEnableTextView = false
    var txtViewData : String?
    var contryCode = ""
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else { return }
        
        DispatchQueue.main.async {
            self.removeOptionalView()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        if let enableCustomForm = getDefaultSettings()?.isQuotStatusComtEnable{
            if enableCustomForm == "0"{
            self.partLblStatusTxtFld.isHidden = true
            self.H_status_Nots.constant = 0
        }else{
            self.H_status_Nots.constant = 50
            self.partLblStatusTxtFld.isHidden = false
        }
    }

        txtViewDes.delegate = self
        txtViewDes.text = LanguageKey.quote_desc
        txtViewDes.textColor = UIColor.lightGray
        
        if let cntryCode = getDefaultSettings()?.ctryCode
        {
            contryCode = cntryCode
        }
        if boolQuat == true {
            DetailQuot()
        }
      
        H_lattitude.constant = 0.0
        IQKeyboardManager.shared.enable = false
        self.registorKeyboardNotification()
        self.getClintListFrmDB()
        getJobTittle()
        getFieldWorkerList()
        getTagListService()
        getClientSink()
        getClientSiteSink()
        getClientContactSink()
       
        if let langCode = getCurrentSelectedLanguageCode() {
            dateAndTimePicker.locale = Locale(identifier: langCode)
        }
        setLocalization()
    }
    
    func DetailQuot (){
        txtfld_Client.isUserInteractionEnabled = false
        txtfld_Client.textColor = UIColor.lightGray
        txtfld_Client.text = aadquote?.nm != nil ? aadquote?.nm : "Unknown"
        txtfld_PostalCode.text = aadquote?.zip != nil ? aadquote?.zip : "Unknown"
        txtfld_City.text = aadquote?.city != nil ? aadquote?.city : "Unknown"
        txtfld_Email.text = aadquote?.email
        self.txtViewDes.text = self.aadquote?.des
        self.stringToHtml = self.txtViewDes.text
       
            DispatchQueue.global(qos: .background).async {
                let htmlString = self.aadquote?.des
                let attributedString = htmlString!.htmlToAttributedString
                DispatchQueue.main.async {
                    self.txtViewDes.attributedText = attributedString
                    killLoader()
                   
                }
            }
      
        // Append Address detail==============================
        let city = aadquote?.city != "" ? aadquote?.city : ""
        let adr = aadquote?.adr != "" ? aadquote?.adr : ""
        
        var ctry = aadquote?.ctry != "" ? aadquote?.ctry : ""
        var stt = aadquote?.state != "" ? aadquote?.state : ""
        
        if(ctry != ""){
            let name = filterStateAccrdToCountry(serchCourID: (ctry)!, searchPredicate: "id", arr: getCountry() as! [Any])
            ctry = name.count != 0 ? (name[0] as? [String : Any])!["name"] as? String  : ""
        }
        
        
        if(stt != ""){
            let statename = filterStateAccrdToCountry(serchCourID: (stt)!, searchPredicate: "id", arr: getStates() as! [Any])
            stt = statename.count != 0 ? (statename[0] as? [String : Any])!["name"] as? String : ""
        }
      
        txtfld_Country.text = "India"
        txtfld_State.text = "Madhya Pradesh"
        param.ctry = "101"
        param.state =  "21"
        
        var address = ""
        
        if adr! != "" {
            if address == "" {
                address =  "\(adr!)"
            }
        }
        
        if let mark = aadquote?.landmark {
            
            if address != "" {
                if  mark != "" {
                    address = address + ", \(mark.capitalizingFirstLetter())"
                }
            } else {
                address = mark.capitalizingFirstLetter()
            }
        }
        
        if city! != "" {
            if address != ""{
                address = address + ", \(city!)".capitalized
            }else{
                address = "\(city!)"
            }
        }
        
        
        if stt! != "" {
            if address != ""{
                address = address + ", \(stt!)".capitalized
            }else{
                address = "\(stt!)"
            }
        }
        
        if ctry! != "" {
            if address != ""{
                address = address + ", \(ctry!)".capitalized
            }else{
                address = "\(ctry!)"
            }
        }
        
        
        if  address != "" {
            txtfld_Address.attributedText =  lineSpacing(string: address.capitalized, lineSpacing: 7.0)
        }else{
            txtfld_Address.text = ""
        }
        
        
        //   param.ctry = aadquote?.ctry
        //     param.state = aadquote?.state
        param.cltId = aadquote?.cltId
        param.conId = aadquote?.conId
        param.siteId = aadquote?.siteId
        param.cnm = aadquote?.cnm
        param.snm = aadquote?.snm
        //   param.assignByUser = aadquote?.assignByUser
        param.status = aadquote?.status
        param.athr = aadquote?.athr
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title =  quoteDetailData != nil ? LanguageKey.edit_quote : LanguageKey.add_quote // LanguageKey.title_add_job
        
        txtfld_FieldWorker.placeholder = LanguageKey.assign_to_fw
        lblnote.text = LanguageKey.notes
        lblTermsAndCondition.text = LanguageKey.term_condition
        txtfld_Status_Nots.placeholder = LanguageKey.status_notes
        txtfld_Contact.placeholder = LanguageKey.contact_name
        txtfld_Email.placeholder = LanguageKey.email
        txtfld_MobNo.placeholder = LanguageKey.mob_no
        txtfld_AltMobNo.placeholder = LanguageKey.alt_mobile_number
        txtfldJobTitle.placeholder = "\(LanguageKey.Job_title) *"
        //txtfld_JobDesc.placeholder = LanguageKey.quote_desc
        txtfld_JobInstruction.placeholder = LanguageKey.quote_instr
        txtfld_Client.placeholder = "\(LanguageKey.client_name) *"
        txtfld_SiteName.placeholder = LanguageKey.site_name
        txtfld_Address.placeholder = "\(LanguageKey.address) *"
        txtfld_City.placeholder = LanguageKey.city
        txtfld_PostalCode.placeholder = LanguageKey.postal_code
        txtfld_Country.placeholder = "\(LanguageKey.country) *"
        txtfld_State.placeholder = "\(LanguageKey.state) *"
        txtfld_status.placeholder = LanguageKey.status_radio_btn
        latitued.placeholder = LanguageKey.latitude
        longitued.placeholder = LanguageKey.longitued
        lblSchedulStart.text =  LanguageKey.quotes_start_date
        lblScheduleEnd.text =  LanguageKey.quotes_end_date
        btnDonebgView.setTitle(LanguageKey.done , for: .normal)
        btnCancelbgView.setTitle(LanguageKey.cancel , for: .normal)
        
        btnClient.setTitle(LanguageKey.save_for_future_use , for: .normal)
        btnContact.setTitle(LanguageKey.save_for_future_use , for: .normal)
        btnSitName.setTitle(LanguageKey.save_for_future_use , for: .normal)
        
        if quoteDetailData != nil {
            btnSubmit.setTitle(LanguageKey.update_btn , for: .normal)
        }else{
            btnSubmit.setTitle(LanguageKey.create_quote , for: .normal)
        }
        
        
        if quoteDetailData != nil{
            
            self.txtfld_Client.isUserInteractionEnabled = false
            self.txtfld_Client.textColor = UIColor.lightGray
            
            param.ctry = quoteDetailData?.ctry
            param.state = quoteDetailData?.state
            param.cltId = quoteDetailData?.cltId
            param.conId = quoteDetailData?.conId
            param.siteId = quoteDetailData?.siteId
            param.cnm = quoteDetailData?.cnm
            param.snm = quoteDetailData?.snm
            param.assignByUser = quoteDetailData?.assignByUser
            param.status = quoteDetailData?.status
            param.athr = quoteDetailData?.athr
            
            
            if let userId = quoteDetailData?.assignByUser {
                if userId != "" {
                    let bPredicate = "self.usrId = \(userId)"
                    let fieldworkder = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: bPredicate) as! [FieldWorkerDetails]
                    
                    if fieldworkder.count>0 {
                        txtfld_FieldWorker.text = fieldworkder[0].fnm
                    }
                }
            }
            
            txtfld_JobInstruction.text = quoteDetailData?.inst
            txtfld_Client.text = quoteDetailData?.nm
            txtfld_Contact.text = quoteDetailData?.cnm
            txtfld_MobNo.text = quoteDetailData?.mob1
            txtfld_AltMobNo.text = quoteDetailData?.mob2
            txtfld_Email.text = quoteDetailData?.email
            txtfld_SiteName.text = quoteDetailData?.snm
            txtfld_Address.text = quoteDetailData?.adr
            txtfld_City.text = quoteDetailData?.city
            txtfld_PostalCode.text = quoteDetailData?.zip
            txtfld_Country.text = quoteDetailData?.ctrynm
            txtfld_State.text = quoteDetailData?.statenm
            txtNote.text = quoteDetailData?.invData?.note
            
            let html = quoteDetailData?.term
            let data = Data(html!.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil) {
                DispatchQueue.main.async {
                    self.txtViewTermsAndCondition.attributedText = attributedString
                }
            }
            
            
            let Notehtml = quoteDetailData?.invData?.note
            let notData = Data(Notehtml!.utf8)
            if let attributedStr = try? NSAttributedString(data: notData, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil) {
                DispatchQueue.main.async {
                    self.txtNote.attributedText = attributedStr
                }
            }
            
            if (quoteDetailData?.jtId?.count)! > 0 {
                var strTitle = ""
                for jtid in quoteDetailData!.jtId! {
                    if param.jtId == nil {
                        param.jtId = [jtIdParam]()
                    }
                    let jt = jtIdParam()
                    jt.jtId = jtid.jtId
                    jt.title = jtid.title
                    param.jtId?.append(jt)
                    
                    if strTitle == ""{
                        strTitle = jtid.title ?? ""
                    }else{
                        strTitle = "\(strTitle), \(jtid.title ?? "")"
                    }
                }
                DispatchQueue.main.async {
                    self.txtfldJobTitle.text = strTitle
                }
            }
            
            
            if let status = quoteDetailData?.status {
                let statusType : [QuoteStatusType] = QuoteStatusType.allCases.filter({String($0.rawValue) == status })
                if statusType.count > 0 {
                    let currentStatus = statusType[0]
                    txtfld_status.text = String(describing: currentStatus).capitalizingFirstLetter()
                    param.status = String(currentStatus.rawValue)
                }else{
                    let currentStatus = QuoteStatusType.New
                    txtfld_status.text = String(describing: currentStatus).capitalizingFirstLetter()
                    param.status = String(currentStatus.rawValue)
                }
            }else{
                let currentStatus = QuoteStatusType.New
                txtfld_status.text = String(describing: currentStatus).capitalizingFirstLetter()
                param.status = String(currentStatus.rawValue)
            }
            
            let quoteDt = NSDate(timeIntervalSince1970: (Double(quoteDetailData!.invData!.invDate!)!))
            let dueDt = NSDate(timeIntervalSince1970: (Double(quoteDetailData!.invData!.duedate!)!))
            setDateInQuoteAndDueDate(quoteDt: quoteDt as Date, dueDt: dueDt as Date)
            
            self.txtViewDes.isScrollEnabled = true
            
            
            if self.quoteDetailData?.des == "" {
                txtView_H.constant = 61
            }else{
                self.txtViewDes.isScrollEnabled = true
                txtView_H.constant = 61*4
            }
            
            DispatchQueue.global(qos: .background).async {
                self.stringToHtml = self.quoteDetailData?.des ?? ""
                let htmlString = self.quoteDetailData?.des
                
               // let string = "\(attributedString)"
//                let attributedString = NSMutableAttributedString(string: htmlString ?? "")
//                let firstAttributes: [NSAttributedString.Key: Any] = [
//                    .foregroundColor: UIColor.lightGray]
//                attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length:100))
                
                
                
//                let text = htmlString
//                let linkTextWithColor = text
//
//                let range = (text! as NSString).range(of: linkTextWithColor!)
//
//                let attributedString = NSMutableAttributedString(string:text!)
//                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray , range: NSRange(location: 1, length:5))

               // self.helpText.attributedText = attributedString
                
                
                let attributedString1 = htmlString?.htmlToAttributedString
                DispatchQueue.main.async {
                    
                    self.txtViewDes.attributedText = attributedString1
                    killLoader()
                }
            }
            
        }else{
            getTermsAndCondition()
            hideStatusField.constant = 0.0
            param.status = "1"
            txtfld_FieldWorker.text = (getUserDetails()?.fnm)!
            param.assignByUser = ((getUserDetails()?.usrId)!)
            self.setUpMethod()
        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LocationManager.shared.startStatusLocTracking()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
        self.removeKeyboardNotification()
        LocationManager.shared.stopStatusTracking()
    }
    
    
    func setUpMethod(){
        if getDefaultSettings()?.isJobLatLngEnable == "0" {
            H_lattitude.constant = 0.0
        }
        setDateInQuoteAndDueDate(quoteDt: Date(), dueDt: Date())
    }
    
    
    func setDateInQuoteAndDueDate(quoteDt:Date, dueDt:Date){
        invDate = convertDateToStringForcostomfieldandform(date: quoteDt, dateFormate: DateFormate.dd_MMM_yyyy_hh_mm_ss)
        dueDate = convertDateToStringForcostomfieldandform(date: dueDt, dateFormate: DateFormate.dd_MMM_yyyy_hh_mm_ss)
        
        let strDate = convertDateToString(date: quoteDt, dateFormate: DateFormate.ddMMMyyyy_hh_mm_a)
        let arr = strDate.components(separatedBy: " ")
        lbl_SrtSchDate.text = arr[0]
       // lbl_SrtSchTime.text = arr[1] + " " + arr[2]
       // lbl_EndSchDate.text = arr[0]
        
        let strDate1 = convertDateToString(date: dueDt, dateFormate: DateFormate.ddMMMyyyy_hh_mm_a)
        let arrOfEndDate = strDate1.components(separatedBy: " ")
        lbl_EndSchDate.text = arrOfEndDate[0]
       // lbl_EndSchTime.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
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
    
    
    
    @IBAction func btnSaveAction(_ sender: Any) {
        
        isClear = false
        
        self.bgViewOfPicker.isHidden = true
        let date = self.dateAndTimePicker.date
        let strDate = convertDateToString(date: date, dateFormate: DateFormate.dd_MMM_yyyy_hh_mm_ss)
        
        if(isStartScheduleBtn){
            invDate = convertDateToStringForcostomfieldandform(date: date, dateFormate: DateFormate.dd_MMM_yyyy_hh_mm_ss)
            let arr = strDate.components(separatedBy: " ")
            lbl_SrtSchDate.text = arr[0]
           // lbl_SrtSchTime.text = arr[1] + " " + arr[2]
        }else{
            //let schStartDate = self.lbl_SrtSchDate.text!
            let schEndDate = convertDateToStringForcostomfieldandform(date: date, dateFormate: DateFormate.dd_MMM_yyyy_hh_mm_ss)
            let value = compareTwodateInAddQuotes(schStartDate: invDate, schEndDate: schEndDate, dateFormate: DateFormate.dd_MMM_yyyy_hh_mm_ss)
            if(value == "orderedDescending"){
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
            }else{
                dueDate = convertDateToStringForcostomfieldandform(date: date, dateFormate: DateFormate.dd_MMM_yyyy_hh_mm_ss)
                let arr = strDate.components(separatedBy: " ")
                lbl_EndSchDate.text = arr[0]
              //  lbl_EndSchTime.text = arr[1] + " " + arr[2]
                
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
    
    
    @IBAction func btnSubmitClickAction(_ sender: Any) {
        
        
       // if boolQuat == false{
            let trimmClintNm  = trimString(string: self.txtfld_Client.text!)
                   let trimmAdr = trimString(string: self.txtfld_Address.text!)
                   let trimmMobNo = trimString(string: self.txtfld_MobNo.text!)
                   let trimmAltMobNo = trimString(string: self.txtfld_AltMobNo.text!)
                   let trimmEmail = trimString(string: self.txtfld_Email.text!)
                   let trimmAltSite = trimString(string: self.txtfld_SiteName.text!)
                   let trimmContact = trimString(string: self.txtfld_Contact.text!)
                   

                   if trimmEmail.count > 0 {
                       if !isValidEmail(testStr: trimmEmail)  {
                           ShowError(message: AlertMessage.validEmailId, controller: windowController)
                           return
                       }
                   }
                   
                   
                   if (trimmMobNo.count > 0) && (trimmMobNo.count < 10) {
                       ShowError(message: AlertMessage.validMobile, controller: windowController)
                       return
                   }
                   
                   
                   if trimmAltMobNo.count > 0 && trimmAltMobNo.count < 10 {
                       ShowError(message: AlertMessage.validAlMobileNo, controller: windowController)
                       return
                   }
                   
                   
                   
                   
        if(param.jtId != nil && param.jtId!.count > 0){
            // if(jobPrty != 0){
            if (trimmClintNm != ""){
//                if (trimmContact != ""){
//                    if (trimmAltSite != ""){
                        if(trimmAdr != ""){
                            if(param.ctry != nil) && (param.ctry != ""){
                                if(param.state != nil) && (param.state != ""){
                                    self.addJob()
                                } else {
                                    ShowError(message: AlertMessage.validState, controller: windowController)
                                }
                            } else {
                                ShowError(message: AlertMessage.selectCountry, controller: windowController)
                            }
                        } else {
                            ShowError(message: AlertMessage.validAddress, controller: windowController)
                        }
//                    } else {
//                        ShowError(message: "Please enter Site", controller: windowController)
//                    }
//                } else {
//                    ShowError(message: "Please enter Contact", controller: windowController)
//                }
            } else {
                ShowError(message: AlertMessage.clientName, controller: windowController)
            }
            
            
            
            //            }else{
            //                ShowError(message: AlertMessage.jobPriority, controller: windowController)
            //            }
        }else{
            ShowError(message: AlertMessage.jobTitle, controller: windowController)
        }
        //        }else{
////            let trimmClintNm  = trimString(string: self.txtfld_Client.text!)
////                   let trimmAdr = trimString(string: self.txtfld_Address.text!)
////                   let trimmMobNo = trimString(string: self.txtfld_MobNo.text!)
////                   let trimmAltMobNo = trimString(string: self.txtfld_AltMobNo.text!)
////                   let trimmEmail = trimString(string: self.txtfld_Email.text!)
////
////
////                   if trimmEmail.count > 0 {
////                       if !isValidEmail(testStr: trimmEmail)  {
////                           ShowError(message: AlertMessage.validEmailId, controller: windowController)
////                           return
////                       }
////                   }
////
////
////                   if (trimmMobNo.count > 0) && (trimmMobNo.count < 10) {
////                       ShowError(message: AlertMessage.validMobile, controller: windowController)
////                       return
////                   }
////
////
////                   if trimmAltMobNo.count > 0 && trimmAltMobNo.count < 10 {
////                       ShowError(message: AlertMessage.validAlMobileNo, controller: windowController)
////                       return
////                   }
////
//
//
//
//                   if(param.jtId != nil && param.jtId!.count > 0){
//                       // if(jobPrty != 0){
////                       if (trimmClintNm != ""){
////                           if(trimmAdr != ""){
////                               if(param.ctry != nil) && (param.ctry != ""){
////                                   if(param.state != nil) && (param.state != ""){
//                                       self.addJob()
////                                   } else {
////                                       ShowError(message: AlertMessage.validState, controller: windowController)
////                                   }
////                               } else {
////                                   ShowError(message: AlertMessage.selectCountry, controller: windowController)
////                               }
////                           } else {
////                               ShowError(message: AlertMessage.validAddress, controller: windowController)
////                           }
////                       } else {
////                           ShowError(message: AlertMessage.clientName, controller: windowController)
////                       }
//                       //            }else{
//                       //                ShowError(message: AlertMessage.jobPriority, controller: windowController)
//                       //            }
//                   }else{
//                       ShowError(message: AlertMessage.jobTitle, controller: windowController)
//                   }
//        }
       
    }
    
    @IBAction func btnActionMethod(_ sender: UIButton) {
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
            if(self.optionalVw == nil){
                arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
                if(arrOfShowData.count > 0){
                    self.openDwopDown( txtField: self.txtfldJobTitle, arr: arrOfShowData)
                }else{
                    ShowError(message: AlertMessage.noJobTitleAvailable , controller: windowController)
                }
            }else{
                self.removeOptionalView()
            }
            break
            
        case 2:
            
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
            
            
            if(self.param.conId != nil && self.param.conId != ""){
                
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
            
            if(self.param.siteId != nil && self.param.siteId != ""){
                
                if(param.cltId != nil){
                    let query = "cltId = '\(param.cltId!)'"
                    arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
                    if(arrOfShowData.count > 0){
                        self.openDwopDown( txtField: self.txtfld_SiteName, arr: arrOfShowData)
                        
                    }
                }
            }else{
                param.siteId = ""
                param.snm = self.txtfld_SiteName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                if(btnSitName.imageView?.image == UIImage(named: "BoxOFUncheck")){
                    self.btnSitName.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
                    
                    self.isSitFutUser = true
                }else{
                    self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
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
            }else{
                self.removeOptionalView()
                
            }
            
            
        case 9 :
        if(self.optionalVw == nil){
            self.arrOfShowData = QuoteStatusType.allCases
            if(arrOfShowData.count > 0){
                self.openDwopDown(txtField: self.txtfld_status, arr: self.arrOfShowData)
            }
        }else{
            self.removeOptionalView()
            
        }
            
            
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
            return  arrOfShowData
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
            let jobTittleListData  =  arrOfShowData[indexPath.row] as? UserJobTittleNm
            
            _ =  param.jtId?.contains{ ( arry : jtIdParam) -> Bool in
                if arry.jtId == jobTittleListData?.jtId{
                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                    return true
                }else{
                    cell?.accessoryType = UITableViewCell.AccessoryType.none
                    return false
                }
            }
            
            cell?.textLabel?.text = jobTittleListData?.title?.capitalizingFirstLetter()
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
            let status : String = String(describing: arrOfShowData[indexPath.row])
            cell?.textLabel?.text = status.capitalizingFirstLetter()
            break
            
        default: break
            
        }
        return cell!
        
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.sltDropDownBtnTag {
        case 0:
            let objOfArr = self.arrOfShowData[indexPath.row] as? UserJobTittleNm
            
            if param.jtId == nil {
                param.jtId = [jtIdParam]()
            }
            
            let jt = jtIdParam()
            jt.jtId = objOfArr?.jtId
            //jt.labour = ""
            jt.title = objOfArr?.title
            
            let isExist =  param.jtId?.contains{ ( arry : jtIdParam) -> Bool in
                if arry.jtId == jt.jtId{
                    //print("Already Added this title")
                    return true
                }
                return false
            }
            
            if !isExist!{
                param.jtId?.append(jt)
            }else{
                let objIndex : Int? = param.jtId?.firstIndex(where: { (jtData : jtIdParam) -> Bool in
                    if jt.jtId == jtData.jtId{
                        return true
                    }else{
                        return false
                    }
                })
                if (objIndex != nil){
                    param.jtId?.remove(at: objIndex!)
                }
            }
            
            if (param.jtId != nil && param.jtId!.count > 0) {
                
                var strTitle = ""
                for jtid in param.jtId! {
                    if strTitle == ""{
                        strTitle = jtid.title ?? ""
                    }else{
                        strTitle = "\(strTitle), \(jtid.title ?? "")"
                        
                    }
                    DispatchQueue.main.async {
                        self.txtfldJobTitle.text = strTitle
                    }
                    
                }
            }else{
                self.txtfldJobTitle.text = ""
            }
            
            break
            
        case 2:
            let objOfArr = self.FltArrClintList.count != 0 ? self.FltArrClintList[indexPath.row] : arrClintList[indexPath.row]
            self.txtfld_Client.text = objOfArr.nm
            param.nm = objOfArr.nm
            param.cltId = objOfArr.cltId
            //self.btnClient.setImage(UIImage(named: "arrowdown"), for: .normal)
            //self.btnClient.isHidden = false
            self.btnClient.isHidden = true
            self.txtfld_SiteName.isUserInteractionEnabled = true
            
            let query = "cltId = '\(objOfArr.cltId!)' AND def = '1'"
            
            //For Contact
            let arrOfContNm = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
            if(arrOfContNm.count > 0){
                let contact = arrOfContNm[0]
                self.txtfld_Contact.text = contact.cnm
                param.conId = contact.conId
                self.btnContact.isHidden = true
                txtfld_MobNo.text = contact.mob1
                txtfld_AltMobNo.text = contact.mob2
                txtfld_Email.text = contact.email
            }else{
                self.txtfld_Contact.text = ""
                param.conId = nil
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
                self.btnSitName.isHidden = true
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
            self.txtfld_FieldWorker.text = ((self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.fnm)!
            param.assignByUser = ((self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.usrId)!
            break
            
        case 9:
            let status : String = String(describing: arrOfShowData[indexPath.row])
            self.txtfld_status.text = status.capitalizingFirstLetter()
            
            let status1 : QuoteStatusType = arrOfShowData[indexPath.row] as! QuoteStatusType
            param.status = String(status1.rawValue)
            break
            
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
                    self.openDwopDown( txtField: self.txtfld_SiteName, arr: arrOfShowData)
                    
                }else{
                    self.btnSitName.isHidden = false
                    self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                }
            }
            
        }else if self.sltTxtField.isEqual(txtfld_Country) {
          //  self.txtfld_Country.text = ""
            self.txtfld_State.isEnabled = true
            self.removeOptionalView()
            arrOfShowData = getJson(fileName: "countries")["countries"] as! [Any]
            self.openDwopDown( txtField: self.txtfld_Country, arr: arrOfShowData)
            
            
            
        }else if self.sltTxtField.isEqual(txtfld_State){
           // self.txtfld_State.text = ""
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
        }else{
            self.removeOptionalView()
        }
        
    }
    
    
  
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtViewDes.text == LanguageKey.quote_desc {
            txtViewDes.text = nil
            txtViewDes.textColor = UIColor.lightGray
        }
        isEnableTextView = true
        sltTxtView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isEnableTextView = false
         sltTxtView = nil
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
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
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
        self.sltDropDownBtnTag = textField.tag
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if (textField == txtfld_PostalCode) {
                       
                       if (string != "") && (textField.text?.count)! > 7 {
                           return false
                       }
             }
        
        
        if (textField == txtfld_MobNo) || (textField == txtfld_AltMobNo){
            
            if (string != "") && (textField.text?.count)! > 13  {
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
        
        
        
        
        
        switch self.sltDropDownBtnTag {
        case 0:
            
            let bPredicate: NSPredicate = NSPredicate(format: "self.title beginswith[c] '%@'", result)
            let arrAlljobTittle = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
            
            arrOfShowData = (arrAlljobTittle as NSArray).filtered(using: bPredicate)
            self.openDwopDown( txtField: self.txtfldJobTitle, arr: arrOfShowData)
            
            DispatchQueue.main.async{
                if(self.arrOfShowData.count > 0){
                    self.optionalVw?.isHidden = false
                    self.optionalVw?.table_View?.reloadData()
                }else{
                    self.optionalVw?.isHidden = true
                }
            }
            break
        case 2:
            
            
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
                    self.btnClient.isHidden = false
                    self.btnContact.isHidden = true
                    self.btnSitName.isHidden = true
                    
                    self.btnClient.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                    self.param.cltId = nil
                    self.param.nm = result
                    self.param.siteId = nil
                    self.param.snm = self.txtfld_SiteName.text
                    self.txtfld_SiteName.text = "self"
                    self.txtfld_SiteName.isUserInteractionEnabled = true
                    self.param.conId = nil
                    self.param.cnm = ""
                    self.optionalVw?.table_View?.reloadData()
                }else{
                    if(result != ""){ // When Txtfield emprt remove dropdown buttton
                        self.removeOptionalView()
                        self.btnClient.isHidden = false
                        self.btnClient.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        self.param.cltId = nil
                        self.param.nm = result
                        self.param.conId = nil
                        self.param.cnm = ""
                        self.btnContact.isHidden = true
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
                            self.openDwopDown( txtField: self.txtfld_SiteName, arr: arrOfShowData)
                        }
                        DispatchQueue.main.async{
                            self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                            self.btnSitName.isHidden = false
                            self.param.siteId = nil
                            self.param.snm = result
                            self.optionalVw?.table_View?.reloadData()
                        }
                    }else{
                        if(result != ""){
                            self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                            self.btnSitName.isHidden = false
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
            self.param.snm = self.txtfld_SiteName.text
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
            
        default:
            
            break
        }
        
        
        
        return true
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
    
    
    func addJob(){
        
        let value = compareTwodateInAddQuotes(schStartDate: invDate, schEndDate: dueDate, dateFormate: DateFormate.MM_yy)
        if(value == "orderedDescending"){
            ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
            return
        }
        
        showLoader()
        
        param.adr = trimString(string: txtfld_Address.text!)
        param.athr = getUserDetails()?.usrId
        param.city = trimString(string: txtfld_City.text!)
        param.cltId =  param.cltId == nil ?  "" : param.cltId
        param.conId =  param.conId == nil ? "" :  param.conId
        param.siteId = param.siteId == nil ? "" : param.siteId
        param.cnm = (param.conId == "" ?  (param.cnm == "" ? "self" : param.cnm) : "")
        param.snm = param.siteId == "" ? param.snm : ""
        
        if self.stringToHtml != "" {
            param.des = self.stringToHtml
        }else{
            param.des = self.txtViewDes.text
        }
        
        param.email = trimString(string: txtfld_Email.text!)
        param.inst =  trimString(string: txtfld_JobInstruction.text!)
        param.mob1 = trimString(string: txtfld_MobNo.text!)
        param.mob2 = trimString(string: txtfld_AltMobNo.text!)
        param.parentId = ""
        param.quotId = quoteDetailData?.quotId
        param.invId = quoteDetailData?.invData?.invId
        param.status = (param.status == nil) ? String(QuoteStatusType.New.rawValue) : param.status
        param.zip = trimString(string: txtfld_PostalCode.text!)
        param.dueDate = dueDate
        param.invDate = invDate
        param.nm =  param.cltId == "" ? param.nm : ""
        param.compId = getUserDetails()?.compId
        param.clientForFuture =  isClintFutUser ? "1" : "0"
        param.siteForFuture = (isSitFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
        param.contactForFuture = (isContactFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
        param.pymtType = ""
        param.gstNo = ""
        param.tinNo = ""
        param.industry = ""
        param.note = getHTMLtoNormalString(string: trimString(string: txtNote.text))
        param.fax = ""
        param.twitter = ""
        param.skype = ""
        param.statusComment = trimString(string: txtfld_Status_Nots.text!)
        
        param.term = getHTMLtoNormalString(string: trimString(string: txtViewTermsAndCondition.text)) //trimString(string: txtViewTermsAndCondition.text)
        param.lat = LocationManager.shared.currentLattitude
        param.lng = LocationManager.shared.currentLongitude
        
        
        var dict =  param.toDictionary
        var ids = [String]()
        let titles : [[String : String]] = dict!["jtId"] as! [[String : String]]
        
        for title in titles {
            ids.append(title["jtId"]!)
        }
        dict!["jtId"] = ids
        
        serverCommunicatorUplaodImageInArrayForInputField(url: Service.addUpdateQuotationForMobile, param: dict, images: imgArr , imagePath:"qa[]") { (response, success) in
            killLoader()
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AddQuoteResponse.self, from: response as! Data) {
                 
                    if decodedData.success == true{
                        
                        DispatchQueue.main.async {
                            DispatchQueue.main.async {
                                if (self.callbackForQuoteInvVC != nil) {
                                    self.callbackForQuoteInvVC!(true)
                                }
                                if self.boolQuat == true {
                                    let searchQuery = "appId = '\(self.aadquote?.commonId! ?? "")'"
                                    let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: searchQuery) as! [AppointmentList]
                                    if isExist.count > 0 {
                                        let existingJob = isExist[0]
                                        existingJob.quotId = decodedData.data!.quotId
                                        existingJob.quotLabel = decodedData.data!.label
                                    
                                    }
                                    
                                    DatabaseClass.shared.saveEntity(callback: {isSuccess in
                                    
                                    })
                                    
                                }
                                self.navigationController?.popViewController(animated: true)
                            }
                     
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
    
    
    func getHTMLtoNormalString(string: String) -> String{
        let convertedString = string.replacingOccurrences(of: "\n", with: "<br>")
        return convertedString
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
        
       
        
        let lastRequestTime1 : String? = UserDefaults.standard.value(forKey: "") as? String
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = ""
        param.index = "0"
        param.search = ""
        param.dateTime = lastRequestTime ?? "" //currentDateTime24HrsFormate()//lastRequestTime ?? ""
        
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
                //DatabaseClass.shared.saveEntity()
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
                //DatabaseClass.shared.saveEntity()
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
                //DatabaseClass.shared.saveEntity()
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
                    //DatabaseClass.shared.saveEntity()
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
                    //DatabaseClass.shared.saveEntity()
                }
            }else{
                if(jobs.isdelete != "0"){
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
                    userJobs?.setValuesForKeys(jobs.toDictionary!)
                    //DatabaseClass.shared.saveEntity()
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
    // MARK:- Save contact data in DataBase
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
                   // DatabaseClass.shared.saveEntity()
                }
            }
        }
        
         DatabaseClass.shared.saveEntity(callback: { _ in})
        
    }
    
    
    //=========================================
    // MARK:- Get Terms And Condition Service
    //=========================================
    
    func getTermsAndCondition(){

        if !isHaveNetowork() {
            return
        }
  
        serverCommunicator(url: Service.getQuatSetting, param: nil) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(TermsResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async {
                             self.txtViewTermsAndCondition.text = decodedData.data?.quotTerms ?? ""
                        }
                    }
                }
            }
        }
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
        
        if sltTxtView != nil {
            if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                let userInfo = notification.userInfo!
                var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
                keyboardFrame = self.view.convert(keyboardFrame, from: nil)
                
                var visibleRect = self.view.frame;
                visibleRect.size.height -= keyboardFrame.size.height ;
                
                var frameFrmScrollView = self.sltTxtView!.convert(self.sltTxtView!.bounds, to:self.scroll_View)
                frameFrmScrollView.origin.y += 130.0  // 150 DropDown Height
                
                var frameFrmView = self.sltTxtView!.convert(self.sltTxtView!.bounds, to:self.view)
                frameFrmView.origin.y += (130.0 + self.sltTxtView!.frame.size.height )
                
                if(visibleRect.size.height <= frameFrmView.origin.y){
                    let scrollPoint = CGPoint(x: 0.0, y: ((frameFrmScrollView.origin.y + frameFrmScrollView.size.height) - visibleRect.size.height))
                    self.scroll_View.setContentOffset(scrollPoint, animated: true)
                    
                }
            }
        }else{
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
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.removeOptionalView()
    }
    
    //==============================================================//
    // open gallary method
    //==============================================================//
       
    @IBAction func btnAddImage(_ sender: Any) {
        
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
             
                   })
               }
           }
           
           actionSheetControllerIOS8.addAction(gallery)
           actionSheetControllerIOS8.addAction(camera)
           self.present(actionSheetControllerIOS8, animated: true, completion: nil)
       }
}

//=================================
//MARK: View controller Extension
//=================================
extension AddQuoteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getTempIdForNewAttechment(newId : Int) -> String {
        
        return "\(getCurrentTimeStamp())"
        
    }
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        self.addImageInline(image: (info[.originalImage] as? UIImage)!)


        let imgStruct = ImageModel(img: (info[.originalImage] as? UIImage)?.resizeImage(targetSize: CGSize(width: 200.0, height: 200.0)), id: getTempIdForNewAttechment(newId: 0))
        imgArr.append(imgStruct)
        self.txtView_H.constant = self.txtView_H.constant+100



        stringToHtmlFormate()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      //  print("Did cancel")
        
         killLoader()
       // self.txtView_H.constant = 61
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

        txtViewDes.textStorage.insert(attrStringWithImage, at: txtViewDes.selectedRange.location)
    }

    //====================================================//
    // convert string to html formate
    //====================================================//
    func stringToHtmlFormate(){
        let finalText = self.txtViewDes.attributedText
        DispatchQueue.global(qos: .background).async {
            self.stringToHtml = finalText!.toHtml() ?? ""
            let urlPaths = self.stringToHtml.imagePathsFromHTMLString()

            for (index,model) in self.imgArr.enumerated() {
                let imageId = "_jobAttSeq_\(index)_"
                if imageId != "" {
                     self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
                }
            }

            DispatchQueue.main.async {
                  killLoader()
                
            }
        }
    }
}
