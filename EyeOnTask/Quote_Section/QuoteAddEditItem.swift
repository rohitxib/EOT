//
//  QuoteAddItem.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 29/07/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class QuoteAddEditItem: UIViewController, OptionViewDelegate {
    
    @IBOutlet weak var billableBtn: UIButton!
    @IBOutlet weak var notBillablBtn: UIButton!
    @IBOutlet weak var btnSaveTaxView: UIButton!
    @IBOutlet weak var btnCancelTaxView: UIButton!
    @IBOutlet weak var deleteItemBtn: UIButton!
    @IBOutlet weak var editItemBtn: UIButton!
    @IBOutlet weak var txtAmount: FloatLabelTextField!
    @IBOutlet weak var txtDiscount: FloatLabelTextField!
    @IBOutlet weak var txtItem: FloatLabelTextField!
    @IBOutlet weak var txtQlt: FloatLabelTextField!
    @IBOutlet weak var taxTable: UITableView!
    @IBOutlet weak var txtTax: FloatLabelTextField!
    @IBOutlet weak var txtRate: FloatLabelTextField!
    @IBOutlet weak var txtDescription: FloatLabelTextField!
    @IBOutlet weak var txtPartno: FloatLabelTextField!
    @IBOutlet weak var txtHSNcode: FloatLabelTextField!
    @IBOutlet weak var txtUnit: FloatLabelTextField!
    @IBOutlet weak var txtTaxAmount: FloatLabelTextField!
    @IBOutlet weak var txtSupplierPrice: FloatLabelTextField!
    @IBOutlet weak var H_tableView: NSLayoutConstraint!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var scrollvw: UIScrollView!
    @IBOutlet weak var H_segment: NSLayoutConstraint!
    @IBOutlet var taxView: UIView!
    @IBOutlet weak var H_itemText: NSLayoutConstraint!
    @IBOutlet weak var H_textDes: NSLayoutConstraint!
    @IBOutlet weak var H_txtQty: NSLayoutConstraint!
    @IBOutlet weak var H_textRate: NSLayoutConstraint!
    @IBOutlet weak var H_txtDiscount: NSLayoutConstraint!
    @IBOutlet weak var H_txtTax: NSLayoutConstraint!
    @IBOutlet weak var H_txtAmount: NSLayoutConstraint!
    @IBOutlet weak var H_txtPartNo: NSLayoutConstraint!
    @IBOutlet weak var H_HNScode: NSLayoutConstraint!
    @IBOutlet weak var H_Unit: NSLayoutConstraint!
    @IBOutlet weak var H_taxAmount: NSLayoutConstraint!
    @IBOutlet weak var H_supplierPrice: NSLayoutConstraint!
    @IBOutlet weak var backgroundVw: UIView!
    
    var arrOfShowDatainTable = [Any]()
    var arrOfShowData = [UserAccType]()
    var arrOfAccType = [UserAccType]()
    var sltTxtFidOrDroDownIdx : Int?
    var selectedTxtField : UITextField?
    var optionalVw : OptionalView?
    let cellReuseIdentifier = "cell"
    let param = Params()
    var arrOffldWrkData = [FieldWorkerDetails]()
    var filterFieldworkers = [FieldWorkerDetails]()
    var arrOfTitles = [UserJobTittleNm]()
    var filterTitles = [UserJobTittleNm]()
    var jobDetail = UserJobList()
    var items = [itemInfo]()
    var taxes = [taxData]()
    var isNonInventory = false
    var itemID = ""
    var isDisable = true
    let ORIGINAL_HEIGHT : CGFloat = 65.0
    let REMOVE_HEIGHT : CGFloat = 0.0
    var selectData = [Double]()
    var selectedRows:[Int] = []
    var isChecked = false
    var callbackDetailVC: ((Bool) -> Void)?
    var isAdd : Bool!
    var isFilter = false
    var selectedInvType : invoiceType = .ITEM
    var selectedIndex : Int?
    var quoteDetails : QuotationDetailData?
    var taxList = [taxListRes]()
    var count : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          segment.removeSegment(at: 1, animated: false)
        isDisable = compPermissionVisible(permission: compPermission.isItemEnable)
        setLocalization()
        
        self.txtQlt.text =  "1"
        self.txtTax.text =  roundOff(value:Double("0.00")!)
        self.txtRate.text =  roundOff(value:Double("0.00")!)
        self.txtAmount.text =  roundOff(value:Double("0.00")!)
        self.txtDiscount.text =  roundOff(value:Double("0.00")!)
        self.txtSupplierPrice.text =  roundOff(value:Double("0.00")!)
        self.txtTaxAmount.text =  roundOff(value:Double("0.00")!)
        btnSaveTaxView.setTitle(LanguageKey.save_btn, for: .normal)
        btnCancelTaxView.setTitle(LanguageKey.cancel, for: .normal)
        
        if isDisable == false {
            
            let fields = [txtItem,txtPartno,txtDescription,txtQlt,txtRate,txtUnit,txtDiscount,txtTax,txtTaxAmount,txtAmount,txtSupplierPrice]
            
            
            for field in fields {
                makeDisableField(field: field!)
            }
          
            DispatchQueue.main.async {
                self.deleteItemBtn.isHidden = true
                self.editItemBtn.isHidden = true
                
                self.btnSaveTaxView.isUserInteractionEnabled = false
                self.btnSaveTaxView.backgroundColor = UIColor.gray
            }
        }
       
        if selectedIndex != nil {
            let selecteditem = quoteDetails?.invData?.itemData![selectedIndex!]
            itemID = selecteditem!.itemId!
            
            
            if isAdd == false{
                
                title = (isDisable ==  false) ? LanguageKey.view_details : LanguageKey.update_item
                
                switch selecteditem!.type {
                case invoiceType.ITEM.rawValue.description:
                    txtItem.placeholder = "\(LanguageKey.items_name)*"
                    selectedInvType = .ITEM
                    break
                case  invoiceType.FIELDWORKER.rawValue.description:
                    txtItem.placeholder = "\(LanguageKey.fieldworkers_name)*"
                    selectedInvType = .FIELDWORKER
                    disableFieldsForFieldworker()
                    break
                case invoiceType.SERVICE.rawValue.description:
                    txtItem.placeholder = "\(LanguageKey.services_name)*"
                    selectedInvType = .SERVICE
                    disableFieldsForService()
                    break
                case .some(_):
                    txtItem.placeholder = "\(LanguageKey.items_name)*"
                    selectedInvType = .ITEM
                    disableFieldsForItem()
                    break
                case .none:
                    txtItem.placeholder = "\(LanguageKey.items_name)*"
                    selectedInvType = .ITEM
                    disableFieldsForItem()
                    break
                }
            }else{
                
            }
            
            txtItem.text = selecteditem!.inm
            txtItem.isUserInteractionEnabled = false
            txtItem.textColor = UIColor.lightGray
            
            txtDiscount.text = getValueFromString(value: selecteditem?.discount)
            txtQlt.text = selecteditem!.qty
            txtRate.text = getValueFromString(value: selecteditem?.rate)
            txtDescription.text = selecteditem!.des
            txtHSNcode.text = selecteditem?.hsncode ?? ""
            txtUnit.text = selecteditem!.unit ?? ""
            txtTaxAmount.text =  getValueFromString(value: selecteditem?.taxamnt)
            txtPartno.text = selecteditem!.pno ?? ""
            txtSupplierPrice.text = getValueFromString(value: selecteditem?.supplierCost)
            
            
            var tax : Double = Double(roundOff(value: 0.0))!
            for tx in selecteditem!.tax! {
                tax = tax + Double(getValueFromString(value: tx.rate))!
            }
            
            txtTax.text =  getValueFromString(value: String(tax))
            txtAmount.text =  getValueFromString(value: selecteditem?.amount)
        }
        
        
        if isAdd == false {
            segment.isHidden = true
            H_segment.constant = 0.0
            deleteItemBtn.isHidden = false
            editItemBtn.setTitle(LanguageKey.update_btn , for: .normal)
        }
        
        // if !isAdd{
        comPermissionIshide() // For show/Hide fields
        // }
        
        
        txtRate.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       // txtQlt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtDiscount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        getTaxList()
        getFwList()
        getTitleList()
        
         H_HNScode.constant = 0.0 // this field is hide by default, we can open this when we need this field
    }
    
    
    func makeDisableField(field : FloatLabelTextField) -> Void {
        DispatchQueue.main.async {
            field.isUserInteractionEnabled = false
            field.textColor = UIColor.lightGray
        }
    }
    
    
    func setLocalization() -> Void {
        self.navigationItem.title = (isDisable ==  false) ? LanguageKey.view_details : LanguageKey.addItem_screen_title
        segment.setTitle(LanguageKey.items_name, forSegmentAt: 0)
       // segment.setTitle(LanguageKey.fieldworker, forSegmentAt: 1)
        segment.setTitle(LanguageKey.services_name, forSegmentAt: 1)
        txtItem.placeholder = "\(LanguageKey.items_name)*"
        txtPartno.placeholder = LanguageKey.part_no
        txtDescription.placeholder = LanguageKey.description
        txtQlt.placeholder = LanguageKey.quantity
        txtRate.placeholder = LanguageKey.rate
        txtUnit.placeholder = LanguageKey.unit
        txtDiscount.placeholder = LanguageKey.discount
        txtTax.placeholder = LanguageKey.tax
        txtTaxAmount.placeholder = LanguageKey.tax_amount
        txtAmount.placeholder = LanguageKey.total_amount
        txtSupplierPrice.placeholder = LanguageKey.supplier_cost
        editItemBtn.setTitle(LanguageKey.save_btn, for: .normal)
        deleteItemBtn.setTitle(LanguageKey.Item_delete_button, for: .normal)
    }
    
    
    
    
    //============================
    //MARK:- ComPermissionIsHide
    //============================
    
    func comPermissionIshide() {
        checkPermission(permission: compPermission.description, layout: H_textDes)
        checkPermission(permission: compPermission.discount, layout: H_txtDiscount)
        checkPermission(permission: compPermission.rate, layout: H_textRate)
        checkPermission(permission: compPermission.tax, layout: H_txtTax)
        checkPermission(permission: compPermission.amount, layout: H_txtAmount)
        //checkPermission(permission: compPermission.hsncode, layout: H_HNScode)
        checkPermission(permission: compPermission.unit, layout: H_Unit)
        checkPermission(permission: compPermission.taxamnt, layout: H_taxAmount)
        checkPermission(permission: compPermission.pno, layout: H_txtPartNo)
        checkPermission(permission: compPermission.supplierCost, layout: H_supplierPrice)
    }
    
    
    func disableFieldsForFieldworker() -> Void {
        //1. supplier cost ,HSN Code, part no, unit for fieldworker
        H_supplierPrice.constant = REMOVE_HEIGHT
        //H_HNScode.constant = REMOVE_HEIGHT
        H_txtPartNo.constant = REMOVE_HEIGHT
        H_Unit.constant = REMOVE_HEIGHT
        H_txtDiscount.constant = compPermissionVisible(permission: compPermission.discount) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
    }
    
    func disableFieldsForService() -> Void {
        // 2. supplier cost and discount for Service
        H_supplierPrice.constant = REMOVE_HEIGHT
        H_txtDiscount.constant = REMOVE_HEIGHT
       // H_HNScode.constant = compPermissionVisible(permission: compPermission.hsncode) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_txtPartNo.constant = compPermissionVisible(permission: compPermission.pno) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_Unit.constant = compPermissionVisible(permission: compPermission.unit) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
    }
    
    func disableFieldsForItem() -> Void {
        // 2. supplier cost and discount for Service
        H_supplierPrice.constant = compPermissionVisible(permission: compPermission.supplierCost) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_txtDiscount.constant = compPermissionVisible(permission: compPermission.discount) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        //H_HNScode.constant = compPermissionVisible(permission: compPermission.hsncode) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_txtPartNo.constant = compPermissionVisible(permission: compPermission.pno) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_Unit.constant = compPermissionVisible(permission: compPermission.unit) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
    }
    
    
    func checkPermission(permission : compPermission, layout : NSLayoutConstraint ) -> Void {
        let isShow = compPermissionVisible(permission: permission)
        if isShow == false {
            layout.constant = REMOVE_HEIGHT
        }
    }
    
    
    
    func getTaxList() -> Void {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            return
        }
        
        
        let param = Params()
        param.limit = "120"
        param.index = "0"
        param.search = ""
        param.compId = getUserDetails()?.compId
        
        serverCommunicator(url: Service.getTaxList, param: param.toDictionary) { (response, success) in
            
            self.removeOptionalView()
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(taxResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        self.taxList = (decodedData.data?.filter({ (tax) -> Bool in
                            if tax.show_Invoice == "1" && tax.isactive == "1" {
                                return true
                            }else{
                                return false
                            }
                        }))!
                        

                        self.selectedRows.removeAll()
                        if self.selectedIndex != nil{
                            let selecteditem = self.quoteDetails?.invData?.itemData![self.selectedIndex!]
                            
                            if self.taxList.count > 0 {
                                for index in 0...self.taxList.count-1 {
                                    
                                    // print(index)
                                    let object = self.taxList[index]
                                    //print(object.taxId)
                                    object.percentage = (object.percentage ?? "0.0")
                                    //let data = selecteditem.tax?.contains(where: {$0.taxId == object.taxId})
                                    let data = selecteditem?.tax?.filter{$0.taxId == object.taxId}
                                    //print(data?.count)
                                    DispatchQueue.main.async {
                                        if self.txtTax.text == "0.00" {
                                            self.selectedRows.removeAll()
                                        }else
                                        { if (data?.count)! > 0 {
                                            self.selectedRows.append(index)
                                            // isChecked = true
                                            }
                                            
                                        }
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                        
                        
                        for tax in self.taxList {
                            //Create taxDetail model for send on server
                            let taxdetail = taxData() // for get model of tax
                            taxdetail.taxId = tax.taxId
                            taxdetail.rate = getValueFromString(value: String(tax.value ?? 0.0))
                            self.taxes.append(taxdetail)
                        }
                        DispatchQueue.main.async {
                            self.taxTable.reloadData()
                        }
                        
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    self.removeOptionalView()
                }
            }else{
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                    }
                })
            }
        }
    }
    
    func filterFieldWorker(searchText:String) -> Void {
        self.removeOptionalView()
        let bPredicate: NSPredicate = NSPredicate(format: "self.fnm beginswith[c] '\(searchText)'")
        filterFieldworkers =  (arrOffldWrkData as NSArray).filtered(using: bPredicate) as! [FieldWorkerDetails]
        if(self.filterFieldworkers.count > 0){
            DispatchQueue.main.async {
                self.openDwopDown(txtField: self.txtItem, arr: self.filterFieldworkers)
            }
        }else{
            self.removeOptionalView()
        }
    }
    
    func filterTitles(searchText:String) -> Void {
        self.removeOptionalView()
        let bPredicate: NSPredicate = NSPredicate(format: "self.title beginswith[c] '\(searchText)'")
        filterTitles =  (arrOfTitles as NSArray).filtered(using: bPredicate) as! [UserJobTittleNm]
        if(self.filterTitles.count > 0){
            DispatchQueue.main.async {
                self.openDwopDown(txtField: self.txtItem, arr: self.filterTitles)
            }
        }else{
            self.removeOptionalView()
        }
    }
    
    
    
    func getItems(txtSearch : String) -> Void {
        
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            return
        }
        
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.type = "0"
        param.limit = "120"
        param.index = "\(count)"
        param.search = txtSearch
        param.activeRecord = "0"
        param.showInvoice = "0"
        
        serverCommunicator(url: Service.getItemsList, param: param.toDictionary) { (response, success) in
            
            self.removeOptionalView()
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ItemModel.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        DispatchQueue.main.async{
                            self.items.removeAll()
                            if decodedData.data?.count != 0 {
                                self.count += (decodedData.data?.count)!
                                self.items = decodedData.data!
                            }
                            
                            self.openDwopDown(txtField: self.txtItem, arr: self.items)
                            
                        }
                    }
                }else{
                    self.removeOptionalView()
                }
            }
        }
    }
    
    
    func getFwList() -> Void {
         let fieldworkersList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
        
        if (quoteDetails?.invData?.itemData?.count)! > 0 {
            let fieldworkers = quoteDetails?.invData?.itemData!.filter { (item) -> Bool in
                if item.type == "2" {
                    return true
                }else{
                    return false
                }
            }
            
            for fieldworker in fieldworkersList {
                let fnm = fieldworker.fnm ?? ""
                let lnm = fieldworker.lnm ?? ""
                let fullname = "\(fnm) \(lnm)"
                
                let isExist = fieldworkers!.contains{($0.inm == fullname)}
                if !isExist {
                    self.arrOffldWrkData.append(fieldworker)
                }
            }
        }else{
            self.arrOffldWrkData = fieldworkersList
        }
    }
    
    func getTitleList() -> Void {
        let servicesList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
        
        if (quoteDetails?.invData?.itemData?.count)! > 0 {
            let titles = quoteDetails?.invData?.itemData!.filter { (item) -> Bool in
                if item.type == "3" {
                    return true
                }else{
                    return false
                }
            }
            
            for title in servicesList {
                let existJtid = title.jtId
                let isExist = titles!.contains{($0.jtId == existJtid)}
                if !isExist {
                    self.arrOfTitles.append(title)
                }
            }
        }else{
            self.arrOfTitles = servicesList
        }
    }
    
    
    
    @IBAction func btnSegmentControl(segControl: UISegmentedControl) {
        
        txtItem.resignFirstResponder()
        self.txtItem.text = ""
        self.txtQlt.text =  "1"
        self.txtTax.text =  roundOff(value:Double("0.00")!)
        self.txtRate.text =  roundOff(value:Double("0.00")!)
        self.txtTaxAmount.text =  roundOff(value:Double("0.00")!)
        self.txtAmount.text =  roundOff(value:Double("0.00")!)
        self.txtDiscount.text =  roundOff(value:Double("0.00")!)
        self.txtSupplierPrice.text =  roundOff(value:Double("0.00")!)
        self.txtDescription.text =  ""
        //self.txtUnit.text = "0"
        self.txtPartno.text = ""
        self.txtHSNcode.text = ""
        self.txtTaxAmount.text = roundOff(value:Double("0.00")!)
        
        
        switch segControl.selectedSegmentIndex {
        case 0:
            selectedInvType = .ITEM
            txtItem.placeholder = "\(LanguageKey.items_name)*"
            disableFieldsForItem()
            break
            
//        case 1:
//            selectedInvType = .FIELDWORKER
//            txtItem.placeholder = "\(LanguageKey.fieldworkers_name)*"
//            disableFieldsForFieldworker()
//            break
            
        default:
            selectedInvType = .SERVICE
            txtItem.placeholder = "\(LanguageKey.services_name)*"
            disableFieldsForService()
            break
        }
        
    }
    
    
    
    @IBAction func taxButtonTapped(_ sender: Any) {
        
        if selectedTxtField != nil {
            selectedTxtField?.resignFirstResponder()
        }
        if  (self.taxList.count) > 0 {
            backgroundVw.isHidden = false
            
            var height:CGFloat = 0.0
            if (self.taxList.count) > 5 {
                height = 350
            }
            else{
                height = CGFloat((self.taxList.count))*60 + 56
            }
            
            var taxVw = taxView.frame
            taxVw.origin.x = backgroundVw.bounds.size.width/2 - taxView.bounds.size.width/2
            taxVw.origin.y = backgroundVw.bounds.size.height/2 - height/2 - 50
            taxVw.size.height = height
            taxView.frame = taxVw
            backgroundVw.addSubview(taxView)
            
            taxView.isHidden = false
        }
    }
    
    @IBAction func btnCancelTax(_ sender: Any) {
        if selectedTxtField != nil {
            selectedTxtField?.resignFirstResponder()
        }
        
        DispatchQueue.main.async {
            for tax in self.taxes {
                let data = self.taxList.filter{$0.taxId == tax.taxId}
                if (data.count) > 0 {
                    data[0].value = Double(getValueFromString(value: tax.rate))
                }
            }
            
            self.taxTable.reloadData()
        }
        backgroundVw.isHidden = true
        taxView.isHidden = true
    }
    
    @IBAction func taxSaveButton(_ sender: Any) {
        
        if selectedTxtField != nil {
            selectedTxtField!.resignFirstResponder()
        }
        
        taxes.removeAll()
        
        var total_tax : Double = 0 // For get total tax
        
        for tax in self.taxList {
            //Create taxDetail model for send on server
            let taxdetail = taxData() // for get model of tax
            taxdetail.taxId = tax.taxId
            taxdetail.rate = getValueFromString(value: String(tax.value ?? 0.0))
            taxes.append(taxdetail)
            
            total_tax = total_tax + ((tax.value == nil) ? 0.00 :  tax.value!)
            
        }
        
        
        
        txtTax.text = String(total_tax)
        
        backgroundVw.isHidden = true
        taxView.isHidden = true
        self.setCalculationForFinalAmount()
        self.taxTable.reloadData()
    }
    
    
    @IBAction func donBtnActn(_ sender: Any) {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            return
        }
        
        if selectedTxtField != nil {
            selectedTxtField!.resignFirstResponder()
        }
        
        if itemID == "" {
            if (selectedInvType == .SERVICE) {
                ShowError(message: AlertMessage.service_error, controller: windowController)
                return
            }
            
            if (selectedInvType == .FIELDWORKER){
                ShowError(message: AlertMessage.fieldworker, controller: windowController)
                return
            }
        }

        if txtQlt.text == "0" {
            ShowError(message: AlertMessage.atleastOneQuantity, controller: windowController)
            return
        }
        
        let trimmedString = trimString(string: txtItem.text!)
        if trimmedString.count > 0 {
                let item = QuoteItem()
                item.iqmmId = (selectedIndex != nil) ? quoteDetails?.invData?.itemData![selectedIndex!].iqmmId : ""
                item.quotId = quoteDetails?.quotId
                item.itemId =  itemID
                item.inm = trimmedString
                item.invId = quoteDetails?.invData?.invId
                item.type = selectedInvType.rawValue.description
                item.rate = getValueFromString(value: txtRate.text)
                item.qty = txtQlt.text == "" ? "1" : txtQlt.text
                item.discount = getValueFromString(value: txtDiscount.text)
                item.des = trimString(string: txtDescription.text!)
                item.pno = trimString(string: txtPartno.text!)
                item.unit = trimString(string: txtUnit.text!)
                item.taxamnt = getValueFromString(value:txtTaxAmount.text)
                item.supplierCost = getValueFromString(value: txtSupplierPrice.text)
                item.totalAmount = getValueFromString(value:txtAmount.text)
                item.isInvOrNoninv = (selectedInvType == .SERVICE) ? "2" : isNonInventory ? "2" : "1"
                item.taxData = taxes
                item.jtId = (selectedInvType == .SERVICE) ? itemID : ""
            print(item)
                addUpdateItemInInvoice(quoteItem: item)
        }else{
            var message = ""
            switch selectedInvType {
            case .ITEM :
                message = AlertMessage.item
                break
                
            case .FIELDWORKER :
                message = AlertMessage.fieldworker
                break
                
            case .SERVICE :
                message = AlertMessage.service_error
                break
            }
            
            ShowError(message: message, controller: windowController)
        }
    }
    

    
    @IBAction func deleteItemActn(_ sender: Any) {
        
        ShowAlert(title: LanguageKey.confirmation , message: AlertMessage.itemRemove, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.remove as NSString, style: .alert) { (cancel, remove) in
            if remove {
                if self.callbackDetailVC != nil {
                    self.callbackDetailVC!(true)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
    //=====================================
    // MARK:- Optional view Detegate
    //=====================================
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch selectedInvType{
        case .ITEM:
            return items.count
            
        case .FIELDWORKER:
            return (isFilter ? filterFieldworkers.count : arrOffldWrkData.count)
            
        case .SERVICE:
            return (isFilter ? filterTitles.count : arrOfTitles.count)
        }
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        cell?.textLabel?.textColor = UIColor.darkGray
        
        
        
        switch selectedInvType{
        case .ITEM:
            if let itemname = items[indexPath.row].inm {
                cell?.textLabel?.text = itemname
            }else{
                cell?.textLabel?.text = "Unknown item"
            }
            break
            
        case .FIELDWORKER:
            let fieldwrkr = isFilter ? filterFieldworkers[indexPath.row] : arrOffldWrkData[indexPath.row]
            cell?.textLabel?.text = (fieldwrkr.fnm ?? "") +  ((fieldwrkr.lnm != "") ? " \(fieldwrkr.lnm ?? "")" : "")
            break
            
        case .SERVICE:
            let title = isFilter ? filterTitles[indexPath.row] : arrOfTitles[indexPath.row]
            cell?.textLabel?.text = title.title
            break
        }
        
        
        return cell!
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isNonInventory = false
        
        switch selectedInvType {
            
            //==========================
            // If Item selected
        //==========================
        case .ITEM:
            
            if let itemname = items[indexPath.row].inm {
                txtItem.text = itemname
            }else{
                txtItem.text = "Unknown item"
            }
            
            
            
            let item = items[indexPath.row]
            let rate = getValueFromString(value: item.rate)
            let discount = getValueFromString(value: item.discount)
            let supplierCost = getValueFromString(value: item.supplierCost)
            let qty = (txtQlt.text == "") ? "0.0" : txtQlt.text!
            
            itemID = item.itemId!
            txtItem.text = item.inm ?? ""
            txtQlt.text =  "1"  //item.qty != "" ? ((Int(item.qty!)! > 0) ? item.qty : "1")   : "1"
            txtTax.text =  roundOff(value:Double("0.00")!)
            txtRate.text =  rate
            txtAmount.text =  roundOff(value:Double("0.00")!)
            txtDiscount.text = discount
            txtDescription.text = item.ides ?? ""
            txtPartno.text = item.pno ?? ""
            txtUnit.text = item.unit ?? ""
            txtHSNcode.text = item.hsncode ?? ""
            txtSupplierPrice.text = supplierCost
            
            
            self.taxes = []
            if let itemDatas = item.tax  {
                for tax in self.taxList {
                    let data = itemDatas.filter{$0.taxId == tax.taxId}
                    if (data.count) > 0 {
                        tax.value =  Double(getValueFromString(value: data[0].rate!))
                    }else{
                        tax.value = Double(roundOff(value: 0.0))
                    }
                }
            }
            
            var totalTax : Double = Double(roundOff(value: 0.0))!
            for tax in self.taxList {
                //Create taxDetail model for send on server
                let taxdetail = taxData() // for get model of tax
                taxdetail.taxId = tax.taxId
                taxdetail.rate = getValueFromString(value: String(tax.value ?? 0.0))
                totalTax = totalTax + (tax.value ?? 0.0)
                self.taxes.append(taxdetail)
            }
            DispatchQueue.main.async {
                self.taxTable.reloadData()
            }
            
            txtTax.text = roundOff(value: totalTax)
            
            let totalAmount =  calculateAmount(quantity: 1.0, rate: Double(rate)!, tax: Double(totalTax), discount: Double(discount)!)
            txtAmount.text =  roundOff(value: totalAmount)
            
            // let taxAmount = calculateTaxAmount(amount: totalAmount, taxRateInPercentage: totalTax)
            let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: Double(totalTax))
            txtTaxAmount.text = roundOff(value: taxAmount)
            break
            
            
            //==========================
            // If Fieldworker selected
        //==========================
        case .FIELDWORKER:
            DispatchQueue.main.async {
                let fieldwrkr = self.isFilter ? self.filterFieldworkers[indexPath.row] : self.arrOffldWrkData[indexPath.row]
                self.itemID = fieldwrkr.usrId!
                self.txtItem.text = (fieldwrkr.fnm ?? "") +  (fieldwrkr.lnm ?? "")
                self.txtQlt.text =  "1"
                self.txtTax.text =  roundOff(value:Double("0.00")!)
                self.txtRate.text =  roundOff(value:Double("0.00")!)
                self.txtAmount.text =  roundOff(value:Double("0.00")!)
                self.txtDiscount.text =  roundOff(value:Double("0.00")!)
                self.txtTaxAmount.text =  roundOff(value:Double("0.00")!)
                self.txtSupplierPrice.text =  roundOff(value:Double("0.00")!)
                self.txtDescription.text =  ""
            }
            break
            
            
            //==========================
            // If Service selected
        //==========================
        case .SERVICE:
            DispatchQueue.main.async {
                let title = self.isFilter ? self.filterTitles[indexPath.row] : self.arrOfTitles[indexPath.row]
                self.itemID = title.jtId ?? ""
                self.txtItem.text = title.title
                self.txtQlt.text =  "1"
                self.txtTax.text =  roundOff(value:Double("0.00")!)
                
                let rate = getValueFromString(value: title.labour)
                let discount = roundOff(value:Double("0.00")!)
                
                self.txtRate.text = rate
                self.txtAmount.text =  roundOff(value:Double("0.00")!)
                self.txtDiscount.text =  discount
                self.txtTaxAmount.text =  roundOff(value:Double("0.00")!)
                self.txtSupplierPrice.text =  roundOff(value:Double("0.00")!)
                self.txtDescription.text =  ""
                
                
                self.taxes = []
                if let taxDatas = title.taxData  {
                    for tax in self.taxList {
                        let data = (taxDatas as! [[String:String]]).filter{$0["taxId"] == tax.taxId}
                        if (data.count) > 0 {
                            tax.value =  Double(getValueFromString(value: data[0]["rate"]))
                        }else{
                            tax.value = Double(roundOff(value: 0.0))
                        }
                    }
                }
                
                var totalTax : Double = Double(roundOff(value: 0.0))!
                for tax in self.taxList {
                    //Create taxDetail model for send on server
                    let taxdetail = taxData() // for get model of tax
                    taxdetail.taxId = tax.taxId
                    taxdetail.rate = getValueFromString(value: String(tax.value ?? 0.0))
                    totalTax = totalTax + (tax.value ?? 0.0)
                    self.taxes.append(taxdetail)
                }
                DispatchQueue.main.async {
                    self.taxTable.reloadData()
                }
                
                self.txtTax.text = roundOff(value: totalTax)
                
                
                let totalAmount =  calculateAmount(quantity: 1.0, rate: Double(rate)!, tax: Double(totalTax), discount: Double(discount)!)
                self.txtAmount.text =  roundOff(value: totalAmount)
                
                let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double("1")!, taxRateInPercentage: Double(self.txtTax.text ?? "0.0")!)
                self.txtTaxAmount.text = roundOff(value: taxAmount)
                
            }
            break
        }
        
        self.removeOptionalView()
    }
    
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
    
    //==========================
    //MARK:- Open OptionalView
    //==========================
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView
            self.optionalVw?.delegate = self
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                self.removeOptionalView()
            }
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
            self.view.addSubview( self.optionalVw!)
        }
        
    }
    
    func removeOptionalView(){
        if optionalVw != nil {
            DispatchQueue.main.async {
                self.optionalVw?.removeFromSuperview()
                self.optionalVw = nil
            }
        }
    }
    
}


extension QuoteAddEditItem : UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taxList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taxCell") as! TaxCell
        
        
        
        let tax = self.taxList[indexPath.row]
        cell.txtFieldPersentShowQute.text = "\(tax.label ?? "") " + "\(tax.percentage ?? "0.0")%"//"(\(getValueFromString(value:(tax.percentage ?? "0.0")))%)"
//        cell.txtField.placeholder = tax.label
//        cell.txtField.text = getValueFromString(value: String(tax.value ?? 0.0))
//        cell.txtField.delegate = self
//        cell.txtField.tag = indexPath.row + 1
        if isChecked != false {
                                   if selectedRows.contains(indexPath.row){
                           
                                                   cell.imgBtnQute.isSelected = false
                           
                                           }else{
                                                   cell.imgBtnQute.isSelected = true
                                   }
                       }else{
                           if selectedRows.contains(indexPath.row){
                           
                                                   cell.imgBtnQute.isSelected = true
                           
                                           }else{
                                                   cell.imgBtnQute.isSelected = false
                                   }
                       }
        
        cell.tapBtnQute.addTarget(self, action: #selector(buttonTapped( sender: )), for: .touchUpInside)
                           cell.tapBtnQute.tag = indexPath.row
        
        if isDisable == false {
            cell.txtField.isUserInteractionEnabled = false
            cell.txtField.textColor = UIColor.lightGray
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        var isCalculate = true
        
        if textField.tag > 0 {
            isCalculate = false
            let tax = self.taxList[textField.tag-1]
            
            if  (textField.text?.count)! > 0 {
                tax.value = Double(textField.text!)!
            }else{
                tax.value = Double(roundOff(value: 0.0))
                textField.text = roundOff(value:Double("0.00")!)
            }
        }
        
        if isCalculate {
            setCalculationForFinalAmount()
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
          taxes.removeAll()
         selectedRows.removeAll()
         selectData.removeAll()
        
        
                   if self.selectedRows.contains(sender.tag){
                    //selectData.removeAll()
                       self.selectedRows.remove(at: self.selectedRows.firstIndex(of: sender.tag)!)
                    
                              
                              
                          var total_tax:Double = 0
                     selectData.removeAll()
                         for index in self.selectedRows {
                         let getValue = taxList[index].percentage
                             var percent = (Double(getValue ?? "0.0"))
                             let getTaxId = taxList[index].taxId
                             let taxdetail = taxData() // for get model of tax
                             taxdetail.taxId = getTaxId
                             taxdetail.rate = getValueFromString(value:getValue ?? "0.0")
                             taxes.append(taxdetail)
                             selectData.append(percent ?? 0.0)
                             
                            
                     }
                     
                   
                     
                     
                     for i in selectData{
                             total_tax = total_tax + (i)
                            // print(total_Value)
                                       }
                     self.txtTax.text = String(total_tax)
                   
                           self.setCalculationForFinalAmount()
                           self.taxTable.reloadData()

                              
                   }else  {
                    //selectData.removeAll()
                       self.selectedRows.append(sender.tag)

                     var total_tax:Double = 0
                    selectData.removeAll()
                  for index in self.selectedRows {
                         let getValue = taxList[index].percentage
                         let getTaxId = taxList[index].taxId
                        var percent = (Double(getValue ?? "0.0"))
                             
                             let taxdetail = taxData() // for get model of tax
                             taxdetail.taxId = getTaxId
                             taxdetail.rate = getValueFromString(value: String(getValue ?? "0.0" ))
                             taxes.append(taxdetail)
                            selectData.append(percent ?? 0.0)
                               
                     }
                         
                                          for i in selectData {
                                          total_tax = total_tax + (i)
                                          print(total_tax)
                                          }
                     
                     self.txtTax.text = String(total_tax)
             
                           self.setCalculationForFinalAmount()
                           self.taxTable.reloadData()

                   }

                   DispatchQueue.main.async{
                       self.taxTable.reloadData()
                   }
    
      }
    
    
    func calculationFunction() -> Void {
        let qty = getValueFromString(value: txtQlt.text)//(txtQlt.text?.count == 0) ? "0" : txtQlt.text
        let rate = getValueFromString(value: txtRate.text)
        let discount = getValueFromString(value: txtDiscount.text)
        
        
        if let enableCustomForm = getDefaultSettings()?.disCalculationType{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                let totalAmount = calculateAmount(quantity: Double(qty)!, rate: Double(rate)!, tax: Double(txtTax.text ?? "0.0")!, discount: Double(discount)!)
                
                let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty:Double(qty)!, taxRateInPercentage: Double(txtTax.text ?? "0.0")!)
                
                DispatchQueue.main.async {
                    self.txtAmount.text = roundOff(value: totalAmount)
                    self.txtTaxAmount.text = roundOff(value: taxAmount)
                }
            }else{
                
                let totalAmount = calculateAmountFlateDiscount(quantity: Double(qty)!, rate: Double(rate)!, tax: Double(txtTax.text ?? "0.0")!, discount: Double(discount)!)
                
                let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty:Double(qty)!, taxRateInPercentage: Double(txtTax.text ?? "0.0")!)
                
                DispatchQueue.main.async {
                    self.txtAmount.text = roundOff(value: totalAmount)
                    self.txtTaxAmount.text = roundOff(value: taxAmount)
                }
                
           
            }
        }
        
    
    }
    
    
    func setCalculationForFinalAmount() -> Void {
        let qty =  getValueFromString(value: txtQlt.text)//(txtQlt.text?.count == 0) ? "0" : txtQlt.text
        let rate = getValueFromString(value: txtRate.text)  // textfieldRoundOffWith(textField: txtRate)
        let discount = getValueFromString(value: txtDiscount.text) //textfieldRoundOffWith(textField: txtDiscount)
        let tax = getValueFromString(value: txtTax.text)  //textfieldRoundOffWith(textField: txtTax)
        
        if let enableCustomForm = getDefaultSettings()?.disCalculationType{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                let totalAmount = calculateAmount(quantity: Double(qty)!, rate: Double(rate)!, tax: Double(tax)!, discount: Double(discount)!)
                
                let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: Double(tax)!)
                
                // DispatchQueue.main.async {
                self.txtQlt.text = txtQlt.text//qty
                self.txtRate.text = rate
                self.txtDiscount.text = discount
                self.txtTax.text = txtTax.text//tax
                self.txtAmount.text = roundOff(value: totalAmount)
                self.txtTaxAmount.text = roundOff(value: taxAmount)
            }else{
                let totalAmount = calculateAmountFlateDiscount(quantity: Double(qty)!, rate: Double(rate)!, tax: Double(tax)!, discount: Double(discount)!)
                
                let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: Double(tax)!)
                
                // DispatchQueue.main.async {
                self.txtQlt.text = txtQlt.text//qty
                self.txtRate.text = rate
                self.txtDiscount.text = discount
                self.txtTax.text = txtTax.text//tax
                self.txtAmount.text = roundOff(value: totalAmount)
                self.txtTaxAmount.text = roundOff(value: taxAmount)
                
            }
        }
   
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        selectedTxtField = textField
        if (textField != txtItem) || (textField != txtDescription){
            let number = Double(textField.text!)
            if number == 0 {
                DispatchQueue.main.async {
                    textField.text = ""
                }
            }
        }
        
        if textField == txtItem {
            isFilter = false
            
            var arry = [Any]()
            switch selectedInvType {
            case .ITEM :
                arry = []
                break
                
            case .FIELDWORKER :
                arry = arrOffldWrkData
                break
                
            case .SERVICE :
                arry = arrOfTitles
                break
            }
            
            openDwopDown(txtField: textField, arr: arry)
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        calculationFunction()
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if(textField != txtItem){
            
            let insensitiveCount = result.lowercased().filter{ $0 == Character(String(".").lowercased())}
            if insensitiveCount.count > 1 {
                return false
            }
            
            var finalText = ""
            if  (textField == txtQlt) {
                finalText = isValidateInputCharactors(text: string, validation: ValidCharactors.NumberWithDot)
            }else if (textField == txtPartno) || (textField == txtHSNcode) || (textField == txtUnit) {
                finalText = string
            }else{
                
                if (result.containsSpecialCharacter){
                    return false
                }
                
                finalText = isValidateInputCharactors(text: string, validation: ValidCharactors.NumberWithDot)
            }
            
            
            if textField == txtDiscount && result != "" {
                if (Double(result)! > 100) {
                    ShowError(message: AlertMessage.discountError, controller: windowController)
                    return false
                }
            }
            
            return string == finalText
        }
        
        count = 0
        
        if textField == txtItem {
            isNonInventory = true
            itemID = ""
            if result.count > 2 {
                switch selectedInvType {
                case .ITEM :
                    self.getItems(txtSearch: result)
                    break
                    
                case .FIELDWORKER :
                    isFilter = true
                    self.filterFieldWorker(searchText: result)
                    break
                    
                case .SERVICE :
                    isFilter = true
                    self.filterTitles(searchText: result)
                    break
                }
                
            }else{
                self.removeOptionalView()
            }
        }
        
        
        
        return true
        
    }

    
    func addUpdateItemInInvoice(quoteItem: QuoteItem?) -> Void {
        
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            return
        }
        
        showLoader()
        let url = (selectedIndex == nil) ? Service.addQuotItemForMobile : Service.updateQuotItemForMobile
        
        serverCommunicator(url:url , param: quoteItem.toDictionary) { (response, success) in
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(CommonResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        if self.callbackDetailVC != nil {
                            self.callbackDetailVC!(false)
                        }
                        DispatchQueue.main.async{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        killLoader()
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    killLoader()
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                killLoader()
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
}
