//
//  AddClientVC.swift
//  EyeOnTask
//
//  Created by Apple on 05/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation


@available(iOS 13.0, *)
class AddClientVC: UIViewController , OptionViewDelegate , UITextFieldDelegate {
  
    
    
    @IBOutlet weak var txtFielf_Reference: FloatLabelTextField!
    @IBOutlet var latitute: UITextField!
    @IBOutlet var longitute: UITextField!
    @IBOutlet var scroll_View: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet var txtField_ClintNm: UITextField!
    @IBOutlet var txtfield_AccNm: UITextField!
    @IBOutlet var txtField_EmailId: UITextField!
    @IBOutlet var txtField_Addrs: UITextField!
    @IBOutlet var txtField_MobNm: UITextField!
    @IBOutlet var txtField_Country: UITextField!
    @IBOutlet var txtField_State: UITextField!
    @IBOutlet var txtField_GSTNo: UITextField!
    @IBOutlet var txtField_Zip: UITextField!
    @IBOutlet var txtField_City: UITextField!
    @IBOutlet var txtField_TinNo: UITextField!
    @IBOutlet var txtField_AccTyp: UITextField!
    @IBOutlet var txtField_Note: UITextField!
    @IBOutlet var txtField_Industry: UITextField!
    @IBOutlet weak var txtField_Site: FloatLabelTextField!
    @IBOutlet weak var txtFielf_Contact: FloatLabelTextField!
    
    @IBOutlet weak var H_lattitude: NSLayoutConstraint!
    @IBOutlet weak var BtnLatlng: UIButton!
    var respAddClient = addClient1 ()
    let cellReuseIdentifier = "cell"
    var count : Int = 0
    var callbackForClientVC: ((Bool) -> Void)?
    var scrollPoint : CGPoint?
    var arr = ["Existing Customer","Google","Local Newspaper","Media","Television","WOM","Website"," Facebook","Instagram","Magazine","Other"]
    var arrKey = ["1","2","3","4","5","6","7","8","9","10","11"]
    
   // let industries = [[ "id" : "1", "name" : "Accounting" ],[ "id" : "2", "name" : "Advertising" ],[ "id" : "3", "name" : "Biotechnology" ],[ "id" : "4", "name" : "Communications" ],[ "id" : "5", "name" : "Consulting" ]];
    var sltTxtField = UITextField()

    var arrOfShowData = [Any]()
    var sltDropDownTag : Int!
    var optionalVw : OptionalView?
    var arrOfAccType = [UserAccType]()
    var fltArrOfAccTyp = [UserAccType]()
    var arrOfIndustryList = [IndustryList]()
    var arrOfReferenceList = [ReferenceList]()
    // var arrOfReferenceList1 = [getReferenceListDetails]()
    var arrOfShowDataState = [Any]()
    var arrOfShowDataCntry = [Any]()
    var data : String? = ""
//    var codes = UserDefaults.standard.value(forKey: "datacode")
    var contryCode = ""
    let param = Params()
    var arrofcompenysetting =  getCompanySettingsDetails()
   
   

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
   // print(getCompanySettingsResponse)
      //  print(arrofcompenysetting)
       
    if let cntryCode = getDefaultSettings()?.ctryCode
            {
                contryCode = cntryCode
            }
        txtFielf_Contact.text = "self"
        txtField_Site.text = "self"
    
       // param.state = "21"
       // param.ctry = "101"
        self.registorKeyboardNotification()
        self.getAccounttype()
        getReferenceList()
        self.getIndustryList()
        if getDefaultSettings()?.isJobLatLngEnable == "0" {
            H_lattitude.constant = 0.0
        }
        
        getClientListFromDBjob()
        getReferenceListDBjob()
        setLocalization()
        getCompanySettings()
        
        ActivityLog(module:Modules.client.rawValue , message: ActivityMessages.clientAdd)
        
       
    }
    @objc func addTapped(){}
    func setLocalization() -> Void {
            self.navigationItem.title = LanguageKey.add_client
            txtField_ClintNm.placeholder = "\(LanguageKey.client_name) *"
            txtfield_AccNm.placeholder = LanguageKey.Account_type
            txtField_EmailId.placeholder = "\(LanguageKey.email)"
            txtField_MobNm.placeholder = "\(LanguageKey.mob_no)"
            txtField_Addrs.placeholder = "\(LanguageKey.address) *"
            txtField_Country.placeholder = "\(LanguageKey.country) *"
            txtField_State.placeholder = "\(LanguageKey.state) *"
            txtField_City.placeholder = LanguageKey.city
            txtFielf_Reference.placeholder = LanguageKey.reference
            txtFielf_Contact.placeholder = "\(LanguageKey.contact_name) *"
            txtField_Site.placeholder = "\(LanguageKey.site_name) *"
            txtField_Zip.placeholder = LanguageKey.zip
            txtField_GSTNo.placeholder = LanguageKey.gst_no
            txtField_TinNo.placeholder = LanguageKey.tin_no
            txtField_Industry.placeholder = LanguageKey.industry
            txtField_Note.placeholder = LanguageKey.notes
            latitute.placeholder = LanguageKey.latitude
            longitute.placeholder = LanguageKey.longitued
            btnSave.setTitle(LanguageKey.create_client , for: .normal)
            BtnLatlng.setTitle(LanguageKey.get_current_lat_long , for: .normal)
//        if let gst = clientDetails?.gstNo{
//            lblGST.text = ""
//        }else if let tin = clientDetails?.tinNo{
//            lblTIN.text = ""
//        }else{
//            
//        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
        self.removeKeyboardNotification()
    }
    
    //=====================================
    //MARK:- Registor Keyboard Notification
    //=====================================
    func registorKeyboardNotification(){
        IQKeyboardManager.shared.enable = false

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
    

 
    @IBAction func saveBtnAction(_ sender: UIButton) {
        let trimmClintNm  =  self.txtField_ClintNm.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmEmail = self.txtField_EmailId.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmMobNo = self.txtField_MobNm.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmAdr = self.txtField_Addrs.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmCountry = param.ctry?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmState = param.state?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let trimmSite = self.txtField_Site.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmContact = self.txtFielf_Contact.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
//        if trimmEmail!.count > 0 {
//            if !isValidEmail(testStr: trimmEmail!)  {
//                ShowError(message: AlertMessage.enterValidEmail, controller: windowController)
//                return
//            }
//        }
//
//
//        if (trimmMobNo!.count > 0) && (trimmMobNo!.count < 8)  {
//            ShowError(message: AlertMessage.validMobile, controller: windowController)
//            return
//        }
        
        
        
        if(trimmClintNm != nil && trimmClintNm != ""){
            if(trimmSite != nil && trimmSite != ""){
                if(trimmContact != nil && trimmContact != ""){
                    
                   // if(trimmEmail != nil && trimmEmail != ""){
                      //  if(trimmMobNo != nil && trimmMobNo != ""){
                            if(trimmAdr != nil && trimmAdr != ""){
                              //  if(trimmCountry != nil && trimmCountry != ""){
                                //    if(trimmState != nil && trimmState != ""){
                                        
                                        
                                        addClint()
                                        
                                        
                             //       }else{
                                    //    ShowError(message: AlertMessage.validState, controller: windowController)
                            //        }
                            //    }else{
                                //    ShowError(message: AlertMessage.validCountry, controller: windowController)
                           //     }
                            }else{
                                ShowError(message: AlertMessage.validAddress, controller: windowController)
                            }
//                        }else{
//                            ShowError(message: AlertMessage.addClientMobileNumber, controller: windowController)
//                        }
//                    }else{
//                        ShowError(message: AlertMessage.enterValidEmail, controller: windowController)
//                    }
                }else{
                    ShowError(message: AlertMessage.cont_name, controller: windowController)
                }
            }else{
                ShowError(message:AlertMessage.err_site_name, controller: windowController)
            }
        }else{
            ShowError(message: AlertMessage.clientName, controller: windowController)
        }
    }
    
    
    func getCountry() -> NSArray {
        return getJson(fileName: "countries")["countries"] as! NSArray
    }
    
    func getStates() -> NSArray {
        return getJson(fileName: "states")["states"] as! NSArray
    }
    

//==========================
//MARK:- Btn Action Methhod
//==========================
    @IBAction func btnDwopDownAction(_ sender: UIButton) {
        self.sltDropDownTag = sender.tag
        switch  sender.tag {
        case 1:
            if(self.optionalVw == nil){
                arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserAccType", query: nil) as! [UserAccType]
                self.openDwopDown( txtField: self.txtfield_AccNm, arr: arrOfShowData)
            }else{
                self.removeOptionalView()

            }
            break
        case 5:
            if(self.optionalVw == nil){
              //  self.reradJson()
                arrOfShowData = getJson(fileName: "countries")["countries"] as! [Any]
                self.openDwopDown( txtField: self.txtField_Country, arr: arrOfShowData)
                
            }else{
                self.removeOptionalView()
            }
           
            break
        case 6:
            if(self.optionalVw == nil){
                
                self.removeOptionalView()
                let namepredicate: NSPredicate = NSPredicate(format:"self.name == %@", self.txtField_Country.text! )
                let arr = getCountry().filtered(using: namepredicate)
                if(arr.count > 0){
                    let dict = (arr[0] as? [String : Any])
                    let serchCourID = dict!["id"]
                    let bPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                    arrOfShowData =  getStates().filtered(using: bPredicate)
                    self.openDwopDown( txtField: self.txtField_State, arr: arrOfShowData)
                }
            }else{
                self.removeOptionalView()

            }
            break
        case 11 :
            
            if(self.optionalVw == nil){
                
                
                arrOfShowData = arrOfIndustryList
           
//                self.arrOfIndustryList = self.arrOfIndustryList.sorted(by: { (Obj1, Obj2) -> Bool in
//                                 let Obj1_Name = Obj1.industryName ?? ""
//                                 let Obj2_Name = Obj2.industryId ?? ""
//                                 return (Obj1_Name.localizedCaseInsensitiveCompare( Obj2_Name) == .orderedAscending)
//                             })
//
                                     self.openDwopDown( txtField: self.txtField_Industry, arr: arrOfShowData)
        
                    //self.openDwopDown( txtField: txtField_Industry, arr: arrOfIndustryList)
                            }else{
                            self.removeOptionalView()
        }
            
            case 12:
            

                if(self.optionalVw == nil){
                      arrOfShowData = arrOfReferenceList
                  //  let bPredicate: NSPredicate = NSPredicate(format: "self. comp_name == '%@'",self.txtFielf_Reference)
                  //  arrOfShowData =  (arrOfReferenceList as NSArray).filtered(using: bPredicate)
                    
                       self.openDwopDown( txtField: self.txtFielf_Reference, arr: arrOfShowData)
                   
            
                        //self.openDwopDown( txtField: txtField_Industry, arr: arrOfIndustryList)
                                }else{
                                self.removeOptionalView()
            }
            
//            arrOfShowData = APP_Delegate.industries
//            self.openDwopDown( txtField: self.txtField_Industry, arr: arrOfShowData)
        default:
         //   print("Defalt")
            break
        }

    }

    //==========================
    //MARK:- Open OptionalView
    //==========================
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x:10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height ), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
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
    
    func openDwopDownForConstactHeight(txtField : UITextField , arr : [Any]) {
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x:10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height ), width: self.view.frame.size.width - 20, height: 100))
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
        }
    }
 
    //=====================================
    //MARK:- OptionalView Delegate method
    //=====================================
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  return arrOfShowData.count
            
               if (sltDropDownTag == 1) {
                  return arrOfShowData.count
               }
               else if (sltDropDownTag == 5) {
                 return arrOfShowData.count
               }
               else if (sltDropDownTag == 6) {

                  return arrOfShowData.count
               }
            
               else if (sltDropDownTag == 11) {
                return arrOfShowData.count

               }else if (sltDropDownTag == 12) {
                return arrOfShowData.count

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
        //cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
        cell?.textLabel?.textColor = UIColor.darkGray

        
        switch self.sltDropDownTag {
        case 1:
              cell?.textLabel?.text = (arrOfShowData[indexPath.row] as! UserAccType).type?.capitalizingFirstLetter()
            break
        case 5:
            cell?.textLabel?.text = ((arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
            break
            
        case 6:
            cell?.textLabel?.text = ((arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
            break
        case 11:
            
           
            
           // let uniqueStrings = ["\(uniqueElementsFrom(array:ab))"]
                           
            cell?.textLabel?.text =   arrOfIndustryList[indexPath.row].industryName //  ((arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
            break
             case 12:
                   cell?.textLabel?.text = arrOfReferenceList[indexPath.row].refName //arr[indexPath.row]
        default: break
            
        }
        return cell!
    }
    
    
    func uniqueElementsFrom(array: [String]) -> [String] {
      //Create an empty Set to track unique items
      var set = Set<String>()
      let result = array.filter {
        guard !set.contains($0 as! String) else {
          //If the set already contains this object, return false
          //so we skip it
          return false
        }
        //Add this item to the set since it will now be in the array
        set.insert($0 as! String)
        //Return true so that filtered array will contain this item.
        return true
      }
      return result
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.sltDropDownTag {
        case 1:
            self.txtfield_AccNm.text =  (self.arrOfShowData[indexPath.row] as? UserAccType)?.type
            param.pymtType = (self.arrOfShowData[indexPath.row] as? UserAccType)?.accId
            self.removeOptionalView()
            break
        case 5:
            self.txtField_Country.text = (arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String
            let countryID = (arrOfShowData[indexPath.row] as? [String : Any])?["id"] as? String
            param.ctry = countryID
            let idPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", countryID! )
            let arrOfstate =  getStates().filtered(using: idPredicate)
            self.txtField_State.text = (arrOfstate[0] as? [String : Any])?["name"] as? String
            param.state = (arrOfstate[0] as? [String : Any])?["id"] as? String
            self.removeOptionalView()
            break
        case 6:
            self.txtField_State.text =  (arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String
            param.state = (arrOfShowData[indexPath.row] as? [String : Any])?["id"] as? String
            self.removeOptionalView()
            break
            
        case 11:
            self.txtField_Industry.text =  arrOfIndustryList[indexPath.row].industryName //(arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String
          
            param.industryName =  arrOfIndustryList[indexPath.row].industryName
            param.industry = arrOfIndustryList[indexPath.row].industryId
            self.removeOptionalView()
            break
        case 12:
            self.txtFielf_Reference.text =  arrOfReferenceList[indexPath.row].refName
            param.comp_name = arrOfReferenceList[indexPath.row].refName
            param.referral = arrOfReferenceList[indexPath.row].refId
            self.removeOptionalView()
            
//            self.txtFielf_Reference.text =  arr[indexPath.row]
//            param.comp_name = arr[indexPath.row]
//            param.referral = arrKey[indexPath.row]
//            self.removeOptionalView()
            break
        default:
            break
        }
    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
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
            latitute.text = "\(currentLocation.coordinate.latitude)"
            longitute.text = "\(currentLocation.coordinate.longitude)"
        }
       }
    @IBAction func btnAddLatLong(_ sender: Any) {
        getCurrentLatLng ()
    }
    
    //=====================================
    //MARK:- TxtField Delegate method
    //=====================================
    
    func openDropDownWhenKeyBordappere(){
       if self.sltTxtField.isEqual(txtField_Country) {
        
            self.removeOptionalView()
            arrOfShowData = getJson(fileName: "countries")["countries"] as! [Any]
            self.openDwopDown( txtField: self.txtField_Country, arr: arrOfShowData)
            
            
        }else if self.sltTxtField.isEqual(txtField_State){
       
            self.removeOptionalView()
            let namepredicate: NSPredicate = NSPredicate(format:"self.name == '%@'", self.txtField_Country.text! )
            let arr = getCountry().filtered(using: namepredicate)
            if(arr.count > 0){
                let dict = (arr[0] as? [String : String])
                let serchCourID = dict!["id"]
                let bPredicate: NSPredicate = NSPredicate(format:"self.country_id == '%@'", serchCourID! )
                arrOfShowData =  getStates().filtered(using: bPredicate)
                self.openDwopDown( txtField: self.txtField_State, arr: arrOfShowData)
            }
        }else if self.sltTxtField.isEqual(txtField_Industry){
            self.removeOptionalView()
           // arrOfShowData =  APP_Delegate.industries
           // self.openDwopDown( txtField: self.txtField_Industry, arr: arrOfShowData)
        }
        else{
            self.removeOptionalView()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
        self.sltTxtField = textField
        self.sltDropDownTag = textField.tag
        if(self.sltTxtField.isEqual(txtField_Country)){
            txtField_Country.text = ""
            param.ctry = nil
        } else if self.sltTxtField.isEqual(txtField_State){
            txtField_State.text = ""
            param.state = nil
        }
        if txtField_MobNm.text!.isEmpty {
                   txtField_MobNm.text = contryCode + txtField_MobNm.text!
                   txtField_MobNm.textColor = UIColor.lightGray
               }
               
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
         let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if (textField == txtField_Zip) {
                         
                         if (string != "") && (textField.text?.count)! > 7 {
                             return false
                         }
               }
        
        
        if (textField == txtField_MobNm) {
                 
                 if (string != "") && (textField.text?.count)! > 14 {
                     return false
                 }
                 
                 let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                 let compSepByCharInSet = string.components(separatedBy: aSet)
                 let numberFiltered = compSepByCharInSet.joined(separator: "")
                 return string == numberFiltered
             }
        
        
        if (textField == latitute) || (textField == longitute){
            let insensitiveCount = result.lowercased().filter{ $0 == Character(String(".").lowercased())}
            if insensitiveCount.count > 1 {
                return false
            }
            
            
            let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
            
        }
        
        
        
        switch self.sltDropDownTag {
        case 5:
             let bPredicate: NSPredicate = NSPredicate(format: "self.name beginswith[c] %@", result)
             arrOfShowData =  getCountry().filtered(using: bPredicate)
             if(self.optionalVw == nil){
                self.openDwopDownForConstactHeight( txtField: textField, arr: arrOfShowData)
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
            
        case 6 :
            
            let namepredicate: NSPredicate = NSPredicate(format:"self.name == %@", self.txtField_Country.text! )
            let arr = getCountry().filtered(using: namepredicate)
            if(arr.count > 0){
                let dict = (arr[0] as? [String : Any])
                let serchCourID = dict?["id"]
                let idPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                let arrOfstate =  getStates().filtered(using: idPredicate)
                 let bPredicate: NSPredicate = NSPredicate(format: "self.name beginswith[c] %@", result)
                arrOfShowData =  ((arrOfstate as NSArray).filtered(using: bPredicate))
                if(self.optionalVw == nil){
                    self.openDwopDownForConstactHeight( txtField: textField, arr: arrOfShowData)
                }
                DispatchQueue.main.async{
                    if(self.arrOfShowData.count > 0){
                        self.optionalVw?.isHidden = false
                        self.optionalVw?.table_View?.reloadData()
                    }else{
                        self.optionalVw?.isHidden = true
                        self.removeOptionalView()
                    }
                }
                
            }
        break
        case 11:
            let bPredicate: NSPredicate = NSPredicate(format: "self.name beginswith[c] %@", result)
            arrOfShowData =  (( APP_Delegate.industries as NSArray).filtered(using: bPredicate))
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: textField, arr: arrOfShowData)
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
            
        default:
            break
        }
        
        
     
        
        return true
    }
    
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   
        textField.resignFirstResponder()
        txtField_ClintNm.resignFirstResponder()
        txtField_ClintNm.text! += " "
     

        return true
    }
    
  
    
    //==============================
    // MARK:- Save data in DataBase
    //==============================
    func saveNewCreatedClientInDataBase( data : AddClientDetails?) -> Void {
        if  let obj = data{
            let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientList")
            userJobs?.setValuesForKeys(obj.toDictionary!)
            DatabaseClass.shared.saveEntity(callback: { _ in})
        }
    }
    
    
    func getTempIdForNewClient(newId : Int) -> String {
        
        return "Client-\(String(describing: getUserDetails()?.usrId ?? ""))-\(getCurrentTimeStamp())"
        
//        let searchQuery = "cltId = 'Client-\(newId)'"
//        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: searchQuery) as! [ClientList]
//        if isExist.count == 0 {
//            return "Client-\(newId)"
//        }else{
//            return getTempIdForNewClient(newId: newId + 1)
//        }
    }
   
    
    func addClint(){
      /*
        compId -> company id
        nm -> client name
        pymtType -> payment type (accId)
        gstNo -> GST Number
        tinNo - >TIN number
        industry -> Industry
        note -> some text
        
        snm -> site name
        adr -> address
        city -> city
        state -> state
        ctry -> country
        zip -> zipcode
        
        cnm -> contact name
        email -> email
        mob1 -> mobile no-1
        mob2 -> mobile no- 2
        fax -> fax number
        twitter -> twitter id
        skype -> skype id
 */
        
        
    
        btnSave.isUserInteractionEnabled = true
        let temp = getTempIdForNewClient(newId: 0)
        param.tempId = temp
        param.cltId = temp

        param.nm  = trimString(string:  self.txtField_ClintNm.text!)
        param.gstNo  = trimString(string:  self.txtField_GSTNo.text!)
        param.tinNo = trimString(string:  self.txtField_TinNo.text!)
        param.note = trimString(string:  self.txtField_Note.text!)
        param.snm  = trimString(string:  self.txtField_Site.text!)
        param.adr =  trimString(string: self.txtField_Addrs.text!)
        param.city = trimString(string: self.txtField_City.text!)
        param.cnm = trimString(string:  self.txtFielf_Contact.text!)
        param.email  = trimString(string: self.txtField_EmailId.text!)
        param.mob1 = trimString(string: self.txtField_MobNm.text!)
        param.jtId = nil
        param.lat = trimString(string: self.latitute.text!)
        param.lng = trimString(string: self.longitute.text!)

        //Save in LOCAL DATABASE
        let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientList")
        userJobs?.setValuesForKeys(param.toDictionary!)
        DatabaseClass.shared.saveEntity(callback: {isSuccess in
            if self.callbackForClientVC != nil {
                self.callbackForClientVC!(true)
            }
            
            
            param.tempId = param.cltId
            param.compId = getUserDetails()?.compId
            param.zip  = trimString(string: self.txtField_Zip.text!)
            param.def = "1"
            serverCommunicator(url: Service.addClient, param: param.toDictionary) { (response, success) in
                 let decoder = JSONDecoder()
                 if let decodedData = try? decoder.decode(addClientRs.self, from: response as! Data) {
                     
                     if decodedData.success == true{
                         UserDefaults.standard.set(CurrentDateTime(), forKey: Service.addClient)
                         self.respAddClient = decodedData.data!
                        //=====================
                        var isSwitchOff = ""
                        isSwitchOff =   UserDefaults.standard.value(forKey: "kprVelue") as? String ?? ""
                        
                        let message = ChatMessageModelForJob1()
                     
                        message.usrId = isSwitchOff
                        message.action = "AddClient"
                        message.msg = "A new Client has been created with Client Name \(self.respAddClient.nm ?? "")."
                        message.usrNm = trimString(string: "\(getUserDetails()?.fnm ?? "")")
                        message.usrType = "2"
                        message.id =  self.respAddClient.cltId
                        message.type = "CLIENT"
                        message.time = getCurrentTimeStamp()
                        
                        ChatManager.shared.sendClientdMessageForJob(jobid: self.respAddClient.cltId ?? "", messageDict: message)

                                                                    
                                    
                                    //==========================
                         print("addClientRs====jugal")
                     }
                 }
             }
            
            showToast(message: AlertMessage.clientAdd) // Alert msgs
            
            //Save and send service
            DatabaseClass.shared.saveOffline(service: Service.addClient, param: param)
            //==========================
        
            
            

            self.navigationController?.popViewController(animated: true)
        })
}
     
    
    func showDataOnTableViewJob(query : String?) -> Void {
        let arrOfIndustry = DatabaseClass.shared.fetchDataFromDatabse(entityName: "IndustryList", query: query) as! [IndustryList]
        
        if arrOfIndustry.count > 0 {
            
            for data in arrOfIndustry {
                
                if arrOfIndustryList.contains(where: { $0.industryId == data.industryId }) {
                    // found
                } else {
                    // not
                    arrOfIndustryList.append(data)
                  //  arrOfIndustryList.sorted(by: true)
                    self.arrOfIndustryList = self.arrOfIndustryList.sorted(by: { (Obj1, Obj2) -> Bool in
                        let Obj1_Name = Obj1.industryName ?? ""
                        let Obj2_Name = Obj2.industryName ?? ""
                        return (Obj1_Name.localizedCaseInsensitiveCompare( Obj2_Name) == .orderedAscending)
                    })
                }
            }
            
        }
        
        
        DispatchQueue.main.async {
            self.optionalVw?.isHidden = self.arrOfIndustryList.count > 0 ? false : true
        }
    }
    
    func showReferenceDataOnTableViewJob(query : String?) -> Void {
         let arrOfIndustry = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ReferenceList", query: query) as! [ReferenceList]
         
         if arrOfIndustry.count > 0 {
             
             for data in arrOfIndustry {
                 
                 if arrOfReferenceList.contains(where: { $0.refId == data.refId }) {
                     // found
                 } else {
                     // not
                     arrOfReferenceList.append(data)
                     self.arrOfReferenceList = self.arrOfReferenceList.sorted(by: { (Obj1, Obj2) -> Bool in
                         let Obj1_Name = Obj1.refName ?? ""
                         let Obj2_Name = Obj2.refName ?? ""
                         return (Obj1_Name.localizedCaseInsensitiveCompare( Obj2_Name) == .orderedAscending)
                     })
                     
                 }
             }
             
         }
         
         
         DispatchQueue.main.async {
             self.optionalVw?.isHidden = self.arrOfIndustryList.count > 0 ? false : true
         }
     }
      
      
      
      
      func getClientListFromDBjob() -> Void {
           
         
               showDataOnTableViewJob(query: nil)
           
          

        }
    func getReferenceListDBjob() -> Void {
              
            
                  showReferenceDataOnTableViewJob(query: nil)
              
             

           }
    
    //=====================================
    // MARK:- Get Account Type Service
    //=====================================
    
    func getAccounttype(){
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
        
        
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getAccType) as? String
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "\(count)"
        param.search = ""
        param.dateTime = lastRequestTime ?? ""
    
        serverCommunicator(url: Service.getAccType, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AccountTypeName.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        if decodedData.data.count != 0 {
                            self.saveAccTypeInDB(data: decodedData.data )
                            self.count += (decodedData.data.count)
                        }
                        
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                        
                            self.getAccounttype()
                        }else{
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getAccType)
                           
                           
                        }
                        
//                        //Request time will be update when data comes otherwise time won't be update
//                        UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getAccType)
//                        DispatchQueue.main.async{
//                            self.saveAccTypeInDB(data: decodedData.data )
//                        }
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
    
    
    //==============================
    // MARK:- Save data in DataBase
    //==============================
    func saveAccTypeInDB( data : [accountTypeDetails]) -> Void {
        for jobs in data{
            let query = "accId = '\(jobs.accId!)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserAccType", query: query) as! [UserAccType]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                existingJob.setValuesForKeys(jobs.toDictionary!)
               // DatabaseClass.shared.saveEntity()
            }else{
                let userJobs = DatabaseClass.shared.createEntity(entityName: "UserAccType")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
               // DatabaseClass.shared.saveEntity()
            }
        }
        
         DatabaseClass.shared.saveEntity(callback: { _ in })
    }
    
    //========================================
    //MARK:-  Stop Copy Paste of Numbers Filed
    //========================================
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if txtField_MobNm.isFirstResponder || txtField_Zip.isFirstResponder {
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
            visibleRect.size.height -= keyboardFrame.size.height;
            
            var frameFrmScrollView = self.sltTxtField.convert(self.sltTxtField.bounds, to:self.scroll_View)
            frameFrmScrollView.origin.y += 150.0  // 150 DropDown Height
            
            var frameFrmView = self.sltTxtField.convert(self.sltTxtField.bounds, to:self.view)
            frameFrmView.origin.y += (150.0 + self.sltTxtField.frame.size.height + 20)
            
            if(visibleRect.size.height <= frameFrmView.origin.y){
                 scrollPoint = CGPoint(x: 0.0, y: ((frameFrmScrollView.origin.y + frameFrmScrollView.size.height + 20) - visibleRect.size.height))
                self.scroll_View.setContentOffset(scrollPoint!, animated: true)
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 0.3 Time Delay
                self.openDropDownWhenKeyBordappere()
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.removeOptionalView()
        
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            let userInfo = notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            let frameFrmScrollView = self.sltTxtField.convert(self.sltTxtField.bounds, to:self.scroll_View)
            if(self.sltTxtField == self.txtField_Note || self.sltTxtField == self.txtField_Industry || self.sltTxtField == self.txtField_TinNo || self.sltTxtField == self.txtField_GSTNo || self.sltTxtField == self.txtField_Zip ){
                scrollPoint = CGPoint(x: 0.0, y: ( keyboardFrame.size.height + frameFrmScrollView.size.height))
                
                self.scroll_View.setContentOffset(scrollPoint!, animated: true)
            }else{
                self.scroll_View.setContentOffset( .zero, animated: true)

            }
        }
    }
    
    
        //=====================================
           // MARK:- Get getCategory List Service
           //=====================================
           
            func getCategoryList(){
       //        "limit ->LINIT
       //        index -> Index
       //        search ->Search [Category name]"//IndustryList
                   
                 
                   param.limit = "500"
                   param.index = "0"
                   param.search = ""
                   serverCommunicator(url: Service.getIndustryList, param: param.toDictionary) { (response, success) in
                       killLoader()
                       if(success){
                           let decoder = JSONDecoder()
                           if let decodedData = try? decoder.decode(AddClientTndstryResponse.self, from: response as! Data) {
                               
                               if decodedData.success == true{
                                //   print("\(decodedData)")
                                
                                  // self.CategoryList = decodedData.data as! [AddExpencee]
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
    
    
        //=====================================
          // MARK:- Get getReferenceList Type Service
          //=====================================
          
          func getReferenceList(){
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
              
              
             // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getIndustryList) as? String
              
              let param = Params()
            //  param.compId = getUserDetails()?.compId
              param.limit = "120"
              param.index = "0"
              param.search = ""
             // param.dateTime = lastRequestTime ?? ""
          
              serverCommunicator(url: Service.getReferenceList, param: param.toDictionary) { (response, success) in
                  if(success){
                      let decoder = JSONDecoder()
                      if let decodedData = try? decoder.decode(getReferenceListResponse.self, from: response as! Data) {

                          if decodedData.success == true{

                              //Request time will be update when data comes otherwise time won't be update
//                              UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getReferenceList)
                              DispatchQueue.main.async{
                                  self.savegetReferenceList(data: decodedData.data )
                             //   print(self.arrOfReferenceList.count)
                              }
                          }else{
                              //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                          }
                      }else{
                          ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                      }
                  }else{
                      //ShowError(message: "Please try again!", controller: windowController)
                  }
              }
          }
    
       //=====================================
       // MARK:- Get getIndustryList Type Service
       //=====================================
       
       func getIndustryList(){
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
           
           
           let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getIndustryList) as? String
           
           let param = Params()
           param.compId = getUserDetails()?.compId
           param.limit = "120"
           param.index = "0"
           param.search = ""
           param.dateTime = ""//currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
       
           serverCommunicator(url: Service.getIndustryList, param: param.toDictionary) { (response, success) in
               if(success){
                   let decoder = JSONDecoder()
                   if let decodedData = try? decoder.decode(AddClientTndstryResponse.self, from: response as! Data) {
                       
                       if decodedData.success == true{
                           
                           //Request time will be update when data comes otherwise time won't be update
                           UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getIndustryList)
                           DispatchQueue.main.async{
                               self.savegetIndustryList(data: decodedData.data )
                            
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
    //==============================
       // MARK:- Save data in DataBase
       //==============================
       func savegetIndustryList( data : [IndClientDetails]) -> Void {
           for jobs in data{
            let query = "industryId = '\(jobs.industryId)'"
               let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "IndustryList", query: query) as! [IndustryList]
               if isExist.count > 0 {
                   let existingJob = isExist[0]
                   existingJob.setValuesForKeys(jobs.toDictionary!)
                  // DatabaseClass.shared.saveEntity()
               }else{
                   let userJobs = DatabaseClass.shared.createEntity(entityName: "IndustryList")
                   userJobs?.setValuesForKeys(jobs.toDictionary!)
                  // DatabaseClass.shared.saveEntity()
               }
           }
           
            DatabaseClass.shared.saveEntity(callback: { _ in })
       }
          
    
    
    //==============================
    // MARK:- Save data in DataBase
    //==============================
    func savegetReferenceList( data : [getReferenceListDetails]) -> Void {
        for jobs in data{
            let query = "refId = '\(jobs.refId)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ReferenceList", query: query) as! [ReferenceList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                existingJob.setValuesForKeys(jobs.toDictionary!)
                // DatabaseClass.shared.saveEntity()
            }else{
                let userJobs = DatabaseClass.shared.createEntity(entityName: "ReferenceList")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
                // DatabaseClass.shared.saveEntity()
            }
        }

              DatabaseClass.shared.saveEntity(callback: { _ in })
         }
    
    func getCompanySettings(){
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
        
        
       // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getIndustryList) as? String
        
        let param = Params()
        //param.compId =
        param.compId = getUserDetails()?.compId
       
       // param.dateTime = lastRequestTime ?? ""
    
        serverCommunicator(url: Service.getCompanySettings, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(getCompanySettingsResponse.self, from: response as! Data) {

                    if decodedData.success == true{
                 
                      //  UserDefaults.standard.set(self.arrofcompenysetting, forKey: "getcompany")
                        DispatchQueue.main.async{
                            self.arrofcompenysetting = decodedData.data
                        
                           
                            self.txtField_City.text = "\(self.arrofcompenysetting.city ?? "")"
                            self.txtField_GSTNo.placeholder = "\(self.arrofcompenysetting.gstLabel ?? "")"
                            self.txtField_TinNo.placeholder = "\(self.arrofcompenysetting.tinLabel ?? "")"
                            
                            let  arrOfShowDataCntry = getJson(fileName: "countries")["countries"] as! [AnyObject]
                            for  countries  in arrOfShowDataCntry {
                                if ((countries as? [String : Any])?["id"] as? String) == self.arrofcompenysetting.ctry! {
                                    self.txtField_Country.text = "\(((countries as? [String : Any])?["name"] as? String ?? ""))"
                                }else{
                                  //  self.txtField_Country.text = "\((countries as AnyObject).text!)"
                                }

                            }
                            let arrofsatate = getJson(fileName: "states")["states"] as! [AnyObject]
                            for  states  in arrofsatate {
                                if  ((states as? [String : Any])?["id"] as? String) == self.arrofcompenysetting.state! {
                                   self.txtField_State.text = "\(((states as? [String : Any])?["name"] as? String ?? ""))"
                                }else{

                                }

                            }

                            
                            
                         // print(self.arrofcompenysetting.count)
                        }
                    }else{
                        //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
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

////////


                        
                        
                        //============================================================================
