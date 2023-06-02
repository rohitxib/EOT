//
//  LeaveReportVC.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 26/10/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class LeaveReportVC: UIViewController ,SWRevealViewControllerDelegate ,OptionViewDelegate{
    
    
    @IBOutlet weak var showList: UIButton!
    @IBOutlet weak var btnClearDate: UIButton!
    @IBOutlet weak var lblStartSechedule: UILabel!
    @IBOutlet weak var lblEndSechedule: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var btnCancleDate: UIButton!
    @IBOutlet weak var btnResheduleDone: UIButton!
    @IBOutlet weak var btnRescheduleCancle: UIButton!
    @IBOutlet weak var dateAndTimePickView: UIDatePicker!
    @IBOutlet weak var btnDoneDate: UIButton!
    @IBOutlet weak var extraButton: UIBarButtonItem!
    @IBOutlet weak var addNotaLbl: UILabel!
    @IBOutlet weak var addNoteTxtVw: UITextView!
    @IBOutlet weak var addReasonLbl: UILabel!
    @IBOutlet weak var addResonTxtVw: UITextView!
    @IBOutlet weak var userNmTitle: UILabel!
    @IBOutlet weak var userNm: UILabel!
    
    
    var jobDetailData : UserJobList?
    var sltDate : String? = ""
    var startDates = Bool()
    var startDatee = Bool()
    var startTimes = Bool()
    var startTimee = Bool()
    var isStartScheduleBtn : Bool!
    var isClear = false
    
    var viewConArr:[String] = ["1","2","3","4","5","6","7"]
    var optionalVw : OptionalView?
    let cellReuseIdentifier = "cell"
    var sltDropDownTag : Int!
    var ArrUserListLeave = [UserListLeave]()
    var setItId = ""
    var ltIdName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLeaveTypeList()
        
        self.userNm.text = trimString(string: "\(getUserDetails()?.fnm ?? "")")
     //   print(getUserDetails()?.fnm)
        if let revealController = self.revealViewController(){
            revealViewController().delegate = self
            extraButton.target = revealViewController()
            extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealController.tapGestureRecognizer()
        }
      
        
        setUpMethod()
        setLocalization()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func setUpMethod(){
        
        
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
                lblStartDate.text = arr[0]
                lblStartTime.text = arr[1]
                lblEndDate.text = arr[0]
            }else{
                lblStartDate.text = arr[0]
                lblStartTime.text = arr[1] + " " + arr[2]
                lblEndDate.text = arr[0]
            }
            
            let arrOfEndDate = strDate.1.components(separatedBy: " ")
            if arrOfEndDate.count == 2 {
                lblEndDate.text = arrOfEndDate[0]
                lblEndTime.text = arrOfEndDate[1]
            }else{
                lblEndDate.text = arrOfEndDate[0]
                lblEndTime.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
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
                    lblStartDate.text = arr[0]
                    lblStartTime.text = arr[1]
                    lblEndDate.text = arr[0]
                }else{
                    lblStartDate.text = arr[0]
                    lblStartTime.text = arr[1] + " " + arr[2]
                    lblEndDate.text = arr[0]
                }
              
                let arrOfEndDate = strDate.1.components(separatedBy: " ")
                if arrOfEndDate.count == 2 {
                    lblEndDate.text = arrOfEndDate[0]
                    lblEndTime.text = arrOfEndDate[1]
                }else{
                    lblEndDate.text = arrOfEndDate[0]
                    lblEndTime.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
                }
                
            }
        }
    }
    
    func setLocalization() -> Void {
        
        self.navigationItem.title = LanguageKey.add_leave
        btnCancleDate.setTitle(LanguageKey.cancel , for: .normal)
        btnDoneDate.setTitle(LanguageKey.done , for: .normal)
        btnResheduleDone.setTitle(LanguageKey.add_leave , for: .normal)
        btnClearDate.setTitle(LanguageKey.clear , for: .normal)
        btnRescheduleCancle.setTitle(LanguageKey.cancel , for: .normal)
        lblStartSechedule.text = "\(LanguageKey.shdl_start)"
        lblEndSechedule.text = "\(LanguageKey.shdl_end)"
        addNotaLbl.text = "\(LanguageKey.add_notes_leave)"
        addReasonLbl.text = "\(LanguageKey.add_reason_leave)"
        showList.setTitle(LanguageKey.select_leave_type , for: .normal)
     
  
    }
    
    @IBAction func btnClearDateAction(_ sender: Any) {
        isClear = true
        DispatchQueue.main.async {
            self.lblStartTime.text =  "00:00"
            self.lblStartDate.text =  "dd-MM-yyyy"
            self.lblEndTime.text =  "00:00"
            self.lblEndDate.text =  "dd-MM-yyyy"
        }
    }
    
    @IBAction func showLisrActn(_ sender: UIButton) {
       
        self.sltDropDownTag = sender.tag
        switch  sender.tag {
   
        case 0:
            if(self.optionalVw == nil){
                
                self.openDwopDown(Buttion:showList,arr: viewConArr)
             
            }else{
                self.removeOptionalView()
            }
            break
            
        default:
            //   print("Defalt")
            break
        }
        
        
    }
    
    
    @IBAction func btnOpenStartDate(_ sender: Any) {
        isStartScheduleBtn = true
        self.datePickerView.isHidden = false
        self.showDateAndTimePicker()
    }
    
    @IBAction func btnopenEndDate(_ sender: Any) {
        isStartScheduleBtn = false
        self.datePickerView.isHidden = false
        self.showDateAndTimePicker()
    }
    
    @IBAction func btnCancle(_ sender: Any) {
        self.datePickerView.isHidden = true
    }
    
    @IBAction func btnRescheduleCancle(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func btnRescheduleDone(_ sender: Any) {
        updateResourceOnJobOffline()
        
    }
    
    @IBAction func btnDone(_ sender: Any) {
        
        
        
        isClear = false
        
        self.datePickerView.isHidden = true
        let date = self.dateAndTimePickView.date
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
                lblStartDate.text = arr[0]
                lblStartTime.text = arr[1]
            }else{
                lblStartDate.text = arr[0]
                lblStartTime.text = arr[1] + " " + arr[2]
            }
            
            
            
        }else{
            
            
            let schStartDate = self.lblStartDate.text! + " " +  self.lblStartTime.text!
            
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                if enableCustomForm == "0"{
                    let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy)
                    if(value == "orderedDescending"){
                        ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                    }else{
                        let arr = strDate.components(separatedBy: " ")
                        
                        if arr.count == 2 {
                            lblEndDate.text = arr[0]
                            lblEndTime.text = arr[1]
                            
                        }else{
                            lblEndDate.text = arr[0]
                            lblEndTime.text = arr[1] + " " + arr[2]
                        }
                    }
                }else{
                    let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy_HH_mm)
                    if(value == "orderedDescending"){
                        ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                    }else{
                        let arr = strDate.components(separatedBy: " ")
                        
                        if arr.count == 2 {
                            lblEndDate.text = arr[0]
                            lblEndTime.text = arr[1]
                            
                        }else{
                            lblEndDate.text = arr[0]
                            lblEndTime.text = arr[1]
                        }
                    }
                }
            }
           
        }
        
        
    }
    
    
    func showDateAndTimePicker(){
        // self.dateAndTimePicker.minimumDate = Date()
        self.datePickerView.isHidden = false
        UIView.animate(withDuration: 0.2)  {
            let frame = CGRect(x: 0, y: self.view.frame.size.height - 240, width: self.view.frame.size.width, height: 240)
            self.datePickerView.frame = frame
            
        }
    }
    
    
    func updateResourceOnJobOffline(){
        
     
        let param = Params()
        var parm = [String: Any]()
        var memId = [String]()
        memId.append((getUserDetails()?.usrId)!)
      //  memId.append(ltIdName)
        parm["usrId"] = memId
      
        let schStartDate = String(format: "%@ %@",  (self.lblStartDate.text == nil ? "" : self.lblStartDate.text! ) , (self.lblStartTime.text == nil ? "" : self.lblStartTime.text!))
        let schEndDate = String(format: "%@ %@",  (self.lblEndDate.text == "" ? "" : self.lblEndDate.text!) , (self.lblEndTime.text == "" ? "" : self.lblEndTime.text!) )
        
        
        var schTime12 = ""
        var endTime12 = ""
        
        if isClear == false{
            
            if schStartDate == "yyyy-MM-dd 00:00"{
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectStartDate, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                return
            }
            
            if schEndDate == "yyyy-MM-dd 00:00"{
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
                
                //
                if let langCode = getCurrentSelectedLanguageCode() {
                    dateFormatter.locale = Locale(identifier: langCode)
                }
                let date = dateFormatter.date(from: self.lblStartTime.text!)
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
                
                //dateFormatter1.dateFormat = "h:mm a"
                if let langCode = getCurrentSelectedLanguageCode() {
                    dateFormatter1.locale = Locale(identifier: langCode)
                }
                let date1 = dateFormatter1.date(from: self.lblEndTime.text!)
                dateFormatter1.dateFormat = "HH:mm:ss"
                endTime12 = dateFormatter1.string(from: date1!)
                //print(endTime12)
                
               // param.startDateTime = isClear ? "" : (self.lblStartDate.text! + " " + schTime12)
              //  param.finishDateTime = isClear ? "" : (self.lblEndDate.text! + " " + endTime12)
                parm["startDateTime"] = isClear ? "" : (self.lblStartDate.text! + " " + schTime12)
                parm["finishDateTime"] = isClear ? "" : (self.lblEndDate.text! + " " + endTime12)
                
            }
        }else{
            parm["startDateTime"] = ""
            parm["finishDateTime"] = ""
            
            param.startDateTime = ""
            param.finishDateTime = ""
        }
        
        parm["reason"] = trimString(string: addResonTxtVw.text!)
        parm["note"] = trimString(string: addNoteTxtVw.text!)
        parm["ltId"] = setItId
        
        let strdate = isClear ? "" : (self.lblStartDate.text! + " " + schTime12)
        let endDate = isClear ? "" : (self.lblEndDate.text! + " " + endTime12)
        print(parm)
        showLoader()
        
        let msg = "User is already on leave for time duration"+"\(strdate)"+" to "+"\(endDate)"+", please create leave after the time period "+"\(endDate)."
        serverCommunicator(url: Service.addLeave, param: parm) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(CommonResponseLeave.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        
                        DispatchQueue.main.async {
                            
                            self.showToast(message: "Leave added Successfully")
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }else{
                        self.showToast(message: decodedData.message!)
                    }
                }else{
                    
                    ShowError(message: "\(msg)", controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
        
    }
    
    
    func openDwopDown(Buttion : UIButton , arr : [Any]) {
        
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = Buttion.convert(Buttion.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
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
        }
    }
    
    //=====================================
    // MARK:- Optional view Detegate
    //=====================================
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return menus.count
    //    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            return ArrUserListLeave.count
     
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        cell?.textLabel?.textColor = UIColor.darkGray
        
        let language = ArrUserListLeave[indexPath.row].leaveType
        cell?.textLabel?.text = language
        
        return cell!
    }
    
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.setItId = ArrUserListLeave[indexPath.row].ltId ?? ""
        self.ltIdName = ArrUserListLeave[indexPath.row].leaveType ?? ""
        showList.setTitle(ltIdName, for: .normal)
       /// print(ltIdName)
        self.removeOptionalView()
    }
   
    
    func getLeaveTypeList() {
        
        let param = Params()
        param.limit = "120"
        param.index = "0"
        
        serverCommunicator(url: Service.getLeaveTypeList, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(ResponseUserListLeave.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                   
                        
                        DispatchQueue.main.async {
                            
                            self.ArrUserListLeave  = decodedData.data as! [UserListLeave]
                            
                        }
                        
                                                        }
                    }else{
                        
                        ShowError(message: AlertMessage.formatProblem, controller: windowController)
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
                }
            }
            
        }
        
}


