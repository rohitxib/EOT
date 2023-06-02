//
//  AllmostDoneVc.swift
//  EyeOnTask
//
//  Created by Altab on 04/11/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class AllmostDoneVc: UIViewController,OptionViewDelegate,UITextFieldDelegate,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var allmostDoneLbl: UILabel!
    @IBOutlet weak var completeDetailLbl: UILabel!
    @IBOutlet weak var selectCntryLbl: UILabel!
    @IBOutlet weak var cntryTxtField: UITextField!
    @IBOutlet weak var selectStateLbl: UILabel!
    @IBOutlet weak var stateTxtField: UITextField!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var selectCurrencyLbl: UILabel!
    @IBOutlet weak var currencyFormatLbl: UILabel!
    @IBOutlet weak var currencyFormatTxtField: UITextField!
    @IBOutlet weak var timeZoneLbl: UILabel!
    @IBOutlet weak var timeZoneTxtField: UITextField!
    @IBOutlet weak var languageTxtField: UITextField!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var currencyTxtField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var sltTxtField = UITextField()
    var sltDropDownBtnTag : Int!
    var optionalVw : OptionalView?
    var locationArr = ["America","Asia","Australia","Europe"]
    let cellReuseIdentifier = "cell"
    var sltDropDownTag : Int!
    var getLocation = ""
    var getlangId = ""
    var getLocalId = ""
    var getContryId = ""
    var getStateId = ""
    var getCurrencyId = ""
    var getTimeZoneId = ""
    var arrOfShowDataCntry = [Any]()
    var arrOfShowDataState = [Any]()
    var arrOfShowDataCurrency = [Any]()
    var arrOfShowDataCurrencyFormate = [Any]()
    var arrOfShowDataTimeZone = [Any]()
    var arrOfShowDataLang = [Any]()
    var loginTokenAuthentication:String? = ""
    var email:String?
    var pass:String?
    var  base = ""
    var apiCode:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        getLoginService()
        // Do any additional setup after loading the view.
    }
    
    
    func getCountry() -> NSArray {
        return getJson(fileName: "countries")["countries"] as! NSArray
    }
    func getState() -> NSArray {
        return getJson(fileName: "states")["states"] as! NSArray
    }
    func getCurrency() -> NSArray {
        return getJson(fileName: "currency")["data"] as! NSArray
    }
    func getCurrencyFormate() -> NSArray {
        return getJson(fileName: "currencyformate")["currency_format"] as! NSArray
    }
    func getTimeZone() -> NSArray {
        return getJson(fileName: "timezone")["timezones"] as! NSArray
    }
    func getLanguage() -> NSArray {
        return getJson(fileName: "language")["language"] as! NSArray
    }
    
    @IBAction func dropDownListBtn(_ sender: UIButton) {
        self.sltDropDownTag = sender.tag
        switch  sender.tag {
        case 0:
            
            if(self.optionalVw == nil){
                arrOfShowDataCntry = getJson(fileName: "countries")["countries"] as! [Any]
                self.openDwopDown( txtField: cntryTxtField , arr: arrOfShowDataCntry)
            }else{
                self.removeOptionalView()
            }
            
            break
        case 1:
            
            
            if(self.optionalVw == nil){
                arrOfShowDataState = getJson(fileName: "states")["states"] as! [Any]
                self.openDwopDown( txtField: stateTxtField , arr: arrOfShowDataState)
                
            }else{
                self.removeOptionalView()
            }
            break
            
            
        case 2:
            
            
            if(self.optionalVw == nil){
                arrOfShowDataCurrency = getJson(fileName: "currency")["data"] as! [Any]
                self.openDwopDown( txtField: currencyTxtField , arr: arrOfShowDataCurrency)
                
            }else{
                self.removeOptionalView()
            }
            break
            
        case 3:
            
            
            if(self.optionalVw == nil){
                
                arrOfShowDataCurrencyFormate = getJson(fileName: "currencyformate")["currency_format"] as! [Any]
                self.openDwopDown( txtField: currencyFormatTxtField , arr: arrOfShowDataCurrencyFormate)
                
            }else{
                self.removeOptionalView()
            }
            break
        case 4:
            
            
            if(self.optionalVw == nil){
                arrOfShowDataTimeZone = getJson(fileName: "timezone")["timezones"] as! [Any]
                self.openDwopDown( txtField: timeZoneTxtField , arr: arrOfShowDataTimeZone)
                
            }else{
                self.removeOptionalView()
            }
            break
        case 5:
            
            
            if(self.optionalVw == nil){
                arrOfShowDataLang = getJson(fileName: "language")["language"] as! [Any]
                self.openDwopDown( txtField: languageTxtField , arr: arrOfShowDataLang)
                
            }else{
                self.removeOptionalView()
            }
            break
            
            
        default:
            print("Defalt")
            break
        }
        
        
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        getAllMostDoneService()
        //getLoginService()
    }
    
    
    //  drop down functionallity
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (sltDropDownTag == 0) {
            return arrOfShowDataCntry.count
        }
        else if (sltDropDownTag == 1) {
            return arrOfShowDataState.count
        }
        else if (sltDropDownTag == 2) {
            return arrOfShowDataCurrency.count
        }
        else if (sltDropDownTag == 3) {
            return arrOfShowDataCurrencyFormate.count
        }
        else if (sltDropDownTag == 4) {
            return arrOfShowDataTimeZone.count
        }
        else if (sltDropDownTag == 5) {
            return arrOfShowDataLang.count
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
        
        // let language = locationArr[indexPath.row]
        switch self.sltDropDownTag {
        case 0:
            cell?.textLabel?.text =  ((arrOfShowDataCntry[indexPath.row] as? [String : Any])?["text"] as? String)?.capitalizingFirstLetter()
            break
        case 1:
            cell?.textLabel?.text =  ((arrOfShowDataState[indexPath.row] as? [String : Any])?["text"] as? String)?.capitalizingFirstLetter()
            break
        case 2:
            cell?.textLabel?.text =  ((arrOfShowDataCurrency[indexPath.row] as? [String : Any])?["text"] as? String)?.capitalizingFirstLetter()
            break
        case 3:
            cell?.textLabel?.text =  ((arrOfShowDataCurrencyFormate[indexPath.row] as? [String : Any])?["text"] as? String)?.capitalizingFirstLetter()
            break
        case 4:
            cell?.textLabel?.text =  ((arrOfShowDataTimeZone[indexPath.row] as? [String : Any])?["text"] as? String)?.capitalizingFirstLetter()
            break
        case 5:
            cell?.textLabel?.text =  ((arrOfShowDataLang[indexPath.row] as? [String : Any])?["nativeName"] as? String)?.capitalizingFirstLetter()
            break
            
        default: break
            
        }
        
        
        
        return cell!
    }
         
         func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if (sltDropDownTag == 0) {
                

                             
                self.cntryTxtField.text = (arrOfShowDataCntry[indexPath.row] as? [String : Any])?["text"] as? String
                                       let countryID = (arrOfShowDataCntry[indexPath.row] as? [String : Any])?["id"] as? String
                               getContryId = countryID!
              
              }
              self.removeOptionalView()
            
            if (sltDropDownTag == 1) {
                            
                           self.stateTxtField.text = (arrOfShowDataState[indexPath.row] as? [String : Any])?["text"] as? String
                                      let countryID = (arrOfShowDataState[indexPath.row] as? [String : Any])?["id"] as? String
                              getStateId = countryID!
             
             }
             self.removeOptionalView()
            
            if (sltDropDownTag == 2) {
                            
                           self.currencyTxtField.text = (arrOfShowDataCurrency[indexPath.row] as? [String : Any])?["text"] as? String
                                      let countryID = (arrOfShowDataCurrency[indexPath.row] as? [String : Any])?["id"] as? String
                              getCurrencyId = countryID!
             
             }
             self.removeOptionalView()
            
            if (sltDropDownTag == 3) {
                            
                           self.currencyFormatTxtField.text = (arrOfShowDataCurrencyFormate[indexPath.row] as? [String : Any])?["text"] as? String
                                      let countryID = (arrOfShowDataCurrencyFormate[indexPath.row] as? [String : Any])?["id"] as? String
                              getLocalId = countryID!
             
             }
             self.removeOptionalView()
            
            if (sltDropDownTag == 4) {
                            
                           self.timeZoneTxtField.text = (arrOfShowDataTimeZone[indexPath.row] as? [String : Any])?["text"] as? String
                                      let countryID = (arrOfShowDataTimeZone[indexPath.row] as? [String : Any])?["id"] as? String
                              getTimeZoneId = countryID!
             
             }
             self.removeOptionalView()
            
            if (sltDropDownTag == 5) {
                            
                           self.languageTxtField.text = (arrOfShowDataLang[indexPath.row] as? [String : Any])?["nativeName"] as? String
                                      let countryID = (arrOfShowDataLang[indexPath.row] as? [String : Any])?["lngId"] as? String
                                getlangId = countryID!
             
             }
             self.removeOptionalView()
            
         }
      
      func removeOptionalView(){
             if optionalVw != nil {
                 self.optionalVw?.removeFromSuperview()
                 self.optionalVw = nil
             }
         }
      func textFieldDidBeginEditing(_ textField: UITextField) {
             self.sltTxtField = textField
             self.sltDropDownBtnTag = textField.tag
    
        if cntryTxtField == textField {
             self.callMethodforOpenDwop(tag: 0)
         }
        if stateTxtField == textField {
            self.callMethodforOpenDwop(tag: 1)
        }
        if currencyTxtField == textField {
            self.callMethodforOpenDwop(tag: 2)
        }
        if currencyFormatTxtField == textField {
            self.callMethodforOpenDwop(tag: 3)
        }
        if timeZoneTxtField == textField {
            self.callMethodforOpenDwop(tag: 4)
        }
        if languageTxtField == textField {
            self.callMethodforOpenDwop(tag: 5)
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
                self.openDwopDown( txtField: cntryTxtField, arr: arrOfShowDataCntry)
            }else{
                self.removeOptionalView()
            }
            
            
            break
            
        case 1:
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 1
                self.openDwopDown( txtField: stateTxtField, arr: arrOfShowDataState)
            }else{
                self.removeOptionalView()
            }
            
            
            break
        case 2:
            
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 2
                self.openDwopDown( txtField: currencyTxtField, arr: arrOfShowDataCurrency)
            }else{
                self.removeOptionalView()
            }
            
            
            break
            
        case 3:
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 3
                self.openDwopDown( txtField: currencyFormatTxtField, arr: arrOfShowDataCurrencyFormate)
            }else{
                self.removeOptionalView()
            }
            
            
            break
        case 4:
            
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 4
                self.openDwopDown( txtField: timeZoneTxtField, arr: arrOfShowDataTimeZone)
            }else{
                self.removeOptionalView()
            }
            
            
            break
            
        case 5:
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 5
                self.openDwopDown( txtField: languageTxtField, arr: arrOfShowDataLang)
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
            let bPredicate: NSPredicate = NSPredicate(format: "self.name beginswith[c] %@", result)
            arrOfShowDataCntry =  getCountry().filtered(using: bPredicate)
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.cntryTxtField, arr: arrOfShowDataCntry)
            }
            DispatchQueue.main.async{
                if(self.arrOfShowDataCntry.count > 0){
                    self.optionalVw?.isHidden = false
                    self.optionalVw?.table_View?.reloadData()
                }else{
                    self.optionalVw?.isHidden = true
                }
            }
            
        case 1:
            stateTxtField.text = ""
            stateTxtField.isUserInteractionEnabled = true
            
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.stateTxtField, arr: arrOfShowDataState)
            }
            self.optionalVw?.isHidden = false
            DispatchQueue.main.async{
                if(self.arrOfShowDataState.count > 0){
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
        case 2:
            currencyTxtField.text = ""
            currencyTxtField.isUserInteractionEnabled = true
            
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.currencyTxtField, arr: arrOfShowDataCurrency)
            }
            self.optionalVw?.isHidden = false
            DispatchQueue.main.async{
                if(self.arrOfShowDataCurrency.count > 0){
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
        case 3:
            currencyFormatTxtField.text = ""
            currencyFormatTxtField.isUserInteractionEnabled = true
            
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.currencyFormatTxtField, arr: arrOfShowDataCurrencyFormate)
            }
            self.optionalVw?.isHidden = false
            DispatchQueue.main.async{
                if(self.arrOfShowDataCurrencyFormate.count > 0){
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
        case 4:
            timeZoneTxtField.text = ""
            timeZoneTxtField.isUserInteractionEnabled = true
            
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.timeZoneTxtField, arr: arrOfShowDataTimeZone)
            }
            self.optionalVw?.isHidden = false
            DispatchQueue.main.async{
                if(self.arrOfShowDataTimeZone.count > 0){
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
        case 5:
            languageTxtField.text = ""
            languageTxtField.isUserInteractionEnabled = true
            
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.languageTxtField, arr: arrOfShowDataLang)
            }
            self.optionalVw?.isHidden = false
            DispatchQueue.main.async{
                if(self.arrOfShowDataLang.count > 0){
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
    
    
    func getLoginService(){
        
        if !isHaveNetowork() {
            // if self.refreshControl.isRefreshing {
            //    self.refreshControl.endRefreshing()
            // return
        }
        
        let param = Params()
        
        param.email = email
        param.cc = ""
        param.devId = ""
        param.devType = "2"
        param.pass = pass
        
        
        
        
        print(param.toDictionary)
        
        
        serverCommunicatorSign(url: Service.signin, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(loginResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        self.loginTokenAuthentication = decodedData.data[0].token
                        // self.arrOfSignUpdata = decodedData.transVar!
                        
                        DispatchQueue.main.async {
                            
                            
                            // self.showToast(message:LanguageKey.expense_added)
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
    
    
    func serverCommunicatorSign(url:String , param:Dictionary<String, Any>?,callBack : @escaping (Any?, Bool) -> Void) {
        
        if apiCode == "1" {
        base = "https://us1.eyeontask.com/en/eotServices/"
        }else if apiCode == "2"{
        base = "https://uk1.eyeontask.com/en/eotServices/"
        }else if apiCode == "3"{
        base = "https://au1.eyeontask.com/en/eotServices/"
        } else {
        base = "https://as1.eyeontask.com/en/eotServices/"
        }
        
        
        guard let url1 = URL(string:base+url) else { return }
    //
        if DebugModePrint() {
             //print(url1)
        }
    //
       
        
        if isHaveNetowork() {
            
            
            var request = URLRequest(url: url1)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
            request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
                //request.addValue("https://us1.eyeontask.com", forHTTPHeaderField: "Origin")
            let origne = url1.host
            request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
            request.timeoutInterval = 30.0
            
            if param != nil {
                request.httpBody =  try? JSONSerialization.data(withJSONObject: param!)
            }
            
            callRequest(request: request, callBack: callBack) // Send request to CallRequest method
      
        }else{
            killLoader()
            errorString = AlertMessage.checkNetwork
            //increaseErrorCount(callBack: callBack, data: nil)
            callBack(nil , false)
        }
    }
    
    
    func getAllMostDoneService(){
        
        if !isHaveNetowork() {
            // if self.refreshControl.isRefreshing {
            //    self.refreshControl.endRefreshing()
            // return
        }
        
        let param = Params()

        param.city = cityTxtField.text
        param.duration = "01.00"
        param.state = getStateId
        param.ctry = getContryId
        param.cur = getCurrencyId
        param.timezone = getTimeZoneId
        param.lngId = getlangId
        param.localId = getLocalId
        param.mob = ""
        
        
        
       // print(param.toDictionary)
        
        serverCommunicatorForAllmostDone(url: Service.setCompanyDefaultSetting, param: param.toDictionary) { (response, success) in
            //        serverCommunicatorForAllmostDone(url: Service.setCompanyDefaultSetting, param: param.toDictionary, images: nil, imagePath: "receipt[]") { (response, success) in
            
            DispatchQueue.main.async {
                // if self.refreshControl.isRefreshing {
                //    self.refreshControl.endRefreshing()
                // }
            }
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(RegistrationResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async {
                            //print(decodedData.transVar!)
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }else{
                        
                    }
                }else{
                    ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                        if cancelButton {
                            showLoader()
                            self.getAllMostDoneService()
                        }
                    })
                }
            }
        }
        
    }
    
    
    
    func serverCommunicatorForAllmostDone(url:String , param:Dictionary<String, Any>?,callBack : @escaping (Any?, Bool) -> Void) {
        
        if apiCode == "1" {
        base = "https://us1.eyeontask.com/en/eotServices/"
        }else if apiCode == "2"{
        base = "https://uk1.eyeontask.com/en/eotServices/"
        }else if apiCode == "3"{
        base = "https://au1.eyeontask.com/en/eotServices/"
        } else {
        base = "https://as1.eyeontask.com/en/eotServices/"
        }
        
        guard let url1 = URL(string: base+url) else { return }
    //
        if DebugModePrint() {
           //  print(url1)
        }
    //
       
        
        if isHaveNetowork() {
            
            
            var request = URLRequest(url: url1)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(loginTokenAuthentication ?? "", forHTTPHeaderField: "Token")
            request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
                //request.addValue("https://us1.eyeontask.com", forHTTPHeaderField: "Origin")
            let origne = url1.host
            request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
            request.timeoutInterval = 30.0
            
            if param != nil {
                request.httpBody =  try? JSONSerialization.data(withJSONObject: param!)
            }
            
            callRequest(request: request, callBack: callBack) // Send request to CallRequest method
      
        }else{
            killLoader()
            errorString = AlertMessage.checkNetwork
            //increaseErrorCount(callBack: callBack, data: nil)
            callBack(nil , false)
        }
    }


    
    //=======================================
    // Save User's Details
    //=======================================
    func saveUserDetails(userDetails : LoginData ) -> Void {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userDetails) {
            loginTokenAuthentication = userDetails.token
            UserDefaults.standard.set(encoded, forKey: "userinfo")
            UserDefaults.standard.synchronize()
        }
    }
      
    
}
