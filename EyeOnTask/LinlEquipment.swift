//
//  LinlEquipment.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 23/09/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Photos
import SDWebImage
import UIKit
import JJFloatingActionButton

class LinlEquipment: UIViewController, UITableViewDataSource, UITableViewDelegate , UITextFieldDelegate , UISearchBarDelegate,UINavigationControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource{
   
    @IBOutlet weak var collectVwFilter: UICollectionView!
    
   // @IBOutlet weak var collViewPart: UICollectionView!
   // @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var serchView: UIView!
    @IBOutlet weak var ownBtn: UIButton!
    @IBOutlet weak var clientBtn: UIButton!
    @IBOutlet weak var eqpmtNotFound: UILabel!
    @IBOutlet weak var lblEqListNo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var backGroundVw: UIView!
    @IBOutlet weak var img: UILabel!
    
    var replacePart = Bool()
    var isUserfirstLogin = Bool()
    var buttonIsSelected = false
    var getTag = ""
    var selectedRows:[Int] = []
    var equipIdName = " "
    var poIdNam = ""
    var filterequipmentData = [equipDataArray]()
    var isEquipmentAddEnable = true
    var searchTxt = ""
    var typeId : String = ""
    var isAdded = Bool()
    var isDropDwon = true
    var objOfUserJobListInDetails : UserJobList?
    var auditDetail : AuditOfflineList?
    var equipments = [EquipementListData]()
    var equipmentsStatus = [getEquipmentStatusDate]()
    var count : Int = 0
    var refreshControl = UIRefreshControl()
    var equipmentData = [equipDataArray]()
    var objOfUserJobListInDetail : AuditOfflineList!
    var searchCount : Int = 0
    var equipDataPartArr = [equipDataPartArray]()
    var equipDataPartArrNew = [equipDataPartArrayNew]()
    var equipementStatuss : [equipmentFilterStatus] = equipmentFilterStatus.allCases
    var selectedExpencesforFilter = [Int]()
    var filteredRemark = [equipDataArray]()
    var filteredsNoRemark = [equipDataArray]()
    var buttonFilter = false
    var buttonFilters = false
    
    
        //=========================
        // MARK:- Initial methods
        //=========================
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.lblEqListNo.isHidden = true
            var on = "On"
            UserDefaults.standard.set(on, forKey: "partView_H")
           getEquipmentStatus()
            let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.searchTxtFld.frame.height))
                searchTxtFld.rightView = paddingView1
                searchTxtFld.rightViewMode = UITextField.ViewMode.always
            
             self.popUpView.isHidden = true
            self.backGroundVw.isHidden = true
       
            self.navigationItem.title = LanguageKey.detail_equipment
       
            NotiyCenterClass.registerRefreshEquipmentListNotifier(vc: self, selector: #selector(equipmentHandler(_:)))
          
            setLocalization()
            refreshControl.attributedTitle = NSAttributedString(string: " ")
          
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
        
        if self.typeId == "" {
            actionButton.addItem(title: LanguageKey.link_own_equipment , image: UIImage(named: "Group_link")?.withRenderingMode(.alwaysOriginal)) { item in
                // do somethin5
                var on = "Off"
                UserDefaults.standard.set(on, forKey: "partView_H")
                
                let isLinkEquipment = "Own"
                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LinkClientsEquioment") as! LinkClientsEquioment
                vc.isLink = isLinkEquipment
                vc.objOfUserJobListInDetails = self.objOfUserJobListInDetails
                self.navigationController!.pushViewController(vc, animated: true)
            }
            
            actionButton.addItem(title:LanguageKey.link_client_equipment, image: UIImage(named: "Group_Link-1")) { item in
                
                var on = "Off"
                UserDefaults.standard.set(on, forKey: "partView_H")
                let isLinkEquipment = "Client"
                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LinkClientsEquioment") as! LinkClientsEquioment
                vc.isLink = isLinkEquipment
                vc.objOfUserJobListInDetails = self.objOfUserJobListInDetails
                self.navigationController!.pushViewController(vc, animated: true)
            }
            
        }else{
            actionButton.addItem(title: LanguageKey.link_own_equipment  , image: UIImage(named: "Group_link")?.withRenderingMode(.alwaysOriginal)) { item in
                // do somethin5
                
                if self.typeId == "1" {
                    
                    var on = "Off"
                    UserDefaults.standard.set(on, forKey: "partView_H")
                    
                    let isLinkEquipment = "Own"
                    let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LinkClientsEquioment") as! LinkClientsEquioment
                    vc.isLink = isLinkEquipment
                    vc.objOfUserJobListInDetails = self.objOfUserJobListInDetails
                    self.navigationController!.pushViewController(vc, animated: true)
                }else{
                    self.showToast(message: LanguageKey.equipment_not_found)
                }
               
            }
           
            actionButton.addItem(title:LanguageKey.link_client_equipment, image: UIImage(named: "Group_Link-1")) { item in
                
                if self.typeId == "2" {
                    
                    var on = "Off"
                    UserDefaults.standard.set(on, forKey: "partView_H")
                    let isLinkEquipment = "Client"
                    let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LinkClientsEquioment") as! LinkClientsEquioment
                    vc.isLink = isLinkEquipment
                    vc.objOfUserJobListInDetails = self.objOfUserJobListInDetails
                    self.navigationController!.pushViewController(vc, animated: true)
                }else{
                    self.showToast(message: LanguageKey.equipment_not_found)
                }
               
            }
        }
       
        isEquipmentAddEnable = compPermissionVisible(permission: compPermission.isEquipmentAddEnable)
        
        if isEquipmentAddEnable == true {
            actionButton.addItem(title: LanguageKey.title_add_equipment , image: UIImage(named: "Group 325")?.withRenderingMode(.alwaysOriginal)) { item in
                // do somethin5
                
                ActivityLog(module:Modules.invoice.rawValue , message:"Add Equipment")
                
                let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "AddEqupment") as! AddEqupment
                loginPageView.objOfUserJodbList = self.objOfUserJobListInDetails!
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
    
        override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
            getJobListService()
            getEquipmentStatus()
            var on = "On"
            UserDefaults.standard.set(on, forKey: "partView_H")
            if let button = self.parent?.navigationItem.rightBarButtonItem {
                button.isEnabled = false
                button.tintColor = UIColor.clear
            }
            self.popUpView.isHidden = true
            self.backGroundVw.isHidden = true
            setData()
            self.tabBarController?.navigationItem.title = LanguageKey.detail_equipment//LanguageKey.title_documents
            
            tableView.estimatedRowHeight = 200
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.rowHeight = UITableView.automaticDimension
            setData()
               // tableView.reloadData()
            }

    @IBAction func searchBtnActn(_ sender: Any) {
        searchTxt =  trimString(string: searchTxtFld.text!)
                  if searchTxt.count > 0 {
                      //showLoader()
                      setData()
                    
        }
               self.searchTxtFld.resignFirstResponder()
    }
    
    @IBAction func ownClientBtn(_ sender: Any) {
        ownBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
        clientBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
        var isLinkEquipment = "Client"
         let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LinkClientsEquioment") as! LinkClientsEquioment
        
        
        vc.isLink = isLinkEquipment
        
         self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func ClientBtn(_ sender: Any) {
        
        clientBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
        ownBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
        var isLinkEquipment = "Own"
        let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
              let vc = storyboard.instantiateViewController(withIdentifier: "LinkClientsEquioment") as! LinkClientsEquioment
          vc.isLink = isLinkEquipment
               self.navigationController!.pushViewController(vc, animated: true)
    }
    
    //================================
     //  MARK: showing And Hiding Background
     //================================
     
     func showBackgroundView() {
         backGroundVw.isHidden = false
         UIView.animate(withDuration: 0.2, animations: {
             self.backGroundVw.backgroundColor = UIColor.black
             self.backGroundVw.alpha = 0.5
         })
     }
    
    func hideBackgroundView() {
        
        
        
        if (popUpView != nil) {
            popUpView.removeFromSuperview()
        }
        
        self.backGroundVw.isHidden = true
        self.backGroundVw.backgroundColor = UIColor.clear
        self.backGroundVw.alpha = 1
    }
        func setData(){
            equipmentData.removeAll()
            let searchQuery = "jobId = '\(objOfUserJobListInDetails?.jobId ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
            if isExist.count > 0{
                objOfUserJobListInDetails!.equArray = isExist[0].equArray
                   if objOfUserJobListInDetails!.equArray != nil {
                    for item in (objOfUserJobListInDetails!.equArray as! [AnyObject]) {
                        if let dta = item as? equArray {
                        }else{
                            var arrTac = [AttechmentArry]()
                            var arrEqPart = [equComponant]()
                          
                            
                            if item["equComponent"] != nil {
                                let eqpartArr =  item["equComponent"] as? [AnyObject]
                                if eqpartArr?.count ?? 0 > 0 {
                                
                                    if item["attachments"] != nil {
                                     
                                     let attachments =  item["attachments"] as? [AnyObject]
                                     if attachments?.count ?? 0 > 0 {
                                          
                                         for attechDic in attachments! {
                                           arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                                    }
                                }
                            }
                                    
                                    
                            for eqPartDic in eqpartArr! {
                                arrEqPart.append(equComponant(equId: eqPartDic["equId"] as? String, equnm: eqPartDic["equnm"] as? String,mno: eqPartDic["mno"] as? String, sno: eqPartDic["sno"] as? String, audId: eqPartDic["audId"] as? String, remark: eqPartDic["remark"] as? String, changeBy: eqPartDic["changeBy"] as? String, status: eqPartDic["status"] as? String, updateData: eqPartDic["updateData"] as? String, lat: eqPartDic["lat"] as? String, lng: eqPartDic["lng"] as? String, location: eqPartDic["location"] as? String, contrid: eqPartDic["contrid"] as? String, type: eqPartDic["type"] as? String,brand: eqPartDic["brand"] as? String, expiryDate: eqPartDic["expiryDate"] as? String, manufactureDate: eqPartDic["manufactureDate"] as? String, purchaseDate: eqPartDic["purchaseDate"] as? String, barcode: eqPartDic["barcode"] as? String, equipment_group: eqPartDic["equipment_group"] as? String, image: eqPartDic["image"] as? String,rate: eqPartDic["rate"] as? String, supId: eqPartDic["supId"] as? String, supplier: eqPartDic["supplier"] as? String, cltId: eqPartDic["cltId"] as? String, nm: eqPartDic["nm"] as? String, statusText: eqPartDic["statusText"] as? String, category: eqPartDic["category"] as? String, parentId: eqPartDic["parentId"] as? String, ecId: eqPartDic["ecId"] as? String, notes: eqPartDic["notes"] as? String    , isPart: eqPartDic["isPart"] as? String, usrManualDoc: eqPartDic["usrManualDoc"] as? String, extraField1: eqPartDic["extraField1"] as? String, extraField2: eqPartDic["extraField2"] as? String, snm: eqPartDic["snm"] as? String, datetime: eqPartDic["datetime"] as? String, installedDate: eqPartDic["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String))
                            }
                              
                                    let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:arrEqPart,notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                    
                                    typeId = dic.type!
                                    equipmentData.append(dic)
                                    
                                    
                                }else {
                                    
                                    
                                    
                                    if item["attachments"] != nil {
                                     
                                     let attachments =  item["attachments"] as? [AnyObject]
                                     if attachments?.count ?? 0 > 0 {
                                          
                                         for attechDic in attachments! {
                                           arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                                    }
                                }
                            }
                                    
                                    let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:arrEqPart,notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                    typeId = dic.type!
                                    
                                    equipmentData.append(dic)
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            
            
            equipDataPartArr.removeAll()
            filterequipmentData.removeAll()
            for dic in equipmentData {
               
                if dic.parentId == "0" {
                    if dic.isPart == "0" {
                        let model = equipDataPartArray(equId: dic, equePartArr: [])
                        
                        equipDataPartArr.append(model)
                    }else {
                        if equipDataPartArr.count > 0 {
                            
                            if let index = equipDataPartArr.index(where: {$0.equeDic?.equId ?? "0" == dic.parentId}) {
                                
                              //  print(index)
                                equipDataPartArr[index].equePartArr?.append(dic)
                                //equipDataPartArrNew[index].equePartArr?.append(dic)
                               
                            }else {
                                filterequipmentData.append(dic)
                                let model = equipDataPartArray(equId: dic, equePartArr: [])
                                equipDataPartArr.append(model)
                            }
                        }
                    }
                    
                }else {
                    
                    if let index = equipDataPartArr.index(where: {$0.equeDic?.equId ?? "0" == dic.parentId}) {
                        
                       // print(index)
                        equipDataPartArr[index].equePartArr?.append(dic)
                        equipDataPartArrNew[index].equePartArr?.append(dic)
                        
                    }else{
                        let model = equipDataPartArray(equId: dic, equePartArr: [])
                        equipDataPartArr.append(model)
                        
                    }
                    
                }
                
            }

            self.tableView.reloadData()
            self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipDataPartArr.count))"
            var arr = self.equipDataPartArr.count
                       if arr > 0  {
                        self.img.isHidden = true
                        self.eqpmtNotFound.isHidden = true
                        
                       }else{
                        self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
                          self.img.isHidden = false
                         self.eqpmtNotFound.isHidden = false
                         
                       }
            
        }
    
 
    
    func dataParse(item:AnyObject) -> equipDataArray{
        var arrTac = [AttechmentArry]()
        
       // if item["attachments"] != nil {
            
            let attachments =  item["attachments"] as? [AnyObject]
            if attachments?.count ?? 0 > 0 {
                
                for attechDic in attachments! {
                    arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                }
                
                //  for item in (objOfUserJobListInDetails!.equArray as! [AnyObject]) {
                return equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                
                //equipmentData.append(dic)
//                                    for dic1 in equipmentData {
//
//
//                                        for dic in equipmentData {
//                                            if dic1.parentId == dic.equId {
//
//                                                //   filterequipmentData.append(dic1)
//                                                print("equnm=========\(dic1.equnm)")
//                                                print("parentIdt=========\(dic1.parentId)")
//                                                print("equId=========\(dic.equId)")
//
//
//                                            }
//
//                                        }
//
//
//
//
//                                    }
                
            }else {
                return equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                //typeId = dic.type!
                
                //                                if dic.parentId == dic.equId {
                //                                    filterequipmentData.append(dic)
                //                                }else{
                
                
                
                // }
                
                
                
            }
        //}
    }
        @objc func equipmentHandler(_ notification: NSNotification){
            let userinfo = notification.userInfo
            
            if let info = userinfo {
                let equipment = equipments.filter({$0.equId == info["equId"] as? String})
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
             searchTxtFld.placeholder = LanguageKey.search
        }
        
        
        @objc func refreshControllerMethod(_ notification: NSNotification){
            count = 0
            
           // equipments.removeAll()
           // self.getEquipementListService()
        }
        
    
    //===============================
    // MARK:- CollectionView methods
    //===============================
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return equipementStatuss.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectVwFilter.dequeueReusableCell(withReuseIdentifier: "jobCollCell", for: indexPath)as! jobCollectionCell
        
        
        let statusType : Int = equipementStatuss[indexPath.row].rawValue
        let statusData = equipmentFilter(taskType: equipementStatuss[indexPath.row])
        cell.lblTask.text = statusData.0.replacingOccurrences(of: " Task", with: "")
        
        
        if selectedExpencesforFilter.firstIndex(of:statusType) != nil {
            cell.greenView.backgroundColor = .init(red: 40.0/255.0, green: 166.0/255.0, blue: 70.0/255.0, alpha: 1.0)
            cell.lblTask.textColor = .white
            cell.imgCrossWidth.constant = 13.0
            cell.imgVw.image = statusData.1
        }else{
            cell.greenView.backgroundColor = UIColor.white
            cell.lblTask.textColor = .init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            cell.imgCrossWidth.constant = 0.0
            cell.imgVw.image = statusData.1
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth / 3
        return CGSize(width: widthPerItem, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let statusType : Int = equipementStatuss[indexPath.row].rawValue
        if let index = selectedExpencesforFilter.firstIndex(of:statusType) {
            selectedExpencesforFilter.remove(at: index)
         
            self.filteredRemark.removeAll()
            self.filteredsNoRemark.removeAll()
            buttonFilters = false
            buttonFilter = false
            setData()
        }else{
            self.selectedExpencesforFilter.removeAll()
            selectedExpencesforFilter.append(statusType)
            if  indexPath.item == 0
            {

                buttonFilters = false
                buttonFilter = true
                self.filteredRemark.removeAll()
                self.filteredsNoRemark.removeAll()
                
                for equipmentDatum in equipmentData {
                    if  equipmentDatum.remark != "" {
                        self.filteredRemark.append(equipmentDatum)
                       
                    }
                }
                
            }else if  indexPath.item == 1
            {

                
                buttonFilter = false
                buttonFilters = true
               
                self.filteredsNoRemark.removeAll()
                self.filteredRemark.removeAll()
              
                for equipmentDatum in equipmentData {
                    if equipmentDatum.remark == "" {
                        
                        self.filteredsNoRemark.append(equipmentDatum)
                        
                    }
                }
                
            }
        }
        
      
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        collectVwFilter.reloadData()
        
    }
    
        
        //==========================
        // MARK:- Tableview methods
        //==========================

        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        if buttonFilter == true{
            return filteredRemark.count
        }else if buttonFilters == true{
            return filteredsNoRemark.count
        }
        return equipmentData.count
      //  return equipDataPartArr.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if buttonFilter == true{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "quipmentCell",for: indexPath) as! EquipmentCell
            if isDropDwon == true{
                cell.partView_H.constant = 45
            }
          
            cell.delegate = self
        
            cell.btnDefaults.setTitle("View Details", for: .normal)
            cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
            let modl = LanguageKey.model_no
            let serl = LanguageKey.serial_no
            let expireDateLbl = LanguageKey.warranty_expiry_date
      
            let cond = LanguageKey.condition
            let remark = LanguageKey.remark
            let equipment = filteredRemark[indexPath.row]
          
            cell.setPartData(equipArray: equipment )
          
            let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
          
            vc.setPartDataArr(equipArray: equipmentData[indexPath.row].equComponent ?? [])
           
            
            if  equipment.equStatus == "1" {
                
                cell.deployView.isHidden = true
                
            }else{
                if  equipment.equStatus != "" {
                    
                    for poIdnm in equipmentsStatus {
                          self.poIdNam = ""
                        if  poIdnm.esId == equipment.equStatus {
                            
                            self.poIdNam = poIdnm.statusText ?? ""
                            
                            cell.deployLbl.text = poIdNam
                            
                           // print("poIdNam ------------------------------ \(poIdNam)")
                           // print(equipment.equnm)
                            if poIdNam == "Deployed" {
                               //// cell.deployLbl.text = LanguageKey.deployed
                                self.replacePart = true
                                cell.deployView.backgroundColor =  UIColor(red: 238/255.0, green: 174/255.0, blue: 91/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor = UIColor.white
                            }else if poIdNam == "Discarded" {
                               // cell.deployLbl.text = "Discarded"
                                self.replacePart = false
                                cell.deployView.backgroundColor =  UIColor(red: 249/255.0, green: 110/255.0, blue: 114/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor =   UIColor.white
                            }else if poIdNam == "Available" {
                              //  cell.deployLbl.text = "Available"
                                self.replacePart = true
                                cell.deployView.backgroundColor =  UIColor(red: 238/255.0, green: 174/255.0, blue: 91/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor = UIColor.white
                            }
                            
                        }
                    }
                    
                }
                
            }
            
         
            
            if equipment.statusUpdateDate != "" {
                if equipment.statusUpdateDate != nil  {
                    cell.deployDateLbl.text = convertTimestampToDateForPayment(timeInterval: (equipment.statusUpdateDate ?? ""))
                }else {
                    cell.deployDateLbl.text = ""
                    cell.H_dateLabel.constant = 0
                }
              
            }else{
                cell.deployDateLbl.text = ""
                cell.H_dateLabel.constant = 0
            }
           
            
                let imageEq = equipment.image
                        
                       if imageEq != nil {
                           let ar = URL(string: Service.BaseUrl)?.absoluteString
                           let ab = equipment.image
                         
                           var ii:URL = URL(string: ar! + ab!)!
                             
                                   DispatchQueue.global().async { [weak self] in
                                       if let data = try? Data(contentsOf: ii) {
                                           if let image = UIImage(data: data) {
                                               DispatchQueue.main.async {
                                                   cell.equipmentImg.image = image
                                               }
                                           }
                                       }
                                   }
                             
                       }else{
                           cell.equipmentImg.image = UIImage(named: "logineBackImg-1")
                       }
                self.equipIdName = equipment.equId!
                
               // print("equipIdName ============== \(equipIdName)")
               // print("parentIdName ============== \(equipment.parentId)")
                //self.typeId = equipment.type ?? ""
                if equipment.isPart == "0"{
                   
                    
                    
                    
                   if equipment.attachments?.count == 1 {

                        cell.imgFirst.isHidden = false
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 116
                        cell.imgSecond.isHidden = true
                        cell.imgThird.isHidden = true
                     cell.attechRemrkBtn.isHidden = true
                        if let img = equipment.attachments?[0].attachThumnailFileName {
                            let imageUrl = Service.BaseUrl + img
                            cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                        }else{
                            cell.imgFirst.image = UIImage(named: "unknownDoc")
                            
                        }
                    } else if equipment.attachments?.count == 2 {
                        cell.imgView_H.constant = 116
                        cell.imgCount.isHidden = true
                        cell.imgThird.isHidden = true
                        cell.imgFirst.isHidden = false
                        cell.imgSecond.isHidden = false
                     cell.attechRemrkBtn.isHidden = true
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
                        
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 0
                        cell.imgSecond.isHidden = true
                        cell.imgFirst.isHidden = true
                        cell.imgThird.isHidden = true
                         cell.attechRemrkBtn.isHidden = true
                    }else {
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
                    
                    
                    cell.remarkDisc.text = equipment.remark
                    cell.lblName.text = equipment.equnm
                    cell.partLbl.isHidden = true
                    cell.partLbl.text = LanguageKey.parts
                    cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
                }
                else{
                    
                   if equipment.attachments?.count == 1 {
                    
                
                        cell.imgFirst.isHidden = false
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 116
                        cell.imgSecond.isHidden = true
                        cell.imgThird.isHidden = true
                     cell.attechRemrkBtn.isHidden = true
                        if let img = equipment.attachments?[0].attachThumnailFileName {
                            let imageUrl = Service.BaseUrl + img
                            cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                        }else{
                            cell.imgFirst.image = UIImage(named: "unknownDoc")
                            
                        }
                    } else if equipment.attachments?.count == 2 {
                        cell.imgView_H.constant = 116
                        cell.imgCount.isHidden = true
                        cell.imgThird.isHidden = true
                     cell.attechRemrkBtn.isHidden = true
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
                        
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 0
                        cell.imgSecond.isHidden = true
                        cell.imgFirst.isHidden = true
                        cell.imgThird.isHidden = true
                        cell.attechRemrkBtn.isHidden = true
                        
                    }else {
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
                    cell.partLbl.text = LanguageKey.parts
                    
                    
                    cell.remarkDisc.text = equipment.remark
                    cell.lblName.text = equipment.equnm
                    cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
                    //cell.lblName.textColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
                }
                
                if equipment.status == "" &&  equipment.remark == ""{
                    cell.remarkView_H.constant = 0
                }else{
                   cell.remarkView_H.constant = 111
                }
                
                // cell.lblName.text = equipment.equnm
                cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
                cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
                cell.lblAddress.text = equipment.location
                let expiryDate = (equipment.expiryDate != "") ? convertTimeStampToString(timestamp: equipment.expiryDate!, dateFormate: DateFormate.ddMMyy) : ""
            
                cell.remarkLbl.text = "\(expireDateLbl) : \(expiryDate)"
                
                //let status = Int(equipment.equStatus!)
                
                
    //            if  equipment.equStatus != "" {
    //
    //                for poIdnm in equipmentsStatus {
    //
    //                    if  poIdnm.esId == equipment.equStatus {
    //
    //                        self.poIdNam = poIdnm.statusText ?? ""
    //                        print("Equipment Status --------------------------------------------\(poIdNam)")
    //
    //                    }
    //
    //
    //                }
    //
    //                cell.conditationLbl.text = poIdNam
    //    //self.poNumbetLbl.isHidden = false
    //            }else{
    //
    //               // self.poNumbetLbl.isHidden = true
    //               // self.poNumber.text = ""
    //            }
                
        //        for statusList in equipmentsStatus {
        //
        //            var statusVelue = statusList.esId
        //            if statusVelue == status {
        //                cell.conditationLbl.text = "Condition :" + " \(statusVelue)"
        //            }
        //
        //        }
                
        //        if status == 5663 {
        //
        //            cell.conditationLbl.text = "\(cond) : Good"
        //        } else if status == 5665 {
        //
        //            cell.conditationLbl.text = "\(cond) : Need to be Repaired"
        //        }else if status == 5666 {
        //
        //            cell.conditationLbl.text = "\(cond) : Not Working"
        //        }else if status == 5664 {
        //
        //            cell.conditationLbl.text = "\(cond) : Poor"
        //        }else{
        //            cell.conditationLbl.text = "\(LanguageKey.condition):"
        //        }
        //
                
              //  cell.remarkLbl.text = "\(remark) : \(equipment.remark ?? "")"
                cell.conditationLbl.text = equipment.statusText ?? ""
                
                //
                if equipment.remark == ""  {
                    cell.remarkEditBt.isHidden = true
                    cell.btnRemark.isHidden = false
                     cell.btnRemark.setTitle("\(LanguageKey.remark)", for: .normal)
                    cell.btnRemark.setTitle("\(LanguageKey.remark_added)", for: .normal)
                   // cell.imageEquip.image = UIImage(named: "Remark")
                   // cell.btnRemark.setTitleColor(UIColor.themeMoreButtonLinkYellow, for: .normal)
                    //cell.btnRemark.setTitleColor(UIColor(named: "868F90"), for: .normal)
                    //cell.btnRemark.isHidden = true
                    
                }else{
                    cell.remarkEditBt.isHidden = false
                    cell.btnRemark.isHidden = true
                    
                     cell.btnRemark.setTitle("\(LanguageKey.remark_added)", for: .normal)
                    cell.btnRemark.setTitle("\(LanguageKey.view_details)", for: .normal)
                   // cell.imageEquip.image = UIImage(named: "Remak-added")
                    
                    cell.btnRemark.setTitleColor(UIColor.themeMoreButtonLink, for: .normal)
                    
                }
                cell.btnDefaults.addTarget(self, action: #selector(buttonbtnlikePressed), for: .touchUpInside)
                cell.btnDefaults.tag = indexPath.row
                
                cell.btnRemark.addTarget(self, action: #selector(buttonbtnlikePressedRemark), for: .touchUpInside)
                cell.btnRemark.tag = indexPath.row
                
                
                cell.remarkEditBt.addTarget(self, action: #selector(EditbuttonbtnlikePressedRemark), for: .touchUpInside)
                cell.remarkEditBt.tag = indexPath.row
               
                
                cell.attechRemrkBtn.addTarget(self, action: #selector(attechRemrkBtnPressedRemark), for: .touchUpInside)
                cell.attechRemrkBtn.tag = indexPath.row
                
                cell.dropDownPartBtn.addTarget(self, action: #selector(partBtnPressedRemark), for: .touchUpInside)
                cell.dropDownPartBtn.tag = indexPath.row
            
               
                
           
                 cell.sizeToFit()
                
                
    //        }else{
    //
    //            func partBtnPressedRemark(_ sender: UIButton) {
    //                let point = sender.convert(CGPoint.zero, to: tableView)
    //                guard let indx = tableView.indexPathForRow(at: point) else {
    //                    return
    //                }
    //                equipDataPartArr.remove(at: indexPath.row)
    //                tableView.deleteRows(at: [indexPath], with: .left)
    //            }
    //
 
            
            return cell
        }else if buttonFilters == true{
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "quipmentCell",for: indexPath) as! EquipmentCell
            if isDropDwon == true{
                cell.partView_H.constant = 45
            }
          
            cell.delegate = self
       
            cell.btnDefaults.setTitle("View Details", for: .normal)
            cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
            let modl = LanguageKey.model_no
            let serl = LanguageKey.serial_no
            let expireDateLbl = LanguageKey.warranty_expiry_date
          
            let cond = LanguageKey.condition
            let remark = LanguageKey.remark
            let equipment = filteredsNoRemark[indexPath.row]
       
            cell.setPartData(equipArray: equipment )
          
            let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
       
            vc.setPartDataArr(equipArray: equipmentData[indexPath.row].equComponent ?? [])
      
            if  equipment.equStatus == "1" {
                
                cell.deployView.isHidden = true
                
            }else{
                if  equipment.equStatus != "" {
                    
                    for poIdnm in equipmentsStatus {
                          self.poIdNam = ""
                        if  poIdnm.esId == equipment.equStatus {
                            
                            self.poIdNam = poIdnm.statusText ?? ""
                            
                            cell.deployLbl.text = poIdNam
                            
                            //("poIdNam ------------------------------ \(poIdNam)")
                          //  print(equipment.equnm)
                            if poIdNam == "Deployed" {
                               //// cell.deployLbl.text = LanguageKey.deployed
                                self.replacePart = true
                                cell.deployView.backgroundColor =  UIColor(red: 238/255.0, green: 174/255.0, blue: 91/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor = UIColor.white
                            }else if poIdNam == "Discarded" {
                               // cell.deployLbl.text = "Discarded"
                                self.replacePart = false
                                cell.deployView.backgroundColor =  UIColor(red: 249/255.0, green: 110/255.0, blue: 114/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor =   UIColor.white
                            }else if poIdNam == "Available" {
                              //  cell.deployLbl.text = "Available"
                                self.replacePart = true
                                cell.deployView.backgroundColor =  UIColor(red: 238/255.0, green: 174/255.0, blue: 91/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor = UIColor.white
                            }
                            
                        }
                    }
                    
                }
                
            }
            
         
            
            if equipment.statusUpdateDate != "" {
                if equipment.statusUpdateDate != nil  {
                    cell.deployDateLbl.text = convertTimestampToDateForPayment(timeInterval: (equipment.statusUpdateDate ?? ""))
                }else {
                    cell.deployDateLbl.text = ""
                    cell.H_dateLabel.constant = 0
                }
              
            }else{
                cell.deployDateLbl.text = ""
                cell.H_dateLabel.constant = 0
            }
           
            
                let imageEq = equipment.image
                        
                       if imageEq != nil {
                           let ar = URL(string: Service.BaseUrl)?.absoluteString
                           let ab = equipment.image
                         
                           var ii:URL = URL(string: ar! + ab!)!
                             
                                   DispatchQueue.global().async { [weak self] in
                                       if let data = try? Data(contentsOf: ii) {
                                           if let image = UIImage(data: data) {
                                               DispatchQueue.main.async {
                                                   cell.equipmentImg.image = image
                                               }
                                           }
                                       }
                                   }
                             
                       }else{
                           cell.equipmentImg.image = UIImage(named: "logineBackImg-1")
                       }
                self.equipIdName = equipment.equId!
                
               // print("equipIdName ============== \(equipIdName)")
               // print("parentIdName ============== \(equipment.parentId)")
                //self.typeId = equipment.type ?? ""
                if equipment.isPart == "0"{
                   
                    
                    
                    
                   if equipment.attachments?.count == 1 {

                        cell.imgFirst.isHidden = false
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 116
                        cell.imgSecond.isHidden = true
                        cell.imgThird.isHidden = true
                     cell.attechRemrkBtn.isHidden = true
                        if let img = equipment.attachments?[0].attachThumnailFileName {
                            let imageUrl = Service.BaseUrl + img
                            cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                        }else{
                            cell.imgFirst.image = UIImage(named: "unknownDoc")
                            
                        }
                    } else if equipment.attachments?.count == 2 {
                        cell.imgView_H.constant = 116
                        cell.imgCount.isHidden = true
                        cell.imgThird.isHidden = true
                        cell.imgFirst.isHidden = false
                        cell.imgSecond.isHidden = false
                     cell.attechRemrkBtn.isHidden = true
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
                        
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 0
                        cell.imgSecond.isHidden = true
                        cell.imgFirst.isHidden = true
                        cell.imgThird.isHidden = true
                         cell.attechRemrkBtn.isHidden = true
                    }else {
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
                    
                    
                    cell.remarkDisc.text = equipment.remark
                    cell.lblName.text = equipment.equnm
                    cell.partLbl.isHidden = true
                    cell.partLbl.text = LanguageKey.parts
                    cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
                }
                else{
                    
                   if equipment.attachments?.count == 1 {
                    
                
                        cell.imgFirst.isHidden = false
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 116
                        cell.imgSecond.isHidden = true
                        cell.imgThird.isHidden = true
                     cell.attechRemrkBtn.isHidden = true
                        if let img = equipment.attachments?[0].attachThumnailFileName {
                            let imageUrl = Service.BaseUrl + img
                            cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                        }else{
                            cell.imgFirst.image = UIImage(named: "unknownDoc")
                            
                        }
                    } else if equipment.attachments?.count == 2 {
                        cell.imgView_H.constant = 116
                        cell.imgCount.isHidden = true
                        cell.imgThird.isHidden = true
                     cell.attechRemrkBtn.isHidden = true
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
                        
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 0
                        cell.imgSecond.isHidden = true
                        cell.imgFirst.isHidden = true
                        cell.imgThird.isHidden = true
                        cell.attechRemrkBtn.isHidden = true
                        
                    }else {
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
                    cell.partLbl.text = LanguageKey.parts
                    
                    
                    cell.remarkDisc.text = equipment.remark
                    cell.lblName.text = equipment.equnm
                    cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
                    //cell.lblName.textColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
                }
                
                if equipment.status == "" &&  equipment.remark == ""{
                    cell.remarkView_H.constant = 0
                }else{
                   cell.remarkView_H.constant = 111
                }
        
                cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
                cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
                cell.lblAddress.text = equipment.location
                let expiryDate = (equipment.expiryDate != "") ? convertTimeStampToString(timestamp: equipment.expiryDate!, dateFormate: DateFormate.ddMMyy) : ""
            
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd-MM-yyyy"
//            formatter.timeZone = TimeZone.current
//            formatter.locale = Locale(identifier: "en_US")
//            let strDate = formatter.string(from: Date())
//
//            if strDate > expiryDate {
//                cell.remarkLbl.textColor = UIColor.red
//            }
           
                cell.remarkLbl.text = "\(expireDateLbl) : \(expiryDate)"
                
       
                cell.conditationLbl.text = equipment.statusText ?? ""
                
               
                if equipment.remark == ""  {
                    cell.remarkEditBt.isHidden = true
                    cell.btnRemark.isHidden = false
                    // cell.btnRemark.setTitle("\(LanguageKey.remark)", for: .normal)
                    cell.btnRemark.setTitle("\(LanguageKey.add_remark)", for: .normal) //(d)
                  
                    
                }else{
                    cell.remarkEditBt.isHidden = false
                    cell.btnRemark.isHidden = true
                    
                     cell.btnRemark.setTitle("\(LanguageKey.remark_added)", for: .normal)
                    cell.btnRemark.setTitle("\(LanguageKey.view_details)", for: .normal)
                  
                    
                    cell.btnRemark.setTitleColor(UIColor.themeMoreButtonLink, for: .normal)
                    
                }
                cell.btnDefaults.addTarget(self, action: #selector(buttonbtnlikePressed), for: .touchUpInside)
                cell.btnDefaults.tag = indexPath.row
                
                cell.btnRemark.addTarget(self, action: #selector(buttonbtnlikePressedRemark), for: .touchUpInside)
                cell.btnRemark.tag = indexPath.row
                
                
                cell.remarkEditBt.addTarget(self, action: #selector(EditbuttonbtnlikePressedRemark), for: .touchUpInside)
                cell.remarkEditBt.tag = indexPath.row
               
                
                cell.attechRemrkBtn.addTarget(self, action: #selector(attechRemrkBtnPressedRemark), for: .touchUpInside)
                cell.attechRemrkBtn.tag = indexPath.row
                
                cell.dropDownPartBtn.addTarget(self, action: #selector(partBtnPressedRemark), for: .touchUpInside)
                cell.dropDownPartBtn.tag = indexPath.row
            
               
                
           
                 cell.sizeToFit()

            return cell
        }else{
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "quipmentCell",for: indexPath) as! EquipmentCell
            if isDropDwon == true{
                cell.partView_H.constant = 40
            }
          
            cell.delegate = self
          
            cell.btnDefaults.setTitle(LanguageKey.view_details, for: .normal)
           // cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
            cell.btnRemark.setTitle("  \(LanguageKey.add_remark)" , for: .normal)
            let modl = LanguageKey.model_no
            let serl = LanguageKey.serial_no
            let expireDateLbl = LanguageKey.warranty_expiry_date
       
            let cond = LanguageKey.condition
            let remark = LanguageKey.remark
            let equipment = equipmentData[indexPath.row]
         
            if equipment.equComponent!.count == 0  {
                
                cell.partLbl1.isHidden = true
                cell.partBtn.isHidden = true
                cell.dropDownPartBtn.isHidden = true
                cell.partLineLbl.isHidden = true
                
            }else{
                cell.partLbl1.isHidden = false
                cell.partBtn.isHidden = false
                cell.dropDownPartBtn.isHidden = false
                cell.partLineLbl.isHidden = false
            }
            
            cell.setPartData(equipArray: equipment )
        
            let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
           
            vc.setPartDataArr(equipArray: equipmentData[indexPath.row].equComponent ?? [])

            
            if  equipment.equStatus == "1" {
                
                cell.deployView.isHidden = true
                
            }else{
                if  equipment.equStatus != "" {
                    
                    for poIdnm in equipmentsStatus {
                          self.poIdNam = ""
                        if  poIdnm.esId == equipment.equStatus {
                            
                            self.poIdNam = poIdnm.statusText ?? ""
                            
                            cell.deployLbl.text = poIdNam
                            
                           // print("poIdNam ------------------------------ \(poIdNam)")
                           // print(equipment.equnm)
                            if poIdNam == "Deployed" {
                               //// cell.deployLbl.text = LanguageKey.deployed
                                self.replacePart = true
                                cell.deployView.backgroundColor =  UIColor(red: 238/255.0, green: 174/255.0, blue: 91/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor = UIColor.white
                            }else if poIdNam == "Discarded" {
                               // cell.deployLbl.text = "Discarded"
                                self.replacePart = false
                                cell.deployView.backgroundColor =  UIColor(red: 249/255.0, green: 110/255.0, blue: 114/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor =   UIColor.white
                            }else if poIdNam == "Available" {
                              //  cell.deployLbl.text = "Available"
                                self.replacePart = true
                                cell.deployView.backgroundColor =  UIColor(red: 238/255.0, green: 174/255.0, blue: 91/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor = UIColor.white
                            }
                            
                        }
                    }
                    
                }
                
            }
            
         
            
            if equipment.statusUpdateDate != "" {
                if equipment.statusUpdateDate != nil  {
                    cell.deployDateLbl.text = convertTimestampToDateForPayment(timeInterval: (equipment.statusUpdateDate ?? ""))
                }else {
                    cell.deployDateLbl.text = ""
                    cell.H_dateLabel.constant = 0
                }
              
            }else{
                cell.deployDateLbl.text = ""
                cell.H_dateLabel.constant = 0
            }
           
            
                let imageEq = equipment.image
                        
                       if imageEq != nil {
                           let ar = URL(string: Service.BaseUrl)?.absoluteString
                           let ab = equipment.image
                         
                           var ii:URL = URL(string: ar! + ab!)!
                             
                                   DispatchQueue.global().async { [weak self] in
                                       if let data = try? Data(contentsOf: ii) {
                                           if let image = UIImage(data: data) {
                                               DispatchQueue.main.async {
                                                   cell.equipmentImg.image = image
                                               }
                                           }
                                       }
                                   }
                             
                       }else{
                           cell.equipmentImg.image = UIImage(named: "logineBackImg-1")
                       }
                self.equipIdName = equipment.equId!
                
               // print("equipIdName ============== \(equipIdName)")
               // print("parentIdName ============== \(equipment.parentId)")
                //self.typeId = equipment.type ?? ""
                if equipment.isPart == "0"{
                   
                    
                    
                    
                   if equipment.attachments?.count == 1 {

                        cell.imgFirst.isHidden = false
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 116
                        cell.imgSecond.isHidden = true
                        cell.imgThird.isHidden = true
                     cell.attechRemrkBtn.isHidden = true
                        if let img = equipment.attachments?[0].attachThumnailFileName {
                            let imageUrl = Service.BaseUrl + img
                            cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                        }else{
                            cell.imgFirst.image = UIImage(named: "unknownDoc")
                            
                        }
                    } else if equipment.attachments?.count == 2 {
                        cell.imgView_H.constant = 116
                        cell.imgCount.isHidden = true
                        cell.imgThird.isHidden = true
                        cell.imgFirst.isHidden = false
                        cell.imgSecond.isHidden = false
                     cell.attechRemrkBtn.isHidden = true
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
                        
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 0
                        cell.imgSecond.isHidden = true
                        cell.imgFirst.isHidden = true
                        cell.imgThird.isHidden = true
                         cell.attechRemrkBtn.isHidden = true
                    }else {
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
                    
                    
                    cell.remarkDisc.text = equipment.remark
                    cell.lblName.text = equipment.equnm
                    cell.partLbl.isHidden = true
                    cell.partLbl.text = LanguageKey.parts
                    cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
                }
                else{
                    
                   if equipment.attachments?.count == 1 {
                    
                
                        cell.imgFirst.isHidden = false
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 116
                        cell.imgSecond.isHidden = true
                        cell.imgThird.isHidden = true
                     cell.attechRemrkBtn.isHidden = true
                        if let img = equipment.attachments?[0].attachThumnailFileName {
                            let imageUrl = Service.BaseUrl + img
                            cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                        }else{
                            cell.imgFirst.image = UIImage(named: "unknownDoc")
                            
                        }
                    } else if equipment.attachments?.count == 2 {
                        cell.imgView_H.constant = 116
                        cell.imgCount.isHidden = true
                        cell.imgThird.isHidden = true
                     cell.attechRemrkBtn.isHidden = true
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
                        
                        cell.imgCount.isHidden = true
                        cell.imgView_H.constant = 0
                        cell.imgSecond.isHidden = true
                        cell.imgFirst.isHidden = true
                        cell.imgThird.isHidden = true
                        cell.attechRemrkBtn.isHidden = true
                        
                    }else {
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
                    cell.partLbl.text = LanguageKey.parts
                    
                    
                    cell.remarkDisc.text = equipment.remark
                    cell.lblName.text = equipment.equnm
                    cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
                    //cell.lblName.textColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
                }
                
                if equipment.status == "" &&  equipment.remark == ""{
                    cell.remarkView_H.constant = 0
                }else{
                   cell.remarkView_H.constant = 111
                }
                
                // cell.lblName.text = equipment.equnm
                cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
                cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
                cell.lblAddress.text = equipment.location
                let expiryDate = (equipment.expiryDate != "") ? convertTimeStampToString(timestamp: equipment.expiryDate!, dateFormate: DateFormate.ddMMyy) : ""
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd/MM/yyyy"
//            formatter.timeZone = TimeZone.current
//            formatter.locale = Locale(identifier: "en_US")
//            let strDate = formatter.string(from: Date())
//
//
//                cell.remarkLbl.text = "\(expireDateLbl) : \(expiryDate)"
//
//            if expiryDate != "" {
//            if strDate == expiryDate {
//                cell.remarkLbl.textColor = UIColor.red
//            }
//            }
                cell.conditationLbl.text = equipment.statusText ?? ""
                
         
                if equipment.remark == ""  {
                    cell.remarkEditBt.isHidden = true
                    cell.btnRemark.isHidden = false
                  //   cell.btnRemark.setTitle("\(LanguageKey.remark)", for: .normal)
                   // cell.btnRemark.setTitle("\(LanguageKey.remark_added)", for: .normal)
                    cell.btnRemark.setTitle("  \(LanguageKey.add_remark)" , for: .normal)
                    
                }else{
                    cell.remarkEditBt.isHidden = false
                    cell.btnRemark.isHidden = true
                    
                     cell.btnRemark.setTitle("\(LanguageKey.remark_added)", for: .normal)
                     cell.btnRemark.setTitle("\(LanguageKey.view_details)", for: .normal)
                   // cell.imageEquip.image = UIImage(named: "Remak-added")
                    
                    cell.btnRemark.setTitleColor(UIColor.themeMoreButtonLink, for: .normal)
                    
                }
                cell.btnDefaults.addTarget(self, action: #selector(buttonbtnlikePressed), for: .touchUpInside)
                cell.btnDefaults.tag = indexPath.row
                
                cell.btnRemark.addTarget(self, action: #selector(buttonbtnlikePressedRemark), for: .touchUpInside)
                cell.btnRemark.tag = indexPath.row
                
                
                cell.remarkEditBt.addTarget(self, action: #selector(EditbuttonbtnlikePressedRemark), for: .touchUpInside)
                cell.remarkEditBt.tag = indexPath.row
               
                
                cell.attechRemrkBtn.addTarget(self, action: #selector(attechRemrkBtnPressedRemark), for: .touchUpInside)
                cell.attechRemrkBtn.tag = indexPath.row
                
                cell.dropDownPartBtn.addTarget(self, action: #selector(partBtnPressedRemark), for: .touchUpInside)
                cell.dropDownPartBtn.tag = indexPath.row
            
           
                 cell.sizeToFit()
                

            return cell
        }
       // return cell
 
    }
    
//    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
//        let tappedImage = sender!.view as! UIImageView
//        EXPhotoViewer.showImage(from: tappedImage)
//    }
    
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
    //==========================
    // MARK:- Textfield methods
    //==========================
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
//        if result.count > 2 || result.count == 0 {
//            var query = ""
//                    if result != "" {
//                   query = "snm CONTAINS[c] '\(result)'"
//                    showDataOnTableView(query: query == "" ? nil : query)
//               }
//       }
        var intValue:Int?
        var stringValue:String?
        intValue = Int(result)
        stringValue = result
        var query = ""
        //var query = ""
        if result.count > 2 || result.count == 0 {
            
            if result != "" {
                if intValue is Int {
                    if intValue is Int {
                        //let lower = result.uppercased().capitalizingFirstLetter()
                        let filtered = equipmentData.filter{ $0.mno!.contains(result) }
                        filtered.forEach { print($0) }
                        if filtered.count != 0 {
                            lblEqListNo.text = "\(LanguageKey.list_item) \(String(filtered.count))"
                            equipmentData = filtered
                        }
                       
                        let barcode = equipmentData.filter{ $0.barcode!.contains(result) }
                        barcode.forEach { print($0) }
                        if barcode.count != 0 {
                            lblEqListNo.text = "\(LanguageKey.list_item) \(String(barcode.count))"
                            equipmentData = barcode
                        }
                    }
                    else {
                        //let lower = result.uppercased().capitalizingFirstLetter()
                        let filtered = equipmentData.filter{ $0.sno!.contains(result) }
                        filtered.forEach { print($0) }
                        if filtered.count != 0 {
                            lblEqListNo.text = "\(LanguageKey.list_item) \(String(filtered.count))"
                            equipmentData = filtered
                        }
                        
                    }
                }else {
                    let lower = result.lowercased().capitalizingFirstLetter()
                    let filtered = equipmentData.filter{ $0.equnm!.contains(lower) }
                    filtered.forEach { print($0) }
                    if filtered.count != 0 {
                        lblEqListNo.text = "\(LanguageKey.list_item) \(String(filtered.count))"
                        equipmentData = filtered
                    }
                   
                }
                
                
            }else {
                
                
                filterequipmentData.removeAll()
                setData()
                equipmentData = filterequipmentData
                showDataOnTableView(query: query == "" ? nil : query)
               // print(equipmentData.count)
               // print(filterequipmentData.count)
                
            }
            tableView.reloadData()
            //showDataOnTableView(query: query == "" ? nil : query)
        }else{
           // tableView.reloadData()
           // showDataOnTableView(query: query == "" ? nil : query)
        }
    
               
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
        
 
    
      func showDataOnTableView(query : String?) -> Void {
       // arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as! [ClientList]
        /////////////
        
        
                    equipmentData.removeAll()
                    let searchQuery = "jobId = '\(objOfUserJobListInDetails?.jobId ?? "")'"
                    let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
                    if isExist.count > 0{
                        objOfUserJobListInDetails!.equArray = isExist[0].equArray
                           if objOfUserJobListInDetails!.equArray != nil {
                            for item in (objOfUserJobListInDetails!.equArray as! [AnyObject]) {
                            if let dta = item as? equArray {
                                                            
                                                         //   print(dta)
                                                            
                            }else{
                                var arrTac = [AttechmentArry]()
                                
                               if item["attachments"] != nil {
                                
                                let attachments =  item["attachments"] as? [AnyObject]
                                if attachments?.count ?? 0 > 0 {
                                     
                                    for attechDic in attachments! {
                                      arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                                }
        //                         for item in (objOfUserJobListInDetails!.equArray as! [AnyObject]) {
                                    let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                    
                                    typeId = dic.type!
                                    //////
                                     equipmentData.append(dic)
                                    if equipmentData.count != 0 {
                                         equipmentData = equipmentData.sorted { $0.snm?.localizedCaseInsensitiveCompare($1.snm!) == ComparisonResult.orderedAscending }
                                             
                                             
                                            // print(equipmentData)
                                         DispatchQueue.main.async {
                                                        self.tableView.reloadData()
                                                    }
                                         }
                                    /////////
                                       
                                    // print(equipmentDic.self) snm

                                    // if let dta = item as? equipData {
                                    // }
                                    }else {
                                             let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                    typeId = dic.type!
                                    equipmentData.append(dic)
                                    if equipmentData.count != 0 {
                                        equipmentData = equipmentData.sorted { $0.snm?.localizedCaseInsensitiveCompare($1.snm!) == ComparisonResult.orderedAscending }
                                        
                                        
                                       // print(equipmentData)
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                    }
                                    /////////
                                }
                                }
                                }
                            }
                        }
        }
                    self.tableView.reloadData()
                    self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipmentData.count))"
                    var arr = self.equipmentData.count
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
                    
      
    }
    
    
    @objc func buttonbtnlikePressedRemark(_ sender: UIButton) {
        if buttonFilter == true{
           
            var on = "Off"
            UserDefaults.standard.set(on, forKey: "partView_H")
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as?  EquipmentCell
            let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
            vc.equipment = filteredRemark[sender.tag]//equipDataPartArr[sender.tag].equeDic!
            vc.objOfUserJobListInDoc = objOfUserJobListInDetails!
            vc.objOfUserJobListInDetail = objOfUserJobListInDetails
            vc.replacePartReport = replacePart
            vc.equipmentsStatusPart = equipmentsStatus
            vc.filterequipmentData =  equipmentData[sender.tag].equComponent!//equipDataPartArr[sender.tag].equePartArr!
            self.navigationController?.pushViewController(vc, animated: true)
        }else if buttonFilters == true{
         
            let on = "Off"
            UserDefaults.standard.set(on, forKey: "partView_H")
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as?  EquipmentCell
            let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
            vc.equipment = filteredsNoRemark[sender.tag]//equipDataPartArr[sender.tag].equeDic!
            vc.objOfUserJobListInDoc = objOfUserJobListInDetails!
            vc.objOfUserJobListInDetail = objOfUserJobListInDetails
            vc.replacePartReport = replacePart
            vc.equipmentsStatusPart = equipmentsStatus
            vc.filterequipmentData =  equipmentData[sender.tag].equComponent!//equipDataPartArr[sender.tag].equePartArr!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let on = "Off"
            UserDefaults.standard.set(on, forKey: "partView_H")
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as?  EquipmentCell
            let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
            vc.equipment = equipmentData[sender.tag]//equipDataPartArr[sender.tag].equeDic!
            vc.objOfUserJobListInDoc = objOfUserJobListInDetails!
            vc.objOfUserJobListInDetail = objOfUserJobListInDetails
            vc.replacePartReport = replacePart
            vc.equipmentsStatusPart = equipmentsStatus
            vc.filterequipmentData =  equipmentData[sender.tag].equComponent!//equipDataPartArr[sender.tag].equePartArr!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    @objc func EditbuttonbtnlikePressedRemark(_ sender: UIButton) {
        
        if buttonFilter == true{
          
            
            let on = "Off"
            UserDefaults.standard.set(on, forKey: "partView_H")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
            vc.equipment =  filteredRemark[sender.tag]//equipDataPartArr[sender.tag].equeDic!//equipmentData[indexpath.row]
            vc.objOfUserJobListInDoc = objOfUserJobListInDetails!
            vc.objOfUserJobListInDetail = objOfUserJobListInDetails
            vc.filterequipmentData = equipmentData[sender.tag].equComponent!//equipDataPartArr[sender.tag].equePartArr!
            self.navigationController?.pushViewController(vc, animated: true)
        }else if buttonFilters == true{
            
            
            let on = "Off"
            UserDefaults.standard.set(on, forKey: "partView_H")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
            vc.equipment =  filteredsNoRemark[sender.tag]//equipDataPartArr[sender.tag].equeDic!//equipmentData[indexpath.row]
            vc.objOfUserJobListInDoc = objOfUserJobListInDetails!
            vc.objOfUserJobListInDetail = objOfUserJobListInDetails
            vc.filterequipmentData = equipmentData[sender.tag].equComponent!//equipDataPartArr[sender.tag].equePartArr!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            let on = "Off"
            UserDefaults.standard.set(on, forKey: "partView_H")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
            vc.equipment =  equipmentData[sender.tag]//equipDataPartArr[sender.tag].equeDic!//equipmentData[indexpath.row]
            vc.objOfUserJobListInDoc = objOfUserJobListInDetails!
            vc.objOfUserJobListInDetail = objOfUserJobListInDetails
            vc.filterequipmentData = equipmentData[sender.tag].equComponent!//equipDataPartArr[sender.tag].equePartArr!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
       
       }
    
    @objc func attechRemrkBtnPressedRemark(_ sender: UIButton) {
              
              let indexpath = IndexPath(row: sender.tag, section: 0)
              let vc = storyboard?.instantiateViewController(withIdentifier: "AttechementRemark") as! AttechementRemark
              vc.equipment = equipmentData[indexpath.row]
              vc.objOfUserJobListInDoc = objOfUserJobListInDetails!
              self.navigationController?.pushViewController(vc, animated: true)
             
          }
    
    @objc func partBtnPressedRemark(_ sender: UIButton) {
        var on = "On"
        UserDefaults.standard.set(on, forKey: "partView_H")
       
        
        buttonIsSelected = !buttonIsSelected
        if buttonIsSelected {
            let indexPath = IndexPath(row: sender.tag, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) as?  EquipmentCell {
                self.isDropDwon = false
                cell.partView_H.constant = 232
                tableView.reloadRows(at: [indexPath], with: .none)
                
            }
        }else{
            let indexPath = IndexPath(row: sender.tag, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) as?  EquipmentCell {
                self.isDropDwon = false
                cell.partView_H.constant = 45
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
    }
    
    @objc func buttonbtnlikePressed(_ sender: UIButton) {
        
        if buttonFilter == true{
       
            var on = "Off"
            UserDefaults.standard.set(on, forKey: "partView_H")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let equipments = filteredRemark[sender.tag]
            let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
            vc.equipments = equipments
            vc.isBarcodeScannerbool = true
            vc.isEquipData = true
            vc.filterequipmentData = equipmentData[sender.tag].equComponent! //equipDataPartArr[sender.tag].equePartArr!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if buttonFilters == true{
           
            
            var on = "Off"
            UserDefaults.standard.set(on, forKey: "partView_H")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let equipments = filteredsNoRemark[sender.tag]
            let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
            vc.equipments = equipments
            vc.isBarcodeScannerbool = true
            vc.isEquipData = true
            vc.filterequipmentData = equipmentData[sender.tag].equComponent! //equipDataPartArr[sender.tag].equePartArr!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
      
            var on = "Off"
            UserDefaults.standard.set(on, forKey: "partView_H")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let equipments = equipmentData[sender.tag]
            let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
            vc.equipments = equipments
            vc.isBarcodeScannerbool = true
            vc.isEquipData = true
            vc.filterequipmentData = equipmentData[sender.tag].equComponent! //equipDataPartArr[sender.tag].equePartArr!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
       
    }
    
    @IBAction func remarkEditBtn(_ sender: Any) {
       
    }
    
    
    @IBAction func addEquipmentBtn(_ sender: Any) {
        
        let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "AddEqupment") as! AddEqupment
        loginPageView.objOfUserJodbList = self.objOfUserJobListInDetails!
           self.navigationController?.pushViewController(loginPageView, animated: true)
    }
    
        //===============================
        // MARK:- Data - Passing method
        //===============================
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if segue.identifier == "LinkEquipmentReport" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let getDetail = segue.destination as! LinkEquipmentReport
                    getDetail.equipment = equipmentData[indexPath.row]
                    getDetail.objOfUserJobListInDoc = objOfUserJobListInDetails!
                }
            }

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
                            
                            if decodedData.data!.count > 0 {
                                self.equipments = decodedData.data!
                                
                                DispatchQueue.main.async {
                                 self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                 self.tableView.reloadData()
                                    killLoader()
                                }
                            }else{
                             //   print("jugal")
                                self.equipments.removeAll()
                                DispatchQueue.main.async {
                                    self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                    self.tableView.reloadData()
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
    
    
    //==================================
    // MARK:- Equipement LIST Service methods
    //==================================
    func getEquipmentStatus(){
        
        if !isHaveNetowork() {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        
        
        let param = Params()
   
        param.limit = ""
        param.index = "0"
        param.isCondition = "1"
      
        
        serverCommunicator(url: Service.getEquipmentStatus, param: param.toDictionary) { (response, success) in
            
               DispatchQueue.main.async {
                   if self.refreshControl.isRefreshing {
                       self.refreshControl.endRefreshing()
                   }
               }
              
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(getEquipmentStatusRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data!.count > 0 {
                            self.equipmentsStatus = decodedData.data!
                            DispatchQueue.main.async {
                            self.tableView.reloadData()
                            }
                           // print(self.equipmentsStatus)
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
                            self.getEquipmentStatus()
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getEquipmentStatus()
                    }
                })
            }
        }
    }

    @objc func buttonbtnlikePressedRemarkDetailIpart(_ sender: UIButton) {
        
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let equipments = filterequipmentData[indexpath.row]
        let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
        vc.equipments = equipments
        vc.isBarcodeScannerbool = true
        vc.isEquipData = true
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    @objc func buttonbtnlikePressedRemarkIsPart(_ sender: UIButton) {
        
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
        vc.equipment = filterequipmentData[indexpath.row]
        vc.objOfUserJobListInDoc = objOfUserJobListInDetails!
        vc.objOfUserJobListInDetail = objOfUserJobListInDetails
        
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    //==================================
          // MARK:- JOB LIST Service methods
          //==================================
       
       func getJobListService(){
              

              
              let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getJobList) as? String
              let param = Params()
              param.usrId = getUserDetails()?.usrId
              param.limit = "100"
              param.index = "0"
              param.search = ""
              param.dateTime = lastRequestTime ?? ""//currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
              
              
           serverCommunicator(url: Service.getUserJobListNew, param: param.toDictionary) { [self] (response, success) in
                  

                  
                  if(success){
                      let decoder = JSONDecoder()
                      
                      if let decodedData = try? decoder.decode(jobListResponse.self, from: response as! Data) {
                          if decodedData.success == true{
                              
                              //print("jugaljob \(decodedData)")
                              
                              if let arryCount = decodedData.data{
                                  if arryCount.count > 0{
                                      
                                      
                                      
                                      self.count += (decodedData.data?.count)!
                                      
                                      if !self.isUserfirstLogin {
                                          
                                          self.saveUserJobsInDataBase(data: decodedData.data!)
                                          
                                          //Request time will be update when data comes otherwise time won't be update
                                          UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getJobList)
                                          DispatchQueue.main.async {
                                             setData()
                                          }
                                      }else{
                                          self.saveAllUserJobsInDataBase(data: decodedData.data!)
                                      }
                                  }else{
                                      //
                                  }
                              }else{
                                  
                              }
                              
                              if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                                  self.getJobListService()
                              }else{
                                  
                                  
                                  if self.isUserfirstLogin {
                                      
                                      //Request time will be update when data comes otherwise time won't be update
                                      UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getJobList)
                                     
                                  }
                                  
                                  
                                  self.saveAllGetDataInDatabase(callback: { isSuccess in
                                      if APP_Delegate.apiCallFirstTime {
                                          APP_Delegate.apiCallFirstTime = false
                                          //self.groupUserListForChat()
                                          // self.getAllCompanySettings()
                                      }else{
                                          killLoader()
                                      }
                                  })
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
                          ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                              
                              if cancel {
                                  showLoader()
                                  self.getJobListService()
                              }
                          })
                      }
                  }else{
                      ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                          if cancelButton {
                              showLoader()
                              self.getJobListService()
                          }
                      })
                  }
              }
          }
       
       func saveUserJobsInDataBase( data : [jobListData]) -> Void {
           
           for job in data{
               let query = "jobId = '\(job.jobId!)'"
               let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
               if isExist.count > 0 {
                   let existingJob = isExist[0]
                   //if Job status Cancel, Reject, Closed so this job is delete from Database
                   
                   if(job.isdelete == "0") {
                       ChatManager.shared.removeJobForChat(jobId: existingJob.jobId!)
                       DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                   }else if (Int(job.status!) == taskStatusType.Cancel.rawValue) ||
                       (Int(job.status!) == taskStatusType.Reject.rawValue) ||
                       (Int(job.status!) == taskStatusType.Closed.rawValue)
                   {
                       ChatManager.shared.removeJobForChat(jobId: existingJob.jobId!)
                       DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                   }else{
                       existingJob.setValuesForKeys(job.toDictionary!)
                       // DatabaseClass.shared.saveEntity()
                   }
               }else{
                   if(job.isdelete != "0") {
                       if (Int(job.status!) != taskStatusType.Cancel.rawValue) &&
                           (Int(job.status!) != taskStatusType.Reject.rawValue) &&
                           (Int(job.status!) != taskStatusType.Closed.rawValue)
                       {
                           let userJobs = DatabaseClass.shared.createEntity(entityName: "UserJobList")
                           userJobs?.setValuesForKeys(job.toDictionary!)
                           //DatabaseClass.shared.saveEntity()
                           
                           let query = "jobId = '\(job.tempId!)'"
                           let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
                           
                           if isExistJob.count > 0 {
                               let existing = isExistJob[0]
                               DatabaseClass.shared.deleteEntity(object: existing, callback: { (_) in})
                           }
                           
                           
                           //Create listner  for new job
                           let model = ChatManager.shared.chatModels.filter { (model) -> Bool in
                               if model.jobId == job.jobId{
                                   return true
                               }
                               return false
                           }
                           
                           if model.count == 0 {
                               let model = ChatModel(from: userJobs as! UserJobList)
                               ChatManager.shared.chatModels.append(model)
                           }
                       }
                   }
               }
           }
       }
       func saveAllUserJobsInDataBase( data : [jobListData]) -> Void {
           for job in data{
               if(job.isdelete != "0"){
                   if (Int(job.status!) != taskStatusType.Cancel.rawValue) &&
                       (Int(job.status!) != taskStatusType.Reject.rawValue) &&
                       (Int(job.status!) != taskStatusType.Closed.rawValue)
                   {
                       let userJobs = DatabaseClass.shared.createEntity(entityName: "UserJobList")
                       userJobs?.setValuesForKeys(job.toDictionary!)
                       // DatabaseClass.shared.saveEntity()
                   }
               }
           }
       }
       
       func saveAllGetDataInDatabase(callback:(Bool)  -> Void) -> Void {
           self.count = 0
           DatabaseClass.shared.saveEntity(callback: callback)
       }
    
       }
       
extension LinlEquipment: partEqDelegate  {
   
    
    func showpartRemarkView(filterArry: equipDataArray) {
        
        let equipments = filterArry
        let vc = storyboard?.instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport
        vc.equipment = equipments//filterequipmentData[indexpath.row]
        vc.objOfUserJobListInDoc = objOfUserJobListInDetails!
        vc.objOfUserJobListInDetail = objOfUserJobListInDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func showpartEqView(equipArray: equipDataArray) {
               
                let equipments = equipArray
                let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
                vc.equipments = equipments
                vc.isBarcodeScannerbool = true
                vc.isEquipData = true
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}
    
extension UIColor {
    static var themeMoreButtonLink = UIColor.init(red: 152/255, green: 152/255, blue: 152/255, alpha: 1)
    static var themeMoreButtonLinkYellow = UIColor.init(red: 235/255, green: 176/255, blue: 87/255, alpha: 1)
}
