//
//  EditClientVC.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 14/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
// jugalsingh

import UIKit
import IQKeyboardManagerSwift
import CoreLocation


class EditClientVC: UIViewController,UITextFieldDelegate,UITextViewDelegate,OptionViewDelegate {

    @IBOutlet weak var BtnLatlng: UIButton!
    @IBOutlet weak var referanceTxtFld: FloatLabelTextField!
    @IBOutlet weak var H_lattitude: NSLayoutConstraint!
    @IBOutlet weak var H_longitude: NSLayoutConstraint!
    @IBOutlet var latitute: UITextField!
    @IBOutlet var longitute: UITextField!
    @IBOutlet weak var btnUpDate: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet var bgView_Ibdustry: UIView!
    @IBOutlet var bgView_AccTyp: UIView!
    @IBOutlet var scroll_View: UIScrollView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var txtClientName: UITextField!
    @IBOutlet weak var txtTINno: UITextField!
    @IBOutlet weak var txtGSTno: UITextField!
    @IBOutlet weak var txtAccType: UITextField!
    @IBOutlet weak var txtIndustry: UITextField!
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var btnDeactive: UIButton!
    
    var clientDetail : ClientList?
    var optionalVw : OptionalView?
    let cellReuseIdentifier = "cell"
    var arrOfShowData = [UserAccType]()
    var arrOfAccType = [UserAccType]()
    var sltTxtFidOrDroDownIdx : Int?
    let param = Params()
    var sltTxtField = UITextField()
    var isTxtView  = false
    var arrOfShow = [Any]()
    var arrOfIndustryList = [IndustryList]()
    var count : Int = 0
    
    var arr = ["Existing Customer","Google","Local Newspaper","Media","Television","WOM","Website"," Facebook","Instagram","Magazine","Other"]
       var arrKey = ["1","2","3","4","5","6","7","8","9","10","11"]
   
    override func viewDidLoad() {
     super.viewDidLoad()
        getClientListFromDBjob()
        getIndustryList()
        if getDefaultSettings()?.isJobLatLngEnable == "0" {
            H_lattitude.constant = 0.0
            H_longitude.constant = 0.0
        }
       
        registorKeyboardNotification()
        txtClientName.text = clientDetail?.nm
        txtTINno.text = clientDetail?.tinNo
        txtGSTno.text = clientDetail?.gstNo
        txtView.text = clientDetail?.note
        let aaa = clientDetail?.referral
        if aaa == "1"{
             referanceTxtFld.text = "Existing Customer"
        }
        if aaa == "2"{
             referanceTxtFld.text = "Google"
        }
        if aaa == "3"{
             referanceTxtFld.text = "Local Newspaper"
        }
        if aaa == "4"{
             referanceTxtFld.text = "Media"
        }
        if aaa == "5"{
             referanceTxtFld.text = "Television"
        }
        if aaa == "6"{
             referanceTxtFld.text = "WOM"
        }
        if aaa == "7"{
             referanceTxtFld.text = "Website"
        }
        if aaa == "8"{
             referanceTxtFld.text = "Facebook"
        }
        if aaa == "9"{
             referanceTxtFld.text = "Instagram"
        }
        if aaa == "10"{
             referanceTxtFld.text = "Magazine"
        }
        if aaa == "11"{
             referanceTxtFld.text = "Other"
        }
    
        latitute.text = clientDetail?.lat
        longitute.text = clientDetail?.lng

        if(clientDetail?.industry != nil && clientDetail?.industry != "0"){
            
            let results = clientDetail?.industry
            var querys = ""
            if results != "" && results != nil{
                querys = "industryId = '\(results!)'"
                let arrOfObjs = DatabaseClass.shared.fetchDataFromDatabse(entityName: "IndustryList", query: querys == "" ? nil : querys) as! [IndustryList]
                if arrOfObjs.count > 0 {
                    txtIndustry.text = arrOfObjs[0].industryName ?? ""//clientDetail?.industryName
                    param.industry = clientDetail?.industry
                }
            }
        }
        
        // For account Type
        let result = clientDetail?.pymtType
        var query = ""
        if result != "" && result != nil{
            query = "accId = '\(result!)'"
        
            let arrOfObj = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserAccType", query: query == "" ? nil : query) as! [UserAccType]
            
            if arrOfObj.count > 0{
               txtAccType.text = arrOfObj[0].type ?? ""
                param.pymtType = clientDetail?.pymtType
                
            }
        }
        
        if clientDetail?.isactive == "0" {
              btnDeactive.setImage(UIImage(named:"radio-selected"), for: .normal)
        }else{
              btnActive.setImage(UIImage(named:"radio-selected"), for: .normal)
        }
          self.getAccounttype()
        
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Arimo", size: 15)!]
        let asterix = NSAttributedString(string: " *", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let attributedStringClientName  = NSMutableAttributedString(string: "Client Name" , attributes: attributes)
        attributedStringClientName.append(asterix)
        self.txtClientName.attributedPlaceholder = attributedStringClientName
        
        setLocalization()
        
        ActivityLog(module:Modules.client.rawValue , message: ActivityMessages.clientUpdate)

    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.edit_client
        txtClientName.placeholder = "\(LanguageKey.client_name) *"
        txtAccType.placeholder = LanguageKey.Account_type
        txtGSTno.placeholder = LanguageKey.gst_no
        txtTINno.placeholder = LanguageKey.tin_no
        txtIndustry.placeholder = LanguageKey.industry
        referanceTxtFld.placeholder = LanguageKey.reference
        lblNote.text = LanguageKey.notes
        lblStatus.text = LanguageKey.status_radio_btn
        btnUpDate.setTitle(LanguageKey.update , for: .normal)
        btnDeactive.setTitle("  \(LanguageKey.inactive_radio_btn)" , for: .normal)
        btnActive.setTitle("  \(LanguageKey.active_radio_btn)" , for: .normal)
        BtnLatlng.setTitle(LanguageKey.get_current_lat_long , for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.navigationBar.topItem?.title = "";
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

    @IBAction func btnUpdatePressed(_ sender: Any) {
        
        if txtClientName.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                updateClientDetails()
        }else{
            ShowError(message: AlertMessage.enterClientName, controller: windowController)
        }
    }
    @IBAction func dropDownBtnAction(_ sender: UIButton) {
        sltTxtFidOrDroDownIdx = sender.tag
        if(sender.tag == 1){
            if(self.optionalVw == nil){
                arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserAccType", query: nil) as! [UserAccType]
                self.openDwopDown( txtField: self.txtAccType , arr: arrOfShowData)
            }else{
                self.removeOptionalView()
                
            }
        }else if (sender.tag == 4) {
            
            if(self.optionalVw == nil){
                arrOfShow = arrOfIndustryList
                self.openDwopDown( txtField: self.txtIndustry, arr: arrOfShow)
                //self.openDwopDown( txtField: self.txtIndustry , arr: APP_Delegate.industries)
            }else{
                self.removeOptionalView()
                
            }
            
        }else if (sender.tag == 5) {
            
            if(self.optionalVw == nil){
             
                self.openDwopDown( txtField: self.referanceTxtFld, arr: arr)
               
            }else{
                self.removeOptionalView()
                
            }
        }
    }
    
    //=====================================
    // MARK:- Optional view Detegate
    //=====================================
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(sltTxtFidOrDroDownIdx == 1){

        return self.arrOfShowData.count == 0 ? arrOfAccType.count : self.arrOfShowData.count
        }else if(sltTxtFidOrDroDownIdx == 4){
            return arrOfIndustryList.count
            
        }else if(sltTxtFidOrDroDownIdx == 5){
            return arr.count
            
        }else{
            return 0
        }
       
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
    
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
     
        cell?.textLabel?.textColor = UIColor.darkGray

        if(sltTxtFidOrDroDownIdx == 1){

        cell?.textLabel?.text = (arrOfShowData[indexPath.row]).type?.capitalizingFirstLetter()
        }else  if(sltTxtFidOrDroDownIdx == 4){
            cell?.textLabel?.text = arrOfIndustryList[indexPath.row].industryName
        }else  if(sltTxtFidOrDroDownIdx == 5){
            cell?.textLabel?.text = arr[indexPath.row]
        }
        return cell!

    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(sltTxtFidOrDroDownIdx == 1){
            self.txtAccType.text =  (self.arrOfShowData[indexPath.row]).type
            param.pymtType = (self.arrOfShowData[indexPath.row]).accId
        }else if(sltTxtFidOrDroDownIdx == 4){
            self.txtIndustry.text =  arrOfIndustryList[indexPath.row].industryName
            param.industry = arrOfIndustryList[indexPath.row].industryId
            
        }else if(sltTxtFidOrDroDownIdx == 5){
            self.referanceTxtFld.text =  arr[indexPath.row]
            param.referral = arrKey[indexPath.row]
            
        }
        self.removeOptionalView()
    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0

    }
  
    //=====================================
    // MARK:- TxtView Detegate
    //=====================================
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        isTxtView = true
    }

    //=====================================
    // MARK:- TxtField Detegate
    //=====================================
    
    func openDropDownWhenKeyBordappere(){
        if(self.optionalVw == nil && self.sltTxtField == self.txtAccType){
            self.removeOptionalView()
            arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserAccType", query: nil) as! [UserAccType]
            self.openDwopDown( txtField: self.txtAccType, arr: arrOfShowData)
            
        }else if(self.optionalVw == nil && self.sltTxtField == self.txtIndustry){
          //  self.openDwopDown( txtField: self.txtIndustry, arr: APP_Delegate.industries)
            
        }else{
            self.removeOptionalView()
            
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        sltTxtFidOrDroDownIdx = textField.tag
        self.isTxtView = false
        self.arrOfShowData.removeAll()
        self.sltTxtField = textField
   
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

        var query = ""
        if result != "" {
            query = "type beginswith[c] '\(result)'"
        }
        
        if(sltTxtFidOrDroDownIdx == 1){
            arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserAccType", query: query == "" ? nil : query) as! [UserAccType]
            
            if(self.arrOfShowData.count > 0){
                if optionalVw == nil {
                    self.openDwopDown( txtField: textField, arr: arrOfShowData)
                }else{
                    self.optionalVw?.table_View?.reloadData()
                }
            }else{
                self.removeOptionalView()
            }
        }
       
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sltTxtField.resignFirstResponder()
        return true
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
 
    //==========================
    //MARK:- Open OptionalView
    //==========================
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
        
            self.arrOfShowData.removeAll()
          
        }
    }
    
    
    //=====================================
    // MARK:- Get Account Type Service
    //=====================================
    
    func getAccounttype(){
     
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
                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
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
              //  DatabaseClass.shared.saveEntity()
            }else{
                let userJobs = DatabaseClass.shared.createEntity(entityName: "UserAccType")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
               // DatabaseClass.shared.saveEntity()
            }
        }
        
         DatabaseClass.shared.saveEntity(callback: {_ in})
    }

    //================================================
    // MARK:- Call service to update Client details
    //=================================================
    func updateClientDetails(){
    
        param.cltId = clientDetail?.cltId
        param.nm = trimString(string:  txtClientName.text!)
        param.pymtType = clientDetail?.pymtType
        param.adr = clientDetail?.adr
        param.city = clientDetail?.city
        param.state = clientDetail?.state
        param.ctry = clientDetail?.ctry
        param.gstNo = trimString(string:  txtGSTno.text!)
        param.tinNo = trimString(string:  txtTINno.text!)
        param.industry = txtIndustry.text
        param.note = trimString(string:  txtView.text!) 
        param.isactive = btnActive.imageView?.image == UIImage.init(named: "radio-selected") ? "1" : "0"
        param.lat = latitute.text
        param.lng = longitute.text
        
        //CHANGE in LOCAL DATABASE
        self.clientDetail?.setValuesForKeys(param.toDictionary!)
        DatabaseClass.shared.saveEntity(callback: {isSuccess in
            showToast(message: AlertMessage.clientUpdate) // Alert msgs
            
            DatabaseClass.shared.saveOffline(service: Service.updateClient, param: param)
            self.navigationController?.popViewController(animated: true)
        })
        
    }
   
    @IBAction func statusButtonPressed(_ sender: UIButton) {
        
        let tag = sender.tag
        
        switch tag {
        case 0:
            btnDeactive.setImage(UIImage(named:"radio_unselected"), for: .normal)
            btnActive.setImage(UIImage(named:"radio-selected"), for: .normal)
            break
        default:
            btnActive.setImage(UIImage(named:"radio_unselected"), for: .normal)
            btnDeactive.setImage(UIImage(named:"radio-selected"), for: .normal)
            break
        }
     }
   
    //========================================
    //MARK:-  Key Board notification method
    //========================================
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //var userInfo = notification.userInfo!
            var keyboardFrame:CGRect = keyboardSize
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var visibleRect = self.view.frame;
            visibleRect.size.height -= keyboardFrame.size.height;
            var frameFrmScrollView : CGRect?
            var frameFrmView : CGRect?
            
            if(isTxtView){
                self.removeOptionalView()
                self.sltTxtField = UITextField()
                frameFrmScrollView = self.txtView.convert(self.txtView.bounds, to:self.scroll_View)
                frameFrmView = self.txtView.convert(self.txtView.bounds, to:self.view)
                frameFrmView?.origin.y +=  self.txtView.frame.size.height
                if(visibleRect.size.height <= (frameFrmView?.origin.y)!){
                    let scrollPoint = CGPoint(x: 0.0, y: (((frameFrmScrollView?.origin.y)! + (frameFrmScrollView?.size.height)! + 80) - visibleRect.size.height))
                    self.scroll_View.setContentOffset(scrollPoint, animated: true)
                    
                }
                
            }else{
                
                if self.sltTxtField.isEqual(txtAccType) {
                    
                    frameFrmScrollView = self.bgView_AccTyp.convert(self.bgView_AccTyp.bounds, to:self.scroll_View)
                    frameFrmScrollView?.origin.y += 150.0  // 150 DropDown Height
                    
                    frameFrmView = self.bgView_AccTyp.convert(self.bgView_AccTyp.bounds, to:self.view)
                    frameFrmView?.origin.y += (150.0 + self.bgView_AccTyp.frame.size.height)
                }else if self.sltTxtField.isEqual(txtIndustry){
                    frameFrmScrollView = self.bgView_Ibdustry.convert(self.bgView_Ibdustry.bounds, to:self.scroll_View)
                    frameFrmScrollView?.origin.y += 150.0  // 150 DropDown Height
                    
                    frameFrmView = self.bgView_Ibdustry.convert(self.bgView_Ibdustry.bounds, to:self.view)
                    frameFrmView?.origin.y += (150.0 + self.bgView_Ibdustry.frame.size.height)
                    
                }else{
                    frameFrmScrollView = self.sltTxtField.convert(self.sltTxtField.bounds, to:self.scroll_View)
                    frameFrmView = self.sltTxtField.convert(self.sltTxtField.bounds, to:self.view)
                    frameFrmView?.origin.y +=  self.sltTxtField.frame.size.height
                    
                }
                
                if(visibleRect.size.height <= (frameFrmView?.origin.y)!){
                    let scrollPoint = CGPoint(x: 0.0, y: (((frameFrmScrollView?.origin.y)! + (frameFrmScrollView?.size.height)!) - visibleRect.size.height))
                    self.scroll_View.setContentOffset(scrollPoint, animated: true)
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 0.3 Time Delay
                    self.openDropDownWhenKeyBordappere()
                    
                }
                
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.removeOptionalView()
        self.scroll_View.setContentOffset(.zero, animated: true)

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
    
    //=====================================
       // MARK:- Get getIndustryList Type Service
       //=====================================
       
       func getIndustryList(){
      
           if !isHaveNetowork() {
               return
           }
           
           
           let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getIndustryList) as? String
           
           let param = Params()
           param.compId = getUserDetails()?.compId
           param.limit = "120"
           param.index = "0"
           param.search = ""
           param.dateTime = currentDateTime24HrsFormate()
       
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
               let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "IndustryList", query: query) as! [UserAccType]
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
}
