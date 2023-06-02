//
//  LinkEquipmentReport.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 23/09/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import MessageUI
import Photos
import CoreData
import MobileCoreServices
import JJFloatingActionButton
class LinkEquipmentReport: UIViewController,OptionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate , UITextFieldDelegate , UITextViewDelegate {
    
    @IBOutlet weak var equipCondationLbl: UIButton!
    @IBOutlet weak var equipConditationBtn: UIButton!
    @IBOutlet weak var equipStatusLbl: UILabel!
    @IBOutlet weak var replaceBtn: UIButton!
    @IBOutlet weak var replaceTittleLbl: UILabel!
    @IBOutlet weak var deployView: UIView!
    @IBOutlet weak var deployDateLbl: UILabel!
    @IBOutlet weak var deployLbl: UILabel!
    @IBOutlet weak var replaceView: UIView!
    @IBOutlet weak var addPartLbl: UILabel!
    @IBOutlet weak var partLbl: UILabel!
    @IBOutlet weak var addItemLbl: UILabel!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var H_itemView: NSLayoutConstraint!
    @IBOutlet weak var H_partView: NSLayoutConstraint!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var partTableView: UITableView!
    @IBOutlet weak var H_collectBigView: NSLayoutConstraint!
    @IBOutlet weak var H_tableView: NSLayoutConstraint!
    @IBOutlet weak var customFormLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var attechmnetLbl: UILabel!
    @IBOutlet weak var uploadLbl: UILabel!
    @IBOutlet weak var btnHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var uploadTitleLbl: UILabel!
    @IBOutlet weak var remarkBtnView: UIView!
    @IBOutlet weak var statusVw: UIView!
    @IBOutlet weak var lblEqName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtRemark: UITextView!
    @IBOutlet weak var btnLblCondition: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnCondition: UIButton!
    @IBOutlet weak var lblRemarkName: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var collectionView_H: NSLayoutConstraint! //246
    @IBOutlet weak var tblView_H: NSLayoutConstraint!
    @IBOutlet weak var equipmntPartBtn: UIButton!
    
    var equipmentStatusVw = ""
    var sltDropDownTag : Int!
    var openDropDwonConditation = true
    var openDropDwonStatus = true
    var equipmentsStatusId = ""
    
    var isPresented = false
    var image : UIImage?
    var imgArr = [ImageModel_LinkEquipmentReport]()
    var poIdNam = ""
    var name : String?
    var getValue = ""
    var equipmentsStatusPart = [getEquipmentStatusDate]()
    var replacePartReport = Bool()
    var equipmentStatus = EquipmentStatus()
    var objOfUserJobListInDetail : UserJobList!
    var objOfUserJobListInDoc = UserJobList()
    var equipementStatus : [ConditionType]  = [.Good, .Poor, .Replace]
    var selectedCondition = ConditionType.Good
    var locationlat:String?
    var locationlng:String?
    var uploadImage : UIImage? = nil
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var refreshControl = UIRefreshControl()
    //var equipment : EquipementListData?
    var equipment : equipDataArray?
    var updateEquipement = [String:Any]()
    var optionalVw : OptionalView?
    var currentStatusID : String? = nil
    var equipmentDetail = AuditOfflineList()
    var arrOfShowData:equipDataArray?
    var arrOfShowData12 = [AuditDocResDataDetails]()
    var arrOfShowData1 = [DocResDataDetails]()
    var imagePicker = UIImagePickerController()
    var callbackDetailVC: ((Bool) -> Void)?
    var callback: ((Bool,NSManagedObject) -> Void)?
    var isNavigate = false
    var sstring : String = ""
    var arrOfShowData11 = [CustomFormDetals]()
    var customVCArr = [CustomDataRes]()
    var sltFormIdx : Int?
    var sltQuestNo : String?
    var selectedTxtField : UITextField?
    var txtFieldData : String?
    var txtViewData : String?
    
    var filterequipmentData = [equComponant]()
    var delegate : partEqDelegate?
    
    var showImg = false
   // var newItemPart = [AllEquipmentItemsData]()
    var itemDetailedData = [ItemDic]()
    var equipmentsStatus = [getEquipmentStatusDate]()
    var equipDataPartDataArr =  [ItemDic]()//[equipDataArrayItem]()
    let isfooter = getDefaultSettings()?.footerMenu
    let JobItemQuantityFormEnable = getDefaultSettings()?.isJobItemQuantityFormEnable
    override func viewDidLoad() {
        super.viewDidLoad()
        self.H_tableView.constant = 0
        self.tblView_H.constant = 0
        getEquipmentStatus()
        setDataForItem()
       
        
        // FOR ITEM PART IS HIDEN :-
        let  isItem = isPermitForShow(permission: permissions.isItemVisible)
        if isfooter?.count != nil {
            for i in 0 ..< isfooter!.count{
                if i < 4 {
                    
                    if isfooter![i].isEnable == "1"{
                        if JobItemQuantityFormEnable == "0" {
                            if isItem && isfooter![i].menuField == "set_itemMenuOdrNo"{
                                
                                self.itemLbl.isHidden = false
                                self.addItemLbl.isHidden = false
                                
                                
                            }else{
                               // print("set_itemMenuOdrNo ===== 1")
                            }
                            
                            
                        }else{
                           // print("set_itemMenuOdrNo ===== 2")
                        }
                        
                        
                    }else{
                     
                        self.itemLbl.isHidden = true
                        self.addItemLbl.isHidden = true
                        self.H_itemView.constant = 0
                      
                      //  print("set_itemMenuOdrNo ===== 3")
                    }
                    
                }
            }
        }
        
        
       // getAllEquipmentItems()
        
        //print(self.equipment?.attachments?.count)
        if self.equipment?.attachments?.count == 0 {
            self.H_collectBigView.constant = 55
            self.collection.isHidden = true
        }else {
            self.H_collectBigView.constant = 200
            self.collection.isHidden = false
        }
    
        
        if filterequipmentData.count == 0 {
            self.H_partView.constant = 55
        }else if filterequipmentData.count == 1 {
            self.H_partView.constant = 150
        }else if filterequipmentData.count == 2 {
            self.H_partView.constant = 300
        }else if filterequipmentData.count == 3 {
            self.H_partView.constant = 450
        }else if filterequipmentData.count == 4 {
            self.H_partView.constant = 600
        }else if filterequipmentData.count == 5 {
            self.H_partView.constant = 750
        }else if filterequipmentData.count == 6 {
            self.H_partView.constant = 900
        }else if filterequipmentData.count == 7 {
            self.H_partView.constant = 1050
        }else if filterequipmentData.count == 8 {
            self.H_partView.constant = 1200
        }else if filterequipmentData.count == 9 {
            self.H_partView.constant = 1350
        }else if filterequipmentData.count == 10 {
            self.H_partView.constant = 1500
        }else if filterequipmentData.count == 11 {
            self.H_partView.constant = 1650
        }
        
        
        let button1 = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: #selector(OpenBarCode))
        self.navigationItem.rightBarButtonItem  = button1
        
        
        
        setLocalization()
        SetBackBarButtonCustom()
        self.navigationController?.navigationBar.backItem?.title = ""
        LocationManager.shared.startStatusLocTracking()
        lblEqName.text = (equipment?.equnm != nil) ?  equipment!.equnm! : ""
        lblAddress.text = (equipment?.location != nil) ?  equipment!.location! : ""
        txtRemark.text = equipment?.remark
        currentStatusID = equipment?.status
        btnLblCondition.setTitle(equipment?.statusText ?? "", for: .normal)
       // print(equipment)
        // getDocumentsList()
        // getAuditAttachments()
        collection.isHidden = false
        collection.reloadData()
        
//        if let statusId = equipment?.status {
//
//
//            if statusId != "" && statusId != "0" {
//                let status = Int(statusId)! - 1
//                if status > 0 {
//                    let status = Int((equipment?.status)!) //getDefaultSettings()!.equipmentStatus
//                    if status == 5666 {
//                        btnLblCondition.setTitle("Good", for: .normal)
//                    } else if status == 1038 {
//                        btnLblCondition.setTitle("Need to be Repaired", for: .normal)
//                    }else if status == 1549 {
//                        btnLblCondition.setTitle("Not Working", for: .normal)
//                    }else if status == 527 {
//                        btnLblCondition.setTitle("Poor", for: .normal)
//                    }
//                }else{
//                    // selectedCondition = equipementStatus[0]
//                    // btnLblCondition.setTitle("\(equipementStatus[0])", for: .normal)
//                }
//            }else{
//                btnLblCondition.setTitle("Good", for: .normal)
//            }
//        }
        
      //  strSelectedCondition = equipment?.statusText ?? ""
       // btnLblCondition.setTitle(strSelectedCondition, for: .normal)
        ActivityLog(module:Modules.equipment.rawValue , message: ActivityMessages.auditEquipmentRemark)
        getFormName()
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        setDataForItem()
       // getEquipmentStatus()
        //  getAllEquipmentItems()
        if showImg == false{
            if self.equipment?.attachments?.count == 0 {
                self.H_collectBigView.constant = 55
                self.collection.isHidden = true
            }else {
                self.H_collectBigView.constant = 200
                self.collection.isHidden = false
            }
        }else{
            self.H_collectBigView.constant = 200
            self.collection.isHidden = true
        }
        
      //  getLocationAndUpdateRemarkOnServer1()
        /*
        let strCondition = getDefaultSettings()?.equipmentStatus.filter {$0.statusText == self.equipment?.statusText }.first?.statusText ?? ""
        self.btnLblCondition.setTitle(strCondition, for: .normal)
        */
    }
    
    func setPartDataArr(equipArray:[equComponant]) {
        filterequipmentData = equipArray
        //partCollactionView.reloadData()
        }
    
   
    
    @objc func OpenBarCode(){
        // print("clicked")
    }
// override func viewWillAppear(_ animated: Bool) {
//        if  (self.equipment?.attachments!.count)! > 0 {
//            self.collectionView_H.constant = 264
//            self.collection.isHidden = false
//        }
//    }
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
        self.navigationItem.title = LanguageKey.add_remark
        btnMap.setTitle(LanguageKey.map , for: .normal)
        lblCondition.text = "\(LanguageKey.condition)*"
        lblRemarkName.text = LanguageKey.remark
        attechmnetLbl.text = LanguageKey.attachment
        uploadLbl.text = LanguageKey.expense_upload
       // uploadTitleLbl.text = LanguageKey.doc_here
        customFormLbl.text = LanguageKey.title_cutomform
        
        addPartLbl.text = LanguageKey.add
        partLbl.text = LanguageKey.parts
        addItemLbl.text = LanguageKey.add
        itemLbl.text = LanguageKey.item
        replaceBtn.setTitle(LanguageKey.replace_equipment , for: .normal)
        
        if equipment?.status == "0" || equipment?.status == ""{
            btnUpdate.setTitle(LanguageKey.submit_btn , for: .normal)
        }else{
            btnUpdate.setTitle(LanguageKey.update_btn , for: .normal)
        }
        
    }
    
    @IBAction func addItemAct(_ sender: Any) {
        
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Invoice", bundle:nil)
        let addVC = storyBoard.instantiateViewController(withIdentifier: "ListItemVC") as! ListItemVC
        addVC.isAdd = true
        addVC.addEquipId = true
        addVC.itenConditionForRemark = true
        addVC.isTittlenameChng = true
        addVC.hidenSigmentView = true
        addVC.eqIdparm = (equipment?.equId)!
        addVC.jobDetail = objOfUserJobListInDetail
        addVC.callbackDetailVC =  {(isUpdate : Bool ) -> Void in

        }
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    @IBAction func replaceBtnAcn(_ sender: Any) {
        var on = self.equipment?.equId
        UserDefaults.standard.set(on, forKey: "ForeReplace")
        var on1 = self.equipment?.equnm
        UserDefaults.standard.set(on1, forKey: "ForeReplaceEqpName")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Invoice", bundle:nil)
        let addVC = storyBoard.instantiateViewController(withIdentifier: "ListItemVC") as! ListItemVC
        addVC.isAdd = true
        addVC.isDissableQntyTxtFld = true
        addVC.hidenSigmentView = true
        addVC.isAddEqup = true
        
        addVC.isTittlenameChng = false
        addVC.jobDetail = objOfUserJobListInDetail
        addVC.callbackDetailVC =  {(isUpdate : Bool ) -> Void in
            
        }
        self.navigationController?.pushViewController(addVC, animated: true)
        
    }
    
    @IBAction func addEqpmtParActn(_ sender: Any) {
        
        var on = self.equipment?.equId
        UserDefaults.standard.set(on, forKey: "ForeReplace")
        var on1 = self.equipment?.equnm
        UserDefaults.standard.set(on1, forKey: "ForeReplaceEqpName")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Invoice", bundle:nil)
        let addVC = storyBoard.instantiateViewController(withIdentifier: "ListItemVC") as! ListItemVC
        addVC.isAdd = true
        addVC.addEquipId = true
        addVC.hidenSigmentView = true
        addVC.isDissableQntyTxtFld = true
        addVC.isAddEqup = true
      
        addVC.eqIdparm = (equipment?.equId)!
        addVC.isTittlenameChng = true
//        addVC.invoiceRes = invoiceRes
        addVC.jobDetail = objOfUserJobListInDetail
        //print(objOfUserJobListInDetail.jobId)
//        addVC.isLocId = locId
        addVC.callbackDetailVC =  {(isUpdate : Bool ) -> Void in
//            if isUpdate {
//                self.displayMsg = AlertMessage.add
//                self.isUpdateItem = false
//                self.updateInvoiceOnServer()
//            }else{
//                self.setData()
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
        }
        self.navigationController?.pushViewController(addVC, animated: true)
        
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        // getLocationAndUpdateRemarkOnServer() // old
        if self.btnLblCondition.currentTitle?.isEmpty  == true {
                 ShowError(message: LanguageKey.status_required, controller: windowController)
                 return
             } else {
                 getLocationAndUpdateRemarkOnServer()
             } 
    }
    
    @IBAction func pressedMapButton(_ sender: Any) {
        
    }
    
    @IBAction func pressedConditionButton(_ sender: Any) {
        self.openDropDwonConditation = true
        self.openDropDwonStatus = false
        self.openDwopDown()
    }
    
    @IBAction func pressedEquipStatusActn(_ sender: Any) {
        self.openDropDwonStatus = true
        self.openDropDwonConditation = false
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
        
        
        // openGallary()
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
                    self.collection.isHidden = true
                    self.imageView.isHidden = true
                    
                    
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
                    self.collection.isHidden = true
                    self.imageView.isHidden = true
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
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
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
                     
                        if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
                            let imgStruct = ImageModel_LinkEquipmentReport(img: (info[.originalImage] as? UIImage)?.resizeImage_LinkEquipmentReport(targetSize: CGSize(width: 1000.0, height: 10000.0)))
                            DispatchQueue.main.async {
                                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                               
                                vc.image = (imgStruct.img!)
                                vc.name = trimString(string: imgName)
                                vc.OnlyForCrop = false
                                vc.OnlyForHideAllTxtView = true
                                vc.OnlycheckMarkCompl = true
                                vc.callback = {(modifiedImage, imageName, imageDescription) in
                                    self.uploadImage = modifiedImage
                                    self.imageView.image =   self.uploadImage//image as? UIImage
                                    // self.uploadDocuments(imgName: imageName, imageDes: imageDescription) { () -> (Void) in
                                    //  DispatchQueue.main.async {
                                    self.imageView.isHidden = false
                                    
//                                    if self.equipment?.attachments?.count == 0 {
//                                        self.H_collectBigView.constant = 55
//                                        self.collection.isHidden = true
//                                    }else {
                                        self.showImg = true
                                        self.H_collectBigView.constant = 200
                                        self.collection.isHidden = true
                                   // }
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
        
        ////////
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
    
    
    
    
    func  updateStatusOnServer(lat:String,lon:String){
        
        if !isHaveNetowork() {
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        showLoader()
        let param = Params()
        param.audId = equipment?.audId
        param.equId = equipment?.equId
        param.status = "\(selectedCondition.rawValue)"
        param.remark = trimString(string: txtRemark.text!)
        param.lat = lat
        param.lng = lon
        
        serverCommunicator(url: Service.getupdateAuditEquipment, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(CommonResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        windowController.showToast(message: getServerMsgFromLanguageJson(key: decodedData.message!)!)
                        self.equipment?.status = "\(self.selectedCondition.rawValue)"
                        self.equipment?.remark = param.remark
                        
                        
                        NotiyCenterClass.fireRefreshEquipmentListNotifier(dict: (self.equipment?.toDictionary)!)
                        
                        DispatchQueue.main.async {
                            if self.isPresented {
                                self.dismiss(animated: true, completion: nil)
                            }else{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        windowController.showToast(message: getServerMsgFromLanguageJson(key: decodedData.message!)!)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        
                        if cancel {
                            showLoader()
                            self.updateStatusOnServer(lat: lat, lon: lon)
                        }
                    })
                }
            }else{
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.updateStatusOnServer(lat: lat, lon: lon)
                    }
                })
            }
        }
    }
    
    func getLocationAndUpdateRemarkOnServer(){
        
        if LocationManager.shared.isCheckLocation() {
            updateRemark(equipementdata:equipment,lat:"\(LocationManager.shared.currentLattitude)",lon:"\(LocationManager.shared.currentLongitude)")
            //self.updateStatusOnServer(lat: "\(LocationManager.shared.currentLattitude)", lon: "\(LocationManager.shared.currentLongitude)")
        }else{
            updateRemark(equipementdata:equipment,lat:"0.0",lon:"0.0")
            //updateStatusOnServer(lat: "0.0", lon: "0.0")
        }
    }
    
    func getLocationAndUpdateRemarkOnServer1(){
          
          if LocationManager.shared.isCheckLocation() {
              updateRemark1(equipementdata:equipment,lat:"\(LocationManager.shared.currentLattitude)",lon:"\(LocationManager.shared.currentLongitude)")
              //self.updateStatusOnServer(lat: "\(LocationManager.shared.currentLattitude)", lon: "\(LocationManager.shared.currentLongitude)")
          }else{
              updateRemark1(equipementdata:equipment,lat:"0.0",lon:"0.0")
              //updateStatusOnServer(lat: "0.0", lon: "0.0")
          }
      }
    
    
    // ================================
    //  MARK: Open Drop Down
    // ================================
    func openDwopDown() {
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            
            if openDropDwonConditation == true {
            let sltTxtfldFrm = btnLblCondition.convert(btnLblCondition.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 20, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height-5), width: self.view.frame.size.width - 40, height: 80))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            }
            if openDropDwonStatus == true {
            let sltTxtfldFrm1 = equipConditationBtn.convert(equipConditationBtn.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 20, y: ((-sltTxtfldFrm1.origin.y) + sltTxtfldFrm1.size.height-5), width: self.view.frame.size.width - 40, height: 80))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            
            }
            
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
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openDropDwonStatus == true {
           
            return equipmentsStatus.count
            
        } else if openDropDwonConditation == true{
        
            return (getDefaultSettings()?.equipmentStatus.count)!
        }
    
        return 0
        
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"cell")
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier:"cell")
        }
        
     
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.isUserInteractionEnabled = true
        
        if openDropDwonStatus == true {
            
            cell?.textLabel?.text = equipmentsStatus[indexPath.row].statusText
            
        } else if openDropDwonConditation   == true {
        
            let statusValue = getDefaultSettings()?.equipmentStatus[indexPath.row]
           
            cell?.textLabel?.text = statusValue!.statusText
        }
        
        
        return cell!
    }
    
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if openDropDwonStatus == true {
            
        //equipmentsStatus
            equipmentsStatusId = equipmentsStatus[indexPath.row].esId!
            let equipmentsStatusNm =  equipmentsStatus[indexPath.row].statusText
            self.equipConditationBtn.setTitle("\(String(describing:equipmentsStatusNm ?? ""))", for: .normal)
               // self.equipmentsStatusId = equipmentsStatus as! String
            self.removeOptionalView()
            
        } else if openDropDwonConditation == true{
        
            let statusValueText = getDefaultSettings()?.equipmentStatus[indexPath.row]
            getValue = (getDefaultSettings()?.equipmentStatus[indexPath.row].esId!)!
            btnLblCondition.setTitle("\(String(describing: statusValueText!.statusText!))", for: .normal)
        //    strSelectedCondition = statusValueText?.statusText ?? ""
            self.removeOptionalView()
        }
     
    }
    
    
    //==================================
    // MARK:- Remark  Service methods
    //==================================
    
    func updateRemark(equipementdata:equipDataArray?,lat:String,lon:String) {
        showLoader()
        
        let itemDt = equipementData()
      
        itemDt.equId =  equipementdata?.equId
        itemDt.equnm =  equipementdata?.equnm
        itemDt.mno =  equipementdata?.mno
        itemDt.sno =  equipementdata?.sno
        itemDt.audId =  equipementdata?.audId
       // itemDt.remark =  trimString(string: txtRemark.text!)
        itemDt.changeBy =  equipementdata?.changeBy
       // itemDt.status =  "\(getValue)" // old
        if "\(getValue)" == "" {
                    itemDt.status =  self.equipment?.status ?? ""
                    self.getValue = self.equipment?.status ?? ""
                } else {
                    itemDt.status =  "\(getValue)"
                }
        itemDt.updateData =  equipementdata?.updateData
        itemDt.lat =  equipementdata?.lat
        itemDt.lng =  equipementdata?.lng
        itemDt.location =  equipementdata?.location
        itemDt.contrid =  equipementdata?.contrid
        itemDt.attachments = equipementdata?.attachments
        itemDt.equStatus = equipmentsStatusId
       
        let searchQuery = "audId = '\(equipment?.audId ?? "")'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: searchQuery) as! [AuditOfflineList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            
            if existingJob.equArray != nil {
                let item = (existingJob.equArray as! [AnyObject])
                var arrItem = [Any]()
                
                for itam1 in item {
                    let ijmt = itam1["equId"] as? String
                    if ijmt == itemDt.equId{
                        
                        arrItem.append(itemDt.toDictionary as Any)
                    }else{
                        arrItem.append(itam1)
                    }
                }
                existingJob.equArray = arrItem as NSObject
                
            }
            DatabaseClass.shared.saveEntity(callback: {_ in
                
            })
        }
        
        
        if !isHaveNetowork() {
            let param = Params()
            param.audId = equipment?.audId
            param.equId = equipment?.equId
            param.status = "\(getValue)"
            param.remark = trimString(string: txtRemark.text!)
            param.lat = lat
            param.lng = lon
            param.isJob = "1"
            param.usrId = getUserDetails()?.usrId
            let dict =  param.toDictionary
          
            let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
            userJobs.apis = Service.getupdateAuditEquipment
            userJobs.parametres = dict?.toString
            userJobs.time = Date()
            
            DatabaseClass.shared.saveEntity(callback: {_ in
                DatabaseClass.shared.syncDatabase()
                if self.isNavigate == true{
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "jobsvc") as! JobVC;
                    
                    let navCon = NavClientController(rootViewController: vc)
                    navCon.modalPresentationStyle = .fullScreen
                    self.present(navCon, animated: true, completion: nil )
                    killLoader()
                    
                }else{
                    self.navigationController?.popToRootViewController(animated: true)
                    killLoader()
                }
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
        parm["status"] = "\(getValue)"
        parm["remark"] = trimString(string: txtRemark.text!)
        parm["lat"] = "0.0"
        parm["lng"] = "0.0"
        parm["isJob"] = "1"
        parm["usrId"] = getUserDetails()?.usrId
        parm["answerArray"] = convertIntoJSONString(arrayObject: questions)
        parm["equStatus"] = equipmentsStatusId
        
      //  print(parm)
        
        
        let images = (imageView.image != nil) ? [imageView.image!] : nil
        
        serverCommunicatorUplaodImageInArray(url: Service.getupdateAuditEquipment, param: parm, images: images, imagePath: "ja[]") { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(EquipModel.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        DispatchQueue.main.async {
                            
                            if self.isNavigate == true{
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "jobsvc") as! JobVC;
                                vc.isBackRemark = true
                               
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                killLoader()
                               
                            }else{
                                //self.navigationController?.popToRootViewController(animated: true)
                                killLoader()
                            }
                            
                            self.showToast(message:LanguageKey.euipment_remark_update)
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
    
    
    func updateRemark1(equipementdata:equipDataArray?,lat:String,lon:String) {
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
        
        if "\(getValue)" == "" {
            itemDt.status =  self.equipment?.status ?? ""
            self.getValue = self.equipment?.status ?? ""
        } else {
            itemDt.status =  "\(getValue)"
        }
        itemDt.updateData =  equipementdata?.updateData
        itemDt.lat =  equipementdata?.lat
        itemDt.lng =  equipementdata?.lng
        itemDt.location =  equipementdata?.location
        itemDt.contrid =  equipementdata?.contrid
        itemDt.attachments = equipementdata?.attachments
       
        let searchQuery = "audId = '\(equipment?.audId ?? "")'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: searchQuery) as! [AuditOfflineList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            
            if existingJob.equArray != nil {
                let item = (existingJob.equArray as! [AnyObject])
                var arrItem = [Any]()
                
                for itam1 in item {
                    let ijmt = itam1["equId"] as? String
                    if ijmt == itemDt.equId{
                      
                        arrItem.append(itemDt.toDictionary as Any)
                    }else{
                        arrItem.append(itam1)
                    }
                }
                existingJob.equArray = arrItem as NSObject
                
                
            }
            DatabaseClass.shared.saveEntity(callback: {_ in
                
            })
        }
        
        
        if !isHaveNetowork() {
            let param = Params()
            param.audId = equipment?.audId
            param.equId = equipment?.equId
            param.status = "\(getValue)"
            // param.status = "\(selectedCondition.rawValue)"
            param.remark = trimString(string: txtRemark.text!)
            param.lat = lat
            param.lng = lon
            param.isJob = "1"
            param.usrId = getUserDetails()?.usrId
            let dict =  param.toDictionary
            
            let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
            userJobs.apis = Service.getupdateAuditEquipment
            userJobs.parametres = dict?.toString
        
            userJobs.time = Date()
            
            DatabaseClass.shared.saveEntity(callback: {_ in
                DatabaseClass.shared.syncDatabase()
                if self.isNavigate == true{
                    
                    killLoader()
                }else{
                   
                    killLoader()
                }
            })
            
        }else{
            addRemark1()
        }
      
    }
       
       
       func addRemark1(){
           
           if !isHaveNetowork() {
               ShowError(message: AlertMessage.networkIssue, controller: windowController)
              
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
           parm["isJob"] = "1"
           parm["usrId"] = getUserDetails()?.usrId
           parm["answerArray"] = convertIntoJSONString(arrayObject: questions)
         
           
           let images = (imageView.image != nil) ? [imageView.image!] : nil
           
           serverCommunicatorUplaodImageInArray(url: Service.getupdateAuditEquipment, param: parm, images: images, imagePath: "ja[]") { (response, success) in
               killLoader()
               if(success){
                   let decoder = JSONDecoder()
                   if let decodedData = try? decoder.decode(EquipModel.self, from: response as! Data) {
                       
                       if decodedData.success == true{
                           DispatchQueue.main.async {
                               
                               if self.isNavigate == true{
                                 
                                   killLoader()
                                  
                               }else{
                                 
                                   killLoader()
                               }
                             
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
          
        }
        return nil
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
        param.isJob = "1"
        param.usrId = getUserDetails()?.usrId
        param.des = imageDes
        param.equStatus = equipmentsStatusId
        
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
                                self.collection.isHidden = false
                                self.arrOfShowData?.attachments?.insert(decodedData.data![0], at: 0)
                                self.collection.reloadData()
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
    
    
//    //==============================================
//    // MARK:- Document getAllEquipmentItems Service
//    //==============================================
//
//    func getAllEquipmentItems() {
//
//
//          if !isHaveNetowork() {
//                  ShowError(message: AlertMessage.checkNetwork, controller: windowController)
//                  if self.refreshControl.isRefreshing {
//                      self.refreshControl.endRefreshing()
//                  }
//                  return
//              }
//
//        let param = Params()
//        param.equId = equipment?.equId
//
//
//        serverCommunicator(url: Service.getAllEquipmentItems, param: param.toDictionary) { (response, success) in
//            DispatchQueue.main.async {
//                if self.refreshControl.isRefreshing {
//                    self.refreshControl.endRefreshing()
//                }
//            }
//
//            if(success){
//                let decoder = JSONDecoder()
//                if let decodedData = try? decoder.decode(getAllEquipmentItemsRes.self, from: response as! Data) {
//                    if decodedData.success == true {
//
//                        self.newItemPart = decodedData.data as! [AllEquipmentItemsData]
//
////
////                        DispatchQueue.main.async {
////
////                        if self.newItemPart.count == 0 {
////                            self.H_itemView.constant = 55
////                        }else if self.newItemPart.count == 1 {
////                            self.H_itemView.constant = 150
////                        }else if self.newItemPart.count == 2 {
////                            self.H_itemView.constant = 300
////                        }else if self.newItemPart.count == 3 {
////                            self.H_itemView.constant = 450
////                        }else if self.newItemPart.count == 4 {
////                            self.H_itemView.constant = 600
////                        }else if self.newItemPart.count == 5 {
////                            self.H_itemView.constant = 600
////                        }else if self.newItemPart.count == 6 {
////                            self.H_itemView.constant = 900
////                        }else if self.newItemPart.count == 7 {
////                            self.H_itemView.constant = 1050
////                        }else if self.newItemPart.count == 8 {
////                            self.H_itemView.constant = 1200
////                        }else if self.newItemPart.count == 9 {
////                            self.H_itemView.constant = 1350
////                        }else if self.newItemPart.count == 10 {
////                            self.H_itemView.constant = 1500
////                        }else if self.newItemPart.count == 11 {
////                            self.H_itemView.constant = 1650
////                        }
////
////                        self.itemTableView.reloadData()
////                        }
//
//
//                    }
//                }else{
//                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
//                        if cancel {
//                            showLoader()
//                            self.getAllEquipmentItems()
//                        }
//                    })
//                }
//            }
//        }
//    }
    
    func setDataForItem(){
        
      itemDetailedData.removeAll()
        if objOfUserJobListInDetail!.itemData != nil {
            for item in (objOfUserJobListInDetail!.itemData as! [AnyObject]) {

            // print(item)
            if let dta = item as? itemData {

          //  print(dta)

            }else{
            if item["tax"] != nil {
            let tax = item["tax"] as! [AnyObject]
            if tax.count > 0 {
            var arrTac = [texDic]()
            for taxDic in tax {
            arrTac.append(texDic(ijtmmId: taxDic["ijtmmId"] as? String, ijmmId: taxDic["ijmmId"] as? String, taxId: taxDic["taxId"] as? String, rate: taxDic["rate"] as? String, label: taxDic["label"] as? String))


            }
            let ammount = amounc(qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String,arrTax: arrTac)
                let dic = ItemDic(ijmmId: item["ijmmId"] as? String, itemId: item["itemId"] as? String, jobId: objOfUserJobListInDetail!.jobId , groupId: item["groupId"] as? String, des: item["des"] as? String, inm: item["inm"] as? String, qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String, amount: ammount, tax: arrTac, hsncode: item["hsncode"] as? String, pno: item["pno"] as? String, unit: item["unit"] as? String, taxamnt: item["taxamnt"] as? String, supplierCost: item["supplierCost"] as? String,dataType: item["dataType"] as? String, serialNo: item["serialNo"] as? String,isBillable: item["isBillable"] as? String, isBillableChange: item["isBillableChange"] as? String , warrantyType: item["warrantyType"] as? String, warrantyValue: item["warrantyValue"] as? String , equId: item["equId"] as? String)
                
                
                

            itemDetailedData.append(dic)
                
                
            } else {
            let ammount = amounc(qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String)
          

                let dic = ItemDic(ijmmId: item["ijmmId"] as? String, itemId: item["itemId"] as? String, jobId: objOfUserJobListInDetail!.jobId , groupId: item["groupId"] as? String, des: item["des"] as? String, inm: item["inm"] as? String, qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String, amount: ammount, tax: [], hsncode: item["hsncode"] as? String, pno: item["pno"] as? String, unit: item["unit"] as? String, taxamnt: item["taxamnt"] as? String, supplierCost: item["supplierCost"] as? String,dataType: item["dataType"] as? String, serialNo: item["serialNo"] as? String,isBillable: item["isBillable"] as? String, isBillableChange: item["isBillableChange"] as? String, warrantyType: item["warrantyType"] as? String, warrantyValue: item["warrantyValue"] as? String ,equId: item["equId"] as? String)
            itemDetailedData.append(dic)
                
            }

            }
            }
                            
        }

            }
        
        
        
        
        var data = equipment?.equId
        equipDataPartDataArr.removeAll()
       // filterequipmentData.removeAll()
        for dic in itemDetailedData {
            // for dic in equipmentData {
       
            if dic.equId == data {
                equipDataPartDataArr.append(dic)
                self.itemTableView.reloadData()
            }
            

        
        }
                       
                        
        
        DispatchQueue.main.async {
            
            // FOR ITEM PART IS HIDEN :-
            let  isItem = isPermitForShow(permission: permissions.isItemVisible)
            if self.isfooter?.count != nil {
                for i in 0 ..< self.isfooter!.count{
                    if i < 4 {
                        
                        if self.isfooter![i].isEnable == "1"{
                            if self.JobItemQuantityFormEnable == "0" {
                                if isItem && self.isfooter![i].menuField == "set_itemMenuOdrNo"{
                                    
                                    
                                    
                                    if self.equipDataPartDataArr.count == 0 {
                                        self.H_itemView.constant = 55
                                    }else if self.equipDataPartDataArr.count == 1 {
                                        self.H_itemView.constant = 120
                                    }else if self.equipDataPartDataArr.count == 2 {
                                        self.H_itemView.constant = 240
                                    }else if self.equipDataPartDataArr.count == 3 {
                                        self.H_itemView.constant = 330
                                    }else if self.equipDataPartDataArr.count == 4 {
                                        self.H_itemView.constant = 440
                                    }else if self.equipDataPartDataArr.count == 5 {
                                        self.H_itemView.constant = 550
                                    }else if self.equipDataPartDataArr.count == 6 {
                                        self.H_itemView.constant = 660
                                    }else if self.equipDataPartDataArr.count == 7 {
                                        self.H_itemView.constant = 770
                                    }else if self.equipDataPartDataArr.count == 8 {
                                        self.H_itemView.constant = 880
                                    }else if self.equipDataPartDataArr.count == 9 {
                                        self.H_itemView.constant = 990
                                    }else if self.equipDataPartDataArr.count == 10 {
                                        self.H_itemView.constant = 1100
                                    }else if self.equipDataPartDataArr.count == 11 {
                                        self.H_itemView.constant = 1210
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        
     
            self.itemTableView.reloadData()
        }
    }
    
    func amounc(qty:String?, rate:String?, discount:String?,arrTax:[texDic]? = nil) -> String{
           var tax : Double = 0.0
           if let itemTex = arrTax {
                       for tx in itemTex {
                           tax = tax + Double((tx.rate == "") ? roundOff(value:Double("0.00")!) : tx.rate ?? "0.0" )!
                       }
           }

           
           let qty1 = (qty == "") ? "0" : qty!
           let rate1 = (rate == "") ? "0.0" : rate!
           let discount1 = (discount == "") ? "0.0" : discount!
           
           
           let totalAmount = calculateAmount(quantity: Double(qty1)!, rate: Double(rate1)!, tax: tax, discount: Double(discount1)!)
           return roundOff(value: totalAmount)
           
           
       }
    
    //==================================
    // MARK:- Equipement LIST Service methods
    //==================================
    func getEquipmentStatus(){
        
        if !isHaveNetowork() {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        let param = Params()
   
        param.limit = ""
        param.index = "0"
        param.isCondition = "1"
      
        
        serverCommunicator(url: Service.getEquipmentStatus, param: param.toDictionary) { (response, success) in
            
               DispatchQueue.main.async {
                   if self.refreshControl.isRefreshing {
                       self.refreshControl.endRefreshing()
                   }
               }
              
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(getEquipmentStatusRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data!.count > 0 {
                            self.equipmentsStatus = decodedData.data!
                            DispatchQueue.main.async {
                                if  self.equipment?.equStatus == "1" {
                                   
                                    
                                }else{
                                    if  self.equipment?.equStatus != "" {
                                        
                                        for poIdnm in self.equipmentsStatus {
                                            
                                            if  poIdnm.esId == self.equipment?.equStatus {
                                                
                                                self.poIdNam = poIdnm.statusText ?? ""
                                                
                                             
                                                if self.poIdNam == "Deployed" {
                                                    self.equipConditationBtn.setTitle("Deployed", for: .normal)
                                                    self.replaceBtn.isHidden = false
                                                    self.replaceTittleLbl.text = LanguageKey.do_you_want_to_discard
                                                }else if self.poIdNam == "Discarded" {
                                                    self.equipConditationBtn.setTitle("Discarded", for: .normal)
                                                    self.replaceTittleLbl.text = "Discard equipments cannot be replaced."
                                                    self.replaceBtn.isHidden = true
                                                } else if self.poIdNam == "Available" {
                                                    self.equipConditationBtn.setTitle("Available", for: .normal)
                                                }
                                                
                                            }
                                        }
                                        
                                    }
                                }
                            self.partTableView.reloadData()
                            self.tableView.reloadData()
                            }
                            //print(self.equipmentsStatus)
                            killLoader()
                        }
                    }else{
                        killLoader()
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        
                        if cancel {
                            showLoader()
                            self.getEquipmentStatus()
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getEquipmentStatus()
                    }
                })
            }
        }
    }

}

extension LinkEquipmentReport: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.arrOfFilterData..count > 0 ? self.arrOfFilterData.count :  self.arrOfShowData.count
        return self.equipment?.attachments?.count ?? 0
        // return self.arrOfShowData1.count
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
        
        if let fileUrl = URL(string: (Service.BaseUrl + ((docResDataDetailsObj?.attachFileName!)!))) {
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
                
                self.collection.isHidden = true
                
            }
            return
        }
        
        
        showLoader()
        let param = Params()
        param.jaId = documentid
        param.des = documentDescription
        
        serverCommunicator(url: Service.updateDocument, param: param.toDictionary) { (response, success) in
            killLoader()
            
            //            DispatchQueue.main.async {
            //                if self.refreshControl.isRefreshing {
            //                    self.refreshControl.endRefreshing()
            //                }
            //            }
            //
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


extension LinkEquipmentReport: UIDocumentPickerDelegate {
    
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
        param.isJob = "1"
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
                                self.collection.isHidden = false
                                self.arrOfShowData?.attachments?.insert(decodedData.data![0], at: 0)
                                self.collection.reloadData()
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
    // MARK:- Get custom form Service
    //=====================================
    
    
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
        // dict["linkTo"] = "1"
    
        serverCommunicator(url: Service.getCustomFormNmList, param: dict) { (response, success) in
            
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(TestRes.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                  
                        
                        if decodedData.data.count > 0 {
                            
                            DispatchQueue.main.async {
                                if  self.equipment?.attachments?.count == 0 {
                                    self.collectionView_H.constant = 0
                                    self.H_collectBigView.constant = 0
                                    self.collection.isHidden = true
                                   // self.tableView.reloadData()
                                }
                           
                                
                                self.sstring = decodedData.data[0].frmId!
                             
                                self.getQuestionsByParentId()
                                // self.tableView.reloadData()
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.H_tableView.constant = 0
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
    
    
    //===============================
    // MARK:- GetQuestionsList
    //===============================
    
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
                                        self.H_tableView.constant = 100
                                    }else{
                                        if self.arrOfShowData11.count < 4 {
                                            self.tblView_H.constant = 350
                                            self.H_tableView.constant = 350
                                            
                                        }else{
                                            if self.arrOfShowData11.count < 6 {
                                                self.tblView_H.constant = 500
                                                self.H_tableView.constant = 500
                                                
                                            }else{
                                                self.H_tableView.constant = 692
                                                self.tblView_H.constant = 692
                                            }                                                }
                                        
                                    }
                                    
                                }else{
                                    self.H_tableView.constant = 0
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
                                    //  print(key)
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
    
}
extension LinkEquipmentReport :  UITableViewDelegate, UITableViewDataSource{
    
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if tableView != partTableView  && tableView != itemTableView{
    
            let customFormDetals = arrOfShowData11[indexPath.row]
    
            if customFormDetals.type == "3" {
                return tableView.estimatedRowHeight
            }else if customFormDetals.type == "2"{
                return tableView.estimatedRowHeight
            }else {
                return tableView.estimatedRowHeight
            }
            }
            return tableView.estimatedRowHeight
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == partTableView {
            return filterequipmentData.count
        }else if tableView == itemTableView {
            return equipDataPartDataArr.count//newItemPart.count
        }else{
            return arrOfShowData11.count
        }
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
        var cell = UITableViewCell()
        if tableView == partTableView {
           
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "quipmentCell",for: indexPath) as! EquipmentCell
            
          
            cell.btnDefaults.setTitle("View Details", for: .normal)
            cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
            let modl = LanguageKey.model_no
            let serl = LanguageKey.serial_no
          
            let cond = LanguageKey.condition
            let remark = LanguageKey.remark
            let equipment = filterequipmentData[indexPath.row]
            //======
//            
//            if  equipment.equStatus != "" {
//                
//                for poIdnm in equipmentsStatus {
//                    
//                    if  poIdnm.esId == equipment.equStatus {
//                        
//                        self.poIdNam = poIdnm.statusText ?? ""
//                        
//                        cell.deployLbl.text = poIdNam
//                       
//                       
//                     
//                    }else{
//                       
//                    }
//                    
//                   
//                }
//        
//            }else{
//               
//            }
//            
            
            
            if  equipment.equStatus == "1" {
                
                cell.deployView.isHidden = true
                
            }else{
                if  equipment.equStatus != "" {
                    
                    for poIdnm in equipmentsStatus {
                        
                        if  poIdnm.esId == equipment.equStatus {
                            
                            self.poIdNam = poIdnm.statusText ?? ""
                            
                            cell.deployLbl.text = poIdNam
                            if poIdNam == "Deployed" {
                                cell.deployLbl.text = LanguageKey.deployed
                                cell.deployView.backgroundColor =  UIColor(red: 238/255.0, green: 174/255.0, blue: 91/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white//UIColor(red: 231/255.0, green: 192/255.0, blue: 125/255.0, alpha: 1.0)
                                cell.deployDateLbl.textColor = UIColor.white //UIColor(red: 231/255.0, green: 192/255.0, blue: 125/255.0, alpha: 1.0)
                            }else if poIdNam == "Discarded" {
                                cell.deployView.backgroundColor =  UIColor(red: 249/255.0, green: 110/255.0, blue: 114/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white//UIColor(red: 179/255.0, green: 61/255.0, blue: 50/255.0, alpha: 1.0)
                                cell.deployDateLbl.textColor =   UIColor.white//UIColor(red: 179/255.0, green: 61/255.0, blue: 50/255.0, alpha: 1.0)
                            }
                            
                        }
                    }
                    
                }
            }
            
            
            if equipment.statusUpdateDate != "" {
                if equipment.statusUpdateDate != nil {
                cell.deployDateLbl.text = convertTimestampToDateForPayment(timeInterval: (equipment.statusUpdateDate ?? ""))
                }else{
                    cell.deployDateLbl.text = ""
                }
            }else{
                cell.deployDateLbl.text = ""
            }
            
           
            //======
            
                let aa = equipment.image
                        
                       if aa != nil {
                           let ar = URL(string: Service.BaseUrl)?.absoluteString
                           let ab = equipment.image
                         
                           
                           var ii:URL = URL(string: ar! + ab!)!
                             
                                   DispatchQueue.global().async { [weak self] in
                                       if let data = try? Data(contentsOf: ii) {
                                           if let image = UIImage(data: data) {
                                               DispatchQueue.main.async {
                                                   cell.equipmentImg.image = image
                                               }
                                           }
                                       }
                                   }
                             
                       }
            //cell.remarkLbl.text = "34589234"
           // cell.remarkDisc.text = equipment.remark
            cell.lblName.text = equipment.equnm
            cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
            
        
        if equipment.status == "" &&  equipment.remark == ""{
          //  cell.remarkView_H.constant = 0
        }else{
         //  cell.remarkView_H.constant = 111
        }
        
        cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
        cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
        cell.lblAddress.text = equipment.location
        
            return cell
        }else if tableView == itemTableView {
            
             var cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! InvoiceCell
            
            let aar = equipDataPartDataArr[indexPath.row]
            
            
            var myrate = aar.rate
            if (myrate?.count)! > 0 {
                myrate = roundOff(value: Double((myrate)!)!)
            }else{
                myrate = roundOff(value:Double("0.00")!)
            }
            
            if aar.isBillable == nil {
                cell.billingLbl.isHidden = true
                cell.billingView.isHidden = true
            }else{
                
                if aar.isBillable == "1"{
                    
                    cell.billingLbl.isHidden = true
                    cell.billingView.isHidden = true
                }else{
                    
                    cell.billingLbl.isHidden = false
                    cell.billingView.isHidden = false
                    cell.billingLbl.textColor = .white
                    cell.billingLbl.text = LanguageKey.non_billable
                    
                }
                
            }
            
           
         //   print(aar.isBillable)
            var mydiscount = aar.discount
            if (mydiscount?.count)! > 0 {
                mydiscount = roundOff(value: Double((mydiscount)!)!)
            }else{
                mydiscount = roundOff(value:Double("0.00")!)
            }
            let ladksj  = aar.ijmmId?.components(separatedBy: "-")
            if ladksj!.count > 0 {
                let tempId = ladksj?[0]
                if tempId == "Item" {
                    cell.lblName.text = aar.inm?.capitalized
                    cell.discountLbl.text =
                    "\(LanguageKey.item_not_sync) " // aar.inm?.capitalized ?? "" + "  Not Sync"
                    cell.desLbl.text = aar.des?.capitalized
                }else  {
                    cell.lblName.text = aar.inm?.capitalized
                    //cell.discountLbl.textColor = UIColor.gray
                    cell.discountLbl.text = ""//aar.des?.capitalized
                    cell.desLbl.text = aar.des?.capitalized
                }
            }
       
            
            if aar.unit != "" {
                let qtyText = aar.unit! //LanguageKey.unit
                cell.qtyLbl.text = "\(qtyText): " + aar.qty!
            }else{
                let qtyText = LanguageKey.qty
                cell.qtyLbl.text = "\(qtyText): " + aar.qty!
            }
            
           
            cell.amountLbl.text = aar.amount ?? "0.0"
            

            return cell
        
        }else {
            
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
        return cell
     
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
       // print(self.txtFieldData)
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
    
    
    
}


extension String {
    func height12(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width12(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

struct ImageModel_LinkEquipmentReport {
    var img: UIImage?
    
}

extension UIImage {
    func resizeImage_LinkEquipmentReport(targetSize: CGSize) -> UIImage {
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

