//
//  LinkClientsEquioment.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 07/04/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class LinkClientsEquioment: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var linkunlinkbtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var msgLbl_H: NSLayoutConstraint!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var eqpmtNotFound: UILabel!
    @IBOutlet weak var lblEqListNo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img: UILabel!
    
    var getValue321 = ""
    var modifiedArray = [String]()
    var appendEquipment = false
    var check = false
    var UnChack = false
    var link_unlinkMsg = ""
    var ContrctBool = false
    var buttonIsSelected = false
    var isLink = ""
    var objOfUserJobListInDetails : UserJobList?
    var LinkEquipmentData = [LinkEquipment]()
    var selectedRows:[Int] = []
    var selectedRows1:[Int] = []
    var arrayCltId = [AuditEquipment]()
    var arrayCltIdForRemove = [AuditEquipment]()
    var buttonSwitched : Bool = false
    var eqIdComp = ""
    var compareId = ""
    var arrayEqId2 =  [String]()
    var arrayEqId = [String]()
    var ContractEquipmentData = [ContractEquipment]()
    var isBarcodeOn = false
    var isMsgBarcode = false
    var jobId:String?
    var aarOfFilterEquipment = [LinkEquipment]()
    var isDataLoading:Bool = false
    var pageNo:Int = 1
    var getValue123 =  ""
    var getValue3211 = ""
    
    //=========================
    // MARK:- Initial methods
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if isMsgBarcode == true{
            SetBackBarButtonCustom()
            LinkEquipmentData.removeAll()
            LinkEquipmentData = aarOfFilterEquipment
            self.msgLbl_H.constant = 0
            self.yesBtn.isHidden = true
            self.img.isHidden = true
            self.eqpmtNotFound.isHidden = true
            tableView.reloadData()
        }
        
        else if objOfUserJobListInDetails?.contrId == "0"{
            self.msgLbl_H.constant = 0
            self.yesBtn.isHidden = true
        }else{
            
            self.messageLbl.text = LanguageKey.client_link_msg
            self.yesBtn.isHidden = false
            self.msgLbl_H.constant = 38
        }
     
        getEquipementListService()
        if isLink == "Own" {
            self.linkunlinkbtn.isHidden = true
            getEquipmentList()
            self.navigationItem.title = LanguageKey.link_equipment
            let buttonWidth = CGFloat(20)
            let buttonHeight = CGFloat(20)
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "barcode.png"), for: .normal)
            button.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        }
        if isLink == "Client" {
            self.linkunlinkbtn.isHidden = true
            getEquipmentListClient()
            self.navigationItem.title = LanguageKey.link_equipment
            let buttonWidth = CGFloat(20)
            let buttonHeight = CGFloat(20)
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "barcode.png"), for: .normal)
            button.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        }
        setLocalization()
    }
    
    //==============================
    //Mark: - Page Nation
    //==============================
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pageNo = 1
    }
    
    func loadMoreItemsForList(){
        self.pageNo += 1
        self.getEquipmentList()
        self.getEquipmentListClient()
        self.getContractEquipmentList()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isDataLoading){
            if !isDataLoading{
                isDataLoading = true
                self.loadMoreItemsForList()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    //==============================
    
    func SetBackBarButtonCustom()
    {
        //Back buttion
        
        let button = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(LinkClientsEquioment.onClcikBack))
        
        self.navigationItem.leftBarButtonItem  = button
    }
    
    @objc func onClcikBack(){
       
            self.dismiss(animated: true, completion: nil)
       
    }
    
    @objc func logoutUser(){
        scanBarcode()
         //print("clicked")
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        if ContrctBool == true {
            ContractEquipmentData.count
        }else{
            
           return LinkEquipmentData.count
        }
           return ContractEquipmentData.count 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quipmentCell",for: indexPath) as! EquipmentCell
        // let equipment = equipments[indexPath.row]
        cell.linkView.backgroundColor = UIColor(red: 226/255, green: 235/255, blue: 236/255, alpha: 1)
        cell.link_Lbl.text = LanguageKey.unlinked
        cell.leftview.isHidden = false
        cell.rightView.isHidden = true
        
        
        
        if ContrctBool == true {
            var coun = ContractEquipmentData.count
            if ContractEquipmentData.count == coun {
                cell.btnDefaults.setTitle("  \(LanguageKey.equipment_btn)" , for: .normal)
                cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
                let modl = LanguageKey.model_no
                let serl = LanguageKey.serial_no
                
                let cond = LanguageKey.condition
                let remark = LanguageKey.remark
                let equipment = ContractEquipmentData[indexPath.row]
              
                if equipment.isPart == "0"{
                    cell.lblName.text = equipment.equnm
                    cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
                }
                else{
                    cell.lblName.text = equipment.equnm
                    cell.lblName.textColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
                }
                
                if  arrayCltId.contains(where: { $0.equId == equipment.equId }) {
                    
                    if check == false && UnChack == false {
                    cell.newCheckImg.image = UIImage(named: "checked24")
                    }
                   
                
                    cell.linkView.backgroundColor = UIColor(red: 36/255.0, green: 147/255.0, blue: 155/255.0, alpha: 1)
                    cell.link_Lbl.text = LanguageKey.linked
                    cell.leftJobLink_H.constant = 0
                    cell.rightJobLink_H.constant = 21
                    cell.rightView.isHidden = false
                    cell.unLinkBtn.addTarget(self, action: #selector(buttonTappedUnLink), for: .touchUpInside)
                    cell.unLinkBtn.tag = indexPath.row
                    cell.linkBtnAct.isHidden = true
                    cell.unLinkBtn.isHidden = false
                    if equipment.status == "4378"{
                        cell.statusLbl.text = "Active"
                    }
                    
                    if equipment.status == "2332"{
                        cell.statusLbl.text = "Deployed"
                    }
                }else{
                    if check == false && UnChack == false {
                    cell.newCheckImg.image = UIImage(named: "unchecked24")
                    }else{
                        if  check == true {
                            cell.checkUnCheckImg.image = UIImage(named: "checked24")
                        } else if UnChack == true {
                            cell.checkUnCheckImg.image = UIImage(named: "unchecked24")
                        }
                    }
                   
      
                    cell.linkView.backgroundColor =  UIColor(red: 226/255, green: 235/255, blue: 236/255, alpha: 1)//.red
                    cell.link_Lbl.text = LanguageKey.unlinked
                    cell.leftview.isHidden = false
                    cell.rightJobLink_H.constant = 0
                    cell.leftJobLink_H.constant = 21
                    cell.linkBtnAct.isHidden = false
                    cell.unLinkBtn.isHidden = true
                    cell.linkBtnAct.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                    cell.linkBtnAct.tag = indexPath.row
                }
                if arrayCltId.count > 0{
//                    for (index, job) in arrayCltId.enumerated() {
//
//
//                        if let match = ContractEquipmentData.first( where: {job.equId == $0.equId} ) {
//
//                            eqIdComp = match.equId!
//                            arrayEqId.append(eqIdComp)
//
//                        }
//                    }
                    
                }else{
                   
                    if check == false && UnChack == false {
                    cell.newCheckImg.image = UIImage(named: "unchecked24")
                    }else{
                        if  check == true {
                            cell.checkUnCheckImg.image = UIImage(named: "checked24")
                        } else if UnChack == true {
                            cell.checkUnCheckImg.image = UIImage(named: "unchecked24")
                        }
                    }
                   
                    cell.unLinkBtn.addTarget(self, action: #selector(buttonTappedUnLink), for: .touchUpInside)
                    cell.unLinkBtn.tag = indexPath.row
                    cell.linkView.backgroundColor = UIColor(red: 35/255.0, green: 86/255.0, blue: 95/255.0, alpha: 1)// .red
                    cell.link_Lbl.text = LanguageKey.unlinked
                    cell.leftview.isHidden = false
                    cell.rightView.isHidden = true
                    cell.linkBtnAct.isHidden = false
                    cell.unLinkBtn.isHidden = true
                }
                selectedRows1.contains(indexPath.row)
               
                cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
                cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
                cell.conditationLbl.text = equipment.adr!
           
            }
            
        } else {
            
            cell.btnDefaults.setTitle("  \(LanguageKey.equipment_btn)" , for: .normal)
            cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
            let modl = LanguageKey.model_no
            let serl = LanguageKey.serial_no
            
            let cond = LanguageKey.condition
            let remark = LanguageKey.remark
            let equipment = LinkEquipmentData[indexPath.row]
        
            if equipment.isPart == "0"{
                cell.lblName.text = equipment.equnm
                cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
            }
            else{
                cell.lblName.text = equipment.equnm
                cell.lblName.textColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
            }
         
            if  arrayCltId.contains(where: { $0.equId == equipment.equId }) {

                if check == false && UnChack == false {
                    self.selectedRows.append(indexPath.row)
                   
                    cell.newCheckImg.image = UIImage(named: "checked24")
                }else{
                    if selectedRows.contains(indexPath.row){
                        
                        cell.newCheckImg.image = UIImage(named: "checked24")
                        
                    }else{
                        cell.newCheckImg.image = UIImage(named: "unchecked24")
                    }
                    
                }
            
                cell.linkView.backgroundColor = UIColor(red: 36/255.0, green: 147/255.0, blue: 155/255.0, alpha: 1)
                cell.link_Lbl.text = LanguageKey.linked
                
                
                cell.leftJobLink_H.constant = 0
                cell.rightJobLink_H.constant = 21
                cell.rightView.isHidden = false
                cell.unLinkBtn.addTarget(self, action: #selector(buttonTappedUnLink), for: .touchUpInside)
                cell.unLinkBtn.tag = indexPath.row
                cell.linkBtnAct.isHidden = true
                cell.unLinkBtn.isHidden = false
                if equipment.status == "4378"{
                    cell.statusLbl.text = "Active"
                }
                
                if equipment.status == "2332"{
                    cell.statusLbl.text = "Deployed"
                }
            }else{
            
                if check == false && UnChack == false {
                    cell.newCheckImg.image = UIImage(named: "unchecked24")
                }else{
                    if selectedRows.contains(indexPath.row){
                        
                        cell.newCheckImg.image = UIImage(named: "checked24")
                        
                    }else{
                        cell.newCheckImg.image = UIImage(named: "unchecked24")
                    }
                    
                }
                
                
//                if check == false && UnChack == false {
//              //  cell.newCheckImg.image = UIImage(named: "unchecked24")
//
//                }else{
//                    if  check == true {
//                        cell.checkUnCheckImg.image = UIImage(named: "checked24")
//                    } else if UnChack == true {
//                        cell.checkUnCheckImg.image = UIImage(named: "unchecked24")
//                    }
//                }
                
                cell.linkView.backgroundColor = UIColor(red: 226/255, green: 235/255, blue: 236/255, alpha: 1)//.red//UIColor(red: 35/255.0, green: 86/255.0, blue: 95/255.0, alpha: 1)//.red
                cell.link_Lbl.text = LanguageKey.unlinked
                cell.leftview.isHidden = false
                cell.rightJobLink_H.constant = 0
                cell.leftJobLink_H.constant = 21
                cell.linkBtnAct.isHidden = false
                cell.unLinkBtn.isHidden = true
                cell.linkBtnAct.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                cell.linkBtnAct.tag = indexPath.row
            }

            
            selectedRows1.contains(indexPath.row)
            
            cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
            cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
            cell.conditationLbl.text = equipment.adr!
            
            
            //var avelabl = ""
            if equipment.status == "4378"{
                cell.statusLbl.text = "Active"
            }
            
            if equipment.status == "2332"{
                cell.statusLbl.text = "Deployed"
            }
            
        }

        cell.tabImgBtn.addTarget(self, action: #selector(Tebimgbtn), for: .touchUpInside)
        cell.tabImgBtn.tag = indexPath.row
        
        return cell
    }

    @objc func Tebimgbtn(_ sender: UIButton) {
        
        if self.selectedRows.contains(sender.tag){
            self.linkunlinkbtn.isHidden = false
            self.check = true
            self.UnChack = true
            self.link_unlinkMsg = "Unlink"
            self.selectedRows1.append(sender.tag)
            for index in self.selectedRows1 {
                getValue321 = LinkEquipmentData[index].equId!
          
            }
            for index in getValue321{
                getValue3211.append(index)
            }
        
            modifiedArray = arrayEqId.filter {!getValue3211.contains($0)}
            arrayEqId = modifiedArray
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: sender.tag)!)
         
        }else{
            self.linkunlinkbtn.isHidden = false
            self.appendEquipment = true
            self.arrayEqId
            self.check = true
            self.UnChack = true
            self.link_unlinkMsg = "link"
            self.selectedRows.append(sender.tag)
            self.selectedRows1.append(sender.tag)
            for index in self.selectedRows1 {
                getValue123 = "\(String(describing: LinkEquipmentData[index].equId ?? ""))"
              
            }
            self.arrayEqId.append(getValue123)// link
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }

        @objc func buttonTapped(_ sender: UIButton) {
        
    }
    
    @objc func buttonTappedUnLink(_ sender: UIButton) {
   // @objc func buttonTappedUnLink(sender: UIButton) {
//        self.link_unlinkMsg = "Unlink"
//        self.UnChack = true
//        self.check = false
//
//
//        let indexPath = IndexPath(row: sender.tag, section: 0)
//        if let cell = self.tableView.cellForRow(at: indexPath) as?  EquipmentCell {
//            cell.checkUnCheckImg.image = UIImage(named: "unchecked24")
//            tableView.reloadRows(at: [indexPath], with: .none)
//           // tableView.reloadData()
//        }
//        //  if self.selectedRows.contains(sender.tag){
//        //selectData.removeAll()a
//        self.selectedRows.append(sender.tag)
//        for index in self.selectedRows {
//            let getValue = LinkEquipmentData[index].equId
//
//            let modifiedArray = arrayEqId.filter { $0 != getValue }
//            arrayEqId = modifiedArray //unlink
//
//        }
//
      //  addAuditEquipment()
        
    }
    
    
    @IBAction func ContrctClientBtn(_ sender: Any) {
        
        buttonIsSelected = !buttonIsSelected
        updateOnOffButton()
        
        
    }
    
    func updateOnOffButton() {
        if buttonIsSelected {
            self.messageLbl.text = LanguageKey.contract_link_msg
            ContrctBool = true
            getContractEquipmentList()
            
        }else{
            ContrctBool = false
            self.messageLbl.text = LanguageKey.client_link_msg
            if isLink == "Own" {
                getEquipmentList()
                self.navigationItem.title = LanguageKey.link_equipment
            }
            if isLink == "Client" {
                getEquipmentListClient()
                self.navigationItem.title = LanguageKey.link_equipment
                
            }
           
        }
    }
    
    @IBAction func linlUnLinkBrnAct(_ sender: Any) {
        
        addAuditEquipment()
    }
    
    @IBAction func addEquipmentBtn(_ sender: Any) {
        
    }
   
    
    //===================================
    // MARK:- Equipement getEquipmentList
    //===================================
    func getEquipmentList(){
        
        if !isHaveNetowork() {
            
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        showLoader()
        
        let param = Params()
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getEquipmentList) as? String
        param.limit = "\(20*pageNo)"
        param.index = "0"
        param.search = ""
        param.activeRecord = "1"
        param.expiry_dtf = ""
        param.expiry_dtt = ""
        param.type = "1"
        param.audId = ""
        param.isParent = "0"
        param.contrId = ""
        param.cltId = ""
        param.siteId = objOfUserJobListInDetails?.siteId
        
        serverCommunicator(url: Service.getEquipmentList, param: param.toDictionary) { (response, success) in
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(LinkEquipmentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data!.count > 0 {
                            self.LinkEquipmentData = decodedData.data as! [LinkEquipment]
                           // killLoader()
                            DispatchQueue.main.async {
                                
                                if self.LinkEquipmentData.count > 0  {
                                    
                                    if self.arrayCltId.count > 0{
                                        
                                        for (index, job) in self.arrayCltId.enumerated() {
                                            
                                            if let match = self.LinkEquipmentData.first( where: {job.equId == $0.equId} ) {
                                                
                                                self.eqIdComp = match.equId!
                                                self.arrayEqId.append(self.eqIdComp)
                                                
                                            }
                                        }
                                    }
                                    
                                    
                                    self.img.isHidden = true
                                    self.eqpmtNotFound.isHidden = true
                                    
                                }else{
                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
                                    //  self.img.isHidden = false
                                    //jugal self.eqpmtNotFound.isHidden = false
                                    
                                }
                                self.tableView.reloadData()
                                
                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.LinkEquipmentData.count))"
                                
                                
                                killLoader()
                            }
                        }else{
                            DispatchQueue.main.async {
                                if self.LinkEquipmentData.count > 0  {
                                    self.img.isHidden = true
                                    self.eqpmtNotFound.isHidden = true
                                   
                                }else{
                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
                                   // self.img.isHidden = false
                                    //jugal   self.eqpmtNotFound.isHidden = false
                                   
                                }
                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.LinkEquipmentData.count))"
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
        
        let param = Params()
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getEquipmentList) as? String
        param.limit = "\(20*pageNo)"
        param.index = "0"
        param.search = ""
        param.activeRecord = "1"
        param.expiry_dtf = ""
        param.expiry_dtt = ""
        param.type = "2"
        param.audId = ""
        param.isParent = "0"
        param.contrId = ""
        param.cltId = objOfUserJobListInDetails?.cltId
        param.siteId = objOfUserJobListInDetails?.siteId
        
        serverCommunicator(url: Service.getEquipmentList, param: param.toDictionary) { (response, success) in
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(LinkEquipmentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data!.count > 0 {
                            self.LinkEquipmentData = decodedData.data as! [LinkEquipment]
                            killLoader()
                            DispatchQueue.main.async {
                                
                                if self.LinkEquipmentData.count > 0  {
                                    self.img.isHidden = true
                                    self.eqpmtNotFound.isHidden = true
                                    //   print("jugal 1")
                                }else{
                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
                                   // self.img.isHidden = false
                                    //jugal  self.eqpmtNotFound.isHidden = false
                                    // print("jugal 0")
                                }
                                self.tableView.reloadData()
                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.LinkEquipmentData.count))"
                                
                                
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
                                   // self.img.isHidden = false
                                    //jugal  self.eqpmtNotFound.isHidden = false
                                    // print("jugal 0")
                                }
                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.LinkEquipmentData.count))"
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
        

        
        let param = Params()
        param.index = "0"
        param.activeRecord = "0"
        param.audId = objOfUserJobListInDetails?.jobId
        param.contrId = "0"
        param.isJob = "1"
        param.isParent = "1"
        
        
        serverCommunicator(url: Service.getAuditEquipmentList, param: param.toDictionary) { (response, success) in
            
         
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(AuditEquipmentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data!.count > 0 {
                            
                            var dd = decodedData.data
                            self.arrayCltId = decodedData.data as! [AuditEquipment]
                            self.arrayCltIdForRemove = decodedData.data as! [AuditEquipment]
                            
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
        
        
        let param = Params()
        var parm = [String: Any]()
     
        parm["equId"] = arrayEqId
        parm["contrId"] = ""
        parm["audId"] = objOfUserJobListInDetails?.jobId
        
        showLoader()

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
                    self.navigationController?.popViewController(animated: true)
                   // self.navigationController?.popToRootViewController(animated: true)
                   
                }
                
            }
        }
        
    }
    
    
    //==================================
    // MARK:- Equipement getContractEquipmentList methods
    //==================================
    func getContractEquipmentList(){
        
        if !isHaveNetowork() {
            
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        showLoader()
        
        
        let param = Params()
        
        param.limit = "\(20*pageNo)"
        param.index = "0"
        param.search = ""
        param.activeRecord = "1"
        param.expiry_dtf = ""
        param.expiry_dtt = ""
        param.type = "2"
        param.audId = objOfUserJobListInDetails?.jobId
        // param.isParent = "0"
        param.contrId = objOfUserJobListInDetails?.contrId
        param.cltId = ""
        serverCommunicator(url: Service.getContractEquipmentList, param: param.toDictionary) { (response, success) in
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(ContractEquipmentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        killLoader()
                        if decodedData.data!.count > 0 {
                            self.ContractEquipmentData = decodedData.data as! [ContractEquipment]
                            
                            if self.arrayCltId.count > 0{
                                for (index, job) in self.arrayCltId.enumerated() {
                                    
                                    
                                    if let match = self.ContractEquipmentData.first( where: {job.equId == $0.equId} ) {
                                       
                                        self.eqIdComp = match.equId!
                                        self.arrayEqId.append(self.eqIdComp)
                                        
                                    }
                                }
                                
                            }
                            
                            DispatchQueue.main.async {
                                
                                if self.ContractEquipmentData.count > 0  {
                                    self.img.isHidden = true
                                    self.eqpmtNotFound.isHidden = true
                                    //   print("jugal 1")
                                }else{
                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
                                   // self.img.isHidden = false
                                    //jugal  self.eqpmtNotFound.isHidden = false
                                    // print("jugal 0")
                                }
                                self.tableView.reloadData()
                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.ContractEquipmentData.count))"
                                
                                
                                killLoader()
                            }
                        }else{
                            DispatchQueue.main.async {
                                if self.ContractEquipmentData.count > 0  {
                                    self.img.isHidden = true
                                    self.eqpmtNotFound.isHidden = true
                                    //   print("jugal 1")
                                }else{
                                    self.eqpmtNotFound.text! = "\(LanguageKey.equipment_not_found)"
                                   // self.img.isHidden = false
                                 //   self.eqpmtNotFound.isHidden = false
                                    // print("jugal 0")
                                }
                                self.lblEqListNo.text! = "\(LanguageKey.equipment) \(String(self.ContractEquipmentData.count))"
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
    
     func scanBarcode() -> Void {
               let viewController = BarcodeScannerViewController()
               viewController.codeDelegate = self
               viewController.errorDelegate = self
               viewController.dismissalDelegate = self
               viewController.isScanBarcodeLinkEquip = true
               viewController.barcode = "1"
               viewController.arrOfEquipment = LinkEquipmentData
               viewController.cltId = objOfUserJobListInDetails?.jobId
               //viewController.auditId = objOfUserJobList?.audId
               present(viewController, animated: true, completion: nil)
           }
    
    func getEquipmentListFromBarcodeScannerOffline(barcodeString : String) -> Void {
        for equip in LinkEquipmentData {
            let getEquip = equip.barcode
            if getEquip == barcodeString {
                LinkEquipmentData.removeAll()
                LinkEquipmentData.append(equip)
                
                tableView.reloadData()
//                func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
//                    controller.dismiss(animated: true, completion: nil)
//                }
                
                
            }
        }
        
    }
    
    func getLinkEquipmentListFromBarcodeScanner(barcodeString : String) -> Void {
               for equip in LinkEquipmentData {
                   let getEquip = equip.barcode
                   if getEquip == barcodeString {
                       LinkEquipmentData.removeAll()
                       LinkEquipmentData.append(equip)
                       
                       tableView.reloadData()
       //                func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
       //                    controller.dismiss(animated: true, completion: nil)
       //                }
                       
                       
                   }
               }
               
           }
    
}

extension LinkClientsEquioment : BarcodeScannerErrorDelegate, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, UITabBarControllerDelegate {
    
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
       // print(code)
        if isLink == "Own" {
            getEquipmentListFromBarcodeScannerOffline(barcodeString: code)
        }else {
            getLinkEquipmentListFromBarcodeScanner(barcodeString: code)
        }
        UserDefaults.standard.set(code, forKey: "barcodeString")
        //        getEquipmentListFromBarcodeScanner(barcodeString: code)
        controller.dismiss(animated: true, completion: {
            controller.reset()
        })
    }
    
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
       // print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}
