//
//  CoustomField.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 24/09/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class CoustomField: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate , UITextViewDelegate{

   
    @IBOutlet var footerView: UIView!
    @IBOutlet var lbl_AlertMess: UILabel!
    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var btnSubmitOrSave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var btnSkip_W: NSLayoutConstraint!
    @IBOutlet weak var skipBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var submitBtnHeight: NSLayoutConstraint!
    @IBOutlet var footerViewHeight: NSLayoutConstraint!
    var arrOfShowDatas : GetDetail?
    var txtFieldData : String?
    var txtViewData : String?
    //  var fff : arrOfShowDatas?
    var objOFTestVC : TestDetails?
    var arrOfShowData = [CustomFormDetals]()
    var sltFormIdx : Int?
    var sltQuestNo : String?
    var sltNaviCount : Int?
    var customVCArr = [CustomDataRes]()
    var callBackFofDetailJob: ((Bool) -> Void)?
    var clickedEvent : Int?
    var objOfUserJobList = UserJobList()
    var isCameFrmStatusBtnClk : Bool!
    var selectedTxtField : UITextField?
    var arr = [getQuestionsBy]()
    var ant = [Any]()
    var ass = String()
    var getfrmId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocalization()
        getFormDetail()
        
        if objOFTestVC?.mandatory == "1"{
            
            self.btnSkip.isHidden = true
            self.btnSkip_W.constant = self.btnSkip_W.constant + 144
            self.btnSubmitOrSave.setTitle(LanguageKey.submit_btn, for: .normal)
            self.btnSubmitOrSave.superview!.setNeedsLayout()
            self.btnSubmitOrSave.superview!.layoutIfNeeded()
        }
        
        btnSkip.setTitle(LanguageKey.skip, for: .normal)
        
        if(self.arrOfShowData.count == 0){
            self.navigationItem.title = LanguageKey.title_cutom_field
            btnSubmitOrSave.setTitle(LanguageKey.submit_btn, for: .normal)
            //self.getQuestionsByParentId()
            
        }else{
            DispatchQueue.main.async() {
                self.navigationItem.title = LanguageKey.title_cutom_field
                self.btnSubmitOrSave.setTitle(LanguageKey.save_btn, for: .normal)
                self.btnSubmitOrSave.superview!.setNeedsLayout()
                self.btnSubmitOrSave.superview!.layoutIfNeeded()
            }
            
        }
        
        
        tableView.estimatedRowHeight = 200
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobCustomForm)
        
    }
        
    
      func setLocalization() -> Void {
          self.navigationItem.title = LanguageKey.title_cutom_field
    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
           
        navigationController?.setNavigationBarHidden(false, animated: animated)
            
            
            if(self.btnSubmitOrSave.titleLabel?.text == LanguageKey.submit_btn && self.customVCArr.count == 0){ //When we submit form and come back to this form then we have to update slt contant
                getFormDetail()
              //  self.getQuestionsByParentId()

            }
            
            self.navigationItem.title = LanguageKey.title_cutom_field
            //self.tableView.reloadData()
        }
        
        
        
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            APP_Delegate.isCustomFormBack = true
            if(self.sltQuestNo != nil){
                if((self.sltQuestNo?.count)! > 3){
                    let name: String = self.sltQuestNo!
                    let endIndex = name.index(name.endIndex, offsetBy: -4)
                    self.sltQuestNo = String(name[..<endIndex]) //name.substring(to: endIndex)
                }
            }
        }
        

        @IBAction func btnSkipAction(_ sender: Any) {
            
            if !isHaveNetowork() {
                ShowAlert(title: LanguageKey.network_issue, message:AlertMessage.networkIssue, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                    if (Ok){
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
                return
            }
            
            
            
            let arrOFShowTabForm : [TestDetails]
            if(isCameFrmStatusBtnClk){
                ShowAlert(title: LanguageKey.skip, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (isOK, isCancel) in}
                self.navigationController?.popViewController(animated: true)
                return
            }else{
                 arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
    //                if(obj.tab == "1"){
    //                    return true
    //                }else{
    //                    return false
    //                }
                    
                    if(self.clickedEvent != nil){
                        if(Int(obj.event!)! == self.clickedEvent) &&  (Int(obj.totalQues!)! != 0){
                            return true
                        }else{
                            return false
                        }
                    }else{
                        if(obj.tab == "1"){
                            return true
                        }else{
                            return false
                        }
                    }
                }
            }
         
            
            let idx = arrOFShowTabForm.firstIndex(where: { $0.frmId ==  objOFTestVC?.frmId })
            
            if((arrOFShowTabForm.count - 1) == (idx != nil ? idx! : 0) ){
                
                if self.callBackFofDetailJob != nil {
                    callBackFofDetailJob!(true)
                }
                ShowAlert(title: LanguageKey.submitted, message: AlertMessage.frm_updated, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (isOK, isCancel) in}
               // self.navigationController?.popViewController(animated: true)
                
                for vc in (self.navigationController?.viewControllers)! {
                    if vc is CustomFormListV {
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                    
                    if vc is JobTabController {
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
                
            }else{
                self.moveCustomVC(arrOfRelatedObj: arrOFShowTabForm , idx: idx!)
            }
        }
        
        func moveCustomVC(arrOfRelatedObj : [TestDetails] , idx : Int ){
    //        let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
    //            if(obj.tab == "1"){
    //                return true
    //            }else{
    //                return false
    //            }
    //        }
    //
    //        let idx = arrOFShowTabForm.index(where: { $0.frmId ==  objOFTestVC?.frmId })
            
           
            
            let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
            customFormVC.objOFTestVC = arrOfRelatedObj[idx + 1]
            customFormVC.sltNaviCount = (self.sltNaviCount! + 1)
            customFormVC.isCameFrmStatusBtnClk = isCameFrmStatusBtnClk
            customFormVC.callBackFofDetailJob = self.callBackFofDetailJob
            customFormVC.clickedEvent = self.clickedEvent != nil ? self.clickedEvent : nil
            customFormVC.objOfUserJobList = self.objOfUserJobList
            customFormVC.optionID = "-1"

            self.navigationController?.navigationBar.topItem?.title = " "
            self.navigationController?.pushViewController(customFormVC, animated: true)
        }
        
        
        
        @IBAction func btnSubmitOrSaveAction(_ sender: UIButton) {
            
            
            
            
            if !isHaveNetowork() {
                ShowAlert(title: LanguageKey.network_issue, message:AlertMessage.networkIssue, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                    if (Ok){
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
                return
            }
            
            if selectedTxtField != nil {
                selectedTxtField?.resignFirstResponder()
            }



            let isMandetory = arrOfShowData.filter { (customForm) -> Bool in

                        for form in self.customVCArr {
                            if form.queId == customForm.queId {
                                if (customForm.mandatory == "1"){
                                    if (form.ans?.count)! > 0 {
                                        return false
                                    }else{
                                        return true
                                    }
                                }
                                return false
                            }
                        }


                        if (customForm.mandatory == "1"){
                                return true
                        }


                        return false
            }


            if isMandetory.count > 0 {
                 ShowError(message: AlertMessage.selectAnyForm, controller: windowController)
                 return
            }


     
            for (_,obj) in self.customVCArr.enumerated(){
                    if(obj.isAdded)!{
                        if let idx = APP_Delegate.mainArr.firstIndex(where: { $0.queId ==  obj.queId }){
                            APP_Delegate.mainArr.remove(at: idx)
                            APP_Delegate.mainArr.append(obj)
                        }else{
                            APP_Delegate.mainArr.append(obj)
                        }
                    }
                }
            
                 if(sender.titleLabel?.text == LanguageKey.submit_btn){

                    self.addAnswer() // Calling Ans api
                 
                        let arrOFShowTabForm : [TestDetails]
                        if(isCameFrmStatusBtnClk){
                           // arrOFShowTabForm = APP_Delegate.arrOFCustomForm
                            ShowAlert(title: LanguageKey.submitted, message: "Answer added successfully.", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (isOK, isCancel) in}
                            self.navigationController?.popViewController(animated: true)
                            return
                        }else{
                        
                        arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
                            if(self.clickedEvent != nil){
                                if(Int(obj.event!)! == self.clickedEvent) &&  (Int(obj.totalQues!)! != 0){
                                    return true
                                }else{
                                    return false
                                }
                            }else{
                                if(obj.tab == "1"){
                                    return true
                                }else{
                                    return false
                                }
                            }
                          }
                        }
                        
                        let idx = arrOFShowTabForm.firstIndex(where: { $0.frmId ==  self.objOFTestVC?.frmId })
                        
                        if((arrOFShowTabForm.count - 1) == (idx != nil ? idx! : 0) ){
                                if self.callBackFofDetailJob != nil {
                                    callBackFofDetailJob!(true)
                                }
                            ShowAlert(title: LanguageKey.submitted, message: AlertMessage.frm_updated, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (isOK, isCancel) in}
                            
                            for vc in (self.navigationController?.viewControllers)! {
                                if vc is CustomFormListV {
                                    self.navigationController?.popToViewController(vc, animated: true)
                                    break
                                }
                                
                                if vc is JobTabController {
                                     self.navigationController?.popToViewController(vc, animated: true)
                                    break
                                }
                            }
                        }else{
                            self.moveCustomVC( arrOfRelatedObj: arrOFShowTabForm, idx: idx!)
                        }
                //  }
    //                else{
    //                    ShowError(message: AlertMessage.selectAnyForm, controller: windowController)
    //                    return
    //                }
                 }else{
                    
                    self.navigationController?.popViewController(animated: true)

                 }
            
               self.customVCArr.removeAll()
            
        }
        
        func ifCameFromEvent(){
            
            if(self.customVCArr.count > 0){
                let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
                     if(Int(obj.event!)! == self.clickedEvent) &&  (Int(obj.totalQues!)! != 0){
                        return true
                    }else{
                        return false
                    }
                }
                let idx = arrOFShowTabForm.firstIndex(where: { $0.frmId ==  self.objOFTestVC?.frmId })
                
                if((arrOFShowTabForm.count - 1) == (idx != nil ? idx! : 0) ){
                    if self.callBackFofDetailJob != nil {
                        callBackFofDetailJob!(true)
                    }
                    ShowAlert(title: LanguageKey.success, message: AlertMessage.frm_updated, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (isOK, isCancel) in}
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }else{
                    self.moveCustomVC( arrOfRelatedObj: arrOFShowTabForm, idx: idx!)
                }
            }
        }
        
        
        func saveDataIntoTempArray(isAdded  : Bool , layer  : String? ,optDetail : OptDetals , customFormDetals : CustomFormDetals){
           //ju

            let dictData = CustomDataRes()
            dictData.queId = customFormDetals.queId
            dictData.type = customFormDetals.type
            dictData.isAdded = isAdded
            dictData.frmId = customFormDetals.frmId
           // dictData.layer = layer
            dictData.ans = [ansDetails]()
            
            let dictData1 = ansDetails()
            
            if optDetail.value != nil {
              //  let dictData1 = ansDetails()
                dictData1.key = optDetail.key
                dictData1.value = trimString(string: optDetail.value ?? "")
                dictData1.layer = layer
                dictData.ans?.append(dictData1)
            }
            
            
            
            if let idx = self.customVCArr.firstIndex(where: { $0.queId ==  customFormDetals.queId }){
                let objOfCusArr  = self.customVCArr[idx]
    //             let isExist = objOfCusArr.ans?.contains(where: { (obj) -> Bool in
    //                if obj.key == optDetail.key{
    //                    obj.value = optDetail.value
    //                    return true
    //                }else{
    //                    return false
    //                }
    //            })
                
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
        
        //====================================
        // MARK:- Table View Delegate Methods
        //====================================
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrOfShowData.count
        }

       
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let customFormDetals = arrOfShowData[indexPath.row]

            if customFormDetals.type == "3"{ //checkBox
                let cell: FirstTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "firstCustomCell") as! FirstTableViewCell?)!

                cell.numberlbl.text =  "\(indexPath.row + 1)."
                
                if customFormDetals.mandatory == "1"{
                    cell.questionLbl.text = "\(customFormDetals.des ?? "") *"
                }else{
                    cell.questionLbl.text = customFormDetals.des
                }
                
                let height = cell.questionLbl.text?.height(withConstrainedWidth: cell.questionLbl.frame.size.width, font: UIFont.systemFont(ofSize: 15.0))
                let frame = CGRect(x: 45, y: Int(height! + 20), width: 325, height: ((customFormDetals.opt?.count)!*40))

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
                        
                        if (result as? OptDetals)!.optHaveChild == "1" {
                            self.getQuestionsByParentIdWhenAnsClick(optDetails: result as? OptDetals)
                        }
                     
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
                                      if((ansobj.layer?.hasPrefix(str!)) != nil)  {
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
                
                let cell: ThirdTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "thirdCustomCell") as! ThirdTableViewCell?)!
                
                
                
                if customFormDetals.mandatory == "1"{
                    cell.lbl_Qstn.text = "\(customFormDetals.des ?? "") *"
                }else{
                    cell.lbl_Qstn.text = customFormDetals.des
                }
                cell.txtView.tag = indexPath.row
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
                let cell: SecondTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "secondCustomCell") as! SecondTableViewCell?)!
                
               
                if customFormDetals.mandatory == "1"{
                    cell.lbl_Qstn.text = "\(customFormDetals.des ?? "") *"
                }else{
                    cell.lbl_Qstn.text = customFormDetals.des
                }
                
                cell.txt_Field.tag = indexPath.row
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
                let cell: fourthTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "fourthCustomCell") as! fourthTableViewCell?)!
                
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
                        
                        if result.optHaveChild == "1" {
                            self.getQuestionsByParentIdWhenAnsClick(optDetails: result )
                        }
                        
                        
                    }else{
                        cell.sltItem = LanguageKey.select_option
                        cell.lbl_Ans.text = LanguageKey.select_option
                       // self.sltQuestNo = ""
                        if(self.sltQuestNo != nil && self.sltQuestNo != ""){
                            if((self.sltQuestNo?.count)! > 3){
                                let name: String = self.sltQuestNo!
                                let endIndex = name.index(name.endIndex, offsetBy: -4)
                                self.sltQuestNo = String(name[..<endIndex]) //name.substring(to: endIndex)
                                print(name)      // "Dolphin"
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
            }else {
                let cell: fifthTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "fifthCustomCell") as! fifthTableViewCell?)!
                cell.btnSltDate.addTarget(self, action: #selector(btnSltDateActionMethod(btn:)), for: .touchUpInside)
                cell.btnSltDate.tag = indexPath.row
                cell.numberlbl.text =   "\(indexPath.row + 1)."
                cell.type = customFormDetals.type ?? "5"
                if (customFormDetals.type == "8"){
                    
                }else if (customFormDetals.type == "9"){
                    let cell: SithNewTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "SithNewTableViewCell") as! SithNewTableViewCell?)!
                    
                    
                    
                    if customFormDetals.mandatory == "1"{
                        cell.labelNam.text = "\(customFormDetals.des ?? "") *"
                    }else{
                        cell.labelNam.text = customFormDetals.des
                    }
                   // cell.labelNam.tag = indexPath.row
                     cell.labelNo.text =   "\(indexPath.row + 1)."
                    
                  
                    
                    //For Already slt ans
//                    if(customFormDetals.ans != nil && customFormDetals.ans?.isEmpty != true){
//                        cell.labelNam.textColor = UIColor.black
//                        cell.labelNam.text = customFormDetals.ans![0].value!
//                        for obj in customFormDetals.ans!{
//                            let layer = String(format: "%d.1", (indexPath.row + 1))
//                            let opt = OptDetals(key: obj.key, questions: nil, value: obj.value, optHaveChild: nil)
//                            self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
//                        }
//                    }
                        return cell
                }else{
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
                    
                    let dateFormate : DateFormate = customFormDetals.type == "5" ? DateFormate.dd_MMM_yyyy : customFormDetals.type == "6" ? DateFormate.h_mm_a : DateFormate.ddMMMyyyy_hh_mm_a
                    
                    if customFormDetals.ans![0].value! != "" && customFormDetals.ans![0].value! != nil  {
                        cell.lbl_Ans.text = createDateTimeForCustomFieldamdForm(timestamp: customFormDetals.ans![0].value!, dateFormate: dateFormate.rawValue)
                    }
                        for obj in customFormDetals.ans!{
                            let layer = String(format: "%d.1", (indexPath.row + 1))
                            if obj.value != "" && obj.value != nil {
                                 let opt = OptDetals(key: obj.key, questions: nil, value: createDateTimeForCustomFieldamdForm(timestamp: obj.value ?? "", dateFormate: dateFormate.rawValue) , optHaveChild: nil)
                                self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                            }
                
                        }
                    }
                
                }


                return cell
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let customFormDetals = arrOfShowData[indexPath.row]
            
            if customFormDetals.type == "3" {
                return tableView.estimatedRowHeight
            }else if customFormDetals.type == "2"{
                return tableView.estimatedRowHeight
            }else {
                 return tableView.estimatedRowHeight
            }
    }
        
        
        
        func buttonPressed(_ sender: AnyObject) {
    //        let button = sender as? UIButton
    //        let cell = button?.superview?.superview as? UITableViewCell
    //        let indexPath = tableView.indexPath(for: cell!)
    //       // print(indexPath?.row)
        }
        
        @objc func btnSltDateActionMethod(btn: UIButton){//Perform actions here
            
            let indexPath = IndexPath(row: btn.tag, section: 0)
            let cell: fifthTableViewCell = self.tableView.cellForRow(at: indexPath) as! fifthTableViewCell
            
            
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
                
                  let displayDateFormate : DateFormate = cell.type == "5" ? DateFormate.dd_MMM_yyyy : cell.type == "6" ? DateFormate.h_mm_a : DateFormate.ddMMMyyyy_hh_mm_a
                cell.lbl_Ans.text =  convertDateToStringForcostomfieldandform(date:selectedDate, dateFormate:displayDateFormate)
                
                let customFormDetals = self.arrOfShowData[indexPath.row]
                
                let ans_server_formate = convertDateToStringForcostomfieldandform(date:selectedDate, dateFormate:DateFormate.dd_MMM_yyyy_hh_mm_ss)
                
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

        
        //===============================
        // MARK:- GetQuestionsList
        //===============================
   
              func getQuestionsByParentId(patmid:String){
        
                  showLoader()
                  let param = Params()
                   param.ansId =  "-1"
                   param.frmId = patmid
                   param.jobId = self.objOfUserJobList.jobId
            
            serverCommunicator(url: Service.getQuestionsByParentId, param: param.toDictionary) { (response, success) in
                
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
           
                    if let decodedData = try? decoder.decode(CustomFormResponse.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            
                            if decodedData.data.count > 0 {
                                DispatchQueue.main.async {
                                    self.lbl_AlertMess.isHidden = true
                                    self.footerView.isHidden = false

                                    self.arrOfShowData = decodedData.data
                                    self.tableView.reloadData()
                                    if (self.arrOfShowData.first(where: {($0.ans?.count != 0)}) != nil) {
                                        self.btnSubmitOrSave.setTitle(LanguageKey.update, for: .normal)
                                    }
                                }
                                
                            }else{
                                if self.arrOfShowData.count == 0{
                                    DispatchQueue.main.async {
                                        self.tableView.isHidden = true
                                        self.lbl_AlertMess.isHidden = false
                                        self.footerView.isHidden = true
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
        
        //=======================================
        // MARK:- GetQuestionsList When Ans Click
        //=======================================
        /*
         parentId -> Parent id
         frmId-> form id
        
         */

        func getQuestionsByParentIdWhenAnsClick(optDetails : OptDetals?){

            showLoader()
            let param = Params()
            param.ansId = optDetails?.key
            param.frmId = objOFTestVC?.frmId
            param.usrId = getUserDetails()?.usrId
            param.jobId = self.objOfUserJobList.jobId


            serverCommunicator(url: Service.getQuestionsByParentId, param: param.toDictionary) { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()

                    if let decodedData = try? decoder.decode(CustomFormResponse.self, from: response as! Data) {

                        if decodedData.success == true{
                            
                           // self.sltQuestNo = ""

                            if decodedData.data.count > 0 {
                                //
                                DispatchQueue.main.async {
                                    let CustomFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
                                    CustomFormVC.objOFTestVC = self.objOFTestVC ?? TestDetails()
                                    CustomFormVC.arrOfShowData = decodedData.data
                                    CustomFormVC.isCameFrmStatusBtnClk = false
                                    CustomFormVC.sltQuestNo = self.sltQuestNo
                                    CustomFormVC.customVCArr = self.customVCArr
                                    CustomFormVC.sltNaviCount = (self.sltNaviCount! + 1)
                                    CustomFormVC.objOfUserJobList = self.objOfUserJobList
                                    CustomFormVC.optionID = "-1"
                              
                                   self.navigationController?.navigationBar.topItem?.title = "\(self.sltNaviCount! + 1)"
                                   self.navigationController?.pushViewController( CustomFormVC , animated: true)
                                }

                            }else{
                             
                                    DispatchQueue.main.async {
                                        if((self.sltQuestNo?.count)! > 3){
                                            let name: String = self.sltQuestNo!
                                            let endIndex = name.index(name.endIndex, offsetBy: -4)
                                            self.sltQuestNo = String(name[..<endIndex]) //name.substring(to: endIndex)
                                   
                                        }
                                    }
                                }
                        }else{
                            if let code =  decodedData.statusCode{
                                if(code == "401"){
                                    ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
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
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
                }
            }
        }
        
        //=======================================
        // MARK:- TextField Delegate Methods
        //=======================================
        
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            selectedTxtField = textField
            textField.text = ""
            textField.textColor = UIColor.black

        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            self.txtFieldData  = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            return true
         }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            let customFormDetals = arrOfShowData[textField.tag]
            let opt = OptDetals(key: "0", questions: nil, value: textField.text, optHaveChild: nil)
            let layer = String(format: "%d.1", (textField.tag + 1))
            self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
        }
        
        //=======================================
        // MARK:- TextView Delegate Methods
        //=======================================
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
            textView.resignFirstResponder()
            return false
            }
            return true
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
              textView.text = ""
              textView.textColor = UIColor.black
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
        
        func textViewDidEndEditing(_ textView: UITextView) {
               let customFormDetals = arrOfShowData[textView.tag]
                let opt = OptDetals(key: "0", questions: nil, value: textView.text, optHaveChild: nil)
                let layer = String(format: "%d.1", (textView.tag + 1))
                self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
          
        }
    
        //=======================================
        // MARK:- AddAns
        //=======================================
      
        func addAnswer(){
            
            showLoader()
            let param = Params()
            param.usrId = getUserDetails()?.usrId
            param.answer = APP_Delegate.mainArr
            param.frmId = getfrmId//objOFTestVC?.frmId
            param.jobId = self.objOfUserJobList.jobId
            param.type = "1"
           
            serverCommunicator(url: Service.addAnswer, param: param.toDictionary) { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()


                    if let decodedData = try? decoder.decode(CustomFormResponse.self, from: response as! Data) {

                        if decodedData.success == true{
                            
                            if  decodedData.message == getServerMsgFromLanguageJson(key: "ans_added"){
                                APP_Delegate.mainArr.removeAll()
                                self.customVCArr.removeAll()

                            }

                        }else{
                            if let code =  decodedData.statusCode{
                                if(code == "401"){
                                    ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
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
                        
                        //
                        self.arrOfShowDatas = decodedData.data
                        //  self.ant = decodedData.data.frmId!
                        // self.ant.append(decodedData.data.frmId)
                        self.getfrmId = decodedData.data.frmId ?? ""
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
//

        

    }//END

    extension String {
        func hieight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            
            return ceil(boundingBox.height)
        }
        
        func wiidth(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            
            return ceil(boundingBox.width)
        }
     
    }
