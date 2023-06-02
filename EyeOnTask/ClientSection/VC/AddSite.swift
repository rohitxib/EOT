//
//  EditSiteVC.swift
//  EyeOnTask
//
//  Created by Apple on 04/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation


class AddSite: UIViewController , UITextFieldDelegate , OptionViewDelegate{
  
    @IBOutlet weak var BtnLatlng: UIButton!
    @IBOutlet weak var txtFld_Contact: FloatLabelTextField!
    //var objOFEditSiteVC : ClientSitList?
    var objOFClient : ClientList?

    var optionalVw : OptionalView?
    var sltDropDownTag : Int!
    let cellReuseIdentifier = "cell"
    var fltStateAccToCtrs = [Any]()
    var arrOfShowData = [Any]()
    let param = Params()
    var arrofcompenysetting =  getCompanySettingsDetails()
    @IBOutlet weak var contctdropdwn_Height: NSLayoutConstraint!
    @IBOutlet weak var contact_Height: NSLayoutConstraint!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var emailLbl_Height: NSLayoutConstraint!
    @IBOutlet weak var email_Hieght: NSLayoutConstraint!
    @IBOutlet weak var creatNewContactBtn: UIButton!
    @IBOutlet weak var existingBtn: UIButton!
    
    @IBOutlet weak var txtFld_Twitter: FloatLabelTextField!
    @IBOutlet weak var txtFld_Skype: FloatLabelTextField!
    
    @IBOutlet weak var txtFld_Fax: FloatLabelTextField!
    
    @IBOutlet weak var txtFld_AltContct: FloatLabelTextField!
    
    @IBOutlet weak var txtFld_MobileNo: FloatLabelTextField!
    @IBOutlet weak var txtFld_Email: FloatLabelTextField!
    @IBOutlet weak var txtFld_Name: FloatLabelTextField!
    @IBOutlet weak var H_lattitude: NSLayoutConstraint!
    @IBOutlet weak var H_longitude: NSLayoutConstraint!
    
    @IBOutlet var latitute: UITextField!
    @IBOutlet var longitute: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var btnDefault: UIButton!
    var arrOfctrs = [Any]()
    var sltTxtField = UITextField()
    var callbackForSiteVC: ((Bool,Bool) -> Void)?
    var adddName = Bool()
    var arrOfShow = [ClientContactList]()
    var arrOfShows = ClientContactList()
    var objOFAddSiteVc : ClientList?
    @IBOutlet var bgView_TxtFldCoty: UIView!
    
    @IBOutlet var bgView_TxtFldState: UIView!
    @IBOutlet var scroll_View: UIScrollView!
    @IBOutlet var txtField_SiteNm: UITextField!
    @IBOutlet var txtField_Country: UITextField!
    @IBOutlet var txtField_State: UITextField!
    @IBOutlet var txtField_City: UITextField!
    @IBOutlet var txtField_Addrs: UITextField!
    @IBOutlet var txtField_PostalCode: UITextField!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeOptionalView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCompanySettings()
        self.txtFld_Contact.isUserInteractionEnabled = false
        self.txtFld_Contact.text = "\(LanguageKey.self_key)"+" (\(LanguageKey.text_default))"
        param.conId = "13806"
        
        self.txtField_Country.text = "India"
        self.txtField_State.text = "Madhya Pradesh"
        self.txtField_City.text = "Indore"
        param.state = "21"
        param.ctry = "101"
        
        self.registorKeyboardNotification()
         getClintContectListFrmDB()
        if getDefaultSettings()?.isJobLatLngEnable == "0" {
            H_lattitude.constant = 0.0
            H_longitude.constant = 0.0
        }
       
//          self.contctdropdwn_Height.constant = 0
//          self.contact_Height.constant = 0
            self.adddName = true
            self.nameView.isHidden = true
            self.email_Hieght.constant = 0
            self.emailLbl_Height.constant = 0
            creatNewContactBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
            existingBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
            setLocalization()
        
        ActivityLog(module:Modules.site.rawValue , message: ActivityMessages.clientSiteAdd)

    }
    
   
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.add_site_screen_title
        txtField_SiteNm.placeholder = "\(LanguageKey.site_name) *"
        txtField_Country.placeholder = "\(LanguageKey.country) *"
        txtField_State.placeholder = "\(LanguageKey.state) *"
        txtField_City.placeholder = LanguageKey.city
        
        txtFld_Twitter.placeholder = LanguageKey.twitter
        txtFld_Skype.placeholder = LanguageKey.skype
        txtFld_Fax.placeholder = LanguageKey.fax
        txtFld_AltContct.placeholder = LanguageKey.alt_mobile_number
        txtFld_MobileNo.placeholder = LanguageKey.mob_no
        txtFld_Email.placeholder = LanguageKey.email
        txtFld_Name.placeholder = LanguageKey.cont_name
        txtFld_Contact.placeholder = LanguageKey.cont_name
        
        txtField_Addrs.placeholder = "\(LanguageKey.address) *"
        latitute.placeholder = LanguageKey.latitude
        longitute.placeholder = LanguageKey.longitued
        txtField_PostalCode.placeholder = LanguageKey.postal_code
        btnDefault.setTitle(LanguageKey.site_default_checkBox , for: .normal)
        btnSubmit.setTitle(LanguageKey.create_project , for: .normal)
        creatNewContactBtn.setTitle("  \(LanguageKey.create_new_contact)" , for: .normal)
        existingBtn.setTitle("  \(LanguageKey.existing)" , for: .normal)
        BtnLatlng.setTitle(LanguageKey.get_current_lat_long , for: .normal)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
     self.registorKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.navigationBar.topItem?.title = "";
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
    
    
    
    func filterStateAccrdToCountry(serchCourID : String, searchPredicate : String , arr : [Any])-> [Any]{
        let bPredicate: NSPredicate = NSPredicate(format:"self.%@ == %@", searchPredicate ,serchCourID )
        return (arr as NSArray).filtered(using: bPredicate)
        
    }

    func getCountry() -> NSArray {
        return getJson(fileName: "countries")["countries"] as! NSArray
    }
    
    func getStates() -> NSArray {
        return getJson(fileName: "states")["states"] as! NSArray
    }
    @IBAction func creatNewCntcBtn_Action(_ sender: Any) {
        
        
  
        if creatNewContactBtn.imageView?.image == UIImage.init(named: "radio-selected") {
          
                creatNewContactBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
            }else{
            
                creatNewContactBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
            }
       
    }
    
    @IBAction func existingBtn_Actn(_ sender: UIButton) {
        
        
        let tag = sender.tag
              
              switch tag {
              case 0:
                param.isAddContact = "0"
                self.adddName = true
                 // self.txtFld_Contact.text = ""
//                self.contctdropdwn_Height.constant = 0
//                self.contact_Height.constant = 0
                  self.email_Hieght.constant = 0
                  self.emailLbl_Height.constant = 0
                  self.nameView.isHidden = true
                  self.contactView.isHidden = false
                  creatNewContactBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                  existingBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                  break
              default:
               // param.conId = arrOfShow.
                 param.isAddContact = "1"
                   self.adddName = false
                  self.nameView.isHidden = false
                  self.contactView.isHidden = true
                  self.email_Hieght.constant = 70
                  self.emailLbl_Height.constant = 70
                  
                  existingBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                  creatNewContactBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                  break
              }
//        if existingBtn.imageView?.image == UIImage.init(named: "radio-selected") {
//                existingBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
//            }else{
//                existingBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
//            }
        
    }
    
    @IBAction func dropDownBtnAction(_ sender: UIButton) {
        self.sltDropDownTag = sender.tag
        switch  sender.tag {
      
        case 1:
            if(self.optionalVw == nil){
                //  self.reradJson()
                arrOfShowData = getJson(fileName: "countries")["countries"] as! [Any]
                self.openDwopDown( txtField: self.txtField_Country, arr: arrOfShowData)
                
            }else{
                self.removeOptionalView()
            }
            
            break
        case 2:
            if(self.optionalVw == nil){
                
                self.removeOptionalView()
                let namepredicate: NSPredicate = NSPredicate(format:"self.name == %@", self.txtField_Country.text! )
                let arr = getCountry().filtered(using: namepredicate)
                if(arr.count > 0){
                    let dict = (arr[0] as? [String : Any])
                    let serchCourID = dict?["id"]
                    let bPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                    arrOfShowData =  getStates().filtered(using: bPredicate)
                    self.openDwopDown( txtField: self.txtField_State, arr: arrOfShowData)
                }
                
                //self.openDwopDown(txtField: self.txtField_State, arr: arrOfstatesAccToCountry)
                
            }else{
                self.removeOptionalView()
                
            }
            break
            
        case 3:
            if(self.optionalVw == nil){
                //  self.reradJson()
                
                         // self.arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: nil) as! [ClientContactList]
                           self.openDwopDown( txtField: txtFld_Contact, arr: arrOfShow )
//                arrOfShowData = getJson(fileName: "countries")["countries"] as! [Any]
//                self.openDwopDown( txtField: self.txtField_Country, arr: arrOfShowData)
                
            }else{
                self.removeOptionalView()
            }
            
            break
        default:
            break
        }
    }
    
  

    @IBAction func updateBtnAction(_ sender: Any) {
        
        if adddName == false {
            //For Country
                   let namepredicateOfCtr: NSPredicate = NSPredicate(format:"self.name == %@", self.txtField_Country.text! )
                   let arrOfCountry = getCountry().filtered(using: namepredicateOfCtr)
                   if(arrOfCountry.count > 0){
                       let dict = (arrOfCountry[0] as? [String : Any])
                      param.ctry = dict!["id"] as! String
                   }else{
                       param.ctry = ""
                   }
                   
                   //For state
                   let namepredicate: NSPredicate = NSPredicate(format:"self.name == %@", self.txtField_State.text! )
                   let arr = getStates().filtered(using: namepredicate)
                   if(arr.count > 0){
                       let dict = (arr[0] as? [String : String])
                       param.state = dict!["id"]
                   }else{
                       param.state = ""
                   }
                   
                   
                   let siteName = txtField_SiteNm.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                      if siteName?.lowercased() == "self"{
                          let mess = AlertMessage.do_not_use_this_name
                          let newString = mess.replacingOccurrences(of: EOT_VAR, with: "'\(txtField_SiteNm.text!)'")
                          ShowError(message: newString, controller: windowController)
                          return
                      }
                   
               
                   if(txtField_SiteNm.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                        if(txtFld_Name.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                       if param.ctry != "" {
                           if param.state != "" {
                              // if txtField_City.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                                   if txtField_Addrs.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                                       self.addClintSite_name()
                                   }else{
                                       ShowError(message: AlertMessage.validAddress, controller: windowController)
                                   }
                               //}else{
                                //   ShowError(message: AlertMessage.city, controller: windowController)
                              // }
                           }else{
                               ShowError(message: AlertMessage.validState, controller: windowController)
                           }
                       }else{
                           ShowError(message: AlertMessage.validCountry, controller: windowController)
                       }
                   }else{
                            ShowError(message: "Name", controller: windowController)
                        }
                   }else{
                        ShowError(message: AlertMessage.siteName, controller: windowController)
                    }
                   
        }else{
            //For Country
                   let namepredicateOfCtr: NSPredicate = NSPredicate(format:"self.name == %@", self.txtField_Country.text! )
                   let arrOfCountry = getCountry().filtered(using: namepredicateOfCtr)
                   if(arrOfCountry.count > 0){
                       let dict = (arrOfCountry[0] as? [String : Any])
                    param.ctry = dict?["id"] as? String
                   }else{
                       param.ctry = ""
                   }
                   
                   //For state
                   let namepredicate: NSPredicate = NSPredicate(format:"self.name == %@", self.txtField_State.text! )
                   let arr = getStates().filtered(using: namepredicate)
                   if(arr.count > 0){
                       let dict = (arr[0] as? [String : Any])
                    param.state = dict?["id"] as? String
                   }else{
                       param.state = ""
                   }
                   
                   
                   let siteName = txtField_SiteNm.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                      if siteName?.lowercased() == "self"{
                          let mess = AlertMessage.do_not_use_this_name
                          let newString = mess.replacingOccurrences(of: EOT_VAR, with: "'\(txtField_SiteNm.text!)'")
                          ShowError(message: newString, controller: windowController)
                          return
                      }
                   
               
                   if(txtField_SiteNm.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                    
                       if param.ctry != "" {
                           if param.state != "" {
                              // if txtField_City.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                                   if txtField_Addrs.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                                       self.addClintSite()
                                   }else{
                                       ShowError(message: AlertMessage.validAddress, controller: windowController)
                                   }
                               //}else{
                                //   ShowError(message: AlertMessage.city, controller: windowController)
                              // }
                           }else{
                               ShowError(message: AlertMessage.validState, controller: windowController)
                           }
                       }else{
                           ShowError(message: AlertMessage.validCountry, controller: windowController)
                       }
                  
                   }else{
                        ShowError(message: AlertMessage.siteName, controller: windowController)
                    }
                   
            
        }
        
       
    }
    
    //=====================================
    // MARK:- Option view Detegate
    //=====================================
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if (sltDropDownTag == 0) {
                    return arrOfShowData.count
                 }
                 else if (sltDropDownTag == 1) {
                    return arrOfShowData.count
                 }
                 else if (sltDropDownTag == 2) {
                       return arrOfShowData.count
                 }
              
                 else if (sltDropDownTag == 3) {
                    return arrOfShow.count
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
       // cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
        cell?.textLabel?.textColor = UIColor.darkGray

        switch self.sltDropDownTag {
            
            
        case 1:
              cell?.textLabel?.text =  ((arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
            break
        case 2:
            cell?.textLabel?.text =  ((arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()
            break
        case 3:
                let contact = self.arrOfShow[indexPath.row]
                if contact.def == "1" {
                                cell?.textLabel?.text = (contact.cnm?.capitalizingFirstLetter())! + " (Default)"
                  }else{
                           cell?.textLabel?.text = contact.cnm?.capitalizingFirstLetter()
                 }
             break
        default: break
            
        }
        return cell!
        
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.sltDropDownTag {
      
        case 1:
         
            self.txtField_Country.text = (arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String
            let countryID = (arrOfShowData[indexPath.row] as? [String : Any])?["id"] as? String
            param.ctry = countryID
            let idPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", countryID! )
            let arrOfstate =  getStates().filtered(using: idPredicate)
            self.txtField_State.text = (arrOfstate[0] as? [String : Any])?["name"] as? String
            param.state = (arrOfstate[0] as? [String : Any])?["id"] as? String
            self.removeOptionalView()
            break
        case 2:
            self.txtField_State.text =  (arrOfShowData[indexPath.row] as? [String : Any])?["name"] as? String
            param.state = (arrOfShowData[indexPath.row] as? [String : Any])?["id"] as? String
            self.removeOptionalView()
            break
            
        case 3:
            self.txtFld_Contact.text = arrOfShow[indexPath.row].cnm
            param.conId = arrOfShow[indexPath.row].conId
            self.removeOptionalView()

            break
        default:
            break
        }
    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0

    }
    

    
    func getDataAccToPriviousStrings(textField: UITextField){
        if(self.optionalVw == nil && (textField == self.txtField_Country)){
            if((self.txtField_Country.text?.trimmingCharacters(in: .whitespacesAndNewlines)) != ""){
                self.arrOfShowData = filterArrUsingpredicate(txtFid: self.txtField_Country, txt: self.txtField_Country.text!, range: nil, arr: APP_Delegate.arrOfctrs , predecateIdentity: "name")
                self.openDwopDown( txtField: self.txtField_Country, arr: self.arrOfShowData)
            }else{
                self.openDwopDown( txtField: self.txtField_Country, arr: APP_Delegate.arrOfctrs)
            }
        }else if (self.optionalVw == nil && textField == self.txtField_State){
            self.fltStateAccToCtrs =  self.filterStateAccrdToCountry(serchCourID: param.ctry!)
            self.arrOfShowData = filterArrUsingpredicate(txtFid: self.txtField_State, txt: self.txtField_State.text!, range: nil, arr: self.fltStateAccToCtrs , predecateIdentity: "name")
            self.openDwopDown( txtField: self.txtField_State, arr: self.arrOfShowData)
        }else{
            self.removeOptionalView()
        }
    }

    
//=====================================
// MARK:- TxtField Detegate
//=====================================
    
    func openDropDownWhenKeyBordappere(){
        if self.sltTxtField.isEqual(txtField_Country) {
            self.removeOptionalView()
            arrOfShowData = getJson(fileName: "countries")["countries"] as! [Any]
            self.openDwopDown( txtField: self.txtField_Country, arr: arrOfShowData)
            
            
        }else if self.sltTxtField.isEqual(txtField_State){
            self.removeOptionalView()
            let namepredicate: NSPredicate = NSPredicate(format:"self.name == %@", self.txtField_Country.text! )
            let arr = getCountry().filtered(using: namepredicate)
            if(arr.count > 0){
                let dict = (arr[0] as? [String : Any])
                let serchCourID = dict?["id"]
                let bPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                arrOfShowData =  getStates().filtered(using: bPredicate)
                self.openDwopDown( txtField: self.txtField_State, arr: arrOfShowData)
            }
        }
        else{
            self.removeOptionalView()
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sltTxtField = textField
        self.sltDropDownTag = textField.tag
        
        if self.sltTxtField.isEqual(txtField_Country) {
            txtField_Country.text = ""
         }else if self.sltTxtField.isEqual(txtField_State){
            txtField_State.text = ""
        }
        
      
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        
        if (textField == txtField_PostalCode) {
                         
                         if (string != "") && (textField.text?.count)! > 7 {
                             return false
                         }
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
        case 1:
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
            
        case 2:
            
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
        case 3:
            
            if(self.optionalVw == nil){
                    self.arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: nil) as! [ClientContactList]
                    self.openDwopDown( txtField: txtField_Country, arr: arrOfShowData)
                    }
            break
        default:
            break
        }
        
    
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if(textField == self.txtField_Country){
            self.txtField_State.text = ""
        }
        
     return true
    }

    
    func removeOptionalView(){
        if optionalVw != nil {
            self.optionalVw?.removeFromSuperview()
            self.optionalVw = nil
            self.scroll_View.isScrollEnabled = true
            self.arrOfShowData.removeAll()
        }
    }
    
    func filterArrUsingpredicate(txtFid : UITextField? , txt : String , range : NSRange? , arr : [Any] , predecateIdentity : String) -> [Any]{
        let predicateStr: NSString;
        if(txtFid != nil && range != nil){
            predicateStr =
                (txtFid!.text as NSString?)!.replacingCharacters(in: range!, with: txt) as NSString
        }else{
            predicateStr = txt as NSString
        }
        
        let bPredicate: NSPredicate = NSPredicate(format: "self.%@ beginswith[c] %@", predecateIdentity ,predicateStr)
        
        return (arr as NSArray).filtered(using: bPredicate)
    }
    
    
    func filterStateAccrdToCountry(serchCourID : String)-> [Any]{
        
        let bPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID )
        return (APP_Delegate.arrOfstates as NSArray).filtered(using: bPredicate)
        
    }
    
    //==================================
    //MARK:- callmethod OpenDwopDown
    //===============================
    func callMethodforOpenDwop(tag : Int) {
        switch tag {
        case 1:
            self.openDwopDown( txtField: self.txtField_Country, arr: self.arrOfShowData.count == 0 ? APP_Delegate.arrOfctrs : self.arrOfShowData)
            break
        case 2:
            self.openDwopDown( txtField: self.txtField_State, arr: arrOfShowData.count == 0 ? self.fltStateAccToCtrs : arrOfShowData)
            break
 
        default:
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
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height ), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            //self.scroll_View.isScrollEnabled = false
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
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height ), width: self.view.frame.size.width - 20, height: 100))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            //self.scroll_View.isScrollEnabled = false
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
    
    
    
    
    func getTempIdForNewSite(newId : Int) -> String {
        
        return "Site-\(String(describing: getUserDetails()?.usrId ?? ""))-\(getCurrentTimeStamp())"
//        let searchQuery = "siteId = 'Site-\(newId)'"
//        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: searchQuery) as! [ClientSitList]
//        if isExist.count == 0 {
//            return "Site-\(newId)"
//        }else{
//            return getTempIdForNewSite(newId: newId + 1)
//        }
    }

    //=====================================
    // MARK:- Get Contact List  Service
    //=====================================
    
    
      func addClintSite_name(){
            /*
             cltId -> client id
             snm -> site name
             adr -> address
             city -> city
             state -> state
             ctry -> country
             zip -> zipcode
             def -> 1 - YES and 0 - NO
             */
    //        var adr: String?
    //        var city: String?
    //        var ctry: String?
    //        var lat: String?
    //        var lng: String?
    //        var siteId: String?
    //        var snm: String?
    //        var state: String?
    //        var zip: String?
    //        var cltId : String?
          //  let results = objOFClient?.conId
                  // var querys = ""
                   //if results != "" && results != nil{
                      // querys = "conId = '\(results!)'"
            let arrOfObjs = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: nil) as! [ClientContactList]
        param.conId = arrOfObjs[0].conId ?? ""
            
            let temp =  getTempIdForNewSite(newId: 0)
            param.tempId = temp
            param.siteId = temp
            param.cltId = objOFClient?.cltId
            param.snm = txtField_SiteNm.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            param.adr = txtField_Addrs.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            param.city = txtField_City.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            param.zip = txtField_PostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            param.lat = trimString(string: latitute.text!)
            param.lng = trimString(string: longitute.text!)
            param.def = btnDefault.imageView?.image == UIImage.init(named: "BoxOFCheck") ? "1" : "0"
             param.cnm =  txtFld_Name.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            // param.conId = arrOfShows.cltId //txtFld_Contact.text?.trimmingCharacters(in: .whitespacesAndNewlines)
             param.email = txtFld_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
             param.mob1 = txtFld_MobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
             param.mob2 = txtFld_AltContct.text?.trimmingCharacters(in: .whitespacesAndNewlines)
             param.fax = txtFld_Fax.text?.trimmingCharacters(in: .whitespacesAndNewlines)
             param.twitter = txtFld_Twitter.text?.trimmingCharacters(in: .whitespacesAndNewlines)
             param.skype = txtFld_Skype.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
                userJobs?.setValuesForKeys(param.toDictionary!)
            
            
            //if user selected default contact, Change all contact are non-default and current is defualt,
            var isDefault = Bool()
            if param.def == "1"{
                
                //Change Address for client list for default
                objOFClient?.adr = param.adr
                isDefault = true
            }
            
            //Database save
            DatabaseClass.shared.saveEntity(callback: { _ in
                if self.callbackForSiteVC != nil {
                    self.callbackForSiteVC!(true,isDefault)
                }
                
                
                param.tempId = param.siteId
                param.compId = getUserDetails()?.compId
                
                showToast(message: AlertMessage.siteAdd) //Alert message
                
                DatabaseClass.shared.saveOffline(service: Service.addClientSite, param: param)
                self.navigationController?.popViewController(animated: true)
            })
        }
    func addClintSite(){
        /*
         cltId -> client id
         snm -> site name
         adr -> address
         city -> city
         state -> state
         ctry -> country
         zip -> zipcode
         def -> 1 - YES and 0 - NO
         */
//        var adr: String?
//        var city: String?
//        var ctry: String?
//        var lat: String?
//        var lng: String?
//        var siteId: String?
//        var snm: String?
//        var state: String?
//        var zip: String?
//        var cltId : String?
        
        
        let temp =  getTempIdForNewSite(newId: 0)
        param.tempId = temp
        param.siteId = temp
        param.cltId = objOFClient?.cltId
        param.snm = txtField_SiteNm.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.adr = txtField_Addrs.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.city = txtField_City.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.zip = txtField_PostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.lat = trimString(string: latitute.text!)
        param.lng = trimString(string: longitute.text!)
        param.def = btnDefault.imageView?.image == UIImage.init(named: "BoxOFCheck") ? "1" : "0"
        // param.cnm =  txtFld_Name.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.cnm =  txtFld_Contact.text?.trimmingCharacters(in: .whitespacesAndNewlines)
         param.email = txtFld_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
         param.mob1 = txtFld_MobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
         param.mob2 = txtFld_AltContct.text?.trimmingCharacters(in: .whitespacesAndNewlines)
         param.fax = txtFld_Fax.text?.trimmingCharacters(in: .whitespacesAndNewlines)
         param.twitter = txtFld_Twitter.text?.trimmingCharacters(in: .whitespacesAndNewlines)
         param.skype = txtFld_Skype.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
            userJobs?.setValuesForKeys(param.toDictionary!)
        
        
        //if user selected default contact, Change all contact are non-default and current is defualt,
        var isDefault = Bool()
        if param.def == "1"{
            
            //Change Address for client list for default
            objOFClient?.adr = param.adr
            isDefault = true
        }
        
        //Database save
        DatabaseClass.shared.saveEntity(callback: { _ in
            if self.callbackForSiteVC != nil {
                self.callbackForSiteVC!(true,isDefault)
            }
            
            
            param.tempId = param.siteId
            param.compId = getUserDetails()?.compId
            
            showToast(message: AlertMessage.siteAdd) //Alert message
            
            DatabaseClass.shared.saveOffline(service: Service.addClientSite, param: param)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    //========================================
    //MARK:-  Stop Copy Paste of Numbers Filed
    //========================================
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if txtField_PostalCode.isFirstResponder {
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
            var frameFrmScrollView : CGRect?
            var frameFrmView : CGRect?
            
            if self.sltTxtField.isEqual(txtField_Country) {
                
                frameFrmScrollView = self.bgView_TxtFldCoty.convert(self.bgView_TxtFldCoty.bounds, to:self.scroll_View)
                frameFrmScrollView?.origin.y += 150.0  // 150 DropDown Height
                
                frameFrmView = self.bgView_TxtFldCoty.convert(self.bgView_TxtFldCoty.bounds, to:self.view)
                frameFrmView?.origin.y += (150.0 + self.bgView_TxtFldCoty.frame.size.height)
            }else if self.sltTxtField.isEqual(txtField_State){
                frameFrmScrollView = self.bgView_TxtFldState.convert(self.bgView_TxtFldState.bounds, to:self.scroll_View)
                frameFrmScrollView?.origin.y += 150.0  // 150 DropDown Height
                
                frameFrmView = self.bgView_TxtFldState.convert(self.bgView_TxtFldState.bounds, to:self.view)
                frameFrmView?.origin.y += (150.0 + self.bgView_TxtFldState.frame.size.height )
            }else{
                frameFrmScrollView = self.sltTxtField.convert(self.sltTxtField.bounds, to:self.scroll_View)
         frameFrmScrollView?.origin.y += 50
                frameFrmView = self.sltTxtField.convert(self.sltTxtField.bounds, to:self.view)
                frameFrmView?.origin.y += (self.sltTxtField.frame.size.height + 50)
            }
            
            
            if(visibleRect.size.height <= (frameFrmView?.origin.y)!){
                let scrollPoint = CGPoint(x: 0.0, y: (((frameFrmScrollView?.origin.y)! + (frameFrmScrollView?.size.height)!) - visibleRect.size.height))
                self.scroll_View.setContentOffset(scrollPoint, animated: true)
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 0.3 Time Delay
                self.openDropDownWhenKeyBordappere()
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.removeOptionalView()
        self.scroll_View.setContentOffset(.zero, animated: true)
    }
    
    @IBAction func btnDefaultPressed(_ sender: Any) {
        
        if btnDefault.imageView?.image == UIImage.init(named: "BoxOFCheck") {
            btnDefault.setImage(UIImage(named:"BoxOFUncheck"), for: .normal)
        }else{
            btnDefault.setImage(UIImage(named:"BoxOFCheck"), for: .normal)
        }
    }
    
    
    /////////////////
    
    //=======================
       // MARK:- Other methods
       //=======================
       func getClintContectListFrmDB() -> Void {
        
        // if isAdded {
               showDataOnTableView(query: nil)
          // }
//
//           if isChanged {
               getClientContactSink()
//           }
//
//           isChanged = true
//           isAdded = false
       }
       
       func showDataOnTableView(query : String?) -> Void {
           arrOfShow = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query == nil ? NSString(format:"cltId == '%@'", (objOFClient?.cltId)!) as String : query) as! [ClientContactList]
             //   arrOfShows =  DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query == nil ? NSString(format:"cltId == '%@'", (objOFClient?.cltId)!) as String : query) as! ClientContactList
           
           if arrOfShow.count != 0 {
               arrOfShow =  arrOfShow.sorted { $0.cnm?.localizedCaseInsensitiveCompare($1.cnm!) == ComparisonResult.orderedAscending }
               DispatchQueue.main.async {
                  // self.tableview.reloadData()
               }
           }

           DispatchQueue.main.async {
             //  self.table_view.isHidden = self.arrOfShow.count > 0 ? false : true
           }
       }
       
       //=====================================
          // MARK:- Get Contact List  Service
          //=====================================
          
          func getClientContactSink(){
              
//              if !isHaveNetowork() {
//                  if self.refreshControl.isRefreshing {
//                      self.refreshControl.endRefreshing()
//                  }
//                  return
//              }
              let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientContactSink) as? String

              let param = Params()
              param.compId = getUserDetails()?.compId
              param.limit = "120"
              param.index = "0"
              param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
          
              serverCommunicator(url: Service.getClientContactSink, param: param.toDictionary) { (response, success) in
                  if(success){
                      let decoder = JSONDecoder()
                      
//                      DispatchQueue.main.async {
//                          if self.refreshControl.isRefreshing {
//                              self.refreshControl.endRefreshing()
//                          }
//                      }
//
                      if let decodedData = try? decoder.decode(ContactResps.self, from: response as! Data) {
                          
                          if decodedData.success == true{
                             
                              if decodedData.data.count > 0 {
                                  //Request time will be update when data comes otherwise time won't be update
                                  UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientContactSink)
                                //  self.saveUserJobsInDataBase(data: decodedData.data)
                              }else{
                                  if self.arrOfShowData.count == 0{
                                      DispatchQueue.main.async {
                                          //self.table_view.isHidden = true
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
                          //  self.txtField_Country.text = "\(self.arrofcompenysetting.ctry ?? "")"
                           // self.txtField_State.text = "\(self.arrofcompenysetting.state ?? "")"
                            let  arrOfShowDataCntry = getJson(fileName: "countries")["countries"] as! [AnyObject]
                            for  countries  in arrOfShowDataCntry {
                                if ((countries as? [String : Any])?["id"] as? String) == self.arrofcompenysetting.ctry! {
                                    self.txtField_Country.text = "\(((countries as? [String : Any])?["name"] as? String ?? ""))"
                                    param.ctry = self.arrofcompenysetting.ctry!
                                }else{
                                  //  self.txtField_Country.text = "\((countries as AnyObject).text!)"
                                }

                            }
                            let arrofsatate = getJson(fileName: "states")["states"] as! [AnyObject]
                            for  states  in arrofsatate {
                                if  ((states as? [String : Any])?["id"] as? String) == self.arrofcompenysetting.state! {
                                   self.txtField_State.text = "\(((states as? [String : Any])?["name"] as? String ?? ""))"
                                    param.state = self.arrofcompenysetting.state!
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
