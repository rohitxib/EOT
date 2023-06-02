//
//  ContactVC.swift
//  EyeOnTask
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class ContactVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet var table_view: UITableView!
    @IBOutlet weak var txtSearchfield: UITextField!
    var objOFContactVC : ClientList?
    var arrOfShowData = [ClientContactList]()
    var isAdded = Bool()
    var isChanged = Bool()
    var selectedCell : IndexPath? = nil
    var refreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isAdded = true
        isChanged = true
        
        DatabaseClass.shared.callbackForContactVC = {( isReload : Bool?) -> Void in
            if(isReload)!{
                DispatchQueue.main.async {
                    self.table_view.reloadData()
                    self.getClientContactSink()
                }
            }
        }

        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearchfield.frame.height))
        txtSearchfield.leftView = paddingView
        txtSearchfield.leftViewMode = UITextField.ViewMode.always
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtSearchfield.frame.height))
        txtSearchfield.rightView = paddingView1
        txtSearchfield.rightViewMode = UITextField.ViewMode.always
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        table_view.addSubview(refreshControl) // not required when using UITableViewController
        
        setLocalization()
        
        ActivityLog(module:Modules.contact.rawValue , message: ActivityMessages.clientContactList)

        
    }
    
    func setLocalization() -> Void {
       // self.navigationItem.title = LanguageKey.contacts_screen_title
        txtSearchfield.placeholder = LanguageKey.search 
    }
    
    
    @objc func refreshControllerMethod() {
        getClientContactSink()
    }
    
    @objc func addTapped() -> Void {
        performSegue(withIdentifier: "AddContact", sender: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
            self.parent?.title = LanguageKey.contacts_screen_title
            let image = UIImage(named:"add.png")
           // self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = true
            button.tintColor = UIColor.white
            self.parent?.navigationItem.rightBarButtonItem?.target = self
            self.parent?.navigationItem.rightBarButtonItem?.action = #selector(addTapped)
            self.parent?.navigationItem.rightBarButtonItem?.image = image
        }else{
            self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        }
        
        
          self.getClintContectListFrmDB()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfShowData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactCell
        
        let contact = self.arrOfShowData[indexPath.row]
        
        
        
       // print(" name == \(contact.cnm)")
        
        
       
        cell.contactNoLbl?.text = contact.mob1
        
        
        if selectedCell == indexPath {
            cell.viw.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        }else{
            cell.viw.backgroundColor = UIColor.white
        }
        
        
        
        let ladksj  = contact.conId!.components(separatedBy: "-")
        
        if ladksj.count > 0 {
            let tempId = ladksj[0]
            if tempId == "Con" {
                cell.contactNoLbl?.textColor = UIColor.red
                cell.contactNoLbl.text = LanguageKey.site_not_sync
                cell.nameLbl?.textColor = UIColor.lightGray
                cell.isUserInteractionEnabled = false
                cell.arrowImage.isHidden = true
            }else{
                cell.arrowImage.isHidden = false
                cell.isUserInteractionEnabled = true
                
                cell.nameLbl?.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                cell.contactNoLbl.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            }
        }else{
            cell.arrowImage.isHidden = false
            cell.isUserInteractionEnabled = true
            
            cell.nameLbl?.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            cell.contactNoLbl.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            
            if selectedCell == indexPath {
                cell.viw.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            }else{
                cell.viw.backgroundColor = UIColor.white
            }
        }
        
        
        if contact.def == "1" {
            cell.nameLbl?.text = (contact.cnm?.capitalizingFirstLetter())! + " (Default)"
        }else{
            cell.nameLbl?.text = contact.cnm?.capitalizingFirstLetter()
        }
        
        
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (selectedCell != nil) {
            //If selected cell exist on visible indexpaths
            let isExist = tableView.indexPathsForVisibleRows?.contains(selectedCell!)
            if isExist!{
                let cellPrevious = tableView.cellForRow(at: selectedCell!) as! ContactCell
                cellPrevious.viw.backgroundColor = .white
            }
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        cell.viw.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.selectedCell = indexPath
        
        //performSegue(withIdentifier: "clientTabs", sender: indexPath)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //==========================
    // MARK:- Textfield methods
    //==========================
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        var query = ""
        if result.count > 2 || result.count == 0 {
            if result != "" {
                query = "cnm CONTAINS[c] '\(result)' AND cltId = '\(objOFContactVC?.cltId! ?? "")'"
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
        
         if segue.identifier == "EditContact"{
            if let indexPath = table_view.indexPathForSelectedRow {
                let editContactVC = segue.destination as! EditContactVC
                editContactVC.objOFEditContactVC = self.arrOfShowData[indexPath.row]
                editContactVC.objOFClient = objOFContactVC
                editContactVC.sltIdex = indexPath.row
                editContactVC.callbackForContactVC = {(isDefault : Bool,result : Int) -> Void in
                    self.isChanged =  false
                    if isDefault{
                        for (index, obj) in self.arrOfShowData.enumerated(){
                            if(index != result){
                                //DispatchQueue.main.async {
                                    obj.def = "0"
                                //}
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.table_view.reloadData()
                    }
                }
            }
        }else if segue.identifier == "AddContact"{
            let addContact = segue.destination as! AddContact
            addContact.objOFClient = objOFContactVC
            addContact.callbackForContactVC = {(isBack : Bool, isDefault : Bool) -> Void in
                
                self.isAdded = true
                self.isChanged =  false
                
                if isDefault {
                    for (_, obj) in self.arrOfShowData.enumerated(){
                       // DispatchQueue.main.async {
                            obj.def = "0"
                        //}
                    }
                }
                
                DispatchQueue.main.async {
                    self.table_view.reloadData()
                }
            }
        }
    }
    //=====================================
    // MARK:- Get Contact List  Service
    //=====================================
    
    func getClientContactSink(){
        
        if !isHaveNetowork() {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            return
        }
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientContactSink) as? String

        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "0"
        param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
    
        serverCommunicator(url: Service.getClientContactSink, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                
                if let decodedData = try? decoder.decode(ContactResps.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                       
                        if decodedData.data.count > 0 {
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientContactSink)
                            self.saveUserJobsInDataBase(data: decodedData.data)
                        }else{
                            if self.arrOfShowData.count == 0{
                                DispatchQueue.main.async {
                                    self.table_view.isHidden = true
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
    
    //==============================
    // MARK:- Save data in DataBase
    //==============================
    func saveUserJobsInDataBase( data : [ContactRespsDetails]) -> Void {
        
        for jobs in data{
            let query = "conId = '\(jobs.conId!)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
            if jobs.def == "1" && objOFContactVC?.cltId == jobs.cltId{
                for (_, obj) in self.arrOfShowData.enumerated(){
                       // DispatchQueue.main.async {
                            obj.def = "0"
                        //}
                }
            }
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
                    
                    let query = "conId = '\(jobs.tempId!)'"
                    let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
                    
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
    func getClintContectListFrmDB() -> Void {
     
      if isAdded {
            showDataOnTableView(query: nil)
        }
        
        if isChanged {
            getClientContactSink()
        }
        
        isChanged = true
        isAdded = false
    }
    
    func showDataOnTableView(query : String?) -> Void {
        arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query == nil ? NSString(format:"cltId == '%@'", (objOFContactVC?.cltId)!) as String : query) as! [ClientContactList]
//
        
        if arrOfShowData.count != 0 {
            arrOfShowData =  arrOfShowData.sorted { $0.cnm?.localizedCaseInsensitiveCompare($1.cnm!) == ComparisonResult.orderedAscending }
            DispatchQueue.main.async {
                self.table_view.reloadData()
            }
        }

        DispatchQueue.main.async {
            self.table_view.isHidden = self.arrOfShowData.count > 0 ? false : true
        }
    }
    
    
    
}
