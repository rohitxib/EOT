//
//  EquipmentVC.swift
//  EyeOnTask
//
//  Created by Mojave on 12/11/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import JJFloatingActionButton
class EquipmentVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var lblEqListNo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var isEquipmentAddEnable = true
    //    var  auditDetail : AuditListData?
    var  auditDetail : AuditOfflineList?
    var equipments = [EquipementListData]()
    var count : Int = 0
    var refreshControl = UIRefreshControl()
    var equipmentData = [equipDataArray]()
    var objOfUserJobListInDetail : AuditOfflineList!
    var typeId : String = ""
    //=========================
    // MARK:- Initial methods
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //   print(equipmentData)
        self.navigationItem.title = LanguageKey.detail_equipment
        // print(auditDetail)
        // print(objOfUserJobListInDetail)
        NotiyCenterClass.registerRefreshEquipmentListNotifier(vc: self, selector: #selector(equipmentHandler(_:)))
        // showLoader()
        //  getEquipementListService()
        
        setLocalization()
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        // refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        // tableView.addSubview(refreshControl) // not required when using UITableViewController
        ActivityLog(module:Modules.equipment.rawValue , message: ActivityMessages.auditEquipment)
        self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipmentData.count))"
        setData()
         floatinActionButton()
    }
    
    func floatinActionButton() {
                let actionButton = JJFloatingActionButton()
                actionButton.buttonAnimationConfiguration = .rotation(toAngle: 0.0)
                actionButton.buttonImage = UIImage(named: "Group 361")
                actionButton.itemAnimationConfiguration = .slideIn(withInterItemSpacing: 20)
                actionButton.buttonColor  = UIColor(red: 55.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1.0)
              
                //  isDisable = compPermissionVisible(permission: compPermission.isItemEnable)

        
        actionButton.addItem(title:LanguageKey.link_client_equipment, image: UIImage(named: "Group_Link-1")) { item in
          
//            if self.typeId == "2" {
               let isLinkEquipment = "Client"
                let storyboard = UIStoryboard(name: "MainAudit", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LinkAuditEquipment") as! LinkAuditEquipment
                vc.isLink = isLinkEquipment
                vc.objOfUserJobListInDetails = self.auditDetail
                self.navigationController!.pushViewController(vc, animated: true)
//            }
          
            
        }
                 isEquipmentAddEnable = compPermissionVisible(permission: compPermission.isEquipmentAddEnable)

                            
                      if isEquipmentAddEnable == true {
                actionButton.addItem(title: LanguageKey.title_add_equipment , image: UIImage(named: "Group 325")?.withRenderingMode(.alwaysOriginal)) { item in
                    // do somethin5
                    
                    if !isHaveNetowork() {
                        DispatchQueue.main.async {
                            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                        }
                        return
                    }
                    
                    let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "addEquipmentRemark") as! addEquipmentRemark
                    loginPageView.objOfUserJodbList = self.auditDetail!
                    self.navigationController?.pushViewController(loginPageView, animated: true)
                    
                    
                }
                
            }
     
        
   
        
        for button in actionButton.items { // change button color of items
            button.buttonColor = UIColor(red: 55.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1.0)
        }
        
        view.addSubview(actionButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setData(){
        equipmentData.removeAll()
        let searchQuery = "audId = '\(auditDetail?.audId ?? "")'"
        let isExistAudit = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: searchQuery) as! [AuditOfflineList]
        if isExistAudit.count > 0{
            auditDetail!.equArray = isExistAudit[0].equArray
            if auditDetail!.equArray != nil {
                
                
                for item in (auditDetail!.equArray as! [AnyObject]) {
                    if let dta = item as? equArray {
                        
                        print(dta)
                        
                    }else{
                        var arrTac = [AttechmentArry]()
                        
                        if item["attachments"] != nil {
                            
                            
                            if (item["attachments"] is [AnyObject]) && ((item["attachments"] as! [AnyObject]).count > 0) {
                                let attachments =  item["attachments"] as! [AnyObject]
                                for attechDic in attachments {
                                    arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                                }
                                
                                
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String, usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String, datetime: item["datetime"] as? String, installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                  typeId = dic.type ?? ""
                                equipmentData.append(dic)
                                // print(equipmentDic.self)
                                
                                // if let dta = item as? equipData {
                                // }
                            }else {
                                
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String, installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                  typeId = dic.type ?? ""
                                equipmentData.append(dic)
                            }
                            
                            
                        }
                    }
                    
                }
            }
            
        }
        self.tableView.reloadData()
        self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipmentData.count))"
    }
    //    func setData(){
    //        equipmentData.removeAll()
    //        let searchQuery = "audId = '\(auditDetail?.audId ?? "")'"
    //        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: searchQuery) as! [AuditOfflineList]
    //        if isExist.count > 0{
    //            auditDetail!.equArray = isExist[0].equArray
    //               if auditDetail!.equArray != nil {
    //                     for item in (auditDetail!.equArray as! [AnyObject]) {
    //                        let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String)
    //                                  equipmentData.append(dic)
    //                       // print(equipmentDic.self)
    //
    //            //            if let dta = item as? equipData {
    //            //            }
    //                    }
    //                    }
    //        }
    //        self.tableView.reloadData()
    //        self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipmentData.count))"
    //    }
    
    @objc func equipmentHandler(_ notification: NSNotification){
        let userinfo = notification.userInfo
        
        if let info = userinfo {
            let equipment = equipmentData.filter({$0.equId == info["equId"] as? String})
            if equipment.count == 1 {
                let equp = equipment[0]
                equp.status = info["status"] as? String
                equp.remark = info["remark"] as? String
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setLocalization() -> Void {
        self.lblEqListNo.text! = "\(LanguageKey.list_item) 0"
        
        
        
        
    }
    
    
    @objc func refreshControllerMethod(_ notification: NSNotification){
        count = 0
        
         getEquipementListService()
         equipments.removeAll()
         self.getEquipementListService()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        // getEquipementListService()
        setData()
        self.tabBarController?.navigationItem.title = LanguageKey.detail_equipment//LanguageKey.title_documents
        
        tableView.estimatedRowHeight = 200
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        //  tableView.reloadData()
    }
    
    
    @IBAction func addEquipment(_ sender: Any) {
//        if !isHaveNetowork() {
//            DispatchQueue.main.async {
//                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
//            }
//            return
//        }
//
//        let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "addEquipmentRemark") as! addEquipmentRemark
//        loginPageView.objOfUserJodbList = self.auditDetail!
//        self.navigationController?.pushViewController(loginPageView, animated: true)
        
    }
    
    //==================================
    // MARK:- Equipement LIST Service methods
    //==================================
    func getEquipementListService(){
        
        if !isHaveNetowork() {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.usrId = getUserDetails()?.usrId
        param.audId = auditDetail?.audId
        param.limit = ContentLimit
        param.index = "0"
        param.isMobile = 1
        
        
        serverCommunicator(url: Service.getAuditEquipmentList, param: param.toDictionary) { (response, success) in
            
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(EqListResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        //  print(decodedData.data)
                        
                        if let dataObject = decodedData.data {
                            let searchQuery = "audId = '\(self.auditDetail?.audId ?? "")'"
                            let isExistAudit = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: searchQuery) as! [AuditOfflineList]
                            if isExistAudit.count > 0{
                                isExistAudit[0].equArray = isExistAudit[0].equArray
                                if isExistAudit[0].equArray != nil {
                                    
                                    
                                    // isExistAudit[0].equArray = decodedData.data as NSObject?
                                    
                                    var item = (isExistAudit[0].equArray as! [Any])
                                    item.removeAll()
                                    for data in decodedData.data!
                                    {
                                        item.append(data.toDictionary as Any)
                                        
                                        // print(item.count)
                                        // print(item)
                                        
                                    }
                                    isExistAudit[0].equArray = item as NSObject
                                    
                                    
                                    // let dic = ["itemId":"","inm":"","des":"","qty":"","discount":"","rate":"","dataType":"","jobId":"","hsncode":"","taxamnt":""]
                                    
                                }
                                DatabaseClass.shared.saveEntity(callback: {_ in })
                                
                            }
                            
                        }
                        
                    }else{
                        killLoader()
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        
                        if cancel {
                            showLoader()
                            self.getEquipementListService()
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getEquipementListService()
                    }
                })
            }
        }
    }
    
    //==========================
    // MARK:- Tableview methods
    //==========================
    
    
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 103.0
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        //return equipments.count
        return equipmentData.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quipmentCell",for: indexPath) as! EquipmentCell
        // let equipment = equipments[indexPath.row]
        
        cell.btnDefaults.setTitle("View Details", for: .normal)
        // cell.btnDefaults.setTitle("  \(LanguageKey.equipment_btn)" , for: .normal)
        // cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
        let modl = LanguageKey.model_no
        let serl = LanguageKey.serial_no
        let equipment = equipmentData[indexPath.row]
         let cond = LanguageKey.condition
        if equipment.isPart == "0"{
            
            
            if equipment.attachments?.count == 1 {
                  cell.attechRemrkBtn.isHidden = true
                cell.imgFirst.isHidden = false
                cell.imgCount.isHidden = true
                cell.imgView_H.constant = 116
                cell.imgSecond.isHidden = true
                cell.imgThird.isHidden = true
                if let img = equipment.attachments?[0].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                }else{
                    cell.imgFirst.image = UIImage(named: "unknownDoc")
                    
                }
            } else if equipment.attachments?.count == 2 {
                 cell.attechRemrkBtn.isHidden = true
                cell.imgView_H.constant = 116
                cell.imgCount.isHidden = true
                cell.imgThird.isHidden = true
                cell.imgFirst.isHidden = false
                cell.imgSecond.isHidden = false
                if let img = equipment.attachments?[0].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                }else{
                    cell.imgFirst.image = UIImage(named: "unknownDoc")
                    
                }
                
                if let img = equipment.attachments?[1].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                }else{
                    cell.imgSecond.image = UIImage(named: "unknownDoc")
                    
                }
            } else if equipment.attachments?.count == 3 {
                 cell.attechRemrkBtn.isHidden = false
                cell.imgThird.isHidden = false
                cell.imgFirst.isHidden = false
                cell.imgSecond.isHidden = false
                cell.imgView_H.constant = 116
                cell.imgCount.isHidden = true
               // cell.imgCount.text = "+\(equipment.attachments!.count)"
                if let img = equipment.attachments?[0].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                }else{
                    cell.imgFirst.image = UIImage(named: "unknownDoc")
                    
                }
                
                if let img = equipment.attachments?[1].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                }else{
                    cell.imgSecond.image = UIImage(named: "unknownDoc")
                    
                }
                if let img = equipment.attachments?[2].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgThird.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[2].image_name ?? "unknownDoc"))
                }else{
                    cell.imgThird.image = UIImage(named: "unknownDoc")
                    
                }
            }else if equipment.attachments?.count == 0 {
                 cell.attechRemrkBtn.isHidden = true
                cell.imgCount.isHidden = true
                cell.imgView_H.constant = 0
                cell.imgSecond.isHidden = true
                cell.imgFirst.isHidden = true
                cell.imgThird.isHidden = true
                
            }else {
                     cell.attechRemrkBtn.isHidden = false
                cell.attechRemrkBtn.isHidden = false
                cell.imgCount.isHidden = false
                cell.imgView_H.constant = 116
                cell.imgCount.text = "+\(equipment.attachments!.count - 3)"
                cell.imgSecond.isHidden = false
                cell.imgFirst.isHidden = false
                cell.imgThird.isHidden = false
                
                if let img = equipment.attachments?[0].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                }else{
                    cell.imgFirst.image = UIImage(named: "unknownDoc")
                    
                }
                
                if let img = equipment.attachments?[1].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                }else{
                    cell.imgSecond.image = UIImage(named: "unknownDoc")
                    
                }
                if let img = equipment.attachments?[2].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgThird.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[2].image_name ?? "unknownDoc"))
                }else{
                    cell.imgThird.image = UIImage(named: "unknownDoc")
                    
                }
                
            }
            
            
            cell.partLbl.isHidden = true
            cell.partLbl.text = LanguageKey.parts
            cell.remarkDisc.text = equipment.remark
            cell.lblName.text = equipment.equnm
            cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        }
        else{
            if equipment.attachments?.count == 1 {
                 cell.attechRemrkBtn.isHidden = true
                cell.imgFirst.isHidden = false
                cell.imgCount.isHidden = true
                cell.imgView_H.constant = 116
                cell.imgSecond.isHidden = true
                cell.imgThird.isHidden = true
                if let img = equipment.attachments?[0].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                }else{
                    cell.imgFirst.image = UIImage(named: "unknownDoc")
                    
                }
            } else if equipment.attachments?.count == 2 {
                 cell.attechRemrkBtn.isHidden = true
                cell.imgView_H.constant = 116
                cell.imgCount.isHidden = true
                cell.imgThird.isHidden = true
                cell.imgFirst.isHidden = false
                cell.imgSecond.isHidden = false
                if let img = equipment.attachments?[0].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                }else{
                    cell.imgFirst.image = UIImage(named: "unknownDoc")
                    
                }
                
                if let img = equipment.attachments?[1].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                }else{
                    cell.imgSecond.image = UIImage(named: "unknownDoc")
                    
                }
            } else if equipment.attachments?.count == 3 {
                 cell.attechRemrkBtn.isHidden = false
                cell.imgThird.isHidden = false
                cell.imgFirst.isHidden = false
                cell.imgSecond.isHidden = false
                cell.imgView_H.constant = 116
                cell.imgCount.isHidden = true
              //  cell.imgCount.text = "+\(equipment.attachments!.count)"
                if let img = equipment.attachments?[0].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                }else{
                    cell.imgFirst.image = UIImage(named: "unknownDoc")
                    
                }
                
                if let img = equipment.attachments?[1].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                }else{
                    cell.imgSecond.image = UIImage(named: "unknownDoc")
                    
                }
                if let img = equipment.attachments?[2].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgThird.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[2].image_name ?? "unknownDoc"))
                }else{
                    cell.imgThird.image = UIImage(named: "unknownDoc")
                    
                }
            }else if equipment.attachments?.count == 0 {
                 cell.attechRemrkBtn.isHidden = true
                cell.imgCount.isHidden = true
                cell.imgView_H.constant = 0
                cell.imgSecond.isHidden = true
                cell.imgFirst.isHidden = true
                cell.imgThird.isHidden = true
                
            }else {
                 cell.attechRemrkBtn.isHidden = true
                cell.imgCount.isHidden = false
                cell.imgView_H.constant = 116
                cell.imgCount.text = "+\(equipment.attachments!.count - 3)"
                cell.imgSecond.isHidden = false
                cell.imgFirst.isHidden = false
                cell.imgThird.isHidden = false
                
                if let img = equipment.attachments?[0].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                }else{
                    cell.imgFirst.image = UIImage(named: "unknownDoc")
                    
                }
                
                if let img = equipment.attachments?[1].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                }else{
                    cell.imgSecond.image = UIImage(named: "unknownDoc")
                    
                }
                if let img = equipment.attachments?[2].attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imgThird.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[2].image_name ?? "unknownDoc"))
                }else{
                    cell.imgThird.image = UIImage(named: "unknownDoc")
                    
                }
                
            }
            
            
            cell.partLbl.isHidden = false
            cell.remarkDisc.text = equipment.remark
            cell.partLbl.text = LanguageKey.parts
            cell.lblName.text = equipment.equnm
            cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
            // cell.lblName.textColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
        }
        // cell.lblName.text = equipment.equnm
        cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
        cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
        cell.lblAddress.text = equipment.location
        
        if equipment.status == "" &&  equipment.remark == ""{
                   cell.remarkView_H.constant = 0
               }else{
                  cell.remarkView_H.constant = 111
               }
        
        let status = Int((equipment.status)!) //getDefaultSettings()!.equipmentStatus
              if status == 16 {
                  
                  cell.conditationLbl.text = "\(cond) : Good"
              } else if status == 1038 {
                  
                  cell.conditationLbl.text = "\(cond) : Need to be Repaired"
              }else if status == 1549 {
                  
                  cell.conditationLbl.text = "\(cond) : Not Working"
              }else if status == 527 {
                  
                  cell.conditationLbl.text = "\(cond) : Poor"
              }else{
                  cell.conditationLbl.text = "\(LanguageKey.condition):"
              }
        
        if equipment.remark == ""{
            cell.remarkEditBt.isHidden = true
            cell.btnRemark.isHidden = false
          
            cell.btnRemark.setTitle("Add Remark", for: .normal)
           // cell.btnRemark.setTitle("\(LanguageKey.remark)", for: .normal)
            cell.imageEquip.image = UIImage(named: "Remark")
            //cell.btnRemark.setTitleColor(UIColor(named: "868F90"), for: .normal)
            //cell.btnRemark.isHidden = true remark_added
           // cell.btnRemark.setTitleColor(UIColor.themeMoreButtonLinkYellow1, for: .normal)
            
            
            
        }else{
            
            cell.remarkEditBt.isHidden = false
            cell.btnRemark.isHidden = true
            
            
            cell.btnRemark.setTitle("View Details", for: .normal)
           // cell.btnRemark.setTitle("\(LanguageKey.remark_added)", for: .normal)
            
            
            cell.imageEquip.image = UIImage(named: "Remak-added")
            // cell.btnRemark.setTitleColor(UIColorFromRGB(named: "868F90"), for: .normal)
            cell.btnRemark.setTitleColor(UIColor.themeMoreButton, for: .normal)
            // cell.imageEquip.backgroundColor = UIColor.gray
        }
        
        
        cell.btnDefaults.addTarget(self, action: #selector(buttonbtnlikePressed), for: .touchUpInside)
        cell.btnDefaults.tag = indexPath.row
        
        cell.btnRemark.addTarget(self, action: #selector(buttonbtnlikePressedRemark), for: .touchUpInside)
        cell.btnRemark.tag = indexPath.row
        
        cell.remarkEditBt.addTarget(self, action: #selector(EditbuttonbtnlikePressedRemark), for: .touchUpInside)
               cell.remarkEditBt.tag = indexPath.row
        
        
        cell.attechRemrkBtn.addTarget(self, action: #selector(attechRemrkBtnPressedRemark), for: .touchUpInside)
        cell.attechRemrkBtn.tag = indexPath.row
        // let ar = URL(string: Service.BaseUrl)?.absoluteString
        // let ab = equipmentData[indexPath.row].image
        // //load(url:(URL(string: ar! + (ab.attachThumnailFileName!))!
        // let url = URL(string: ar! + ab!)
        // if let data = try? Data(contentsOf: url!) {
        // if let image = UIImage(data: data){
        // cell.equipmentImg.image = image
        // }
        // }
        //
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
      func getImage(fileType : String) -> UIImage {
          
          //'jpg','png','jpeg','pdf','doc','docx','xlsx','csv','xls'
          
          let filename: NSString = fileType as NSString
          let pathExtention = filename.pathExtension
          
          var imageName = ""
          switch pathExtention {
          case "jpg","png","jpeg":
              imageName = "default-thumbnail"
              
          case "pdf":
              imageName = "pdf"
              
          case "doc","docx":
              imageName = "word"
              
          case "xlsx","xls":
              imageName = "excel"
              
          case "csv":
              imageName = "csv"
              
          default:
              imageName = "unknownDoc"
          }
          
          let image = UIImage(named: imageName)
          return image!
          
      }
    
    @objc func attechRemrkBtnPressedRemark(_ sender: UIButton) {
                
                let indexpath = IndexPath(row: sender.tag, section: 0)
                //let equipments = equipmentData[indexpath.row]
                //let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
                let vc = storyboard?.instantiateViewController(withIdentifier: "AttechRemarkAudit") as! AttechRemarkAudit
                vc.equipment = equipmentData[indexpath.row]
                vc.objOfUserJobListInDoc = auditDetail!
                
                self.navigationController?.pushViewController(vc, animated: true)
               
            }
    //===============================
    // MARK:- Data - Passing method
    //===============================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Remark" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let getDetail = segue.destination as! RemarkVC
                getDetail.equipment = equipmentData[indexPath.row]
                getDetail.auditDetaiData = auditDetail
            }
        }
        
    }
    @objc func buttonbtnlikePressed(_ sender: UIButton) {
        
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let equipments = equipmentData[indexpath.row]
        // let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
        vc.equipments = equipments
        vc.isBarcodeScannerboolremarkaud = true
        // vc.isBarcodeScannerbool = true
        
        vc.isEquipData = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func buttonbtnlikePressedRemark(_ sender: UIButton) {
        
        let indexpath = IndexPath(row: sender.tag, section: 0)
        //let equipments = equipmentData[indexpath.row]
        //let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "remarkTab") as! RemarkVC
        vc.equipment = equipmentData[indexpath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //// for EDIT EQUIPMENT REMARK
    
    @objc func EditbuttonbtnlikePressedRemark(_ sender: UIButton) {
           
          let indexpath = IndexPath(row: sender.tag, section: 0)
                  //let equipments = equipmentData[indexpath.row]
                  //let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
                  let vc = storyboard?.instantiateViewController(withIdentifier: "remarkTab") as! RemarkVC
                  vc.equipment = equipmentData[indexpath.row]
                  
                  self.navigationController?.pushViewController(vc, animated: true)
          
       }
    
    //
    //    //==================================
    //    // MARK:- Equipement LIST Service methods
    //    //==================================
    //    func getEquipementListService(){
    //
    //        if !isHaveNetowork() {
    //            if self.refreshControl.isRefreshing {
    //                self.refreshControl.endRefreshing()
    //            }
    //            killLoader()
    //            ShowError(message: AlertMessage.networkIssue, controller: windowController)
    //
    //            return
    //        }
    //
    //
    //
    //
    //        let param = Params()
    //        param.compId = getUserDetails()?.compId
    //        param.usrId = getUserDetails()?.usrId
    //        param.audId = auditDetail?.audId
    //        param.limit = ContentLimit
    //        param.index = "0"
    //        param.isMobile = 1
    //
    //
    //        serverCommunicator(url: Service.getAuditEquipmentList, param: param.toDictionary) { (response, success) in
    //
    //               DispatchQueue.main.async {
    //                   if self.refreshControl.isRefreshing {
    //                       self.refreshControl.endRefreshing()
    //                   }
    //               }
    //
    //
    //            if(success){
    //                let decoder = JSONDecoder()
    //
    //                if let decodedData = try? decoder.decode(EqListResponse.self, from: response as! Data) {
    //                    if decodedData.success == true{
    //
    //                        if decodedData.data!.count > 0 {
    //                            self.equipments = decodedData.data!
    //
    //                            DispatchQueue.main.async {
    //                             self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
    //                             self.tableView.reloadData()
    //                                killLoader()
    //                            }
    //                        }else{
    //                            self.equipments.removeAll()
    //                            DispatchQueue.main.async {
    //                                self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
    //                                self.tableView.reloadData()
    //                            }
    //
    //                            killLoader()
    //                        }
    //                    }else{
    //                        killLoader()
    //                    }
    //                }else{
    //                    killLoader()
    //                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
    //
    //                        if cancel {
    //                            showLoader()
    //                            self.getEquipementListService()
    //                        }
    //                    })
    //                }
    //            }else{
    //                killLoader()
    //                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
    //                    if cancelButton {
    //                        showLoader()
    //                        self.getEquipementListService()
    //                    }
    //                })
    //            }
    //        }
    //    }
}
extension UIColor {
    static var themeMoreButton = UIColor.init(red: 152/255, green: 152/255, blue: 152/255, alpha: 1)
    static var themeMoreButtonLinkYellow1 = UIColor.init(red: 235/255, green: 176/255, blue: 87/255, alpha: 1)
}
