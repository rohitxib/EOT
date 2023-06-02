//
//  SettingVC.swift
//  EyeOnTask
//
//  Created by Altab on 01/09/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import CoreData

struct SideMenuModel1 {
    //var id = Int()
    var name = String()
    var subMenu = [Any]()
    //var image = String()
    //var isCollaps = false
}



class SettingVC: UIViewController,OptionViewDelegate,UITextFieldDelegate,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var bottemline: UILabel!
    @IBOutlet weak var errorLogBtn: UIButton!
    @IBOutlet weak var errorLogLbl: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var navigationTittle: UILabel!
    @IBOutlet weak var extraBtn: UIBarButtonItem!
    @IBOutlet weak var txtLanguageName: UITextField!
    @IBOutlet weak var txtViewConName: UITextField!
    @IBOutlet weak var lblDefaulPageView: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    let context = APP_Delegate.persistentContainer.viewContext //Create context
    var buttonIsSelected = false
    var sltTxtField = UITextField()
    var sltDropDownBtnTag : Int!
    var optionalVw : OptionalView?
    let cellReuseIdentifier = "cell"
    var sltDropDownTag : Int!
    var arrOfShowData = [ClientList]()
    var arrOfShow = [Any]()
    var menus = [SideMenuModel]()
    var modelArr = [languageDetails]()
    var viewConArr:[String] = []
    var defaultPageArr = [Any]()
    var languageIndex = 2
    var getValu = languageDetails()
    var LanguagArr = [SideMenuModel1]()
    var isPopup = false
    var langArr = [String]()
    var arrErrorLog = [ErrorsList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPermitForShow(permission: permissions.isAppointmentVisible) == true{
            
            self.viewConArr = ["Jobs","Calendar","Audit","Clients","Quote","Chats","Expenses"]
            
        }else{
            self.txtLanguageName.text = "Jobs"
            self.viewConArr = ["Jobs","Audit","Clients","Quote","Chats","Expenses"]
           
        }
        
        
        switchBtn.onTintColor = UIColor.init(red: 0/255, green: 132/255, blue: 141/255, alpha: 1.0)
     
        var isSwitchOff = ""
        isSwitchOff =   UserDefaults.standard.value(forKey: "TokenOff") as? String ?? ""
      
        
        if (isSwitchOff == "Off") {
            
            self.switchBtn.isOn = false
            
        }
        
        setLocalization()
        
      
        self.txtLanguageName.text = "English"
    
        if let revealController = self.revealViewController(){
            revealViewController().delegate = self
            extraBtn.target = revealViewController()
            extraBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealController.tapGestureRecognizer()
        }
        language()
        
        txtLanguageName.text = UserDefaults.standard.value(forKey: "getLanguage") as? String ?? "English"
        txtViewConName.text = UserDefaults.standard.value(forKey: "defaultPage") as? String ?? "job"
        
        var lang = ""
        if let selectedLang = getCurrentSelectedLanguage() {
            lang = "\(LanguageKey.settings) (\(selectedLang))"
        }
      
        if getDefaultSettings()!.languageList! != nil {
            let language = SideMenuModel1(name: lang, subMenu: getDefaultSettings()!.languageList!)
                   LanguagArr.append(language)
                   languageIndex = LanguagArr.endIndex - 1
        }
       
    }
    
//    func uploadErrorsOnServer() -> Void {
//        var errorArry = self.fetchDataFromDatabse(entityName:Entities.ErrorsList.rawValue, query: nil) as! [ErrorsList]
//
//        if errorArry.count > 0{
//            showLoader()
//            // Sort requests in assending order for upload request according to time (First in First out)
//            errorArry = errorArry.sorted(by: {
//                $0.time?.compare($1.time!) == .orderedAscending
//            })
//
//            let usrId = getUserDetails()?.usrId
//            let compId = getUserDetails()?.compId
//            let token = (UserDefaults.standard.value(forKey: "deviceToken") as? String) ?? ""
//            let data = errorArry [0]
//            let param = Params()
//            param.apiUrl =  URL(string: Service.BaseUrl)?.absoluteString//"Send From Setting"//data.apiUrl
//            param.requestParam = "UsrId - \(usrId ?? "")," + " CompId - \(compId ?? "")," + " DeviceToken - \(token ?? "")"//data.requestParam
//            param.response = "\(errorArry)"//data.response
//            param.response = "\(errorArry)"//data.response
//            param.version = data.version
//
//
//            serverCommunicator(url: Service.errorUpload, param: param.toDictionary, callBack: { (response, success) in
//
//                if (success){
//                    let decoder = JSONDecoder()
//                    if let decodedData = try? decoder.decode(ErrorServiceResponse.self, from: response as! Data) {
//
//                        killLoader()
//                            self.showToast(message: "Log Send")
//                        self.arrErrorLog = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ErrorsList", query: nil) as! [ErrorsList]
//
//                        print(self.arrErrorLog)
//                        for job in self.arrErrorLog{
//                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
//                         }
//
//                        if decodedData.success! {
//
//                        }
//                    }
//                }else{
//
//                }
//            })
//        }else{
//            print("Error Log Not Found.")
//        }
//    }


    //=====================
    //MARK:- FETCH Entity
    //=====================
    func fetchDataFromDatabse(entityName : String, query : String?) -> Any? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let formate = query {
            request.predicate = NSPredicate(format: formate)
        }
        request.returnsObjectsAsFaults = false

        do{
            let result = try context.fetch(request)
            //print("success")
            return result
        }catch {
            //print("Failed")
            return nil
        }
    }
    
    
    func setLocalization() -> Void {
        
        navigationTittle.text = LanguageKey.settings
        lblDefaulPageView.text =  LanguageKey.default_view
        msgLbl.text = LanguageKey.site_name_show_permisson
        lblLanguage.text =  LanguageKey.app_language
        errorLogLbl.text =  LanguageKey.report_msg
        btnSave.setTitle(LanguageKey.save_btn, for: .normal)
        errorLogBtn.setTitle(LanguageKey.detail_report, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        language()
        let result = SideMenu.getModel()
        menus = result.0
        languageIndex = result.1
    }
    
    @IBAction func errorLogBtnAct(_ sender: Any) {
        //uploadErrorsOnServer()
    }
    
    @IBAction func switchOnOff(_ sender: Any) {
        var isSwitchOff = ""
        isSwitchOff =   UserDefaults.standard.value(forKey: "TokenOff") as? String ?? ""
        
        
        if (isSwitchOff == "Off") {
            
            // self.switchBtn.isOn = false
            buttonIsSelected == buttonIsSelected
            updateOnOffButton()
            
        }else{
            
            
            buttonIsSelected = !buttonIsSelected
            //  self.switchBtn.isOn = true
            updateOnOffButton()
        }
    }
    
    
    func updateOnOffButton() {
        if buttonIsSelected {
            //let isAlreadyLogin = UserDefaults.standard.value(forKey: "TokenOff")
            var on = "Off"
            UserDefaults.standard.set(on, forKey: "TokenOff")
          //  print("TokenOff")
       
        }else{
            switchBtn.onTintColor = UIColor.init(red: 0/255, green: 132/255, blue: 141/255, alpha: 1.0)
          //  switchBtn.subviews[0].subviews[0].backgroundColor = UIColor.init(red: 0/255, green: 132/255, blue: 141/255, alpha: 1.0)
            var on = "On"
            UserDefaults.standard.set(on, forKey: "TokenOff")
           // print("TokenOn")
            //showEyePass
            
        }
    }
    
    @IBAction func btnSaveSetting(_ sender: Any) {
        
        
        //        if !isHaveNetowork() {
        //                   ShowError(message: AlertMessage.networkIssue, controller: windowController)
        //                   return
        //               }
        //
        //              // showLoader()
        //      if isPopup == true {
        //        if self.sltDropDownTag != nil {
        //
        //        ShowAlert(title: LanguageKey.confirmation, message: LanguageKey.changeLanguage, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.done as NSString, style: .alert) { (cancel, ok) in
        //        if ok {
        //           // self.modelArr.removeAll()
        //        let index = self.modelArr
        //
        //        if self.txtLanguageName.text != nil
        //        {
        //
        ////        for i in self.modelArr{
        ////        self.getValu = i
        ////
        ////        }
        //        LanguageManager.shared.setLanguage(filename: self.getValu.fileName!, filePath: self.getValu.filePath!, languageName: self.getValu.nativeName!, version: self.getValu.version!, alert: true, callBack: { (success) in
        //        if success {
        //        self.langArr.append(self.getValu.nativeName!)
        //
        //        killLoader()
        //
        ////        self.dismiss(animated: true, completion: nil)
        ////        self.revealViewController()?.revealToggle(animated: true)
        //             self.navigationController?.popViewController(animated: true)
        //        }
        //        })
        //        }else{
        //       // self.revealViewController()?.revealToggle(animated: true)
        //            self.navigationController?.popViewController(animated: true)
        //        }
        //
        //
        //        }
        //
        //        if cancel {
        //        killLoader()
        //        }
        //        }
        //
        //        }else {
        //        killLoader()
        //
        //        }
        //        }else{
        //       self.navigationController?.popViewController(animated: true)
        //       // self.revealViewController()?.revealToggle(animated: true)
        //
        //
        //
        //
        //        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sltTxtField = textField
        self.sltDropDownBtnTag = textField.tag
        
        
        if txtLanguageName == textField {
            self.callMethodforOpenDwop(tag: 0)
        }
        if txtViewConName == textField {
            self.callMethodforOpenDwop(tag: 1)
        }
        
    }
    func removeOptionalView(){
        if optionalVw != nil {
            self.optionalVw?.removeFromSuperview()
            self.optionalVw = nil
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLanguageAction(_ sender: UIButton) {
        self.sltDropDownTag = sender.tag
        switch  sender.tag {
        case 0:
            
            if(self.optionalVw == nil){
                
              
                self.openDwopDown( txtField: txtLanguageName , arr: menus)
            }else{
                self.removeOptionalView()
            }
            
            break
        case 1:
            
            
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: txtViewConName , arr: viewConArr)
                
            }else{
                self.removeOptionalView()
            }
            break
            
        default:
            //   print("Defalt")
            break
        }
    }
    
    func callMethodforOpenDwop(tag : Int){
        if(self.optionalVw != nil){
            self.removeOptionalView()
            return
        }
        
        switch tag {
        case 0:
            
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 0
                self.openDwopDown( txtField: txtLanguageName, arr: arrOfShowData)
            }else{
                self.removeOptionalView()
            }
            
            
            break
            
        case 1:
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 1
                self.openDwopDown( txtField: txtViewConName, arr: viewConArr)
            }else{
                self.removeOptionalView()
            }
            
            
            break
            
        default:
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.sltDropDownBtnTag = textField.tag
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        
        switch self.sltDropDownBtnTag {
        case 0:
            
            
            txtViewConName.text = ""
            txtLanguageName.text = ""
            
            
            txtViewConName.isUserInteractionEnabled = true
            txtLanguageName.isUserInteractionEnabled = true
            
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.txtLanguageName, arr: menus)
            }
            self.optionalVw?.isHidden = false
            DispatchQueue.main.async{
                if(self.menus.count > 0){
                    
                    
                    self.optionalVw?.table_View?.reloadData()
                }else{
                    if(result != ""){
                        self.removeOptionalView()
                        
                        
                    }else{
                        self.removeOptionalView()
                        
                        
                    }
                }
            }
            break
            
            
        default: break
            
        }
        
        return true
    }
    
    
    //====================================================
    //MARK:-  Create Tags
    //====================================================
    func createTags(strName : String , view : ASJTagsView){
        view.addTag(strName, withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: true)
        view.deleteBlock = {(tagText : String ,idx : Int) -> Void in
            view.deleteTag(at: idx)
            //self.FltWorkerId.remove(at: idx)
        }
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
    //
    //    let languageModel = SideMenuModel(id: 3, name: lang, subMenu: getDefaultSettings()!.languageList!, image: "language", isCollaps: false)
    //    menus.append(languageModel)
    //    languageIndex = menus.endIndex - 1
    //
    
    func getDefaultSettings() -> DefaultSettings? {
        let decoder = JSONDecoder()
        if let questionData = UserDefaults.standard.data(forKey: "DefSetting"){
            let question = try? decoder.decode(DefaultSettings.self, from:questionData)
            return question ?? nil
        }
        return nil
    }
    func language() {
        if getDefaultSettings()?.language?.isLock == "0" {
            var lang = ""
            if let selectedLang = getCurrentSelectedLanguage() {
                lang = "\(LanguageKey.language) (\(selectedLang))"
            }
            let languageModel = SideMenuModel(id: 3, name: lang, subMenu: getDefaultSettings()!.languageList!, image: "language", isCollaps: false)
            menus.append(languageModel)
            languageIndex = menus.endIndex - 1
        }
    }
    
    
    //=====================================
    // MARK:- Optional view Detegate
    //=====================================
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return menus.count
    //    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (sltDropDownTag == 0) {
            //            let menu = menus[section]
            //            if menu.id == 3 && menu.isCollaps == true {
            //                return menu.subMenu.count
            //            }
            //            return 0
            return getDefaultSettings()!.languageList!.count
        }
        else if (sltDropDownTag == 1) {
            return viewConArr.count
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
        
        // let menu = menus[languageIndex].subMenu as! [languageDetails]
        let menu = LanguagArr[languageIndex].subMenu as! [languageDetails]
        let language = menu[indexPath.row]
        switch self.sltDropDownTag {
        case 0:
          
            cell?.textLabel?.text = language.nativeName
            break
        case 1:
            cell?.textLabel?.text = viewConArr[indexPath.row]
            
            break
            
        default: break
            
        }
        
        
        return cell!
    }
    
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            killLoader()
            return
        }
        
        if (sltDropDownTag == 0) {
            
            var  isSwitchOff =  UserDefaults.standard.value(forKey: "staticLabelFwKeyVal") as? String ?? ""
            
            
            if isSwitchOff != "" {
            
                ShowAlert(title: "", message: LanguageKey.static_label_will_remain_same, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {(_ , _) in })
            }else{
                
                showLoader()
                ShowAlert(title: LanguageKey.confirmation, message: LanguageKey.changeLanguage, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.done as NSString, style: .alert) { (cancel, ok) in
                    if ok {
                        
                        // self.isPopup = true
                        self.getValu  = (self.getDefaultSettings()?.languageList![indexPath.row])!
                        self.txtLanguageName.text = self.getValu.nativeName
                        UserDefaults.standard.set(self.getValu.nativeName, forKey: "getLanguage")
                        
                        self.removeOptionalView()
                        
                        
                        if !isHaveNetowork() {
                            ShowError(message: AlertMessage.networkIssue, controller: windowController)
                            return
                        }
                        
                        if self.sltDropDownTag != nil {
                            
                            
                            let index = self.modelArr
                            
                            if self.txtLanguageName.text != nil
                            {
                                
                                LanguageManager.shared.setLanguage(filename: self.getValu.fileName!, filePath: self.getValu.filePath!, languageName: self.getValu.nativeName!, version: self.getValu.version!, alert: true, callBack: { (success) in
                                    if success {
                                        self.langArr.append(self.getValu.nativeName!)
                                        
                                        killLoader()
                                        
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                })
                            }else{
                                killLoader()
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            
                        }else {
                            killLoader()
                            
                        }
                        
                        
                    }
                    
                    if cancel {
                        killLoader()
                    }
                }
                
            }
      
        }else if (sltDropDownTag == 1) {
            defaultPageArr.removeAll()
            self.txtViewConName.text = viewConArr[indexPath.row]
            UserDefaults.standard.set(self.txtViewConName.text, forKey:"defaultPage")
            
        }
        
        
        self.removeOptionalView()
    }
    
    
}
