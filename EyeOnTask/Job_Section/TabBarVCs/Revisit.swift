//
//  Revisit.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 21/08/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class Revisit: UIViewController , UITextFieldDelegate , OptionViewDelegate {
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var addTagTxtFld: UITextField!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var schedulrStart: UILabel!
    @IBOutlet weak var schedulerEnd: UILabel!
    
    @IBOutlet weak var addFildWkr: UITextField!
    @IBOutlet weak var asiinTo: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bigVw: UIView!
    @IBOutlet weak var endTimeTxtFld: UILabel!
    @IBOutlet weak var endDateTxtFld: UILabel!
    @IBOutlet weak var startTimeTxtFld: UILabel!
    @IBOutlet weak var startDateTxtFld: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var tagTxtFld: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchDropDwnView: UIView!
    @IBOutlet weak var searchBackBtn: UIButton!
    @IBOutlet weak var mediumTxtFld: FloatLabelTextField!
    @IBOutlet weak var tagView: ASJTagsView!
    @IBOutlet weak var jobInstrctTxtFld: FloatLabelTextField!
    @IBOutlet weak var disTxtFld: FloatLabelTextField!
    @IBOutlet weak var jobType: FloatLabelTextField!
    
    var arrr : UserJobList?
    var isStartScheduleBtn : Bool!
    var optionalVw : OptionalView?
    var isClear  = false
    var FltWorkerId = [String]()
    let param = Params()
    var arra = [Any]()
    var searcharra = [Any]()
    var searcharraisbol = false
    let cellReuseIdentifier = "cell"
    let arrOfPriroty = ["Low" , "Medium" , "High"]
    var arrOfShowData = [Any]()
    var sltDropDownBtnTag : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
              if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                  if enableCustomForm == "0"{
                      datePicker.locale = Locale.init(identifier: "en_US")
                    
                  }else{
                      datePicker.locale = Locale.init(identifier: "en_gb")

                  }
              }
        
        setUpMethod()
        setLocalization()
        self.jobInstrctTxtFld.text = arrr?.inst
        self.disTxtFld.text = arrr?.des
        self.jobType.text = arrr?.kpr
        let kpr = arrr?.kpr?.components(separatedBy: ",")
        
        
        
        if arrr?.kpr != "" {
            for i in kpr! {
                
                let searchQueryFld = "usrId = '\(i)'"
                let tagData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: searchQueryFld) as! [FieldWorkerDetails]
                
                if tagData.count > 0 {
                    let tag = tagData[0]
                    
                    
                    DispatchQueue.main.async {
                        self.createTags(strName: (tag.fnm)!, view: self.tagView)
                    }
                    
                    
                    self.FltWorkerId.append(tag.usrId!)
                    
                }
                
            }
        }
        
        let ardsr = arrr?.schdlFinish?.components(separatedBy: " ")
        
        let ardr = arrr?.schdlStart?.components(separatedBy: " ")
        
     
               let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable //This is round off digit for invoice
                  if enableCustomForm == "0"{
                    let startDate = (arrr?.schdlStart != nil) ? convertTimeStampToString(timestamp: (arrr?.schdlStart)!, dateFormate: DateFormate.dd_MM_yyyy) : ""
                    if (startDate != "") {
                             let arr = startDate.components(separatedBy: " ")
                             
                             if arr.count > 0 {
                                 startDateTxtFld.text = arr[0]
                                 startTimeTxtFld.text = arr[1] + " " + arr[2]
                             }
                         }
                         
                  }else{
                      if (arrr?.schdlStart != "") {
                          let startDate = (arrr?.schdlStart != nil) ? convertTimeStampToString(timestamp: (arrr?.schdlStart)!, dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                          
                          if (startDate != "") {
                              let arr = startDate.components(separatedBy: " ")
                              
                              if arr.count > 0 {
                                  startDateTxtFld.text = arr[0]
                                  startTimeTxtFld.text = arr[1]
                              }else{
                                  startDateTxtFld.text = ""
                                  startTimeTxtFld.text = ""
                              }
                          }
                      }
                      
                  }
              
        let enableCustomForm1 = getDefaultSettings()?.is24hrFormatEnable //This is round off digit for invoice
        if enableCustomForm1 == "0"{
            let endDate = (arrr?.schdlFinish != nil) ? convertTimeStampToString(timestamp: (arrr?.schdlFinish)!, dateFormate: DateFormate.dd_MM_yyyy) : ""
                   
                   
                   if (endDate != "") {
                       let arr = endDate.components(separatedBy: " ")
                       
                       if arr.count > 0 {
                           endDateTxtFld.text = arr[0]
                           endTimeTxtFld.text = arr[1] + " " + arr[2]
                       }
                   }
        }else{
            if (arrr?.schdlStart != "") {
                
                let endDate = (arrr?.schdlFinish != nil) ? convertTimeStampToString(timestamp: (arrr?.schdlFinish)!, dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                
                
                if (endDate != "") {
                    let arr = endDate.components(separatedBy: " ")
                    
                    if arr.count > 0 {
                        endDateTxtFld.text = arr[0]
                        endTimeTxtFld.text = arr[1]
                    }
                }
            }else{
                startDateTxtFld.text = ""
                startTimeTxtFld.text = ""
            }
        }
     
        arra = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
        self.searchDropDwnView.isHidden = true
        self.searchBackBtn.isHidden = true
        
        
        if param.jtId == nil {
            param.jtId = [jtIdParam]()
        }
        if arrr?.jtId != nil {
            for kprData in (arrr?.jtId as! [AnyObject]) {
                //  let searchQueryFld = "usrId = '\((kprData as! [String:String])["title"] ?? "")'"
                
                
                let jt = jtIdParam()
                jt.jtId = (kprData as! [String:String])["jtId"] ?? ""
                jt.title = (kprData as! [String:String])["title"] ?? ""
                
                //                let isExist =  param.jtId?.contains{ ( arry : jtIdParam) -> Bool in
                //                    if arry.jtId == jt.jtId{
                //                        return true
                //                    }
                //                    return false
                //                }
                param.jtId?.append(jt)
                //                if !isExist!{
                //cel
                //                }else{
                //                    let objIndex : Int? = param.jtId?.firstIndex(where: { (jtData : jtIdParam) -> Bool in
                //                        if jt.jtId == jtData.jtId{
                //                            return true
                //                        }else{
                //                            return false
                //                        }
                //                    })
                //                    if (objIndex != nil){
                //                        param.jtId?.remove(at: objIndex!)
                //                    }
                //                }
                
                if (param.jtId != nil && param.jtId!.count > 0) {
                    
                    var strTitle = ""
                    for jtid in param.jtId! {
                        if strTitle == ""{
                            strTitle = jtid.title ?? ""
                        }else{
                            strTitle = "\(strTitle), \(jtid.title ?? "")"
                            
                        }
                        DispatchQueue.main.async {
                            self.jobType.text = strTitle
                        }
                        
                    }
                }else{
                    self.jobType.text = ""
                }
            }
            
            
            
            
        }
        // Do any additional setup after loading the view.
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.revisit
        
        /////////
        
        
        submitBtn.setTitle(LanguageKey.revisit , for: .normal)
        doneBtn.setTitle(LanguageKey.done , for: .normal)
        cancelBtn.setTitle(LanguageKey.cancel , for: .normal)
        clearBtn.setTitle(LanguageKey.clear , for: .normal)
        // searchBackBtn.setTitle(LanguageKey.search , for: .normal)
        
        
        
        mediumTxtFld.placeholder = LanguageKey.job_priority
        jobInstrctTxtFld.placeholder = LanguageKey.job_inst
        disTxtFld.placeholder = LanguageKey.job_desc
        jobType.placeholder = LanguageKey.Job_title
        
        tags.text = "\(LanguageKey.assign_to)"
        schedulrStart.text = "\(LanguageKey.shdl_start)"
        schedulrStart.text = "\(LanguageKey.shdl_end)"
        asiinTo.text = "\(LanguageKey.tags)"
        addTagTxtFld.placeholder = LanguageKey.add_tag
        addFildWkr.placeholder = LanguageKey.add_fieldworker
        addBtn.setTitle(LanguageKey.add , for: .normal)
        
        
        
        
    }
    
    func setUpMethod(){
        
        
        //          if getDefaultSettings()?.isJobLatLngEnable == "0" {
        //              H_lattitude.constant = 0.0
        //          }
        //
        //          if getDefaultSettings()?.isLandmarkEnable == "0" {
        //              H_landmark.constant = 0.0
        //          }
        
        
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
                startDateTxtFld.text = arr[0]
                startTimeTxtFld.text = arr[1]
                endDateTxtFld.text = arr[0]
            }else{
                startDateTxtFld.text = arr[0]
                startTimeTxtFld.text = arr[1] + " " + arr[2]
                endDateTxtFld.text = arr[0]
            }
            
            let arrOfEndDate = strDate.1.components(separatedBy: " ")
            if arrOfEndDate.count == 2 {
                endDateTxtFld.text = arrOfEndDate[0]
                endTimeTxtFld.text = arrOfEndDate[1]
            }else{
                endDateTxtFld.text = arrOfEndDate[0]
                endTimeTxtFld.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
            }
            
            
            
            
        }else{
            let adminSchTime : String? = getDefaultSettings()?.jobSchedule
            if(adminSchTime != "" && adminSchTime != nil){
                // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
                         var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
                         duration = updateDefaultTime(duration ?? "01:00")
                let arrOFDurationTime = duration?.components(separatedBy: ":")
                            //getSchStartandEndDateAndTimeForSchDate
                let strDate = getSchStartandEndDateAndTimeForSchDate(timeInterval: (getDefaultSettings()?.jobSchedule)!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
                
                
                let arr = strDate.0.components(separatedBy: " ")
                if arr.count == 2 {
                    startDateTxtFld.text = arr[0]
                    startTimeTxtFld.text = arr[1]
                    endDateTxtFld.text = arr[0]
                }else{
                    startDateTxtFld.text = arr[0]
                    startTimeTxtFld.text = arr[1] + " " + arr[2]
                    endDateTxtFld.text = arr[0]
                }
                
                
                
                let arrOfEndDate = strDate.1.components(separatedBy: " ")
                if arrOfEndDate.count == 2 {
                    endDateTxtFld.text = arrOfEndDate[0]
                    endTimeTxtFld.text = arrOfEndDate[1]
                }else{
                    endDateTxtFld.text = arrOfEndDate[0]
                    endTimeTxtFld.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
                }
                
                
            }
        }
    }
    
    
    @IBAction func submiteBtn(_ sender: Any) {
        
        
        addJob()
        
    }
    @IBAction func endSedulerBtn(_ sender: Any) {
        
        removeOptionalView()
        isStartScheduleBtn = false
        self.bigVw.isHidden = false
        self.showDateAndTimePicker()
    }
    @IBAction func startsedulerBrn(_ sender: Any) {
        
        removeOptionalView()
        isStartScheduleBtn = true
        self.bigVw.isHidden = false
        self.showDateAndTimePicker()
    }
    @IBAction func cleaBtn(_ sender: Any) {
        
        isClear = true
        DispatchQueue.main.async {
            self.startTimeTxtFld.text =  "00:00"
            self.startDateTxtFld.text =  "dd-MM-yyyy"
            self.endTimeTxtFld.text =  "00:00"
            self.endDateTxtFld.text =  "dd-MM-yyyy"
        }
    }
    
    @IBAction func DoneBtn(_ sender: Any) {
        
        
        isClear = false
        
        self.bigVw.isHidden = true
        let date = self.datePicker.date
        let formatter = DateFormatter()
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                formatter.dateFormat = "dd-MM-yyyy h:mm a"
            }else{
                formatter.dateFormat = "dd-MM-yyyy HH:mm"
            }
        }
        
        formatter.timeZone = TimeZone.current
        
        if let langCode = getCurrentSelectedLanguageCode() {
            formatter.locale = Locale(identifier: langCode)
        }
        
        let strDate = formatter.string(from: date)
        if(isStartScheduleBtn){
            let arr = strDate.components(separatedBy: " ")
            
            if arr.count == 2 {
                startDateTxtFld.text = arr[0]
                startTimeTxtFld.text = arr[1]
            }else{
                startDateTxtFld.text = arr[0]
                startTimeTxtFld.text = arr[1] + " " + arr[2]
            }
            
            
            
        }else{
            
            
            let schStartDate = self.startDateTxtFld.text! + " " +  self.startTimeTxtFld.text!
            
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                
                
                let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy)
                if(value == "orderedDescending"){
                    ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                }else{
                    let arr = strDate.components(separatedBy: " ")
                    
                    if arr.count == 2 {
                        endDateTxtFld.text = arr[0]
                        endTimeTxtFld.text = arr[1]
                    }else{
                        endDateTxtFld.text = arr[0]
                        endTimeTxtFld.text = arr[1] + " " + arr[2]
                    }
                }
                
                }else
            {
                
                let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy_HH_mm)
                if(value == "orderedDescending"){
                    ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                }else{
                    let arr = strDate.components(separatedBy: " ")
                    
                    if arr.count == 2 {
                        endDateTxtFld.text = arr[0]
                        endTimeTxtFld.text = arr[1]
                    }else{
                        endDateTxtFld.text = arr[0]
                        endTimeTxtFld.text = arr[1] + " " + arr[2]
                    }
                }
                
                }
            }
            
            
            
        }
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        
        self.bigVw.isHidden = true
    }
    @IBAction func mediumBtn(_ sender: Any) {
    }
    @IBAction func jobType(_ sender: UIButton) {
        searcharraisbol = false
        self.tableView.reloadData()
        self.sltDropDownBtnTag  = sender.tag
        self.callMethodforOpenDwop(tag: sender.tag)
    }
    
    
    func showDateAndTimePicker(){
        // self.dateAndTimePicker.minimumDate = Date()
        self.bigVw.isHidden = false
        UIView.animate(withDuration: 0.2)  {
            let frame = CGRect(x: 0, y: self.view.frame.size.height - 240, width: self.view.frame.size.width, height: 240)
            self.bigVw.frame = frame
            
        }
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
            
        case 7:
            
            
            
            if(self.optionalVw == nil){
                self.arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
                if(arrOfShowData.count > 0){
                    self.openDwopDown(txtField: self.tagTxtFld, arr: self.arrOfShowData)
                }
                //                else{
                //                    ShowError(message: AlertMessage.noFieldWorkerAvailable , controller: windowController)
                //                }
            }else{
                self.removeOptionalView()
                
            }
            
            
            
            
            
            break
        case 1:
            
            self.openDwopDown( txtField: self.mediumTxtFld, arr: arrOfPriroty)
            break
            
        default:
            return
        }
    }
    
    
    @IBAction func searchBtn(_ sender: Any) {
        
        self.searchDropDwnView.isHidden = true
        self.searchBackBtn.isHidden = true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // self.sltTxtField = textField
        self.sltDropDownBtnTag = textField.tag
        
        self.removeOptionalView()
    }
    
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height), width: self.view.frame.size.width - 20, height: CGFloat((arr.count > 5) ? 150 : arr.count*38)))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            //  self.scroll_View.isScrollEnabled = false
            
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
            // self.scroll_View.isScrollEnabled = false
            
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
            // self.scroll_View.isScrollEnabled = true
            // self.FltArrClintList.removeAll()
        }
    }
    
    func getArrForOptionalView( ) -> [Any]{
        switch self.sltDropDownBtnTag {
        case 0:
            return arrOfShowData
        case 1:
            return arrOfPriroty
            //        case 2:
            //            return FltArrClintList.count != 0 ? FltArrClintList : arrClintList
            //        case 3:
            //            return arrOfShowData
            //        case 4:
            //            return arrOfShowData
            //        case 5:
            //            return arrOfShowData
            //        case 6:
        //            return arrOfShowData
        case 7:
            return  arrOfShowData
            //        case 8:
        //            return  arrOfShowData
        default:
            return [""]
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.sltDropDownBtnTag = textField.tag
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        
        switch self.sltDropDownBtnTag {
            
            
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
            
        case 7 :
            
            let bPredicate: NSPredicate = NSPredicate(format: "self.fnm beginswith[c] '%@'", result)
            
            let allFldWorkerNm = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
            arrOfShowData =  (allFldWorkerNm as NSArray).filtered(using: bPredicate)
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.tagTxtFld, arr: arrOfShowData)
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
            
        default:
            
            break
        }
        
        
        
        return true
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
        case 7:
            //
            //                if(self.optionalVw == nil){
            //                              self.arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
            //                                if(arrOfShowData.count > 0){
            //                                    self.openDwopDown(txtField: self.tagTxtFld, arr: self.arrOfShowData)
            //                                }
            //                //                else{
            //                //                    ShowError(message: AlertMessage.noFieldWorkerAvailable , controller: windowController)
            //                //                }
            //                            }else{
            //                                self.removeOptionalView()
            //
            //                            }
            //
            //
            //
            //
            //    //            let jobTittleListData  =  arrOfShowData[indexPath.row] as? UserJobTittleNm
            //    //
            //    ////            let isExist = param.jtId?.contains{$0.jtId == jobTittleListData?.jtId}
            //    ////
            //    ////            if isExist! {
            //    ////                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            //    ////            }else {
            //    ////                cell?.accessoryType = UITableViewCell.AccessoryType.none
            //    ////            }
            //    //
            //    //
            //    //            _ =  param.jtId?.contains{ ( arry : jtIdParam) -> Bool in
            //    //                if arry.jtId == jobTittleListData?.jtId{
            //    //                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            //    //                    return true
            //    //                }else{
            //    //                    cell?.accessoryType = UITableViewCell.AccessoryType.none
            //    //                    return false
            //    //                }
            //    //            }
            //    //
            //    //            cell?.textLabel?.text = jobTittleListData?.title?.capitalizingFirstLetter()
            cell?.textLabel?.text = (self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.fnm?.capitalizingFirstLetter()
            break
        case 1:
            cell?.textLabel?.text = arrOfPriroty[indexPath.row].capitalizingFirstLetter()
            break
            
            //            case 2:
            //               let clintList = self.FltArrClintList.count != 0 ? self.FltArrClintList[indexPath.row] : arrClintList[indexPath.row]
            //
            //               cell?.textLabel?.text = clintList.nm?.capitalizingFirstLetter()
            //                break
            //
            //            case 3:
            //                let cltAllContactList  =  arrOfShowData[indexPath.row] as? ClientContactList
            //                cell?.textLabel?.text = cltAllContactList?.cnm?.capitalizingFirstLetter()
            //                break
            //
            //            case 4:
            //                let cltAllSiteList  =  arrOfShowData[indexPath.row] as? ClientSitList
            //                cell?.textLabel?.text = cltAllSiteList?.snm?.capitalizingFirstLetter()
            //                break
            //
            //            case 5:
            //                if(arrOfShowData.count > 0){
            //                     cell?.textLabel?.text =  ((arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
            //                }
            //                break
            //
            //            case 6:
            //                if(arrOfShowData.count > 0){
            //                        cell?.textLabel?.text =  ((arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
            //                }
            //
            //                break
            //
            //            case 7:
            //                cell?.textLabel?.text = (self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.fnm?.capitalizingFirstLetter()
            //                break
            //            case 8:
            //                cell?.textLabel?.text = (self.arrOfShowData[indexPath.row] as? TagsList)?.tnm?.capitalizingFirstLetter()
        //                break
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
            self.mediumTxtFld.text = self.arrOfPriroty[indexPath.row]
            break
            
        case 7:
            
            let isExist = self.FltWorkerId.contains(((self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.usrId)!)
            if(!isExist){
                createTags(strName: ((self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.fnm)!, view: self.tagView)
                self.FltWorkerId.append(((self.arrOfShowData[indexPath.row] as? FieldWorkerDetails)?.usrId)!)
            }
            self.tagTxtFld.text = ""
            break
            
            
            
            
        default: break
            
        }
        self.removeOptionalView()
    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
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
        
        // let searchQuery = "jobId = 'Job-\(newId)'"
        //        let searchQuery = String.init(format: "parametres contains[c] '\"jobId\":\"Job-%d\'",newId)
        //        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineList", query: searchQuery) as! [OfflineList]
        //        if isExist.count == 0 {
        //            return "Job-\(newId)"
        //        }else{
        //           return getTempIdForNewJob(newId: newId + 1)
        //        }
    }
    func addJob(){
        
        let temp = getTempIdForNewJob(newId: 0)
        param.tempId = temp
        param.jobId = temp
        param.contrId = arrr?.contrId == nil ?  "" : arrr?.contrId
        param.adr = arrr?.adr == nil ?  "" : arrr?.adr //self.txtfld_Address.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.athr = getUserDetails()?.usrId
        param.city = arrr?.city == nil ?  "" : arrr?.city
        param.cltId =  arrr?.cltId == nil ?  "" : arrr?.cltId
        param.conId =  arrr?.conId == nil ? "" :  arrr?.conId
        param.siteId = arrr?.siteId == nil ? "" : arrr?.siteId
        param.ctry = arrr?.ctry
        param.state = arrr?.state
        param.zip = arrr?.zip
        param.cnm = (arrr?.conId == "" ?  (arrr?.cnm == "" ? "self" : arrr?.cnm) : "")
        param.snm = arrr?.siteId == "" ? arrr?.snm : ""
        
        
        param.des =  disTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.email = arrr?.email
        param.inst = self.jobInstrctTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        ///param.jtId = param.jtId == nil ?  "" : param.jtId
        
        
        
        param.kpr = FltWorkerId.count == 0 ? "" : (FltWorkerId.count == 1 ? FltWorkerId[0] : "")
        param.mob1 = arrr?.mob1// == "" ? arrr?.snm : ""
        param.mob2 = ""
        param.parentId = arrr?.jobId
        param.prty =  String(format: "%d",getPriortyRawValueAccordingToText(txt: (mediumTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)) // no
        param.quotId = arrr?.quotId == nil ? "" :  arrr?.quotId
        //param.siteId = param.siteId == nil ? "" : param.siteId
        //  param.snm = param.siteId == "" ? param.snm : ""
        param.status = "1"
        param.type = FltWorkerId.count == 0 ? "1"  : (FltWorkerId.count == 1 ? "1" : "2")// no
        // param.zip = self.txtfld_PostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.updateDate = String(Int(Date().timeIntervalSince1970))
        //param.title = self.txtfldJobTitle.text
        
        
        let schStartDate = String(format: "%@ %@",  (self.startDateTxtFld.text == nil ? "" : self.startDateTxtFld.text! ) , (self.startDateTxtFld.text == nil ? "" : self.startDateTxtFld.text!))
        let schEndDate = String(format: "%@ %@",  (self.endDateTxtFld.text == "" ? "" : self.endDateTxtFld.text!) , (self.endTimeTxtFld.text == "" ? "" : self.endTimeTxtFld.text!) )
        
        
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
                let date = dateFormatter.date(from: self.startTimeTxtFld.text!)
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
              //  dateFormatter1.dateFormat = "h:mm a"
                if let langCode = getCurrentSelectedLanguageCode() {
                    dateFormatter1.locale = Locale(identifier: langCode)
                }
                let date1 = dateFormatter1.date(from: self.endTimeTxtFld.text!)
                dateFormatter1.dateFormat = "HH:mm:ss"
                endTime12 = dateFormatter1.string(from: date1!)
                //print(endTime12)
                
                param.schdlStart = isClear ? "" : (self.startDateTxtFld.text! + " " + schTime12)
                param.schdlFinish = isClear ? "" : (self.endDateTxtFld.text! + " " + endTime12)
                
                //2018-08-09 15:27:00
                
                //
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
        
        
        // param.tagData = arrOfaddTags.count == 0 ? [] : arrOfaddTags
        // param.lat = latitued.text
        // param.lng = longitued.text
        // param.landmark = trimString(string: txt_landmark.text!)
        
        let isExist = self.FltWorkerId.contains((getUserDetails()?.usrId)!)
        if(isExist){
            //                let userJobs = DatabaseClass.shared.createEntity(entityName: "UserJobList")
            //                userJobs?.setValuesForKeys(param.toDictionary!)
            //                DatabaseClass.shared.saveEntity(callback: {_ in
            ////                    if self.callbackForJobVC != nil {
            ////                        self.callbackForJobVC!(true)
            ////                    }
            //                })
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
        
        
        
        //  param.schdlStart = isClear ? "" : (self.lbl_SrtSchDate.text! + " " + schTime12)
        //  param.schdlFinish = isClear ? "" : (self.lbl_EndSchDate.text! + " " + endTime12)
        
        if isClear {
            param.schdlStart =  ""
            param.schdlFinish =  ""
        }else{
            
            param.schdlStart = convertDateToStringForServerAddJob(dateStr: (self.startDateTxtFld.text! + " " + schTime12))
            param.schdlFinish = convertDateToStringForServerAddJob(dateStr: (self.endDateTxtFld.text! + " " + endTime12))
        }
        
        
        param.nm =  param.cltId == "" ? arrr?.nm : ""
        param.compId = getUserDetails()?.compId
        param.memIds =  (FltWorkerId.count == 0 ? [] : (FltWorkerId.count == 1 ? [] : FltWorkerId))
        //  param.clientForFuture =  isClintFutUser ? "1" : "0"
        // param.siteForFuture = (isSitFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
        // param.contactForFuture = (isContactFutUser ? "1" : ( isClintFutUser ? "1" : "0"))
        // param.tagData = arrOfaddTags.count == 0 ? [] : arrOfaddTags as! [[String : String]]
        param.pymtType = ""
        param.gstNo = ""
        param.tinNo = ""
        param.industry = ""
        param.note = ""
        param.fax = ""
        param.twitter = ""
        param.skype = ""
        param.tempId = arrr?.jobId
        
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
    
    
}
extension Revisit : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searcharraisbol ? searcharra.count : arra.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        
        cell?.backgroundColor = .clear
        //cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
        
        
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        let jobTittleListData  = searcharraisbol ? searcharra[indexPath.row] as? UserJobTittleNm : arra[indexPath.row] as? UserJobTittleNm
        
        //            let isExist = param.jtId?.contains{$0.jtId == jobTittleListData?.jtId}
        //
        //            if isExist! {
        //                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
        //            }else {
        //                cell?.accessoryType = UITableViewCell.AccessoryType.none
        //            }
        
        
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
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.textLabel?.textColor = UIColor.darkGray
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
                    self.jobType.text = strTitle
                }
                
            }
        }else{
            self.jobType.text = ""
        }
        
        tableView.reloadData()
        
        self.searchDropDwnView.isHidden = true
        self.searchBackBtn.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}





