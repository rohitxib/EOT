//
//  AuditTabController.swift
//  EyeOnTask
//
//  Created by Mojave on 07/11/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

//
//  JobTabController.swift
//  EyeOnTask
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import CoreData
//import BarcodeScanner
import AVFoundation

class AuditTabController: UITabBarController{
    var name : String?
//    var  objOfUserJobList : AuditListData?
    var  objOfUserJobList : AuditOfflineList?
    var tabUserJob = AuditListData()
    //var equidataArr = []
   // var jobs = [AuditListData]()
    var jobs = [AuditOfflineList]()
    var chatmodel = [ChatModel]()
    var isChatTabSelected = false
    var callback: ((Bool,NSManagedObject) -> Void)?
    var customCollectionVew : CustomCollectionView?
    var chatBadgePosition = 2
    var btnMore : UIButton?
    var invoiceId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetBackBarButtonCustom()
        //    tabBarController?.moreNavigationController.navigationBar.topItem?.title = LanguageKey.more
        self.delegate = self
        let storyboard = UIStoryboard(name: "MainAudit", bundle: nil)
        var controllers = [UIViewController]()
        
        let detailCon = storyboard.instantiateViewController(withIdentifier: "auditDetailVC") as! AuditDetailVC
        detailCon.tabBarItem = UITabBarItem(title:LanguageKey.detail_audit, image: UIImage(named: "detail_selected"), tag: 0)
        detailCon.auditDetail = objOfUserJobList
        detailCon.jobArray = jobs
        detailCon.callbackDetailVC = callback
        controllers.append(detailCon)
        
//        let  isItem = isPermitForShow(permission: permissions.isItemVisible)
//        if isItem {
//        let  isEquipmentEnable = isPermitForShow(permission: permissions.isEquipmentEnable)
//            if  isEquipmentEnable {
                
                var isCustomFieldEnable = true
                                    if let enableCustomForm = getDefaultSettings()?.isEquipmentEnable{ //This is round off digit for invoice
                                        if enableCustomForm == "1"{
            let invoiceCon = storyboard.instantiateViewController(withIdentifier: "euipmentvc") as! EquipmentVC
            invoiceCon.tabBarItem = UITabBarItem(title: LanguageKey.detail_equipment, image: UIImage(named: "Equipement"), tag: 1)
            invoiceCon.auditDetail = objOfUserJobList
            controllers.append(invoiceCon)
                                            
                                        }
                                        
        }
//
//            chatBadgePosition = 2
//        }else{
//            chatBadgePosition = 1
//        }
        //var isCustomFieldEnable = true
                                      if let enableCustomForm = getDefaultSettings()?.isEquipmentEnable{ //This is round off digit for invoice
                                          if enableCustomForm == "1"{
        let scanCon = storyboard.instantiateViewController(withIdentifier: "barcode") as! ScanBarcodeVC
        scanCon.tabBarItem = UITabBarItem(title: LanguageKey.detail_scan_barcode, image: UIImage(named: "qrcode"), tag: 1)
        //scanCon.auditDetail = objOfUserJobList
        controllers.append(scanCon)
        
                                        }
                                        
        }
        let feedbackCon = storyboard.instantiateViewController(withIdentifier: "reportvc") as! AuditReportVC
        feedbackCon.tabBarItem = UITabBarItem(title: LanguageKey.detail_report, image: UIImage(named: "Report"), tag: 1)
        feedbackCon.auditDetail = objOfUserJobList
        controllers.append(feedbackCon)
        

        
        let Document = storyboard.instantiateViewController(withIdentifier: "auditDocument") as! AuditDocuments
        Document.tabBarItem = UITabBarItem(title: LanguageKey.title_documents, image: UIImage(named: "Document"), tag: 1)
        Document.auditDetail = objOfUserJobList
        controllers.append(Document)
        self.viewControllers = controllers
        
    }
    
    func SetBackBarButtonCustom()
       {
           //Back buttion

             let button = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action:#selector(AuditVC.onClcikBack))
             self.navigationItem.leftBarButtonItem  = button
       }

       @objc func onClcikBack()
       {
           _ = self.navigationController?.popViewController(animated: true)
           self.dismiss(animated: true, completion: nil)
       }
    
    
    func scanBarcode() -> Void {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        viewController.auditId = objOfUserJobList?.audId
        present(viewController, animated: true, completion: nil)
    }
    func getEquipmentListFromBarcodeScannerOffline(barcodeString : String) -> Void {

            var equpDataArray = [equipDataArray]()

            let isExistAudit = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: nil) as! [AuditOfflineList]
            if isExistAudit.count > 0 {


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
                                                    
                                                   let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                                  // equipmentData.append(dic)
                                                          //equpDataArrayAudit.append(dic)
                                                        equpDataArray.append(dic)
                                                   // print(equipmentDic.self)

                                                   // if let dta = item as? equipData {
                                                   // }
                                                   }else {
                                                   let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                                  // equipmentData.append(dic)
                                                          //equpDataArrayAudit.append(dic)
                                                        equpDataArray.append(dic)
                                                       }
                                                       
                                                      
                                                      }else{
              let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:[], type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
//
            equpDataArray.append(dic)
                }
            }


            }
            }


            }
        
        //objOfUserJobList?.equArray

        let auditBarcode = equpDataArray.filter({$0.barcode == barcodeString})

            if auditBarcode.count != 0 {


            //audit
            if equpDataArray.count > 1 {

            let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
            vc.equipmentDetailAudit = equpDataArray
            vc.barcodeString = barcodeString
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)

        //    let navCon = NavClientController(rootViewController: vc)
        //    navCon.modalPresentationStyle = .fullScreen
        //    vc.isBarcodeScanner = true



          //  self.present(navCon, animated: true, completion: nil)

            }else{

            let vc = UIStoryboard(name: "MainAudit", bundle: nil).instantiateViewController(withIdentifier: "remarkTab") as! RemarkVC;
            let navCon = NavClientController(rootViewController: vc)
            vc.isPresented = true
            vc.equipment = equpDataArray[0]
        //    navCon.modalPresentationStyle = .fullScreen
        //    self.present(navCon, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)

            }

            }else{
                
                self.showToast(message: "Equipment not found")
                
                }

    }
    
  
}//END


extension AuditTabController : BarcodeScannerErrorDelegate, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, UITabBarControllerDelegate {
    
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
        print(code)
        getEquipmentListFromBarcodeScannerOffline(barcodeString: code)
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
    

}


