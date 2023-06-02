//
//  EquipmentDetailVc.swift
//  EyeOnTask
//
//  Created by Altab on 07/10/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import MobileCoreServices

class EquipmentDetailVc: UIViewController, UITableViewDataSource, UITableViewDelegate,UIDocumentPickerDelegate ,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    
    @IBOutlet weak var serviceDueDate: UILabel!
    @IBOutlet weak var serviceDueDateLbl: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var H_itemView: NSLayoutConstraint!
    @IBOutlet weak var equipmentPartLbl: UILabel!
    @IBOutlet weak var H_partView: NSLayoutConstraint!
    @IBOutlet weak var partTableView: UITableView!
    @IBOutlet weak var installDateLbl: UILabel!
    @IBOutlet weak var installDate: UILabel!
    @IBOutlet weak var showLastSrvDate: UILabel!
    @IBOutlet weak var lastServDate: UILabel!
    @IBOutlet weak var manualDocBtn: UIButton!
    @IBOutlet weak var btnAddUserManual: UIButton!
    @IBOutlet weak var btnViewUserManual: UIButton!
    @IBOutlet weak var auditTblView_H: NSLayoutConstraint!
    @IBOutlet weak var scanTxtLbl: UILabel!
    @IBOutlet weak var go_To_Audit: NSLayoutConstraint!
    @IBOutlet weak var go_To_Job: NSLayoutConstraint!
    @IBOutlet weak var auditWidth: NSLayoutConstraint!
    @IBOutlet weak var jobWidth: NSLayoutConstraint!
    @IBOutlet weak var auditBtn: UIButton!
    @IBOutlet weak var jobBtn: UIButton!
    @IBOutlet weak var auditHieght: NSLayoutConstraint!
    @IBOutlet weak var jobHieght: NSLayoutConstraint!
    @IBOutlet weak var barCodeShowLbl: UILabel!
    @IBOutlet weak var barCodeLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblEquipName: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var modelNo: UILabel!
    @IBOutlet weak var serialNo: UILabel!
    @IBOutlet weak var tarrifRate: UILabel!
    @IBOutlet weak var extraFieldOneShow: UILabel!
    @IBOutlet weak var extraFieldTwoShow: UILabel!
    @IBOutlet weak var extraFieldOne: UILabel!
    @IBOutlet weak var extraFielfTwo: UILabel!
    @IBOutlet weak var manufactureDate: UILabel!
    @IBOutlet weak var purchaseDate: UILabel!
    @IBOutlet weak var equipmentGroup: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var lblModelNo: UILabel!
    @IBOutlet weak var lblSerialNo: UILabel!
    @IBOutlet weak var lblTariffRate: UILabel!
    @IBOutlet weak var lblWarrntyExpDate: UILabel!
    @IBOutlet weak var lblManufactureDate: UILabel!
    @IBOutlet weak var lblPurchaseDate: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblEquipmentGroup: UILabel!
    @IBOutlet weak var warrantyExpDate: UILabel!
    @IBOutlet weak var lblScan: UILabel!
    @IBOutlet weak var addjobBtn: UIButton!
    @IBOutlet weak var H_add_Job: NSLayoutConstraint!
    @IBOutlet weak var viewAllSerBtn: UIButton!
    @IBOutlet weak var viewAllAuditBtn: UIButton!
    @IBOutlet weak var serviceTblView: UITableView!
    @IBOutlet weak var serviceCount: UILabel!
    @IBOutlet weak var serviceView_H: NSLayoutConstraint!
    @IBOutlet weak var auditCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var count : Int = 0
    var isUserfirstLogin = Bool()
    var refreshControl = UIRefreshControl()
    var userManualFile = UIImage()
    var isDisable = true
    var auditDetalVc:AuditTabController?
    var isAdded = Bool()
    var selectedAuditID : String? = nil
    var allEqpHistry = [AllEquipment]()// [[String : [AllEquipment]]]() //[AllEquipment]()
    var allEqpHistrySer = [AllEquipmtser]()
    var isEquipData = false
    var equipments:equipDataArray?
    var equipmentDetailAudit = [equipDataArray]()
    var equipmentDetailJob = [equipDataArray]()
    var adminEquipment = [EquipListDataModel]()
    //var equipmentDetailList:equipDataArray!
    var getValuArray = [AuditOfflineList]()
    var getJobEquipment = [UserJobList]()
    var barcodeString: String?
    var isBarcodeScanner = false
    var isBarcodeScannerbool = false
    var isBarcodeScannerboolremarkaud = false
    var isNavigateVc = false
    var isFromMssage = false
    //var isScanBarcode = false
    var filterequipmentData = [equComponant]()
    var newItemPart = [AllEquipmentItemsData]()
    func getEquipmentListOfflineBarcodeScanner(barcodeString : String) -> Void{
        
        var equpDataArrayAudit = [equipDataArray]()
        // var sNo:String = ""
        //let query = "audId = '\(job.audId!)'"
        let isExistAudit = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: nil) as! [AuditOfflineList]
        if isExistAudit.count > 0 {
            equpDataArrayAudit.removeAll()
            
            for audit in isExistAudit {
                for item in (audit.equArray as! [AnyObject]) {
                    
                    if item["barcode"] as? String == barcodeString
                    {
                        
                        
                        var arrTac = [AttechmentArry]()
                        
                        if item["attachments"] != nil {
                            
                            
                            if (item["attachments"] is [AnyObject]) && ((item["attachments"] as! [AnyObject]).count > 0) {
                                let attachments =  item["attachments"] as! [AnyObject]
                                for attechDic in attachments {
                                    arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                                }
                                
                                
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String , extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String ,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                // equipmentData.append(dic)
                                equpDataArrayAudit.append(dic)
                                // print(equipmentDic.self)
                             
                                // if let dta = item as? equipData {
                                // }
                            }else {
                                
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                // equipmentData.append(dic)
                                equpDataArrayAudit.append(dic)
                            }
                            
                            
                        }else {
                            
                            
                            
                            let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:[], type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                            //
                            equpDataArrayAudit.append(dic)
                        }
                    }
                    
                    
                }
            }
            
        }
        var equpDataArrayJob = [equipDataArray]()
        // var sNo:String = ""
        let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: nil) as! [UserJobList]
        if isExistJob.count > 0 {
            equpDataArrayJob.removeAll()
            // equpDataArray.append(isExistAudit[0].equArray as! AuditOfflineList)
            for job in isExistJob {
                for item in (job.equArray as! [AnyObject]) {
                    
                    if item["barcode"] as? String == barcodeString
                    {
                        
                        
                        var arrTac = [AttechmentArry]()
                        
                        if item["attachments"] != nil {
                            
                            
                            if (item["attachments"] is [AnyObject]) && ((item["attachments"] as! [AnyObject]).count > 0) {
                                let attachments =  item["attachments"] as! [AnyObject]
                                for attechDic in attachments {
                                    arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                                }
                                
                                
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                // equipmentData.append(dic)
                                equpDataArrayJob.append(dic)
                                // print(equipmentDic.self)
                                
                                // if let dta = item as? equipData {
                                // }
                            }else {
                                
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                // equipmentData.append(dic)
                                equpDataArrayJob.append(dic)
                            }
                            
                            
                        }else
                        {
                           
                            let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:[], type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                            equpDataArrayJob.append(dic)
                        }
                    }
                }
            }
            
        }
        
        let jobBarcode = equpDataArrayJob.filter({$0.barcode == barcodeString})
        let auditBarcode = equpDataArrayAudit.filter({$0.barcode == barcodeString})
        
        if jobBarcode.count != 0 && auditBarcode.count != 0 {
            //2
            self.equipmentDetailAudit = equpDataArrayAudit
            
        } else if jobBarcode.count != 0 {
            self.equipmentDetailJob = equpDataArrayJob
        } else if auditBarcode.count != 0 {
            
            // if auditBarcode.count>1 {
            self.equipmentDetailAudit = equpDataArrayAudit
            
            //  }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllEquipmentItems()
        
        
        let image = UIImage(named:"icons8-menu-vertical-32")
        let leftButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = leftButton
      
        addjobBtn.isHidden = true
        if isBarcodeScannerbool == true {
        
        }else if isBarcodeScannerboolremarkaud == true {
            
        }else{
            

            addjobBtn.isHidden = false
            getEquipmentListOfflineBarcodeScanner(barcodeString: barcodeString!)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllEquipmentItems()
        
        var nm1 = LanguageKey.equipment_parts
        self.equipmentPartLbl.text! = "\(nm1): \(String(self.filterequipmentData.count))"
        
        if filterequipmentData.count == 0 {
            self.H_partView.constant = 55
        }else if filterequipmentData.count == 1 {
            self.H_partView.constant = 150
        }else if filterequipmentData.count == 2 {
            self.H_partView.constant = 300
        }else if filterequipmentData.count == 3 {
            self.H_partView.constant = 450
        }else if filterequipmentData.count == 4 {
            self.H_partView.constant = 600
        }else if filterequipmentData.count == 5 {
            self.H_partView.constant = 750
        }else if filterequipmentData.count == 6 {
            self.H_partView.constant = 900
        }else if filterequipmentData.count == 7 {
            self.H_partView.constant = 1050
        }else if filterequipmentData.count == 8 {
            self.H_partView.constant = 1200
        }else if filterequipmentData.count == 9 {
            self.H_partView.constant = 1350
        }else if filterequipmentData.count == 10 {
            self.H_partView.constant = 1500
        }else if filterequipmentData.count == 11 {
            self.H_partView.constant = 1650
        }else if filterequipmentData.count == 12 {
            self.H_partView.constant = 1800
        }else if filterequipmentData.count == 13 {
            self.H_partView.constant = 1950
        }else if filterequipmentData.count == 14 {
            self.H_partView.constant = 2050
        }
        
        
        print(filterequipmentData.count)
        let image = UIImage(named:"icons8-menu-vertical-32")
        let leftButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = leftButton
        
        
        addjobBtn.isHidden = true
        manualDocBtn.isHidden = true
        btnViewUserManual.isHidden = true
        
        isDisable = compPermissionVisible(permission: compPermission.equpHistory)

        
        if isDisable == false {
            self.auditCount.isHidden = true
            self.serviceCount.isHidden = true
            self.serviceView_H.constant = 0
            self.auditTblView_H.constant = 0
        }
        
      
     
        self.getEquAuditSchedule()
        getEquAuditScheduleService()
        
        self.setLocalization()
        showDetial()
       
    }
    
    @objc func addTapped(){
       
        if self.manualDocBtn.isSelected == false
        {
            self.manualDocBtn.isSelected = true
            if equipmentDetailJob.count > 0 {
                if equipmentDetailJob[0].usrManualDoc != "" {
                    btnViewUserManual.isHidden = false
                   
                }else{
                    manualDocBtn.isHidden = false
                }
            }else if adminEquipment.count > 0{
                if adminEquipment[0].usrManualDoc != "" {
                    btnViewUserManual.isHidden = false
                   
                }else{
                   
                    manualDocBtn.isHidden = false
                }
            }else if equipmentDetailAudit.count > 0{
                
                if equipmentDetailAudit[0].usrManualDoc != "" {
                    btnViewUserManual.isHidden = false
                  
                }else{
                   
                    manualDocBtn.isHidden = false
                }
            }
                else {
                
                    if equipments?.usrManualDoc != "" {
                    btnViewUserManual.isHidden = false
                  
                }else{
                   
                    manualDocBtn.isHidden = false
                }
                
            } //self.manualDocBtn.isSelected = true
            // manualDocBtn.isHidden = true
        }
            
        else
            
        {

                 self.manualDocBtn.isSelected = false
                 manualDocBtn.isHidden = true
                 btnViewUserManual.isHidden = true
             }
        
    }
        
    func compareTwodate(schStartDate : String , schEndDate : String, dateFormate:DateFormate) -> String{
             
             let formatter = DateFormatter()
             formatter.dateFormat = dateFormate.rawValue  //"MM-yy
             let startDate = formatter.date(from: schStartDate)
             let endDate = formatter.date(from: schEndDate)
             switch startDate?.compare(endDate!) {
             case .orderedAscending?     :  return("orderedAscending")
             case .orderedDescending?    :  return("orderedDescending")
             case .orderedSame?          :  return("orderedSame")
             case .none:    return ""
             }
             
         }
         
         func getCurrentYy()-> String{
             let date = Date()
             let formatter = DateFormatter()
             let dateTime =  DateFormate.dd_MMM_yyyy.rawValue
             formatter.dateFormat = dateTime
             let result = formatter.string(from: date)
             
             return result
             
         }
    
    
    
    
    @IBAction func viewAllBtn(_ sender: Any) {
        self.auditTblView_H.constant = 407
        self.viewAllAuditBtn.isHidden = true
    }
    
    @IBAction func viewAllService(_ sender: Any) {
        self.viewAllSerBtn.isHidden = true
        self.serviceView_H.constant = 407
    }
    @IBAction func btnScanAction(_ sender: Any) {
        
        scanBarcode()
    }
    
    
    
    func getGenerateBarcodeOffline(barcodeString : String) -> Void {
        
        if !isHaveNetowork() {
            return
        }
        
        let param = Params()
        param.barCode = barcodeString
        
        if equipmentDetailJob.count > 0 {
            param.equId = equipmentDetailJob[0].equId
          }else{
            param.equId = equipments?.equId
        }
        
        serverCommunicator(url: Service.generateBarcodeUsingGivenCode, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ScanBarcodeResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async {self.dismiss(animated: true, completion: nil)}
                        self.showToast(message:"Barcode Added")
                        
                    }else{
                        
                        killLoader()
                        if let code =  decodedData.statusCode{
                            if(code == "401"){
                                ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
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
                    
                }
            }else{
                
            }
        }
        
    }
    
    func showDetial() {
        
        if isEquipData == true {
            auditBtn.isHidden = true
            jobBtn.isHidden = true
        } else if adminEquipment.count != 0{
            
            if isFromMssage == true {
                SetBackBarAdminCustom()
                auditBtn.isHidden = true
                jobBtn.isHidden = true
                //jobBtn.isOpaque = true
            }else {
                auditBtn.isHidden = true
                jobBtn.isHidden = true
            }
        }
        else {
            
            if equipmentDetailAudit.count != 0 && equipmentDetailJob.count != 0  {
                
                auditBtn.isHidden = false
                
                jobBtn.isHidden = false
                // hide job / audit
            } else if equipmentDetailAudit.count == 0 && equipmentDetailJob.count == 0
            {
                // hide audit//
                
                auditBtn.isHidden = true
                jobBtn.isHidden = false
                
            } else if equipmentDetailJob.count == 0
            {
                // hide job
                // jobHieght.constant = 0
                jobBtn.isHidden = true
                jobWidth.constant = 0
            }else if equipmentDetailAudit.count == 0
            {
                auditBtn.isHidden = true
              //  auditWidth.constant = 0
                // auditBtn.center
                auditBtn.center = self.view.center
                
            }
            
            //     else if adminEquipment.count != 0{
            //                    auditBtn.isHidden = true
            //                    jobBtn.isHidden = true
            //                }
            
        }
        
        
        if equipmentDetailAudit.count > 0 {
            self.addjobBtn.isHidden = true
            let aa = equipmentDetailAudit[0].image!
            lblEquipName.text = equipmentDetailAudit[0].equnm
            //imageView.image = equipmentDetailList.image
            //lblBrandName.text = ""
            //lblStatus.text = equipmentDetailAudit[0].status
            lblModelNo.text = equipmentDetailAudit[0].mno
            lblSerialNo.text = equipmentDetailAudit[0].sno
            //if aa != nil {
            if aa.count > 0 {
                let ar = URL(string: Service.BaseUrl)?.absoluteString
                let ab = equipmentDetailAudit[0].image
                //load(url:(URL(string: ar! + (ab.attachThumnailFileName!))!
                load(url:URL(string: ar! + ab!)!)
            }
            // }
            
            lblBrandName.text = equipmentDetailAudit[0].brand
            lblTariffRate.text = equipmentDetailAudit[0].rate
            lblPurchaseDate.text = equipmentDetailAudit[0].purchaseDate
            lblManufactureDate.text = equipmentDetailAudit[0].manufactureDate
            // lblWarrntyExpDate.text = equipmentDetailList
            // lblSuplier.text = equipmentDetailList.s
            lblEquipmentGroup.text = equipmentDetailAudit[0].equipment_group
            if equipments?.type == "1" {
                lblType.text = LanguageKey.owner
            }
            if equipments?.type == "2" {
                lblType.text = LanguageKey.serv_prov
            }
            //lblType.text =  equipmentDetailAudit[0].type
            //barcodeNo.text = equipmentDetailAudit[0].barcode
            
            // lblManufactureDate.text = (equipmentDetailList?.manufactureDate != nil) ? convertTimeStampToStringForEquipmet(timestamp: (equipmentDetailList?.manufactureDate!)!, dateFormate: DateFormate.ddMMMyyyy_hh_mma) : ""
            
            if equipmentDetailAudit[0].manufactureDate != "" {
                // let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].manufactureDate)!)
                
                let startDate = (equipmentDetailAudit[0].manufactureDate != nil) ? convertTimeStampToString(timestamp: (equipmentDetailAudit[0].manufactureDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                // lblManufactureDate.text = tempTime.0 + tempTime.1
                lblManufactureDate.text = startDate
            } else {
                lblManufactureDate.text = ""
            }
            
            
            if equipmentDetailAudit[0].purchaseDate != "" {
                //let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].purchaseDate)!)
                let startDate = (equipmentDetailAudit[0].purchaseDate != nil) ? convertTimeStampToString(timestamp: (equipmentDetailAudit[0].purchaseDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                lblPurchaseDate.text = startDate
            } else {
                lblPurchaseDate.text = ""
            }
            
            
            if equipmentDetailAudit[0].expiryDate != "" {
                //let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].expiryDate)!)
                let startDate = (equipmentDetailAudit[0].expiryDate != nil) ? convertTimeStampToString(timestamp: (equipmentDetailAudit[0].expiryDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                lblWarrntyExpDate.text = startDate
            } else {
                lblWarrntyExpDate.text = ""
            }
            
//            if equipmentDetailAudit[0].usrManualDoc != "" {
//                btnViewUserManual.isHidden = false
//            }else{
//                btnViewUserManual.isHidden = true
//            }
            
        }
            
            
            // job list data
            
        else if equipmentDetailJob.count > 0 { // barcode
            
            

             let warntyDataVelue = Int(equipmentDetailJob[0].servIntvalValue ?? "")
             let warntyDataType = Int(equipmentDetailJob[0].servIntvalType ?? "")
             
             if warntyDataType == 0 { // FOR DAY
                 
                 // var day = self.serviceIntervalTxtFld.text
                 let dayToAdd = warntyDataVelue//Int(day ?? "")
                 let currentDate = Date()
                 var dateComponent = DateComponents()
                 dateComponent.day = dayToAdd
                 let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                 let currntDateEx = futureDate
                 let formatterEx = DateFormatter()
                 formatterEx.dateFormat="dd-MM-yyyy"
                 let endDateEx = formatterEx.string(from: currntDateEx!)
                 serviceDueDate.text = endDateEx
                 
             }else if warntyDataType == 1 { //FOR MONTH
                 
                 let monthToAdd = warntyDataVelue
                 // var month = self.serviceIntervalTxtFld.text
                 // let monthToAdd = Int(month ?? "")
                 let currentDate = Date()
                 var dateComponent = DateComponents()
                 dateComponent.month = monthToAdd
                 let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                 let currntDateEx = futureDate
                 let formatterEx = DateFormatter()
                 formatterEx.dateFormat="dd-MM-yyyy"
                 let endDateEx = formatterEx.string(from: currntDateEx!)
                 serviceDueDate.text = endDateEx
                 
             } else if warntyDataType == 2 { //FOR YEAR
                 
                 let yearsToAdd = warntyDataVelue
                 let currentDate = Date()
                 var dateComponent = DateComponents()
                 dateComponent.year = yearsToAdd
                 let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                 let currntDateEx = futureDate
                 let formatterEx = DateFormatter()
                 formatterEx.dateFormat="dd-MM-yyyy"
                 let endDateEx = formatterEx.string(from: currntDateEx!)
                 serviceDueDate.text = endDateEx
                 print(currentDate)
                 print(futureDate!)
             }
             
             
            
            self.addjobBtn.isHidden = false
           
            self.extraFieldOne.text =  getDefaultSettings()?.equpExtraField1Label
            self.extraFielfTwo.text =  getDefaultSettings()?.equpExtraField2Label
           barCodeShowLbl.text = equipmentDetailJob[0].barcode
           
           if equipmentDetailJob[0].datetime != "" {
               let datetime = (equipmentDetailJob[0].datetime  != nil) ? convertTimeStampToString(timestamp: (equipmentDetailJob[0].datetime)!, dateFormate: DateFormate.dd_MMM_yyyy_HH_mm) : ""
               showLastSrvDate.text = datetime
           }else{
               showLastSrvDate.text = ""
           }
           

            extraFieldOneShow.text = equipmentDetailJob[0].extraField1
            extraFieldTwoShow.text = equipmentDetailJob[0].extraField2
            
            
            let aa = equipmentDetailJob[0].image!
            lblEquipName.text = equipmentDetailJob[0].equnm
            //imageView.image = equipmentDetailList.image
            //lblBrandName.text = ""
            //lblStatus.text = equipmentDetailJob[0].status
            lblModelNo.text = equipmentDetailJob[0].mno
            lblSerialNo.text = equipmentDetailJob[0].sno
            // if aa != nil {
            if aa.count > 0 {
                let ar = URL(string: Service.BaseUrl)?.absoluteString
                let ab = equipmentDetailJob[0].image
                //load(url:(URL(string: ar! + (ab.attachThumnailFileName!))!
                load(url:URL(string: ar! + ab!)!)
            }
            // }
            
            
            lblBrandName.text = equipmentDetailJob[0].brand
            lblTariffRate.text = equipmentDetailJob[0].rate
            lblPurchaseDate.text = equipmentDetailJob[0].purchaseDate
            lblManufactureDate.text = equipmentDetailJob[0].manufactureDate
            // lblWarrntyExpDate.text = equipmentDetailList
            // lblSuplier.text = equipmentDetailList.s
            lblEquipmentGroup.text = equipmentDetailJob[0].equipment_group
            if equipmentDetailJob[0].type == "1" {
                lblType.text = LanguageKey.owner
            }
            if equipmentDetailJob[0].type == "2" {
                lblType.text = LanguageKey.serv_prov
            }
            //lblType.text = LanguageKey.owner//equipmentDetailJob[0].type
            // barcodeNo.text = equipmentDetailJob[0].barcode
            
            // lblManufactureDate.text = (equipmentDetailList?.manufactureDate != nil) ? convertTimeStampToStringForEquipmet(timestamp: (equipmentDetailList?.manufactureDate!)!, dateFormate: DateFormate.ddMMMyyyy_hh_mma) : ""
            
            if equipmentDetailJob[0].manufactureDate != "" {
                // let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].manufactureDate)!)
                
                let startDate = (equipmentDetailJob[0].manufactureDate != nil) ? convertTimeStampToString(timestamp: (equipmentDetailJob[0].manufactureDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                // lblManufactureDate.text = tempTime.0 + tempTime.1
                lblManufactureDate.text = startDate
            } else {
                lblManufactureDate.text = ""
            }
            
            
            if equipmentDetailJob[0].purchaseDate != "" {
                //let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].purchaseDate)!)
                let startDate = (equipmentDetailJob[0].purchaseDate != nil) ? convertTimeStampToString(timestamp: (equipmentDetailJob[0].purchaseDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                lblPurchaseDate.text = startDate
            } else {
                lblPurchaseDate.text = ""
            }
            
            
            if equipmentDetailJob[0].expiryDate != "" {
                //let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].expiryDate)!)
                let startDate = (equipmentDetailJob[0].expiryDate != nil) ? convertTimeStampToString(timestamp: (equipmentDetailJob[0].expiryDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                lblWarrntyExpDate.text = startDate
            } else {
                lblWarrntyExpDate.text = ""
            }
            
            if equipmentDetailJob[0].installedDate != "" {
                //let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].expiryDate)!)
                let installDt = (equipmentDetailJob[0].installedDate  != nil) ? convertTimeStampToString(timestamp: (equipmentDetailJob[0].installedDate )!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                installDateLbl.text = installDt
            } else {
                installDateLbl.text = ""
                
            }
            
//            if equipmentDetailJob[0].usrManualDoc != "" {
//                btnViewUserManual.isHidden = false
//            }else{
//                btnViewUserManual.isHidden = true
//            }
            
            // }
            
        }
        else if adminEquipment.count > 0{
            self.addjobBtn.isHidden = true
            let aa = adminEquipment[0].image!
            lblEquipName.text = adminEquipment[0].equnm
            //imageView.image = equipmentDetailList.image
            //lblBrandName.text = ""
            // lblStatus.text = adminEquipment[0].status
            lblModelNo.text = adminEquipment[0].mno
            lblSerialNo.text = adminEquipment[0].sno
            // if aa != nil {
            if aa.count > 0 {
                let ar = URL(string: Service.BaseUrl)?.absoluteString
                let ab = adminEquipment[0].image
                //load(url:(URL(string: ar! + (ab.attachThumnailFileName!))!
                load(url:URL(string: ar! + ab!)!)
            }
            // }
            
            
            lblBrandName.text = adminEquipment[0].brand
            lblTariffRate.text = adminEquipment[0].rate
            lblPurchaseDate.text = adminEquipment[0].purchaseDate
            lblManufactureDate.text = adminEquipment[0].manufactureDate
            // lblWarrntyExpDate.text = equipmentDetailList
            // lblSuplier.text = equipmentDetailList.s
            lblEquipmentGroup.text = adminEquipment[0].groupName
            if adminEquipment[0].type == "1" {
                lblType.text = LanguageKey.owner
            }
            if adminEquipment[0].type == "2" {
                lblType.text = LanguageKey.serv_prov
            }
            //lblType.text = LanguageKey.owner//equipmentDetailJob[0].type
            // barcodeNo.text = adminEquipment[0].barcode
            
            // lblManufactureDate.text = (equipmentDetailList?.manufactureDate != nil) ? convertTimeStampToStringForEquipmet(timestamp: (equipmentDetailList?.manufactureDate!)!, dateFormate: DateFormate.ddMMMyyyy_hh_mma) : ""
            
            if adminEquipment[0].manufactureDate != "" {
                // let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].manufactureDate)!)
                
                let startDate = (adminEquipment[0].manufactureDate != nil) ? convertTimeStampToString(timestamp: (adminEquipment[0].manufactureDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                // lblManufactureDate.text = tempTime.0 + tempTime.1
                lblManufactureDate.text = startDate
            } else {
                lblManufactureDate.text = ""
            }
            
            
            if adminEquipment[0].purchaseDate != "" {
                //let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].purchaseDate)!)
                let startDate = (adminEquipment[0].purchaseDate != nil) ? convertTimeStampToString(timestamp: (adminEquipment[0].purchaseDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                lblPurchaseDate.text = startDate
            } else {
                lblPurchaseDate.text = ""
            }
            
            
            if adminEquipment[0].expiryDate != "" {
                //let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].expiryDate)!)
                let startDate = (adminEquipment[0].expiryDate != nil) ? convertTimeStampToString(timestamp: (adminEquipment[0].expiryDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                lblWarrntyExpDate.text = startDate
            } else {
                lblWarrntyExpDate.text = ""
            }
//            if adminEquipment[0].usrManualDoc != "" {
//                btnViewUserManual.isHidden = false
//            }else{
//                btnViewUserManual.isHidden = true
//            }
            
        }
            
        else {
            
           

            let warntyDataVelue = Int(equipments?.servIntvalValue ?? "")
            let warntyDataType = Int(equipments?.servIntvalType ?? "")
            
            if warntyDataType == 0 { // FOR DAY
                
                // var day = self.serviceIntervalTxtFld.text
                let dayToAdd = warntyDataVelue//Int(day ?? "")
                let currentDate = Date()
                var dateComponent = DateComponents()
                dateComponent.day = dayToAdd
                let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                let currntDateEx = futureDate
                let formatterEx = DateFormatter()
                formatterEx.dateFormat="dd-MM-yyyy"
                let endDateEx = formatterEx.string(from: currntDateEx!)
                serviceDueDate.text = endDateEx
                
            }else if warntyDataType == 1 { //FOR MONTH
                
                let monthToAdd = warntyDataVelue
                // var month = self.serviceIntervalTxtFld.text
                // let monthToAdd = Int(month ?? "")
                let currentDate = Date()
                var dateComponent = DateComponents()
                dateComponent.month = monthToAdd
                let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                let currntDateEx = futureDate
                let formatterEx = DateFormatter()
                formatterEx.dateFormat="dd-MM-yyyy"
                let endDateEx = formatterEx.string(from: currntDateEx!)
                serviceDueDate.text = endDateEx
                
            } else if warntyDataType == 2 { //FOR YEAR
                
                let yearsToAdd = warntyDataVelue
                let currentDate = Date()
                var dateComponent = DateComponents()
                dateComponent.year = yearsToAdd
                let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                let currntDateEx = futureDate
                let formatterEx = DateFormatter()
                formatterEx.dateFormat="dd-MM-yyyy"
                let endDateEx = formatterEx.string(from: currntDateEx!)
                serviceDueDate.text = endDateEx
                print(currentDate)
                print(futureDate!)
            }
            
            
            
            
            self.addjobBtn.isHidden = false
             self.extraFieldOne.text =  getDefaultSettings()?.equpExtraField1Label
             self.extraFielfTwo.text =  getDefaultSettings()?.equpExtraField2Label
            barCodeShowLbl.text = equipments?.barcode
            
            if equipments?.datetime != "" {
                let datetime = (equipments?.datetime  != nil) ? convertTimeStampToString(timestamp: (equipments?.datetime)!, dateFormate: DateFormate.dd_MMM_yyyy_HH_mm) : ""
                showLastSrvDate.text = datetime
            }else{
                showLastSrvDate.text = ""
            }
            
//            let isoDate = equipments?.datetime ?? ""
//            if isoDate != ""{
//            let endDate = (isoDate != nil) ? convertTimeStampToString(timestamp: isoDate, dateFormate: DateFormate.dd_MMM_yyyy_HH_mm) : ""
//
//
//            showLastSrvDate.text = endDate
//
//            }else{
//
//            showLastSrvDate.text = ""
//
//            }
            
            extraFieldOneShow.text = equipments?.extraField1
            extraFieldTwoShow.text = equipments?.extraField2
            lblEquipName.text = equipments?.equnm
            //imageView.image = equipmentDetailList.image
            //lblBrandName.text = ""
            // lblStatus.text = equipments?.status
            lblModelNo.text = equipments?.mno
            lblSerialNo.text = equipments?.sno
            let aa = equipments?.image
            if aa != nil{
                if aa!.count > 0 {
                    let ar = URL(string: Service.BaseUrl)?.absoluteString
                    let ab = equipments!.image
                    //load(url:(URL(string: ar! + (ab.attachThumnailFileName!))!
                    load(url:URL(string: ar! + ab!)!)
                }
            }
            
            lblBrandName.text = equipments!.brand
            lblTariffRate.text = equipments!.rate
            lblPurchaseDate.text = equipments!.purchaseDate
            lblManufactureDate.text = equipments!.manufactureDate
            // lblWarrntyExpDate.text = equipmentDetailList
            // lblSuplier.text = equipmentDetailList.s
            lblEquipmentGroup.text = equipments!.equipment_group
            
            if equipments?.type == "1" {
                lblType.text = LanguageKey.owner
            }
            if equipments?.type == "2" {
                lblType.text = LanguageKey.serv_prov
            }
            
            
            
            // lblType.text = equipments!.type
            // barcodeNo.text = equipments?.barcode
            
            // lblManufactureDate.text = (equipmentDetailList?.manufactureDate != nil) ? convertTimeStampToStringForEquipmet(timestamp: (equipmentDetailList?.manufactureDate!)!, dateFormate: DateFormate.ddMMMyyyy_hh_mma) : ""
            
            if equipments?.manufactureDate != "" {
                // let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].manufactureDate)!)
                
                let startDate = (equipments!.manufactureDate != nil) ? convertTimeStampToString(timestamp: (equipments?.manufactureDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                // lblManufactureDate.text = tempTime.0 + tempTime.1
                lblManufactureDate.text = startDate
            } else {
                lblManufactureDate.text = ""
            }
            
            
            if equipments?.purchaseDate != "" {
                //let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].purchaseDate)!)
                let startDate = (equipments?.purchaseDate != nil) ? convertTimeStampToString(timestamp: (equipments!.purchaseDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                lblPurchaseDate.text = startDate
            } else {
                lblPurchaseDate.text = ""
            }
            
            
            if equipments?.expiryDate != "" {
                //let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].expiryDate)!)
                let startDate = (equipments?.expiryDate != nil) ? convertTimeStampToString(timestamp: (equipments?.expiryDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                lblWarrntyExpDate.text = startDate
            } else {
                lblWarrntyExpDate.text = ""
                
            }
            
            if equipments?.installedDate != "" {
                //let tempTime = convertTimestampToDate(timeInterval: (equipmentDetailAudit[0].expiryDate)!)
                let installDt = (equipments?.installedDate != nil) ? convertTimeStampToString(timestamp: (equipments?.installedDate)!, dateFormate: DateFormate.dd_MMM_yyyy) : ""
                installDateLbl.text = installDt
            } else {
                installDateLbl.text = ""
                
            }
            
//            if equipments?.usrManualDoc != "" {
//                btnViewUserManual.isHidden = false
//            }else{
//                btnViewUserManual.isHidden = true
//            }
            
            
        }
        
        
        if isBarcodeScanner {
            SetBackBarButtonCustom()
            //self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else{
            APP_Delegate.currentVC = "job"
        }
    }
    
    
    func setLocalization() -> Void {
        
       // itemLbl.text =  LanguageKey.equipment_items
       // equipmentPartLbl.text =  LanguageKey.equipment_parts
        self.navigationItem.title = LanguageKey.title_equ_details
        self.addjobBtn.setTitle(LanguageKey.go_to_addjob, for: .normal)
        brandName.text =  LanguageKey.brand_name
        modelNo.text =  LanguageKey.model_no
        serialNo.text =  LanguageKey.serial_no
        tarrifRate.text =  LanguageKey.tariff_rate
        //status.text =  LanguageKey.condition
        warrantyExpDate.text =  LanguageKey.warranty_expiry_date
        manufactureDate.text =  LanguageKey.manufacture_date
        purchaseDate.text =  LanguageKey.purchase_date
        type.text =  LanguageKey.type
        equipmentGroup.text =  LanguageKey.equipment_group
        barCodeLbl.text =  LanguageKey.barcode_num
        lastServDate.text =  LanguageKey.last_serv_date
        lblScan.text = LanguageKey.capture_barcode
        auditBtn.setTitle(LanguageKey.go_to_audit, for: .normal)
        jobBtn.setTitle(LanguageKey.go_to_job, for: .normal)
        btnAddUserManual.setTitle(LanguageKey.add_user_mannual, for: .normal)
        btnViewUserManual.setTitle(LanguageKey.view_user_mannual, for: .normal)
       
    }
    
    
    @IBAction func btnJobVc(_ sender: Any) {
        self.getJobEquipment.removeAll()
        if equipmentDetailJob.count > 1
            
        {
            print(getJobEquipment.count)
            let allJobs = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: nil) as! [UserJobList]

            for jobs in equipmentDetailJob {

                let filterAudit = allJobs.filter({$0.jobId == jobs.audId})
                if filterAudit.count > 0 {
                    self.getJobEquipment.append(contentsOf: filterAudit)
                    print(getJobEquipment)
                    
                    
                    //                        if audit.audId == audits.audId
                    //                        {
                    //                            self.getValuArray.append(audit)
                    //
                    //                        }
                }
            }


            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "jobsvc") as! JobVC;
            vc.arrOFUserData2 = getJobEquipment
            print(getJobEquipment.count)
            let navCon = NavClientController(rootViewController: vc)
            navCon.modalPresentationStyle = .fullScreen
            vc.isBarcodeScanner = true
            vc.isJob = true
            vc.isJobBarcodeSceen = true
            self.present(navCon, animated: true, completion: nil )
            //self.isBackEnable = true
            
        }else {
            
            let vc = UIStoryboard(name: "MainJob", bundle: nil).instantiateViewController(withIdentifier: "LinkEquipmentReport") as! LinkEquipmentReport;
            let navCon = NavClientController(rootViewController: vc)
            vc.isPresented = true
            vc.equipment = equipmentDetailJob[0]
            vc.isNavigate = true
            navCon.modalPresentationStyle = .fullScreen
            self.present(navCon, animated: true, completion: nil)
            //self.isBackEnable = true
            
        }
      
    }
    
    
    func SetBackBarAdminCustom()
    {
        //Back buttion
        
        let button = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(EquipmentDetailVc.onClcikBack1))
        
        self.navigationItem.leftBarButtonItem  = button
    }
    
    @objc func onClcikBack1(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func btnAuditVc(_ sender: Any) {
        self.getValuArray.removeAll()
        if equipmentDetailAudit.count > 1
            
            
            
            
        {
            let allAudits = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: nil) as! [AuditOfflineList]
            
            
            
            
            
            
            
            //                for audit in allAudits{
            //allAudits
            
            for audits in equipmentDetailAudit {
                
                let filterAudit = allAudits.filter({$0.audId == audits.audId})
                if filterAudit.count > 0 {
                    self.getValuArray.append(contentsOf: filterAudit)
                    //                        if audit.audId == audits.audId
                    //                        {
                    //                            self.getValuArray.append(audit)
                    //
                    //                        }
                }
            }
            
            
            ////                               let filterAudit = allAudits.filter({$0.audId == audit.audId})
            ////                               if filterAudit.count > 0 {
            ////                                   self.getValuArray.append(filterAudit[0])
            //
            //                               }
            
            let vc = UIStoryboard(name: "MainAudit", bundle: nil).instantiateViewController(withIdentifier: "audit") as! AuditVC;
            
            vc.arrOFUserData2 = getValuArray
            
            let navCon = NavClientController(rootViewController: vc)
            navCon.modalPresentationStyle = .fullScreen
            vc.isBarcodeScanner = true
            vc.isAuditData = true
            self.present(navCon, animated: true, completion: nil )
            //self.isBackEnable = true
            
            
        }
            //}
        else {
            
            let vc = UIStoryboard(name: "MainAudit", bundle: nil).instantiateViewController(withIdentifier: "remarkTab") as! RemarkVC;
            let navCon = NavClientController(rootViewController: vc)
            vc.isPresented = true
            vc.equipment = equipmentDetailAudit[0]
            navCon.modalPresentationStyle = .fullScreen
            self.present(navCon, animated: true, completion: nil)
            //self.isBackEnable = true
        }
        
    }
    
    
    func SetBackBarButtonCustom()
    {
        //Back buttion
        
        let button = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(EquipmentDetailVc.onClcikBack))
        
        self.navigationItem.leftBarButtonItem  = button
    }
    
    @objc func onClcikBack(){
        if isBarcodeScanner {
            self.dismiss(animated: true, completion: nil)
        }
        else{
            // self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    func load(url:  URL ) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
    //==================================
    // MARK:- Equipement LIST Service methods
    //==================================
    func getEquAuditScheduleService(){
        
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
        
        if equipmentDetailJob.count > 0 {
            param.equId = equipmentDetailJob[0].equId
          }else{
            param.equId = equipments?.equId
        }
        param.limit = "120"
        param.index = "0"
        param.moduleType = "0"
        // param.dateTime = lastRequestTime ?? ""
        
        // limit, index, search, dateTime
        
        
        
        serverCommunicator(url: Service.getEquAuditSchedule, param: param.toDictionary) { (response, success) in
            
            //               DispatchQueue.main.async {
            //                   if self.refreshControl.isRefreshing {
            //                       self.refreshControl.endRefreshing()
            //                   }
            //               }
            
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(AllEquipmentService.self, from: response as! Data) {
                    if decodedData.success == true{
                        killLoader()
                        if decodedData.data!.count > 0 {
                            self.allEqpHistrySer = decodedData.data as! [AllEquipmtser]//[[String : [AllEquipment]]]                                                        }
                            
                            DispatchQueue.main.async {
                                var nm = LanguageKey.equipment_service
                                self.serviceCount.text! = "\(nm): \(String(self.allEqpHistrySer.count))"
                                
                                
                                var arrs = self.allEqpHistrySer.count
                                if arrs == 0{
                                   // self.viewAllSerBtn.isHidden = true
                                   // self.serviceView_H.constant = 0
                                }else{
                                  //  self.viewAllSerBtn.isHidden = false
                                   // self.serviceView_H.constant = 140
                                }
                                
                                self.serviceTblView.reloadData()
                                //
                                //  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                
                                killLoader()
                            }
                        }else{
                            //   print("jugal")
                            //self.equipments.removeAll()
                            DispatchQueue.main.async {
                                var nm = LanguageKey.equipment_service
                                self.serviceCount.text! = "\(nm): \(String(self.allEqpHistrySer.count))"
                                
                                
                                var arrs = self.allEqpHistrySer.count
                                if arrs == 0{
                                    self.serviceView_H.constant = 0
                                    self.viewAllSerBtn.isHidden = true
                                }else{
                                    self.viewAllSerBtn.isHidden = false
                                    self.serviceView_H.constant = 140
                                }
                                // self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                self.serviceTblView.reloadData()
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
                            //  self.getAdminEquipementList()
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        // self.getAdminEquipementList()
                    }
                })
            }
        }
    }
    
    //==================================
    // MARK:- Equipement LIST Audit methods
    //==================================
    func getEquAuditSchedule(){
        
        if !isHaveNetowork() {
            // if self.refreshControl.isRefreshing {
            //   self.refreshControl.endRefreshing()
            // }
            killLoader()
           // var nm = "Equipment Audit Feture is not Avelabel on Offline Mode"
            //    self.auditCount.text! = "\(nm)"
                // ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        showLoader()
        
        // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getEquipmentList) as? String
        let param = Params()
        
        if equipmentDetailJob.count > 0 {
            param.equId = equipmentDetailJob[0].equId
          }else{
            param.equId = equipments?.equId
        }
        param.limit = "120"
        param.index = "0"
        param.moduleType = "1"
        // param.dateTime = lastRequestTime ?? ""
        
        // limit, index, search, dateTime
        
        
        
        serverCommunicator(url: Service.getEquAuditSchedule, param: param.toDictionary) { (response, success) in
            
            //               DispatchQueue.main.async {
            //                   if self.refreshControl.isRefreshing {
            //                       self.refreshControl.endRefreshing()
            //                   }
            //               }
            
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(ResEquipmentHistry.self, from: response as! Data) {
                    if decodedData.success == true{
                        killLoader()
                        if decodedData.data!.count > 0 {
                            self.allEqpHistry = decodedData.data as! [AllEquipment]//[[String : [AllEquipment]]] //[AllEquipment]
                            
                       
                            
                            DispatchQueue.main.async {
                                var nm = LanguageKey.equipment_audit
                                self.auditCount.text! = "\(nm): \(String(self.allEqpHistry.count))"
                                var arr = self.allEqpHistry.count
                                if arr == 0 {
                                  //  self.viewAllAuditBtn.isHidden = true
                                  //  self.auditTblView_H.constant = 0
                                }else{
                                  //  self.viewAllAuditBtn.isHidden = false
                                   // self.auditTblView_H.constant = 140
                                }
                                //                                var arr = self.EquipmentsList.count
                                //                                if arr > 0  {
                                //                                    self.img.isHidden = true
                                //                                    self.eqpmtNotFound.isHidden = true
                                //                                    //   print("jugal 1")
                                //                                }else{
                                //                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
                                //                                    self.img.isHidden = false
                                //                                    self.eqpmtNotFound.isHidden = false
                                //                                    // print("jugal 0")
                                //                                }
                                self.tableView.reloadData()
                                //
                                //  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                
                                killLoader()
                            }
                        }else{
                            //   print("jugal")
                            //self.equipments.removeAll()
                            DispatchQueue.main.async {
                                var nm = LanguageKey.equipment_audit
                                self.auditCount.text! = "\(nm): \(String(self.allEqpHistry.count))"
                                
                                var arr = self.allEqpHistry.count
                                if arr == 0 {
                                    self.auditTblView_H.constant = 0
                                    self.viewAllAuditBtn.isHidden = true
                                }else{
                                    //self.viewAllAuditBtn.isHidden = false
                                   // self.auditTblView_H.constant = 140
                                }
                                // self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
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
                            //  self.getAdminEquipementList()
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        // self.getAdminEquipementList()
                    }
                })
            }
        }
    }
    
    //==========================
    // MARK:- Tableview methods
    //==========================
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return self.allEqpHistry.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let headerView = UIView()
    //        headerView.frame = CGRect(x: 0, y: 0, width: Int(self.tableView.frame.size.width), height: 30)
    //        headerView.backgroundColor = UIColor(red: 246.0/255.0, green: 242.0/255.0, blue: 243.0/255.0, alpha: 1.0)
    //
    //        let headerLabel = UILabel(frame: CGRect(x: 14, y: 10, width:
    //            headerView.bounds.size.width-20, height: 20))
    //        headerLabel.font = Font.ArimoBold(fontSize: 13.0)
    //        headerLabel.textColor = UIColor(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
    //
    //        let dict = self.allEqpHistry[section]
    //
    ////        let firstKey = Array(dict.keys)[0]
    ////        let arr = firstKey.components(separatedBy: ",")
    ////        let att = changeColoreOFDate(main_string: firstKey, string_to_color: arr[0])
    ////
    ////        if(arr[0] == "Today" || arr[0] == "Yesterday" || arr[0] == "Tomorrow" ) {
    ////            headerLabel.attributedText = att
    ////        }else{
    ////            headerLabel.text = att.string
    ////        }
    //
    //
    //        headerLabel.textAlignment = .left;
    //
    //        DispatchQueue.main.async {
    //            headerView.addSubview(headerLabel)
    //        }
    //
    //        //headerView.addSubview(headerLabel)
    //        return headerView
    //    }
    //
    //
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 30.0
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == partTableView {
            return 140
        }else{
            return 103.0
        }
        return 140

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
     
        var cellToReturn = UITableViewCell()
        
        if tableView == self.serviceTblView {
            
            if(self.allEqpHistrySer.count != 0){
                let dict = self.allEqpHistrySer[section]
               
                return allEqpHistrySer.count
            }else{
                return 0
            }
            
            
        } else if tableView == self.tableView {
            
            if(self.allEqpHistry.count != 0){
                let dict = self.allEqpHistry[section]
                
                return allEqpHistry.count
            }else{
                return 0
            }
            
        }else if tableView == partTableView {
            return filterequipmentData.count
        }else if tableView == itemTableView {
            return newItemPart.count
        }
        
        return allEqpHistry.count + allEqpHistrySer.count + filterequipmentData.count + newItemPart.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellToReturn = UITableViewCell()
        
        if tableView == self.serviceTblView {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
            cell.isUserInteractionEnabled = true
            let dict = self.allEqpHistrySer[indexPath.section]
            //  print(self.arrOfFilterDict1[indexPath.section])
            // let firstKey = Array(dict.keys)[0] // or .first
            //  let arr = dict[firstKey]
            let audit = allEqpHistrySer[indexPath.row]
            
            cell.imgEquipment.isHidden = true
            cell.attchment_Audit.isHidden = true
            

            
            if let auditID = audit.audId {
                cell.name.text = "\(audit.label != nil ? audit.label! : "Apl\(auditID)" )"
            }
            
            
            if audit.schdlStartTime != "" {
                let dateTime =  DateFormate.dd_MMM_yyyy.rawValue
                                                                                  
                let sssa =  timeStampToDateFormate(timeInterval:audit.schdlStartTime!.description, dateFormate:dateTime)
               
                let schEndDate1 = getCurrentYy()
                               let dateTimeo =  DateFormate.dd_MMM_yyyy.rawValue
                              /// let dd = audit.schdlStartTime!
                               let value1 = compareTwodate(schStartDate: sssa, schEndDate: schEndDate1, dateFormate: DateFormate(rawValue: dateTimeo)!)
                               if(value1 == "orderedSame"){
                                   cell.statusServLbl.text = LanguageKey.today //"Today"//value1
                                   cell.statusServLbl.backgroundColor = UIColor(red: 0/255.0, green: 132/255.0, blue: 141/255.0, alpha: 1.0)
                                   print("Today")
                                   
                               }
                               if(value1 == "orderedDescending"){
                                    cell.statusServLbl.backgroundColor = UIColor(red: 0/255.0, green: 132/255.0, blue: 141/255.0, alpha: 1.0)
                                      cell.statusServLbl.text = LanguageKey.upcoming//"Upcoming"// value1
                                   print("Upcoming")
                                   
                               }
                               if(value1 == "orderedAscending"){
                                       cell.statusServLbl.backgroundColor = UIColor.red
                                      cell.statusServLbl.text =  LanguageKey.overdue//"Overdue"//value1
                                   print("Overdue")
                                   
                               }
                
              
                cell.dateService.text = "\(sssa != nil ? sssa : " " )"
            }else{
                 cell.dateService.text = " "
            }
            
            
            
            var address = ""
            if let adr = audit.adr {
                if adr != "" {
                    address = "\(adr)"
                }
            }
            
            
            if  address != "" {
                cell.taskDescription.attributedText =  lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
            }else{
                cell.taskDescription.text = ""
            }
            
            if audit.schdlStart != "" {
                let tempTime = convertTimestampToDate(timeInterval: audit.schdlStart!)
                cell.time.text = tempTime.0
                cell.timeAMPM.text = tempTime.1
                
            } else {
                cell.time.text = ""
                cell.timeAMPM.text = ""
            }
            
            
            //temp code // if status are nil ....
            
            if let statusValue = audit.status {
                if statusValue != "" {
                    let status =
                        taskStatus(taskType: taskStatusType(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)!)     //taskStatus(taskType: taskStatusType(rawValue: Int(job.status! == "0" ? "1" : job.status!)!)!)
                    
                    if taskStatusType(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)! == taskStatusType.InProgress{
                        cell.status.text = status.0
                        cell.leftBaseView.backgroundColor = UIColor(red: 109.0/255.0, green: 209.0/255.0, blue: 32.0/255.0, alpha: 1.0)
                        cell.status.textColor = UIColor.black
                        cell.timeAMPM.textColor = UIColor.white
                        cell.time.textColor = UIColor.white
                        cell.statusImage.image  = UIImage.init(named: "inprogress_white")
                    }else{
                        
                        cell.status.text = status.0.replacingOccurrences(of: " Task", with: "")
                      //  cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                        cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                        cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                        cell.statusImage.image  = status.1
                    }
                }else{
                    cell.status.text = ""
                   // cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                    cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                    cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                    cell.statusImage.image  = nil
                }
            }else{
                cell.status.text = ""
               // cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                cell.statusImage.image  = nil
            }
            
            
            
            
            
            //if user add job in OFFLINE mode and job not sync on the server
            let ladksj  = audit.audId!.components(separatedBy: "-")
            if ladksj.count > 0 {
                let tempId = ladksj[0]
                if tempId == "Job" {
                    
                    cell.name.textColor = UIColor.black
                    //cell.lblTitle.textColor = UIColor.lightGray
                    cell.time.textColor = UIColor.lightGray
                    cell.timeAMPM.textColor = UIColor.lightGray
                    cell.status.textColor = UIColor.black
                    cell.taskDescription.textColor = UIColor.red
                    cell.taskDescription.text = LanguageKey.audit_not_sync
                    cell.isUserInteractionEnabled = false
                }else{
                    
                    if audit.status != "7"{
                     //   cell.name.textColor =  UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        //cell.lblTitle.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        cell.taskDescription.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        cell.time.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                        cell.timeAMPM.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                       // cell.status.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                    }
                }
            }
            
            return cell
            cellToReturn = cell
            
        } else if tableView == self.tableView {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
            cell.isUserInteractionEnabled = true
            let dict = self.allEqpHistry[indexPath.section]
            //  print(self.arrOfFilterDict1[indexPath.section])
            // let firstKey = Array(dict.keys)[0] // or .first
            //  let arr = dict[firstKey]
            let audit = allEqpHistry[indexPath.row]
            
            cell.imgEquipment.isHidden = true
            cell.attchment_Audit.isHidden = true
            
            if selectedAuditID == audit.audId {
                cell.rightView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                cell.leftBaseView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            }else{
                cell.rightView.backgroundColor = UIColor.white
                cell.leftBaseView.backgroundColor = UIColor.white
            }
         
            
            if let auditID = audit.audId {
                cell.name.text = "\(audit.label != nil ? audit.label! : "Apl\(auditID)" )"
            }
         
            if audit.schdlStartTime != "" {
            let dateTime =  DateFormate.dd_MMM_yyyy.rawValue
                                                                 
                                                                   
            let sssa =  timeStampToDateFormate(timeInterval:audit.schdlStartTime!.description, dateFormate:dateTime)
               
                
                let schEndDate1 = getCurrentYy()
                let dateTimeo =  DateFormate.dd_MMM_yyyy.rawValue
               /// let dd = audit.schdlStartTime!
                let value1 = compareTwodate(schStartDate: sssa, schEndDate: schEndDate1, dateFormate: DateFormate(rawValue: dateTimeo)!)
                if(value1 == "orderedSame"){
                    cell.nameOne.text = LanguageKey.today
                    cell.nameOne.backgroundColor = UIColor(red: 0/255.0, green: 132/255.0, blue: 141/255.0, alpha: 1.0)
                    print("Today")
                    
                }
                if(value1 == "orderedDescending"){
                     cell.nameOne.backgroundColor = UIColor(red: 0/255.0, green: 132/255.0, blue: 141/255.0, alpha: 1.0)
                    cell.nameOne.text = LanguageKey.upcoming
                    print("Upcoming")
                    
                }
                if(value1 == "orderedAscending"){
                        cell.nameOne.backgroundColor = UIColor.red
                       cell.nameOne.text =  LanguageKey.overdue
                    print("Overdue")
                    
                }
                
            cell.dateLbl.text = "\(sssa != nil ? sssa : " " )"
                     
            }else{
                
                 cell.dateLbl.text = " "
            }
            
            var address = ""
            if let adr = audit.adr {
                if adr != "" {
                    address = "\(adr)"
                }
            }
            
            
            if  address != "" {
                cell.taskDescription.attributedText =  lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
            }else{
                cell.taskDescription.text = ""
            }
            
            if audit.schdlStart != "" {
                let tempTime = convertTimestampToDate(timeInterval: audit.schdlStart!)
                cell.time.text = tempTime.0
                cell.timeAMPM.text = tempTime.1
                
            } else {
                cell.time.text = ""
                cell.timeAMPM.text = ""
            }
            
            
            //temp code // if status are nil ....
            
            if let statusValue = audit.status {
                if statusValue != "" {
                    let status =
                        taskStatus(taskType: taskStatusType(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)!)     //taskStatus(taskType: taskStatusType(rawValue: Int(job.status! == "0" ? "1" : job.status!)!)!)
                    
                    if taskStatusType(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)! == taskStatusType.InProgress{
                        cell.status.text = status.0
                        cell.leftBaseView.backgroundColor = UIColor(red: 109.0/255.0, green: 209.0/255.0, blue: 32.0/255.0, alpha: 1.0)
                        cell.status.textColor = UIColor.black
                        cell.timeAMPM.textColor = UIColor.white
                        cell.time.textColor = UIColor.white
                        cell.statusImage.image  = UIImage.init(named: "inprogress_white")
                    }else{
                        
                        cell.status.text = status.0.replacingOccurrences(of: " Task", with: "")
                      //  cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                        cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                        cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                        cell.statusImage.image  = status.1
                    }
                }else{
                    cell.status.text = ""
                  //  cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                    cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                    cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                    cell.statusImage.image  = nil
                }
            }else{
                cell.status.text = ""
              //  cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                cell.statusImage.image  = nil
            }
            
            
            
            
            
            //if user add job in OFFLINE mode and job not sync on the server
            let ladksj  = audit.audId!.components(separatedBy: "-")
            if ladksj.count > 0 {
                let tempId = ladksj[0]
                if tempId == "Job" {
                    
                    cell.name.textColor = UIColor.black
                    //cell.lblTitle.textColor = UIColor.lightGray
                    cell.time.textColor = UIColor.lightGray
                    cell.timeAMPM.textColor = UIColor.lightGray
                    cell.status.textColor = UIColor.black
                    cell.taskDescription.textColor = UIColor.red
                    cell.taskDescription.text = LanguageKey.audit_not_sync
                    cell.isUserInteractionEnabled = false
                }else{
                    
                    if audit.status != "7"{
                     //   cell.name.textColor =  UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        //cell.lblTitle.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        cell.taskDescription.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        cell.time.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                        cell.timeAMPM.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                       // cell.status.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                    }
                }
            }
            
            return cell
            
        }else if tableView == partTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "quipmentCell",for: indexPath) as! EquipmentCell
            
          
            cell.btnDefaults.setTitle("View Details", for: .normal)
            cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
            let modl = LanguageKey.model_no
            let serl = LanguageKey.serial_no
          
            let cond = LanguageKey.condition
            let remark = LanguageKey.remark
            let equipment = filterequipmentData[indexPath.row]
            
            
                let aa = equipment.image
                        
                       if aa != nil {
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
                             
                       }
            
           // cell.remarkDisc.text = equipment.remark
            cell.lblName.text = equipment.equnm
            cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
            
        
        if equipment.status == "" &&  equipment.remark == ""{
          //  cell.remarkView_H.constant = 0
        }else{
         //  cell.remarkView_H.constant = 111
        }
        
        cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
        cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
        cell.lblAddress.text = equipment.location
        
            return cell
        }else if tableView == itemTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! InvoiceCell
           
           let aar = newItemPart[indexPath.row]
           
           
           var myrate = aar.rate
           if (myrate?.count)! > 0 {
               myrate = roundOff(value: Double((myrate)!)!)
           }else{
               myrate = roundOff(value:Double("0.00")!)
           }
           
           if aar.isBillable == nil {
               cell.billingLbl.isHidden = true
               cell.billingView.isHidden = true
           }else{
               
               if aar.isBillable == "1"{
                   
                   cell.billingLbl.isHidden = true
                   cell.billingView.isHidden = true
               }else{
                   
                   cell.billingLbl.isHidden = false
                   cell.billingView.isHidden = false
                   cell.billingLbl.textColor = .white
                   cell.billingLbl.text = LanguageKey.non_billable
                   
               }
               
           }
           
          
        //   print(aar.isBillable)
           var mydiscount = aar.discount
           if (mydiscount?.count)! > 0 {
               mydiscount = roundOff(value: Double((mydiscount)!)!)
           }else{
               mydiscount = roundOff(value:Double("0.00")!)
           }
           let ladksj  = aar.ijmmId?.components(separatedBy: "-")
           if ladksj!.count > 0 {
               let tempId = ladksj?[0]
               if tempId == "Item" {
                   cell.lblName.text = aar.inm?.capitalized
                   cell.discountLbl.text =
                   "\(LanguageKey.item_not_sync) " // aar.inm?.capitalized ?? "" + "  Not Sync"
                   cell.desLbl.text = aar.des?.capitalized
               }else  {
                   cell.lblName.text = aar.inm?.capitalized
                   //cell.discountLbl.textColor = UIColor.gray
                   cell.discountLbl.text = ""//aar.des?.capitalized
                   cell.desLbl.text = aar.des?.capitalized
               }
           }
      
           
           if aar.unit != "" {
               let qtyText = aar.unit! //LanguageKey.unit
               cell.qtyLbl.text = "\(qtyText): " + aar.qty!
           }else{
               let qtyText = LanguageKey.qty
               cell.qtyLbl.text = "\(qtyText): " + aar.qty!
           }
           
          
           cell.amountLbl.text = aar.amount ?? "0.0"
           

           return cell
        }
        return cellToReturn
     
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        var cellToReturn = UITableViewCell()
            
            if tableView == self.serviceTblView {
                
             
                
                 //  performSegue(withIdentifier: "EquipmentAuditHistry", sender: self)
                   let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
                   let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentServiceDetail") as! EquipmentServiceDetail
                   vc.serviceDetail = allEqpHistrySer[indexPath.row]
                  // vc.auditDetail = allEqpHistry
                   // vc.barcodeString = barcodeString
                   //  self.navigationController?.isNavigationBarHidden = false
                   self.navigationController?.pushViewController(vc, animated: true)
                
            } else if tableView == self.tableView {
                
              
               //  performSegue(withIdentifier: "EquipmentAuditHistry", sender: self)
                 let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
                 let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentAuditHistry") as! EquipmentAuditHistry
                 vc.jobArray = allEqpHistry[indexPath.row]
                // vc.auditDetail = allEqpHistry
                 // vc.barcodeString = barcodeString
                 //  self.navigationController?.isNavigationBarHidden = false
                 self.navigationController?.pushViewController(vc, animated: true)
            }
        
   
        
    }
    
    //=======================================
     // this user manual button functionality
    //=======================================
    
    @IBAction func btnAddUserDoc(_ sender: Any) {
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: LanguageKey.please_select, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: LanguageKey.cancel , style: .cancel) { _ in
            
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let document = UIAlertAction(title: LanguageKey.document, style: .default)
        { _ in
            
            
            let kUTTypeDOC = "com.microsoft.word.doc" // for Doc file
            let kUTTypeDOCX = "org.openxmlformats.wordprocessingml.document" // for Docx file
            let kUTTypeXls = "com.microsoft.excel.xls"
            let kUTTypeXlsx = "org.openxmlformats.spreadsheetml.sheet"
       
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeCommaSeparatedText),kUTTypeXls,kUTTypeXlsx,kUTTypeDOCX,kUTTypeDOC], in: .import)
                                             documentPicker.delegate = self
            APP_Delegate.showBackButtonTextForFileMan()
            self.present(documentPicker, animated: true, completion: nil)
        }
        
       // actionSheetControllerIOS8.addAction(gallery)
        //actionSheetControllerIOS8.addAction(camera)
        actionSheetControllerIOS8.addAction(document)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    @IBAction func addJobBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddJobVC") as! AddJobVC
      
      vc.callbackForJobVC = {(isBack : Bool) -> Void in
          self.isAdded = true
        
         // self.filterArrToDate(date: self.currentDate)
          //self.isChanged =  false
        //  self.getJobListFromDB()
      }
        vc.eqDetail  = true
        if equipmentDetailJob.count > 0 {
            vc.aadEqId = equipmentDetailJob[0].equId
          }else{
              vc.aadEqId =  self.equipments?.equId
        }
        
      
        vc.eqpmtArr = self.equipments
        //vc.invoiceid = (self.invoiceRes.data?.invId)!
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnViewUserDoc(_ sender: Any) {
       
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pdfvc") as! ShowPdfVC
        vc.pdfWithEquipment = true
        vc.pdfPathFromEquDetail =  (equipments?.usrManualDoc as? String ?? "")
        //vc.jobIdLabel = objOfUserJobListInDetail?.label as! String
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
        //=============================
    // MARK:- Document picker methods
    //=============================
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        APP_Delegate.hideBackButtonText()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        //  print(url)
        
        let filename = url.lastPathComponent
        let splitName = filename.split(separator: ".")
        let name = splitName.first!
        let filetype = splitName.last!.lowercased()
        
        APP_Delegate.hideBackButtonText()
        
        //'jpg','png','jpeg'
        if filetype == "jpg" || filetype == "png" || filetype == "jpeg" {
            
            do {
                let imageData = try Data(contentsOf: url as URL)
                
                if let image = UIImage(data: imageData) {
                    APP_Delegate.showBackButtonText()
                    //self.showPhotoEditor(withImage: image, andImageName: filename)
                }
            }
            catch {
                // can't load image data
            }
        }else{
            let imageName = String(name)
            self.uploadMediaDocuments(fileUrl: url, fileName: imageName)
   
        }
        
    }
    
    //=======================================
    // MARK:- User Manual LIST Service methods
    //=======================================
    func uploadMediaDocuments(fileUrl : URL ,fileName : String) {
       
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            }
            return
        }
        
        showLoaderOnWindow()
        let param = Params()
        if equipmentDetailJob.count > 0 {
            param.equId = equipmentDetailJob[0].equId
          }else{
            param.equId = equipments?.equId
        }
        param.usrManualDoc = fileUrl
        
        
        serverCommunicatorUplaodDocuments(url: Service.uploadEquUsrManualDoc, param: param.toDictionary, docUrl: fileUrl, DocPathOnServer: "usrManualDoc", docName: fileName) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(UserManualData.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            
                            killLoader()
                            
                            if((decodedData.data?.count)! > 0){
                                self.getAuditListService()
                                
                             self.navigationController?.popViewController(animated: true)
                            }else{
                                killLoader()
                                ShowAlert(title: LanguageKey.success, message:getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                            }
                        }
                    }else{
                        killLoader()

                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                      
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                killLoader()
                ShowError(message: errorString, controller: windowController)
            }
        }
        
        
     self.getJobListService()
    }

    // api calling for refresh list
    
    //==================================
    // MARK:- Audit LIST Service methods
    //==================================
    func getAuditListService(){
        
        if !isHaveNetowork() {
            return
        }
        showLoader()
        var dates = ("","")
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.usrId = getUserDetails()?.usrId
        param.limit = ContentLimit
        param.index = "0"
        param.search = ""
        param.dtf = dates.0
        param.dtt = dates.1
        param.isCallFromCurrent = "1"
        var dict = param.toDictionary
        //dict!["status"] = selectedStatus
        
        
        
        serverCommunicator(url: Service.getAuditList, param: dict) { (response, success) in
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(AuditListResponse.self, from: response as! Data) {
                    
                    killLoader()
                    
                    if decodedData.success == true{
                        
                        
                        
                        if let arryCount = decodedData.data{
                            if arryCount.count > 0 {
                                
                               // self.count += (decodedData.data?.count)!
                                
                                if !self.isUserfirstLogin {
                                    
                                    self.saveUserAuditsInDataBase(data: decodedData.data!)
                                    
                                    //Request time will be update when data comes otherwise time won't be update
                                    UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getAuditList)
                                    
                                    
                                }else{
                                    self.saveAllUserAuditInDataBase(data: decodedData.data!)
                                }
                            }
                            
                        }
                    }
                }
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
        
    
    
            //=====================================
            // MARK:- save offline  in AuditList
            //=====================================
            
            func saveAllUserAuditInDataBase( data : [AuditListData]) -> Void {
                for job in data{
                    //if(job.isdelete != "0"){
                        if (Int(job.status!) != taskStatusType.Cancel.rawValue) &&
                            (Int(job.status!) != taskStatusType.Reject.rawValue) &&
                            (Int(job.status!) != taskStatusType.Closed.rawValue)
                        {
                            let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
                            userJobs?.setValuesForKeys(job.toDictionary!)
                            //DatabaseClass.shared.saveEntity(callback: {_ in
                                
                            //})
                        }
                    }
               // }
            }
            
            func saveUserAuditsInDataBase( data : [AuditListData]) -> Void {

                     for job in data{
                         let query = "audId = '\(job.audId!)'"
                         let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: query) as! [AuditOfflineList]

                 
                         if isExist.count > 0 {
                             let existingJob = isExist[0]
                             //if Job status Cancel, Reject, Closed so this job is delete from Database

                             if(job.isdelete == "0") {
                                 ChatManager.shared.removeJobForChat(jobId: existingJob.audId!)
                                 DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                             }else if (Int(job.status!) == taskStatusType.Cancel.rawValue) ||
                                 (Int(job.status!) == taskStatusType.Reject.rawValue) ||
                                 (Int(job.status!) == taskStatusType.Closed.rawValue)
                             {
                                 ChatManager.shared.removeJobForChat(jobId: existingJob.audId!)
                                 DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                             }else{
                                 existingJob.setValuesForKeys(job.toDictionary!)
    //                        DatabaseClass.shared.saveEntity(callback: {_ in
    //
    //                        })
                            }
                         }else{
                             if(job.isdelete != "0") {
                                 if (Int(job.status!) != taskStatusType.Cancel.rawValue) &&
                                     (Int(job.status!) != taskStatusType.Reject.rawValue) &&
                                     (Int(job.status!) != taskStatusType.Closed.rawValue)
                                 {
                                     let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
                                     userJobs?.setValuesForKeys(job.toDictionary!)
                            print(userJobs)
    //                                 //DatabaseClass.shared.saveEntity()

                                     let query = "audId = '\(job.tempId ?? "")'"
                                     let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: query) as! [AuditOfflineList]

                                     if isExistJob.count > 0 {
                                         let existing = isExistJob[0]
                                         DatabaseClass.shared.deleteEntity(object: existing, callback: { (_) in})
                                     }

                                 }
                             }
                         }
                     }
                       

                 }
    
            //==================================
            // MARK:- JOB LIST Service methods
            //==================================
        
        
        func getJobListService(){
              
              if !isHaveNetowork() {
                  if self.refreshControl.isRefreshing {
                      self.refreshControl.endRefreshing()
                  }
                  
                  return
              }
              
              
              let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getJobList) as? String
              let param = Params()
              param.usrId = getUserDetails()?.usrId
              param.limit = "120"
              param.index = "\(count)"
              param.search = ""
              param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
              
              
              serverCommunicator(url: Service.getUserJobListNew, param: param.toDictionary) { (response, success) in
                  
                  DispatchQueue.main.async {
                      if self.refreshControl.isRefreshing {
                          self.refreshControl.endRefreshing()
                      }
                  }
                  
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
                                     // self.changePercentage(apiNumber:7,title: LanguageKey.completed)
                                      
                                      // check if filter enable then data not reload on table
    //                                  if  self.filterjobsArray.count == 0{
    //                                      //print("showDataOnTableView running")
    //                                      self.showDataOnTableView(query: nil) //Show joblist on tableview
    //                                  }
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
    @IBAction func showUserBtn(_ sender: Any) {
    if self.manualDocBtn.isSelected == false
    {
        self.manualDocBtn.isSelected = true
        if equipmentDetailJob.count > 0 {
            if equipmentDetailJob[0].usrManualDoc != "" {
                btnViewUserManual.isHidden = false
               
            }else{
                manualDocBtn.isHidden = false
            }
        }else if adminEquipment.count > 0{
            if adminEquipment[0].usrManualDoc != "" {
                btnViewUserManual.isHidden = false
               
            }else{
               
                manualDocBtn.isHidden = false
            }
        }else if equipmentDetailAudit.count > 0{
            
            if equipmentDetailAudit[0].usrManualDoc != "" {
                btnViewUserManual.isHidden = false
              
            }else{
               
                manualDocBtn.isHidden = false
            }
        }
            else {
            
                if equipments?.usrManualDoc != "" {
                btnViewUserManual.isHidden = false
              
            }else{
               
                manualDocBtn.isHidden = false
            }
            
        } //self.manualDocBtn.isSelected = true
        // manualDocBtn.isHidden = true
    }
        
    else
        
    {

             self.manualDocBtn.isSelected = false
             manualDocBtn.isHidden = true
             btnViewUserManual.isHidden = true
         }
         //manualDocBtn.isHidden = false
     }
    
    @IBAction func manualDocBtn(_ sender: Any) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: LanguageKey.please_select, message: nil, preferredStyle: .actionSheet)
                
                let cancelActionButton = UIAlertAction(title: LanguageKey.cancel , style: .cancel) { _ in
                    
                }
                actionSheetControllerIOS8.addAction(cancelActionButton)
                
                let document = UIAlertAction(title: LanguageKey.document, style: .default)
                { _ in
                    
                    
                    let kUTTypeDOC = "com.microsoft.word.doc" // for Doc file
                    let kUTTypeDOCX = "org.openxmlformats.wordprocessingml.document" // for Docx file
                    let kUTTypeXls = "com.microsoft.excel.xls"
                    let kUTTypeXlsx = "org.openxmlformats.spreadsheetml.sheet"
               
                    let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeCommaSeparatedText),kUTTypeXls,kUTTypeXlsx,kUTTypeDOCX,kUTTypeDOC], in: .import)
                                                     documentPicker.delegate = self
                    APP_Delegate.showBackButtonTextForFileMan()
                    self.present(documentPicker, animated: true, completion: nil)
                }
                
               // actionSheetControllerIOS8.addAction(gallery)
                //actionSheetControllerIOS8.addAction(camera)
                manualDocBtn.isHidden = true
                actionSheetControllerIOS8.addAction(document)
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    //==============================================
    // MARK:- Document getAllEquipmentItems Service
    //==============================================
    
    func getAllEquipmentItems() {

        
          if !isHaveNetowork() {
                  ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                  if self.refreshControl.isRefreshing {
                      self.refreshControl.endRefreshing()
                  }
                  return
              }
        
        let param = Params()
        if equipmentDetailJob.count > 0 {
            param.equId = equipmentDetailJob[0].equId
          }else{
            param.equId = equipments?.equId
        }
        
        
        serverCommunicator(url: Service.getAllEquipmentItems, param: param.toDictionary) { (response, success) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
        
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(getAllEquipmentItemsRes.self, from: response as! Data) {
                    if decodedData.success == true {
                 
                        self.newItemPart = decodedData.data as! [AllEquipmentItemsData]
                        

                        DispatchQueue.main.async {
                           
                            var nm = LanguageKey.equipment_items
                            self.itemLbl.text! = "\(nm): \(String(self.newItemPart.count))"
                            
                            
                            if self.newItemPart.count == 0 {
                                self.H_itemView.constant = 55
                            }else if self.newItemPart.count == 1 {
                                self.H_itemView.constant = 120
                            }else if self.newItemPart.count == 2 {
                                self.H_itemView.constant = 240
                            }else if self.newItemPart.count == 3 {
                                self.H_itemView.constant = 330
                            }else if self.newItemPart.count == 4 {
                                self.H_itemView.constant = 440
                            }else if self.newItemPart.count == 5 {
                                self.H_itemView.constant = 550
                            }else if self.newItemPart.count == 6 {
                                self.H_itemView.constant = 660
                            }else if self.newItemPart.count == 7 {
                                self.H_itemView.constant = 770
                            }else if self.newItemPart.count == 8 {
                                self.H_itemView.constant = 880
                            }else if self.newItemPart.count == 9 {
                                self.H_itemView.constant = 990
                            }else if self.newItemPart.count == 10 {
                                self.H_itemView.constant = 1100
                            }else if self.newItemPart.count == 11 {
                                self.H_itemView.constant = 1210
                            }



                        self.itemTableView.reloadData()
                        }
                       
                        
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        if cancel {
                            showLoader()
                            self.getAllEquipmentItems()
                        }
                    })
                }
            }
        }
    }
    
}

extension EquipmentDetailVc : BarcodeScannerErrorDelegate, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.isKind(of: ScanBarcodeVC.self) {
            if !isHaveNetowork() {
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                killLoader()
                return false
            }
            
            ActivityLog(module:Modules.audit.rawValue , message: ActivityMessages.auditScanBarcode)
            scanBarcode()
            return false
        }
        return true
    }
    
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        //  print(code)
        getGenerateBarcodeOffline(barcodeString: code)
        UserDefaults.standard.set(code, forKey: "barcodeString")
        //        getEquipmentListFromBarcodeScanner(barcodeString: code)
        controller.dismiss(animated: true, completion: {
            controller.reset()
        })
    }
    
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func scanBarcode() -> Void {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        viewController.equipId = equipments?.equId
        viewController.isScanBarcode = true
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    
}

class ScanBarcodeResponse: Codable {
    var success: Bool?
    var message: String?
    var data: String?
    var statusCode:String?
}


