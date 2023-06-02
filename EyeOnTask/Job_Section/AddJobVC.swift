//
//  ViewController.swift
//  EyeOnTask
//
//  Created by Apple on 03/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import Firebase
import FirebaseStorage


class AddJobVC: UIViewController, UITextFieldDelegate , OptionViewDelegate ,UITextViewDelegate,DailyRecurProtocol,MonthlyRecurProtocol,WeeklyRecurProtocol{
    
    @IBOutlet weak var shedular_topLbl: NSLayoutConstraint!
    @IBOutlet weak var shedulrStrtDate_topVw: NSLayoutConstraint!
    @IBOutlet weak var top_Constrnt_recerVw: NSLayoutConstraint!
    @IBOutlet weak var checkBtnDispatch: UIButton!
    @IBOutlet weak var dispatchLbl: UILabel!
    @IBOutlet weak var schedularLbl: UILabel!
    @IBOutlet weak var schedulerTxtFld_H: NSLayoutConstraint!
    @IBOutlet weak var scheduleTxt_Fld: FloatLabelTextField!
    @IBOutlet weak var switchBtnAllDays: UISwitch!
    @IBOutlet weak var dropDownAllDaysBtn: UIButton!
    @IBOutlet weak var emailtextSend: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var allDayLbl: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var mailPerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view_Hieght: NSLayoutConstraint!
    @IBOutlet weak var BtnLatlng: UIButton!
    @IBOutlet weak var txtSuggetionField: UITextField!
    @IBOutlet weak var contrectTxtFldLbl: UILabel!
    @IBOutlet weak var contrectTxtFld_Hight: NSLayoutConstraint!
    @IBOutlet weak var lblHideRecur: UILabel!
    @IBOutlet weak var recurCollectView: UICollectionView!
    @IBOutlet weak var btnRecurJobAdd: UIButton!
    @IBOutlet weak var lblRecurCreation: UILabel!
    @IBOutlet weak var btnEndDateShow: UIButton!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblRecurEndDate: UILabel!
    @IBOutlet weak var recurViewHieght: NSLayoutConstraint!
    @IBOutlet weak var btnCustomRecur: UIButton!
    @IBOutlet weak var lblCustomShow: UILabel!
    @IBOutlet weak var lblDateOn: UILabel!
    @IBOutlet weak var btnDateOn: UIButton!
    @IBOutlet weak var recurView: UIView!
    @IBOutlet weak var checkMrkBtn_H: NSLayoutConstraint!
    @IBOutlet weak var btnCustoM_H: NSLayoutConstraint!
    @IBOutlet weak var recurSuperView: UIView!
    @IBOutlet weak var recurMsgView: UIView!
    @IBOutlet weak var recurMsgHieght: NSLayoutConstraint!
    @IBOutlet weak var lblmsgDontWork: UILabel!
    @IBOutlet weak var btnNormalRecur: UIButton!
    @IBOutlet weak var lblCustom: UILabel!
    @IBOutlet weak var lblWeekly: UILabel!
    @IBOutlet weak var lblMsgCustom: UILabel!
    @IBOutlet weak var customField_Tbl: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var H_JobDes: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var contrectTxtFld: FloatLabelTextField!
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
    @IBOutlet weak var txtfld_PoNumber: FloatLabelTextField!
    @IBOutlet weak var txtfld_AllDays: UITextField!
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
    @IBOutlet var tagVw_OFTag: ASJTagsView!
    @IBOutlet weak var H_landmark: NSLayoutConstraint!
    @IBOutlet var lbl_AssignTo: UILabel!
    @IBOutlet var btnClient: UIButton!
    @IBOutlet var btnSitName: UIButton!
    @IBOutlet var btnContact: UIButton!
    @IBOutlet weak var attachImgBtn: UIButton!
    
    var FltWorkerId = [String]()
    var ContractArray = [ContractListData]()
    var recuDataJsonString:String = ""
    var responceaddjob = dataDetail()
    var txtFieldData : String?
    var arrOfShowDatas : GetDetail?
    var selectedTxtField : UITextField?
    var sltQuestNo : String?
    var arrOfShowData11 = [CustomFormDetals]()
    var customVCArr = [CustomDataRes]()
    var poIdVelue = ""
    var poIdBool:Bool = false
    var appoinmentDate:Bool = false
    var ArryUserLeave = [ShiftList]()
    var confirmationTriggerArray = [String]()
    var emailSendStatus = ""
    var emailpermision:Bool = false
    var discpFirstTittle:Bool = false
    var arrOfServicSuggestion = [UserJobTittleNm]()
    var arrOfsuggetionItem = [suggestionListData]()
    var userJobTittleNmRef : UserJobTittleNm?
    var arrOfSuggest = [suggestionListData]()
    var arrOfJtId = [String]()
    var images = [UIImage]()
    var imgArr = [ImageModel]()
    var stringToHtml = ""
    var stringToHtmlOnlyText = ""
    var imagePicker = UIImagePickerController()
    var txtViewData : String?
    var userName : String?
    var cntry = ""
    var states = ""
    var clientSelf = false
    var aadAppId : String?
    var appoinmnrA : CommanListDataModel?
    var PurchaseOrderArrList = [PurchaseOrderList]()
    var PurchaseOrder = [PurchaseOrderList]()
    var eqDetail  = false
    var aadEqId : String?
    var eqpmtArr : equipDataArray?
    var parmnew = false
    var optionalVw : OptionalView?
    var isOpenOptionalView = false
    let arrOfPriroty = ["Low" , "Medium" , "High"]
    var arrClintList = [ClientList]()
    var FltArrClintList = [ClientList]()
    var FltContractListt = [ContractList]()
    var arrContractList = [ContractList]()
    var arrOffldWrkData = [FieldWorkerDetails]()
    var FltArrOffldWrkData = [FieldWorkerDetails]()
    var arrOfShowData = [Any]()
    var arra = [UserJobTittleNm]()
    var searcharraisbol = false
    var searcharra = [Any]()
    var arrOfaddTags = [[String : String]]()
    var contryCode = ""
    var DictGlob:[[String:String]] = []
    var sltDropDownBtnTag : Int!
    var sltTxtField = UITextField()
    var isarrOfShowData11 = false
    let cellReuseIdentifier = "cell"
    let param = Params()
    var isClintFutUser  = false
    var isSitFutUser  = false
    var isContactFutUser  = false
    var isClear  = false
    var callbackForJobVC: ((Bool) -> Void)?
    var isdidSelect : Bool!
    var ArrContrect = [ContractList]()
    var UserLeave = [getUserLeaveData]()
    var selectedRows:[Int] = []
    var isChecked = false
    var arrDaysCount = [Any]()
    var buttonSwitched : Bool = false
    var addRecur : AddRecurVC?
    var recurMode = "2"
    var isStartScheduleBtn = false
    var isRecureDate = false
    var daysDic = [String:Any]()
    var isBoolRecurArr = [Bool]()
    var recurDatastring:String = ""
    var recurTyp:String = ""
    var recurMassege:String = ""
    var daiyType = ""
    var monthlyType = ""
    var weeklyType = ""
    var recurDay = ""
    
    var dispatchStatus = ""
    
    struct WeekDay {
        let title: String
        var isSelected = false
        var id:String
    }
    
    let weekdays = [
        WeekDay(title: "M", isSelected: false,id: "1"),
        WeekDay(title: "T", isSelected: false,id: "2"),
        WeekDay(title: "W", isSelected: false,id: "3"),
        WeekDay(title: "T", isSelected: false,id: "4"),
        WeekDay(title: "F", isSelected: false,id: "5"),
        WeekDay(title: "S", isSelected: false,id: "6"),
        WeekDay(title: "S", isSelected: false,id: "7")
    ]
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else { return }
        
        DispatchQueue.main.async {
            self.removeOptionalView()
        }
    }
    
      
      var arrItemListOnline1GetJobTittle = [SiteVCRespDetails]()
      var searchkryGetJobTittle:Bool = false
      var countGetJobTittle : Int = 0
      var addcountGetJobTittle : Int = 0
      var globelGetJobTittle :Int = 0
      var searchInventroryCountGetJobTittle : Int = 0
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.checkBtnDispatch.isUserInteractionEnabled = false
        if let dispatch = getDefaultSettings()?.isJobCrteWthDispatch {
            
            if dispatch == "0"{
                
                checkBtnDispatch.setImage(UIImage(named: "unchecked24"), for: .normal)
                self.dispatchStatus = "13"
            }
            else
            {
                checkBtnDispatch.setImage(UIImage(named: "checked24"), for: .normal)
                self.dispatchStatus = "1"
            }
        }
        
        
        if let enableCustomForm = getDefaultSettings()?.isCustomFieldEnable{
            if enableCustomForm == "0"{
              
               // self.view_Hieght.constant = 1850
            }else{
               
                
                if let isAddJobRecurEnable = getDefaultSettings()?.isAddJobCustomFieldEnable{
                    if isAddJobRecurEnable == "0"{
                       
                      //  self.view_Hieght.constant = 1850
                    }else{
                      //  self.view_Hieght.constant = 2762
                        
                    }
                }
            }
        }
        
        if let isScheduleTextEnable = getDefaultSettings()?.isScheduleTextEnable{
            if isScheduleTextEnable == "0"{
                self.schedularLbl.isHidden = true
                self.schedulerTxtFld_H.constant = 0
                self.shedular_topLbl.constant = shedular_topLbl.constant - 60
                self.shedulrStrtDate_topVw.constant = shedulrStrtDate_topVw.constant - 60
               
            }else{
                self.schedularLbl.isHidden = false
                self.schedulerTxtFld_H.constant = 50
                
            }
       
    }
       
        self.switchBtnAllDays.isHidden = true
        self.dropDownAllDaysBtn.isHidden = true
        getUserLeaveList()
        self.switchBtnAllDays.isOn = false
      
       
        backgroundView.isHidden = true
        if let cntryCode = getDefaultSettings()?.ctryCode
        {
            contryCode = cntryCode
            txtfld_MobNo.text = contryCode
            txtfld_MobNo.textColor = UIColor.lightGray
            
            txtfld_AltMobNo.text = contryCode
            txtfld_AltMobNo.textColor = UIColor.lightGray
            
        }
        
        if isPermitForShow(permission: permissions.isRecur) == false {
            
              self.lblHideRecur.isHidden = true
              self.checkMrkBtn_H.constant = 0
              self.btnCustoM_H.constant = 0
              self.btnRecurJobAdd.isHidden = true
              self.lblRecurCreation.isHidden = true
              self.btnCustomRecur.isHidden = true
              self.lblCustomShow.isHidden = true
            
        }else{
            if let isAddJobRecurEnable = getDefaultSettings()?.isAddJobRecurEnable{ //This is round off digit for invoice
                if isAddJobRecurEnable == "0"{
                   
                    self.lblHideRecur.isHidden = true
                    self.checkMrkBtn_H.constant = 0
                    self.btnCustoM_H.constant = 0
                    self.top_Constrnt_recerVw.constant = -25
                    self.btnRecurJobAdd.isHidden = true
                    self.lblRecurCreation.isHidden = true
                    self.btnCustomRecur.isHidden = true
                    self.lblCustomShow.isHidden = true
                }else{
                    self.lblHideRecur.isHidden = false
                    self.checkMrkBtn_H.constant = 25
                    self.btnCustoM_H.constant = 25
                    self.btnRecurJobAdd.isHidden = false
                    self.lblRecurCreation.isHidden = false
                    self.btnCustomRecur.isHidden = false
                    self.lblCustomShow.isHidden = false
                    
                }
            }
        }
        
        btnRecurJobAdd.setImage(UIImage(named: "unchecked24"), for: .normal)
        recurView.isHidden = true
        recurViewHieght.constant = 0
        btnEndDateShow.setImage(UIImage(named:"radio_unselected"), for: .normal)
      
        if arrOfShowData11.count > 0 {
            
            self.isarrOfShowData11 == true
        }
        
        recurMsgHieght.constant = 0
        recurSuperView.isHidden = true
        getFormDetail()
        textView.delegate = self
        textView.text = LanguageKey.job_desc
        textView.textColor = UIColor.lightGray
        self.txtfld_Contact.isUserInteractionEnabled = false
        
        if eqDetail == true{
            
//            self.txtfld_MobNo.text = self.eqpmtArr?.mno
//            self.txtfld_AltMobNo.text = self.appoinmnrA?.mob2
//            self.txtfld_Email.text = self.appoinmnrA?.email
//            self.txtfld_City.text = appoinmnrA?.city
//            //  self.txtfld_Country.text = self.appoinmnrA?.adr
//            //  self.txtfld_State.text = self.appoinmnrA?.state
//            self.txtfld_Address.text = self.appoinmnrA?.adr
//            param.cltId = param.cltId == nil ?  "" : appoinmnrA?.cltId  // param.cltId == nil ?  "" : param.cltId
//            param.conId = param.conId == nil ?  "" : param.conId// == nil ? "" :  param.conId
//            self.txtfld_Client.text = self.userName
//            self.txtfld_Client.isUserInteractionEnabled = false
        }
        
        
        if parmnew == true{
            self.txtfld_MobNo.text = self.appoinmnrA?.mob1
            self.txtfld_AltMobNo.text = self.appoinmnrA?.mob2
            self.txtfld_Email.text = self.appoinmnrA?.email
            self.txtfld_City.text = appoinmnrA?.city
            self.txtfld_Address.text = self.appoinmnrA?.adr
            param.cltId = param.cltId == nil ?  "" : appoinmnrA?.cltId  // param.cltId == nil ?  "" : param.cltId
            param.conId = param.conId == nil ?  "" : appoinmnrA?.conId// == nil ? "" :  param.conId
            self.txtfld_Client.text = self.userName
            self.textView.text = self.appoinmnrA?.des
                      self.stringToHtml = self.textView.text
                     
                      DispatchQueue.global(qos: .background).async {
                          
                          DispatchQueue.global(qos: .background).async {
                              let htmlString = self.appoinmnrA?.des
                              let attributedString = htmlString!.htmlToAttributedString
                              DispatchQueue.main.async {
                                  self.textView.attributedText = attributedString
                                  killLoader()
                                  print("Successfully converted string to HTML")
                              }
                          }
                         
                      }
            
            self.txtfld_Client.isUserInteractionEnabled = false
            
            
        }
        arra = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
        self.searchDropDwnView.isHidden = true
        self.searchBackBtn.isHidden = true
        self.setUpMethod()
        LocationManager.shared.startTracking()
        IQKeyboardManager.shared.enable = false
        self.registorKeyboardNotification()
        self.getClintListFrmDB()
        getJobTittle()
        //getFieldWorkerList()
        //getTagListService()
        contractSynch()
       // getClientSink()
       // getClientSiteSink()
       // getClientContactSink()
        
        if let langCode = getCurrentSelectedLanguageCode() {
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                      if enableCustomForm == "0"{
                        dateAndTimePicker.locale = Locale.init(identifier: "en_US")
                      }else{
                        dateAndTimePicker.locale = Locale.init(identifier: "en_gb")
                      }
                  }
            
           //dateAndTimePicker.locale = Locale(identifier: langCode)
        }
        
        DispatchQueue.main.async {
            self.createTags(strName: (getUserDetails()?.fnm)!, view: self.tagView)
        }
        
        
        self.FltWorkerId.append((getUserDetails()?.usrId)!)
        
        setLocalization()
        
        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobsAdd)
        
        
        /////////////////////////CONTRECT TXTFIELDSHOW/HIDE/////////////////////////////////////
        self.contrectTxtFld_Hight.constant = 0
        self.contrectTxtFldLbl.isHidden = true
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        PurchaseOrderArrList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "PurchaseOrderList", query: nil) as! [PurchaseOrderList]
        getAllCompanySettings()
        
    }
    
    //================================
    //  MARK: showing And Hiding Background
    //================================
    
    func showBackgroundView() {
        backgroundView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.backgroundColor = UIColor.black
            self.backgroundView.alpha = 0.5
        })
    }
    
    func hideBackgroundView() {
        
        if ((optionalVw) != nil){
            removeOptionalView()
        }
        
        if (mailPerView != nil) {
            mailPerView.removeFromSuperview()
        }
        
        
        self.backgroundView.isHidden = true
        self.backgroundView.backgroundColor = UIColor.clear
        self.backgroundView.alpha = 1
    }
    
    func dailyRecurData(recurData: String?, recurType: String?, recurMsg: String?, daily: String) {
        recurDatastring = recurData!
        recurTyp = recurType!
        recurMassege = recurMsg!
        daiyType = daily
        
    }
    func monthlyRecurData(recurData: String?, recurType: String?, recurMsg: String?, monthly: String) {
        recurDatastring = recurData ?? ""
        recurTyp = recurType ?? ""
        recurMassege = recurMsg ?? ""
        monthlyType = monthly
    }
    func weeklyRecurData(recurData: String?, recurType: String?, recurMsg: String?, weekly: String, recurDays: String?) {
        recurDatastring = recurData ?? ""
        recurTyp = recurType ?? ""
        recurMassege = recurMsg ?? ""
        weeklyType = weekly
        recurDay = recurDays ?? ""
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.title_add_job
        taxFieldAddTags.placeholder = LanguageKey.add_tag
        txtfld_FieldWorker.placeholder = LanguageKey.add_fieldworker
        txtfld_Contact.placeholder = LanguageKey.contact_name
        txtfld_Email.placeholder = LanguageKey.email
        txtfld_MobNo.placeholder = LanguageKey.mob_no
        txtfld_AltMobNo.placeholder = LanguageKey.alt_mobile_number
        txtfldJobTitle.placeholder = "\(LanguageKey.Job_title) *"
        txtfld_JobInstruction.placeholder = LanguageKey.job_inst
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
        dispatchLbl.text = LanguageKey.dispatch
        allDayLbl.text = LanguageKey.all_day_leave
        lblAddTags.text = LanguageKey.tags
        btnDonebgView.setTitle(LanguageKey.done , for: .normal)
        btnCancelbgView.setTitle(LanguageKey.cancel , for: .normal)
        btnSubmit.setTitle(LanguageKey.create_job , for: .normal)
        btnAdd.setTitle(LanguageKey.add , for: .normal)
        btnClear.setTitle(LanguageKey.clear , for: .normal)
        btnClient.setTitle(LanguageKey.save_for_future_use , for: .normal)
        btnContact.setTitle(LanguageKey.add , for: .normal)
        btnSitName.setTitle(LanguageKey.add_new_site , for: .normal)
        txtfld_JobPriority.placeholder = LanguageKey.job_priority
        txt_landmark.placeholder = LanguageKey.landmark_addjob
        txtfld_PoNumber.placeholder = LanguageKey.po_number
        lblDateOn.text = LanguageKey.radio_end_by
        lblEndDate.text = LanguageKey.never_end
        lblRecurCreation.text = LanguageKey.add_rucr_for_job
        lblCustomShow.text = LanguageKey.dont_create_recur
        btnCustomRecur.setTitle(LanguageKey.custom_recur_pattern , for: .normal)
        btnNormalRecur.setTitle(LanguageKey.normal_recur , for: .normal)
        BtnLatlng.setTitle(LanguageKey.get_current_lat_long , for: .normal)
        emailtextSend.text = LanguageKey.send_client_mail
        yesBtn.setTitle(LanguageKey.yes , for: .normal)
        noBtn.setTitle(LanguageKey.no , for: .normal)
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let vc = segue.destination as? AddRecurVC {
            vc.addJobDate = lbl_SrtSchDate.text!
            vc.delegateDailyRecur = self
            vc.delegateMonthlyRecur = self
            vc.delegateWeeklyRecur = self
            
        }

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? AddRecurVC {
//            vc.addJobDate = lbl_SrtSchDate.text!
//        }
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if daiyType == "1" {
            btnRecurJobAdd.setImage(UIImage(named: "checked24"), for: .normal)
            self.lblWeekly.text = "Daily"
            self.recurMsgHieght.constant = 106
            self.recurSuperView.isHidden = false
            recurView.isHidden = true
            recurViewHieght.constant = 93
            self.btnCustomRecur.isHidden = true
            
        }else if weeklyType == "2"{
            btnRecurJobAdd.setImage(UIImage(named: "checked24"), for: .normal)
            self.lblWeekly.text = "Weekly"
            self.recurMsgHieght.constant = 106
            self.recurSuperView.isHidden = false
            self.lblMsgCustom.text! = recurMassege
            recurView.isHidden = true
            recurViewHieght.constant = 93
            self.btnCustomRecur.isHidden = true
        }else if monthlyType == "3"{
            btnRecurJobAdd.setImage(UIImage(named: "checked24"), for: .normal)
            self.lblWeekly.text = "Monthly"
            self.recurMsgHieght.constant = 106
            self.recurSuperView.isHidden = false
            self.lblMsgCustom.text! = recurMassege
            recurView.isHidden = true
            recurViewHieght.constant = 93
            self.btnCustomRecur.isHidden = true
        }
        
        if arrOfShowData11.count > 0{
                   //view_Hieght.constant = 1550
               }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
        self.removeKeyboardNotification()
    }
    
    
    
    // textview delegate here .....
   
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == LanguageKey.job_desc {
                     textView.text = nil
                     textView.textColor = UIColor.lightGray
                 }
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.lightGray
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if arrOfShowData11.count > 0 {
        let customFormDetals = arrOfShowData11[textView.tag]
        let opt = OptDetals(key: "0", questions: nil, value: textView.text, optHaveChild: nil)
        let layer = String(format: "%d.1", (textView.tag + 1))
        self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals as! CustomFormDetals)
        }
        if textView.text.isEmpty {
            textView.text = LanguageKey.job_desc
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    
    //==============================
    // MARK:- Recur functionality
    //==============================
    // this functionality emplimented by Dharmendra for Recur
    @IBAction func btnShowRecur(_ sender: Any) {
       
       // if isPermitForShow(permission: permissions.isRecur) == false{
            
        self.buttonSwitched = !self.buttonSwitched
        
        if self.buttonSwitched
        {
            btnRecurJobAdd.setImage(UIImage(named: "unchecked24"), for: .normal)
            recurView.isHidden = true
            recurViewHieght.constant = 0
            recurMsgHieght.constant = 0
            recurSuperView.isHidden = true
            self.btnCustomRecur.isHidden = false
        }
        else
        {
            btnRecurJobAdd.setImage(UIImage(named: "checked24"), for: .normal)
            recurView.isHidden = false
            recurViewHieght.constant = 93
            recurMsgHieght.constant = 0
            recurSuperView.isHidden = true
            self.btnCustomRecur.isHidden = false
        }
          //  }
       
    }
    
    @IBAction func btnEndDateRadio(_ sender: Any) {
        btnDateOn.setImage(UIImage(named:"radio_unselected"), for: .normal)
        btnEndDateShow.setImage(UIImage(named:"radio-selected"), for: .normal)
        recurMode = "0"
        
    }
    
    @IBAction func btnShowEndDate(_ sender: Any) {
        self.bgViewOfPicker.isHidden = false
        isRecureDate = true
        self.showDateAndTimePicker()
    }
    
    @IBAction func btnCustomRecur(_ sender: Any) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddRecurVC")as? AddRecurVC {
//
//            //callBack block will execute when user back from SecondViewController.
//            vc.addJobDate = lbl_SrtSchDate.text!
//
//            vc.callBack = {(daily: Bool,weekly: Bool,monthly: Bool) in
//                print(daily,weekly,monthly)
//                if daily == true {
//                    self.lblWeekly.text = "Daily"
//                    self.recurMsgHieght.constant = 106
//                    self.recurSuperView.isHidden = false
//
//                } else if weekly == true {
//                    self.lblWeekly.text = "Weekly"
//                    self.recurMsgHieght.constant = 106
//                    self.recurSuperView.isHidden = false
//                } else if monthly == true {
//                    self.lblWeekly.text = "Monthly"
//                    self.recurMsgHieght.constant = 106
//                    self.recurSuperView.isHidden = false
//                }
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    
    @IBAction func btnDateOn(_ sender: Any) {
        btnEndDateShow.setImage(UIImage(named:"radio_unselected"), for: .normal)
        btnDateOn.setImage(UIImage(named:"radio-selected"), for: .normal)
        recurMode = "2"
        
    }
    
    //=====================================================//
    
    
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
    
    @IBAction func switchBtnAllDays(_ sender: Any) {
        
        self.buttonSwitched = !self.buttonSwitched
        
        if self.buttonSwitched
        {
           
            
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
                         lbl_SrtSchDate.text = arr[0]
                       //  lbl_SrtSchTime.text = arr[1]
                         lbl_EndSchDate.text = arr[0]
                     }else{
                         lbl_SrtSchDate.text = arr[0]
                        // lbl_SrtSchTime.text = arr[1] + " " + arr[2]
                         lbl_EndSchDate.text = arr[0]
                     }
                     
                     let arrOfEndDate = strDate.1.components(separatedBy: " ")
                     if arrOfEndDate.count == 2 {
                         lbl_EndSchDate.text = arrOfEndDate[0]
                        // lbl_EndSchTime.text = arrOfEndDate[1]
                     }else{
                         lbl_EndSchDate.text = arrOfEndDate[0]
                       //  lbl_EndSchTime.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
                     }
                      
                 }
            
           
            let dateAsString = self.ArryUserLeave[0].shiftStartTime
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            let date = dateFormatter.date(from: dateAsString!)
            dateFormatter.dateFormat = "h:mm a"
            let Date12 = dateFormatter.string(from: date!)
        
            let dateAsStEnd = self.ArryUserLeave[0].shiftEndTime
            let dateFormatterEnd = DateFormatter()
            dateFormatterEnd.dateFormat = "HH:mm"
            
            let date1 = dateFormatterEnd.date(from: dateAsStEnd!)
            dateFormatterEnd.dateFormat = "h:mm a"
            let Date11 = dateFormatter.string(from: date1!)
            
            
            var strtShedulTime = Date11
            var endShedulTime = Date12
            self.lbl_SrtSchTime.text = endShedulTime
            self.lbl_EndSchTime.text = strtShedulTime
           // print("SwitchBtnOn")
        }
        else
        {
            setUpMethod()
           // print("SwitchBtnOof")
        }
       
    }
    
   
    @IBAction func dispatchBtnActn(_ sender: Any) {
        
        self.buttonSwitched = !self.buttonSwitched
        
        if self.buttonSwitched
        {
            checkBtnDispatch.setImage(UIImage(named: "unchecked24"), for: .normal)
            self.dispatchStatus = "13"
        }
        else
        {
            self.dispatchStatus = "1"
            checkBtnDispatch.setImage(UIImage(named: "checked24"), for: .normal)
        }
    }
    
    func setUpMethod(){
        
        if getDefaultSettings()?.isJobLatLngEnable == "0" {
            H_lattitude.constant = 0.0
        }
        
        if getDefaultSettings()?.isLandmarkEnable == "0" {
            H_landmark.constant = 0.0
        }
        
        var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
        duration = updateDefaultTime(duration ?? "01:00")
        let arrOFDurationTime = duration?.components(separatedBy: ":")
       
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
                
                if appoinmentDate == true{
                    if  persimissionOn == "On"{
                        lbl_SrtSchDate.text = isdateFormt
                        lbl_SrtSchTime.text = arr[1]
                        lbl_EndSchDate.text = isdateFormt
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
                
            } else {
                
                var isdateFormt = ""
                isdateFormt =   UserDefaults.standard.value(forKey: "clickDate") as? String ?? ""
                var persimissionOn = ""
                persimissionOn =   UserDefaults.standard.value(forKey: "persimissionOn") as? String ?? ""
                
                if appoinmentDate == true{
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
                isdateFormt = UserDefaults.standard.value(forKey: "clickDate") as? String ?? ""
                var persimissionOn = ""
                persimissionOn =   UserDefaults.standard.value(forKey: "persimissionOn") as? String ?? ""
                
                if appoinmentDate == true{
                    
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
                isdateFormt = UserDefaults.standard.value(forKey: "clickDate") as? String ?? ""
                var persimissionOn = ""
                persimissionOn =   UserDefaults.standard.value(forKey: "persimissionOn") as? String ?? ""
                
                if appoinmentDate == true{
                    
                    if  persimissionOn == "On"{
                        lbl_EndSchDate.text = isdateFormt
                    }else{
                        lbl_EndSchDate.text = arrOfEndDate[0]
                    }
                    
                }else{
                    lbl_EndSchDate.text = arrOfEndDate[0]
                }
                
                lbl_EndSchTime.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
            }
            
        }else{
            let adminSchTime : String? = getDefaultSettings()?.jobSchedule
            if(adminSchTime != "" && adminSchTime != nil){
                
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
        
        if (isRecureDate == true){
            let arr = strDate.components(separatedBy: " ")
            if arr.count == 2 {
                lblRecurEndDate.text = arr[0]
            }else{
                lblRecurEndDate.text = arr[0]
                
            }
            
        } else if isStartScheduleBtn == true {
            
            
            let schStartDate = self.lbl_SrtSchDate.text! + " " + self.lbl_SrtSchTime.text!
            //getDefaultSettings()?.is24hrFormatEnable{
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{
                if enableCustomForm == "0"{
                          let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy)
                         if(value == "orderedAscending"){
                             ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                         }else{
                             let arr = strDate.components(separatedBy: " ")
                             
                             if arr.count == 2 {
                                 lbl_SrtSchDate.text = arr[0]
                                 lbl_SrtSchTime.text = arr[1]
                             }else{
                                 lbl_SrtSchDate.text = arr[0]
                                 lbl_SrtSchTime.text = arr[1] + " " + arr[2]
                             }
                         }
                }else{
                         let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy_HH_mm)
                         if(value == "orderedAscending"){
                             ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                         }else{
                             let arr = strDate.components(separatedBy: " ")
                             
                             if arr.count == 2 {
                                 lbl_SrtSchDate.text = arr[0]
                                 lbl_SrtSchTime.text = arr[1]
                             }else{
                                 lbl_SrtSchDate.text = arr[0]
                                 lbl_SrtSchTime.text = arr[1] + " " + arr[2]
                             }
                         }
                }
            }
            
            
            ///
//            let arr = strDate.components(separatedBy: " ")
//
//            if arr.count == 2 {
//                lbl_SrtSchDate.text = arr[0]
//                lbl_SrtSchTime.text = arr[1]
//            }else{
//                lbl_SrtSchDate.text = arr[0]
//                lbl_SrtSchTime.text = arr[1] + " " + arr[2]
//            }
          
        }else{
           
            let schStartDate = self.lbl_SrtSchDate.text! + " " + self.lbl_SrtSchTime.text!
            //getDefaultSettings()?.is24hrFormatEnable{
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{
                if enableCustomForm == "0"{
                          let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy)
                         if(value == "orderedDescending"){
                             ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
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
                             ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
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
 
    @IBAction func btnYesEmail(_ sender: Any) {
        
                self.emailSendStatus = "1"
                hideBackgroundView()
                let trimmClintNm  = trimString(string: self.txtfld_Client.text!)
                let trimmAdr = trimString(string: self.txtfld_Address.text!)
                let trimmMobNo = trimString(string: self.txtfld_MobNo.text!)
                let trimmAltMobNo = trimString(string: self.txtfld_AltMobNo.text!)
                let trimmEmail = trimString(string: self.txtfld_Email.text!)
                let trimmAltSite = trimString(string: self.txtfld_SiteName.text!)
                let trimmContact = trimString(string: self.txtfld_Contact.text!)
                
                let jobPrty = getPriortyRawValueAccordingToText(txt: (txtfld_JobPriority.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
                
                if trimmEmail.count > 0 {
                    if !isValidEmail(testStr: trimmEmail)  {
                        ShowError(message: AlertMessage.validEmailId, controller: windowController)
                        return
                    }
                }
  
                if(param.jtId != nil && param.jtId!.count > 0){
                    if(jobPrty != 0){
                        if (trimmClintNm != ""){
        //                    if (trimmContact != ""){
        //                        if (trimmAltSite != ""){
                                    if(trimmAdr != ""){
                                        if(param.ctry != nil) && (param.ctry != ""){
                                            if(param.state != nil) && (param.state != ""){
                                                // self.addJob()
                                                
                                                if !isHaveNetowork() {
                                                    if imgArr.count > 0 {
                                                        
                                                        ShowError(message: LanguageKey.offline_feature_alert, controller: windowController)
                                                        
                                                    }else{

                                                        self.addJob()
                                                    }
                                                }else{
                                                   
                                                    addJobOnlineWithAttechment()
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
        //                        } else {
        //                            ShowError(message: "Please enter Site", controller: windowController)
        //                        }
        //                    } else {
        //                        ShowError(message: "Please enter Contact", controller: windowController)
        //                    }
                        } else {
                            ShowError(message: AlertMessage.clientName, controller: windowController)
                        }
                    }else{
                        ShowError(message: AlertMessage.jobPriority, controller: windowController)
                    }
                }else{
                    ShowError(message: AlertMessage.err_job_title, controller: windowController)
                }
        
        
    }
    
    @IBAction func btnNoEmail(_ sender: Any) {
        self.emailSendStatus = "0"
         hideBackgroundView()
        
         
                let trimmClintNm  = trimString(string: self.txtfld_Client.text!)
                let trimmAdr = trimString(string: self.txtfld_Address.text!)
                let trimmMobNo = trimString(string: self.txtfld_MobNo.text!)
                let trimmAltMobNo = trimString(string: self.txtfld_AltMobNo.text!)
                let trimmEmail = trimString(string: self.txtfld_Email.text!)
                let trimmAltSite = trimString(string: self.txtfld_SiteName.text!)
                let trimmContact = trimString(string: self.txtfld_Contact.text!)
                
                let jobPrty = getPriortyRawValueAccordingToText(txt: (txtfld_JobPriority.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
                
                if trimmEmail.count > 0 {
                    if !isValidEmail(testStr: trimmEmail)  {
                        ShowError(message: AlertMessage.validEmailId, controller: windowController)
                        return
                    }
                }
                
                
//                if (trimmMobNo.count > 0) && (trimmMobNo.count < 8) {
//                    ShowError(message: AlertMessage.validMobile, controller: windowController)
//                    return
//                }
//
//
//                if trimmAltMobNo.count > 0 && trimmAltMobNo.count < 8  {
//                    ShowError(message: AlertMessage.validAlMobileNo, controller: windowController)
//                    return
//                }
                
                
                if(param.jtId != nil && param.jtId!.count > 0){
                    if(jobPrty != 0){
                        if (trimmClintNm != ""){
        //                    if (trimmContact != ""){
        //                        if (trimmAltSite != ""){
                                    if(trimmAdr != ""){
                                        if(param.ctry != nil) && (param.ctry != ""){
                                            if(param.state != nil) && (param.state != ""){
                                                // self.addJob()
                                                
                                                if !isHaveNetowork() {
                                                    if imgArr.count > 0 {
                                                        
                                                        ShowError(message: LanguageKey.offline_feature_alert, controller: windowController)
                                                        
                                                    }else{
                                                        
//                                                        showBackgroundView()
//                                                        view.addSubview(mailPerView)
//                                                        mailPerView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
                                                        self.addJob()
                                                    }
                                                }else{
                                                    
//                                                    showBackgroundView()
//                                                    view.addSubview(mailPerView)
//                                                    mailPerView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
                                                    
                                                    addJobOnlineWithAttechment()
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
        //                        } else {
        //                            ShowError(message: "Please enter Site", controller: windowController)
        //                        }
        //                    } else {
        //                        ShowError(message: "Please enter Contact", controller: windowController)
        //                    }
                        } else {
                            ShowError(message: AlertMessage.clientName, controller: windowController)
                        }
                    }else{
                        ShowError(message: AlertMessage.jobPriority, controller: windowController)
                    }
                }else{
                    ShowError(message: AlertMessage.err_job_title, controller: windowController)
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
        
        if emailpermision == true {
            
            showBackgroundView()
            view.addSubview(mailPerView)
            mailPerView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
        }else{
            
            
            let trimmClintNm  = trimString(string: self.txtfld_Client.text!)
            let trimmAdr = trimString(string: self.txtfld_Address.text!)
            let trimmMobNo = trimString(string: self.txtfld_MobNo.text!)
            let trimmAltMobNo = trimString(string: self.txtfld_AltMobNo.text!)
            let trimmEmail = trimString(string: self.txtfld_Email.text!)
            let trimmAltSite = trimString(string: self.txtfld_SiteName.text!)
            let trimmContact = trimString(string: self.txtfld_Contact.text!)
            
            let jobPrty = getPriortyRawValueAccordingToText(txt: (txtfld_JobPriority.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
            
            if trimmEmail.count > 0 {
                if !isValidEmail(testStr: trimmEmail)  {
                    ShowError(message: AlertMessage.validEmailId, controller: windowController)
                    return
                }
            }
            
            
//            if (trimmMobNo.count > 0) && (trimmMobNo.count < 8) {
//                ShowError(message: AlertMessage.validMobile, controller: windowController)
//                return
//            }
//            
//            
//            if trimmAltMobNo.count > 0 && trimmAltMobNo.count < 8  {
//                ShowError(message: AlertMessage.validAlMobileNo, controller: windowController)
//                return
//            }
            
            
            if(param.jtId != nil && param.jtId!.count > 0){
                if(jobPrty != 0){
                    if (trimmClintNm != ""){
                        //                    if (trimmContact != ""){
                        //                        if (trimmAltSite != ""){
                        if(trimmAdr != ""){
                            if(param.ctry != nil) && (param.ctry != ""){
                                if(param.state != nil) && (param.state != ""){
                                    // self.addJob()
                                    
                                    if !isHaveNetowork() {
                                        if imgArr.count > 0 {
                                            
                                            ShowError(message: LanguageKey.offline_feature_alert, controller: windowController)
                                            
                                        }else{
                                            
                                            //                                                        showBackgroundView()
                                            //                                                        view.addSubview(mailPerView)
                                            //                                                        mailPerView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
                                            self.addJob()
                                        }
                                    }else{
                                        
                                        //                                                    showBackgroundView()
                                        //                                                    view.addSubview(mailPerView)
                                        //                                                    mailPerView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
                                        
                                        addJobOnlineWithAttechment()
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
                        //                        } else {
                        //                            ShowError(message: "Please enter Site", controller: windowController)
                        //                        }
                        //                    } else {
                        //                        ShowError(message: "Please enter Contact", controller: windowController)
                        //                    }
                    } else {
                        ShowError(message: AlertMessage.clientName, controller: windowController)
                    }
                }else{
                    ShowError(message: AlertMessage.jobPriority, controller: windowController)
                }
            }else{
                ShowError(message: AlertMessage.err_job_title, controller: windowController)
            }
            
        }
        
    }
    
    
    @IBAction func btnNormalRecPattern(_ sender: Any) {
        self.recurSuperView.isHidden = true
        recurView.isHidden = false
        recurViewHieght.constant = 93
        self.btnCustomRecur.isHidden = false
    }
    
    @IBAction func btnActionMethod(_ sender: UIButton) {
        self.sltDropDownBtnTag  = sender.tag
        self.callMethodforOpenDwop(tag: sender.tag)
        
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
            
   
            self.searchDropDwnView.isHidden = false
            self.searchBackBtn.isHidden = false
            self.searchTxtFld.text = ""
            searcharraisbol = false
         
            
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
                self.btnContact.isHidden = true
                self.txtfld_Contact.text = ""
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
                self.btnSitName.isHidden = true
                self.txtfld_SiteName.text = ""
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
                if(btnSitName.imageView?.image == UIImage(named: "")){
                    self.btnSitName.setImage(UIImage(named: ""), for: .normal)
                    self.btnSitName.isHidden = true
                    self.isSitFutUser = true
                    self.txtfld_SiteName.text = ""
                }else{
                    self.btnSitName.setImage(UIImage(named: ""), for: .normal)
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
     
            
        case 10 :
            
            if(self.optionalVw == nil){
                
                if(arrOfSuggest.count > 0){
                    self.openDwopDown(txtField: self.txtSuggetionField, arr: self.arrOfSuggest)
                }else{
                   
                }
            }else{
                self.removeOptionalView()
                
            }
            
        case 11 :
            
            if(self.optionalVw == nil){
                
                if(UserLeave.count > 0){
                    self.openDwopDown(txtField: self.txtfld_AllDays, arr: self.UserLeave)
                }else{
                    
                }
            }else{
                self.removeOptionalView()
                
            }
            
        case 12 :
            
            if(self.optionalVw == nil){
                self.arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "PurchaseOrderList", query: nil) as! [PurchaseOrderList]
                if(arrOfShowData.count > 0){
                    self.openDwopDown(txtField: self.txtfld_PoNumber, arr: self.arrOfShowData)
                }
                //                else{
                //                    ShowError(message: AlertMessage.noFieldWorkerAvailable , controller: windowController)
                //                }
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
        case 10:
            return  arrOfSuggest
        case 11:
            return  ArryUserLeave
        case 12 :
            return  PurchaseOrder
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
            //=
            //var parm = []
            //var parm = param
           var arr = (self.arrOfShowData[indexPath.row] as? TagsList)?.tagId?.capitalizingFirstLetter()
            
//            _ =   arry.tagId.contains{ ( arry : AudTagData) -> Bool in
//                if arry.arr == arr?.tagId{
//                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
//                    return true
//                }else{
//                    cell?.accessoryType = UITableViewCell.AccessoryType.none
//                    return false
//                }
//            }
            
//            if let idS = param.tagId {
//                if (idS.contains("\(arr)")) {
//                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
//                    //return true
//                }else{
//                    cell?.accessoryType = UITableViewCell.AccessoryType.none
//                    //return false
//                }
//            }
        
            //=
            cell?.textLabel?.text = (self.arrOfShowData[indexPath.row] as? TagsList)?.tnm?.capitalizingFirstLetter()
            break
        case 9:
            let cltAllSiteList  =  ArrContrect[indexPath.row].nm //arrOfShowData[indexPath.row] as? ContractList
            cell?.textLabel?.text = cltAllSiteList?.capitalizingFirstLetter()
            
            break
            
        case 10:
            
            cell?.textLabel?.text = (self.arrOfSuggest[indexPath.row] as? suggestionListData)?.jtDesSugg?.capitalizingFirstLetter()
            
            break
        case 11:
            
            cell?.textLabel?.text = self.ArryUserLeave[indexPath.row].shiftNm
            
            break
            
        case 12:
            
            cell?.textLabel?.text = self.PurchaseOrder[indexPath.row].poNum
            
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
            //self.btnClient.isHidden = false
            self.btnClient.isHidden = true
            self.btnSitName.isHidden = false
            self.txtfld_SiteName.isUserInteractionEnabled = true
            self.txtfld_Contact.isUserInteractionEnabled = true
            
           // let query = "cltId = '\(objOfArr.cltId!)' AND def = '1'"
            
            //For Contact
            
            let query = "cltId = '\(String(describing: objOfArr.cltId ?? ""))'"
               //let isExistSite = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: queryOFSiteAndContact) as! [ClientSitList]
            
            
            let arrOfContNm = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList] //ClientContactList
            if(arrOfContNm.count > 0){
                let contact = arrOfContNm[0]
                self.txtfld_Contact.text = contact.cnm
                param.conId = contact.conId
                //self.btnContact.setImage(UIImage(named: "arrowdown"), for: .normal)
                // self.btnContact.isHidden = false
                self.btnContact.isHidden = true
                
                if let cntryCode = getDefaultSettings()?.ctryCode
                {
                    contryCode = cntryCode
                    txtfld_MobNo.text = contryCode + contact.mob1!
                    txtfld_MobNo.textColor = UIColor.lightGray
                    
                    txtfld_AltMobNo.text = contryCode + contact.mob2!
                    txtfld_AltMobNo.textColor = UIColor.lightGray
                    
                }
              //  txtfld_MobNo.text = contact.mob1
               // txtfld_AltMobNo.text = contact.mob2
                txtfld_Email.text = contact.email
                
            }else{
                self.txtfld_Contact.text = ""
                param.conId = nil
                // self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                self.btnContact.isHidden = true
                if let cntryCode = getDefaultSettings()?.ctryCode
                {
                    contryCode = cntryCode
                    txtfld_MobNo.text = contryCode
                    txtfld_MobNo.textColor = UIColor.lightGray
                    
                    txtfld_AltMobNo.text = contryCode 
                    txtfld_AltMobNo.textColor = UIColor.lightGray
                    
                }
//                txtfld_MobNo.text = ""
//                txtfld_AltMobNo.text = ""
                txtfld_Email.text = ""
            }
            
            //For Site
            let arrOfSiteNm = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
            if(arrOfSiteNm.count > 0){
                let site = arrOfSiteNm[0]
                self.txtfld_SiteName.text = site.snm
                param.siteId = site.siteId
                //                   self.btnSitName.setImage(UIImage(named: "arrowdown"), for: .normal)
                self.btnContact.isHidden = false
                self.btnSitName.isHidden = false
                
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
                cntry = param.ctry!
                states = param.state!
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
            states = ((arrOfShowData[indexPath.row] as? [String : Any])?["id"] as? String)!
            self.removeOptionalView()
            break
        case 6: // For Country
            self.txtfld_Country.text = (arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String
            let countryID = (arrOfShowData[indexPath.row] as? [String : Any])?["id"] as? String
            param.ctry = countryID
            cntry = countryID!
            
            let idPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", countryID! )
            let arrOfstate =  getStates().filtered(using: idPredicate)
            self.txtfld_State.text = (arrOfstate[0] as? [String : Any])?["name"] as? String
            param.state = (arrOfstate[0] as? [String : Any])?["id"] as? String
            states = ((arrOfstate[0] as? [String : Any])?["id"] as? String)!
           
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
            
            break
            
            case 10:
                if discpFirstTittle == false {
                     self.textView.text = ""
                      discpFirstTittle = true
                }
                
                   self.textView.text += "\(arrOfSuggest[indexPath.row].jtDesSugg ?? "")\n"
                break
            
        case 11:
       
            
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
                    lbl_SrtSchDate.text = arr[0]
                    //  lbl_SrtSchTime.text = arr[1]
                    lbl_EndSchDate.text = arr[0]
                }else{
                    lbl_SrtSchDate.text = arr[0]
                    // lbl_SrtSchTime.text = arr[1] + " " + arr
                    lbl_EndSchDate.text = arr[0]
                }
                
                let arrOfEndDate = strDate.1.components(separatedBy: " ")
                if arrOfEndDate.count == 2 {
                    lbl_EndSchDate.text = arrOfEndDate[0]
                    // lbl_EndSchTime.text = arrOfEndDate[1]
                }else{
                    lbl_EndSchDate.text = arrOfEndDate[0]
                    //  lbl_EndSchTime.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
                }
                
            }
          
            
            var st = "\(ArryUserLeave[indexPath.row].shiftStartTime ?? "")"
            var ed = "\(ArryUserLeave[indexPath.row].shiftEndTime ?? "")"
            
            let dateAsString = "\(ArryUserLeave[indexPath.row].shiftStartTime ?? "")"//self.ArryUserLeave[0].shiftStartTime
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "h:mm a"
            let Date12 = dateFormatter.string(from: date!)
            
            
            let dateAsStEnd = "\(ArryUserLeave[indexPath.row].shiftEndTime ?? "")"//self.ArryUserLeave[0].shiftEndTime
            let dateFormatterEnd = DateFormatter()
            dateFormatterEnd.dateFormat = "HH:mm"
            
            let date1 = dateFormatterEnd.date(from: dateAsStEnd)
            dateFormatterEnd.dateFormat = "h:mm a"
            let Date11 = dateFormatter.string(from: date1!)
            
           
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                if enableCustomForm == "0"{
                    dateFormatter.dateFormat = "h:mm a"
                    
                    var strtShedulTime = Date11
                    var endShedulTime = Date12
                    self.lbl_SrtSchTime.text = endShedulTime
                    self.lbl_EndSchTime.text = strtShedulTime
                }else{
                    
                    var strtShedulTime = dateAsStEnd//Date11
                    var endShedulTime = dateAsString//Date12
                    self.lbl_SrtSchTime.text = endShedulTime
                    self.lbl_EndSchTime.text = strtShedulTime
                }
            }

           // print("SwitchBtnOn")
            
            break
            
        case 12:
            self.poIdBool = true
            self.txtfld_PoNumber.text = PurchaseOrder[indexPath.row].poNum
               // self.poIdVelue =  PurchaseOrderArrList[indexPath.row].poId ?? ""
            self.poIdVelue =  PurchaseOrder[indexPath.row].poNum  ?? ""//PurchaseOrderArrList[indexPath.row].poId ?? ""
            
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
                    self.btnContact.isHidden = true
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
                    self.btnSitName.setImage(UIImage(named: ""), for: .normal)
                }
            }
            
        }else if self.sltTxtField.isEqual(txtfld_Country) {
            //  self.txtfld_Country.text = ""
            self.txtfld_State.isEnabled = true
            self.removeOptionalView()
            arrOfShowData = getJson(fileName: "countries")["countries"] as! [Any]
            self.openDwopDown( txtField: self.txtfld_Country, arr: arrOfShowData)
            
            
            
        }else if self.sltTxtField.isEqual(txtfld_State){
            //  self.txtfld_State.text = ""
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
        
      
        textField.resignFirstResponder()
  
        
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
        
        
        //        if isarrOfShowData11 == true{
        
        selectedTxtField = textField
        textField.text = ""
        // textField.textColor = UIColor.black
        
        //        }else{
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
        //}
        
        if self.txtfld_AltMobNo.text != "" {
        if txtfld_MobNo.text!.isEmpty {
                   txtfld_MobNo.text = contryCode + txtfld_MobNo.text!
                   txtfld_MobNo.textColor = UIColor.lightGray
               }
               if txtfld_AltMobNo.text!.isEmpty {
                   txtfld_AltMobNo.text = contryCode + txtfld_AltMobNo.text!
                   txtfld_AltMobNo.textColor = UIColor.lightGray
               }
      }
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if isarrOfShowData11 == true{
                         self.txtFieldData  = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//
//              }else {
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
                    self.btnClient.isHidden = false
                    self.btnContact.isHidden = true
                    self.btnSitName.isHidden = true
                    
                    self.btnClient.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                    self.param.cltId = nil
                    self.param.nm = result
                    self.param.siteId = nil
                    self.param.cnm = nil
                    self.param.snm = self.txtfld_SiteName.text
                    self.param.cnm =   self.txtfld_Contact.text
                    self.txtfld_SiteName.text = "self"
                    self.txtfld_Contact.text = "self"
                    self.txtfld_SiteName.isUserInteractionEnabled = true
                    self.txtfld_Contact.isUserInteractionEnabled = true
                    self.param.conId = nil
                    //self.param.cnm = ""
                    //                    self.btnClient.setImage(UIImage(named: "arrowdown"), for: .normal)
                    //                    self.btnContact.setImage(UIImage(named: "arrowdown"), for: .normal)
                    //                    self.btnSitName.setImage(UIImage(named: "arrowdown"), for: .normal)
                    //                    self.btnClient.isHidden = false
                    //                    self.btnContact.isHidden = false
                    //                    self.btnSitName.isHidden = false
                    self.optionalVw?.table_View?.reloadData()
                }else{
                    if(result != ""){ // When Txtfield emprt remove dropdown buttton
                        self.removeOptionalView()
                        self.btnClient.isHidden = false
                        //                        self.btnContact.isHidden = false
                        //                        self.btnSitName.isHidden = false
                        self.btnClient.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        //self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        //self.btnSitName.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        self.param.cltId = nil
                        self.param.nm = result
                        
                        self.param.conId = nil
                        //  self.param.cnm = ""
                        self.btnContact.isHidden = true
                        self.param.cnm = nil
                        self.param.cnm =   self.txtfld_Contact.text
                        self.txtfld_Contact.text = "self"
                        // self.param.cnm = self.txtfld_Contact.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.param.siteId = nil
                        self.param.snm =   self.txtfld_SiteName.text
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
                            self.btnContact.isHidden = true
                            self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                            self.param.conId = nil
                            self.param.cnm = result
                            self.optionalVw?.table_View?.reloadData()
                        }
                    }else{
                        if(result != ""){
                            self.btnContact.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                            self.btnContact.isHidden = true
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
                    //  self.btnContact.isHidden = false
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
                            //                                self.btnSitName.isHidden = false
                            //                                self.btnSitName.setImage(UIImage(named: "arrowdown"), for: .normal)
                            //self.btnSitName.isHidden = true
                            
                            self.btnSitName.setImage(UIImage(named: ""), for: .normal)
                            self.btnSitName.isHidden = true
                            self.param.siteId = nil
                            self.param.snm = result
                            self.optionalVw?.table_View?.reloadData()
                        }
                    }else{
                        if(result != ""){
                            self.btnSitName.setImage(UIImage(named: ""), for: .normal)
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
                    self.btnSitName.setImage(UIImage(named: ""), for: .normal)
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
        case 12 :
            
            self.poIdBool = false
            PurchaseOrderArrList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "PurchaseOrderList", query: nil) as! [PurchaseOrderList]
            let bPredicate: NSPredicate = NSPredicate(format: "self.poNum beginswith[c] %@", result)
            PurchaseOrder =  (PurchaseOrderArrList as NSArray).filtered(using: bPredicate) as! [PurchaseOrderList]
            
            if(self.optionalVw == nil){
                self.openDwopDownForConstantHeight( txtField: self.txtfld_PoNumber, arr: PurchaseOrder)
            }
            DispatchQueue.main.async{
                if(self.PurchaseOrder.count > 0){
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
            
       // }
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
//         if arrOfShowData11.count > 0 {
//              let customFormDetals = arrOfShowData11[textField.tag]
//              let opt = OptDetals(key: "0", questions: nil, value: textField.text, optHaveChild: nil)
//              let layer = String(format: "%d.1", (textField.tag + 1))
//              self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals as! CustomFormDetals)
//        }
        
        if textField.tag == 15 || textField.tag == 0 || textField.tag == 2 || textField.tag == 8 || textField.tag == 6 || textField.tag == 5 || textField.tag == 12 || textField.tag == 3 || textField.tag == 4 {
          //  print("nothing to print")
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
  
    //=====================================
    // MARK:- Create Job list  Service
    //=====================================
  
    func getTempIdForNewJob(newId : Int) -> String {
       return "Job-\(String(describing: getUserDetails()?.usrId ?? ""))-\(getCurrentTimeStamp())"
    }
   
    func addJob(){
        
        let temp = getTempIdForNewJob(newId: 0)
        
        if parmnew == true {
            param.appId = aadAppId
           
        }else{
            param.appId = ""
            param.mob1 = self.txtfld_MobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            param.mob2 = self.txtfld_AltMobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            param.email = self.txtfld_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            param.city = self.txtfld_City.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            param.cltId =  param.cltId == nil ?  "" : param.cltId
            param.conId =  param.conId == nil ? "" :  param.conId
        }
        param.tempId = temp
        param.jobId = temp
        param.adr = self.txtfld_Address.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.athr = getUserDetails()?.usrId
        if poIdBool == true {
            param.pono = poIdVelue
        }else{
            param.pono = self.txtfld_PoNumber.text
        }
      
        param.siteId = param.siteId == nil ? "" : param.siteId
        param.cnm = (param.conId == "" ?  (param.cnm == "" ? "self" : param.cnm) : "")
        param.snm = param.siteId == "" ? param.snm : ""
        param.des =  textView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.inst = self.txtfld_JobInstruction.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.kpr = FltWorkerId.count == 0 ? "" : (FltWorkerId.count == 1 ? FltWorkerId[0] : "")
        param.parentId = ""
        param.prty =  String(format: "%d",getPriortyRawValueAccordingToText(txt: (txtfld_JobPriority.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)) // no
        param.quotId = param.quotId == nil ? "" :  param.quotId
        param.siteId = param.siteId == nil ? "" : param.siteId
        param.snm = param.siteId == "" ? param.snm : ""
        param.status = self.dispatchStatus
        param.type = FltWorkerId.count == 0 ? "1"  : (FltWorkerId.count == 1 ? "1" : "2")// no
        param.zip = self.txtfld_PostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.updateDate = String(Int(Date().timeIntervalSince1970))
        param.title = self.txtfldJobTitle.text
        
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
              
                if let langCode = getCurrentSelectedLanguageCode() {
                    dateFormatter.locale = Locale(identifier: langCode)
                }
                let date = dateFormatter.date(from: self.lbl_SrtSchTime.text!)
                dateFormatter.dateFormat = "HH:mm:ss"
                schTime12 = dateFormatter.string(from: date!)
             
                let dateFormatter1 = DateFormatter()
                if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                    if enableCustomForm == "0"{
                        dateFormatter1.dateFormat = "h:mm a"
                    }else{
                        dateFormatter1.dateFormat = "HH:mm"
                    }
                }
               
                if let langCode = getCurrentSelectedLanguageCode() {
                    dateFormatter1.locale = Locale(identifier: langCode)
                }
                let date1 = dateFormatter1.date(from: self.lbl_EndSchTime.text!)
                dateFormatter1.dateFormat = "HH:mm:ss"
                endTime12 = dateFormatter1.string(from: date1!)
                
                param.schdlStart = isClear ? "" : (self.lbl_SrtSchDate.text! + " " + schTime12)
                param.schdlFinish = isClear ? "" : (self.lbl_EndSchDate.text! + " " + endTime12)
               
                if param.schdlStart != "" {
                    param.schdlStart = convertDateStringToTimestamp(dateString: param.schdlStart!)
                }
                
                if param.schdlFinish != "" {
                    param.schdlFinish = convertDateStringToTimestamp(dateString: param.schdlFinish!)
                }
            }
        }else{
            param.schdlStart = ""
            param.schdlFinish = ""
        }
       
        param.tagData = arrOfaddTags.count == 0 ? [] : arrOfaddTags
        param.lat = latitued.text
        param.lng = longitued.text
        param.landmark = trimString(string: txt_landmark.text!)
        
        let isExist = self.FltWorkerId.contains((getUserDetails()?.usrId)!)
        if(isExist){
            let userJobs = DatabaseClass.shared.createEntity(entityName: "UserJobList")
            userJobs?.setValuesForKeys(param.toDictionary!)
            DatabaseClass.shared.saveEntity(callback: {_ in
                if self.callbackForJobVC != nil {
                    self.callbackForJobVC!(true)
                }
            })
        }else{
            //            if(param.kpr == getUserDetails()?.usrId){
            //                let userJobs = DatabaseClass.shared.createEntity(entityName: "UserJobList")
            //                userJobs?.setValuesForKeys(param.toDictionary!)
            //                DatabaseClass.shared.saveEntity()
            //
            //                if self.callbackForJobVC != nil {
            //                    self.callbackForJobVC!(true)
            //                }
            //            }
        }
        
        if isClear {
            param.schdlStart =  ""
            param.schdlFinish =  ""
        }else{
            
            param.schdlStart = convertDateToStringForServerAddJob(dateStr: (self.lbl_SrtSchDate.text! + " " + schTime12))
            param.schdlFinish = convertDateToStringForServerAddJob(dateStr: (self.lbl_EndSchDate.text! + " " + endTime12))
        }
      
        param.nm =  param.cltId == "" ? param.nm : ""
        param.compId = getUserDetails()?.compId
        param.memIds =  (FltWorkerId.count == 0 ? [] : (FltWorkerId.count == 1 ? [] : FltWorkerId))
        param.clientForFuture =  isClintFutUser ? "1" : "0"
        param.siteForFuture = (isSitFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
        param.contactForFuture = (isContactFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
        // param.tagData = arrOfaddTags.count == 0 ? [] : arrOfaddTags as! [[String : String]]
        param.pymtType = ""
        param.gstNo = ""
        param.tinNo = ""
        param.industry = ""
        param.note = ""
        param.fax = ""
        param.twitter = ""
        param.skype = ""
        param.tempId = param.jobId
        param.dateTime =  currentDateTime24HrsFormate()
        
        var dict =  param.toDictionary
        var ids = [String]()
        let titles : [[String : String]] = dict!["jtId"] as! [[String : String]]
        
        for title in titles {
            ids.append(title["jtId"]!)
        }
        dict!["jtId"] = ids
        
        let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
        userJobs.apis = Service.addJob
        userJobs.parametres = dict?.toString
        userJobs.time = Date()
        
        DatabaseClass.shared.saveEntity(callback: {_ in
            DatabaseClass.shared.syncDatabase()
            self.navigationController?.popViewController(animated: true)
        })
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
        param.limit = "120"
        param.index = "0"
        param.search = ""
        param.dateTime = ""
        
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
        param.dateTime = ""
        
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
        param.dateTime = lastRequestTime ?? ""
        
        
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
        param.index = "0"
        
//        param.limit = "120"
//                   if searchkryGetJobTittle == false {
//                   param.index = "\(countGetJobTittle)"
//                  }else{
//                       param.index = "\(addcountGetJobTittle)"
//                   }
        
       param.dateTime = ""//currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
        
        
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
            if(jobs.isdelete != "0"){
                let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
                //DatabaseClass.shared.saveEntity()
            }
        }
        
        
//        for jobs in data{
//            let query = "siteId = '\(jobs.siteId!)'"
//            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
//            if isExist.count > 0 {
//                if(jobs.isdelete == "0"){
//                    let existingJob = isExist[0]
//                    DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
//                }else{
//                    let existingJob = isExist[0]
//                    existingJob.setValuesForKeys(jobs.toDictionary!)
//                    // DatabaseClass.shared.saveEntity()
//                }
//            }else{
//                if(jobs.isdelete != "0"){
//                    let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
//                    userJobs?.setValuesForKeys(jobs.toDictionary!)
//                    // DatabaseClass.shared.saveEntity()
//                }
//            }
//        }
//
//        DatabaseClass.shared.saveEntity(callback: { _ in})
        
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
        param.dateTime = ""//lastRequestTime ?? ""
        
        serverCommunicator(url: Service.getClientContactSink, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ContactResps.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                       // DatabaseClass.shared.saveEntity(callback: { _ in
                            
                            if decodedData.data.count > 0 {
                                self.saveUserContactInDataBase(data: decodedData.data)
                            }
                            
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientContactSink)
                            
                       // })
                        
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
           // print(isExist)
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
                       // print(isExistJob)
                        if isExistJob.count > 0 {
                            let existing = isExistJob[0]
                            DatabaseClass.shared.deleteEntity(object: existing, callback: { (_) in})
                        }
                        
                    }
                }
            }
        }

        getClientListFromDBjob()
        
    }
   
    
    func getClientListFromDBjob() -> Void {
        
        
        showDataOnTableView(query : nil)
        
    }
    func showDataOnTableView(query : String?) -> Void {
        ArrContrect = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ContractList", query: query) as! [ContractList]
        //  print(ArrContrect)
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
                        //   print("\(decodedData)")
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
    
    //=================================
        // MARK:- Suggetion for job type
         //=================================
        
        @IBAction func BtnSddSuggetion(_ sender: UIButton) {
            setData()
            
            if arrOfSuggest.count > 0 {
               
                
                self.sltDropDownBtnTag  = sender.tag
                self.callMethodforOpenDwop(tag: sender.tag)
                
            
            }else{
                
               
                ShowError(message: AlertMessage.no_suggesstion, controller: windowController)
            }
        
            
        }
        
     
           
        func setData(){
            
            
            let dict = param.toDictionary
            let ids = [Any]()
           if dict!["jtId"] != nil
                   {
            
            let titles : [[String : String]] = (dict!["jtId"] as! [[String : String]])
            
            for jtId in titles {
                let Ids = jtId["jtId"]
              //  let getId = (Ids as! [String:String])["jtId"] ?? ""
                //print(getId)
                let query = "jtId = '\(Ids!)'"
                let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: query) as! [UserJobTittleNm]
                
                for value in isExist {
                    
                    for des in (value.suggestionList as! [AnyObject]) {
                        let dic  = (des as! [String:String])["complNoteSugg"] ?? ""
                        
                        if dic != "" {
                            
                            let jtId  = (des as! [String:String])["jtId"] ?? ""
                            let complNoteSugg  = (des as! [String:String])["complNoteSugg"] ?? ""
                            let compId  = (des as! [String:String])["compId"] ?? ""
                            let updateDate  = (des as! [String:String])["updateDate"] ?? ""
                            let createdDate  = (des as! [String:String])["createdDate"] ?? ""
                            let suggId  = (des as! [String:String])["suggId"] ?? ""
                            let jtDesSugg  = (des as! [String:String])["jtDesSugg"] ?? ""
                            
                            arrOfSuggest.append(suggestionListData(suggId: suggId, compId: compId, jtId: jtId, jtDesSugg: jtDesSugg, complNoteSugg: complNoteSugg, createdDate: createdDate, updateDate: updateDate))
                        }
                        
                        
                    }
                    
                    
                    
                }
                
            }
                    
            }else {
                   // print("id is not get ")
            }
            
            var seen = Set<String>()
            var newData = [suggestionListData]()
            for message in arrOfSuggest {
                if !seen.contains(message.jtId!) {
                    newData.append(message)
                    seen.insert(message.jtId!)
                }
            }
            
            arrOfSuggest = newData
        }
    
        func getCurrentLatLng () {
                 let locManager = CLLocationManager()
                 locManager.requestWhenInUseAuthorization()
                 var currentLocation: CLLocation!
                 if
                    CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() ==  .authorizedAlways
                 {
                     currentLocation = locManager.location
                 }
              if  currentLocation != nil {
                  latitued.text = "\(currentLocation.coordinate.latitude)"
                  longitued.text = "\(currentLocation.coordinate.longitude)"
              }
                
             }
    
    
    
    @IBAction func btnAddLatLong(_ sender: Any) {
        getCurrentLatLng ()
    }
    
    
    
    
    //=====================================
    // MARK:- get All Company Settings
    //=====================================
    
    func getAllCompanySettings(){
        
        ChatManager.shared.ref.database.goOnline() // make sure online realtime database
        
        let param = Params()
        param.usrId = getUserDetails()!.usrId
        param.devType = "2"
        
        serverCommunicator(url: Service.getMobileDefaultSettings, param: param.toDictionary) { (response, success) in
            
            if success {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(DefaultSettingResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                    
                        self.confirmationTriggerArray = (decodedData.data!.confirmationTrigger)!
                        
                        //print(self.confirmationTriggerArray)
                        
                        for admin in self.confirmationTriggerArray {
                                   // Get admin's path for notification messages add
                                   
                            var aa = "1"
                            if aa == admin {
                                self.emailpermision = true
                                
                            }else{
                                
                            }
                        }

                        
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
    
    
    //=======================================
    // MARK:- API method getLocationList
    //=======================================
    
       
    func getUserLeaveList() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            killLoader()
            return
        }
    
        let  param  = Params()
          param.limit = "120"
          param.index = "0"
          param.search = ""

        serverCommunicator(url: Service.getShiftList, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(GetShiftListResp.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        self.UserLeave = decodedData.data as! [getUserLeaveData]
                     
                       // self.searchInventroryCount = Int(decodedData.count!)!
                        DispatchQueue.main.async {
                            
//                            var cou = decodedData.data.count
//
//                            //  0                         // 120                   //360
//                            if Int(param.index!)! +  Int(param.limit!)! <= self.searchInventroryCount {
//                                self.globel = Int(param.index!)! +  Int(param.limit!)!
//
//
//                                self.addcount = self.globel
//
//                                self.searchkry = true
//
//                                self.arrItemListOnline1.append(contentsOf: decodedData.data as! [LocationList])
//                                self.getLocationList()
//                                //  self.savegetLocationListInDataBase(data: self.arrItemListOnline1)
//
//                            }else{
//                                self.arrItemListOnline1.append(contentsOf: decodedData.data as! [LocationList])
//
//                                print("loc ---\(self.arrItemListOnline1.count)")
//                                UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getLocationList)
//                                if decodedData.data.count > 0 {
//
//                                    self.savegetLocationListInDataBase(data: self.arrItemListOnline1)
//
//                                }
//                            }
           
                            self.savegetIndustryList1(data:self.UserLeave )
                            self.showDataOnTableViewJob1(query: nil)
                            if self.ArryUserLeave.count >= 2 {
                                self.switchBtnAllDays.isHidden = true
                                self.dropDownAllDaysBtn.isHidden = false
                            }else{
                                self.switchBtnAllDays.isHidden = false
                                self.dropDownAllDaysBtn.isHidden = true
                            }
                            
                        }
                     
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                ShowError(message: AlertMessage.check_in_out_fail, controller: windowController)
            }
        }
        
    }
    
            
    //==============================
       // MARK:- Save getItems in DataBase
       //==============================
       func savegetIndustryList1( data : [getUserLeaveData]) -> Void {
           for jobs in data{
               let query = "shiftId = '\(String(describing: jobs.shiftId ?? ""))'"
               let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ShiftList", query: query) as! [ShiftList]
               if isExist.count > 0 {
                   let existingJob = isExist[0]
                   existingJob.setValuesForKeys(jobs.toDictionary!)
                   // DatabaseClass.shared.saveEntity()
               }else{
                   let userJobs = DatabaseClass.shared.createEntity(entityName: "ShiftList")
                   userJobs?.setValuesForKeys(jobs.toDictionary!)
                   // DatabaseClass.shared.saveEntity()
               }
           }
           
           DatabaseClass.shared.saveEntity(callback: { _ in })
       }
     
       func showDataOnTableViewJob1(query : String?) -> Void {
           ArryUserLeave = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ShiftList", query: query) as! [ShiftList]
           
       }
   
    }
 
////MARK:- UITableView
extension AddJobVC : UITableViewDelegate, UITableViewDataSource{
    
    func getQuestionsByParentId(patmid:String){
        
        let param = Params()
        param.ansId = "-1"
        param.frmId = patmid
        param.jobId = ""
        
        serverCommunicator(url: Service.getQuestionsByParentId, param: param.toDictionary) { (response, success) in
            
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(CustomFormResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        if decodedData.data.count > 0 {
                            DispatchQueue.main.async {
                                
                                if  decodedData.data.count == 1 {
                                    self.view_Hieght.constant = 2050//1870
                                } else if decodedData.data.count == 2 {
                                    self.view_Hieght.constant = 1960
                                }  else  if decodedData.data.count == 3 {
                                    self.view_Hieght.constant = 2050
                                }  else if decodedData.data.count == 4 {
                                    self.view_Hieght.constant = 2140
                                }  else if decodedData.data.count == 5 {
                                    self.view_Hieght.constant = 2360
                                }  else if decodedData.data.count == 6 {
                                    self.view_Hieght.constant = 2320
                                }  else if decodedData.data.count == 7 {
                                    self.view_Hieght.constant = 2510
                                }  else if decodedData.data.count == 8 {
                                    self.view_Hieght.constant = 2600
                                }  else if decodedData.data.count == 9 {
                                    self.view_Hieght.constant = 2690
                                }  else if decodedData.data.count == 10 {
                                    self.view_Hieght.constant = 2780
                                }  else if decodedData.data.count == 11 {
                                    self.view_Hieght.constant = 2870
                                }  else if decodedData.data.count == 12 {
                                    self.view_Hieght.constant = 2960
                                }  else if decodedData.data.count == 13 {
                                    self.view_Hieght.constant = 3000
                                }  else if decodedData.data.count == 14 {
                                    self.view_Hieght.constant = 3140
                                } else if decodedData.data.count == 15 {
                                    self.view_Hieght.constant = 3290
                                }
                                if let isAddJobRecurEnable = getDefaultSettings()?.isAddJobCustomFieldEnable{
                                    if isAddJobRecurEnable == "0"{
                                        
                                        self.view_Hieght.constant = 1700
                                        self.customField_Tbl.isHidden = true
                                    } else{
                                        self.customField_Tbl.isHidden = false
                                    }
                                    
                                }
                                
                                self.arrOfShowData11 = decodedData.data
                                self.customField_Tbl.reloadData()
                                
                            }
                            
                        }else{
                            if self.arrOfShowData.count == 0{
                                DispatchQueue.main.async {
                                    
                                    self.view_Hieght.constant = 1700
                                    self.customField_Tbl.isHidden = true
                                    
                                }
                            }
                        }
                    }else{
                        self.view_Hieght.constant = 1700
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
        param.type = "1"
        // param.dateTime = lastRequestTime ?? ""
        
        serverCommunicator(url: Service.getFormDetail, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(FormDetail.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        self.arrOfShowDatas = decodedData.data
                     
                        self.getQuestionsByParentId(patmid: decodedData.data.frmId!)
                      
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
        let cell: fifthTableViewCell = self.customField_Tbl.cellForRow(at: indexPath) as! fifthTableViewCell
        
        
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
                
            }else{
                
                if optDetail.value != "" {
                    objOfCusArr.ans?.append(dictData1)
                }
                
            }
        }else{
            self.customVCArr.append(dictData)
        }
    }
    
    @objc func tapOnTermAndConditionButton(sender: UIButton) {
     
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
      
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellToReturn = UITableViewCell() // Dummy value
        if tableView == self.tableView {
            
            return  searcharraisbol ? searcharra.count : arra.count
         
        } else if tableView == self.customField_Tbl {
            return  arrOfShowData11.count
          
        }
        
        return  searcharraisbol ? searcharra.count : arra.count + arrOfShowData11.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cellToReturn = UITableViewCell()
        if tableView == self.tableView {
            //  let cell = tableView.dequeueReusableCellWithIdentifier("CustomOne") as! CustomOneTableViewCell
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            
            cell?.backgroundColor = .clear
            
            if(cell == nil){
                cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
            }
            
            let jobTittleListData  = searcharraisbol ? searcharra[indexPath.row] as? UserJobTittleNm : arra[indexPath.row] as? UserJobTittleNm
            self.arra = self.arra.sorted(by: { (Obj1, Obj2) -> Bool in
                let Obj1_Name = Obj1.title ?? ""
                let Obj2_Name = Obj2.title ?? ""
                return (Obj1_Name.localizedCaseInsensitiveCompare( Obj2_Name) == .orderedAscending)
            })
            
            var arrService =  param.jtId?.contains{ ( arry : jtIdParam) -> Bool in
                if arry.jtId == jobTittleListData?.jtId{
                    
                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                    
                    return true
                }else{
                    cell?.accessoryType = UITableViewCell.AccessoryType.none
                    return false
                }
            }
            if self.txtfldJobTitle.text == "" {
                
                cell?.accessoryType = UITableViewCell.AccessoryType.none
                
            }
            
            cell?.textLabel?.text = jobTittleListData?.title?.capitalizingFirstLetter()
            cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
            cell?.textLabel?.textColor = UIColor.darkGray
            return cell!
            cellToReturn = cell!
        } else if tableView == self.customField_Tbl {
            
            
            let customFormDetals = arrOfShowData11[indexPath.row]
            
            if customFormDetals.type == "3"{ //checkBox
                //  let cell: FirstTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "firstCustomCell") as! FirstTableViewCell?)!
                let cell: FirstTableViewCell = (self.customField_Tbl.dequeueReusableCell(withIdentifier:"firstCustomCell") as! FirstTableViewCell?)!
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
                
                let cell: ThirdTableViewCell = (self.customField_Tbl.dequeueReusableCell(withIdentifier: "thirdCustomCell") as! ThirdTableViewCell?)!
                
                
                
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
                let cell: SecondTableViewCell = (self.customField_Tbl.dequeueReusableCell(withIdentifier: "secondCustomCell") as! SecondTableViewCell?)!
                
                
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
                let cell: fourthTableViewCell = (self.customField_Tbl.dequeueReusableCell(withIdentifier: "fourthCustomCell") as! fourthTableViewCell?)!
                
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
                
                let cell: sixthTableViewCell = (self.customField_Tbl.dequeueReusableCell(withIdentifier: sixthTableViewCell.identifier) as! sixthTableViewCell?)!
                
                
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
                let cell: sixthTableViewCell = (self.customField_Tbl.dequeueReusableCell(withIdentifier: sixthTableViewCell.identifier) as! sixthTableViewCell?)!
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
                let cell: fifthTableViewCell = (self.customField_Tbl.dequeueReusableCell(withIdentifier: "fifthCustomCell") as! fifthTableViewCell?)!
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
        
        if tableView == self.tableView {
            
            let objOfArr = searcharraisbol ? searcharra[indexPath.row] as? UserJobTittleNm : arra[indexPath.row] as? UserJobTittleNm
            
            if param.jtId == nil {
                param.jtId = [jtIdParam]()
            }
            
            let jt = jtIdParam()
            jt.jtId = objOfArr?.jtId
            jt.title = objOfArr?.title
            
            let isExist =  param.jtId?.contains{ ( arry : jtIdParam) -> Bool in
                if arry.jtId == jt.jtId{
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
            
            tableView.reloadData()
            
            self.searchDropDwnView.isHidden = true
            self.searchBackBtn.isHidden = true
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellToReturn = UITableViewCell() // Dummy value
        if tableView == self.tableView {
            return UITableView.automaticDimension
        }else if tableView == self.customField_Tbl{
            let customFormDetals = arrOfShowData11[indexPath.row]
            
            if customFormDetals.type == "3" {
                return tableView.estimatedRowHeight
            }else if customFormDetals.type == "2"{
                return tableView.estimatedRowHeight
            }else {
                return tableView.estimatedRowHeight
            }
        }
        
        return UITableView.automaticDimension
        
    }
    
    
    
    //==============================================================//
    // open gallary method
    //==============================================================//
    
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
                    
                    //self.imgView.isHidden = true
                    //self.HightTopView.constant = 55
                    
                })
            }
        }
        
        actionSheetControllerIOS8.addAction(gallery)
        actionSheetControllerIOS8.addAction(camera)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    
    func convertIntoJSONString(arrayObject: [Any]) -> String? {
        
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    
    func convertToDictionary(text: String) -> [[String: String]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    // ===================================
    // MARK:- Get Online Add job  Service
    // ===================================
    
    func addJobOnlineWithAttechment(){
        
        var recuDataArr1: [[String:Any]] = []
        var parm = [String: Any]()
        
        let temp = getTempIdForNewJob(newId: 0)
        var memId = [String]()
        var eqpIdArr = [String]()
        memId.append((getUserDetails()?.usrId)!)
        if parmnew == true {
            parm["appId"] = aadAppId
            parm["cltId"] = appoinmnrA?.cltId
        }else{
            parm["appId"] = ""
            parm["cltId"] = param.cltId == nil ? "" : param.cltId
        }
        parm["appId"] = ""
        parm["mob1"] = self.txtfld_MobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        parm["mob2"] = self.txtfld_AltMobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        parm["email"] = self.txtfld_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        parm["city"] = self.txtfld_City.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        parm["conId"] = param.conId == nil ? "" : param.conId
        
        //        if eqDetail == true{
        //            //eqpIdArr.append(aadEqId!)
        //            //  parm["appId"] =  aadEqId//eqpIdArr
        //        }
        
        
        if clientSelf == true {
            parm["conId"] = param.conId == nil ? "" : param.conId
            parm["nm"] =  param.cltId == "" ? param.nm : ""
            parm["siteId"] = param.siteId == nil ? "" : param.siteId
            parm["snm"] = param.siteId == nil ? param.snm : ""
            
        }else{
            parm["cnm"] = (param.conId == "" ? (param.cnm == "" ? "self" : param.cnm) : "")
            parm["nm"] = param.cltId == "" ? param.nm : ""
            parm["siteId"] = param.siteId == nil ? "" : param.siteId
            parm["snm"] = param.siteId == "" ? param.snm : ""
        }
        parm["ctry"] = cntry
        parm["state"] = states
        parm["isMailSentToClt"] = emailSendStatus
        parm["tempId"] = temp
        parm["jobId"] = temp
        parm["contrId"] = ""
        parm["adr"] = self.txtfld_Address.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        parm["athr"] = getUserDetails()?.usrId
        
        if self.stringToHtml != "" {
            
            parm["des"] = self.stringToHtml
        }else{
            
            if self.textView.text == "Job Description" {
                parm["des"] = ""
            }else{
                stringToHtmlFormateWithOutImage()
                parm["des"] = "<p>\(self.textView.text ?? "")</p>"
                
            }
            
        }
        
        parm["inst"] = self.txtfld_JobInstruction.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        parm["kpr"] = FltWorkerId.count == 0 ? "" : (FltWorkerId.count == 1 ? FltWorkerId[0] : "")
        parm["parentId"] = ""
        parm["prty"] = String(format: "%d",getPriortyRawValueAccordingToText(txt: (txtfld_JobPriority.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)) // no
        parm["quotId"] = param.quotId == nil ? "" : param.quotId
        parm["type"] = FltWorkerId.count == 0 ? "1" : (FltWorkerId.count == 1 ? "1" : "2")// no
        parm["zip"] = self.txtfld_PostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        // parm["updateDate"] = String(Int(Date().timeIntervalSince1970))
        // parm["status"] = "1"
        parm["status"] = self.dispatchStatus
        parm["scheduleDisplayText"] = scheduleTxt_Fld.text
        
        if poIdBool == true {
            parm["pono"] = poIdVelue
        }else{
            parm["pono"] = self.txtfld_PoNumber.text
        }
        
        let schStartDate = String(format: "%@ %@", (self.lbl_SrtSchDate.text == nil ? "" : self.lbl_SrtSchDate.text! ) , (self.lbl_SrtSchTime.text == nil ? "" : self.lbl_SrtSchTime.text!))
        let schEndDate = String(format: "%@ %@", (self.lbl_EndSchDate.text == "" ? "" : self.lbl_EndSchDate.text!) , (self.lbl_EndSchTime.text == "" ? "" : self.lbl_EndSchTime.text!) )
        
        var schTime12 = ""
        var endTime12 = ""
        
        if isClear == false{
            
            if schStartDate == "dd-MM-yyyy 00:00"{
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectStartDate, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                return
            }
            
            if schEndDate == "dd-MM-yyyy 00:00"{
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectEndDate, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                return
            }
            
            
            let value = compareTwodate(schStartDate:schStartDate , schEndDate: schEndDate, dateFormate: DateFormate.dd_MM_yyyy)
            if(value == "orderedDescending") || (value == "orderedSame"){
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
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
                
                
                if let langCode = getCurrentSelectedLanguageCode() {
                    dateFormatter.locale = Locale(identifier: langCode)
                }
                let date = dateFormatter.date(from: self.lbl_SrtSchTime.text!)
                dateFormatter.dateFormat = "HH:mm:ss"
                schTime12 = dateFormatter.string(from: date!)
                
                
                
                let dateFormatter1 = DateFormatter()
                
                if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                    if enableCustomForm == "0"{
                        dateFormatter1.dateFormat = "h:mm a"
                    }else{
                        dateFormatter1.dateFormat = "HH:mm"
                    }
                }
                
                if let langCode = getCurrentSelectedLanguageCode() {
                    dateFormatter1.locale = Locale(identifier: langCode)
                }
                let date1 = dateFormatter1.date(from: self.lbl_EndSchTime.text!)
                dateFormatter1.dateFormat = "HH:mm:ss"
                endTime12 = dateFormatter1.string(from: date1!)
                
                
                parm["schdlStart"] = isClear ? "" : (self.lbl_SrtSchDate.text! + " " + schTime12)
                parm["schdlFinish"] = isClear ? "" : (self.lbl_EndSchDate.text! + " " + endTime12)
                
                var schdlStart = isClear ? "" : (self.lbl_SrtSchDate.text! + " " + schTime12)
                var schdlFinish = isClear ? "" : (self.lbl_EndSchDate.text! + " " + endTime12)
                
                
                if schdlStart != "" {
                    parm["schdlStart"] = convertDateStringToTimestamp(dateString: schdlStart)
                }
                
                if schdlFinish != "" {
                    parm["schdlFinish"] = convertDateStringToTimestamp(dateString: schdlFinish)
                }
            }
        }else{
            parm["schdlStart"] = ""
            parm["schdlFinish"] = ""
        }
        
        
        parm["lat"] = latitued.text
        parm["lng"] = longitued.text
        parm["landmark"] = trimString(string: txt_landmark.text!)
        
        if isClear {
            
            parm["schdlStart"] = ""
            parm["schdlFinish"] = ""
        }else{
            
            parm["schdlStart"] = convertDateToStringForServerAddJob(dateStr: (self.lbl_SrtSchDate.text! + " " + schTime12))
            parm["schdlFinish"] = convertDateToStringForServerAddJob(dateStr: (self.lbl_EndSchDate.text! + " " + endTime12))
        }
        
        parm["compId"] = getUserDetails()?.compId
        if FltWorkerId.count > 1  {
            parm["memIds"] = (FltWorkerId.count == 0 ? [] : (FltWorkerId.count == 1 ? [] : FltWorkerId))
        }
        
        parm["clientForFuture"] = isClintFutUser ? "1" : "0"
        parm["siteForFuture"] = (isSitFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
        parm["contactForFuture"] = (isContactFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
        
        
        var tagDataids : [[String:Any]] = []
        let titlesDataids  = arrOfaddTags.count == 0 ? [] : arrOfaddTags
        
        for title in titlesDataids {
            tagDataids.append((title as [String : Any] ) )
            
            
        }
        
        parm["tagData"] = convertIntoJSONString(arrayObject: tagDataids)//arrOfaddTags.count == 0 ? [] : arrOfaddTags as! [[String : String]]
        
        parm["dateTime"] = currentDateTime24HrsFormate()
        
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
        
        parm["answerArray"] = convertIntoJSONString(arrayObject: questions)
        
        var recuDataArr: [[String:Any]] = []
        var recuDaysArr: [[String:Any]] = []
        
        
        if daiyType == "1" {
            recuDaysArr.append(daysDic)
            parm["selectedDays"] = recurDay
            parm["recurData"] = recurDatastring
            parm["recurType"] = "1"
            // print(parm)
        }else if weeklyType == "2"
        {
            recuDaysArr.append(daysDic)
            
            parm["recurData"] = recurDatastring
            parm["recurType"] = "2"
            parm["selectedDays"] = recurDay
            // print(parm)
        }
        else if monthlyType == "3"
        {
            
            parm["recurData"] = recurDatastring
            parm["recurType"] = "3"
            // print(parm)
        }else{
            
            
            if lblRecurEndDate.text != "" {
                var paramDic = [String:Any]()
                paramDic["mode"] = "1"
                paramDic["startDate"] = convertDateFormater(date: lbl_SrtSchDate.text!)
                paramDic["numOfWeeks"] = "1"
                paramDic["endDate"] = convertDateFormater(date: lblRecurEndDate.text!)
                paramDic["occurences"] = "0"
                paramDic["jobId"] = ""
                paramDic["weekDays"] = arrDaysCount
                paramDic["endRecurMode"] = recurMode
                paramDic["stopRecur"] = "0"
                recuDataArr.append(paramDic)
                recuDaysArr.append(daysDic)
                let recuDataJsonString = convertIntoJSONStringForRecur(arrayObject: recuDataArr)
                let daysJsonString = convertIntoJSONStringForRecur(arrayObject: recuDaysArr)
                parm["recurData"] = recuDataJsonString!
                parm["selectedDays"] = daysJsonString!
                parm["recurType"] = "2"
            }else {
                var paramDic = [String:Any]()
                paramDic["mode"] = "1"
                paramDic["startDate"] = convertDateFormater(date: lbl_SrtSchDate.text!)
                paramDic["numOfWeeks"] = "1"
                paramDic["endDate"] = ""//convertDateFormater(date: lblRecurEndDate.text!)
                paramDic["occurences"] = "0"
                paramDic["jobId"] = ""
                paramDic["weekDays"] = arrDaysCount
                paramDic["endRecurMode"] = recurMode
                paramDic["stopRecur"] = "0"
                recuDataArr.append(paramDic)
                recuDaysArr.append(daysDic)
                let recuDataJsonString = convertIntoJSONStringForRecur(arrayObject: recuDataArr)
                let daysJsonString = convertIntoJSONStringForRecur(arrayObject: recuDaysArr)
                parm["recurData"] = recuDataJsonString!
                parm["selectedDays"] = daysJsonString!
                parm["recurType"] = "2"
                
            }
        }
        
        param.answerArray = DictGlob
        var dict = param.toDictionary
        var ids = [String]()
        let titles : [[String : String]] = dict!["jtId"] as! [[String : String]]
        
        for title in titles {
            ids.append(title["jtId"]!)
            
        }
        
        parm["jtId"] = ids//param.jtId == nil ? "" : param.jtId.toString
        
        
        let image = images
        
        showLoader()
        
        
        recuDataArr1.append(parm)
        
        //  print(parm)
        recuDataJsonString = convertIntoJSONStringForRecur(arrayObject: recuDataArr1)!
        serverCommunicatorUplaodImageInArrayForInputField(url: Service.addJob, param: parm, images: imgArr , imagePath:"ja[]") { (response, success) in
            killLoader()
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AddjobRes.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        DispatchQueue.main.async {
                            killLoader()
                            
                            
                            //========================FORNOTIFICATION===================================
                            self.responceaddjob = decodedData.data!
                            var on = "On"
                            UserDefaults.standard.set(on, forKey: "ForGetuserJoblistRefresh")
                            
                            let jobCod = self.responceaddjob.label ?? ""
                            let message = ChatMessageModelForJob1()
                            let message1 = ChatMessageModel()
                            message.usrId = self.responceaddjob.kpr
                            message.action = "AddJob"
                            message.msg =  "A new Job has been created with Job code \(jobCod)."
                            message.usrNm = trimString(string: "\(getUserDetails()?.fnm ?? "")")
                            message.usrType = "2"
                            message.id =  self.responceaddjob.jobId
                            message.type = "JOB"
                            message.time = getCurrentTimeStamp()
                            ChatManager.shared.sendClientdMessageForJob(jobid: self.responceaddjob.jobId ?? "", messageDict: message)
                            NotiyCenterClass.addJobRefreshJobList(dict: [:]) 
                            self.navigationController?.popToRootViewController(animated: true)
                            // self.sendImageOnFireStoreforjob()
                            
                            
                            //============================================================================
                            
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    
                    // ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                DispatchQueue.main.async {
                    // self.navigationController?.popToRootViewController(animated: true)
                }
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
        // images.removeAll()
        
        
    }
    
    
    func convertDateFormater(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date ?? Date())
        
    }
    
    func convertIntoJSONStringForRecur(arrayObject: [Any]) -> String? {
        
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            // print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    func convertIntoJSONString(arrayObject: [String:Any]) -> String? {
        
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            // print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    
    
    
    func getTempIdForNewAttechment(newId : Int) -> String {
        
        return "\(getCurrentTimeStamp())"
        
    }
    
}


//=================================
//MARK: View controller Extension
//=================================
extension AddJobVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        self.addImageInline(image: (info[.originalImage] as? UIImage)!)
        
        
        let imgStruct = ImageModel(img: (info[.originalImage] as? UIImage)?.resizeImage(targetSize: CGSize(width: 1500.0, height: 1500.0)), id: getTempIdForNewAttechment(newId: 0))
        imgArr.append(imgStruct)
        self.H_JobDes.constant = 150
        
        
       
        stringToHtmlFormate()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        killLoader()
        print("Did cancel")
        self.H_JobDes.constant = 50
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
            
            for (index,model) in self.imgArr.enumerated() {
            let imageId = "_jobAttSeq_\(index)_"
                if imageId != "" {
                     self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
                }
      //  self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
            }
            
            //print(self.stringToHtml)
            
            DispatchQueue.main.async {
                  killLoader()
                print("Successfully converted string to HTML")
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
            
        
//        for (index,pathInside) in urlPaths.enumerated() {
//            let imageId = "_jobAttSeq_\(index)_"
//            if imageId != "" {
//                self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
//            }
//        }
        
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
              //  print("Successfully converted string to HTML")
            }
       // }
    }
}
//===================================
//MARK: NSAttributedString Extension
//===================================
extension NSAttributedString {
    func toHtml() -> String? {
        let documentAttributes = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        do {
            let htmlData = try self.data(from: NSMakeRange(0, self.length), documentAttributes:documentAttributes)
            if let htmlString = String(data:htmlData, encoding:String.Encoding.utf8) {
                return htmlString
            }
        }
        catch {
            print("error creating HTML from Attributed String")
        }
        return nil
    }
}


//===================================
//MARK: String Extension
//===================================
extension String {
    func imagePathsFromHTMLString() -> [String] {
        let regex: NSRegularExpression = try! NSRegularExpression(pattern: "<img.*?src=[\"\']([^\"\']*)[\"\']", options: .caseInsensitive)
        
        var paths = [String]()
        let range = NSMakeRange(0, self.count)
        let imgSources = regex.matches(in: self, options: .withoutAnchoringBounds, range: range)
        
        for imgSrc in imgSources {
            let text = (self as NSString).substring(with: imgSrc.range(at: 1))
            paths.append(text)
           // print(paths)
        }
        // paths.append(text)
        //path.appen
        return paths
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
}

struct ImageModel {
    var img: UIImage?
    var id: String?
    var frmId:String?
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}



    extension String {
        func height123(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

            return ceil(boundingBox.height)
        }

        func width123(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

            return ceil(boundingBox.width)
        }

    }


    extension AddJobVC :  UICollectionViewDelegate, UICollectionViewDataSource{
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return weekdays.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RecurCollectionViewCell
            let recurDay = weekdays[indexPath.row]
            let layout = recurCollectView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.minimumLineSpacing = 10
            
            cell.lblRecurDays.text = recurDay.title
            
            
            if isChecked != false {
                if selectedRows.contains(indexPath.row){
                    
                    cell.btnRecurTap.isSelected = false
                    cell.lblRecurDays.textColor = UIColor(red: 6/256, green: 132/256, blue: 122/256, alpha: 1.0)
                    cell.lblRecurDays.backgroundColor = UIColor(red: 225/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1)
                    
                }else{
                    cell.btnRecurTap.isSelected = true
                    cell.lblRecurDays.textColor = UIColor(red: 248/256, green: 251/256, blue: 251/256, alpha: 1.0)
                    cell.lblRecurDays.backgroundColor = UIColor(red: 6/255.0, green: 132/255.0, blue: 122/255.0, alpha: 1)
                }
            }else{
                if selectedRows.contains(indexPath.row){
                    
                    cell.btnRecurTap.isSelected = true
                    cell.lblRecurDays.textColor = UIColor(red: 248/256, green: 251/256, blue: 251/256, alpha: 1.0)
                    cell.lblRecurDays.backgroundColor = UIColor(red: 6/255.0, green: 132/255.0, blue: 122/255.0, alpha: 1)
                    
                }else{
                    cell.btnRecurTap.isSelected = false
                    cell.lblRecurDays.textColor = UIColor(red: 6/256, green: 132/256, blue: 122/256, alpha: 1.0)
                    cell.lblRecurDays.backgroundColor = UIColor(red: 225/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1)
                }
            }
            
            
            
            
            cell.btnRecurTap.addTarget(self, action: #selector(buttonTapped( sender: )), for: .touchUpInside)
            cell.btnRecurTap.tag = indexPath.row
            
            
            
            return cell
        }
        
        @objc func buttonTapped(sender: UIButton) {
            arrDaysCount.removeAll()
            //var daysDic = [String:Any]()
            if self.selectedRows.contains(sender.tag){
                self.selectedRows.remove(at: self.selectedRows.firstIndex(of: sender.tag)!)
                for day in selectedRows{
                    let id = weekdays[day].id
                    let isSelected = weekdays[day].isSelected
                    // var daysDic = [String:Any]()
                    if id == "1" || id == "1" {
                        daysDic["monday"] = "1"
                    }
                    else if id == "2" {
                        daysDic["tuesday"] = "1"
                    }
                    else if id == "3" {
                        daysDic["wednesday"] = "1"
                    }
                    else if id == "4" {
                        daysDic["thursday"] = "1"
                    }
                    else if id == "5" {
                        daysDic["friday"] = "1"
                    }
                    else if id == "6" {
                        daysDic["saturday"] = "1"
                    }
                    else if id == "7" {
                        daysDic["Ssunday"] = "1"
                    }
                    // print(daysDic)
                    
                    
                    arrDaysCount.append(id)
                    isBoolRecurArr.append(isSelected)
                    // print(id)
                    //print(arrDaysCount.count)
                }
                //print(daysDic)
                
                
                
            }else {
                //var daysDic = [String:Any]()
                self.selectedRows.append(sender.tag)
                for day in selectedRows{
                    let id = weekdays[day].id
                    let isSelected = weekdays[day].isSelected
                    //arrDaysCount.append(id)
                    //var daysDic = [String:Any]()
                    if id == "1" {
                        daysDic["monday"] = "1"
                    }
                    else if id == "2" {
                        daysDic["tuesday"] = "1"
                    }
                    else if id == "3" {
                        daysDic["wednesday"] = "1"
                    }
                    else if id == "4" {
                        daysDic["thursday"] = "1"
                    }
                    else if id == "5" {
                        daysDic["friday"] = "1"
                    }
                    else if id == "6" {
                        daysDic["saturday"] = "1"
                    }
                    else if id == "7" {
                        daysDic["sunday"] = "1"
                    }
                    //print(daysDic)
                   // print(id)
                    arrDaysCount.append(id)
                    isBoolRecurArr.append(isSelected)
                    // print(id)
                   // print(arrDaysCount.count)
                }
               // print(daysDic)
            }
            DispatchQueue.main.async{
                self.recurCollectView.reloadData()
            }
            
        }
       
        
        
    }




