//
//  EditContactVC.swift
//  EyeOnTask
//
//  Created by Apple on 14/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//
import CoreData

import UIKit
import IQKeyboardManagerSwift

class AddContact: UIViewController , UITextFieldDelegate,OptionViewDelegate {
    var objOFClient : ClientList?
       var sltIdex : Int?
    
    
    
    @IBOutlet weak var txtFld_Notes: FloatLabelTextField!
    @IBOutlet weak var fieldOne: FloatLabelTextField!
    @IBOutlet weak var fieldTwo: FloatLabelTextField!
    @IBOutlet weak var fieldThree: FloatLabelTextField!
    @IBOutlet weak var fieldFour: FloatLabelTextField!
    
    
    
    @IBOutlet weak var linksite: UILabel!
    @IBOutlet weak var txtField_LinkSite: UITextField!
   
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet var txtField_Name: UITextField!
    @IBOutlet var txtField_Email: UITextField!
    @IBOutlet var txtField_mobNo: UITextField!
    @IBOutlet var txtField_AltMobNo: UITextField!
    @IBOutlet var txtField_Fax: UITextField!
    @IBOutlet var txtField_Skype: UITextField!
    @IBOutlet var txtField_Twitter: UITextField!
    
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var scrollVw: UIScrollView!
    var callbackForContactVC: ((Bool,Bool) -> Void)?
    
    
    
     var arrOfShow = [ClientSitList]()
   // var arrOfShowData = [ClientList]()
       let param = Params()
    let paramsContect = ParamsContect()
    let cellReuseIdentifier = "cell"
    var optionalVw : OptionalView?
    var arrOfShowData = [Any]()
    let arr = ["1","2","3","4","5",]
     var selectedRows:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let conExtraField1Label = getDefaultSettings()?.conExtraField1Label
        let conExtraField2Label = getDefaultSettings()?.conExtraField2Label
        let conExtraField3Label = getDefaultSettings()?.conExtraField3Label
        let conExtraField4Label = getDefaultSettings()?.conExtraField4Label
        
        if conExtraField1Label != "" {
            fieldOne.placeholder = conExtraField1Label
        }else{
            fieldOne.placeholder =  LanguageKey.extra_feild_1
        }
        if conExtraField2Label != "" {
            fieldTwo.placeholder = conExtraField2Label
        }else{
            fieldTwo.placeholder =  LanguageKey.extra_feild_2
        }
        if conExtraField3Label != "" {
            fieldThree.placeholder = conExtraField3Label
        }else{
            fieldThree.placeholder =  LanguageKey.extra_feild_3
        }
        if conExtraField4Label != "" {
            fieldFour.placeholder = conExtraField4Label
        }else{
            fieldFour.placeholder =  LanguageKey.extra_feild_4
        }
        
            getClintSitListFrmDB()
            if Constants.kIphone_5 || Constants.kIphone_4s {
                self.scrollVw.isScrollEnabled = true
            }
            setLocalization()
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.add_contacts_screen_title
        txtFld_Notes.placeholder = "\(LanguageKey.notes)"
        txtField_Name.placeholder = "\(LanguageKey.contact_name) *"
        txtField_Email.placeholder = "\(LanguageKey.email) *"
        txtField_mobNo.placeholder = "\(LanguageKey.mob_no) *"
        txtField_AltMobNo.placeholder = LanguageKey.alt_mobile_number
        txtField_Fax.placeholder = LanguageKey.fax
        txtField_Skype.placeholder = LanguageKey.skype
        txtField_Twitter.placeholder = LanguageKey.twitter
        linksite.text = "\(LanguageKey.select_site)"
        txtField_LinkSite.placeholder = "\(LanguageKey.link_site)"
        btnDefault.setTitle(LanguageKey.default_contact , for: .normal)
        btnSubmit.setTitle(LanguageKey.create_contact , for: .normal)
        
        ActivityLog(module:Modules.contact.rawValue , message: ActivityMessages.clientContactAdd)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.navigationBar.topItem?.title = "";
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == txtField_mobNo) || (textField == txtField_AltMobNo){
            if (string != "") && (textField.text?.count)! > 14 {
                return false
            }
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }

    @IBAction func linkSite(_ sender: Any) {
        
       // if(param.cltId != nil){

//                              arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: nil) as! [ClientSitList]
                        self.openDwopDown( txtField: self.txtField_LinkSite, arr: arrOfShow)
                         //  }else{
              //  self.removeOptionalView()
                      //  }
        
        
    }
    
    @IBAction func updateBtnAction(_ sender: Any) {
//        let siteName = txtField_Name.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//        if siteName?.lowercased() == "self"{
//            let mess = AlertMessage.do_not_use_this_name
//            let newString = mess.replacingOccurrences(of: EOT_VAR, with: "'\(txtField_Name.text!)'")
//            ShowError(message: newString, controller: windowController)
//            return
//        }
               
               
        
        let trimmMobNo = trimString(string: self.txtField_mobNo.text!)
         let trimmAltMobNo = trimString(string: self.txtField_AltMobNo.text!)
         
         if (trimmMobNo.count > 0) && (trimmMobNo.count < 8) {
             ShowError(message: AlertMessage.validMobile, controller: windowController)
                 return
             }
         
         
         if trimmAltMobNo.count > 0 && trimmAltMobNo.count < 8  {
             ShowError(message: AlertMessage.validAlMobileNo, controller: windowController)
                 return
             }
        
        
        
        if(txtField_Name.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
            if isValidEmail(testStr: txtField_Email.text!) {
                if (txtField_mobNo.text!.count >= 8){
                    self.addUserContact()
                }else{
                    ShowError(message: AlertMessage.validMobileNo , controller: windowController)
                }
            }else{
                ShowError(message: AlertMessage.enterValidEmail, controller: windowController)
            }
        }else{
            ShowError(message: AlertMessage.enterClientName, controller: windowController)
        }
    }
    
    func getTempIdForNewContact(newId : Int) -> String {
        
        return "Contact-\(String(describing: getUserDetails()?.usrId ?? ""))-\(getCurrentTimeStamp())"
        
//        let searchQuery = "conId = 'Con-\(newId)'"
//        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: searchQuery) as! [ClientContactList]
//        if isExist.count == 0 {
//            return "Con-\(newId)"
//        }else{
//            return getTempIdForNewContact(newId: newId + 1)
//        }
    }
    
    // MARK:- Optional view Detegate
       
         func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
             return 50.0
         }
         
         func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return arrOfShow.count
             
         }
         
          func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
                  if(cell == nil){
                      cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
                  }
                  
                  cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
                  cell?.backgroundColor = .clear
                  cell?.textLabel?.textColor = UIColor.darkGray
                 
            
                    let cltAllSiteList  =  arrOfShow[indexPath.row]
                // =  param.siteId?.contains{ ( arry : siteIdParam) -> Bool in
            if let idS = paramsContect.siteId {
                if (idS.contains(cltAllSiteList.siteId!)) {
                                            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                                            //return true
                                        }else{
                                            cell?.accessoryType = UITableViewCell.AccessoryType.none
                                            //return false
                                        }
            }
         
                      // }
            

            
            if cltAllSiteList.def == "1" {
                     cell?.textLabel?.text  = (cltAllSiteList.snm?.capitalizingFirstLetter())! + " (Default)"
                  }else{
                      cell?.textLabel?.text = cltAllSiteList.snm?.capitalizingFirstLetter()
                  }
                   //  cell?.textLabel?.text = cltAllSiteList.snm?.capitalizingFirstLetter()
                   return cell!
             
         }
         
         
         func optionView(_ OptiontableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            var ar = arrOfShow[indexPath.row].siteId
            if paramsContect.siteId == nil {
                           paramsContect.siteId = [String]()
                       }

//                       let jt = ParamsContect()
//                       jt.siteId = ar?.siteId
//                       jt.title = ar?.title

//                       let isExist =  paramsContect.siteId?.contains{ ( arry : siteIdParam) -> Bool in
//                           if arry.jtId == jt.siteId{
//                               return true
//                           }
//                           return false
//                       }
            if (paramsContect.siteId?.contains(ar!))!{
                if let index = paramsContect.siteId!.firstIndex(of: ar!) {
                    paramsContect.siteId?.remove(at: index)
                }
            }else{
                paramsContect.siteId?.append(ar!)
            }

//                       if !isExist!{
//                            param.siteId?.append(jt)
//                       }else{
//                           let objIndex : Int? = param.jtId?.firstIndex(where: { (jtData : siteIdParam) -> Bool in
//                               if jt.siteId == jtData.siteId{
//                                   return true
//                               }else{
//                                   return false
//                               }
//                           })
//                           if (objIndex != nil){
//                               param.siteId?.remove(at: objIndex!)
//                           }
//                       }
//
//                       if (paramsContect.siteId != nil && paramsContect.siteId!.count > 0) {
//
//                           var strTitle = ""
//                           for jtid in paramsContect.siteId! {
//                               if strTitle == ""{
//                                   strTitle = siteId.title ?? ""
//                               }else{
//                                   strTitle = "\(strTitle), \(siteId.title ?? "")"
//
//                               }
//                               DispatchQueue.main.async {
//                                   self.txtField_LinkSite.text = strTitle
//                               }
//
//                           }
//                       }else{
//                           self.txtField_LinkSite.text = ""
//                       }
            
//               self.txtField_LinkSite.text = arr[indexPath.row]
//
//                  let cltAllSieList  =  arrOfShowData[indexPath.row] as? ClientSitList
//                  self.txtField_LinkSite.text = cltAllSieList?.snm
             var strTitle = ""
            for dic in arrOfShow {
                if (paramsContect.siteId?.contains(dic.siteId!))!{
                    
                    if strTitle == ""{
                                                       strTitle = dic.snm ?? ""
                                                   }else{
                                                       strTitle = "\(strTitle), \(dic.snm ?? "")"
                    
                                                   }
                                                   DispatchQueue.main.async {
                                                       self.txtField_LinkSite.text = strTitle
                                                   }
                    
                }
            }
            
           // self.txtField_LinkSite.text  = arrOfShow[indexPath.row].snm
                // paramsContect.siteId = arrOfShow[indexPath.row].siteId
                 paramsContect.snm = self.txtField_LinkSite.text
               
                  self.removeOptionalView()
         }
       
    
    
    //================================
    // MARK:- Optional view Detegate
    //================================
    
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

       func openDwopDownForConstactHeight(txtField : UITextField , arr : [Any]) {
             
             if (optionalVw == nil){
                 self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
                 let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
                 self.optionalVw?.setUpMethod(frame: CGRect(x:10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height ), width: self.view.frame.size.width - 20, height: 100))
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
    // MARK:- Get Contact List  Service
    //=====================================
    
    func addUserContact(){
        /*
         cltId -> client id
         cnm -> contact name
         email -> email
         mob1 -> mobile no-1
         mob2 -> mobile no- 2
         fax -> fax number
         twitter -> twitter id
         skype -> skype id
         */

        let param = ParamsContect()
        let temp = getTempIdForNewContact(newId: 0)
        param.tempId = temp
        param.conId = temp
        param.cltId = objOFClient?.cltId
        param.cnm = txtField_Name.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.email = txtField_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.mob1 = txtField_mobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.mob2 = txtField_AltMobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.fax = txtField_Fax.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.twitter = txtField_Twitter.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.skype = txtField_Skype.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.def = btnDefault.imageView?.image == UIImage.init(named: "BoxOFCheck") ? "1" : "0"
        param.siteId = paramsContect.siteId
        param.snm = txtField_LinkSite.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.extraField1 = fieldOne.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.extraField2 = fieldTwo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.extraField3 = fieldThree.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.extraField4 = fieldFour.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.notes = txtFld_Notes.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
   
        
        //ADD in LOCAL DATABASE
        let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientContactList")
        userJobs?.setValuesForKeys(param.toDictionary!)
        
        
        //if user selected default contact, Change all contact are non-default and current is defualt,
        var isDefault = Bool()
        if param.def == "1"{
            
            //Change Address for client list for default
            objOFClient?.mob1 = param.mob1
            objOFClient?.mob2 = param.mob2
            objOFClient?.email = param.email
            
            isDefault = true
        }
        if self.callbackForContactVC != nil {
            self.callbackForContactVC!(true,isDefault)
        }
         
         
        
        DatabaseClass.shared.saveEntity(callback: {isSuccess in
            param.tempId = param.conId
            param.compId = getUserDetails()?.compId
            
            //Call Service
            
            showToast(message: AlertMessage.contactAdd) //Alert message
            
            DatabaseClass.shared.saveOfflineContect(service: Service.addClientContact, param: param)
            
            self.navigationController?.popViewController(animated: true)
        })
}
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnDefaultPressed(_ sender: Any) {
   
        if btnDefault.imageView?.image == UIImage.init(named: "BoxOFCheck") {
            btnDefault.setImage(UIImage(named:"BoxOFUncheck"), for: .normal)
        }else{
            btnDefault.setImage(UIImage(named:"BoxOFCheck"), for: .normal)
        }
    }
    
    //=======================
    // MARK:- Other methods
    //=======================
    func getClintSitListFrmDB() -> Void {

       // if isAdded {
             showDataOnTableView(query: nil)
       // }
        
      //  if isChanged {
            getClientSiteSink()
       // }
        
//        isChanged = true
//        isAdded = false
    }
    
    //========================================
    //MARK:-  Stop Copy Paste of Numbers Filed
    //========================================
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if txtField_mobNo.isFirstResponder || txtField_AltMobNo.isFirstResponder || txtField_Fax.isFirstResponder {
            DispatchQueue.main.async(execute: {
                (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
            })
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    
    
    //=====================================
       // MARK:- Get Clint Sit List  Service
       //=====================================
       
       func getClientSiteSink(){
           
//           if !isHaveNetowork() {
//               if self.refreshControl.isRefreshing {
//                   self.refreshControl.endRefreshing()
//               }
//               return
          // }
           let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientSiteSink) as? String

    
           let param = Params()
           param.compId = getUserDetails()?.compId
           param.limit = "120"
           param.index = "0"
           param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
       
           serverCommunicator(url: Service.getClientSiteSink, param: param.toDictionary) { (response, success) in
               if(success){
                   let decoder = JSONDecoder()
                   
//                   DispatchQueue.main.async {
//                       if self.refreshControl.isRefreshing {
//                           self.refreshControl.endRefreshing()
//                       }
//                   }
                   
                   if let decodedData = try? decoder.decode(SiteVCResp.self, from: response as! Data) {
                       
                       if decodedData.success == true{
                          if decodedData.data.count > 0 {
                               //Request time will be update when data comes otherwise time won't be update
                               UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSiteSink)
                               //self.saveSiteInDataBase(data: decodedData.data)
                           }else{
                               if self.arrOfShowData.count == 0{
                                   DispatchQueue.main.async {
                                     //  self.tableView.isHidden = true
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
                 //  ShowAlert(title: "Network Error", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertControllerStyle.alert, callback: {_,_ in})
               }
           }
       }
       
       func showDataOnTableView(query : String?) -> Void {
             arrOfShow = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query == nil ? NSString(format:"cltId == '%@'", (objOFClient?.cltId)!) as String : query) as! [ClientSitList]
    //         if arrOfShowData.count != 0 {
    //             arrOfShowData =  arrOfShowData.sorted { $0.snm?.localizedCaseInsensitiveCompare($1.snm!) == ComparisonResult.orderedAscending }
    //             DispatchQueue.main.async {
    //                // self.tableView.reloadData()
    //             }
    //         }
             
             DispatchQueue.main.async {
                // self.tableView.isHidden = self.arrOfShowData.count > 0 ? false : true
             }
    }
   
}
