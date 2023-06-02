//
//  NewItem.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 20/10/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class NewItem:  UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
        
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var txtFullAmntPopUp: UITextField!
    @IBOutlet weak var btnPayPopUp: UIButton!
    @IBOutlet weak var lblPayPrtlPopUp: UILabel!
    @IBOutlet weak var lblPayFullPopUp: UILabel!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblCreatDate: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var listItemView: UIView!
    @IBOutlet weak var alertLogo: UILabel!
    @IBOutlet weak var backGroubdView: UIView!
    @IBOutlet weak var deleteCellBtn: UIButton!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var viewDateDtl: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var arryCount: UILabel!
    @IBOutlet weak var deleteCellImg: UIImageView!
    @IBOutlet weak var payPartialAmnt: UITextField!
    @IBOutlet weak var height_HeaderView: NSLayoutConstraint!
    @IBOutlet weak var createdDateLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var compninameLbl: UILabel!
    @IBOutlet weak var adrsLbl: UILabel!
    @IBOutlet weak var H_tablviewBottom: NSLayoutConstraint!
    
    var refreshControl = UIRefreshControl()
    var selectedIndex : Int?
    var isDelete : Bool!
    var invoiceRes =   InvoiceResponse()
    var itemDetailedData = [ItemDic]()
    var itemDetailedDatanew = [DetailedItemData]()
    var selectedRows:[Int] = []
    var objOfUserJobListInDetail : UserJobList!
    var chatConPosition : Int = 0
    //var selectedCell : IndexPath? = nil
    var currency = ""
    var isUpdateItem = true
    var displayMsg = ""
    let loc_listItem = LanguageKey.list_item
    var isDisable = true
    var upDateQnty = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getItemListRecord()
        setData()
        setLocalization()
        
        self.height_HeaderView.constant = 0
      
        //-----------text height scroll method -------------
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 165
        backGroubdView.isHidden = true
        isDisable = compPermissionVisible(permission: compPermission.isItemEnable)
        
        if isDisable == false {
            H_tablviewBottom.constant = 0.0
        }
        
        self.viewDateDtl.layer.cornerRadius = 20
        self.viewDateDtl.layer.shadowColor = UIColor.black.cgColor
        self.viewDateDtl.layer.shadowOpacity = 0.5
        self.viewDateDtl.layer.shadowRadius = 7
        
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        ActivityLog(module:Modules.item.rawValue , message: ActivityMessages.jobProducts)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setData()
    }
    @objc func refreshControllerMethod() {
        getItemListRecord()
        setData()
    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 5 { // set your total tabs here
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
  
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.items_screen_title
        self.btnAddItem.setTitle(LanguageKey.add_new_item, for: .normal)
        self.saveBtn.setTitle(LanguageKey.update, for: .normal)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = LanguageKey.items_screen_title
        
        if isUpdateItem{
            //  getInvoiceRecord()
            isUpdateItem = false
        }
        
        if self.invoiceRes.data != nil && self.invoiceRes.data!.itemData!.count == 0{
            showNoDataAlert()
        }else{
            hideNoDataAlert()
        }
        setData()
    }
    
    func setData(){
        itemDetailedData.removeAll()
        if objOfUserJobListInDetail.itemData != nil {
            for item in (objOfUserJobListInDetail.itemData as! [AnyObject]) {
            
                if let dta = item as? itemData {
                   
                }else{
                    if item["tax"] != nil {
                        let tax = item["tax"] as! [AnyObject]
                        if tax.count > 0 {
                            var arrTac = [texDic]()
                            for taxDic in tax {
                                arrTac.append(texDic(ijtmmId: taxDic["ijtmmId"] as? String, ijmmId: taxDic["ijmmId"] as? String, taxId: taxDic["taxId"] as? String, rate: taxDic["rate"] as? String, label: taxDic["label"] as? String))
                                
                            }
                            let ammount = amounc(qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String,arrTax: arrTac)
                            let dic = ItemDic(ijmmId: item["ijmmId"] as? String, itemId: item["itemId"] as? String, jobId: objOfUserJobListInDetail.jobId , groupId: item["groupId"] as? String, des: item["des"] as? String, inm: item["inm"] as? String, qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String, amount: ammount, tax: arrTac, hsncode: item["hsncode"] as? String, pno: item["pno"] as? String, unit: item["unit"] as? String, taxamnt: item["taxamnt"] as? String, supplierCost: item["supplierCost"] as? String,dataType: item["dataType"] as? String, serialNo: item["serialNo"] as? String,isBillable: item["isBillable"] as? String)
                            
                            itemDetailedData.append(dic)
                        } else {
                            let ammount = amounc(qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String)
                            
                            let dic = ItemDic(ijmmId: item["ijmmId"] as? String, itemId: item["itemId"] as? String, jobId: objOfUserJobListInDetail.jobId , groupId: item["groupId"] as? String, des: item["des"] as? String, inm: item["inm"] as? String, qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String, amount: ammount, tax: [], hsncode: item["hsncode"] as? String, pno: item["pno"] as? String, unit: item["unit"] as? String, taxamnt: item["taxamnt"] as? String, supplierCost: item["supplierCost"] as? String,dataType: item["dataType"] as? String, serialNo: item["serialNo"] as? String ,isBillable: item["isBillable"] as? String)
                            itemDetailedData.append(dic)
                        }
                        
                    }
                }

            }
        
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.arryCount.text = "\(self.loc_listItem) \(self.itemDetailedData.count)"
                if self.itemDetailedData.count == 0{
                    self.showNoDataAlert()
                    self.saveBtn.isHidden = true
                }else{
                    self.saveBtn.isHidden = false
                    self.hideNoDataAlert()
                }
            }
            
        }
    }
    
    //---------------------------- callback ---------------------------------
    
    @IBAction func saveBtnAct(_ sender: Any) {
        self.updateItemQuantity()
        
    }
    
    @IBAction func btnAddNewItemPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Invoice", bundle:nil)
        let addVC = storyBoard.instantiateViewController(withIdentifier: "ListItemVC") as! ListItemVC
        addVC.isAdd = true
        addVC.invoiceRes = invoiceRes
        addVC.jobDetail = objOfUserJobListInDetail
        addVC.isLocId = "0"
        addVC.callbackDetailVC =  {(isUpdate : Bool ) -> Void in
            if isUpdate {
                self.displayMsg = AlertMessage.add
                self.isUpdateItem = false
                self.updateInvoiceOnServer()
            }else{
                self.setData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        self.navigationController?.pushViewController(addVC, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            if let addVC = segue.destination as? ListItemVC {
                addVC.isAdd = true
                addVC.invoiceRes = invoiceRes
                addVC.jobDetail = objOfUserJobListInDetail
                addVC.callbackDetailVC =  {(isUpdate : Bool ) -> Void in
                    
                    if isUpdate {
                        self.displayMsg = AlertMessage.add
                        self.isUpdateItem = false
                        self.updateInvoiceOnServer()
                    }else{
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    // Text Field Delegate ==============
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        payPartialAmnt.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let data = textField.text
        //    print(data)
        //   print(textField.tag)
        itemDetailedData[textField.tag].qty = data
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string != "" && textField.text?.count == 12) {
            
            textField.text = ""
            return false
        }
        
        return true
        
    }
    
    // Table View Delegate ==============
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            
            if let items = self.invoiceRes.data?.shippingItem{
                if items.count > 0 {
                    return 20.0
                }else {
                    return 0.0
                }
            }else{
                return 0.0
            }
        }else{
            return 0.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return self.itemDetailedData.count
            // return self.invoiceRes.data?.itemData! == nil ? 0 :  (self.invoiceRes.data?.itemData?.count)!
        }else{
            return self.invoiceRes.data?.shippingItem! == nil ? 0 :  (self.invoiceRes.data?.shippingItem?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! InvoiceCell
            let aar = self.itemDetailedData[indexPath.row]
            if aar.isBillable == "1"{
                cell.nonBillabalLbl.text = LanguageKey.non_billable
                cell.nonBillabalLbl.isHidden = true
                cell.billabelView.isHidden = true
                
            }else{
                cell.nonBillabalLbl.textColor = .white
                cell.nonBillabalLbl.isHidden = false
                cell.billabelView.isHidden = false
                
            }
            var myrate = aar.rate
            if (myrate?.count)! > 0 {
                myrate = roundOff(value: Double((myrate)!)!)
            }else{
                myrate = roundOff(value:Double("0.00")!)
            }
            
            
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
                }else  {
                    cell.lblName.text = aar.inm?.capitalized
                    cell.discountLbl.text = ""
                }
            }
            
            
            let qtyText = LanguageKey.qty
            cell.quntyTxtFld.text =  aar.qty!
            
            
            cell.amountLbl.text = "\(qtyText)"//
            
            cell.quntyTxtFld.delegate = self
            cell.quntyTxtFld.tag = indexPath.row
            //   cell.discountLbl.text = "ITC " + mydiscount! + " %"
            cell.qtyLbl.text = aar.amount ?? "0.0"
            
            
            
            if isDisable == false {
                cell.btnTap.isHidden = true
                cell.checkMarkBtn.isHidden = true
                cell.X_lblName.constant = 17.0
                cell.X_lblQty.constant = 17.0
            }else{
                if selectedRows.contains(indexPath.row){
                    cell.checkMarkBtn.isSelected = true
                }else{
                    cell.checkMarkBtn.isSelected = false
                }
                cell.btnTap.addTarget(self, action: #selector(buttonTapped( sender: )), for: .touchUpInside)
                cell.btnTap.tag = indexPath.row
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "shipCell",for: indexPath) as! ShippingItemCell
            let shippingItem = self.invoiceRes.data?.shippingItem?[indexPath.row]
            cell.itemName.text = shippingItem?.inm
            
            var myrate = shippingItem!.rate
            if (myrate?.count)! > 0 {
                myrate = roundOff(value: Double((myrate)!)!)
            }else{
                myrate = roundOff(value:Double("0.00")!)
            }
            cell.lblPrice.text = myrate
            
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            return cell
        }
    }
    
    
    //        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //            if indexPath.section == 1 {
    //                return
    //            }
    //
    //
    //            let itemDetailVC = storyboard?.instantiateViewController(withIdentifier: "ListItemVC") as! ListItemVC
    //    //        if (selectedCell != nil) {
    //    //
    //    //            //If selected cell exist on visible indexpaths
    //    //            let isExist = tableView.indexPathsForVisibleRows?.contains(selectedCell!)
    //    //            if isExist!{
    //    //                let cellPrevious = tableView.cellForRow(at: selectedCell!) as! InvoiceCell
    //    //                cellPrevious.view.backgroundColor = .white
    //    //            }
    //    //        }
    //    //
    //    //        let cell = tableView.cellForRow(at: indexPath) as! InvoiceCell
    //    //        cell.view.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    //    //        self.selectedCell = indexPath
    //               itemDetailVC.item = itemDetailedData
    //             itemDetailVC.jobDetail = objOfUserJobListInDetail
    //            // var invoiceRes : InvoiceResponse?
    //            itemDetailVC.selectedIndex = indexPath.row
    //            itemDetailVC.invoiceRes = invoiceRes
    //            itemDetailVC.isAdd = false
    //            itemDetailVC.callbackDetailVC =  {(student : Bool) -> Void in
    //               // showLoader()
    //                self.displayMsg = AlertMessage.updated
    //                self.isUpdateItem = false
    //               // self.updateInvoiceOnServer()
    //            }
    //
    //            self.navigationController?.pushViewController(itemDetailVC, animated: true)
    //        }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isUpdateItem = true
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        popUpView.removeFromSuperview()
        backGroubdView.isHidden = true
    }
    
    @IBAction func payBtnAcction(_ sender: Any) {
        
        backGroubdView.isHidden = false
        view.addSubview(popUpView)
        popUpView.center = CGPoint(x: backGroubdView.frame.width / 2, y: backGroubdView.frame.height / 4.2)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        
        if self.selectedRows.contains(sender.tag){
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: sender.tag)!)
        }else  {
            self.selectedRows.append(sender.tag)
        }
        
        if  selectedRows.count == 0 {
            //   deleteCellImg.image = UIImage(named: "trash")
        } else{
            // deleteCellImg.image = UIImage(named: "trash (2)")
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func deleteCellBtnActn(_ sender: UIButton) {
        
        if self.selectedRows.count == 0 {
            return
        }
        if (self.selectedRows.count == self.itemDetailedData.count){
            
            ShowAlert(title: nil , message: AlertMessage.itemRemoveAllItem, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (_,_) in }
            
            
            return
            
        }
        ShowAlert(title: LanguageKey.confirmation , message: AlertMessage.itemRemove, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: LanguageKey.remove as NSString, style: .alert) { (cancel, remove) in
            if remove {
                
                // var itemIndexPath: [IndexPath] = []
                self.selectedRows = self.selectedRows.sorted(by: >)
                var itemValue: [String] = []
                for index in self.selectedRows{
                    // let indexpth = IndexPath(row:index , section: 0)
                    // itemIndexPath.append(indexpth)
                    // self.itemDetailedData.remove(at: index)
                    
                    let index = self.itemDetailedData[index]
                    let getIjmmId  = index.ijmmId
                    let ladksj  = getIjmmId?.components(separatedBy: "-")
                    if ladksj!.count > 0 {
                        let tempId = ladksj?[0]
                        if tempId == "Item" {
                            let searchQuery1 = String.init(format: "parametres contains[c] '\"ijmmId\":\"%@\'", (getIjmmId ?? ""))
                            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineList", query: searchQuery1) as! [OfflineList]
                            
                            if isExist.count > 0 {
                                DatabaseClass.shared.context.delete(isExist[0])
                            }
                            self.DeletnoysynkItem(itemid: getIjmmId!)
                            
                        } else {
                            itemValue.append(getIjmmId ?? "")
                        }
                    }
                    
                }
                
                
                self.deletetemInviceOffline(itemdata: itemValue)
                
                self.selectedRows.removeAll()
                
                self.displayMsg = AlertMessage.delete
                //self.updateInvoiceOnServer()
            }
        }
    }
    
    
    func CelculateAmount (){
        
        for var item1 in itemDetailedData {
            let tax : Double = 0.0
            
            
            let qty = (item1.qty == "") ? "0" : item1.qty!
            let rate = (item1.rate == "") ? "0.0" : item1.rate!
            let discount = (item1.discount == "") ? "0.0" : item1.discount!
            
            
            let totalAmount = calculateAmount(quantity: Double(qty)!, rate: Double(rate)!, tax: tax, discount: Double(discount)!)
            item1.amount = roundOff(value: totalAmount)
            
            
            let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(Int(qty)!), taxRateInPercentage: tax)
            item1.taxamnt = roundOff(value: taxAmount)
        }
        self.tableView.reloadData()
    }
    
    
    func amounc(qty:String?, rate:String?, discount:String?,arrTax:[texDic]? = nil) -> String{
        var tax : Double = 0.0
        if let itemTex = arrTax {
            for tx in itemTex {
                tax = tax + Double((tx.rate == "") ? roundOff(value:Double("0.00")!) : tx.rate ?? "0.0" )!
            }
        }
        
        
        let qty1 = (qty == "") ? "0" : qty!
        let rate1 = (rate == "") ? "0.0" : rate!
        let discount1 = (discount == "") ? "0.0" : discount!
        
        
        let totalAmount = calculateAmount(quantity: Double(qty1)!, rate: Double(rate1)!, tax: tax, discount: Double(discount1)!)
        return roundOff(value: totalAmount)
        
    }
    
    //    //=================================================//
    //        //MARK:- Delete Item Api Calling
    //    //=================================================//
    func deletetemInviceOffline(itemdata:[String]){
        
        
        
        let  param  = Params()
        
        param.jobId = objOfUserJobListInDetail.jobId
        param.ijmmId = itemdata
        
        
        let dict =  param.toDictionary
        
        let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
        userJobs.apis = Service.deleteItemFromJob
        userJobs.parametres = dict?.toString
        // print(dict)
        userJobs.time = Date()
        
        DatabaseClass.shared.saveEntity(callback: {_ in
            DatabaseClass.shared.syncDatabase()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // your code here
                self.deletedata(itemdata: itemdata)
                
            }
            
            //self.navigationController?.popViewController(animated: true)
        })
        
        
        
        
    }
    
    func deletedata(itemdata:[String]){
        let searchQuery = "jobId = '\(objOfUserJobListInDetail.jobId ?? "")'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            
            if existingJob.itemData != nil {
                let item = (existingJob.itemData as! [AnyObject])
                var arrItem = [Any]()
                
                for itam1 in item {
                    guard let ijmt = itam1["ijmmId"] as? String else { return  }
                    
                    if itemdata.contains(ijmt) {
                        
                    } else {
                        arrItem.append(itam1)
                    }
                    
                }
                existingJob.itemData = arrItem as NSObject
                
            }
            DatabaseClass.shared.saveEntity(callback: {_ in
                
                self.setData()
                
            })
            
        }
        
    }
    
    func DeletnoysynkItem(itemid : String) {
        let searchQuery = "jobId = '\(objOfUserJobListInDetail.jobId ?? "")'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            
            if existingJob.itemData != nil {
                let item = (existingJob.itemData as! [AnyObject])
                var arrItem = [Any]()
                
                for itam1 in item {
                    guard let ijmt = itam1["ijmmId"] as? String else { return  }
                    
                    if itemid == ijmt {
                        
                    } else {
                        arrItem.append(itam1)
                    }
                    
                }
                existingJob.itemData = arrItem as NSObject
                
            }
            DatabaseClass.shared.saveEntity(callback: {_ in
                
                self.setData()
                
            })
            
        }
        
    }
    
    
    //======================================================
    // MARK: Get ItemList Data
    //======================================================
    
    func getItemListRecord() {
        
        if !isHaveNetowork() {
            //ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            setData()
            return
        }
        
        // showLoader()
        let param = Params()
        param.jobId = objOfUserJobListInDetail?.jobId
        // param.invId = ""
        
        serverCommunicator(url: Service.getItemFromJob, param: param.toDictionary) { (response, success) in
            killLoader()
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ItemGetListRes.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        self.replaceJobItemDataID(dict:  decodedData.data!)
                        
                        DispatchQueue.main.async{
                            self.setData()
                            self.arryCount.text = "\(self.loc_listItem) \(self.itemDetailedData.count)"
                            if decodedData.data?.count == 0{
                                self.showNoDataAlert()
                                self.saveBtn.isHidden = true
                            }else{
                                self.saveBtn.isHidden = false
                                self.hideNoDataAlert()
                            }
                            
                        }
                    }else{
                        self.setData()
                        
                    }
                }else{
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    func replaceJobItemDataID( dict :[itemListInfo]) -> Void {
        
        //Replace Contact id in OFFLINE Entity
        
        if (dict.count) > 0 {
            let searchQuery = "jobId = '\(objOfUserJobListInDetail?.jobId ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                
                if existingJob.itemData != nil {
                    
                    var arrItem = [Any]()
                    
                    
                    for item in dict {
                        arrItem.append(item.toDictionary!)
                    }
                    
                    
                    existingJob.itemData = arrItem as NSObject?
                    
                }
                
            }
            
            DatabaseClass.shared.saveEntity(callback: {isSuccess in
                
                self.setData()
                
            })
        }
        
    }
    
    //======================================================
    // MARK: Get Invoice Data
    //======================================================
    func getInvoiceRecord() {
        
        if !isHaveNetowork() {
            //ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            return
        }
        
        // showLoader()
        let param = Params()
        param.jobId = objOfUserJobListInDetail?.jobId
        param.invId = ""
        
        serverCommunicator(url: Service.getInvoiceDetail, param: param.toDictionary) { (response, success) in
            killLoader()
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(InvoiceResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        self.invoiceRes = decodedData
                        taxCalculationType = (self.invoiceRes.data?.taxCalculationType)!
                        
                        if  let data = self.invoiceRes.data {
                            
                            self.replaceJobItemDataID(dict:  self.invoiceRes)
                            self.currency = data.curSym!
                            
                            for item in data.itemData! {
                                var tax : Double = 0.0
                                for tx in item.tax! {
                                    tax = tax + Double((tx.rate == "") ? roundOff(value:Double("0.00")!) : tx.rate!)!
                                }
                                
                                let qty = (item.qty == "") ? "0" : item.qty!
                                let rate = (item.rate == "") ? "0.0" : item.rate!
                                let discount = (item.discount == "") ? "0.0" : item.discount!
                                
                                
                                let totalAmount = calculateAmount(quantity: Double(qty)!, rate: Double(rate)!, tax: tax, discount: Double(discount)!)
                                item.amount = roundOff(value: totalAmount)
                                
                                
                                let taxAmount = calculateTaxAmount(rate: Double(rate)!,qty: Double(Int(qty)!), taxRateInPercentage: tax)
                                item.taxamnt = roundOff(value: taxAmount)
                            }
                            
                            
                            
                            DispatchQueue.main.async{
                                self.arryCount.text = "\(self.loc_listItem) \(self.itemDetailedData.count)"
                                if data.itemData!.count == 0{
                                    self.showNoDataAlert()
                                    self.saveBtn.isHidden = true
                                }else{
                                    self.saveBtn.isHidden = false
                                    self.hideNoDataAlert()
                                }
                                self.tableView.reloadData()
                            }
                        }else{
                            self.showNoDataAlert()
                        }
                    }else{
                        if (decodedData.statusCode != nil) && decodedData.statusCode == "401" {
                            ShowAlert(title:  getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                if (Ok){
                                    DispatchQueue.main.async {
                                        (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                    }
                                }
                            })
                        }else{
                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                        self.showNoDataAlert()
                    }
                }else{
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    func replaceJobItemDataID( dict :InvoiceResponse) -> Void {
        
        //Replace Contact id in OFFLINE Entity
        
        
        let item = dict.data
        if (dict.data?.itemData!.count)! > 0 {
            let searchQuery = "jobId = '\(objOfUserJobListInDetail?.jobId ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                
                if existingJob.itemData != nil {
                    // let item = (existingJob.itemData as! [AnyObject])
                    var arrItem = [Any]()
                    if let itemd = item?.itemData {
                        
                        for item in itemd {
                            arrItem.append(item.toDictionary!)
                        }
                        
                        
                        existingJob.itemData = arrItem as NSObject?
                    }
                }
                
            }
            
            DatabaseClass.shared.saveEntity(callback: {isSuccess in
                
                self.setData()
                
            })
        }
        
    }
    
    func showNoDataAlert() -> Void {
        DispatchQueue.main.async{
            self.topView.isHidden = true
            self.listItemView.isHidden = true
            self.alertMessage.isHidden = false
            self.alertLogo.isHidden = false
            self.alertMessage.text =  AlertMessage.noneitems
        }
    }
    
    func hideNoDataAlert() -> Void {
        DispatchQueue.main.async{
            self.topView.isHidden = false
            self.listItemView.isHidden = false
            self.alertMessage.isHidden = true
            self.alertLogo.isHidden = true
            self.alertMessage.text =  AlertMessage.noneitems
        }
    }
    
    
    func updateInvoiceOnServer() {
        
        showLoader()
        
        var totalAmount : Double = 0.0
        //Response model change for request param for ItemData
        var editedItemData = [itemData] ()
        
        if let itemDatas = invoiceRes.data?.itemData{
            for item in itemDatas {
                let data = itemData()
                data.itemId = item.itemId
                data.jobId = objOfUserJobListInDetail?.jobId
                data.rate = item.rate
                data.qty = item.qty
                data.discount = item.discount
                data.isGroup = "0"
                data.inm = item.inm
                data.des = item.des
                data.type = item.type
                totalAmount = totalAmount + Double(item.amount!)! // make total amount for set totalAmount in request
                var taxDt : [taxData] = []
                for tax in item.tax! {
                    let tx = taxData()
                    tx.taxId = tax.taxId
                    tx.txRate = tax.rate != nil ? tax.rate : tax.txRate
                    taxDt.append(tx)
                }
                data.tax = taxDt /// currently this field is blank
                data.hsncode = item.hsncode
                data.pno = item.pno
                data.taxamnt = item.taxamnt
                data.unit = item.unit
                data.supplierCost = item.supplierCost
                data.jtId = item.jtId
                editedItemData.append(data)
            }
        }
        
        if let newItems = invoiceRes.data?.newItem{
            for item in newItems {
                totalAmount = totalAmount + Double(item.amount!)!
            }
        }
        
        
        if let shippingItem = invoiceRes.data?.shippingItem{
            for item in shippingItem {
                
                let data = newItemData()
                data.itemId = item.itemId
                data.inm = item.inm
                data.qty = "0"
                data.rate = item.rate
                data.supplierCost = "0"
                data.discount = "0"
                data.itype = "2" //2 itype for Shipping items
                data.isItemOrTitle = "1"
                data.taxamnt = "0"
                
                totalAmount = totalAmount + Double(item.rate!)!
                
                if invoiceRes.data?.newItem != nil{
                    invoiceRes.data?.newItem?.append(data)
                }else{
                    invoiceRes.data?.newItem = [newItemData]()
                    invoiceRes.data?.newItem?.append(data)
                }
            }
        }
        
        let  param  = Params()
        param.invId = invoiceRes.data?.invId
        param.jobId = objOfUserJobListInDetail?.jobId
        param.cltId =  invoiceRes.data?.cltId
        param.nm = invoiceRes.data?.nm
        param.pro = invoiceRes.data?.pro
        param.compId = invoiceRes.data?.compId
        param.invType = invoiceRes.data?.invType
        param.adr = invoiceRes.data?.inv_client_address
        param.discount = invoiceRes.data?.discount
        param.total = String(totalAmount)
        param.note = invoiceRes.data?.note
        param.paid = invoiceRes.data?.paid
        param.pono = invoiceRes.data?.pono
        param.invDate = invoiceRes.data?.invDate == "" ? convertSystemDateIntoLocalTimeZoneWithStaticTime(date: Date()) : dateFormateWithoutTime(timeInterval: (invoiceRes.data?.invDate)!)
        param.dueDate = invoiceRes.data?.duedate == "" ? convertSystemDateIntoLocalTimeZoneWithStaticTime(date: Date()) : dateFormateWithoutTime(timeInterval: (invoiceRes.data?.duedate)!)
        param.newItem = invoiceRes.data?.newItem
        param.itemData = editedItemData
        param.groupByData = []
        param.changeState = "0"
        param.cur = invoiceRes.data?.cur // currently by default 0
        param.isShowInList = invoiceRes.data!.isShowInList
        param.shipto = invoiceRes.data!.shipto
        
        
        serverCommunicator(url: Service.updateInvoice, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(InvoiceResponse.self, from: response as! Data) {
                    // print(decodedData)
                    
                    if decodedData.success == true{
                        
                        self.showToast(message: self.displayMsg)
                        
                        self.invoiceRes = decodedData
                        taxCalculationType = (self.invoiceRes.data?.taxCalculationType)!
                        
                        for item in (self.invoiceRes.data?.itemData)! {
                            var tax : Double = 0.0
                            for tx in item.tax! {
                                tax = tax + Double((tx.rate == "") ? roundOff(value:Double("0.00")!) : tx.rate!)!
                            }
                            
                            let qty = (item.qty == "") ? "0" : item.qty!
                            let rate = (item.rate == "") ? "0.0" : item.rate!
                            let discount = (item.discount == "") ? "0.0" : item.discount!
                            
                            let totalAmount = calculateAmount(quantity: Double(qty)!, rate: Double(rate)!, tax: tax, discount: Double(discount)!)
                            item.amount = roundOff(value: totalAmount)
                            
                            //let taxAmount = calculateTaxAmount(amount: totalAmount, taxRateInPercentage: tax)
                            let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: tax)
                            item.taxamnt = roundOff(value: taxAmount)
                            
                        }
                        
                        
                        DispatchQueue.main.async{
                            self.arryCount.text = "\(self.loc_listItem) \(self.itemDetailedData.count)"
                            
                            if self.invoiceRes.data!.itemData!.count == 0{
                                
                                self.saveBtn.isHidden = true
                                self.showNoDataAlert()
                            }else{
                                self.saveBtn.isHidden = false
                                self.hideNoDataAlert()
                            }
                            
                            self.tableView.reloadData()
                        }
                    }else{
                        
                        if (decodedData.statusCode != nil) && decodedData.statusCode == "401" {
                            ShowAlert(title:  getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                if (Ok){
                                    DispatchQueue.main.async {
                                        (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                    }
                                }
                            })
                        }else{
                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }
                }else{
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    
    //=====================================
    // MARK:- Get updateItemQuantity List Service
    //=====================================
    
    
    func updateItemQuantity(){
        
        let  param  = Params()
        
        param.jobId = objOfUserJobListInDetail.jobId
        //param.itemData = "0"
        var item = [itemData]()
        for data in itemDetailedData  {
            let model = itemData()
            model.ijmmId = data.ijmmId
            model.qty =  data.qty
            item.append(model)
        }
        
        param.itemData = item
        serverCommunicator(url: Service.updateItemQuantity, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(UpdateItemQuantity.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        // print("\(decodedData)")
                        
                        DispatchQueue.main.async{
                            self.refreshControl.attributedTitle = NSAttributedString(string: " ")
                            self.refreshControl.addTarget(self, action: #selector(self.refreshControllerMethod), for: UIControl.Event.valueChanged)
                            self.tableView.addSubview(self.refreshControl) // not required when using UITableViewController
                            
                            self.showToast(message:LanguageKey.item_qty_update)
                        }
                        
                    }else{
                        ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
        
    }
    
}
