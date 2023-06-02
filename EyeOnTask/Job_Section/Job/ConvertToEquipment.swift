//
//  ConvertToEquipment.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 06/11/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import MessageUI
import Photos
import CoreData
import MobileCoreServices
import JJFloatingActionButton

class  ConvertToEquipment: UIViewController,OptionViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIDocumentPickerDelegate  {
    
    
    
    @IBOutlet weak var warrantySartTxtFld: FloatLabelTextField!
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
    
    var objOfUserJodbList = UserJobList()
    var itemList = ""
    var DisList = ""
    var warntyType = ""
    var warntyVelue = ""
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
    var CategoryList = [EquCltLists]()
    var EquBrandListss = [EquBrandLists]()
    
    var a = Bool()
    var b = Bool()
    var c = Bool()
    var d = Bool()
    var addEquip = false
    var grp = ""
    var clts = ""
    var brands = ""
    let param = Params()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print("warntyType ---- \(warntyType)")
      //  print("warntyVelue ---- \(warntyVelue )")
        
        let currntDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat="dd-MM-yyyy"
        let str = formatter.string(from: currntDate)
        warrantySartTxtFld.text = str

        let warntyDataVelue = Int(warntyVelue)
        let warntyDataType = Int(warntyType)
        
        if warntyDataType == 0 { // FOR DAY
            
             let dayToAdd = warntyDataVelue
             let currentDate = Date()
             var dateComponent = DateComponents()
             dateComponent.day = dayToAdd
             let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
             let currntDateEx = futureDate
             let formatterEx = DateFormatter()
             formatterEx.dateFormat="dd-MM-yyyy"
             let endDateEx = formatterEx.string(from: currntDateEx!)
             warrantyExpiryDateTxtFld.text = endDateEx
           //  print(currentDate)
           //  print(futureDate!)
            
        }else if warntyDataType == 1 { //FOR MONTH
            
            let monthToAdd = warntyDataVelue
            let currentDate = Date()
            var dateComponent = DateComponents()
            dateComponent.month = monthToAdd
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
            let currntDateEx = futureDate
            let formatterEx = DateFormatter()
            formatterEx.dateFormat="dd-MM-yyyy"
            let endDateEx = formatterEx.string(from: currntDateEx!)
            warrantyExpiryDateTxtFld.text = endDateEx
           // print(currentDate)
          //  print(futureDate!)
            
        } else if warntyDataType == 2 { //FOR YEAR
            
            let yearsToAdd = warntyDataVelue
            let currentDate = Date()
            var dateComponent = DateComponents()
            dateComponent.year = yearsToAdd
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
            let currntDateEx = futureDate
            let formatterEx = DateFormatter()
            formatterEx.dateFormat="dd-MM-yyyy"
            let endDateEx = formatterEx.string(from: currntDateEx!)
            warrantyExpiryDateTxtFld.text = endDateEx
           // print(currentDate)
           // print(futureDate!)
        }
        
        
//       // let monthsToAdd = ""
//      //  let daysToAdd = ""
//      //  let yearsToAdd = expDate
//        let currentDate = Date()
//        var dateComponent = DateComponents()
//      //  dateComponent.month = monthsToAdd
//      //  dateComponent.day = daysToAdd
//        dateComponent.year = yearsToAdd
//        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
//
//        let currntDateEx = futureDate
//        let formatterEx = DateFormatter()
//        formatterEx.dateFormat="dd-MM-yyyy"
//        let endDateEx = formatterEx.string(from: currntDateEx!)
//        warrantyExpiryDateTxtFld.text = endDateEx
//        print(currentDate)
//        print(futureDate!)
        

        
        self.customTxtFldOne.text =  getDefaultSettings()?.equpExtraField1Label
        customTxtFldOneSub.placeholder = self.customTxtFldOne.text
        
        
        self.customTxtFldTwo.text =  getDefaultSettings()?.equpExtraField2Label
        customTxtFldTwoSub.placeholder = self.customTxtFldTwo.text
        
        
        getEquBrandList()
        self.equipmentTxtFld.text = itemList
        self.notesTxtFld.text = DisList
        getCategoryList()
        getEquGroupList()
        self.setLocalization()
        self.countryTxtFld.text = "India"
        self.stateTxtFld.text = "Madhya Pradesh"
        self.cityTxtFld.text = "Indore"
        param.state = "21"
        param.ctry = "101"
        
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
        serialTxtFld.placeholder = "\(LanguageKey.serial_no)"
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
        
        
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
            let imgStruct = ImageModel_ConvertToEquipment(img: (info[.originalImage] as? UIImage)?.resizeImage_ConvertToEquipment(targetSize: CGSize(width: 1000.0, height: 10000.0)))
            img.image = (imgStruct.img!)//image as? UIImage
            
        }
        
        self.img.isHidden = false
        
        
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
    
    @IBAction func genrateBarcode(_ sender: Any) {
        
        if(genrateBarcode.imageView?.image == UIImage(named: "BoxOFUncheck")){
            self.genrateBarcode.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
            
            self.isClintFutUser = true
            
            
        }else{
            // isAddValidation = false
            self.genrateBarcode.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
            self.isClintFutUser = false
            
        }
    }
    @IBAction func saveBtn(_ sender: Any) {
        
        
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
    
    @IBAction func warrntyStartBtn(_ sender: Any) {
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
            warrantySartTxtFld.text = str
            self.bigView.isHidden = true
        }
        
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
        
        param.equnm = self.equipmentTxtFld.text
        param.brand = brands//self.baradTxtFld.text
        param.mno = self.modelNoTxtFld.text
        param.sno = self.serialTxtFld.text
        param.supplier = self.superTxtFld.text
        param.expiryDate = self.warrantyExpiryDateTxtFld.text
        param.warrantyStartDate = self.warrantySartTxtFld.text
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
        param.jobId = objOfUserJodbList.jobId
        param.extraField1 = self.customTxtFldOneSub.text
        param.extraField2 = self.customTxtFldTwoSub.text
        
        let images = (img.image != nil) ? img.image! : nil
        serverCommunicatorUplaodImage(url: Service.addEquipment, param:  param.toDictionary, image: images, imagePath: "image[]", imageName: "image" ){(response, success) in
            //serverCommunicatorUplaodImage(url: Service.addEquipment, param: param.toDictionary, images: images, imagePath: "Image[]") { (response, success) in
            // serverCommunicator(url: Service.addEquipment, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(EquipModels1.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        let searchQuery = "jobId = '\(self.objOfUserJodbList.jobId ?? "")'"
                        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
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
                                //  print(item.count)
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
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
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
                        //   print("\(decodedData)")
                        
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
                        //    print("\(decodedData)")
                        
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
    
    
}
class EquipModels1: Codable {
    var success:Bool?
    var message:String?
    var data:Modal1?
}
class Modal1: Codable {
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
    var equImage: [Modalimage1]?
    var equnm:String?
    var expiryDate:String?
    var isusable:String?
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

class Modalimage1: Codable {
    var imgId: String?
    var img: String?
}

struct ImageModel_ConvertToEquipment {
    var img: UIImage?
    
}

extension UIImage {
    func resizeImage_ConvertToEquipment(targetSize: CGSize) -> UIImage {
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
