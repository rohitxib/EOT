//
//  RemarkVC.swift
//  EyeOnTask
//
//  Created by Mojave on 12/11/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import MessageUI
import Photos
import CoreData
import MobileCoreServices
import JJFloatingActionButton
class RemarkVC:  UIViewController , OptionViewDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate , UITextViewDelegate {
    var isPresented = false
    
    
    @IBOutlet weak var collactionView_H: NSLayoutConstraint!
    @IBOutlet weak var tblView_H: NSLayoutConstraint!
    @IBOutlet weak var costomForm: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var attchemntLbl: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var uploadLbl: UILabel!
    @IBOutlet weak var uploadTileLbl: UILabel!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var statusVw: UIView!
    @IBOutlet weak var lblEqName: UILabel!
    @IBOutlet weak var remarkCollectionView: UICollectionView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var txtRemark: UITextView!
    @IBOutlet weak var btnLblCondition: UIButton!
    @IBOutlet weak var uploadHieght: NSLayoutConstraint!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnCondition: UIButton!
    @IBOutlet weak var lblRemarkName: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    var image : UIImage?
    // var uploadImage : UIImage? = nil
    var name : String?
    var equipmentStatus = EquipmentStatus()
    var getValue = ""
    var equipementStatus : [ConditionType]  = [.Good, .Poor , .Replace]
    var selectedCondition = ConditionType.Good
    var locationlat:String?
    var locationlng:String?
    var uploadImage : UIImage? = nil
    //var equipment : EquipementListData?
    var equipment : equipDataArray?
    var updateEquipement = [String:Any]()
    var optionalVw : OptionalView?
    var currentStatusID : String? = nil
    var imagePicker = UIImagePickerController()
    var equipmentDetail = AuditOfflineList()
    var arrOfShowData:equipDataArray?
    var arrOfShowData1 = [AuditDocResDataDetails]()
    var imageThumbNail = ""
    let screenWidth = UIScreen.main.bounds.width
    var auditDetail:AuditOfflineList?
    var arrOfRemarkAttcment : AttechmentArry?
    var auditDetaiData:AuditOfflineList?
    var auditDataArray = [AuditOfflineList]()
    var tableViewData = [CustomDataRes]()
    // var arrOfImage = [AttechmentArry]()
    let screenHeight = UIScreen.main.bounds.height
    var callback: ((Bool,NSManagedObject) -> Void)?
    var arrOfShowDataArr = [TestDetails]()
    var txtFieldData : String?
    var txtViewData : String?
    var objOFTestVC : TestDetails?
    var arrOfShowData11 = [CustomFormDetals]()
    var sltFormIdx : Int?
    var sltQuestNo : String?
    var sltNaviCount : Int?
    var customVCArr = [CustomDataRes]()
    var callBackFofDetailJob: ((Bool) -> Void)?
    var clickedEvent : Int?
    var objOfUserJobList = UserJobList()
    var isCameFrmStatusBtnClk : Bool!
    var selectedTxtField : UITextField?
    var sstring : String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        let searchQuery = "audId = '\(equipment?.audId ?? "")'"
        auditDataArray = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: searchQuery) as! [AuditOfflineList]
        
        
        //  print(arrOfShowDataArr.count)
        // var aa = arrOfShowDataArr[0].frmId
        if objOFTestVC?.mandatory == "1"{
            
        }
        
        
        tableView.estimatedRowHeight = 200
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobCustomForm)
        
        
        // addRemark()
        //print(self.remarkCollectionView.isHidden)
        self.remarkCollectionView.isHidden = false
        self.ImageView.isHidden = true
        self.remarkCollectionView.reloadData()
        // print(equipment)
        setLocalization()
        SetBackBarButtonCustom()
        self.navigationController?.navigationBar.backItem?.title = ""
        LocationManager.shared.startStatusLocTracking()
        lblEqName.text = (equipment?.equnm != nil) ?  equipment!.equnm! : ""
        lblAddress.text = (equipment?.location != nil) ?  equipment!.location! : ""
        txtRemark.text = equipment?.remark
        currentStatusID = equipment?.status
        // var images = ""
        // getDocumentsList()
        //getAuditAttachments()
        
        
        if let statusId = equipment?.status {
            
            if statusId != "" && statusId != "0" {
                let status = Int(statusId)!-1
                if status > 0 {
                    // var StatusIdArray = ["16","1038","1549","527"]
                    //var StatusNameArray = ["Good","Need to be Repaired","Not Working","Poor"]
                    let status = Int((equipment?.status)!) //getDefaultSettings()!.equipmentStatus
                    if status == 16 {
                        btnLblCondition.setTitle("Good", for: .normal)
                    } else if status == 1038 {
                        btnLblCondition.setTitle("Need to be Repaired", for: .normal)
                    }else if status == 1549 {
                        btnLblCondition.setTitle("Not Working", for: .normal)
                    }else if status == 527 {
                        btnLblCondition.setTitle("Poor", for: .normal)
                    }
                    
                }else{
                    
                }
            }else{
                // selctionID = getDefaultSettings()?.equipmentStatus[0] as! EquipmentStatus
                btnLblCondition.setTitle("Good", for: .normal)
            }
        }
        
        ActivityLog(module:Modules.equipment.rawValue , message: ActivityMessages.auditEquipmentRemark)
        getFormName()
        // self.getQuestionsByParentId()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //  self.navigationItem.title = objOFTestVC?.frmnm
        //self.tableView.reloadData()
    }
    
    func moveCustomVC(arrOfRelatedObj : [TestDetails] , idx : Int ){

            
            let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "remarkTab") as! RemarkVC
            customFormVC.objOFTestVC = arrOfRelatedObj[idx + 1]
            customFormVC.sltNaviCount = (self.sltNaviCount! + 1)
            customFormVC.isCameFrmStatusBtnClk = isCameFrmStatusBtnClk
            customFormVC.callBackFofDetailJob = self.callBackFofDetailJob
            customFormVC.clickedEvent = self.clickedEvent != nil ? self.clickedEvent : nil
            customFormVC.objOfUserJobList = self.objOfUserJobList

            self.navigationController?.navigationBar.topItem?.title = " "
            self.navigationController?.pushViewController(customFormVC, animated: true)
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
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                func SetBackBarButtonCustom()
                {
                    //Back buttion
                    let button = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(AuditVC.onClcikBack))
                           self.navigationItem.leftBarButtonItem  = button
                }

                @objc func onClcikBack()
                {
                    _ = self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
                func setLocalization() -> Void {
                    // self.navigationItem.title = LanguageKey.add_remark
                    self.navigationItem.title = LanguageKey.add_remark //LanguageKey.job_details
                    btnMap.setTitle(LanguageKey.map , for: .normal)
                    lblCondition.text = LanguageKey.condition
                    lblRemarkName.text = LanguageKey.remark
                    attchemntLbl.text = LanguageKey.attachment
                    uploadLbl.text = LanguageKey.expense_upload
                    uploadTileLbl.text = LanguageKey.doc_here
                    costomForm.text = LanguageKey.title_cutomform
                    if equipment?.status == "0" || equipment?.status == ""{
                        btnUpdate.setTitle(LanguageKey.submit_btn , for: .normal)
                    }else{
                        btnUpdate.setTitle(LanguageKey.update_btn , for: .normal)
                    }

                }
       
                @IBAction func btnSubmit(_ sender: UIButton) {
                    
                     getLocationAndUpdateRemarkOnServer()
                }
                
                @IBAction func pressedMapButton(_ sender: Any) {
                    
                }
                
                @IBAction func pressedConditionButton(_ sender: Any) {
                    self.openDwopDown()
                }
                
                
                override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
                       if identifier == "remarkMap" {
                           if equipment?.lat == nil || equipment?.lng == nil || equipment?.lat == "" || equipment?.lng == "" || equipment?.lat == "0" || equipment?.lng == "0" {
                              self.showToast(message: AlertMessage.locationNotAvailable)
                               return false
                           }
                       }
                       return true
                   }
                   
                   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                       if segue.identifier == "remarkMap"{
                           let mapVw = segue.destination as! MapVC
                           mapVw.lattitude = equipment?.lat
                           mapVw.longitude = equipment?.lng
                           mapVw.address = lblAddress.text
                       }
                   }
                
                @IBAction func uploadBtn(_ sender: Any) {
                    
                    
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
                                self.remarkCollectionView.isHidden = true
                                self.ImageView.isHidden = true
                                //self.HightTopView.constant = 55
                                
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
                                self.remarkCollectionView.isHidden = true
                                self.ImageView.isHidden = true
                                //self.HightTopView.constant = 55
                                
                            })
                        }
                    }
                    
                    let document = UIAlertAction(title: LanguageKey.document, style: .default)
                    { _ in
                        
                        
                        let kUTTypeDOC = "com.microsoft.word.doc" // for Doc file
                        let kUTTypeDOCX = "org.openxmlformats.wordprocessingml.document" // for Docx file
                        let kUTTypeXls = "com.microsoft.excel.xls"
                        let kUTTypeXlsx = "org.openxmlformats.spreadsheetml.sheet"
                        
                        //'jpg','png','jpeg','pdf','doc','docx','xlsx','csv','xls'
                        //                                       let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeCommaSeparatedText),kUTTypeXls,kUTTypeXlsx,kUTTypeDOCX,kUTTypeDOC], in: .import)
                        //                                       documentPicker.delegate = self
                        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeCommaSeparatedText),kUTTypeXls,kUTTypeXlsx,kUTTypeDOCX,kUTTypeDOC], in: .import)
                        documentPicker.delegate = self
                        APP_Delegate.showBackButtonTextForFileMan()
                        self.present(documentPicker, animated: true, completion: nil)
                    }
                    
                    actionSheetControllerIOS8.addAction(gallery)
                    actionSheetControllerIOS8.addAction(camera)
                    actionSheetControllerIOS8.addAction(document)
                    self.present(actionSheetControllerIOS8, animated: true, completion: nil)
                    
                    
                    
                    
                }
    
           
                
                
                
                func getLocationAndUpdateRemarkOnServer(){
                    
                    if LocationManager.shared.isCheckLocation() {
                        updateRemark(equipementdata:equipment,lat:"\(LocationManager.shared.currentLattitude)",lon:"\(LocationManager.shared.currentLongitude)")
                        //self.updateStatusOnServer(lat: "\(LocationManager.shared.currentLattitude)", lon: "\(LocationManager.shared.currentLongitude)")
                    }else{
                         updateRemark(equipementdata:equipment,lat:"0.0",lon:"0.0")
                        //UdateIamge(attachment:arrOfImage!,equipementdata:equipment,lat:"0.0",lon:"0.0")
                        //updateStatusOnServer(lat: "0.0", lon: "0.0")
                    }
                }
                
                
                // ================================
                //  MARK: Open Drop Down
                // ================================
                func openDwopDown() {
                    
                    if (optionalVw == nil){
                        self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
                        let sltTxtfldFrm = btnLblCondition.convert(btnLblCondition.bounds, from: self.view)
                        self.optionalVw?.setUpMethod(frame: CGRect(x: 20, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height-5), width: self.view.frame.size.width - 40, height: 80))
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
                        //self.backgroundView.isHidden = true
                        self.optionalVw?.removeFromSuperview()
                        self.optionalVw = nil
                    }
                }
                
                func hideBackgroundView() {
                    if ((optionalVw) != nil){
                        removeOptionalView()
                    }
                    
                }
                //====================================================
                //MARK:- OptionView Delegate Methods
                //====================================================
                func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                   return (getDefaultSettings()?.equipmentStatus.count)!
                }
                
                func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                      var cell = tableView.dequeueReusableCell(withIdentifier:"cell")
                             if(cell == nil){
                                 cell = UITableViewCell.init(style: .default, reuseIdentifier:"cell")
                             }
                             //let status : String = String(describing: getDefaultSettings()?.equipmentStatus[indexPath.row])
                             let statusValue = getDefaultSettings()?.equipmentStatus[indexPath.row]
                             cell?.textLabel?.text = statusValue!.statusText
                             cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
                             cell?.backgroundColor = .clear
                             cell?.textLabel?.textColor = UIColor.darkGray
                             cell?.isUserInteractionEnabled = true
                             
                             return cell!
                }
                
                
                func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                   //self.removeOptionalView()
                    let statusValueText =  getDefaultSettings()?.equipmentStatus[indexPath.row]
                      
                    
                      getValue = getDefaultSettings()?.equipmentStatus[indexPath.row].esId! as! String
                      //UserDefaults.standard.set(getValue, forKey: "equipStatus")
                      equipmentStatus = getDefaultSettings()?.equipmentStatus[indexPath.row] as! EquipmentStatus
                      
                      btnLblCondition.setTitle("\(String(describing: statusValueText!.statusText!))", for: .normal)
                      
                      self.removeOptionalView()        }
                
                
                func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                    return 40.0
                }
                
                
                //==================================
                    // MARK:- Remark  Service methods
                    //==================================
            
    func UdateIamge(attachment:EquipModel,equipementdata:equipDataArray?,lat:String,lon:String)
            {

                               let itemDt = equipementData()
                  
                               itemDt.attachments = attachment.data
                               //print(equipment?.audId)
                                                  let searchQuery = "audId = '\(equipment?.audId ?? "")'"
                                                      let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: searchQuery) as! [AuditOfflineList]
                                                      if isExist.count > 0 {
                                                          let existingJob = isExist[0]

                                                         if existingJob.equArray != nil {
                                                             let item = (existingJob.equArray as! [AnyObject])
                                                             var arrItem = [Any]()
                                                             
                                                             for itam1 in item {
                                                                 let ijmt = itam1["equId"] as? String
                                                               
                                                            //   print(ijmt)
                                                             //  print(itemDt.equId)
                                                                 if ijmt == itemDt.equId{
                                                                    // itam1 = itemDt.toDictionary as AnyObject
                                                                     arrItem.append(itemDt.toDictionary as Any)
                                                                 }else{
                                                                     arrItem.append(itam1)
                                                                 }
                                                             }
                                                             existingJob.equArray = arrItem as NSObject
                                                             //print(item.count)

                                                         // item.append(itemDt)

                                                      }
                                                         DatabaseClass.shared.saveEntity(callback: {_ in
                                                                            
                                                         })
                                                      }
                
            }
    
            
                    
        func updateRemark(equipementdata:equipDataArray?,lat:String,lon:String) {

            showLoader()
            
            let itemDt = equipementData()
            
            itemDt.equId =  equipementdata?.equId
            itemDt.equnm =  equipementdata?.equnm
            itemDt.mno =  equipementdata?.mno
            itemDt.sno =  equipementdata?.sno
            itemDt.audId =  equipementdata?.audId
            itemDt.remark =  trimString(string: txtRemark.text!)
            itemDt.changeBy =  equipementdata?.changeBy
            itemDt.status =  "\(getValue)"
            // itemDt.status =  "\(selectedCondition.rawValue)"
            itemDt.updateData =  equipementdata?.updateData
            itemDt.lat =  equipementdata?.lat
            itemDt.lng =  equipementdata?.lng
            itemDt.location =  equipementdata?.location
            itemDt.contrid =  equipementdata?.contrid
            itemDt.attachments =  equipementdata?.attachments
            
            let searchQuery = "audId = '\(equipment?.audId ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: searchQuery) as! [AuditOfflineList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                
                if existingJob.equArray != nil {
                    let item = (existingJob.equArray as! [AnyObject])
                    var arrItem = [Any]()
                    
                    for itam1 in item {
                        let ijmt = itam1["equId"] as? String
                        
                        //print(ijmt)
                        // print(itemDt.equId)
                        if ijmt == itemDt.equId{
                            // itam1 = itemDt.toDictionary as AnyObject
                            arrItem.append(itemDt.toDictionary as Any)
                        }else{
                            arrItem.append(itam1)
                        }
                    }
                    existingJob.equArray = arrItem as NSObject
                    // print(item.count)
                    
                    // item.append(itemDt)
                    
                }
                DatabaseClass.shared.saveEntity(callback: {_ in
                    
                })
            }
            
            
            if !isHaveNetowork() {
                
                
                
                let param = Params()
                param.audId = equipment?.audId
                param.equId = equipment?.equId
                param.status = "\(getValue))"
                // param.status = "\(selectedCondition.rawValue)"
                param.remark = trimString(string: txtRemark.text!)
                param.lat = lat
                param.lng = lon
                // param.isJob = " "
                param.usrId = getUserDetails()?.usrId
                // param.answerArray = [customItem]
                var dict =  param.toDictionary
                
                
                
                let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
                userJobs.apis = Service.getupdateAuditEquipment
                userJobs.parametres = dict?.toString
                // print(dict)
                userJobs.time = Date()
                
                DatabaseClass.shared.saveEntity(callback: {_ in
                    DatabaseClass.shared.syncDatabase()
                       killLoader()
                    self.navigationController?.popToRootViewController(animated: true)
                    self.remarkCollectionView.isHidden = false
                    self.ImageView.isHidden = true
                })
                
            }else{
                addRemark()
            }
            
            
            
    }
    
    
    
    func addRemark(){
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            // hideloader()
            return
        }
        
        
        
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
        
        var parm = [String: Any]()
        
        parm["audId"] = equipment?.audId
        parm["equId"] = equipment?.equId
        parm["status"] = "\(getValue))"
        parm["remark"] = trimString(string: txtRemark.text!)
        parm["lat"] = "0.0"
        parm["lng"] = "0.0"
        parm["isJob"] = ""
        parm["usrId"] = getUserDetails()?.usrId
        parm["answerArray"] = convertIntoJSONString(arrayObject: questions)
        
        print(parm)
        let images = (ImageView.image != nil) ? [ImageView.image!] : nil
        
        
        
        
        serverCommunicatorUplaodImageInArray(url: Service.getupdateAuditEquipment, param: parm, images: images, imagePath: "ja[]") { (response, success) in
            //killLoader()
            //   print(response)
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(EquipModel.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        // print(decodedData.data!)
                        
                        if let dataObject = decodedData.data {
                            for eqData in dataObject {
                                self.equipment?.attachments?.append(eqData)
                                if self.auditDetail?.equArray != nil {
                                    var attachments =  (self.auditDetail?.equArray as AnyObject)["attachments"] as! [AnyObject]
                                    let attachmentDict = eqData.toDictionary
                                    attachments.append(attachmentDict as AnyObject)
                                }
                                
                            }
                            DatabaseClass.shared.saveEntity(callback: {_ in })
                        }
                        
                        
                        //self.arrOfImage = decodedData.data!
                        // // self.remarkCollectionView.reloadData()
                        //self.ImageView.isHidden = true
                        //self.UdateIamge(attachment:decodedData,equipementdata:self.equipment,lat:"0.0",lon:"0.0")
                        //                                            var  imageThumbNail = decodedData.data!
                        //                                            for image in imageThumbNail {
                        //                                                 imageThumbNail = image.attachThumnailFileName
                        //                                            }
                        //  itemDt.attachments = equipementdata?.imageThumbNail.At
                        DispatchQueue.main.async {
                            killLoader()
                            self.navigationController?.popToRootViewController(animated: true)
                            self.showToast(message:LanguageKey.euipment_remark_update)
                            // self.navigationController?.popViewController(animated: true)
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
            
            
            
            
            
            
            
            
            
            public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//            if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
//            ImageView.image = image as? UIImage
//
//
//            // btnUplaod.alpha = 1.0
//
//            }
//
//            //self.btnRemove.isHidden = true
//            self.ImageView.isHidden = false
//            //self.HightTopView.constant = 150
//
//            self.dismiss(animated: true, completion: { () -> Void in
//
//            })
                
                ///
             //   let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
                                                 
                
                self.dismiss(animated: true, completion: { () -> Void in
                    
                })
                
                
                let status = PHPhotoLibrary.authorizationStatus()
                if (status == .denied || status == .restricted) {
                    ShowAlert(title: "", message: LanguageKey.photo_denied, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
                    return
                }else{
                    PHPhotoLibrary.requestAuthorization { (authStatus) in
                        if authStatus == .authorized{
                            let imageAsset = PHAsset.fetchAssets(with: .image, options: nil)
                            // for index in 0..<imageAsset.count{
                            
                            if imageAsset.count > 0{
                                let asset = imageAsset.firstObject
                                let imgFullName = asset?.value(forKey: "filename") as! String
                                let arr = imgFullName.components(separatedBy: ".")
                                let imgExtension = arr.last
                                let imgName = imgFullName.replacingOccurrences(of: ".\(imgExtension!)", with: "")
                                // if let image = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
                                if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
                                    let imgStruct = ImageModel_RemarkVC(img: (info[.originalImage] as? UIImage)?.resizeImage_RemarkVC(targetSize: CGSize(width: 1000.0, height: 1000.0)))
                                    DispatchQueue.main.async {
                                        let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                                        //  vc.image = (image as! UIImage)
                                        vc.image = (imgStruct.img!)
                                        vc.OnlyForCrop = false
                                        vc.OnlycheckMarkCompl = true
                                        vc.name = trimString(string: imgName)
                                        vc.callback = {(modifiedImage, imageName, imageDescription) in
                                            self.uploadImage = modifiedImage
                                            self.ImageView.image =   self.uploadImage//image as? UIImage
                                            // self.uploadDocuments(imgName: imageName, imageDes: imageDescription) { () -> (Void) in
                                            //  DispatchQueue.main.async {
                                            self.ImageView.isHidden = false
                                            vc.navigationController?.popViewController(animated: true)
                                            // }
                                            //}
                                        }
                                        self.navigationController!.pushViewController(vc, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
                
                ////
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
            
            
            
                
                //==============================================================//
                  // open gallary method
                  //==============================================================//
                  
                  func openGallary() {
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
                                                              //self.HightTopView.constant = 55
                                                            
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
                                                            
                                                              //self.imgView.isHidden = true
                                                              //self.HightTopView.constant = 55
                                                              
                                                          })
                                                      }
                                                  }
                              
                                                 let document = UIAlertAction(title: LanguageKey.document, style: .default)
                                                 { _ in
                                                     
                                                     
                                                  let kUTTypeDOC = "com.microsoft.word.doc" // for Doc file
                                                  let kUTTypeDOCX = "org.openxmlformats.wordprocessingml.document" // for Docx file
                                                  let kUTTypeXls = "com.microsoft.excel.xls"
                                                  let kUTTypeXlsx = "org.openxmlformats.spreadsheetml.sheet"
                                                  
                                                  //'jpg','png','jpeg','pdf','doc','docx','xlsx','csv','xls'
                                                  let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeCommaSeparatedText),kUTTypeXls,kUTTypeXlsx,kUTTypeDOCX,kUTTypeDOC], in: .import)
                                                  documentPicker.delegate = self
                                                     APP_Delegate.showBackButtonTextForFileMan()
                                                     self.present(documentPicker, animated: true, completion: nil)
                                                 }
                                                  
                                                  actionSheetControllerIOS8.addAction(gallery)
                                                  actionSheetControllerIOS8.addAction(camera)
                                                  actionSheetControllerIOS8.addAction(document)
                                                  self.present(actionSheetControllerIOS8, animated: true, completion: nil)
                  }
                  
               
                  
                //=====================================
                     // MARK:- Document upload Service
                //=====================================
                  
                func uploadDocuments(imgName : String, imageDes : String, completion : @escaping (()->(Void))) -> Void {
                         
                         if !isHaveNetowork() {
                             DispatchQueue.main.async {
                                 ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                             }
                             return
                         }
                         
                         showLoader()
                         let param = Params()
                          param.audId = equipment?.audId
                          param.equId = equipment?.equId
                          param.status = "\(selectedCondition.rawValue)"
                          param.remark = trimString(string: txtRemark.text!)
                          param.lat = "0.0"
                          param.lng = "0.0"
                         // param.isJob = " "
                          param.usrId = getUserDetails()?.usrId
                          param.des = imageDes
                         
                         
                         serverCommunicatorUplaodImage(url: Service.getupdateAuditEquipment, param: param.toDictionary, image: uploadImage, imagePath: "ja[]", imageName: imgName) { (response, success) in
                             if(success){
                                 let decoder = JSONDecoder()
                                 
                                 completion()
                                 
                                 if let decodedData = try? decoder.decode(EquipModel.self, from: response as! Data) {
                                     if decodedData.success == true{
                                         DispatchQueue.main.async{
                                             
                                             killLoader()
                                             
                                             if(decodedData.data!.count > 0){
                                                // self.lblAleartMsg.isHidden = true
                                             // self.imgEmtAttch.isHidden = true
                                                 self.remarkCollectionView.isHidden = false
                                              self.arrOfShowData?.attachments?.insert(decodedData.data![0], at: 0)
                                                 self.remarkCollectionView.reloadData()
                                                 ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                                 
                                             }else{
                                                 killLoader()
                                                 ShowAlert(title: LanguageKey.success, message:getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                                             }
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
                                     killLoader()
                                     ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                                 }
                             }else{
                                 killLoader()
                                 ShowError(message: errorString, controller: windowController)
                             }
                         }
                     }
                
                
                
                
                
                
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    

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
            showLoader()
            let param = Params()
             param.ansId =  "-1"
             param.frmId = sstring
             param.usrId = ""
             param.jobId = equipment?.audId
             param.equId = equipment?.equId
            
           // print(param.toDictionary)
           // {"ansId":"-1","frmId":"1227","jobId":"94773","equId":"375"}:
            
            
            serverCommunicator(url: Service.getQuestionsByParentId, param: param.toDictionary!) { (response, success) in
                
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
           
                    if let decodedData = try? decoder.decode(CustomFormResponse.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            
                            if decodedData.data.count > 0 {
                                DispatchQueue.main.async {
                                    if self.arrOfShowData11.count > 0 {
                                        if self.arrOfShowData11.count < 2 {
                                            self.tblView_H.constant = 100
                                        }else{
                                            if self.arrOfShowData11.count < 4 {
                                                self.tblView_H.constant = 350
                                                
                                            }else{
                                                if self.arrOfShowData11.count < 6 {
                                                    self.tblView_H.constant = 500
                                                    
                                                }else{
                                                    self.tblView_H.constant = 692
                                                }                                                }
                                            
                                        }
                                        
                                    }else{
                                        self.tblView_H.constant = 0
                                    }
                                }
                                
                                self.arrOfShowData11 = decodedData.data
                               // print(self.arrOfShowData11[0].ans)
                                for i in self.arrOfShowData11{
                                    var nas = [AnsDetals]()
                                    nas = i.ans!
                                    for j in nas {
                                        let key  = j.key
                                        print(key)
                                    }
                                }
                                DispatchQueue.main.async {
                                   // self.lbl_AlertMess.isHidden = true/////////////////////////////////
                                   // self.footerView.isHidden = false/////////////////////////////////

                                    self.arrOfShowData11 = decodedData.data
                                    self.tableView.reloadData()
                                }
                                
                            }else{
                                if self.arrOfShowData11.count == 0{
                                    DispatchQueue.main.async {
                                        self.tableView.isHidden = true
                                        //self.lbl_AlertMess.isHidden = false/////////////////////////////////
                                      //  self.footerView.isHidden = true/////////////////////////////////
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

           // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getQuestionsByParentId) as? String

            showLoader()
            let param = Params()
            param.ansId = optDetails?.key
            param.frmId = sstring//arrOfShowDataArr[0].frmId
            param.usrId = getUserDetails()?.usrId
            param.equId = equipment?.equId
            param.audId = equipment?.audId

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
                                    
                                    
                                   
                                    let CustomFormVC = self.storyboard?.instantiateViewController(withIdentifier: "remarkTab") as! RemarkVC
                                    CustomFormVC.objOFTestVC = self.objOFTestVC
                                    CustomFormVC.arrOfShowData11 = decodedData.data
                                    CustomFormVC.isCameFrmStatusBtnClk = false
                                    CustomFormVC.sltQuestNo = self.sltQuestNo
                                    CustomFormVC.customVCArr = self.customVCArr
                                    CustomFormVC.sltNaviCount = (self.sltNaviCount ?? 0 + 1)
                                    CustomFormVC.objOfUserJobList = self.objOfUserJobList
                              
                                   self.navigationController?.navigationBar.topItem?.title = "\(self.sltNaviCount ?? 0 + 1)"
                                   self.navigationController?.pushViewController( CustomFormVC , animated: true)
                                }

                            }else{
                                //if self.arrOfShowData.count == 0{
                                    DispatchQueue.main.async {
                                        if((self.sltQuestNo?.count)! > 3){
                                            let name: String = self.sltQuestNo!
                                            let endIndex = name.index(name.endIndex, offsetBy: -4)
                                            self.sltQuestNo = String(name[..<endIndex]) //name.substring(to: endIndex)
                                         //   print(name)      // "Dolphin"
                                        //    print(self.sltQuestNo) // "Dolph"
                                            
                                        }
                                    }
                               // }
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
            let customFormDetals = arrOfShowData11[textField.tag]
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
               let customFormDetals = arrOfShowData11[textView.tag]
                let opt = OptDetals(key: "0", questions: nil, value: textView.text, optHaveChild: nil)
                let layer = String(format: "%d.1", (textView.tag + 1))
                self.saveDataIntoTempArray(isAdded: true, layer: layer , optDetail: opt , customFormDetals: customFormDetals)
          
        }
    
    
    //   ================================
    //      MARK: getFormName
    //   ================================
       
       
           func getFormName(){
               if !isHaveNetowork() {
                   return
               }


            
            var dict = [String:Any]()
                        dict["limit"] = ContentLimit
                        dict["index"] = "0"
                        dict["auditType"] = "1"
                        dict["jobId"] = equipment?.audId
                        dict["jtId"] = [(equipment?.ecId)]
                        dict["linkTo"] = "2"
                        //dict["compId"] = auditDataArray[0].compid
         //   print(dict)
               serverCommunicator(url: Service.getCustomFormNmList, param: dict) { (response, success) in
                   
                   killLoader()
                   if(success){
                       let decoder = JSONDecoder()
       
                       if let decodedData = try? decoder.decode(TestRes.self, from: response as! Data) {
       
                           if decodedData.success == true{
                         //   print(decodedData)
                            
                            if decodedData.data.count > 0 {
                                                       //
                                                       DispatchQueue.main.async {
                                                        if  self.equipment?.attachments?.count == 0 {
                                                            self.collactionView_H.constant = 0
                                                            self.remarkCollectionView.isHidden = true
                                                        }
                                                        self.arrOfShowDataArr = decodedData.data
                                                        
                                                      //  self.getQuestionsByParentId(patmid: decodedData.data.frmId!)
                                                        
                                                        self.sstring = decodedData.data[0].frmId!
                                                     //   print(self.sstring)
                                                        self.getQuestionsByParentId()
                                                      // self.tableView.reloadData()
                                                       }
                            }else{
                                 DispatchQueue.main.async {
                                self.tblView_H.constant = 0
                            }
                        }

                           }else{
                               killLoader()
                           }
                       }else{
                           killLoader()
                           ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                       }
                   }else{
                       killLoader()
                   }
               }
           }


    
                
            }

            extension RemarkVC: UICollectionViewDelegate, UICollectionViewDataSource {
                
                func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                    //return self.arrOfFilterData..count > 0 ? self.arrOfFilterData.count :  self.arrOfShowData.count
                    return self.equipment?.attachments?.count ?? 0
                    //return  self.arrOfRemarkAttcment
                    //return self.arrOfShowData1.count
                }
                
                func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageDetailCell", for: indexPath as IndexPath) as! ImageDetailCell
                   // let docResDataDetailsObj = self.arrOfShowData?.attachments?[indexPath.row]
                    let docResDataDetailsObj = self.equipment?.attachments?[indexPath.row]
                    cell.lblfileName.text = docResDataDetailsObj?.attachFileActualName
                    
                    if let img = docResDataDetailsObj?.attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imageView.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: docResDataDetailsObj?.image_name ?? "unknownDoc"))
                    }else{
                        cell.imageView.image = UIImage(named: "unknownDoc")
                    }
                    return cell
                }
                
                
                func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

                    //let docResDataDetailsObj = self.arrOfShowData?.attachments?[indexPath.row]
                    let docResDataDetailsObj = self.equipment?.attachments?[indexPath.row]
                    
                    if let fileUrl = URL(string: (Service.BaseUrl + ((docResDataDetailsObj?.attachFileName! ?? " ")))) {
                              let customView = CustomDocView.instanceFromNib() as? CustomDocView
                              let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
                                  backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)

                        customView!.setupMethod(url: fileUrl, image: nil, imageName: docResDataDetailsObj?.attachFileActualName ?? "", imageDescription:docResDataDetailsObj?.des ?? "") //docResDataDetailsObj.des ?? "")
                                  customView?.completionHandler = {(editedName,editedDes) in

                                    if docResDataDetailsObj?.des != editedDes {
                                        self.updateDocumentDescription(documentid: docResDataDetailsObj?.attachmentId! ?? "", documentDescription: editedDes) {
                                            docResDataDetailsObj?.des = editedDes
                                                 DispatchQueue.main.async {
                                                      customView?.removeFromSuperview()
                                                      backgroundView.removeFromSuperview()
                                                  }

                                             }
                                      }else{
                                          DispatchQueue.main.async {
                                              customView?.removeFromSuperview()
                                              backgroundView.removeFromSuperview()
                                          }
                                      }
                                  

                        
                        }
                        
                        
                    
                                let viewWidth = self.view.bounds.width
                                let viewHeight = self.view.bounds.height

                                 customView!.frame = CGRect(x: (viewWidth/2-(customView!.bounds.width/2)), y: (viewHeight/2-(customView!.bounds.height/2)), width: customView!.bounds.width, height:  customView!.bounds.height)

                                 self.view.addSubview(backgroundView)
                                 self.view.addSubview(customView!)

                    
                    }
                    
                    
                 
                    
                }
                
                func getImage(fileType : String) -> UIImage {
                    
                    //'jpg','png','jpeg','pdf','doc','docx','xlsx','csv','xls'
                    
                    let filename: NSString = fileType as NSString
                    let pathExtention = filename.pathExtension
                    
                    var imageName = ""
                    switch pathExtention {
                    case "jpg","png","jpeg":
                        imageName = "default-thumbnail"
                        
                    case "pdf":
                        imageName = "pdf"
                        
                    case "doc","docx":
                        imageName = "word"
                        
                    case "xlsx","xls":
                        imageName = "excel"
                        
                    case "csv":
                        imageName = "csv"
                        
                    default:
                        imageName = "unknownDoc"
                    }
                    
                    let image = UIImage(named: imageName)
                    return image!
                    
                }
                
                
                //=====================================
                    // MARK:- Update Document Description
                    //=====================================
                    
                    func updateDocumentDescription(documentid : String, documentDescription : String, completion : @escaping (()->(Void))) {
                        
                        
                        if !isHaveNetowork() {
                            DispatchQueue.main.async {
                               
                                self.remarkCollectionView.isHidden = true
                                
                            }
                            return
                        }
                        
                      
                         showLoader()
                        let param = Params()
                        param.jaId = documentid
                        param.des = documentDescription
                        
                        serverCommunicator(url: Service.updateDocument, param: param.toDictionary) { (response, success) in
                            killLoader()
                            
                            completion()
                            if(success){
                                let decoder = JSONDecoder()
                                if let decodedData = try? decoder.decode(CommonResponse.self, from: response as! Data) {
                                    DispatchQueue.main.async {
                                   
                                    }
                                    
                                    if decodedData.success == true{
                                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                    }else{
                                        
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
                                ShowError(message: errorString, controller: windowController)
                            }
                        }
                    }

                
                
                
            }






            extension RemarkVC: UIDocumentPickerDelegate {

             //=============================
             // MARK:- Document picker methods
             //=============================
             func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
                 APP_Delegate.hideBackButtonText()
             }
             
             func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
                 
                 
                 let filename = url.lastPathComponent
                 let splitName = filename.split(separator: ".")
                 let name = splitName.first!
                 let filetype = splitName.last!.lowercased()
                 
                 APP_Delegate.hideBackButtonText()
                 
                 //'jpg','png','jpeg'
                 if filetype == "jpg" || filetype == "png" || filetype == "jpeg" {
                     
                         do {
                             let imageData = try Data(contentsOf: url as URL)
             
                             if let image = UIImage(data: imageData) {
                                 let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                 let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                                 vc.image = (image )
                                 vc.name = trimString(string: String(name))
                                 vc.callback = {(modifiedImage, imageName, imageDescription) in
                                   self.uploadImage = modifiedImage
                                   self.uploadDocuments(imgName: imageName, imageDes: imageDescription) { () -> (Void) in
                                       DispatchQueue.main.async {
                                            vc.navigationController?.popViewController(animated: true)
                                       }
                                   }
                               }
                                 DispatchQueue.main.async {
                                   self.navigationController!.pushViewController(vc, animated: true)
                                 }
                             }
                         }catch {
                             // can't load image data
                         }
                 }else{
                     
                    DispatchQueue.main.async {
                           let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
                           let vc = storyboard.instantiateViewController(withIdentifier: "DocumentEditorVC") as! DocumentEditorVC
                           //vc.image = (image as! UIImage)
                           vc.name = trimString(string: String(name))
                           vc.docUrl = url
                           vc.callbackForDocument = {(fileName, fileDescription) in
                             self.uploadMediaDocuments(fileUrl: url, fileName: fileName, description: fileDescription) { () -> (Void) in
                                  DispatchQueue.main.async {
                                      vc.navigationController?.popViewController(animated: true)
                                 }
                             }
                             
                         }
                           self.navigationController!.pushViewController(vc, animated: true)
                     }
                 
                 }
                 
             }
             

             func uploadMediaDocuments(fileUrl : URL ,fileName : String, description : String, completion : @escaping (()->(Void))) -> Void {
                 
                 if !isHaveNetowork() {
                     DispatchQueue.main.async {
                         ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                     }
                     return
                 }
                 
                 showLoader()
                 let param = Params()
                  param.audId = equipment?.audId
                  param.equId = equipment?.equId
                  param.status = "\(selectedCondition.rawValue)"
                  param.remark = trimString(string: txtRemark.text!)
                  param.lat = "0.0"
                  param.lng = "0.0"
                 // param.isJob = " "
                  param.usrId = getUserDetails()?.usrId
                 param.des = description
                 
                 serverCommunicatorUplaodDocuments(url: Service.getupdateAuditEquipment, param: param.toDictionary, docUrl: fileUrl, DocPathOnServer: "ja", docName: fileName) { (response, success) in
                     
                     completion()
                     
                     if(success){
                         
                         
                         
                         let decoder = JSONDecoder()
                         if let decodedData = try? decoder.decode(EquipModel.self, from: response as! Data) {
                             if decodedData.success == true{
                                 DispatchQueue.main.async{
                                     
                                     killLoader()
                                     
                                     if(decodedData.data!.count > 0){
                                       // self.lblAleartMsg.isHidden = true
                                          //self.imgEmtAttch.isHidden = true
                                            self.remarkCollectionView.isHidden = false
                                            self.arrOfShowData?.attachments?.insert(decodedData.data![0], at: 0)
                                            self.remarkCollectionView.reloadData()
                                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                         
                                     }else{
                                         killLoader()
                                         ShowAlert(title: LanguageKey.success, message:getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                                     }
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
                             killLoader()
                             ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                         }
                     }else{
                         killLoader()
                         ShowError(message: errorString, controller: windowController)
                     }
                 }
                 
             }
                
                
                //=====================================
                    // MARK:- Get all Document List Service
                    //=====================================
                    
                
                
                
                    func getDocumentsList(){
                        
                        if !isHaveNetowork() {
                            DispatchQueue.main.async {
                               //self.lblAlertMess.isHidden = false
                                self.remarkCollectionView.isHidden = true
                                // self.lblAleartMsg.text = LanguageKey.err_check_network
                                

                            }
                            return
                        }
                        
                    
                        let param = Params()
                        
                        param.audId = equipment?.audId
                      //  param.jobId = objOfUserJobListInDoc.jobId
                              param.usrId = getUserDetails()?.usrId
                        //print(param.toDictionary)
                        
                        serverCommunicator(url: Service.getAppointmentDocument, param: param.toDictionary) { (response, success) in
                            killLoader()

                            if(success){
                                let decoder = JSONDecoder()
                                if let decodedData = try? decoder.decode(AuditDocRes.self, from: response as! Data) {
                                    DispatchQueue.main.async {
                                     
                                    }

                                    if decodedData.success == true {
                                        
                                        DispatchQueue.main.async{
                                                                  
                                                                  killLoader()
                                                                  
                                                                   self.remarkCollectionView.isHidden = false
                                            self.arrOfShowData1  = decodedData.data!
                                                                 
                                                                   self.remarkCollectionView.reloadData()
                                                                
                                                                  if (self.arrOfShowData?.attachments?.count)! == 0
                                                                        {
                                                                            self.remarkCollectionView.isHidden = true
                                                                           //self.lblAleartMsg.text = LanguageKey.appointment_attach_msg//"Appointment Attechtment will apear here "
                                                                           // self.imgEmtAttch.isHidden = false
                                                                        }else{
                                                                            self.remarkCollectionView.isHidden = false
                                                                     //self.imgEmtAttch.isHidden = true
                                                                        }
                                        }
                                        
                                       



                                    }else{
                                        
                                         ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)


                                    }
                                }else{
                //                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                                }
                            }else{
                                ShowError(message: errorString, controller: windowController)
                            }
                        }
                    }
                    
                

            }
extension RemarkVC :  UITableViewDelegate, UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrOfShowData11.count
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
       
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let customFormDetals = arrOfShowData11[indexPath.row]

            if customFormDetals.type == "3"{ //checkBox
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
                let cell: SecondTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "secondCustomCell") as! SecondTableViewCell?)!
                
               
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
                             //   print(name)      // "Dolphin"
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
                
                let cell: sixthTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: sixthTableViewCell.identifier) as! sixthTableViewCell?)!
                 
                
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
                
                
            }else if customFormDetals.type == "9" {
                let cell: sixthTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: sixthTableViewCell.identifier) as! sixthTableViewCell?)!
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
                let cell: fifthTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "fifthCustomCell") as! fifthTableViewCell?)!
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
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let customFormDetals = arrOfShowData11[indexPath.row]
            
            if customFormDetals.type == "3" {
                return tableView.estimatedRowHeight
            }else if customFormDetals.type == "2"{
                return tableView.estimatedRowHeight
            }else {
                 return tableView.estimatedRowHeight
            }
    }
        
    
    
}


extension String {
    func height1(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width1(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
 
}

struct ImageModel_RemarkVC {
    var img: UIImage?
   
}

extension UIImage {
    func resizeImage_RemarkVC(targetSize: CGSize) -> UIImage {
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
