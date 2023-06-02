//
//  CustomFormVC.swift
//  EyeOnTask
//
//  Created by Mac on 05/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class CustomFormVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate , UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,YPSignatureDelegate{
    
    
    @IBOutlet weak var H_tableView: NSLayoutConstraint!
    @IBOutlet weak var singnatureView: YPDrawSignatureView!
    @IBOutlet var uperView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var lbl_AlertMess: UILabel!
    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var btnSubmitOrSave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var btnSkip_W: NSLayoutConstraint!
    @IBOutlet weak var skipBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var submitBtnHeight: NSLayoutConstraint!
    @IBOutlet var footerViewHeight: NSLayoutConstraint!
    
    var restoreArrOfShowData = [CustomFormDetals]() // to preserve cell data when table auto reload
    var singnatureImage : UIImage? // by rohit
    var attachmentImage : UIImage?// by rohit
    var indexPathSignrCell: IndexPath? //by rohit
    var cellImages = [CellImageAtIndexPath]() // by rohit
    var arrIndexPaths : Int?
    var imagePicker = UIImagePickerController()
    var txtFieldData : String?
    var txtViewData : String?
    // var objOFTestVC : TestDetails? // old
    var objOFTestVC = TestDetails()
    var arrOfShowData = [CustomFormDetals]()
    var arrOflocalData = [CustomAns]()
    var sltFormIdx : Int?
    var sltQuestNo : String?
    var sltNaviCount : Int?
    var customVCArr = [CustomDataRes]()
    var callBackFofDetailJob: ((Bool) -> Void)?
    var clickedEvent : Int?
    var objOfUserJobList = UserJobList()
    var isCameFrmStatusBtnClk : Bool!
    var selectedTxtField : UITextField?
    var imageArr = [UIImage]()
    var indexPatharr = [Int]()
    var rowIndex:Int?
    var customViewForImage:YPDrawSignatureView?
    var singImgData : UIImage?
    var customansArr = [CustomAns]()
    var imageArr1 = [UIImage]()
    var imgpalecholdar : UIImage?
    var frmIdGlobel = ""
    var arrOfflineImage = [String]()
    var fillingCustomFormFromDraft = false
    var isTableRefreshFirst: Bool = false
    var optionID : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        singnatureView.delegate = self
        self.singnatureView.layer.zPosition = 1
        self.backGroundView.isHidden = true
        
        if objOFTestVC.mandatory == "1"{
            self.btnSkip.isHidden = true
            self.btnSkip_W.constant = self.btnSkip_W.constant + 144
            self.btnSubmitOrSave.superview!.setNeedsLayout()
            self.btnSubmitOrSave.superview!.layoutIfNeeded()
        }
        
        btnSkip.setTitle(LanguageKey.skip, for: .normal)
        
        if(self.arrOfShowData.count == 0){
            btnSubmitOrSave.setTitle(LanguageKey.submit_btn, for: .normal)
        }else{
            DispatchQueue.main.async() {
                self.btnSubmitOrSave.setTitle(LanguageKey.save_btn, for: .normal)
                self.btnSubmitOrSave.superview!.setNeedsLayout()
                self.btnSubmitOrSave.superview!.layoutIfNeeded()
            }
            
        }
        
        tableView.estimatedRowHeight = 200
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobCustomForm)
        let image = UIImage(named:"back-arrow")
        let leftButton = UIBarButtonItem(image: image, style: .plain, target: self,  action: #selector(addTapped))
        let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
        self.navigationItem.leftBarButtonItem = leftButton
        
    }
    
    func fillCustomFormFromDraft() {
        fillingCustomFormFromDraft = true
        
        self.fillFormFromDraft()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isDraftHide = false
        UserDefaults.standard.set(isDraftHide, forKey: "DraftHide")
        
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = true
            button.tintColor = UIColor.white
        }
        
        if(self.btnSubmitOrSave.titleLabel?.text == LanguageKey.submit_btn && self.customVCArr.count == 0){ //When we submit form and come back to this form then we have to update slt contant
            
            self.getQuestionsByParentId()
            
        }
        
        self.navigationItem.title = objOFTestVC.frmnm
        //self.tableView.reloadData()
        
        
        if !isHaveNetowork() {
            //            let arrCustomDataRes =  DatabaseClass.shared.fetchCustomDataRequest(customFormID: objOFTestVC.frmId!, jobID: objOfUserJobList.jobId!)
            //            if !arrCustomDataRes.isEmpty {
            //                self.arrOfShowData.removeAll()
            //                self.arrOfShowData = arrCustomDataRes
            //            }
            //            print(arrOfShowData)
            self.getOFFLineForm()
            print(arrOfShowData)
            self.tableView.reloadData()
        }else{
            
        }
    }
    
    func getOFFLineForm() {
        fillingCustomFormFromDraft = true
        let arrCustomFormData =  DatabaseClass.shared.fetchCustomFormBy(customFormID: objOFTestVC.frmId!, jobID: objOfUserJobList.jobId!)
        if !arrCustomFormData.isEmpty {
            self.arrOfShowData.removeAll()
            self.arrOfShowData = arrCustomFormData
        }
        fillFormFromDraft()
    }
    
    func fillFormFromDraft() {
           let arrCustomDataAns =  DatabaseClass.shared.fetchCustomFormAnswersBy(customFormID: objOFTestVC.frmId!, jobID: objOfUserJobList.jobId!, optionId: optionID ?? "-100")
           
           arrCustomDataAns.forEach{ obj in
               let quesId = obj.queId
               
               if let idx = self.arrOfShowData.firstIndex(where: { $0.queId ==  obj.queId }){
                   var answers = [AnsDetals]()
                   
                   if let ansDetail = obj.ans {
                       ansDetail.forEach{ ansTemp in
                           let ans = AnsDetals.init(key: ansTemp.key, value: ansTemp.value, layer: ansTemp.layer)
                           answers.append(ans)
                       }
                   }
                   self.arrOfShowData[idx].ans = answers
               }
           }
           restoreArrOfShowData = self.arrOfShowData
           self.tableView.reloadData()
       }
       func fillChildFormFromDraftfrom(form:[CustomFormDetals],data:[CustomDataRes]) -> [CustomFormDetals]  {
              let arrCustomDataAns =  data
              var datamodelForChild = form
              
              arrCustomDataAns.forEach{ obj in
                  let quesId = obj.queId
                  
                  if let idx = datamodelForChild.firstIndex(where: { $0.queId ==  obj.queId }){
                      var answers = [AnsDetals]()
                      
                      if let ansDetail = obj.ans {
                          ansDetail.forEach{ ansTemp in
                              let ans = AnsDetals.init(key: ansTemp.key, value: ansTemp.value, layer: ansTemp.layer)
                              answers.append(ans)
                          }
                      }
                      datamodelForChild[idx].ans = answers
                  }
              }
              return datamodelForChild
          }
    override func viewDidLayoutSubviews() {
        self.H_tableView.constant = tableView.contentSize.height
    }
    
    @objc func addTapped(){
        let dialogMessage = UIAlertController(title: "Confirm", message: LanguageKey.save_to_draft, preferredStyle: .alert)
        let ok = UIAlertAction(title: LanguageKey.yes, style: .default, handler: { [self] (action) -> Void in
            
            let isDraftJObid = self.objOfUserJobList.jobId
            UserDefaults.standard.set(isDraftJObid, forKey: "isDraftgetJobId")
            let isDraftHide = false
            UserDefaults.standard.set(isDraftHide, forKey: "DraftHide")
            
            self.saveForminDB()
         
            let arrSignature = getSignatures()
            let arrAttacment = getattachments()
            
            for singnature in arrSignature {
                
                if let image = singnature.img, let signId = singnature.id , let frmId = singnature.frmId,let jobId = self.objOfUserJobList.jobId ,!frmId.isEmpty,!signId.isEmpty  {
                    let imageName = "Photo-\(jobId+signId+frmId).jpg"
                    saveImageDocumentDirectryPath(image: image, timeFormate: imageName)
                }
                
            }
            
            for Attacment in arrAttacment {
                
                if let attech = Attacment.img, let attechId = Attacment.id,let jobId = self.objOfUserJobList.jobId,let attechFrmId =  Attacment.frmId ,!attechFrmId.isEmpty,!attechId.isEmpty  {
                    let imageName = "Photo-\(jobId+attechId+attechFrmId).jpg"
                    saveImageDocumentDirectryPath(image: attech, timeFormate: imageName)
                }
                
            }
            
            //===
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
            
        })
        let cancel = UIAlertAction(title: LanguageKey.no, style: .cancel) { (action) -> Void in
            for index in self.arrOfflineImage {
                self.deleteFileForImage(fileName: index)
            }
            self.arrOfflineImage.removeAll()
            let isDraftgetJobId = ""
            UserDefaults.standard.set(isDraftgetJobId, forKey: "isDraftgetJobId")
            let isDraftJObid = ""
            UserDefaults.standard.set(isDraftJObid, forKey: "isDraftJObid")
            
            // rohit
            DatabaseClass.shared.storeOnlyCustomFormInDataBase(customForm: self.arrOfShowData, formID: self.objOFTestVC.frmId!)
            DatabaseClass.shared.deleteCustomFormAns(formID:self.objOFTestVC.frmId!,jobID:self.objOfUserJobList.jobId!, optionId: self.optionID!)
            
            self.arrOflocalData.removeAll()
            self.navigationController?.popViewController(animated: true)
            
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    @objc func permissionReplaceDraftAnd(){
        let dialogMessage = UIAlertController(title: "Confirm", message: "Do You Want To Add Draft Ans", preferredStyle: .alert)
        let ok = UIAlertAction(title: LanguageKey.yes, style: .default, handler: { [self] (action) -> Void in
            fillCustomFormFromDraft()
            
        })
        let cancel = UIAlertAction(title: LanguageKey.no, style: .cancel) { (action) -> Void in
            
            
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    private func saveForminDB() {
        
        //        var arrOfQuestions = [CustomFormDetals]()
        //        arrOfShowData.forEach{ obj in
        //                let quesId = obj.queId
        //                        if let ansDetail = self.customVCArr.filter {($0.queId == quesId)}.first?.ans {
        //                            var anss = [AnsDetals]()
        //                            for ansAns in ansDetail {
        //                                let ansQue = AnsDetals(key: ansAns.key, value: ansAns.value, layer: ansAns.layer)
        //                                anss.append(ansQue)
        //                            }
        //                            obj.ans = anss
        //                            anss.removeAll()
        //                        }
        //            arrOfQuestions.append(obj)
        //        }
        //        DatabaseClass.shared.storeCustomFormInDataBase(customForm: arrOfQuestions, jobID: objOfUserJobList.jobId!, formID: objOFTestVC.frmId!)
        
        if let optidd = optionID,optidd == "-1" {
                    DatabaseClass.shared.storeOnlyCustomFormInDataBase(customForm: self.arrOfShowData, formID: objOFTestVC.frmId!)
                }
                DatabaseClass.shared.storeOnlyCustomFormAnsInDataBase(customFormAns: self.customVCArr, formID: objOFTestVC.frmId!, jobID: objOfUserJobList.jobId!, optionId: optionID!)
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
    
    //================================
    //  MARK: showing And Hiding Background
    //================================
    
    func showBackgroundView() {
        backGroundView.isHidden = false
        self.uperView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.backGroundView.backgroundColor = UIColor.black
            self.backGroundView.alpha = 0.5
        })
    }
    
    func hideBackgroundView() {
        self.singnatureView.clear()
        self.uperView.isHidden = true
        self.backGroundView.isHidden = true
        self.backGroundView.backgroundColor = UIColor.clear
        self.backGroundView.alpha = 1
    }
   
    @IBAction func ok_Btn(_ sender: UIButton) {
        
        if let img =   singnatureView.getCroppedSignature(scale: 1.0){
            singImgData = img
        }
        if let indx = indexPathSignrCell{
            let indexPathSection = indx
            tableView.reloadRows(at: [indx], with: .fade)
        }
        hideBackgroundView()
    }
    
    @IBAction func clear_Btn(_ sender: Any) {
        self.singnatureView.clear()
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
        
        // ShowAlert(title: LanguageKey.submitted, message: AlertMessage.frm_updated, controller:
        
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
        
        let idx = arrOFShowTabForm.firstIndex(where: { $0.frmId ==  objOFTestVC.frmId })
        
        if((arrOFShowTabForm.count - 1) == (idx != nil ? idx! : 0) ){
            
            if self.callBackFofDetailJob != nil {
                callBackFofDetailJob!(true)
            }
            ShowAlert(title: LanguageKey.skip, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (isOK, isCancel) in}
            
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
        
        let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
        customFormVC.objOFTestVC = arrOfRelatedObj[idx + 1]
        customFormVC.sltNaviCount = (self.sltNaviCount! + 1)
        customFormVC.isCameFrmStatusBtnClk = isCameFrmStatusBtnClk
        customFormVC.callBackFofDetailJob = self.callBackFofDetailJob
        customFormVC.clickedEvent = self.clickedEvent != nil ? self.clickedEvent : nil
        customFormVC.objOfUserJobList = self.objOfUserJobList
        customFormVC.optionID = ""
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.pushViewController(customFormVC, animated: true)
    }

    @IBAction func btnSubmitOrSaveAction(_ sender: UIButton) {
        
        self.customansArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "CustomAns", query: nil) as! [CustomAns]
        // rohit
        
      //  DatabaseClass.shared.deleteCustomFormInDataBase(jobID: self.objOfUserJobList.jobId!, formID: self.objOFTestVC.frmId!)
        // print(self.customansArr)
        for job in self.customansArr{
            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
        }
        DemosaveUserCustomFormAnsInDataBase(data: customVCArr)
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
                    //   self.arrOflocalData.removeAll()
                }
            }
        }
        
               for itemOne in self.cellImages{
                   if let idx = APP_Delegate.mainArrCustomFormTblCellImages.firstIndex(where: { $0.questionId ==  itemOne.questionId }){
                       APP_Delegate.mainArrCustomFormTblCellImages.remove(at: idx)
                       APP_Delegate.mainArrCustomFormTblCellImages.append(itemOne)
                   }else{
                       APP_Delegate.mainArrCustomFormTblCellImages.append(itemOne)
                   }
               }
        
        if optionID != "-1" {
            ShowAlert(title: LanguageKey.save_to_draft, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (isOK, isCancel) in}
        }
        
        if(sender.titleLabel?.text == LanguageKey.submit_btn){
            let isDraftJObid = ""
            UserDefaults.standard.set(isDraftJObid, forKey: "isDraftJObid")
            var frmId = ""
            UserDefaults.standard.set(frmId, forKey: "isDraftJObid")
            
            //================================
            //  MARK: API CLL FOR SUBMIT
            //================================
            if APP_Delegate.mainArr.count < 1{
                
                ShowAlert(title: LanguageKey.enter_ans, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (isOK, isCancel) in}
                return
            }
            self.addAnswer() // Calling Ans api
         
            //==================================================================================
            
            let arrOFShowTabForm : [TestDetails]
            if(isCameFrmStatusBtnClk){
                // arrOFShowTabForm = APP_Delegate.arrOFCustomForm
             
                 ShowAlert(title: LanguageKey.submitted, message: AlertMessage.frm_updated, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (isOK, isCancel) in}
                DatabaseClass.shared.deleteCustomFormAns(formID:self.objOFTestVC.frmId!,jobID:self.objOfUserJobList.jobId!, optionId: "")
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
            
            let idx = arrOFShowTabForm.firstIndex(where: { $0.frmId ==  self.objOFTestVC.frmId })
            
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
            let idx = arrOFShowTabForm.firstIndex(where: { $0.frmId ==  self.objOFTestVC.frmId })
            
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
    func jsonToAnyObject(_ jsonString: String) -> [AnsDetals]? {
        var arr: [AnsDetals]?
        
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                arr = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnsDetals]
            } catch let error as NSError {
                let sError = String(describing: error)
                NSLog(sError)
                //throw JSONSerialization.jso
            }
        }
        return arr
    }
    
    func saveDataIntoTempArray(isAdded  : Bool , layer  : String? ,optDetail : OptDetals , customFormDetals : CustomFormDetals){
        
        let dictData = CustomDataRes()
        dictData.queId = customFormDetals.queId
        dictData.type = customFormDetals.type
        dictData.isAdded = isAdded
        dictData.frmId = customFormDetals.frmId
        dictData.ans = [ansDetails]()
        let dictData1 = ansDetails()
        
        if optDetail.value != "" && optDetail.value != nil {
            
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
    
    //====================================
    // MARK:- Table View Delegate Methods
    //====================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfShowData.count
       
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let customFormDetals = arrOfShowData[indexPath.row]
        
        if customFormDetals.type == "3"{ //multy checkBox
            let cell: FirstTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "firstCustomCell") as! FirstTableViewCell?)!
           
            cell.numberlbl.text =  "\(indexPath.row + 1)."
            
            if customFormDetals.mandatory == "1"{
                cell.questionLbl.text = "\(customFormDetals.des ?? "") *"
            }else{
                cell.questionLbl.text = customFormDetals.des
            }
            
            let height = cell.questionLbl.text?.height(withConstrainedWidth: cell.questionLbl.frame.size.width, font: UIFont.systemFont(ofSize: 15.0))
            let frame = CGRect(x: 32, y: Int(height! + 20), width: Int(windowController.view.frame.size.width-32), height: ((customFormDetals.opt?.count)!*40))
            
            cell.lbl_Qust_B.constant = CGFloat((((customFormDetals.opt?.count)!*40)))
           
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
                      
                        let opt = OptDetals(key: obj.key, questions: nil, value: obj.value, optHaveChild: nil)
                        self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                    }
                }
            }
            
            cell.addSubTblView(frame: frame, ShowData: customFormDetals.opt, alreadyGivnAns: customFormDetals.ans , selection: { (success , result , sltIdx) in
                if(success){
                 
                    if(self.sltQuestNo == "" || self.sltQuestNo == nil){
                        self.sltQuestNo =   String(format: "%d.%d", (indexPath.row + 1) ,(sltIdx))
                    }else{
                        self.sltQuestNo =  String(format: "%@.%d.%d", self.sltQuestNo! , indexPath.row + 1 ,sltIdx)
                    }
                    // by rohit
                    if let optionDetail = result as? OptDetals{

                        if optionDetail.value != "" && optionDetail.value != nil {
                            let dictData1 = AnsDetals(key: optionDetail.key, value: trimString(string: optionDetail.value!), layer: self.sltQuestNo)
                            self.arrOfShowData[indexPath.row].ans?.append(dictData1)
                        }
                    }
    // end by rohit
                    
                    //Save Data into Temp Array
                    self.saveDataIntoTempArray(isAdded: true, layer: self.sltQuestNo! , optDetail: (result as? OptDetals)!, customFormDetals: customFormDetals)
                    
                    if (result as? OptDetals)!.optHaveChild == "1" {
                         if !isHaveNetowork() {
                            killLoader()
                            ShowAlert(title: LanguageKey.dialog_alert, message: LanguageKey.offline_feature_alert, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                         } else {
                        self.getQuestionsByParentIdWhenAnsClick(optDetails: result as? OptDetals)
                         }
                    }
                    
                }else{
             // by rohit to remove frome  model
                    if let optionDetail = result as? OptDetals{
                        let isExist = self.arrOfShowData[indexPath.row].ans?.firstIndex(where: { $0.key == optionDetail.key })
                        if isExist != nil{
                            self.arrOfShowData[indexPath.row].ans?.remove(at: isExist!)
                        }
                    }

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
            
            let cell: ThirdTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "thirdCustomCell") as! ThirdTableViewCell?)!
            
            if customFormDetals.mandatory == "1"{
                cell.lbl_Qstn.text = "\(customFormDetals.des ?? "") *"
            }else{
                cell.lbl_Qstn.text = customFormDetals.des
            }
            cell.txtView.tag = indexPath.row
            cell.numberlbl.text =   "\(indexPath.row + 1)."
            cell.txtView.text =  "" // set nil otherwise it will use previous valu in reuse
            
            
           // if let anss = restoreArrOfShowData[indexPath.row].ans, anss.count > 0 {
                
                cell.txtView.textColor = UIColor.darkGray
            cell.txtView.text = customFormDetals.ans?.first?.value ?? "" // sestore user edited data
                    let layer = String(format: "%d.1", (indexPath.row + 1))
                    let opt = OptDetals(key: customFormDetals.ans?.first?.key ?? "", questions: nil, value: customFormDetals.ans?.first?.value ?? "", optHaveChild: nil)
                    self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)

            return cell
            
        } else if customFormDetals.type == "11"{ //Attachment
            
            indexPathSignrCell = indexPath
            
            let cell: sixeTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "sixeTableViewCell") as! sixeTableViewCell?)!
            cell.lbl_Qstn.text = customFormDetals.des
            cell.numberlbl.text = "\(indexPath.row + 1)."
            cell.selectionStyle = .none
            cell.layoutSubviews()
            cell.addAttechement.tag = indexPath.row
            cell.addAttechement.addTarget(self, action: #selector(btnSltDateActionMethod1(btn:)), for: .touchUpInside);
            cell.imgView.image = UIImage(named: "default-thumbnail") // rohit

            
            if let idx = self.isImageExistAtQuestionID(questionID: customFormDetals.queId ?? "") {
                print("")

                if  let img = attachmentImage {
                    cell.imgView.image = img
                    updateImageAtQuestionID(image: cell.imgView.image, QuestionID: customFormDetals.queId ?? "")
                    attachmentImage = nil

                }else{  let obj = self.cellImages[idx]
                    cell.imgView.image = obj.img
                }
            }else{
                print("")
                if customFormDetals.ans?.isEmpty != true && customFormDetals.ans != nil {
                    
                    for obj in customFormDetals.ans!{
                        DispatchQueue.global().async { [weak self] in
                            let ar = URL(string: Service.BaseUrl)?.absoluteString
                            let ab = obj.value
                            if let baseUrl = ar ,let nextHalfUrl = ab , let finalUrl = URL(string: baseUrl + nextHalfUrl){
                                if let data = try? Data(contentsOf: finalUrl) {
                                    if let image = UIImage(data: data) {
                                        DispatchQueue.main.async {
                                            cell.imgView.image = image as? UIImage
                                            self?.imageArr.append( cell.imgView.image!)
                                            let layer = String(format: "%d.1", (indexPath.row + 1))
                                            let opt = OptDetals(key: "0", questions: nil, value: "ATTACHMENT.png", optHaveChild: nil)
                                            self?.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                                            self?.saveImageInArray(image: cell.imgView.image, atindexpath: indexPath, quId: customFormDetals.queId ?? "", celltype: "11", frmId: customFormDetals.frmId ?? "")                                }
                                    }
                                }
                            }
                        }
                    }
                }
                // getting ofline data
                    if  let signId = customFormDetals.queId , let frmId = customFormDetals.frmId,let jobID = objOfUserJobList.jobId,!frmId.isEmpty,!signId.isEmpty  {
                     
                        let imageName = "Photo-\(jobID+signId+frmId).jpg"
                        arrOfflineImage.append("\(imageName)")
                        print("GET IMAGE OFFLINE ---\(arrOfflineImage)")
                        if let imageObj = self.getImage(imageName: imageName) {
                            cell.imgView.image = imageObj
                            
                        }
                    }
                
                if  let img = attachmentImage {
                    cell.imgView.image = img
                    self.attachmentImage = nil
                }
                
                 // filling images in  storing model by rohit
                 let backgraundImg = UIImage(named: "default-thumbnail")
                 if let img = cell.imgView.image  {
                     
                     if(  img.isEqualToImage(backgraundImg!) == false){
                         self.saveImageInArray(image: cell.imgView.image, atindexpath: indexPath, quId: customFormDetals.queId ?? "", celltype: "11", frmId: customFormDetals.frmId ?? "")
                         // storing ans to server model
                         let layer = String(format: "%d.1", (indexPath.row + 1))
                         let opt = OptDetals(key: "0", questions: nil, value: "ATTACHMENT.png", optHaveChild: nil)
                         self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                     }
                 }
                
            }
            
            return cell
           
        } else if customFormDetals.type == "10"{ // SignView
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "earthTableViewCell", for: indexPath) as! earthTableViewCell
            
            cell.addSignBtn.tag = indexPath.row
            cell.deleteSignBtn.tag = indexPath.row
            cell.lbl_Qstn.text = customFormDetals.des
            cell.numberlbl.text = "\(indexPath.row + 1)."
            cell.addSignBtn.tag = indexPath.row // by rohit
            cell.addSignBtn.addTarget(self, action: #selector(btnSelectForAddSign(btn:)), for: .touchUpInside);
            cell.deleteSignBtn.addTarget(self, action: #selector(deleteSignView(btn:)), for: .touchUpInside);
            cell.img.image = nil // rohit
          
            if let idx = self.isImageExistAtQuestionID(questionID: customFormDetals.queId ?? "") {
                
                if  let img = singImgData {
                    cell.img.image = img
                    updateImageAtQuestionID(image: cell.img.image, QuestionID: customFormDetals.queId ?? "")
                    singImgData = nil
                }else{  let obj = self.cellImages[idx]
                    cell.img.image = obj.img
                }
             
            }else{
             
                if customFormDetals.ans?.isEmpty != true && customFormDetals.ans != nil {
                    
                    for obj in customFormDetals.ans!{
                        DispatchQueue.global().async { [weak self] in
                            let ar = URL(string: Service.BaseUrl)?.absoluteString
                            let ab = obj.value
                            if let baseUrl = ar ,let nextHalfUrl = ab , let finalUrl = URL(string: baseUrl + nextHalfUrl){
                                if let data = try? Data(contentsOf: finalUrl ) {
                                    if let image = UIImage(data: data) {
                                        DispatchQueue.main.async {
                                            cell.img.image = image as? UIImage
                                            let layer = String(format: "%d.1", (indexPath.row + 1))
                                            let opt = OptDetals(key: "0", questions: nil, value: "SIGNATURE\(indexPath.row).png", optHaveChild: nil)
                                            self?.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                                            self?.saveImageInArray(image: cell.img.image, atindexpath: indexPath,quId:customFormDetals.queId ?? "", celltype: "10", frmId: customFormDetals.frmId ?? "")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if  let img = singImgData {
                    cell.img.image = img
                }
                
                     if  let signId = customFormDetals.queId , let frmId = customFormDetals.frmId,let jobID = objOfUserJobList.jobId,!frmId.isEmpty,!signId.isEmpty  {
                         let imageName = "Photo-\(jobID+signId+frmId).jpg"
                         arrOfflineImage.append("\(imageName)")
                         print("GET IMAGE OFFLINE ---\(arrOfflineImage)")
                         if let imageObj = self.getImage(imageName: imageName) {
                           
                             cell.img.image = imageObj
                             
                             let layer = String(format: "%d.1", (indexPath.row + 1))
                             let opt = OptDetals(key: "0", questions: nil, value: "SIGNATURE\(indexPath.row).png", optHaveChild: nil)
                             self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                             
                             self.saveImageInArray(image: cell.img.image, atindexpath: indexPath,quId:customFormDetals.queId ?? "", celltype: "10", frmId: customFormDetals.frmId ?? "")
                         }
                     }
                
                
                
                if let img = cell.img.image  {
                    let layer = String(format: "%d.1", (indexPath.row + 1))
                    let opt = OptDetals(key: "0", questions: nil, value: "SIGNATURE\(indexPath.row).png", optHaveChild: nil)
                    self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                    // filling images in  storing model by rohit
                    self.saveImageInArray(image: cell.img.image, atindexpath: indexPath,quId:customFormDetals.queId ?? "", celltype: "10", frmId: customFormDetals.frmId ?? "")
                }
              
                self.singImgData = nil
            }
            return  cell
        }
        
        else if customFormDetals.type == "1"{ //Text
            let cell: SecondTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "secondCustomCell") as! SecondTableViewCell?)!
            
            if customFormDetals.mandatory == "1"{
                cell.lbl_Qstn.text = "\(customFormDetals.des ?? "") *"
            }else{
                cell.lbl_Qstn.text = customFormDetals.des
            }
            
            cell.txt_Field.text = ""
            cell.txt_Field.tag = indexPath.row
            cell.numberlbl.text =   "\(indexPath.row + 1)."
            
            //For Already slt ans
            if(customFormDetals.ans != nil && customFormDetals.ans?.isEmpty != true) {
                cell.txt_Field.textColor = UIColor.darkGray
                cell.txt_Field.text = customFormDetals.ans![0].value
//                if let txtvalue = restoreArrOfShowData[indexPath.row].ans![0].value{
//                    cell.txt_Field.text = txtvalue // sestore user edited data
//                }
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
                cell.lbl_Ans.textColor = UIColor.darkGray
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
            
//            if restoreArrOfShowData.indices.contains(indexPath.row){
//                if let anss = restoreArrOfShowData[indexPath.row].ans { //rohit
//                    if  anss.count > 0{
//                        cell.lbl_Ans.text = anss[0].value
//                    }
//                }
//            }
            
            cell.callBack = {(success : Bool ,result : OptDetals , sltIdx : Int) -> Void in
                if(success){
                    
                    cell.lbl_Ans.textColor = UIColor.darkGray
                    cell.lbl_Ans.text = result.value
                    cell.sltItem = cell.lbl_Ans.text
                    
                    if  self.arrOfShowData[indexPath.row].ans!.count > 0{ // rohit
                        self.arrOfShowData[indexPath.row].ans![0].value = cell.lbl_Ans.text
                    }else{
                        let ans = AnsDetals(key: "0", value: cell.lbl_Ans.text, layer: "")
                        self.arrOfShowData[indexPath.row].ans?.append(ans)
                    }
                    
                    if(self.sltQuestNo == "" || self.sltQuestNo == nil){
                        self.sltQuestNo =   String(format: "%d.%d", (indexPath.row + 1) ,(sltIdx))
                    }else{
                        self.sltQuestNo =  String(format: "%@.%d.%d", self.sltQuestNo!,(indexPath.row + 1) ,sltIdx)
                    }
                    
                    if let idx = self.customVCArr.firstIndex(where: { $0.queId == customFormDetals.queId }){
                        self.customVCArr.remove(at: idx)
                  
                    }
                    
                    //Save Data into Temp Array
                    self.saveDataIntoTempArray(isAdded: true, layer: self.sltQuestNo! , optDetail: result , customFormDetals: customFormDetals)
                    
                    if result.optHaveChild == "1" {
                        self.getQuestionsByParentIdWhenAnsClick(optDetails: result )
                    }
                  
                }else{
                    cell.sltItem = LanguageKey.select_option
                    cell.lbl_Ans.text = LanguageKey.select_option
                    
                    if  self.arrOfShowData[indexPath.row].ans!.count > 0{ // rohit
                        self.arrOfShowData[indexPath.row].ans?.removeAll()
                    }
                   
                    if(self.sltQuestNo != nil && self.sltQuestNo != ""){
                        if((self.sltQuestNo?.count)! > 3){
                            let name: String = self.sltQuestNo!
                            let endIndex = name.index(name.endIndex, offsetBy: -4)
                            self.sltQuestNo = String(name[..<endIndex])
                         
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
                            
                        }
                        
                    }
                   
                    //Delete Value From CustomArray Array when Deselect any options
                    for (index,obj) in self.customVCArr.enumerated(){
                        if let idx = obj.ans?.firstIndex(where: { $0.key == (result as OptDetals).key}){
                            let diSelectObj = self.customVCArr[index]
                           
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
                            
                        }
                        
                    }
                }
            }
            return cell
        } else if customFormDetals.type == "8"{ //checkBox
            let cell: NaithTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "NaithTableViewCell") as! NaithTableViewCell?)!
         
            cell.numLbl.text =  "\(indexPath.row + 1)."
            
            if customFormDetals.mandatory == "1"{
                cell.queLbl.text = "\(customFormDetals.des ?? "") *"
            }else{
                cell.queLbl.text = customFormDetals.des
            }
     
            cell.btnClick.tag = indexPath.row
            cell.btnClick.addTarget(self, action: #selector(tapOnTermAndConditionButton(sender:)), for: .touchUpInside)
            if(customFormDetals.ans != nil && customFormDetals.ans?.isEmpty != true) {
                if customFormDetals.ans![0].value == "1" {
                    cell.btnClick.setImage(UIImage(named: "checked24"), for: .normal)
                }else{
                    cell.btnClick.setImage(UIImage(named: "unchecked24"), for: .normal)
                }
            }else{
                cell.btnClick.setImage(UIImage(named: "unchecked24"), for: .normal)
            }
            // rohit
//            if let anss = restoreArrOfShowData[indexPath.row].ans {
//                if  anss.count > 0{
//
//                    if anss[0].value == "1" {
//                        cell.btnClick.setImage(UIImage(named: "checked24"), for: .normal)
//                    }else{
//                        cell.btnClick.setImage(UIImage(named: "unchecked24"), for: .normal)
//                    }
//                }
//            }
            
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
                        
                        let opt = OptDetals(key: obj.key, questions: nil, value: obj.value, optHaveChild: nil)
                        self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                    }
                    
                }
                
            }
            
            return cell
        } else  if customFormDetals.type == "9"{ // lable
            let cell: TenthTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "TenthTableViewCell") as! TenthTableViewCell?)!
            
            cell.lblNm.text =  "\(indexPath.row + 1)."
            
            if customFormDetals.mandatory == "1"{
                cell.lblItem.text = "\(customFormDetals.des ?? "") *"
            }else{
                cell.lblItem.text = customFormDetals.des
            }
           
            return cell
            
        }else{
            
            let cell: fifthTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "fifthCustomCell") as! fifthTableViewCell?)!
       
            cell.btnSltDate.addTarget(self, action: #selector(btnSltDateActionMethod(btn:)), for: .touchUpInside)
            cell.btnSltDate.tag = indexPath.row
            cell.numberlbl.text =   "\(indexPath.row + 1)."
            cell.type = customFormDetals.type ?? "5"
            
            let title : String = customFormDetals.type == "5" ? LanguageKey.date : customFormDetals.type == "6" ? LanguageKey.time : LanguageKey.datetime
          
            // Mark Place holder conditation : -
            if customFormDetals.type == "5" {
                cell.lbl_Ans.text = "DD-MM-YY"
                cell.celenderIng.isHidden = false
                cell.clockImg.isHidden = true
            }else if customFormDetals.type == "6"{
                cell.lbl_Ans.text = "HH-MM-AM"
                cell.celenderIng.isHidden = true
                cell.clockImg.isHidden = false
                cell.H_trelingCelenderImg.constant = 0
                cell.width_CelenderImg.constant = 0
            } else if customFormDetals.type == "7"{
                cell.lbl_Ans.text = "Choose date time"
                cell.celenderIng.isHidden = false
                cell.clockImg.isHidden = false
            }
            cell.lbl_Ans.text = title
        
            if customFormDetals.mandatory == "1"{
                cell.lbl_Qstn.text = "\(customFormDetals.des ?? "") *"
            }else{
                cell.lbl_Qstn.text = customFormDetals.des
            }
         
            //For Already slt ans
            if(customFormDetals.ans != nil && customFormDetals.ans?.isEmpty != true){
                cell.lbl_Ans.textColor = UIColor.darkGray
                let dateFormate : DateFormate = customFormDetals.type == "5" ? DateFormate.dd_MMM_yyyy : customFormDetals.type == "6" ? DateFormate.h_mm_a : customFormDetals.type == "7" ? DateFormate.ddMMMyyyy_hh_mm_a : DateFormate.ddMMMyyyy_hh_mm_a
                
                var isDraftHide : Bool?
                isDraftHide = UserDefaults.standard.value(forKey: "DraftHide") as? Bool
                if customFormDetals.ans![0].value! != "" && customFormDetals.ans![0].value! != nil  {
                    cell.lbl_Ans.textColor =  UIColor.darkGray
                    cell.lbl_Ans.text = customFormDetals.ans![0].value!
                }

                for obj in customFormDetals.ans!{
                    let layer = String(format: "%d.1", (indexPath.row + 1))
                        if obj.value != "" && obj.value != nil  {
                            let opt = OptDetals(key: obj.key, questions: nil, value: createDateTimeForCustomFieldamdFormDraft(timestamp: obj.value!, dateFormate: dateFormate.rawValue) , optHaveChild: nil)
                            self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
                        }
                }
            }
            return cell
        }
    }
    
    @objc func tapOnTermAndConditionButton(sender: UIButton) {
        
        var isSelected = "0"
        
        if sender.currentImage == UIImage(named: "checked24") {
            sender.setImage(UIImage(named: "unchecked24"), for: .normal)
            isSelected = "0"
        }else{
            sender.setImage(UIImage(named: "checked24"), for: .normal)
            isSelected = "1"
        }
        
        // by rohit for restore user data
        if sender.currentImage == UIImage(named: "checked24"){
            
            if  arrOfShowData[sender.tag].ans!.count > 0{ // rohit
                arrOfShowData[sender.tag].ans![0].value = "1"
            }else{
                let ans = AnsDetals(key: "0", value: "1", layer: "")
                arrOfShowData[sender.tag].ans?.append(ans)
            }
        }else{
            arrOfShowData[sender.tag].ans![0].value = "0"
        }
        let customFormDetals = arrOfShowData[sender.tag]
        
        let layer = String(format: "%d.1", (sender.tag + 1))
        let opt = OptDetals(key:"0", questions: nil, value: isSelected, optHaveChild: nil)
        self.saveDataIntoTempArrays(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
        
    }
    
    func saveDataIntoTempArrays(isAdded  : Bool , layer  : String? ,optDetail : OptDetals , customFormDetals : CustomFormDetals){
        
        
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
            self.DemosaveUserCustomFormAnsInDataBase(data: self.customVCArr)
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
    @objc func btnSltDateActionMethod1(btn: UIButton){
        indexPatharr.removeAll()
        let btnTag = btn.tag
        print(btnTag)
        rowIndex = btnTag
        indexPathSignrCell = IndexPath(row: btnTag, section: 0) // by rohit
        
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
                    
                    // self.imgView.isHidden = true
                    // self.HightTopView.constant = 55
                    
                })
            }
        }
        
        let gallery = UIAlertAction(title: LanguageKey.gallery, style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = false
                APP_Delegate.showBackButtonText()
                self.present(self.imagePicker, animated: true, completion: {
                    
                    // self.imgView.isHidden = true
                    // self.HightTopView.constant = 55
                    
                })
            }
        }
        
        actionSheetControllerIOS8.addAction(gallery)
        actionSheetControllerIOS8.addAction(camera)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
            
            attachmentImage = image as? UIImage// // by rohit
            let indexPath = IndexPath(row: rowIndex!, section: 0)
            
            let cell = tableView.cellForRow(at: indexPath) as! sixeTableViewCell
            cell.imgView.image = image as? UIImage
            
            
            imageArr.append(cell.imgView.image!)
            
            if let indx = indexPathSignrCell{ // by rohit
                
                tableView.reloadRows(at: [indx], with: .fade)
            }
            
        }
        
        
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        APP_Delegate.hideBackButtonText()
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
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
            cell.lbl_Ans.textColor = UIColor.darkGray
            
            
            let selectedDate = sltDate != nil ? sltDate! : Date()
            
            let displayDateFormate : DateFormate = cell.type == "5" ? DateFormate.dd_MMM_yyyy : cell.type == "6" ? DateFormate.h_mm_a : DateFormate.ddMMMyyyy_hh_mm_a
            cell.lbl_Ans.text =  convertDateToStringForcostomfieldandform(date:selectedDate, dateFormate:displayDateFormate)
            
            if  self.arrOfShowData[indexPath.row].ans!.count > 0{ // rohit
                self.arrOfShowData[indexPath.row].ans![0].value = cell.lbl_Ans.text
            }else{
                let ans = AnsDetals(key: "0", value: cell.lbl_Ans.text, layer: "")
                self.arrOfShowData[indexPath.row].ans?.append(ans)
            }

            let customFormDetals = self.arrOfShowData[indexPath.row]
            
            let ans_server_formate = convertDateToStringForcostomfieldandform(date:selectedDate, dateFormate: displayDateFormate)
            
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
    /*
     ansId -> Answer id
     parentId->parentId
     frmId-> form id
     usrId->user id
     jobId->job id
     
     */
    
    func getQuestionsByParentId(){
        
        // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getQuestionsByParentId) as? String
        // showLoader()
        let param = Params()
        param.parentId = "-1"
        param.frmId = objOFTestVC.frmId
        param.usrId = getUserDetails()?.usrId
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
                                
                                // self.arrOfShowData = decodedData.data
                                self.arrOfShowData = self.convertTimeStampToStrOfDatamodel(arry: decodedData.data)
                                
                                self.restoreArrOfShowData = decodedData.data
                                
                                if  let optID = self.optionID , self.arrOfShowData.count > 0 {
                                    let recordCount = DatabaseClass.shared.fetchCustomFormAnswersBy(customFormID: self.objOFTestVC.frmId!, jobID: self.objOfUserJobList.jobId!, optionId: optID)
                                    if recordCount.count > 0{
                                        self.fillFormFromDraft()
                                    }
                                }
                           
                                var frmId = decodedData.data[0].frmId
                                self.frmIdGlobel = decodedData.data[0].frmId ?? ""
                                UserDefaults.standard.set(frmId, forKey: "isDraftJObid")
                                
                                var isDraftgetJobId : String?
                                isDraftgetJobId = UserDefaults.standard.value(forKey: "isDraftgetJobId") as? String
                                
                                var isDraftJObid : String?
                                isDraftJObid = UserDefaults.standard.value(forKey: "isDraftJObid") as? String
                                if isDraftJObid == frmId{
                                    
                                    if isDraftgetJobId == self.objOfUserJobList.jobId {
                                      
                                    }
                                }
                                self.tableView.reloadData()
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
    
    func convertTimeStampToStrOfDatamodel(arry: [CustomFormDetals]) ->  [CustomFormDetals] {
            var dataObj = arry
            
            for (indexPo,itemObj) in dataObj.enumerated() {
                if itemObj.type == "5" || itemObj.type == "6" || itemObj.type == "7"{
                    
                    if let questionAns = itemObj.ans , let firstAns =  questionAns.first, let dateValue =  firstAns.value{
                        let dateFormate : DateFormate = itemObj.type == "5" ? DateFormate.dd_MMM_yyyy : itemObj.type == "6" ? DateFormate.h_mm_a : itemObj.type == "7" ? DateFormate.ddMMMyyyy_hh_mm_a : DateFormate.ddMMMyyyy_hh_mm_a
                        let dateString = createDateTimeForCustomFieldamdFormDraft(timestamp: dateValue, dateFormate: dateFormate.rawValue)
                       
                        dataObj[indexPo].ans?.first?.value = dateString
                        
                    }
                }
            }
            return dataObj
        }
    func saveImageDocumentDirectryPath(image:UIImage,timeFormate:String){
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Create URL
        let url = documents.appendingPathComponent(timeFormate)
        
        // Convert to Data
        if let data = image.pngData() {
            do {
                try data.write(to: url)
            } catch {
                print("Unable to Write Image Data to Disk")
            }
        }
    }
    
    func getImage(imageName:String) -> UIImage?{
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePAth){
            return UIImage(contentsOfFile: imagePAth)
        }else{
            return nil
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
        
    }
    
    func DemosaveUserCustomFormAnsInDataBase( data : [CustomDataRes]) -> Void {
        
        let arrSignature = getSignatures()
        let arrAttacment = getattachments()
        
        for singnature in arrSignature {
                    
                    if let image = singnature.img, let signId = singnature.id , let frmId = singnature.frmId,let jobId = self.objOfUserJobList.jobId,!frmId.isEmpty,!signId.isEmpty  {
                        let imageName = "Photo-\(jobId+frmId+signId).jpg"
                        saveImageDocumentDirectryPath(image: image, timeFormate: imageName)
                    }
                }
                
                for Attacment in arrAttacment {
                    
                    if let attech = Attacment.img, let attechId = Attacment.id,let frmId =  Attacment.frmId,let jobId = self.objOfUserJobList.jobId ,!frmId.isEmpty,!attechId.isEmpty  {
                        let imageName = "Photo-\(jobId+frmId+attechId).jpg"
                        saveImageDocumentDirectryPath(image: attech, timeFormate: imageName)
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
        param.frmId = objOFTestVC.frmId
        param.usrId = getUserDetails()?.usrId
        param.jobId = self.objOfUserJobList.jobId
        
        serverCommunicator(url: Service.getQuestionsByParentId, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(CustomFormResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        if decodedData.data.count > 0 {
                            
                            DispatchQueue.main.async {
                                let CustomFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
                                CustomFormVC.objOFTestVC = self.objOFTestVC
                                  //  CustomFormVC.arrOfShowData = decodedData.data
                                    CustomFormVC.arrOfShowData = self.convertTimeStampToStrOfDatamodel(arry: decodedData.data)
                                   // CustomFormVC.restoreArrOfShowData = decodedData.data
                                // geting record from draft if saved

                                    let record = DatabaseClass.shared.fetchCustomFormAnswersBy(customFormID: self.objOFTestVC.frmId!, jobID: self.objOfUserJobList.jobId!, optionId:optDetails?.key ?? "-100")
                                    if record.count > 0{
                                        CustomFormVC.arrOfShowData = self.fillChildFormFromDraftfrom(form: decodedData.data, data: record)
                                    }
                              
                                CustomFormVC.isCameFrmStatusBtnClk = false
                                CustomFormVC.sltQuestNo = self.sltQuestNo
                                CustomFormVC.customVCArr = self.customVCArr
                                CustomFormVC.sltNaviCount = (self.sltNaviCount! + 1)
                                CustomFormVC.objOfUserJobList = self.objOfUserJobList
                                CustomFormVC.optionID = optDetails?.key

                                
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
        textField.textColor = UIColor.darkGray
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.txtFieldData  = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let customFormDetals = arrOfShowData[textField.tag]
        let opt = OptDetals(key: "0", questions: nil, value: textField.text, optHaveChild: nil)
        let layer = String(format: "%d.1", (textField.tag + 1))
        if  arrOfShowData[textField.tag].ans!.count > 0{ // rohit
            arrOfShowData[textField.tag].ans![0].value = textField.text // rohit
        }else{
            let ans = AnsDetals(key: "0", value: textField.text, layer: "")
            arrOfShowData[textField.tag].ans?.append(ans)
        }

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
        textView.textColor = UIColor.darkGray
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.txtViewData  = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if(self.txtViewData?.trimmingCharacters(in: .whitespaces) == ""){
            textView.textColor = UIColor.lightGray
        }else{
            textView.textColor = UIColor.darkGray
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let customFormDetals = arrOfShowData[textView.tag]
        let opt = OptDetals(key: "0", questions: nil, value: textView.text, optHaveChild: nil)
        let layer = String(format: "%d.1", (textView.tag + 1))
        //   cell.txtView.text = customFormDetals.ans![0].value!
        
        if  arrOfShowData[textView.tag].ans!.count > 0{ // rohit
            arrOfShowData[textView.tag].ans![0].value = textView.text // rohit
        }else{
            let ans = AnsDetals(key: "0", value: textView.text, layer: "")
            arrOfShowData[textView.tag].ans?.append(ans)
        }
        
        self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
    }
    
    //=======================================
    // MARK:- AddAns
    //=======================================
    /*
     usrId -> user id
     answer -> Answer array
     frmId->form id
     
     */
    
    func addAnswer(){
        if !isHaveNetowork() {
            killLoader()
        }else{
            showLoader()
        }
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.answer = APP_Delegate.mainArr
        param.frmId = objOFTestVC.frmId
        param.jobId = self.objOfUserJobList.jobId

        // param for addSignatureAndDoc by Rohit
        var signQueIdArray = [String]()
        var docQueIdArray = [String]()
        var arrSignature = getSignaturesOrAttacment(type: "10")
        var arrAttacment = getSignaturesOrAttacment(type: "11")

        for id in arrSignature {
            signQueIdArray.append(id.id!)
        }
        for id in arrAttacment {
            docQueIdArray.append(id.id!)
        }

        var param2 = [String:Any]()
        param2["answer"] = param.toDictionary!["answer"]
        param2["frmId"] = objOFTestVC.frmId
        param2["docQueIdArray"] = docQueIdArray
        param2["signQueIdArray"] = signQueIdArray
        param2["jobId"] = self.objOfUserJobList.jobId
        param2["usrId"] = getUserDetails()?.usrId
        param2["type"] = ""
        param2["isdelete"] = "1"

        if arrSignature.count > 0 || arrAttacment.count > 0 {
            if !isHaveNetowork() {
                DatabaseClass.shared.deleteCustomFormAns(formID:self.objOFTestVC.frmId!,jobID:self.objOfUserJobList.jobId!, optionId: "")
                APP_Delegate.mainArr.removeAll()
                APP_Delegate.mainArrCustomFormTblCellImages.removeAll()
                let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
                userJobs.apis = Service.addSignatureAndDoc
                userJobs.parametres = param2.toString
                userJobs.time = Date()

                DatabaseClass.shared.saveEntity(callback: {_ in
                    DatabaseClass.shared.syncDatabase()
                    self.navigationController?.popViewController(animated: true)
                })

            } else {
                serverCommunicatorUplaodSignatureAndAttachment(stringUrl: Service.addSignatureAndDoc, method: "POST", parameters: param2, imageSig: arrSignature, imageAtchmnt: arrAttacment, signaturePath: "signAns[]", atchmntPath: "docAns[]") { response, error, succes in
                    arrSignature.removeAll()
                    arrAttacment.removeAll()
                    APP_Delegate.mainArr.removeAll()
                    self.excutApiResult(response: response, success: succes)
                }
            }

        } else {
            if !isHaveNetowork() {

                var arrOfflineFilter = [[String:Any]]()
                if let arrAnswer = param2["answer"] as? [[String:Any]] {
                    for objAns in arrAnswer {
                        if objAns.keys.contains("ans") {
                        
                            if let strObject = objAns.toString, strObject != "", !strObject.contains("ATTACHMENT.png") {
                                arrOfflineFilter.append(objAns)
                            }
                        }
                    }
                    param2["answer"] = arrOfflineFilter
                }

                DatabaseClass.shared.deleteCustomFormAns(formID:self.objOFTestVC.frmId!,jobID:self.objOfUserJobList.jobId!, optionId: "")
                APP_Delegate.mainArr.removeAll()
                APP_Delegate.mainArrCustomFormTblCellImages.removeAll()
                let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
                userJobs.apis = Service.addAnswer
                userJobs.parametres = param2.toString
                userJobs.time = Date()

                DatabaseClass.shared.saveEntity(callback: {_ in
                    DatabaseClass.shared.syncDatabase()
                    self.navigationController?.popViewController(animated: true)
                })

            } else{
                //////////////////////////////////////////////
                var arrFilter = [CustomDataRes]()
                if let arrAns = param.answer {
                    for objAns in arrAns {
                        if let ans = objAns.ans {
                            for obj in ans {
                                if let value = obj.value , value != "ATTACHMENT.png" {
                                    arrFilter.append(objAns)
                                }
                            }
                        }
                    }
                    param.answer = arrFilter
                }
                //////////////////////////////////////////////
                serverCommunicator(url: Service.addAnswer, param: param.toDictionary) { (response, success) in
                    self.excutApiResult(response: response, success: success)
                }
            }
        }
    }
    
    
    func excutApiResult(response: Any?,success: Bool) {
        killLoader()
        if(success){
            let decoder = JSONDecoder()
            
            if let decodedData = try? decoder.decode(CustomFormResponse.self, from: response as! Data) {
                
                if decodedData.success == true{
                    
                    DatabaseClass.shared.storeCustomFormSubmitStatus(formID: objOFTestVC.frmId!, jobID: objOfUserJobList.jobId!, subStatus: decodedData.success)
                    DatabaseClass.shared.deleteCustomFormAns(formID:self.objOFTestVC.frmId!,jobID:self.objOfUserJobList.jobId!, optionId: "")
                    //Remove Image in File Manager in Mobile : -
                    for index in arrOfflineImage {
                        deleteFileForImage(fileName: index)
                    }
                    APP_Delegate.mainArr.removeAll()
                    APP_Delegate.mainArrCustomFormTblCellImages.removeAll()
                    let isDraftJObid = ""
                    UserDefaults.standard.set(isDraftJObid, forKey: "isDraftJObid")
                    var frmId = ""
                    UserDefaults.standard.set(frmId, forKey: "isDraftJObid")
                    
                    self.customansArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "CustomAns", query: nil) as! [CustomAns]
                    
                    for job in self.customansArr{
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                    }
                    
                    self.customVCArr.removeAll()
                    if  decodedData.message == getServerMsgFromLanguageJson(key: "ans_added"){
                        APP_Delegate.mainArr.removeAll()
                    }

                    //rohit
                    //                        let alert = UIAlertController(title: LanguageKey.submitted, message: AlertMessage.frm_updated, preferredStyle: .alert)
                    //
                    //                        alert.addAction(UIAlertAction(title: LanguageKey.ok as NSString as String, style: UIAlertAction.Style.default, handler: { _ in
                    //                            DispatchQueue.main.async {
                    //                                self.navigationController?.popViewController(animated: true)
                    //                            }                                }))
                    //                        DispatchQueue.main.async {
                    //                            self.present(alert, animated: false, completion: nil)
                    //                        }
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
            let isDraftHide = false
            UserDefaults.standard.set(isDraftHide, forKey: "DraftHide")
            
        }
    }
    
    func resetView() -> Void {
        //        let indexpathRow = btn.tag
        //        let indexPathSection = IndexPath(row: indexpathRow, section: 0)
        //        let cell = tableView.cellForRow(at: indexPathSection) as! earthTableViewCell
        //        indexPathSignrCell = IndexPath(row: indexpathRow, section: 0)
        //        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! earthTableViewCell
        //         cell.AddSignature_view.clear()
        //        tableView.reloadData()
    }
    
    //======================================================
    // MARK: Signature delegate methods
    //======================================================
    
    
    func didStart() {
        //let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! earthTableViewCell
        // print("Start Signature")
    }
    
    func didFinish() {
        //let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! earthTableViewCell
        //  print("Finish Signature")
    }
    
    @objc func btnSelectForAddSign(btn: UIButton){
        let indexpathRow = btn.tag
        
        showBackgroundView()
        view.addSubview(uperView)
        uperView.center = CGPoint(x: backGroundView.frame.width / 2, y: backGroundView.frame.height / 2)
        let indexPathSection = IndexPath(row: indexpathRow, section: 0)
        let cell = tableView.cellForRow(at: indexPathSection) as! earthTableViewCell
        indexPathSignrCell = IndexPath(row: indexpathRow, section: 0)
    }
    
    @objc func deleteSignView(btn: UIButton){
        let qusID = arrOfShowData[btn.tag].queId
        
        if qusID != ""{
                if let idx = self.cellImages.firstIndex(where: { $0.questionId ==  qusID }){
                    self.cellImages[idx].img = nil
                    let indexPath = IndexPath(row: btn.tag, section: 0)
                    
                    let cell = tableView.cellForRow(at: indexPath) as! earthTableViewCell
                    cell.img.image = nil // rohit
                        tableView.reloadRows(at: [indexPath], with: .fade)
                }
        }
        
    }
    
    //======================================================
    // MARK: Sinature & Document Api Calling
    //======================================================
    
    
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
    
    func deleteFileForImage(fileName : String) -> Bool{
        
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePath = docDir.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: filePath)
            print("File deleted")
            return true
        }
        catch {
            print("Error")
        }
        return false
    }
    
}//END


extension CustomFormVC {
    func getSignaturesOrAttacment(type: String) -> [ImageModel] {
           var imagesSignature = [ImageModel]()
           for (indexPo,itemOne) in APP_Delegate.mainArrCustomFormTblCellImages.enumerated() {
               if itemOne.cellType == type  {
                   var imgModel = ImageModel()
                   if let imgg = itemOne.img {
                       imgModel.id = itemOne.questionId
                       imgModel.img = imgg
                       imgModel.frmId = itemOne.frmId
                       imagesSignature.append(imgModel)
                   }
               }
           }
           return imagesSignature
       }
    func getSignatures() -> [ImageModel] {
        var imagesSignature = [ImageModel]()
        for (indexPo,itemOne) in self.cellImages.enumerated() {
            if itemOne.cellType == "10"  {
                var imgModel = ImageModel()
                if let imgg = itemOne.img {
                    imgModel.id = itemOne.questionId
                    imgModel.img = imgg
                    imgModel.frmId = itemOne.frmId
                    imagesSignature.append(imgModel)
                }
            }
        }
        return imagesSignature
    }
    
    func getattachments() -> [ImageModel] {
        var imagesAttachments = [ImageModel]()
        for (indexPo,itemOne) in self.cellImages.enumerated() {
            if itemOne.cellType == "11"  {
                var imgModel = ImageModel()
                if let imgg = itemOne.img {
                    imgModel.id = itemOne.questionId
                    imgModel.img = imgg
                    imgModel.frmId = itemOne.frmId
                    imagesAttachments.append(imgModel)
                }
            }
        }
        return imagesAttachments
    }
    
    func isImageExistAtIndex(indxPath: IndexPath) -> Int? {
        if let idx = self.cellImages.firstIndex(where: { $0.indexpth?.row ==  indxPath.row }) {
            return idx
        }
        return nil
    }
    
    func isImageExistAtQuestionID(questionID: String) -> Int? {
            if let idx = self.cellImages.firstIndex(where: { $0.questionId ==  questionID }) {
                return idx
            }
            return nil
        }
    
    func saveImageAtIndex(image: UIImage?, atindex: Int) {
        if let img = image{
            self.cellImages[atindex].img = img
            
        }
    }
   
    func updateImageAtQuestionID(image: UIImage?, QuestionID: String) {
           
             if let img = image{
                 if let idx = self.cellImages.firstIndex(where: { $0.questionId ==  QuestionID }){
                     self.cellImages[idx].img = img
                 }
             }
       }
    
    func saveImageInArray(image: UIImage?, atindexpath: IndexPath,quId:String,celltype:String,frmId:String) {
         
           if let img = image{
               
               if let idx = self.cellImages.firstIndex(where: { $0.questionId ==  quId }){
                   self.cellImages[idx].img = img
               }else{
                   var imgModel = CellImageAtIndexPath()
                   imgModel.indexpth = atindexpath
                   imgModel.img = img
                   imgModel.questionId = quId
                   imgModel.cellType = celltype
                   imgModel.frmId = frmId
                   cellImages.append(imgModel)
               }
           }
       }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}


extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        @objc class ClosureSleeve: NSObject {
            let closure:()->()
            init(_ closure: @escaping()->()) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}


struct CellImageAtIndexPath {
    var img: UIImage?
    var indexpth: IndexPath?
    var questionId: String?
    var cellType: String?
    var frmId: String?
    
}
extension UIImage {
    
    func isEqualToImage(_ image: UIImage) -> Bool {
        return self.pngData() == image.pngData()
    }
    
}

extension String {
    func getFileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func getFileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
