//
//  LinkAuditEquipment.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 11/04/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class LinkAuditEquipment: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var msgLbl_H: NSLayoutConstraint!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var eqpmtNotFound: UILabel!
    @IBOutlet weak var lblEqListNo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var isLink = ""
    var objOfUserJobListInDetails : AuditOfflineList?
    var LinkEquipmentData = [LinkEquipment]()
    var link_unlinkMsg = ""
    var arrayCltId = [AuditEquipment]()
    var buttonSwitched : Bool = false
    var selectedRows:[Int] = []
    var ContrctBool = false
    var buttonIsSelected = false
    
    var eqIdComp = ""
    var arrayEqId2 =  [String]()
    var arrayEqId = [String]()
    @IBOutlet weak var img: UILabel!
    var clientBool : Bool  = false
    //=========================
    // MARK:- Initial methods
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        getEquipementListService()
        self.messageLbl.text = LanguageKey.client_link_msg
        if objOfUserJobListInDetails?.contrId == "0"{
            self.msgLbl_H.constant = 0
            self.yesBtn.isHidden = true
        }else{
            self.yesBtn.isHidden = false
            self.msgLbl_H.constant = 38
        }
        if isLink == "Own" {
            getEquipmentList()
            self.navigationItem.title = LanguageKey.link_equipment
        }
        if isLink == "Client" {
            getEquipmentListClient()
            self.navigationItem.title = LanguageKey.link_equipment
            
        }
        
        
        
        setLocalization()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setData()
        self.tabBarController?.navigationItem.title = LanguageKey.detail_equipment//LanguageKey.title_documents
        
        tableView.estimatedRowHeight = 200
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        
    }
    
    
    func setLocalization() -> Void {
        self.lblEqListNo.text! = "\(LanguageKey.equipment) 0"
    }
    
    
    //==========================
    // MARK:- Tableview methods
    //==========================
    
    
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 103.0
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        //return equipments.count
        return LinkEquipmentData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quipmentCell",for: indexPath) as! EquipmentCell
     
        cell.linkView.backgroundColor =    UIColor(red: 226/255, green: 235/255, blue: 236/255, alpha: 1)//.red
        cell.link_Lbl.text = LanguageKey.unlinked
        cell.leftview.isHidden = false
        cell.rightView.isHidden = true
        
        cell.btnDefaults.setTitle("  \(LanguageKey.equipment_btn)" , for: .normal)
        cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
        let modl = LanguageKey.model_no
        let serl = LanguageKey.serial_no
        
        let cond = LanguageKey.condition
        let remark = LanguageKey.remark
        let equipment = LinkEquipmentData[indexPath.row]
        
        //  let clt = arrayCltId[indexPath.row]
        if equipment.isPart == "0"{
            cell.lblName.text = equipment.equnm
            cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        }
        else{
            cell.lblName.text = equipment.equnm
            cell.lblName.textColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
        }
        
        // cell.linkLbl.text = clt.equId
        // cell.lblName.text = equipment.equnm
        cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
        cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
        cell.conditationLbl.text = equipment.adr!
        ///  cell.lblAddress.text = equipment.location///////
        
        if  arrayCltId.contains(where: { $0.equId == equipment.equId }) {
            
           // print("Link")
            cell.linkView.backgroundColor = UIColor(red: 36/255.0, green: 147/255.0, blue: 155/255.0, alpha: 1)
            cell.link_Lbl.text = LanguageKey.linked
            cell.leftAuditLink_H.constant = 0
            cell.rightAuditLink_H.constant = 21
            cell.rightView.isHidden = false
            cell.linkBtnAct.addTarget(self, action: #selector(buttonTappedUnLink( sender: )), for: .touchUpInside)
            cell.linkBtnAct.tag = indexPath.row
            cell.linkBtnAct.isHidden = false
            cell.unlinkBtnAct.isHidden = true
            if equipment.status == "4378"{
                cell.auditLinkStatusLbl.text = "Active"
            }
            
            if equipment.status == "2332"{
                cell.auditLinkStatusLbl.text = "Deployed"
            }
        }else{
         //   print("UnLink")
            
            cell.linkView.backgroundColor =  UIColor(red: 226/255, green: 235/255, blue: 236/255, alpha: 1)//.red
            cell.link_Lbl.text = LanguageKey.unlinked
            cell.leftview.isHidden = false
            cell.rightAuditLink_H.constant = 0
            cell.leftAuditLink_H.constant = 21
            cell.unlinkBtnAct.isHidden = false
            cell.linkBtnAct.isHidden = true
            cell.unlinkBtnAct.addTarget(self, action: #selector(buttonTapped( sender: )), for: .touchUpInside)
            cell.unlinkBtnAct.tag = indexPath.row
        }
        if arrayCltId.count > 0{
            for (index, job) in arrayCltId.enumerated() {
                
                
                if let match = LinkEquipmentData.first( where: {job.equId == $0.equId} ) {
                    //print(match.equId)
                    
                    
                    eqIdComp = match.equId!
                    arrayEqId.append(eqIdComp)
                    // for eq in eqIdComp{
                    //  print(arrayEqId)
                    //                       if equipment.equId == eqIdComp {
                    //                            var h = ["1"]
                    //                           equipment.linkkey? = h
                    //                           //equipment.linkkey?.append(h)
                    //                           // equipment.linkkey!.append(h)
                    //                           // self.tableView.reloadData()
                    //                           //  print(eqIdComp)
                    //                           cell.linkView.backgroundColor = UIColor(red: 36/255.0, green: 147/255.0, blue: 155/255.0, alpha: 1)
                    //                        cell.link_Lbl.text = LanguageKey.linked
                    //                           cell.leftview.isHidden = true
                    //                           cell.rightView.isHidden = false
                    //
                    //                       }else{
                    //
                    //
                    //                         var h = ["2"]
                    //                            equipment.linkkey? = h
                    //                                          //    equipment.linkkey?.append(h)
                    //                           cell.linkView.backgroundColor = .red
                    //                           cell.link_Lbl.text = LanguageKey.unlinked
                    //                           cell.leftview.isHidden = false
                    //                           cell.rightView.isHidden = true
                    //                       }
                    // print(equipment.linkkey)
                    
                    //}
                    
                }
            }
        }else{
            
        }
        
        selectedRows.contains(indexPath.row)
        //        cell.linkBtnAct.addTarget(self, action: #selector(buttonTapped( sender: )), for: .touchUpInside)
        //        cell.linkBtnAct.tag = indexPath.row
        
        if equipment.status == "4378"{
            cell.auditLinkStatusLbl.text = "Active"
        }
        
        if equipment.status == "2332"{
            cell.auditLinkStatusLbl.text = "Deployed"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @objc func buttonTapped(sender: UIButton) {
        self.link_unlinkMsg = "link"
        self.selectedRows.append(sender.tag)
        for index in self.selectedRows {
            let getValue = LinkEquipmentData[index].equId
            
            self.arrayEqId.append(getValue!)// link
            
            //              let modifiedArray = arrayEqId.filter { $0 != getValue }
            //              arrayEqId = modifiedArray //unlink
            
        }
        addAuditEquipment()
        
        
    }
    
    @objc func buttonTappedUnLink(sender: UIButton) {
        
        self.link_unlinkMsg = "Unlink"
        //  if self.selectedRows.contains(sender.tag){
        //selectData.removeAll()
        self.selectedRows.append(sender.tag)
        for index in self.selectedRows {
            let getValue = LinkEquipmentData[index].equId
            
            
            let modifiedArray = arrayEqId.filter { $0 != getValue }
            arrayEqId = modifiedArray //unlink
            
        }
        
        addAuditEquipment()
        
        
        
    }
    
    @IBAction func searchBtnActn(_ sender: Any) {
        
    }
    
    @IBAction func yesBtnActn(_ sender: Any) {
        
        buttonIsSelected = !buttonIsSelected
        updateOnOffButton()
    }
    
    
    
    func updateOnOffButton() {
        if buttonIsSelected {
            
            clientBool  = true
            self.messageLbl.text = LanguageKey.client_link_msg
            
            ContrctBool = true
            getEquipmentListClient()
            //  getContractEquipmentList()
            
        }else{
            clientBool  = false
            self.messageLbl.text = LanguageKey.contract_link_msg
            // ContrctBool = false
            
            //  if isLink == "Own" {
            //    getEquipmentList()
            //  self.navigationItem.title = "Own Equipment"
            // }
            if isLink == "Client" {
                getEquipmentListClient()
                self.navigationItem.title = LanguageKey.link_equipment
                
            }
            //showEyePass
            
        }
    }
    @IBAction func addEquipmentBtn(_ sender: Any) {
        
    }
    
    
    
    
    //==================================/
    // MARK:- Equipement getEquipmentList methods
    //==================================
    func getEquipmentList(){
        
        if !isHaveNetowork() {
            
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        showLoader()
        
        //{"index":0,"activeRecord":1,"limit":10,"search":"","expiry_dtf":"","expiry_dtt":"","cltId":"","type":"1","audId":"","isParent":"0","contrId":""}:
        let param = Params()
        
        param.limit = "500"
        param.index = "0"
        param.search = ""
        param.activeRecord = "1"
        param.expiry_dtf = ""
        param.expiry_dtt = ""
        param.type = "1"
        param.audId = ""
        param.isParent = "0"
        param.contrId = ""
        param.cltId = ""//objOfUserJobListInDetail?.cltId
        
        serverCommunicator(url: Service.getEquipmentList, param: param.toDictionary) { (response, success) in
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(LinkEquipmentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        killLoader()
                        if decodedData.data!.count > 0 {
                            self.LinkEquipmentData = decodedData.data as! [LinkEquipment]
                            
                            DispatchQueue.main.async {
                                
                                if self.LinkEquipmentData.count > 0  {
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
                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.LinkEquipmentData.count))"
                                //  self.tableView.isHidden = false//
                                
                                //  self.lblImg.isHidden = true
                                //  self.lblNotFound.isHidden = true
                                
                                killLoader()
                            }
                        }else{
                            DispatchQueue.main.async {
                                if self.LinkEquipmentData.count > 0  {
                                    self.img.isHidden = true
                                    self.eqpmtNotFound.isHidden = true
                                    //   print("jugal 1")
                                }else{
                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
                                    self.img.isHidden = false
                                    self.eqpmtNotFound.isHidden = false
                                    // print("jugal 0")
                                }
                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.LinkEquipmentData.count))"
                                self.tableView.reloadData()
                                //                                       self.lblNotFound.text = LanguageKey.audit_not_found
                                //                                       self.tableView.isHidden = true
                                //                                       self.lblImg.isHidden = false
                                //                                       self.lblNotFound.isHidden = false
                                //                                       self.tableView.reloadData()
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
                            
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        
                    }
                })
            }
            
            
        }
        
    }
    
    
    //==================================/
    // MARK:- Equipement getEquipmentList methods
    //==================================
    func getEquipmentListClient(){
        
        if !isHaveNetowork() {
            
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        showLoader()
        //            {"index":0,"activeRecord":1,"limit":10,"search":"","expiry_dtf":"","expiry_dtt":"","cltId":"10324","type":"2","audId":"96875","isParent":"0","contrId":""}:
        
        let param = Params()
        
        param.limit = "500"
        param.index = "0"
        param.search = ""
        param.activeRecord = "1"
        param.expiry_dtf = ""
        param.expiry_dtt = ""
        param.type = "2"
        param.audId = objOfUserJobListInDetails?.audId
        param.isParent = "0"
        
        if clientBool == true {
            param.contrId = ""
        }else{
            if objOfUserJobListInDetails?.contrId == "0" {
                param.contrId = ""
            }else{
                param.contrId = objOfUserJobListInDetails?.contrId
            }
        }
        
        
        param.cltId = objOfUserJobListInDetails?.cltId
        
        serverCommunicator(url: Service.getEquipmentList, param: param.toDictionary) { (response, success) in
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(LinkEquipmentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        killLoader()
                        if decodedData.data!.count > 0 {
                            self.LinkEquipmentData = decodedData.data as! [LinkEquipment]
                            
                            DispatchQueue.main.async {
                                
                                if self.LinkEquipmentData.count > 0  {
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
                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.LinkEquipmentData.count))"
                                //  self.tableView.isHidden = false//
                                
                                //  self.lblImg.isHidden = true
                                //  self.lblNotFound.isHidden = true
                                
                                killLoader()
                            }
                        }else{
                            DispatchQueue.main.async {
                                if self.LinkEquipmentData.count > 0  {
                                    self.img.isHidden = true
                                    self.eqpmtNotFound.isHidden = true
                                    //   print("jugal 1")
                                }else{
                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
                                    self.img.isHidden = false
                                    self.eqpmtNotFound.isHidden = false
                                    // print("jugal 0")
                                }
                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.LinkEquipmentData.count))"
                                self.tableView.reloadData()
                                //                                       self.lblNotFound.text = LanguageKey.audit_not_found
                                //                                       self.tableView.isHidden = true
                                //                                       self.lblImg.isHidden = false
                                //                                       self.lblNotFound.isHidden = false
                                //                                       self.tableView.reloadData()
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
                            
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        
                    }
                })
            }
            
            
        }
        
    }
    
    
    
    //==================================
    // MARK:- Equipement LIST Service methods
    //==================================
    func getEquipementListService(){
        
        //               if !isHaveNetowork() {
        //                   if self.refreshControl.isRefreshing {
        //                       self.refreshControl.endRefreshing()
        //                   }
        //                   killLoader()
        //                   ShowError(message: AlertMessage.networkIssue, controller: windowController)
        //
        //                   return
        //               }
        //
        
        
        
        let param = Params()
        param.index = "0"
        param.activeRecord = "0"
        param.audId = objOfUserJobListInDetails?.audId
        param.contrId = "0"
        param.isJob = "1"
        param.isParent = "1"
        
        
        serverCommunicator(url: Service.getAuditEquipmentList, param: param.toDictionary) { (response, success) in
            
            //                      DispatchQueue.main.async {
            //                          if self.refreshControl.isRefreshing {
            //                              self.refreshControl.endRefreshing()
            //                          }
            //                      }
            
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(AuditEquipmentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data!.count > 0 {
                            self.arrayCltId = decodedData.data as! [AuditEquipment]
                            // print(arrayCltId.eq)
                            DispatchQueue.main.async {
                                //  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                self.tableView.reloadData()
                                killLoader()
                            }
                        }else{
                            //   print("jugal")
                            //  self.equipments.removeAll()
                            DispatchQueue.main.async {
                                //  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                //
                                
                                killLoader()
                            }
                        }
                    }else{
                        killLoader()
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                            
                            if cancel {
                                showLoader()
                                // self.getEquipementListService()
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
        
    }
    
    
    //==================================
    // MARK:- addAuditEquipment Service methods
    //==================================
    func addAuditEquipment(){
        
        showLoader()
        
        
        let param = Params()
        
        var parm = [String: Any]()
        
        
        
        var ar = ["394"]
        parm["equId"] = arrayEqId
        parm["contrId"] = ""
        parm["audId"] = objOfUserJobListInDetails?.audId
        // var ar:Array = ["319"]
        //        param.equId = ""
        //        param.contrId = ""
        //        param.audId = objOfUserJobListInDetails?.audId
        
        
        
        serverCommunicator(url: Service.addAuditEquipment, param: parm) { (response, success) in
            
            
            
            if(success){
                let decoder = JSONDecoder()
                killLoader()
                DispatchQueue.main.async {
                    if self.link_unlinkMsg == "link" {
                        self.showToast(message: AlertMessage.linked)
                    }
                    if self.link_unlinkMsg == "Unlink" {
                        self.showToast(message: AlertMessage.unlinked)
                    }
                    // self.addEquip = true
                    self.navigationController?.popToRootViewController(animated: true)
                    // self.showToast(message:LanguageKey.euipment_remark_update)
                }
                
                
            }
        }
        
    }
    
    
    //    //{"index":0,"activeRecord":1,"limit":10,"search":"","expiry_dtf":"","expiry_dtt":"","cltId":"1527","type":"2","audId":"96610","isParent":"0","contrId":"734"}:
    //    //==================================/
    //    // MARK:- Equipement getContractEquipmentList methods
    //    //==================================
    //    func getContractEquipmentList(){
    //
    //        if !isHaveNetowork() {
    //
    //            killLoader()
    //            ShowError(message: AlertMessage.networkIssue, controller: windowController)
    //
    //            return
    //        }
    //
    //        showLoader()
    //
    //        //{"index":0,"activeRecord":1,"limit":10,"search":"","expiry_dtf":"","expiry_dtt":"","cltId":"","type":"2","jobId":"96842","contrId":"734"}:
    //        let param = Params()
    //
    //        param.limit = "10"
    //        param.index = "0"
    //        param.search = ""
    //        param.activeRecord = "1"
    //        param.expiry_dtf = ""
    //        param.expiry_dtt = ""
    //        param.type = "2"
    //        param.audId = objOfUserJobListInDetails?.jobId
    //       // param.isParent = "0"
    //        param.contrId = objOfUserJobListInDetails?.contrId
    //        param.cltId = ""
    //        serverCommunicator(url: Service.getContractEquipmentList, param: param.toDictionary) { (response, success) in
    //
    //            if(success){
    //                let decoder = JSONDecoder()
    //
    //                if let decodedData = try? decoder.decode(ContractEquipmentRes.self, from: response as! Data) {
    //                    if decodedData.success == true{
    //                        killLoader()
    //                        if decodedData.data!.count > 0 {
    //                           self.ContractEquipmentData = decodedData.data as! [ContractEquipment]
    //
    //                            DispatchQueue.main.async {
    //
    //                                if self.ContractEquipmentData.count > 0  {
    //                                    self.img.isHidden = true
    //                                    self.eqpmtNotFound.isHidden = true
    //                                    //   print("jugal 1")
    //                                }else{
    //                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
    //                                    self.img.isHidden = false
    //                                    self.eqpmtNotFound.isHidden = false
    //                                    // print("jugal 0")
    //                                }
    //                                self.tableView.reloadData()
    //                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.LinkEquipmentData.count))"
    //                                //  self.tableView.isHidden = false//
    //
    //                                //  self.lblImg.isHidden = true
    //                                //  self.lblNotFound.isHidden = true
    //
    //                                killLoader()
    //                            }
    //                        }else{
    //                            DispatchQueue.main.async {
    //                                if self.ContractEquipmentData.count > 0  {
    //                                    self.img.isHidden = true
    //                                    self.eqpmtNotFound.isHidden = true
    //                                    //   print("jugal 1")
    //                                }else{
    //                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
    //                                    self.img.isHidden = false
    //                                    self.eqpmtNotFound.isHidden = false
    //                                    // print("jugal 0")
    //                                }
    //                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.ContractEquipmentData.count))"
    //                                self.tableView.reloadData()
    //                                //                                       self.lblNotFound.text = LanguageKey.audit_not_found
    //                                //                                       self.tableView.isHidden = true
    //                                //                                       self.lblImg.isHidden = false
    //                                //                                       self.lblNotFound.isHidden = false
    //                                //                                       self.tableView.reloadData()
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
    //
    //                        }
    //                    })
    //                }
    //            }else{
    //                killLoader()
    //                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
    //                    if cancelButton {
    //                        showLoader()
    //
    //                    }
    //                })
    //            }
    //
    //
    //        }
    //
    //    }
    //
}

