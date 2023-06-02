//
//  addEquipmentRemark.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 21/12/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import MessageUI
import Photos
import CoreData
import MobileCoreServices
import JJFloatingActionButton

class addEquipmentRemark: UIViewController,OptionViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIDocumentPickerDelegate  {
        var objOfUserJodbList = AuditOfflineList()
    
    
    @IBOutlet weak var installDateTxtFld: FloatLabelTextField!
    @IBOutlet weak var checkInsertBtn: UIButton!
    @IBOutlet weak var barCodeInsrtTxtFld: FloatLabelTextField!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var customTxtFldTwoSub: FloatLabelTextField!
    @IBOutlet weak var customTxtFldOneSub: FloatLabelTextField!
    @IBOutlet weak var customTxtFldTwo: UITextField!
    @IBOutlet weak var customTxtFldOne: UITextField!
    @IBOutlet weak var donBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var attchmentLbl: UILabel!
    @IBOutlet weak var yourDocLbl: UILabel!
    @IBOutlet weak var updateLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var ownerBtn: UIButton!
    @IBOutlet weak var serviceProBtn: UIButton!
    @IBOutlet weak var equipmentTxtFld: FloatLabelTextField!
    @IBOutlet weak var modelNoTxtFld: FloatLabelTextField!
    @IBOutlet weak var superTxtFld: FloatLabelTextField!
    @IBOutlet weak var manufctureTxtFld: FloatLabelTextField!
    @IBOutlet weak var equipmentCategoryTxtFld: FloatLabelTextField!
    @IBOutlet weak var equipmentGroupTxtFld: FloatLabelTextField!
    @IBOutlet weak var baradTxtFld: FloatLabelTextField!
    @IBOutlet weak var serialTxtFld: FloatLabelTextField!
    @IBOutlet weak var warrantyExpiryDateTxtFld: FloatLabelTextField!
    @IBOutlet weak var purchaseDateTxtFld: FloatLabelTextField!
    @IBOutlet weak var adressTxtFld: FloatLabelTextField!
    @IBOutlet weak var countryTxtFld: FloatLabelTextField!
    @IBOutlet weak var stateTxtFld: FloatLabelTextField!
    @IBOutlet weak var cityTxtFld: FloatLabelTextField!
    @IBOutlet weak var notesTxtFld: FloatLabelTextField!
    @IBOutlet weak var zipTxtFld: FloatLabelTextField!
    @IBOutlet weak var genrateBarcode: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bigView: UIView!
    
    var scanBarcodeId = ""
    var imgArr = [ImageModel_addEquipmentRemark]()
    var image : UIImage?
    var uploadImage : UIImage? = nil
    var name : String?
    var isClintFutUser  = false
    var sltTxtField = UITextField()
    var sltDropDownBtnTag : Int!
    var optionalVw : OptionalView?
    let cellReuseIdentifier = "cell"
    var sltDropDownTag : Int!
    var arrOfShow = [Any]()
    var arrOfShowData = [ClientList]()
    var imagePicker = UIImagePickerController()
    var EquGroupList = [EquGroupLists]()
    var EquBrandListss = [EquBrandLists]()
    var CategoryList = [EquCltLists]()
    var a = Bool()
    var b = Bool()
    var c = Bool()
    var d = Bool()
    var addEquip = false
    var brands = ""
    var grp = ""
    var clts = ""
    let param = Params()
    var customFldOne = ""
    var customFldTwo = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barCodeInsrtTxtFld.isHidden = true
        self.scanBtn.isHidden = true
       // var isSwitchOff = ""
      //  isSwitchOff =   UserDefaults.standard.value(forKey: "CustomOneKey") as? String ?? ""
        self.customTxtFldOne.text =  getDefaultSettings()?.equpExtraField1Label
       // if isSwitchOff != "" {
        customTxtFldOneSub.placeholder = self.customTxtFldOne.text
          //  } else {
            // customTxtFldOneSub.placeholder = "Extra Feild One"
       // }
        
        
      //  var isSwitchTwo = ""
       // isSwitchTwo =   UserDefaults.standard.value(forKey: "CustomTwoKey") as? String ?? ""
        self.customTxtFldTwo.text =  getDefaultSettings()?.equpExtraField2Label
       // if isSwitchTwo != "" {
        customTxtFldTwoSub.placeholder = self.customTxtFldTwo.text
        // } else {
        //      customTxtFldTwoSub.placeholder = "Extra Feild Two"
       // }
            
        getEquBrandList()
        getCategoryList()
        getEquGroupList()
        self.setLocalization()
        self.countryTxtFld.text = "India"
        self.stateTxtFld.text = "Madhya Pradesh"
        self.cityTxtFld.text = "Indore"
        
        param.state = "21"
        param.ctry = "101"
       // self.navigationItem.title = "Add Equipment"//LanguageKey.add_expense
        // Do any additional setup after loading the view.
    }
    
    
    func setLocalization() -> Void {
        
        self.navigationItem.title = LanguageKey.title_add_equipment
        
        equipmentTxtFld.placeholder = "\(LanguageKey.equipment)*"
        modelNoTxtFld.placeholder = "\(LanguageKey.equipment_model)"
        superTxtFld.placeholder = "\(LanguageKey.supplier)"
        manufctureTxtFld.placeholder = "\(LanguageKey.manufacture_date)"
        equipmentCategoryTxtFld.placeholder = "\(LanguageKey.equipment_category)"
        equipmentGroupTxtFld.placeholder = "\(LanguageKey.equipment_group)"
        baradTxtFld.placeholder = "\(LanguageKey.brand)"
        serialTxtFld.placeholder = " \(LanguageKey.serial_no)"
        warrantyExpiryDateTxtFld.placeholder = "\(LanguageKey.warranty_expiry_date)"
        purchaseDateTxtFld.placeholder = "\(LanguageKey.purchase_date)"
        adressTxtFld.placeholder = "\(LanguageKey.address)"
        countryTxtFld.placeholder = "\(LanguageKey.country)"
        stateTxtFld.placeholder = "\(LanguageKey.state)"
        cityTxtFld.placeholder = "\(LanguageKey.city)"
        notesTxtFld.placeholder = "\(LanguageKey.notes)"
        zipTxtFld.placeholder = "\(LanguageKey.zip)"
        
        typeLbl.text =  LanguageKey.type
        attchmentLbl.text =  LanguageKey.add_images
        yourDocLbl.text =  LanguageKey.doc_here
        updateLbl.text =  LanguageKey.expense_upload
        donBtn.setTitle(LanguageKey.done, for: .normal)
        cancelBtn.setTitle(LanguageKey.cancel, for: .normal)
        saveBtn.setTitle(LanguageKey.title_add_equipment, for: .normal)
        ownerBtn.setTitle(" \(LanguageKey.serv_prov)", for: .normal)
        // serviceProBtn.setTitle(LanguageKey.save_btn, for: .normal)
        genrateBarcode.setTitle(LanguageKey.gen_bar_code, for: .normal)
        
        scanBtn.setTitle(LanguageKey.scan, for: .normal)
        checkInsertBtn.setTitle(LanguageKey.scan_insert_barcode, for: .normal)
        
        
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
//            img.image = image as? UIImage
//
//
//            // btnUplaod.alpha = 1.0
//
//        }
//
//        //self.btnRemove.isHidden = true
//        self.img.isHidden = false
//        //self.HightTopView.constant = 150
//
//        self.dismiss(animated: true, completion: { () -> Void in
//
//        })
        
        
        ///////
       // let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
                                  
                                  
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
//                    if let image = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
    if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
        let imgStruct = ImageModel_addEquipmentRemark(img: (info[.originalImage] as? UIImage)?.resizeImage_addEquipmentRemark(targetSize: CGSize(width: 1000.0, height: 1000.0)))
                                                      DispatchQueue.main.async {
                                                            let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                                            let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                                                        vc.image = (imgStruct.img!)
                                                          //  vc.image = (image as! UIImage)
                                                            vc.OnlyForCrop = false
                                                            vc.OnlycheckMarkCompl = true
                                                            vc.name = trimString(string: imgName)
                                                            vc.callback = {(modifiedImage, imageName, imageDescription) in
                                                              self.uploadImage = modifiedImage
                                                              self.img.image =   self.uploadImage//image as? UIImage
                                                             // self.uploadDocuments(imgName: imageName, imageDes: imageDescription) { () -> (Void) in
                                                                //  DispatchQueue.main.async {
                                                                self.img.isHidden = false
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
                            
        ///////
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
    
    
    @IBAction func scanBarCodAct(_ sender: Any) {
        scanBarcode()
    }
    
    
    @IBAction func insertBarCodeCheckBtn(_ sender: Any) {
        
        self.barCodeInsrtTxtFld.isHidden = true
        self.scanBtn.isHidden = true
        
        if(checkInsertBtn.imageView?.image == UIImage(named: "BoxOFUncheck")){
            self.checkInsertBtn.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
            
            self.barCodeInsrtTxtFld.isHidden = false
            self.scanBtn.isHidden = false
            self.genrateBarcode.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
            self.isClintFutUser = false
            
        }else{
            // isAddValidation = false
            self.checkInsertBtn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
            self.barCodeInsrtTxtFld.isHidden = true
            self.scanBtn.isHidden = true
            
        }
        
    }
    

    
    @IBAction func genrateBarcode(_ sender: Any) {
        
        if(genrateBarcode.imageView?.image == UIImage(named: "BoxOFUncheck")){
            self.genrateBarcode.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
            
            self.isClintFutUser = true
            self.checkInsertBtn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
            self.barCodeInsrtTxtFld.isHidden = true
            self.scanBtn.isHidden = true
            
        }else{
            // isAddValidation = false
            self.genrateBarcode.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
            self.isClintFutUser = false
            
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
//        customFldTwo = customTxtFldTwo.text!
//               UserDefaults.standard.set(customFldTwo, forKey: "CustomTwoKey")
//
//               customFldOne = customTxtFldOne.text!
//               UserDefaults.standard.set(customFldOne, forKey: "CustomOneKey")
        
        let equipmentNm  =  self.equipmentTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if(equipmentNm != nil && equipmentNm != ""){
            
            addEquipment()
            
            
        }else{
            ShowError(message: LanguageKey.equp_nm_req, controller: windowController)
        }
        
        
        
    }
    
    
    @IBAction func uploadImg(_ sender: Any) {
        
        
        
        
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
                    
                    // self.img.isHidden = true
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
                    
                    self.img.isHidden = true
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
    
    
    @IBAction func ownerBtn(_ sender: Any) {
        
        ownerBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
        serviceProBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
    }
    @IBAction func serviceProBtn(_ sender: Any) {
        
        serviceProBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
        ownerBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
    }
    
    @IBAction func manufactureDateBtn(_ sender: Any) {
        a = true
        b = false
        c = false
        d = false
        self.bigView.isHidden = false
    }
    
    @IBAction func warrantyExpiryDateBtn(_ sender: Any) {
        b = true
        a = false
        c = false
        d = false
        self.bigView.isHidden = false
    }
    
    @IBAction func purchaseDateBtn(_ sender: Any) {
        c = true
        a = false
        b = false
        d = false
        self.bigView.isHidden = false
    }
    
    
    @IBAction func installDateBtn(_ sender: Any) {
        d = true
        c = false
        a = false
        b = false
        
        self.bigView.isHidden = false
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.bigView.isHidden = true
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        let selectedDate = datePicker!.date
        
        
        if a == true{
            let formatter = DateFormatter()
            formatter.dateFormat="dd-MM-yyyy"
            let str = formatter.string(from: selectedDate)
            manufctureTxtFld.text = str
            self.bigView.isHidden = true
        }
        if b == true{
            let formatter = DateFormatter()
            formatter.dateFormat="dd-MM-yyyy"
            let str = formatter.string(from: selectedDate)
            warrantyExpiryDateTxtFld.text = str
            self.bigView.isHidden = true
        }
        if c == true{
            let formatter = DateFormatter()
            formatter.dateFormat="dd-MM-yyyy"
            let str = formatter.string(from: selectedDate)
            purchaseDateTxtFld.text = str
            self.bigView.isHidden = true
        }
        if d == true{
            let formatter = DateFormatter()
            formatter.dateFormat="dd-MM-yyyy"
            let str = formatter.string(from: selectedDate)
            installDateTxtFld.text = str
            self.bigView.isHidden = true
        }
        
    }
    
    func scanBarcode() -> Void {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    func getCountry() -> NSArray {
        return getJson(fileName: "countries")["countries"] as! NSArray
    }
    
    func getStates() -> NSArray {
        return getJson(fileName: "states")["states"] as! NSArray
    }
    
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
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
    func callMethodforOpenDwop(tag : Int){
        if(self.optionalVw != nil){
            self.removeOptionalView()
            return
        }
        
        switch tag {
            
        case 1:
            
            if(self.optionalVw == nil){
                sltDropDownTag = 1
                
                arrOfShow = getJson(fileName: "countries")["countries"] as! [Any]
                self.openDwopDown( txtField: self.countryTxtFld, arr: arrOfShow)
                
            }else{
                self.removeOptionalView()
            }
            
            break
            
        case 2:
            sltDropDownTag = 2
            
            if(self.optionalVw == nil){
                let namepredicate: NSPredicate = NSPredicate(format:"self.name == %@", self.countryTxtFld.text! )
                let arr = getCountry().filtered(using: namepredicate)
                if(arr.count > 0){
                    let dict = (arr[0] as? [String : Any])
                    let serchCourID = dict?["id"]
                    let bPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                    arrOfShow =  getStates().filtered(using: bPredicate)
                    self.openDwopDown( txtField: self.stateTxtFld, arr: arrOfShow)
                }
                
                
            }else{
                self.removeOptionalView()
                
            }
            
            break
        case 8:
            sltDropDownTag = 8
            if(self.optionalVw == nil){
                
                
                // arrOfShow = getJson(fileName: "countries")["countries"] as! [Any]
                self.openDwopDown( txtField: self.equipmentCategoryTxtFld, arr: CategoryList)
                
            }else{
                self.removeOptionalView()
            }
            
            break
        case 9:
            sltDropDownTag = 9
            if(self.optionalVw == nil){
                
                
                // arrOfShow = getJson(fileName: "countries")["countries"] as! [Any]
                self.openDwopDown( txtField: self.equipmentGroupTxtFld, arr: EquGroupList)
                
            }else{
                self.removeOptionalView()
            }
            
            break
        case 10:
            sltDropDownTag = 10
            if(self.optionalVw == nil){
                
                
                // arrOfShow = getJson(fileName: "countries")["countries"] as! [Any]
                self.openDwopDown( txtField: self.baradTxtFld, arr: EquBrandListss)
                
            }else{
                self.removeOptionalView()
            }
            
            break
            
        default:
            return
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sltTxtField = textField
        self.sltDropDownBtnTag = textField.tag
        
        
        
        if countryTxtFld == textField {
            self.callMethodforOpenDwop(tag: 1)
        }
        if stateTxtFld == textField {
            self.callMethodforOpenDwop(tag: 2)
        }
        if equipmentCategoryTxtFld == textField {
            self.callMethodforOpenDwop(tag: 8)
        }
        if equipmentGroupTxtFld == textField {
            self.callMethodforOpenDwop(tag: 9)
        }
        if baradTxtFld == textField {
            self.callMethodforOpenDwop(tag: 10)
        }
        
    }
    
    
    //=====================================
    // MARK:- Optional view Detegate
    //=====================================
    
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        if (sltDropDownTag == 1) {
            return arrOfShow.count
        }
        else if (sltDropDownTag == 2) {
            
            return arrOfShow.count
        }else if (sltDropDownTag == 8) {
            
            return CategoryList.count
        }else if (sltDropDownTag == 9) {
            
            return EquGroupList.count
        }else if (sltDropDownTag == 10) {
            
            return EquBrandListss.count
        }
        
        return 0
        
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        cell?.textLabel?.textColor = UIColor.darkGray
        
        switch self.sltDropDownTag {
            
        case 1:
            cell?.textLabel?.text =  ((arrOfShow[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
            
            break
            
        case 2:
            
            cell?.textLabel?.text = ((arrOfShow[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
            
            
        case 8:
            cell?.textLabel?.text = CategoryList[indexPath.row].equ_cate
            
            break
        case 9:
            cell?.textLabel?.text = EquGroupList[indexPath.row].equ_group
            
            break
        case 10:
            cell?.textLabel?.text = EquBrandListss[indexPath.row].name
            
            break
        default: break
            
        }
        
        return cell!
        
    }
    
    
    func optionView(_ OptiontableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if (sltDropDownTag == 1) {
            self.countryTxtFld.text = (arrOfShow[indexPath.row] as? [String : Any])?["name"] as? String
            let countryID = (arrOfShow[indexPath.row] as? [String : Any])?["id"] as? String
            //param.ctry = countryID
            let idPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", countryID! )
            let arrOfstate =  getStates().filtered(using: idPredicate)
            self.stateTxtFld.text = (arrOfstate[0] as? [String : Any])?["name"] as? String
            param.state = (arrOfstate[0] as? [String : Any])?["id"] as? String
        }
        else if (sltDropDownTag == 2) {
            
            
            self.stateTxtFld.text =  (arrOfShow[indexPath.row] as? [String : Any])?["name"] as? String
            param.state = (arrOfShow[indexPath.row] as? [String : Any])?["id"] as? String
            
            
        }
        else if (sltDropDownTag == 8) {
            
            
            self.equipmentCategoryTxtFld.text = self.CategoryList[indexPath.row].equ_cate
            clts =  self.CategoryList[indexPath.row].ecId ?? ""
            
            
        } else if (sltDropDownTag == 9) {
            
            
            self.equipmentGroupTxtFld.text = self.EquGroupList[indexPath.row].equ_group
            grp =  self.EquGroupList[indexPath.row].egId ?? ""
            
            
        }else if (sltDropDownTag == 10) {
            
            
            self.baradTxtFld.text = self.EquBrandListss[indexPath.row].name
            brands =  self.EquBrandListss[indexPath.row].ebId ?? ""
            
            
        }
        
        
        self.removeOptionalView()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.sltDropDownBtnTag = textField.tag
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if (textField == zipTxtFld) {
            
            if (string != "") && (textField.text?.count)! > 7 {
                return false
            }
        }
        
        switch self.sltDropDownBtnTag {
            
        case 1:
            let bPredicate: NSPredicate = NSPredicate(format: "self.name beginswith[c] %@", result)
            arrOfShow =  getCountry().filtered(using: bPredicate)
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.countryTxtFld, arr: arrOfShowData)
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
            
        case 2:
            
            let namepredicate: NSPredicate = NSPredicate(format:"self.name = %@", countryTxtFld.text! )
            let arr = getCountry().filtered(using: namepredicate)
            if(arr.count > 0){
                self.optionalVw?.isHidden = false
                let dict = (arr[0] as? [String : Any])
                let serchCourID = dict?["id"]
                let idPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                let arrOfstate =  getStates().filtered(using: idPredicate)
                let bPredicate: NSPredicate = NSPredicate(format: "self.name beginswith[c] %@", result)
                arrOfShow =  ((arrOfstate as NSArray).filtered(using: bPredicate))
                if(self.optionalVw == nil){
                    self.openDwopDown( txtField: self.stateTxtFld, arr: arrOfShowData)
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
            
        default: break
            
        }
        
        return true
    }
    
    
    func addEquipment(){
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            // hideloader()
            return
        }
        
        showLoader()
        
        let param = Params()
        //  param.equId = "263"
        param.equnm = self.equipmentTxtFld.text
        param.brand = brands//self.baradTxtFld.text
        param.mno = self.modelNoTxtFld.text
        param.sno = self.serialTxtFld.text
        param.supplier = self.superTxtFld.text
        param.expiryDate = self.warrantyExpiryDateTxtFld.text
        param.manufactureDate = self.manufctureTxtFld.text
        param.purchaseDate = self.purchaseDateTxtFld.text
        param.rate = self.equipmentTxtFld.text
        // param.status = []
        param.notes = self.notesTxtFld.text
        param.isBarcodeGenerate = isClintFutUser ? "1" : "0"
        // param.state = self.stateTxtFld.text
        // param.ctry = self.countryTxtFld.text
        param.adr = self.equipmentTxtFld.text
        param.city = self.cityTxtFld.text
        param.zip = self.zipTxtFld.text
        param.ecId = clts//self.equipmentCategoryTxtFld.text
        param.egId = grp//self.equipmentGroupTxtFld.text
        param.type = "1"
        param.status = "1"
        param.cltId = objOfUserJodbList.cltId
        param.contrId = objOfUserJodbList.contrId ?? "0"
        // param.isAddressChange = "1"
        param.jobId = objOfUserJodbList.audId
        param.extraField1 = self.customTxtFldOneSub.text
        param.extraField2 = self.customTxtFldTwoSub.text
        param.barCode = self.barCodeInsrtTxtFld.text
        param.installedDate = self.installDateTxtFld.text
        
        // print(param)
        let images = (img.image != nil) ? img.image! : nil
        serverCommunicatorUplaodImage(url: Service.addEquipment, param:  param.toDictionary, image: images, imagePath: "image[]", imageName: "image" ){(response, success) in
            //serverCommunicatorUplaodImage(url: Service.addEquipment, param: param.toDictionary, images: images, imagePath: "Image[]") { (response, success) in
            // serverCommunicator(url: Service.addEquipment, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(EquipModelsAudit.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        let searchQuery = "audId = '\(self.objOfUserJodbList.audId ?? "")'"
                        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: searchQuery) as! [AuditOfflineList]
                        if isExist.count > 0{
                            var  art = isExist[0].equArray as! [AnyObject]
                            
                            
                            let existingJob = isExist[0]
                            
                            if existingJob.equArray != nil {
                                let item = (existingJob.equArray as! [AnyObject])
                                var arrItem = [Any]()
                                
                                for itam1 in item {
                                    
                                    
                                    let ijmt = itam1["equId"] as? String
                                    if ijmt == decodedData.data?.equId{
                                        // itam1 = itemDt.toDictionary as AnyObject
                                        arrItem.append(decodedData.data as Any)
                                        
                                    }else{
                                        arrItem.append(itam1)
                                    }
                                }
                                arrItem.append(decodedData.data.toDictionary as Any)
                                existingJob.equArray = arrItem as NSObject
                                //   print(item.count)
                            }
                            DatabaseClass.shared.saveEntity(callback: {_ in
                                
                            })
                            //
                        }
                        DispatchQueue.main.async {
                            // self.addEquip = true
                            self.navigationController?.popToRootViewController(animated: true)
                            // self.showToast(message:LanguageKey.euipment_remark_update)
                        }
                    }else{
                        killLoader()
                        ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    killLoader()
                    ShowError(message: "This Barcode is already allocated to another equipment, please choose another one.", controller: windowController)
                }
            }else{
                killLoader()
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    
    //=====================================
    // MARK:- Get getCategory List Service
    //=====================================
    
    func getCategoryList(){
        //        "limit ->LINIT
        //        index -> Index
        //        search ->Search [Category name]"
        
        
        param.limit = "500"
        param.index = "0"
        param.activeRecord = "0"
        serverCommunicator(url: Service.getEquCategoryList, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(EquCltListg.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        //  print("\(decodedData)")
                        
                        self.CategoryList = decodedData.data as! [EquCltLists]
                        
                        
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
    
    func getEquGroupList(){
        //        "limit ->LINIT
        //        index -> Index
        //        search ->Search [Category name]"
        
        
        param.limit = "500"
        param.index = "0"
        param.activeRecord = "0"
        serverCommunicator(url: Service.getEquGroupList, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(EquGroupListg.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        //   print("\(decodedData)")
                        
                        self.EquGroupList = decodedData.data as! [EquGroupLists]
                        
                        
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
    
    func getEquBrandList(){
        //        "limit ->LINIT
        //        index -> Index
        //        search ->Search [Category name]"
        
        
        param.limit = "500"
        param.index = "0"
        param.activeRecord = "0"
        serverCommunicator(url: Service.getEquBrandList, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(EquBrangListg.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        //   print("\(decodedData)")
                        
                        self.EquBrandListss = decodedData.data as! [EquBrandLists]
                        
                        
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
    
    func getEquipmentListOfflineBarcodeScanner(barcodeString : String) -> Void{
        self.scanBarcodeId = barcodeString
        self.barCodeInsrtTxtFld.text = scanBarcodeId
    }
    
}

extension addEquipmentRemark : BarcodeScannerErrorDelegate, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        //   print(code)
        getEquipmentListOfflineBarcodeScanner(barcodeString: code)
        UserDefaults.standard.set(code, forKey: "barcodeString")
        //  getEquipmentListFromBarcodeScanner(barcodeString: code)
        controller.dismiss(animated: true, completion: {
            controller.reset()
        }
        )
    }
    
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        //  print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class EquipModelsAudit: Codable {
    var success:Bool?
    var message:String?
    var data:ModalAudit?
}
class ModalAudit: Codable {
    var adr:String?
    var barcode:String?
    var barcodeImg:String?
    var brand:String?
    var city:String?
    var cltId:String?
    var ctry:String?
    var ecId:String?
    var egId:String?
    var equId:String?
    var equImage: [ModalimageAudit]?
    
    var equnm:String?
    var expiryDate:String?
    var isusable:String?
    // var lastAudit: []
    // var lastContract: []
    var manufactureDate:String?
    var mno:String?
    var nm: String?
    var notes: String?
    var purchaseDate: String?
    var rate: String?
    var sno: String?
    var state: String?
    var status: String?
    var supplier: String?
    var type: String?
    var zip: String?
}
class ModalimageAudit: Codable {
    var imgId: String?
    var img: String?
}

struct ImageModel_addEquipmentRemark {
    var img: UIImage?
   
}

extension UIImage {
    func resizeImage_addEquipmentRemark(targetSize: CGSize) -> UIImage {
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
