//
//  SiteVC.swift
//  EyeOnTask
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class SiteVC: UIViewController, UITableViewDataSource, UITableViewDelegate , UITextFieldDelegate {
    var objOFSitVC : ClientList?
    @IBOutlet weak var txtSearchField: UITextField!
    @IBOutlet var tableView: UITableView!
    var arrOfShowData = [ClientSitList]()
    var isAdded = Bool()
    var isChanged = Bool()
    var selectedCell : IndexPath? = nil
    var refreshControl = UIRefreshControl()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        isAdded = true
        isChanged = true
        
        
        DatabaseClass.shared.callbackForSiteVC = {( isReload : Bool?) -> Void in
            if(isReload)!{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.getClientSiteSink()
                }
            }
        }

        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearchField.frame.height))
        txtSearchField.leftView = paddingView
        txtSearchField.leftViewMode = UITextField.ViewMode.always
        
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtSearchField.frame.height))
        txtSearchField.rightView = paddingView1
        txtSearchField.rightViewMode = UITextField.ViewMode.always
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // Do any additional setup after loading the view.
        
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        setLocalization()
        
        ActivityLog(module:Modules.site.rawValue , message: ActivityMessages.clientSiteList)

    }
    
    
    func setLocalization() -> Void {
        
       // self.navigationItem.title = LanguageKey.sites_screen_title
        txtSearchField.placeholder = LanguageKey.search 
    
    }
    
    @objc func refreshControllerMethod() {
        getClientSiteSink()
    }

    override func viewWillAppear(_ animated: Bool) {
        
          
        
         self.parent?.title = LanguageKey.sites_screen_title
//        self.parent?.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
//        self.parent?.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let image = UIImage(named:"add.png")
//        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = true
            button.tintColor = UIColor.white
            self.parent?.navigationItem.rightBarButtonItem?.target = self
            self.parent?.navigationItem.rightBarButtonItem?.action = #selector(addTapped)
            self.parent?.navigationItem.rightBarButtonItem?.image = image
        }else{
            self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        }
        
        
        self.getClintSitListFrmDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    @objc func addTapped() -> Void {
        performSegue(withIdentifier: "AddSite", sender: nil)
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfShowData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SiteCell
        
        let site = self.arrOfShowData[indexPath.row]

        
        
        if let addressString = site.adr {
            let address = addressString.capitalizingFirstLetter()
            cell.lblAddress?.attributedText =  lineSpacing(string: address, lineSpacing: 7.0)
        }else{
            cell.lblAddress?.text = ""
        }
        
        
        if selectedCell == indexPath {
            cell.viw.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        }else{
            cell.viw.backgroundColor = UIColor.white
        }
        
        
        let ladksj  = site.siteId!.components(separatedBy: "-")
        
        if ladksj.count > 0 {
            let tempId = ladksj[0]
            if tempId == "Site" {
                cell.lblAddress?.textColor = UIColor.red
                cell.lblAddress.text = LanguageKey.site_not_sync
                cell.lblSiteName?.textColor = UIColor.lightGray
                cell.isUserInteractionEnabled = false
                cell.arrowImage.isHidden = true
            }else{
                cell.arrowImage.isHidden = false
                cell.isUserInteractionEnabled = true
                
                cell.lblSiteName?.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                cell.lblAddress.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            }
        }else{
            cell.arrowImage.isHidden = false
            cell.isUserInteractionEnabled = true
            
            cell.lblSiteName?.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            cell.lblAddress.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            
            if selectedCell == indexPath {
                cell.viw.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            }else{
                cell.viw.backgroundColor = UIColor.white
            }
        }
        
        
        if site.def == "1" {
            cell.lblSiteName?.text  = (site.snm?.capitalizingFirstLetter())! + " (Default)"
        }else{
            cell.lblSiteName?.text = site.snm?.capitalizingFirstLetter()
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (selectedCell != nil) {
            
            //If selected cell exist on visible indexpaths
            let isExist = tableView.indexPathsForVisibleRows?.contains(selectedCell!)
            if isExist!{
                let cellPrevious = tableView.cellForRow(at: selectedCell!) as! SiteCell
                cellPrevious.viw.backgroundColor = .white
            }
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! SiteCell
        cell.viw.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.selectedCell = indexPath
        
        //performSegue(withIdentifier: "clientTabs", sender: indexPath)
    }
    
    //==========================
    // MARK:- Textfield methods
    //==========================
    
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
    
     var query = ""
    if result.count > 2 || result.count == 0 {
        if result != "" {
            query = "snm CONTAINS[c] '\(result)' AND cltId = '\(objOFSitVC?.cltId! ?? "")'"
        }
        
        showDataOnTableView(query: query == "" ? nil : query)
     }
       return true
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 3 { // set your total tabs here
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditSite"{
            if let indexPath = tableView.indexPathForSelectedRow {
                let editSiteVC = segue.destination as! EditSiteVC
                editSiteVC.objOFEditSiteVC = self.arrOfShowData[indexPath.row]
                editSiteVC.sltIdex = indexPath.row
                editSiteVC.objOFClient = objOFSitVC
                editSiteVC.callbackForSiteVC = {(isDefault : Bool,result : Int) -> Void in
                    
                    self.isChanged =  false
                    
                    if isDefault{
                        for (index, obj) in self.arrOfShowData.enumerated(){
                            if(index != result){
                                DispatchQueue.main.async {
                                    obj.def = "0"
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }else if segue.identifier == "AddSite"{
            let addSiteVC = segue.destination as! AddSite
            addSiteVC.objOFClient = objOFSitVC
            addSiteVC.callbackForSiteVC = {(isBack : Bool, isDefault : Bool) -> Void in
                
                self.isAdded = true
                self.isChanged =  false
                
                if isDefault {
                    for (_, obj) in self.arrOfShowData.enumerated(){
                        DispatchQueue.main.async {
                            obj.def = "0"
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    //=====================================
    // MARK:- Get Clint Sit List  Service
    //=====================================
    
    func getClientSiteSink(){
        
        if !isHaveNetowork() {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            return
        }
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientSiteSink) as? String

 
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "0"
        param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
    
        serverCommunicator(url: Service.getClientSiteSink, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                
                if let decodedData = try? decoder.decode(SiteVCResp.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                       if decodedData.data.count > 0 {
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSiteSink)
                            self.saveSiteInDataBase(data: decodedData.data)
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
    
    //==============================
    // MARK:- Save data in DataBase
    //==============================
    func saveSiteInDataBase( data : [SiteVCRespDetails]) -> Void {
        
    
        for jobs in data{
            let query = "siteId = '\(jobs.siteId!)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
            
            if jobs.def == "1" && objOFSitVC?.cltId == jobs.cltId{
                objOFSitVC?.adr = jobs.adr
                if jobs.def == "1"{
                    for (_, obj) in self.arrOfShowData.enumerated(){
                            DispatchQueue.main.async {
                                obj.def = "0"
                            }
                    }
                }
            }
            
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
                  let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
                   userJobs?.setValuesForKeys(jobs.toDictionary!)
                   // DatabaseClass.shared.saveEntity()
                    
                    let query = "siteId = '\(jobs.tempId!)'"
                    let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
                    
                    if isExistJob.count > 0 {
                        let existing = isExistJob[0]
                        DatabaseClass.shared.deleteEntity(object: existing, callback: { (_) in})
                    }
                    
                    
                }
            }
        }
        
        DatabaseClass.shared.saveEntity(callback: { isSuccess in
            showDataOnTableView(query: nil)
        })
    }
    
    
    //=======================
    // MARK:- Other methods
    //=======================
    func getClintSitListFrmDB() -> Void {

        if isAdded {
             showDataOnTableView(query: nil)
        }
        
        if isChanged {
            getClientSiteSink()
        }
        
        isChanged = true
        isAdded = false
    }
    
    func showDataOnTableView(query : String?) -> Void {
        arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query == nil ? NSString(format:"cltId == '%@'", (objOFSitVC?.cltId)!) as String : query) as! [ClientSitList]
        var seen = Set<String>()
                           var newData = [ClientSitList]()
                           for message in arrOfShowData {
                               if !seen.contains(message.snm!) {
                                   newData.append(message)
                                   seen.insert(message.snm!)
                               }
                           }
                           
                           arrOfShowData.removeAll()
                           arrOfShowData = newData
        
        if arrOfShowData.count != 0 {
            arrOfShowData =  arrOfShowData.sorted { $0.snm?.localizedCaseInsensitiveCompare($1.snm!) == ComparisonResult.orderedAscending }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.isHidden = self.arrOfShowData.count > 0 ? false : true
        }
    }
    
    
    
}
