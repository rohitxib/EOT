//
//  AllEquipmentVC.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 12/03/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class AllEquipmentVC: UIViewController,SWRevealViewControllerDelegate,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var extraBtn: UIBarButtonItem!
    @IBOutlet weak var tittleLbl: UILabel!
    @IBOutlet weak var eqpmtNotFound: UILabel!
    @IBOutlet weak var lblEqListNo: UILabel!
   
    var countList:String = ""
    var EquipmentsList = [AdminEquipListData]()
 
    
    @IBOutlet weak var img: UILabel!
    
    //=========================
    // MARK:- Initial methods
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        getAdminEquipementList()
        print("jugal")
        if let revealController = self.revealViewController(){
            revealViewController().delegate = self
            extraBtn.target = revealViewController()
            extraBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealController.tapGestureRecognizer()
        }
     //   self.lblEqListNo.text! = "\(LanguageKey.list_item) \(countList)"
        
        //             //   print(equipmentData)
        //                self.navigationItem.title = LanguageKey.detail_equipment
        //               // print(auditDetail)
        //               // print(objOfUserJobListInDetail)
        //                NotiyCenterClass.registerRefreshEquipmentListNotifier(vc: self, selector: #selector(equipmentHandler(_:)))
        //               // showLoader()
        //              // getEquipementListService()
        //
        //                setLocalization()
        //                refreshControl.attributedTitle = NSAttributedString(string: " ")
        //               // refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        //             //   tableView.addSubview(refreshControl) // not required when using UITableViewController
        //                ActivityLog(module:Modules.equipment.rawValue , message: ActivityMessages.auditEquipment)
        //                self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipmentData.count))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //                       setData()
        //                    self.tabBarController?.navigationItem.title = LanguageKey.detail_equipment//LanguageKey.title_documents
        //
        //                    tableView.estimatedRowHeight = 200
        //                    tableView.estimatedRowHeight = UITableView.automaticDimension
        //                    tableView.rowHeight = UITableView.automaticDimension
        
        //  tableView.reloadData()
    }
    
    
    //            func setData(){
    //                equipmentData.removeAll()
    //                let searchQuery = "jobId = '\(objOfUserJobListInDetails?.jobId ?? "")'"
    //                let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
    //                if isExist.count > 0{
    //                    objOfUserJobListInDetails!.equArray = isExist[0].equArray
    //                       if objOfUserJobListInDetails!.equArray != nil {
    //                        for item in (objOfUserJobListInDetails!.equArray as! [AnyObject]) {
    //                        if let dta = item as? equArray {
    //
    //                                                     //   print(dta)
    //
    //                        }else{
    //                            var arrTac = [AttechmentArry]()
    //
    //                           if item["attachments"] != nil {
    //
    //                            let attachments =  item["attachments"] as? [AnyObject]
    //                            if attachments?.count ?? 0 > 0 {
    //
    //                                for attechDic in attachments! {
    //                                  arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
    //                            }
    //    //                         for item in (objOfUserJobListInDetails!.equArray as! [AnyObject]) {
    //                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String)
    //                                    equipmentData.append(dic)
    //                                // print(equipmentDic.self)
    //
    //                                // if let dta = item as? equipData {
    //                                // }
    //                                }else {
    //                                         let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String)
    //                                             equipmentData.append(dic)
    //                            }
    //                            }
    //                            }
    //                            }
    //                            }
    //                }
    //                self.tableView.reloadData()
    //                self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipmentData.count))"
    //                var arr = self.equipmentData.count
    //                           if arr > 0  {
    //                            self.img.isHidden = true
    //                            self.eqpmtNotFound.isHidden = true
    //                            //   print("jugal 1")
    //                           }else{
    //                            self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
    //                              self.img.isHidden = false
    //                             self.eqpmtNotFound.isHidden = false
    //                              // print("jugal 0")
    //                           }
    //
    //            }
    
    //            @objc func equipmentHandler(_ notification: NSNotification){
    //                let userinfo = notification.userInfo
    //
    //                if let info = userinfo {
    //                    let equipment = equipments.filter({$0.equId == info["equId"] as? String})
    //                    if equipment.count == 1 {
    //                        let equp = equipment[0]
    //                        equp.status = info["status"] as? String
    //                        equp.remark = info["remark"] as? String
    //                    }
    //
    //                    DispatchQueue.main.async {
    //                        self.tableView.reloadData()
    //                    }
    //                }
    //            }
    
    //            func setLocalization() -> Void {
    //                self.lblEqListNo.text! = "\(LanguageKey.list_item) 0"
    //            }
    //
    //
    //            @objc func refreshControllerMethod(_ notification: NSNotification){
    //                count = 0
    //
    //               // equipments.removeAll()
    //               // self.getEquipementListService()
    //            }
    //
    
    
    
    
    
    //==========================
    // MARK:- Tableview methods
    //==========================
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        //return equipments.count
        return EquipmentsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quipmentCell",for: indexPath) as! EquipmentCell
        // let equipment = equipments[indexPath.row]
        
        //self.countList = EquipmentsList.count
        cell.btnDefaults.setTitle("  \(LanguageKey.equipment_btn)" , for: .normal)
        cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
        let modl = LanguageKey.model_no
        let serl = LanguageKey.serial_no
        
        let cond = LanguageKey.condition
        let remark = LanguageKey.remark
        let equipment = EquipmentsList[indexPath.row]
        
        //   if equipment.isPart == "0"{
        cell.lblName.text = equipment.equnm
        cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        //  }
        //  else{
        cell.lblName.text = equipment.equnm
        cell.lblName.textColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
        // }
        // cell.lblName.text = equipment.equnm
        cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
        cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
        //      cell.lblAddress.text = equipment.location
        
        //
        //                let status = Int((equipment.status)!) //getDefaultSettings()!.equipmentStatus
        //                           if status == 16 {
        //
        //                            cell.conditationLbl.text = "\(cond) : Good"
        //                           } else if status == 1038 {
        //
        //                             cell.conditationLbl.text = "\(cond) : Need to be Repaired"
        //                           }else if status == 1549 {
        //
        //                             cell.conditationLbl.text = "\(cond) : Not Working"
        //                           }else if status == 527 {
        //
        //                             cell.conditationLbl.text = "\(cond) : Poor"
        //                           }else{
        //                            cell.conditationLbl.text = "\(LanguageKey.condition):"
        //                }
        
        
        // cell.remarkLbl.text = "\(remark) : \(equipment.remark ?? "")"
        
        
        //
        // if equipment.remark == ""  {
        
        cell.btnRemark.setTitle("\(LanguageKey.remark)", for: .normal)
        cell.imageEquip.image = UIImage(named: "Remark")
        cell.btnRemark.setTitleColor(UIColor.themeMoreButtonLinkYellow, for: .normal)
        //cell.btnRemark.setTitleColor(UIColor(named: "868F90"), for: .normal)
        //cell.btnRemark.isHidden = true
        
        //                }else{
        //
        //                cell.btnRemark.setTitle("\(LanguageKey.remark_added)", for: .normal)
        //
        //                cell.imageEquip.image = UIImage(named: "Vector")
        //
        //                cell.btnRemark.setTitleColor(UIColor.themeMoreButtonLink, for: .normal)
        //
        //                }
        //                cell.btnDefaults.addTarget(self, action: #selector(buttonbtnlikePressed), for: .touchUpInside)
        //                cell.btnDefaults.tag = indexPath.row
        //
        //                cell.btnRemark.addTarget(self, action: #selector(buttonbtnlikePressedRemark), for: .touchUpInside)
        //                cell.btnRemark.tag = indexPath.row
        //                //
        
        // let ar = URL(string: Service.BaseUrl)?.absoluteString
        // let ab = equipmentData[indexPath.row].image
        // //load(url:(URL(string: ar! + (ab.attachThumnailFileName!))!
        // let url = URL(string: ar! + ab!)
        // if let data = try? Data(contentsOf: url!) {
        // if let image = UIImage(data: data){
        // cell.equipmentImg.image = image
        // }
        // }
        
        
        return cell
    }
    //
    //            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //            }
    //
    //        @objc func buttonbtnlikePressed(_ sender: UIButton) {
    //
    //            let indexpath = IndexPath(row: sender.tag, section: 0)
    //            let equipments = equipmentData[indexpath.row]
    //            let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
    //            let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
    //            vc.equipments = equipments
    //            vc.isBarcodeScannerbool = true
    //            vc.isEquipData = true
    //            self.navigationController?.pushViewController(vc, animated: true)
    //
    //        }
    //        @objc func buttonbtnlikePressedRemark(_ sender: UIButton) {
    //
    //            let indexpath = IndexPath(row: sender.tag, section: 0)
    //            //let equipments = equipmentData[indexpath.row]
    //            //let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
    //            let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
    //            vc.equipment = equipmentData[indexpath.row]
    //            vc.objOfUserJobListInDoc = objOfUserJobListInDetails!
    //
    //            self.navigationController?.pushViewController(vc, animated: true)
    //
    //        }
    //        @IBAction func addEquipmentBtn(_ sender: Any) {
    //
    //            let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "AddEqupment") as! AddEqupment
    //            loginPageView.objOfUserJodbList = self.objOfUserJobListInDetails!
    //               self.navigationController?.pushViewController(loginPageView, animated: true)
    //        }
    //        //===============================
    //            // MARK:- Data - Passing method
    //            //===============================
    //            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //                if segue.identifier == "LinkEquipmentReport" {
    //                    if let indexPath = tableView.indexPathForSelectedRow {
    //                        let getDetail = segue.destination as! LinkEquipmentReport
    //                        getDetail.equipment = equipmentData[indexPath.row]
    //                        getDetail.objOfUserJobListInDoc = objOfUserJobListInDetails!
    //                    }
    //                }
    //
    //            }
    //
    //
    //
    //            //==================================
    //            // MARK:- Equipement LIST Service methods
    //            //==================================
    //            func getEquipementListService(){
    //
    //                if !isHaveNetowork() {
    //                    if self.refreshControl.isRefreshing {
    //                        self.refreshControl.endRefreshing()
    //                    }
    //                    killLoader()
    //                    ShowError(message: AlertMessage.networkIssue, controller: windowController)
    //
    //                    return
    //                }
    //
    //
    //
    //
    //                let param = Params()
    //                param.compId = getUserDetails()?.compId
    //                param.usrId = getUserDetails()?.usrId
    //                param.audId = auditDetail?.audId
    //                param.limit = ContentLimit
    //                param.index = "0"
    //                param.isMobile = 1
    //
    //
    //                serverCommunicator(url: Service.getAuditEquipmentList, param: param.toDictionary) { (response, success) in
    //
    //                       DispatchQueue.main.async {
    //                           if self.refreshControl.isRefreshing {
    //                               self.refreshControl.endRefreshing()
    //                           }
    //                       }
    //
    //
    //                    if(success){
    //                        let decoder = JSONDecoder()
    //
    //                        if let decodedData = try? decoder.decode(EqListResponse.self, from: response as! Data) {
    //                            if decodedData.success == true{
    //
    //                                if decodedData.data!.count > 0 {
    //                                    self.equipments = decodedData.data!
    //
    //                                    DispatchQueue.main.async {
    //                                     self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
    //                                     self.tableView.reloadData()
    //                                        killLoader()
    //                                    }
    //                                }else{
    //                                 //   print("jugal")
    //                                    self.equipments.removeAll()
    //                                    DispatchQueue.main.async {
    //                                        self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
    //                                        self.tableView.reloadData()
    //                                    }
    //
    //                                    killLoader()
    //                                }
    //                            }else{
    //                                killLoader()
    //                            }
    //                        }else{
    //                            killLoader()
    //                            ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
    //
    //                                if cancel {
    //                                    showLoader()
    //                                    self.getEquipementListService()
    //                                }
    //                            })
    //                        }
    //                    }else{
    //                        killLoader()
    //                        ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
    //                            if cancelButton {
    //                                showLoader()
    //                                self.getEquipementListService()
    //                            }
    //                        })
    //                    }
    //                }
    //            }
    //
    //
    //
    //
    //
    //
    //
    //
    @IBAction func backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //==================================
    // MARK:- Equipement LIST Service methods
    //==================================
    func getAdminEquipementList(){
        
        if !isHaveNetowork() {
            // if self.refreshControl.isRefreshing {
            //   self.refreshControl.endRefreshing()
            // }
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
         showLoader()
        
        // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getEquipmentList) as? String
        let param = Params()
        
        param.isactive = ""
        param.search = ""
        param.type = "2"
        // param.dateTime = lastRequestTime ?? ""
        
        // limit, index, search, dateTime
        
        
        
        serverCommunicator(url: Service.getEquipmentList, param: param.toDictionary) { (response, success) in
            
            //               DispatchQueue.main.async {
            //                   if self.refreshControl.isRefreshing {
            //                       self.refreshControl.endRefreshing()
            //                   }
            //               }
            
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(AdminEquipListResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                            killLoader()
                        if decodedData.data!.count > 0 {
                            self.EquipmentsList = decodedData.data as! [AdminEquipListData]
                            
                            //                                  if !self.isUserfirstLogin {
                            //
                            //                                                              self.saveUserJobsInDataBase(data: decodedData.data!)
                            //
                            //                                                              //Request time will be update when data comes otherwise time won't be update
                            //                                                              UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getEquipmentList)
                            //
                            //
                            //                                                              //self.showDataOnTableView(query: nil) //Show joblist on tableview
                            //
                            //                                                          }else{
                            //                                                              self.saveAllUserJobsInDataBase(data: decodedData.data!)
                            //                                                          }
                            
                            DispatchQueue.main.async {
                                
                                  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.EquipmentsList.count))"
                                
                                var arr = self.EquipmentsList.count
                                if arr > 0  {
                                    self.img.isHidden = true
                                    self.eqpmtNotFound.isHidden = true
                                    //   print("jugal 1")
                                }else{
                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
                                    self.img.isHidden = false
                                    self.eqpmtNotFound.isHidden = false
                                    // print("jugal 0")
                                }
                                self.tableView.reloadData()
                                
                                //  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                
                                killLoader()
                            }
                        }else{
                            //   print("jugal")
                            //self.equipments.removeAll()
                            DispatchQueue.main.async {
                                // self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                //self.tableView.reloadData()
                            }
                            
                            killLoader()
                        }
                    }else{
                        killLoader()
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        
                        if cancel {
                            showLoader()
                            self.getAdminEquipementList()
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getAdminEquipementList()
                    }
                })
            }
        }
    }
    
}







//    extension UIColor {
//        static var themeMoreButtonLink = UIColor.init(red: 152/255, green: 152/255, blue: 152/255, alpha: 1)
//        static var themeMoreButtonLinkYellow = UIColor.init(red: 235/255, green: 176/255, blue: 87/255, alpha: 1)
//    }
