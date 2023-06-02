//
//  ClientVC.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 08/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import CoreData
@available(iOS 13.0, *)
class ClientVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate ,SWRevealViewControllerDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var lblClient: UILabel!
    @IBOutlet weak var txtSearchField: UITextField!
    @IBOutlet var extraButton: UIBarButtonItem!
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    var isFilter = Bool()
    var filterArry = [ClientList]()
    var arrOfShowData = [ClientList]()
    var arrOfShowDataMob1 = [ClientContactList]()
    var arrOFUserData = [UserJobList]()
    var isAdded = Bool()
    var isChanged = Bool()
    var selectedCell : IndexPath? = nil
    var refreshControl = UIRefreshControl()
    var jobTabVC : JobTabController?
    var arrayEqId = [String]()
    var ssd = "false"
    var count : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getClientSiteSink()
        getClientContactSink()
        getIndustryList()
         var ssd = "false"
        getIndustryList()
     
        lblClient.text = LanguageKey.empty_client_list
       

        
        isAdded = true
        isChanged = true
        self.getAccounttype()
        
        DatabaseClass.shared.callbackForClientVC = {( isReload : Bool?) -> Void in
            if(isReload)!{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.getClientSink()
                }
            }
        }


         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearchField.frame.height))
        txtSearchField.leftView = paddingView
        txtSearchField.leftViewMode = UITextField.ViewMode.always
        
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtSearchField.frame.height))
        txtSearchField.rightView = paddingView1
        txtSearchField.rightViewMode = UITextField.ViewMode.always
        
      
        
        if let revealController = self.revealViewController(){
            revealViewController().delegate = self
            extraButton.target = revealViewController()
            extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealController.tapGestureRecognizer()
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
         arrOFUserData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: nil) as! [UserJobList]
         setLocalization()
        
        
        ActivityLog(module:Modules.client.rawValue , message: ActivityMessages.clientList)
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.clients
        txtSearchField.placeholder = LanguageKey.search
               
    }
    
    @objc func refreshControllerMethod() {
       getClientSink()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         tableView.reloadData()
         self.getClientListFromDB()
    }
    
    
    //=======================
    // Disable Pan gesture
    //========================
    func revealControllerPanGestureShouldBegin(_ revealController: SWRevealViewController!) -> Bool {
        return false
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
          if position == .left {
              setLocalization()
              //getClientSink()
          }
      }
    
    
    //=======================
    // TableView methods
    //========================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrOfShowData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ClientCell
        
        let clientDetails = self.arrOfShowData[indexPath.row]
        cell.nameLbl?.text = clientDetails.nm?.capitalizingFirstLetter()
         
        let query = "cltId = '\(clientDetails.cltId!)' && def = 1"

         let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as? [ClientSitList]
        if isExist != nil && isExist!.count > 0  {
            let cltSiteDetails = isExist![0]
                let address = cltSiteDetails.adr?.capitalizingFirstLetter()
                    cell.addressLbl?.attributedText =  lineSpacing(string: address!, lineSpacing: 7.0)
        }else{
             cell.addressLbl?.text = ""
        }
        
        
        let ladksj  = clientDetails.cltId!.components(separatedBy: "-")
        
        if ladksj.count > 0 {
            let tempId = ladksj[0]

                cell.arrowImage.isHidden = false
                cell.isUserInteractionEnabled = true
                
                cell.nameLbl?.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                cell.addressLbl.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
          
        }else{
            cell.arrowImage.isHidden = false
            cell.isUserInteractionEnabled = true
            
            cell.nameLbl?.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            cell.addressLbl.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            
            
        }
        
        if selectedCell == indexPath {
            cell.viw.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        }else{
            cell.viw.backgroundColor = UIColor.white
        }
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (selectedCell != nil) {
            //If selected cell exist on visible indexpaths
            let isExist = tableView.indexPathsForVisibleRows?.contains(selectedCell!)
            if isExist!{
                let cellPrevious = tableView.cellForRow(at: selectedCell!) as! ClientCell
                    cellPrevious.viw.backgroundColor = .white
            }
        }

        let cell = tableView.cellForRow(at: indexPath) as! ClientCell
        cell.viw.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.selectedCell = indexPath
        
        performSegue(withIdentifier: "clientTabs", sender: indexPath)
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "clientTabs"{
            if let indexPath = tableView.indexPathForSelectedRow {
                let clinttabbarVC = segue.destination as! ClientTabController
                clinttabbarVC.objOFClintTabBar = self.arrOfShowData[indexPath.row]
            }
        }else if segue.identifier == "AddClient"{
            let addContact = segue.destination as! AddClientVC
            addContact.callbackForClientVC = {(isBack : Bool) -> Void in
                self.isAdded = true
                self.isChanged =  false
            }
         }
    }
    
    
    //==========================
    // MARK:- Textfield methods
    //==========================
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if result.count > 2 || result.count == 0 {
            var query = ""
            
            var str = result

            let decimalCharacters = CharacterSet.decimalDigits

            let decimalRange = str.rangeOfCharacter(from: decimalCharacters)

            if decimalRange != nil {
                if result != "" {
                  
                    query = "mob1 CONTAINS[c] '\(result)'"
                    // query = "mob2 CONTAINS[c] '\(result)'"
                    ssd = "true"
                    
                     showDataOnTableView(query: query == "" ? nil : query)
                }
             //   print("Numbers found")
            }else{
                if result != "" {
                    query = "nm CONTAINS[c] '\(result)'"
                    ssd = "false"
                     showDataOnTableView(query: query == "" ? nil : query)
                }
               // print("String found")
            }

        }else{
            self.showDataOnTableView(query:nil)
        }
        
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
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
                      //  if decodedData.data.count > 0 {
                            
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
                            
                            
//                            //Request time will be update when data comes otherwise time won't be update
//                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getAccType)
//                                self.saveAccTypeInDB(data: decodedData.data )
                     //   }
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
               // DatabaseClass.shared.saveEntity()
            }else{
                let userJobs = DatabaseClass.shared.createEntity(entityName: "UserAccType")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
               // DatabaseClass.shared.saveEntity()
            }
        }
        
         DatabaseClass.shared.saveEntity(callback: {_ in})
    }
    

//=====================================
// MARK:- Get Clint List Service
//=====================================
    
    func getClientSink(){
        
//        var isChangeTime = ""
//        var upTime = ""
//        var lastTime =  ""
//        
//        
//        if isChangeTime == "true" {
//            let UpdateRequestTime : String? = upTime
//        }else if  isChangeTime == "false"{
//           // isChangeTime = "false"
//            let UpdateRequestTime : String? =  UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSink) as? String
//        }else{
//            let UpdateRequestTime : String? =  UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSink) as? String
//        }
//       
        
        if !isHaveNetowork() {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            return
        }
        
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientSink) as? String

        
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "0"
        param.search = ""
        param.isactive = ""
        

        param.dateTime = lastRequestTime ?? ""
   //  print("-----------==================lastRequestTime>>>>>>>>>>>>>>. \(lastRequestTime ?? "")")
        


       
        serverCommunicator(url: Service.getClientSink, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                
                if let decodedData = try? decoder.decode(ClientResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        
                        if decodedData.data.count > 0 {
                            
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSink)
//print("-----------==================updateRequestTime>>>>>>>>>>>>>>. \( UserDefaults.standard.value(forKey: Service.getClientSink) as? String)")
                            self.saveClintInDataBase(data: decodedData.data)
                            self.getClientSiteSink()
                        }else{
                            if self.arrOfShowData.count == 0{
                                DispatchQueue.main.async {
                                    self.tableView.isHidden = true
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
     func saveClintInDataBase( data : [ClientListData]) -> Void {
        
        for jobs in data{
            let query = "cltId = '\(jobs.cltId!)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as! [ClientList]
            if isExist.count > 0 {
                    if(jobs.isdelete == "0"){
                        let existingJob = isExist[0]
                        DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                    }else{
                        let existingJob = isExist[0]
                        existingJob.setValuesForKeys(jobs.toDictionary!)
                        //DatabaseClass.shared.saveEntity()
                      }
            }else{
                if(jobs.isdelete != "0"){
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientList")
                    userJobs?.setValuesForKeys(jobs.toDictionary!)
                    //DatabaseClass.shared.saveEntity()
                    
                    let query = "cltId = '\(jobs.tempId!)'"
                    let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as! [ClientList]
                    if isExistJob.count > 0 {
                        let existing = isExistJob[0]
                        DatabaseClass.shared.deleteEntity(object: existing, callback: { (_) in})
                    }
                }
            }
        }
        
        DatabaseClass.shared.saveEntity(callback: { _ in
            showDataOnTableView(query: nil)
        })
    }
        
    
        
    //=======================
    // MARK:- Other methods
    //=======================
     func getClientListFromDB() -> Void {
        
        if isAdded {
            showDataOnTableView(query: nil)
        }
       
        if isChanged {
            self.getClientSink()
        }
        
        isChanged = true
        isAdded = false
     }
   
    
    //=====================================
    // MARK:- Get Clint Sit List  Service
    //=====================================
    
    func getClientSiteSink(){
        
        if !isHaveNetowork() {
            return
        }
        
        let param = Params()
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientSiteSink) as? String
        
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = ""
        param.dateTime = lastRequestTime //currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
        
        
        serverCommunicator(url: Service.getClientSiteSink, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(SiteVCResp.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data.count > 0 {
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSiteSink)
                            self.saveSiteInDataBase(data: decodedData.data)
                        }
                      
                        self.getClientContactSink()
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
                //  ShowAlert(title: "Network Error", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertControllerStyle.alert, callback: {_,_ in})
            }
        }
    }
    
    //==============================
    // MARK:- Save data in DataBase
    //==============================
    func saveSiteInDataBase( data : [SiteVCRespDetails] ) -> Void {
        for jobs in data{
            let query = "siteId = '\(jobs.siteId!)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
            if isExist.count > 0 {
                if(jobs.isdelete == "0"){
                    let existingJob = isExist[0]
                    DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                }else{
                    let existingJob = isExist[0]
                    existingJob.setValuesForKeys(jobs.toDictionary!)
                   // DatabaseClass.shared.saveEntity()
                }
            }else{
                if(jobs.isdelete != "0"){
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
                    userJobs?.setValuesForKeys(jobs.toDictionary!)
                   // DatabaseClass.shared.saveEntity()
                }
            }
        }
        
        DatabaseClass.shared.saveEntity(callback: { _ in })
    }
    
    //=====================================
    // MARK:- Get Contact List  Service
    //=====================================

    func getClientContactSink(){
        
        if !isHaveNetowork() {
            return
        }

        let param = Params()
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientContactSink) as? String

        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = ""
        param.dateTime = lastRequestTime ?? ""

        serverCommunicator(url: Service.getClientContactSink, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ContactResps.self, from: response as! Data) {
                    if decodedData.success == true{

                        //DatabaseClass.shared.saveEntity()
                        
                        if decodedData.data.count > 0 {
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientContactSink)
                            self.saveUserContactInDataBase(data: decodedData.data)
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
        //  }
    }

    //==============================
    // MARK:- Save contact data in DataBase
    //==============================
    func saveUserContactInDataBase( data : [ContactRespsDetails]) -> Void {

        for jobs in data{
            let query = "conId = '\(jobs.conId!)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
            if isExist.count > 0 {

                if(jobs.isdelete == "0"){
                    let existingJob = isExist[0]
                    DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                }else{
                    let existingJob = isExist[0]
                    existingJob.setValuesForKeys(jobs.toDictionary!)
                   // DatabaseClass.shared.saveEntity()
                }

            }else{
                if(jobs.isdelete != "0"){

                    let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientContactList")
                    userJobs?.setValuesForKeys(jobs.toDictionary!)
                    //DatabaseClass.shared.saveEntity()
                }
            }
        }
        
        DatabaseClass.shared.saveEntity(callback: { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    func showDataOnTableView(query : String?) -> Void {
        
        ///
        
            if ssd == "true"{
                
                arrOfShowDataMob1 = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
                 if arrOfShowDataMob1.count != 0 {
        arrOfShowDataMob1 =  arrOfShowDataMob1.sorted { $0.mob1?.localizedCaseInsensitiveCompare($1.mob1!) == ComparisonResult.orderedAscending }
                    
                    
                    ///////////////////////////////////////////////////////////////////////////
                    let aaa:String? = nil
                    arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: aaa) as! [ClientList]
                    
                    var seen = Set<String>()
                    var newData = [ClientList]()
                    for message in arrOfShowData {
                        if !seen.contains(message.cltId!) {
                            newData.append(message)
                            seen.insert(message.cltId!)
                        }
                    }
                    
                    arrOfShowData.removeAll()
                    arrOfShowData = newData
                    
                    if arrOfShowDataMob1.count > 0{
                                 for (index, job) in arrOfShowDataMob1.enumerated() {
                                     
                                     
                                     let match = arrOfShowData.first( where: {job.cltId == $0.cltId} )
                               //     print(match)
                                    if match != nil{
                                       // arrOfShowData = match
                                        arrOfShowData.removeAll()
                                     arrOfShowData.append(match!)
                                    }
                                    //
                                      // arrOfShowData = match
                                    
                                    }
                    }
                    /////////////////////////////////////////////////////////////////////////
               // print(arrOfShowDataMob1)
                DispatchQueue.main.async {
                                self.tableView.reloadData()
                                        }
            }
                DispatchQueue.main.async {
                    self.tableView.isHidden = self.arrOfShowData.count > 0 ? false : true
                }
                
                
            
        }
            
            if ssd == "false"{
                arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as! [ClientList]
                
                var seen = Set<String>()
                var newData = [ClientList]()
                for message in arrOfShowData {
                    if !seen.contains(message.cltId!) {
                        newData.append(message)
                        seen.insert(message.cltId!)
                    }
                }
                
                arrOfShowData.removeAll()
                arrOfShowData = newData
                  if arrOfShowData.count != 0 {
                arrOfShowData =  arrOfShowData.sorted { $0.nm?.localizedCaseInsensitiveCompare($1.nm!) == ComparisonResult.orderedAscending }
                  //  print(arrOfShowData)
                DispatchQueue.main.async {
                               self.tableView.reloadData()
                           }
            }
            
           DispatchQueue.main.async {
               self.tableView.isHidden = self.arrOfShowData.count > 0 ? false : true
           }
           
        }
        ////
//        }else{
//            lblClient.isHidden =  true
//        }
        
    }
    
//    @objc func chatfNotiHandle(_ notification: NSNotification){
//        if let dict = notification.userInfo as? [String : Any]{
//            let storyBoard : UIStoryboard = UIStoryboard(name: "MainJob", bundle:nil)
//            if jobTabVC != nil {
//                jobTabVC!.navigationController?.popViewController(animated: false)
//            }
//            
//            jobTabVC = (storyBoard.instantiateViewController(withIdentifier: "jobTab") as! JobTabController)
//            jobTabVC!.jobs = arrOFUserData
//            
////            let currentJob = arrOFUserData.filter { (model) -> Bool in
////                if model.jobId == (dict["jobId"] as! String) {
////                    return true
////                }
////                return false
////            }
//            let query = "jobId = '\(dict["jobId"]!)'"
//            let currentJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
//            
//            if currentJob.count > 0 {
//                jobTabVC!.objOfUserJobList = currentJob[0]
//                jobTabVC!.isChatTabSelected = true
//                jobTabVC!.callback =  {(isDelete : Bool, object : NSManagedObject) -> Void in
//                    if isDelete{
//                        self.jobTabVC!.navigationController?.popViewController(animated: true)
//                    }
//                }
//                DispatchQueue.main.async {
//                    let controller = self.topMostViewController()
//                    controller.navigationController?.pushViewController(self.jobTabVC!, animated: true)
//                }
//            }else {
//                let mess = AlertMessage.sorryThisJobNoLonger
//                let newString = mess.replacingOccurrences(of: EOT_VAR, with: "'\(dict["jobCode"] as! String)'")
//                ShowError(message: newString, controller: windowController)
//
//            }
//        }
//    }
//    
//    @objc func clientChatNotiHandle(_ notification: NSNotification){
//        if let dict = notification.userInfo as? [String : Any]{
//            let vc = UIStoryboard.init(name: "MainClientChat", bundle: Bundle.main).instantiateViewController(withIdentifier: "CLIENTCHATE") as? ClientChatVC
//            
//            let query = "jobId = '\(dict["jobId"]!)'"
//            let currentJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
//            
//            if currentJob.count > 0 {
//                vc!.objOfUserJobListInDetail = currentJob[0]
//                DispatchQueue.main.async {
//                    self.navigationController?.pushViewController(vc!, animated: true)
//                }
//            }
//        }
//    }
    
    
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
              param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
          
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
                          //  print(self.arrOfReferenceList.count)
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
    
    
    
    
}//END

//========================FORNOTIFICATION===================================
//          self.responceaddjob = decodedData.data!
//          //let jobNoti = decodedData.data as! [dataDetail]
//
//            let jobCod = self.responceaddjob.label
//            let message = ChatMessageModelForJob()
//            let message1 = ChatMessageModel()
//             message.usrid = self.responceaddjob.kpr
//             message.action = "AddClient"
//             message.msg = "A new Client has been created in the system with Client Name \(jobCod)."
//             message.usrnm = "Alex"
//             message.usrType = "2"
//             message.id =  self.responceaddjob.jobId
//             message.type = "CLIENT"
//
//            ChatManager.shared.sendClientdMessageForJob(jobid: self.responceaddjob.jobId ?? "", messageDict: message)
          //  self.navigationController?.popToRootViewController(animated: true)
             // self.sendImageOnFireStoreforjob()
          
          //==========================
