//
//  RescheduleVC.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 24/08/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class RescheduleVC: UIViewController {
    
    
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
    var jobDetailData : UserJobList?
    var sltDate : String? = ""
    var startDates = Bool()
    var startDatee = Bool()
    var startTimes = Bool()
    var startTimee = Bool()
    var isStartScheduleBtn : Bool!
    var isClear = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                         if enableCustomForm == "0"{
                             dateAndTimePickView.locale = Locale.init(identifier: "en_US")
                           
                         }else{
                             dateAndTimePickView.locale = Locale.init(identifier: "en_gb")

                         }
                     }
        
        if jobDetailData?.schdlStart != "" {
            

            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                if enableCustomForm == "0"{
                    let startDate = (jobDetailData?.schdlStart != nil) ? convertTimeStampToString(timestamp: (jobDetailData?.schdlStart!)!, dateFormate: DateFormate.dd_MM_yyyy) : ""
                    
                    
                    if (startDate != "") {
                        let arr = startDate.components(separatedBy: " ")
                        
                        if arr.count > 0 {
                            lblStartDate.text = arr[0]
                            lblStartTime.text = arr[1] + " " + arr[2]
                        }
                    }
                    
                }else{
                    let startDate = (jobDetailData?.schdlStart != nil) ? convertTimeStampToString(timestamp: (jobDetailData?.schdlStart!)!, dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                    
                    
                    if (startDate != "") {
                        let arr = startDate.components(separatedBy: " ")
                        
                        if arr.count > 0 {
                            lblStartDate.text = arr[0]
                            lblStartTime.text = arr[1]
                        }
                    }
                    
                }
            }
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                if enableCustomForm == "0"{
                    
                    let endDate = (jobDetailData?.schdlFinish != nil) ? convertTimeStampToString(timestamp: jobDetailData!.schdlFinish!, dateFormate: DateFormate.dd_MM_yyyy) : ""
                    
                    if (endDate != "") {
                        let arr = endDate.components(separatedBy: " ")
                        
                        if arr.count > 0 {
                            lblEndDate.text = arr[0]
                            lblEndTime.text = arr[1] + " " + arr[2]
                        }
                    }
                    
                }else{
                    
                    let endDate = (jobDetailData?.schdlFinish != nil) ? convertTimeStampToString(timestamp: jobDetailData!.schdlFinish!, dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                    
                    if (endDate != "") {
                        let arr = endDate.components(separatedBy: " ")
                        
                        if arr.count > 0 {
                            lblEndDate.text = arr[0]
                            lblEndTime.text = arr[1]
                        }
                    }
                    
                }
            }
          
        }else{
            DispatchQueue.main.async {
                
                self.lblStartTime.text =  "00:00"
                self.lblStartDate.text =  "dd-MM-yyyy"
                self.lblEndTime.text =  "00:00"
                self.lblEndDate.text =  "dd-MM-yyyy"
                
                
            }
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.reschedule
        
        
        btnCancleDate.setTitle(LanguageKey.cancel , for: .normal)
        btnDoneDate.setTitle(LanguageKey.done , for: .normal)
        btnResheduleDone.setTitle(LanguageKey.reschedule , for: .normal)
        btnClearDate.setTitle(LanguageKey.clear , for: .normal)
        btnRescheduleCancle.setTitle(LanguageKey.cancel , for: .normal)
        
        
        
        lblStartSechedule.text = "\(LanguageKey.shdl_start)"
        lblEndSechedule.text = "\(LanguageKey.shdl_end)"
        
        
        
        
        
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
        
        if isClear == true {
            
            
            ShowAlert(title: LanguageKey.dialog_alert, message: LanguageKey.schedule_date_required, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
            return
        }
        let param = Params()
        
        param.jobId = jobDetailData?.jobId
        param.usrId = getUserDetails()?.usrId
        let schStartDate = String(format: "%@ %@",  (self.lblStartDate.text == nil ? "" : self.lblStartDate.text! ) , (self.lblStartTime.text == nil ? "" : self.lblStartTime.text!))
        let schEndDate = String(format: "%@ %@",  (self.lblEndDate.text == "" ? "" : self.lblEndDate.text!) , (self.lblEndTime.text == "" ? "" : self.lblEndTime.text!) )
        
        
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
                
                param.schdlStart = isClear ? "" : (self.lblStartDate.text! + " " + schTime12)
                param.schdlFinish = isClear ? "" : (self.lblEndDate.text! + " " + endTime12)
             
              
            }
        }else{
            param.schdlStart = ""
            param.schdlFinish = ""
        }
        param.dateTime = currentDateTime24HrsFormate()
        
        let dict = param.toDictionary
        
        //  print(dict)
        
        let searchQuery = "jobId  = '\(jobDetailData?.jobId ?? "")'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            existingJob.schdlStart = convertDateStringToTimestamp(dateString: param.schdlStart!)
            existingJob.schdlFinish = convertDateStringToTimestamp(dateString: param.schdlFinish!)
            
        }
        
        
        DatabaseClass.shared.saveEntity(callback: {isSuccess in
            
        })
        
        // self.jobDetailData?.setValuesForKeys(param.toDictionary!)
        
        
        let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
        userJobs.apis = Service.updateJobSchedule
        userJobs.parametres = dict?.toString
        // print(dict)
        userJobs.time = Date()
        
        DatabaseClass.shared.saveEntity(callback: {_ in
            DatabaseClass.shared.syncDatabase()
            // if self.callbackDetailVC != nil {
            // callbackDetailVC!(false)
            // }
            //        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.navigationController?.popViewController(animated: true)
            //        })
        })
        
    }
    
    
}
