//
//  ListItemVC.swift
//  EyeOnTask
//
//  Created by Mac on 27/03/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit//equStatus

class ListItemVC: UIViewController, OptionViewDelegate {
    
    @IBOutlet weak var view_H: NSLayoutConstraint!
    @IBOutlet weak var partTableView: UITableView!
    @IBOutlet weak var partItemVw: UIView!
    @IBOutlet weak var taxtCancelBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var skipVwTittle: UILabel!
    @IBOutlet weak var skipView: UIView!
    @IBOutlet weak var billableBtn: UIButton!
    @IBOutlet weak var notBillablBtn: UIButton!
    @IBOutlet weak var extraTxtFld: UITextField!
    @IBOutlet weak var converEquipmentBtn: UIButton!
    @IBOutlet weak var serialNoTxtFld: FloatLabelTextField!
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
    @IBOutlet weak var H_rareIncTxtView: NSLayoutConstraint!
    @IBOutlet weak var txtRateIncTxt: FloatLabelTextField!
    @IBOutlet weak var billableView: UIView!
    @IBOutlet weak var H_segment: NSLayoutConstraint!
    @IBOutlet var taxView: UIView!
    @IBOutlet weak var H_serialNo: NSLayoutConstraint!
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
    
    var selectedTaxId = ""
    var callbackDetailVC: ((Bool) -> Void)?
    var itemGroupCond = false
    var hiddenPartCheckBtn  = false
    var arrOfflineTax = [TaxList]()
    var inventryOneItenSearch = false
    var arrItemListOnlineOneItem = [itemInfo]()
    var inventrySearchBool = false
    var isbillableTag = "1"
    var TagList = ["Indore","Bhopal","Dewas","Ujjain","Dehli"]
    var sltDropDownTag : Int!
    var timer:Timer?
    var searchkry:Bool = false
    var globel :Int = 0
    var searchkey = ""
    var SearchLimit:Int = 0
    var taxListOnlinArr = [TaxList]()
    var selectArr = [String]()
    var selectData = [Double]()
    var selectedRows:[Int] = []
    var name = ""
    var Description = ""
    var warrantyValue = ""
    var partItemId = ""
    var warrantyType = ""
    var arrOfflineTaxData = [TaxList]()
    var isAdd : Bool!
    var addEquipId = false
    var itenConditionForRemark :Bool = false
    var eqIdparm = ""
    var isDissableQntyTxtFld :Bool = false
    var hidenSigmentView :Bool = false
    var isAddEqup : Bool!
    var isTittlenameChng : Bool!
    var isFilter = false
    var isFistTimeAdd = false
    var textCount = 0
    var selectedInvType : invoiceType = .ITEM
    var selectedIndex : Int?
    var isHiddenView = false
    var invoiceRes : InvoiceResponse?
    var item = [ItemDic]()
    var taxList = [taxListRes]()
    var count : Int = 0
    var addcount : Int = 0
    var arrItemListOnline = [itemInfo]()
    var filterItemListOnline = [itemInfo]()
    var searchKeyItemListOnline = [itemInfo]()
    var arrItemList = [ItemList]()
    var filterItemList = [ItemList]()
    var searchtemList = [ItemList]()
    var searchInventroryCount : Int = 0
    var cou : Int = 0
    var arrOfShowDatainTable = [Any]()
    var arrOfShowData = [UserAccType]()
    var arrOfAccType = [UserAccType]()
    var globelCheckTxt = ""
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
    var taxes = [texDetail]()
    var taxDic = [texDic]()
    var isNonInventory = false
    var itemID = ""
    var isDisable = true
    let ORIGINAL_HEIGHT : CGFloat = 65.0
    let REMOVE_HEIGHT : CGFloat = 0.0
    var taxListData = [TaxListResData]()
    var NewtaxListData = [TaxListResData]()
    var itemValue: [String] = []
    var itemValueText: [String] = []
    var textFldTuchAct = false
    var isChecked = false
    var inventoryItmSerch = Bool()
    var isLocId = ""
    var arrItemListOnline1GetJobTittle = [taxListRes]()
    var searchkryGetJobTittle:Bool = false
    var countGetJobTittle : Int = 0
    var addcountGetJobTittle : Int = 0
    var globelGetJobTittle :Int = 0
    var searchInventroryCountGetJobTittle : Int = 0
    var getItemPartsArr = [getItemPartsData]()
    var arrTaxData = [taxData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view_H.constant = 1350
        
        self.partItemVw.isHidden = true
        self.partItemVw.layer.cornerRadius = 0
        self.partItemVw.layer.shadowColor = UIColor.black.cgColor
        self.partItemVw.layer.shadowOpacity = 0.1
        self.partItemVw.layer.shadowRadius = 5
        
        billableBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
        self.taxtCancelBtn.isHidden = true
        var taxid = ""
        taxid = UserDefaults.standard.value(forKey: "Taxid") as? String ?? ""
        var isJobCardHide = "True"
        UserDefaults.standard.set(isJobCardHide, forKey: "isJobCardHide")
        
        if hidenSigmentView == true {
            if itenConditionForRemark == true{
                self.skipView.isHidden = true
            }else{
                self.skipView.isHidden = false
            }
            self.segment.isHidden = true
        }
        self.converEquipmentBtn.isHidden = true
        if isDissableQntyTxtFld == true {
            self.txtQlt.isUserInteractionEnabled = false
        }
 
        getJobTittle()
        getTaxList()
        getFwList()
        getTitleList()
        
        
        
        if isHiddenView == true {
            self.billableView.isHidden = true
        }else{
            self.billableView.isHidden = false
        }
        
        if selectedIndex != nil {
            let selecteditem1 = item[selectedIndex!]
            
            
            if selecteditem1.isBillable == nil {
                notBillablBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                billableBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
            }else{
                if selecteditem1.isBillable == "1"{
                    self.isbillableTag = "1"
                    notBillablBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                    billableBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                }else{
                    self.isbillableTag = "0"
                    billableBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                    notBillablBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                }
            }
            
        }
        
        // getLocationList()
        
        getTitleList22()
        segment.removeSegment(at: 1, animated: false)
        self.arrItemListOnline.removeAll()
        arrItemListOnlineOneItem.removeAll()
        
        //        taxTable.register(UITableViewCell.self, forCellReuseIdentifier: "taxCell")
        //        taxTable.allowsSelectionDuringEditing = true
        
        //  self.getItems(txtSearch: "")
        
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
        btnCancelTaxView.setTitle(LanguageKey.close, for: .normal)
        self.txtRateIncTxt.text =  roundOff(value:Double("0.00")!)
        
        if let hsn = invoiceRes?.data?.hsnCodeLable{
            if hsn == "" {
                txtHSNcode.placeholder = LanguageKey.hsn_code
            }else{
                txtHSNcode.placeholder = hsn
            }
        }else{
            txtHSNcode.placeholder = LanguageKey.hsn_code
        }
        
        if isDisable == false {
            let fields = [txtItem,txtPartno,txtHSNcode,txtDescription,txtQlt,txtRate,txtUnit,txtDiscount,txtTax,txtTaxAmount,txtAmount,txtSupplierPrice]
            
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
            
            ActivityLog(module:Modules.item.rawValue , message: ActivityMessages.jobProductsUpdateProduct)
            
            let selecteditem = item[selectedIndex!]
            itemID = selecteditem.itemId!
            
            if selecteditem.dataType == "6"{
             
                self.converEquipmentBtn.isHidden = true
                self.serialNoTxtFld.isUserInteractionEnabled = false
                self.serialNoTxtFld.textColor = UIColor.lightGray
                self.editItemBtn.isHidden = true
                self.txtAmount.isUserInteractionEnabled = false
                self.txtAmount.textColor = UIColor.lightGray
                self.txtDiscount.isUserInteractionEnabled = false
                self.txtDiscount.textColor = UIColor.lightGray
                self.txtItem.isUserInteractionEnabled = false
                self.txtItem.textColor = UIColor.lightGray
                self.txtQlt.isUserInteractionEnabled = false
                self.txtQlt.textColor = UIColor.lightGray
                self.txtTax.isUserInteractionEnabled = false
                self.txtTax.textColor = UIColor.lightGray
                self.txtRate.isUserInteractionEnabled = false
                self.txtRate.textColor = UIColor.lightGray
                self.txtDescription.isUserInteractionEnabled = false
                self.txtDescription.textColor = UIColor.lightGray
                self.txtPartno.isUserInteractionEnabled = false
                self.txtPartno.textColor = UIColor.lightGray
                self.txtHSNcode.isUserInteractionEnabled = false
                self.txtHSNcode.textColor = UIColor.lightGray
                self.txtUnit.isUserInteractionEnabled = false
                self.txtUnit.textColor = UIColor.lightGray
                self.txtTaxAmount.isUserInteractionEnabled = false
                self.txtTaxAmount.textColor = UIColor.lightGray
                self.txtSupplierPrice.isUserInteractionEnabled = false
                self.txtSupplierPrice.textColor = UIColor.lightGray
            }
            
            if isAdd == false{
                self.converEquipmentBtn.isHidden = false
                title = (isDisable ==  false) ? LanguageKey.view_details : LanguageKey.update_item
                
                switch selecteditem.type {
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
                ActivityLog(module:Modules.item.rawValue , message: ActivityMessages.jobProductsAddNewProduct)
            }
            
            
            serialNoTxtFld.text = selecteditem.serialNo
            txtItem.text = selecteditem.inm
            self.name =  txtItem.text ?? ""
            txtItem.isUserInteractionEnabled = false
            txtItem.textColor = UIColor.lightGray
            txtDiscount.text = getValueFromString(value: selecteditem.discount)
            txtQlt.text = selecteditem.qty
            txtRate.text = getValueFromString(value: selecteditem.rate)
            txtRateIncTxt.text = getValueFromString(value: selecteditem.rate)
            txtDescription.text = selecteditem.des
            self.Description =   txtDescription.text ?? ""
            txtHSNcode.text = selecteditem.hsncode ?? ""
            txtUnit.text = selecteditem.unit ?? ""
            txtTaxAmount.text =  getValueFromString(value: selecteditem.taxamnt)
            txtPartno.text = selecteditem.pno ?? ""
            txtSupplierPrice.text = getValueFromString(value: selecteditem.supplierCost)
            self.warrantyType = selecteditem.warrantyType ?? ""
            self.warrantyValue = selecteditem.warrantyValue ?? ""
            
            
            var tax : Double = Double(roundOff(value: 0.0))!
            for tx in selecteditem.tax! {
                tax = tax + Double(getValueFromString(value: tx.rate))!
            }
            
            var TextValue =  getValueFromString(value: String(tax))
                    
                    if TextValue != "" && TextValue != nil && TextValue != "0.00"
                    {
                        self.taxtCancelBtn.isHidden = false
                    }else{
                        self.taxtCancelBtn.isHidden = true
                    }
            
            txtTax.text =  getValueFromString(value: String(tax))
            txtAmount.text =  getValueFromString(value: selecteditem.amount)
            self.setData(objItem: selecteditem, tax: tax)
        }
        
        
        if isAdd == false {
            segment.isHidden = true
            H_segment.constant = 0.0
            deleteItemBtn.isHidden = true
            
            if let enableItemEditEnable = getDefaultSettings()?.isItemEditEnable{ //This is round off digit for invoice
                if enableItemEditEnable == "0"{
                    
                    serialNoTxtFld.textColor = UIColor.lightGray
                    txtAmount.textColor = UIColor.lightGray
                    txtDiscount.textColor = UIColor.lightGray
                    txtItem.textColor = UIColor.lightGray
                    txtQlt.textColor = UIColor.lightGray
                    txtTax.textColor = UIColor.lightGray
                    txtRate.textColor = UIColor.lightGray
                    txtDescription.textColor = UIColor.lightGray
                    txtPartno.textColor = UIColor.lightGray
                    txtHSNcode.textColor = UIColor.lightGray
                    txtUnit.textColor = UIColor.lightGray
                    txtTaxAmount.textColor = UIColor.lightGray
                    txtSupplierPrice.textColor = UIColor.lightGray
                    self.serialNoTxtFld.isUserInteractionEnabled = false
                    self.txtAmount.isUserInteractionEnabled = false
                    self.txtDiscount.isUserInteractionEnabled = false
                    self.txtItem.isUserInteractionEnabled = false
                    self.txtQlt.isUserInteractionEnabled = false
                    self.txtTax.isUserInteractionEnabled = false
                    self.txtRate.isUserInteractionEnabled = false
                    self.txtDescription.isUserInteractionEnabled = false
                    self.txtPartno.isUserInteractionEnabled = false
                    self.txtHSNcode.isUserInteractionEnabled = false
                    self.txtUnit.isUserInteractionEnabled = false
                    self.txtTaxAmount.isUserInteractionEnabled = false
                    self.txtSupplierPrice.isUserInteractionEnabled = false
                    
                    editItemBtn.isHidden = true
                }else{
                    
                    let selecteditem = item[selectedIndex!]
                    if selecteditem.dataType == "6"{
                        editItemBtn.isHidden = true
                        
                    }else{
                        self.converEquipmentBtn.isHidden = false
                        editItemBtn.setTitle(LanguageKey.update_btn , for: .normal)
                        editItemBtn.isHidden = false
                    }
                    
                }
            }
            
        }
        

        comPermissionIshide() // For show/Hide fields
        
        txtRate.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // txtQlt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtDiscount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtRate.addTarget(self, action: #selector(textFieldDidChange1(_:)), for: .editingChanged)
     
        showDataOnTableViewJob(query: nil)
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
               super .viewWillAppear(animated)
           if hidenSigmentView == true{
               
               
             //  navigationController?.setNavigationBarHidden(false, animated: animated)
            let image = UIImage(named:"back-arrow")
            let leftButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonMethod))
            self.navigationItem.leftBarButtonItem = leftButton

               self.isFistTimeAdd = false
           }
           
       }
    
    @objc func backButtonMethod() -> Void {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    func setData(objItem: ItemDic, tax: Double) {
        let rate = Double(getValueFromString(value: objItem.rate ?? "")) ?? 0.0
        let quantity = Double(getValueFromString(value: objItem.qty ?? "")) ?? 0.0
        let discount = Double(getValueFromString(value: objItem.discount ?? "")) ?? 0.0
        if let arrTax = objItem.tax, arrTax.count > 0 && tax != 0 {
            for obj in arrTax {
                let objTax = taxData()
                if (obj.rate != "") && (obj.taxId != "") {
                    objTax.taxId = obj.taxId
                    objTax.rate = obj.rate
                    objTax.txRate = obj.txRate
                    objTax.tnm = obj.label
                    objTax.ijmmId = obj.ijmmId
                    objTax.tagId = obj.ijtmmId
                    self.arrTaxData.append(objTax)
                }
            }
        }
        
        if let adminCalculationType = getDefaultSettings()?.disCalculationType , adminCalculationType == "0" {
            if let jobCalculationType = self.jobDetail.disCalculationType , jobCalculationType == "1" {
                let  result = calculateNormalDiscountAmount(quantity: quantity, rate: rate, tax: tax, discount: discount)
                self.txtRateIncTxt.text = roundOff(value: result.0)
                self.txtTaxAmount.text = roundOff(value: result.1)
                self.txtAmount.text = roundOff(value: result.2)
            } else {
                let result = calculateFlateDiscountAmount(quantity: quantity, rate: rate, tax: tax, discount: discount)
                self.txtRateIncTxt.text = roundOff(value: result.0)
                self.txtTaxAmount.text = roundOff(value: result.1)
                self.txtAmount.text = roundOff(value: result.2)
            }
        } else {
            
            if let jobCalculationType = self.jobDetail.disCalculationType , jobCalculationType == "1" {
                let  result = calculateNormalDiscountAmount(quantity: quantity, rate: rate, tax: tax, discount: discount)
                self.txtRateIncTxt.text = roundOff(value: result.0)
                self.txtTaxAmount.text = roundOff(value: result.1)
                self.txtAmount.text = roundOff(value: result.2)
            } else {
                let  result = calculatePercentageDiscountAmount(quantity: quantity, rate: rate, tax: tax, discount: discount)
                self.txtRateIncTxt.text = roundOff(value: result.0)
                self.txtTaxAmount.text = roundOff(value: result.1)
                self.txtAmount.text = roundOff(value: result.2)
            }
        }
    }
    
    func makeDisableField(field : FloatLabelTextField) -> Void {
        DispatchQueue.main.async {
            field.isUserInteractionEnabled = false
            field.textColor = UIColor.lightGray
        }
    }
    
    
    func setLocalization() -> Void {
        if hidenSigmentView == true{
            if self.isTittlenameChng == true {
                self.navigationItem.title = (isDisable ==  false) ? LanguageKey.view_details : LanguageKey.addItem_screen_title
            }else{
                
                self.skipView.isHidden = false
                self.navigationItem.title = LanguageKey.step_1
            }
        }else{
            self.skipView.isHidden = true 
            self.navigationItem.title = (isDisable ==  false) ? LanguageKey.view_details : LanguageKey.addItem_screen_title
        }
        
        
        segment.setTitle(LanguageKey.items_name, forSegmentAt: 0)
        // segment.setTitle(LanguageKey.fieldworker, forSegmentAt: 1)
        segment.setTitle(LanguageKey.services_name, forSegmentAt: 1)
        txtItem.placeholder = "\(LanguageKey.items_name)*"
        txtPartno.placeholder = LanguageKey.part_no
        txtDescription.placeholder = LanguageKey.description
        txtQlt.placeholder = LanguageKey.qty_hr
        txtRate.placeholder = LanguageKey.rate
        txtUnit.placeholder = LanguageKey.unit
        txtRateIncTxt.placeholder = LanguageKey.rate_inclu_tax
        
        if let enableCustomForm = jobDetail.disCalculationType { //getDefaultSettings()?.disCalculationType{ chng
            if enableCustomForm == "0" {
                txtDiscount.placeholder = "\(LanguageKey.discount)(%)"
             } else {
                txtDiscount.placeholder = "\(LanguageKey.discount)"
            }
    }
        txtTax.placeholder = LanguageKey.tax
        txtTaxAmount.placeholder = LanguageKey.tax_amount
        txtAmount.placeholder = LanguageKey.total_amount
        serialNoTxtFld.placeholder = LanguageKey.equipment_serial
        txtSupplierPrice.placeholder = LanguageKey.supplier_cost
        converEquipmentBtn.setTitle(LanguageKey.convert_item_to_equ, for: .normal)
        editItemBtn.setTitle(LanguageKey.save_btn, for: .normal)
        deleteItemBtn.setTitle(LanguageKey.Item_delete_button, for: .normal)
        //serialNoTxtFld.placeholder = LanguageKey.tax
        billableBtn.setTitle(" \(LanguageKey.billable)" + " (\(LanguageKey.text_default))", for: .normal)
        notBillablBtn.setTitle(" \(LanguageKey.non_billable)", for: .normal)
        
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
        checkPermission(permission: compPermission.hsncode, layout: H_HNScode)
        checkPermission(permission: compPermission.unit, layout: H_Unit)
        checkPermission(permission: compPermission.taxamnt, layout: H_taxAmount)
        checkPermission(permission: compPermission.pno, layout: H_txtPartNo)
        checkPermission(permission: compPermission.supplierCost, layout: H_supplierPrice)
        checkPermission(permission: compPermission.serialNo, layout: H_serialNo)
        checkPermission(permission: compPermission.isRateIncludingTax, layout: H_rareIncTxtView)
    }
    
    func disableFieldsForFieldworker() -> Void {
        
        H_serialNo.constant = REMOVE_HEIGHT
        //1. supplier cost ,HSN Code, part no, unit for fieldworker
        H_supplierPrice.constant = REMOVE_HEIGHT
        H_HNScode.constant = REMOVE_HEIGHT
        H_txtPartNo.constant = REMOVE_HEIGHT
        H_Unit.constant = REMOVE_HEIGHT
        H_txtDiscount.constant = compPermissionVisible(permission: compPermission.discount) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
    }
    
    func disableFieldsForService() -> Void {
        // 2. supplier cost and discount for Service
        H_supplierPrice.constant = REMOVE_HEIGHT
      //  H_txtDiscount.constant = REMOVE_HEIGHT
        H_HNScode.constant = compPermissionVisible(permission: compPermission.hsncode) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_txtPartNo.constant = compPermissionVisible(permission: compPermission.pno) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_Unit.constant = compPermissionVisible(permission: compPermission.unit) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_serialNo.constant = compPermissionVisible(permission: compPermission.serialNo) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_rareIncTxtView.constant = compPermissionVisible(permission: compPermission.isRateIncludingTax) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
    }
    
    func disableFieldsForItem() -> Void {
        // 2. supplier cost and discount for Service
        H_supplierPrice.constant = compPermissionVisible(permission: compPermission.supplierCost) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_txtDiscount.constant = compPermissionVisible(permission: compPermission.discount) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_HNScode.constant = compPermissionVisible(permission: compPermission.hsncode) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_txtPartNo.constant = compPermissionVisible(permission: compPermission.pno) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_Unit.constant = compPermissionVisible(permission: compPermission.unit) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_serialNo.constant = compPermissionVisible(permission: compPermission.serialNo) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
        H_rareIncTxtView.constant = compPermissionVisible(permission: compPermission.isRateIncludingTax) ? ORIGINAL_HEIGHT : REMOVE_HEIGHT
    }
    
    func checkPermission(permission : compPermission, layout : NSLayoutConstraint ) -> Void {
        let isShow = compPermissionVisible(permission: permission)
        if isShow == false {
            layout.constant = 0.0
        }
    }
    
    func getTaxList() -> Void {
        
        if !isHaveNetowork() {
            // ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            return
        }
        
        
        let param = Params()
        
        param.limit = "120"
        if searchkryGetJobTittle == false {
            param.index = "\(countGetJobTittle)"
        }else{
            param.index = "\(addcountGetJobTittle)"
        }
        
        param.search = ""
        param.compId = getUserDetails()?.compId
        
        serverCommunicator(url: Service.getTaxList, param: param.toDictionary) { (response, success) in
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(taxResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        self.searchInventroryCountGetJobTittle = 200
                        
                        if Int(param.index!)! +  Int(param.limit!)! <= self.searchInventroryCountGetJobTittle {
                            
                            self.globelGetJobTittle = Int(param.index!)! +  Int(param.limit!)!
                            self.addcountGetJobTittle = self.globelGetJobTittle
                            self.searchkryGetJobTittle = true
                            self.arrItemListOnline1GetJobTittle.append(contentsOf: decodedData.data as! [taxListRes])
                            self.getTaxList()
                            
                        }else{
                            
                            self.saveTaxList(data: self.arrItemListOnline1GetJobTittle)
                            
                        }
                        
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    // self.removeOptionalView()
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
    

    
    func showTaxDataOnTableViewJob(query : String?) -> Void {
      
        arrOfflineTax = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TaxList", query: query) as! [TaxList]
        self.arrOfflineTaxData = (arrOfflineTax.filter({ (tax) -> Bool in
            if tax.show_Invoice == "1" && tax.isactive == "1" {
                return true
            }else{
                return false
            }
            
        }))
        
        taxListData.removeAll()
        for data in arrOfflineTaxData {
            taxListData.append(TaxListResData(dic: data))
            
        }
  
        for indde in taxListData {
            //  itemValue.removeAll()
            if isLocId == "0"{
                
                
                if indde.locId == isLocId{
                    //    NewtaxListData.append(indde)
                    
                    
                    //                if indde.locId == isLocId{
                    //                                   itemValueText.append("\(indde.label!)" + "  \(indde.percentage!) %" )
                    //
                }
            }else{
                if indde.locId == "0"{
                    //itemValueText.append("\(indde.label!)" + "  \(indde.percentage!) %" )
                    NewtaxListData.append(indde)
                    
                }
                
                if indde.locId == isLocId{
                    // itemValueText.append("\(indde.label!)" + "  \(indde.percentage!) %" )
                    NewtaxListData.append(indde)
                }
            }
           
        }
        
        var countTxt = itemValueText.count
        textCount = countTxt
       
        if isAdd == false {
            self.selectedRows.removeAll()
            if self.selectedIndex != nil{
                let selecteditem = self.item[self.selectedIndex!]
                
                if self.taxListData.count > 0 {
                    for index in 0...taxListData.count-1 {
                        
                        let object = taxListData[index]
                        
                        object.percentage = (object.percentage ?? "0.0")
                        
                        let data = selecteditem.tax?.filter{$0.taxId == object.taxId}
                        
                        DispatchQueue.main.async {
                            if self.txtTax.text == "0.00" {
                                self.selectedRows.removeAll()
                            } else {
                                if (data?.count)! > 0 {
                                self.selectedRows.append(index)
                                if let taxId = data?.first?.taxId {
                                    self.selectedTaxId = taxId
                                }
                            }
                                
                            }
                        }
                        
                    }
                }
            }
            
        }
        
        
        for tax in taxListData {
            
            //Create taxDetail model for send on server
            let taxdetail = texDetail() 
            taxdetail.taxId = tax.taxId
            taxdetail.txRate = getValueFromString(value: String(tax.value ?? 0.0 ))
            taxdetail.label = tax.label
            self.taxes.append(taxdetail)
            
        }
        DispatchQueue.main.async {
            self.taxTable.reloadData()
        }
        
    }
    
    @objc  func redirect1(){
        ShowError(message: AlertMessage.checkNetwork, controller: windowController)
        // showToast(message: AlertMessage.checkNetwork)
    }
    
    //==============================
    // MARK:- Save saveTaxList in DataBase
    //==============================
    func saveTaxList( data : [taxListRes]) -> Void {
        for jobs in data{
            let query = "taxId = '\(String(describing: jobs.taxId ?? ""))'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TaxList", query: query) as! [TaxList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                existingJob.setValuesForKeys(jobs.toDictionary!)
                // DatabaseClass.shared.saveEntity()
            }else{
                let userJobs = DatabaseClass.shared.createEntity(entityName: "TaxList")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
                // DatabaseClass.shared.saveEntity()
            
           }
        }
        
        
        DatabaseClass.shared.saveEntity(callback: { _ in })
       
        showTaxDataOnTableViewJob(query : nil)
      
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
    
    
    
    func filterListItem(searchText:String) -> Void {
        self.removeOptionalView()
        // let bPredicateOnline: NSPredicate = NSPredicate(format: "self.inm beginswith[c] '\(searchText)'")
        print(filterItemList.count)
        let lower = searchText.uppercased().capitalizingFirstLetter()
        print(lower)
        // self.getItems(txtSearch: searchText)
        if self.arrItemListOnlineOneItem.count == 1{
        filterItemListOnline = arrItemListOnline.filter({$0.inm!.range(of: lower) != nil})
        searchKeyItemListOnline = arrItemListOnline.filter({$0.searchKey!.range(of: lower) != nil})
       // let bPredicate: NSPredicate = NSPredicate(format: "self.inm beginswith[c] \(searchText)")
       // let searchKey: NSPredicate = NSPredicate(format: "self.searchKey beginswith[c] \(searchText)")
       // filterItemList =  (arrItemList as NSArray).filtered(using: bPredicate) as! [ItemList]
       // searchtemList =  (arrItemList as NSArray).filtered(using: searchKey) as! [ItemList]
        }
        if self.arrItemListOnline.count > 2000 {
            
          
            if(self.filterItemListOnline.count > 0){
                DispatchQueue.main.async {
                    self.inventoryItmSerch = false
                    
                    self.openDwopDown(txtField: self.txtItem, arr: self.filterItemListOnline)
                    
                }
            }else{
                self.removeOptionalView()
            }
            
            if(self.searchKeyItemListOnline.count > 0){
                DispatchQueue.main.async {
                    self.inventoryItmSerch = true
                    self.openDwopDown(txtField: self.txtItem, arr: self.searchKeyItemListOnline)
                }
            }else{
                //self.removeOptionalView()
            }
            //taxTable.reloadData()
        } else {
            if  self.inventryOneItenSearch == true{
                if(self.arrItemListOnlineOneItem.count > 0){
                    DispatchQueue.main.async {
                self.openDwopDown(txtField: self.txtItem, arr: self.arrItemListOnlineOneItem)
                    }
                }
            }else{
                if(self.filterItemList.count > 0){
                    DispatchQueue.main.async {
                        self.inventoryItmSerch = false
                        self.openDwopDown(txtField: self.txtItem, arr: self.filterItemList)
                        
                    }
                }else{
                    self.removeOptionalView()
                }
                
                if(self.searchtemList.count > 0){
                    DispatchQueue.main.async {
                        self.inventoryItmSerch = true
                        self.openDwopDown(txtField: self.txtItem, arr: self.searchtemList)
                    }
                }else{
                    //self.removeOptionalView()
                }
            }
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
          //  ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.item_sync )!, controller: windowController)
            
        }
        //  self.timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(redirectJobcll), userInfo: nil, repeats: true)
        if !isHaveNetowork() {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(redirect), userInfo: nil, repeats: false)
            // showToast(message: AlertMessage.checkNetwork)
            //ShowError(message: AlertMessage.checkNetwork, controller: windowController)
           // return
        }
        
        
        
        // showLoader()
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.type = "0"
        param.limit = "120"
     
        if searchkry == false {
            param.index = "\(count)"
        }else{
            param.index = "\(addcount)"
        }
        
        param.search = txtSearch
        param.activeRecord = "0"
        param.showInvoice = "0"
        
        serverCommunicator(url: Service.getItemsList, param: param.toDictionary) { (response, success) in
            
            //     self.removeOptionalView()
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ItemModel.self, from: response as! Data) {
                    if decodedData.success == true{
                        self.searchInventroryCount = Int(decodedData.count!)!
                        // print(self.searchInventroryCount)
                        DispatchQueue.main.async{
                            //  showLoader()
                            //
                            //  var cou = decodedData.data!.count
                            
                            
                            //  0                         // 120                   //360
                            if Int(param.index!)! +  Int(param.limit!)! <= self.searchInventroryCount {
                                self.globel = Int(param.index!)! +  Int(param.limit!)!
                                
                                
                                
                                self.addcount = self.globel
                                self.searchkry = true
                                self.getItems(txtSearch: self.searchkey)
                                self.arrItemListOnline.append(contentsOf: decodedData.data as! [itemInfo])
                                self.inventryOneItenSearch = false
                            }else{
                                self.inventryOneItenSearch = false
                                self.arrItemListOnline.append(contentsOf: decodedData.data as! [itemInfo])
                                self.searchkry = false
                                if   self.arrItemListOnline.count > 2000 {
                                    killLoader()
                                    self.filterListItem(searchText: txtSearch)
                                    
                                }else {
                            
                                    killLoader()
                                  
                                        self.arrItemListOnlineOneItem.removeAll()
                                        self.inventryOneItenSearch = true
                                        self.arrItemListOnlineOneItem.append(contentsOf: decodedData.data as! [itemInfo])
                                        self.filterListItem(searchText: txtSearch)
                                }
                            }
                        }
                    }
                }else{
                    self.removeOptionalView()
                }
            }
        }
    }
    
    @objc  func redirect(){
        ShowError(message: AlertMessage.checkNetwork, controller: windowController)
        // showToast(message: AlertMessage.checkNetwork)
    }
    
    //==============================
    // MARK:- Save getItems in DataBase
    //==============================
    func savegetIndustryList( data : [itemInfo]) -> Void {
        for jobs in data{
            let query = "itemId = '\(String(describing: jobs.itemId ?? ""))'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ItemList", query: query) as! [ItemList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                existingJob.setValuesForKeys(jobs.toDictionary!)
                // DatabaseClass.shared.saveEntity()
            }else{
                let userJobs = DatabaseClass.shared.createEntity(entityName: "ItemList")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
                // DatabaseClass.shared.saveEntity()
            }
        }
        
        DatabaseClass.shared.saveEntity(callback: { _ in })
    }
    
    
    func showDataOnTableViewJob(query : String?) -> Void {
        arrItemList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ItemList", query: query) as! [ItemList]
        
    }
    
    func getFwList() -> Void {
        
        let fieldworkersList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
        //self.arrOffldWrkData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
        
        if (item.count) > 0 {
            let fieldworkers = item.filter { (item) -> Bool in
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
                
                let isExist = fieldworkers.contains{($0.inm == fullname)}
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
        // self.arrOfTitles = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
        
        if (item.count) > 0 {
            let titles = item.filter { (item) -> Bool in
                if item.type == "3" {
                    return true
                }else{
                    return false
                }
            }
            
            for title in servicesList {
                let existJtid = title.jtId
                let isExist = titles.contains{($0.jtId == existJtid)}
                if !isExist {
                    self.arrOfTitles.append(title)
                }
            }
        }else{
            self.arrOfTitles = servicesList
        }
    }
    
    @IBAction func skipBtnActn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "MainJob", bundle:nil)
        let addEqpmnt = storyBoard.instantiateViewController(withIdentifier: "AddEqupment") as! AddEqupment
        self.hiddenPartCheckBtn = true
        addEqpmnt.objOfUserJodbList = self.jobDetail
        addEqpmnt.tittelNm = self.hidenSigmentView
        addEqpmnt.hiddenPartCheckBtn1 = hiddenPartCheckBtn
        self.navigationController?.pushViewController(addEqpmnt, animated: true)
    }
    
    @IBAction func convertEquipment(_ sender: Any) {
        ShowAlert(title: LanguageKey.are_you_sure, message: LanguageKey.item_convrt_count, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.ok as NSString, style: .alert) { (cancel, ok) in
            
            if ok {
                
                let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "ConvertToEquipment") as! ConvertToEquipment
                loginPageView.objOfUserJodbList = self.jobDetail
                loginPageView.itemList = self.name
                loginPageView.DisList = self.Description
                loginPageView.warntyType = self.warrantyType
                loginPageView.warntyVelue = self.warrantyValue
                self.navigationController?.pushViewController(loginPageView, animated: true)
                
            }
            
            if cancel {
                
            }
        
        }
        
    }
    
    
    @IBAction func statusButtonPressed(_ sender: UIButton) {
        
        if selectedIndex != nil {
            
            let tag = sender.tag
            
            switch tag {
            case 0:
                billableBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                notBillablBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                self.isbillableTag = "0"
                break
            default:
                notBillablBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                billableBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                self.isbillableTag = "1"
                break
            }
            
          //  print("update Item")
        }else{
            let tag = sender.tag
            
            switch tag {
            case 0:
                self.isbillableTag = "0"
                billableBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                notBillablBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                break
            default:
                self.isbillableTag = "1"
                notBillablBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                billableBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                break
            }
           // print("add Itemn")
            
            
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
            self.billableBtn.isHidden = false
            self.notBillablBtn.isHidden = false
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
            self.converEquipmentBtn.isHidden = true
            getJobTittle()
            self.billableBtn.isHidden = true
            self.notBillablBtn.isHidden = true
            selectedInvType = .SERVICE
            txtItem.placeholder = "\(LanguageKey.services_name)*"
            disableFieldsForService()
            break
        }
        
    }
   
    @IBAction func taxButtonTapped(_ sender: Any) {
        
        
        if self.taxListData.count > 0 || self.NewtaxListData.count > 0 {
            
            self.taxView.isHidden = false
            if selectedTxtField != nil {
                selectedTxtField?.resignFirstResponder()
            }
            if (self.taxListData.count) > 0 {
                backgroundVw.isHidden = false
                
                var height:CGFloat = 0.0
                if (self.arrOfflineTaxData.count) > 5 {
                    height = 350
                }
                else{
                    height = CGFloat((self.arrOfflineTaxData.count))*60 + 56
                }
                
                var taxVw = taxView.frame
                taxVw.origin.x = backgroundVw.bounds.size.width/2 - taxView.bounds.size.width/2
                taxVw.origin.y = backgroundVw.bounds.size.height/2 - height/2 - 50
                taxVw.size.height = height
                taxView.frame = taxVw
                backgroundVw.addSubview(taxView)
                
                taxView.isHidden = false
            }
        }else{
            self.taxView.isHidden = true
        }
      
        // inventrySearchBool = false
    }
    
    @IBAction func locationDropDown(_ sender: UIButton) {
        
        
        self.sltDropDownTag = sender.tag
        
        switch  sender.tag {
        case 0:
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: txtTax , arr: TagList)
            }else{
                self.removeOptionalView()
            }
            
            break
        default:
          //  print("Defalt")
            break
        }
        
    }
    @IBAction func txtCancelBtnAcn(_ sender: UIButton) {
        inventrySearchBool = false
        taxes.removeAll()
        selectedRows.removeAll()
        selectData.removeAll()
        self.selectedTaxId = "0"
        self.selectedRows.append(sender.tag)
        var total_tax:Double = 0
        selectData.removeAll()
        for index in self.selectedRows {
            let getValue =  roundOff(value:Double("0.00")!)//"0.00"//taxListData[index].percentage
            var taxid = ""
            taxid = UserDefaults.standard.value(forKey: "Taxid") as? String ?? ""
          //  print(taxid)
            var percent = (Double(getValue ?? "0.0"))
            
            let taxdetail = texDetail() // for get model of tax
            taxdetail.taxId = taxid
            taxdetail.txRate = getValueFromString(value: String(getValue ?? "0.0" ))
            taxes.append(taxdetail)
            selectData.append(percent ?? 0.0)
            
        }
        
        for i in selectData {
            total_tax = total_tax + (i)
            //   print(total_tax)
        }
        
        self.txtTax.text = String(total_tax)
        
        //================
        
        let ww = Float((total_tax))
        let dd = Float(txtRate.text!)!
        
        
        let rateIn = dd + dd * ww/100
        self.txtRateIncTxt.text = String(rateIn)
      //  print(rateIn)
        
        //==================
        self.setCalculationForFinalAmount()
        self.taxTable.reloadData()
        
        //  }
        
        DispatchQueue.main.async{
            self.taxTable.reloadData()
        }
    }
    
    @IBAction func btnCancelTax(_ sender: Any) {
        if selectedTxtField != nil {
            selectedTxtField?.resignFirstResponder()
        }
        
        DispatchQueue.main.async {
            
            self.arrTaxData.removeAll()
            for tax in self.taxes {
                var data = self.taxListData.filter{$0.taxId == tax.taxId}
                if (data.count) > 0 {
                    data[0].value = Double(getValueFromString(value: tax.txRate))!
                    let objTax = taxData()
                    objTax.taxId = data[0].taxId
                    objTax.rate = getValueFromString(value: tax.txRate)
                    objTax.tnm = data[0].label
                    self.arrTaxData.append(objTax)
                }
            }
            
            self.taxTable.reloadData()
        }
        backgroundVw.isHidden = true
        taxView.isHidden = true
        self.setCalculationForFinalAmount()
    }
    
    @IBAction func taxSaveButton(_ sender: Any) {
        
        if selectedTxtField != nil {
            selectedTxtField!.resignFirstResponder()
        }
        
        taxes.removeAll()
        
        var total_tax : Double = 0 // For get total tax
        
        for tax in self.taxListData {
            //Create taxDetail model for send on server
            let taxdetail = texDetail() // for get model of tax
            taxdetail.taxId = tax.taxId
            taxdetail.txRate = getValueFromString(value: String(tax.value ?? 0.0 ))
            taxes.append(taxdetail)
            
            total_tax = total_tax + (((tax.value == nil) ? 0.00 :  tax.value) ?? 0.0)
            
        }
        
        
        txtTax.text = String(total_tax)
        
        backgroundVw.isHidden = true
        taxView.isHidden = true
        self.setCalculationForFinalAmount()
        self.taxTable.reloadData()
    }
    
    
    @IBAction func donBtnActn(_ sender: Any) {
        
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
        
        //        if !isHaveNetowork() {
        //            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
        //            return
        //        }
        
        if txtItem.text == "" {
            ShowError(message: LanguageKey.item_empty, controller: windowController)
            return
        }
        
        if selectedTxtField != nil {
            selectedTxtField!.resignFirstResponder()
        }
        
        if itemID == "" {
            if (selectedInvType == .SERVICE) {
                //   ShowError(message: AlertMessage.service_error, controller: windowController)
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
            
            if isAdd {
                if  (selectedInvType == .SERVICE) {
                    self.callforNonInventoryItem()
                }else{
                    let item = DetailedItemData()
                    item.itemId =  itemID
                    item.inm =  trimmedString
                    item.des = trimString(string: txtDescription.text!)
                    item.serialNo = trimString(string:serialNoTxtFld.text!)
                    item.isBillableChange = isbillableTag
                    item.isBillable = isbillableTag
                    item.qty =  txtQlt.text == "" ? "0.1" : txtQlt.text
                    item.rate =  getValueFromString(value: txtRate.text)
                    item.discount = getValueFromString(value: txtDiscount.text)
                    item.type = selectedInvType.rawValue.description
                    item.tax = taxes
                    item.jobId = jobDetail.jobId
                    item.amount = getValueFromString(value:txtAmount.text)
                    item.hsncode = trimString(string: txtHSNcode.text!)
                    item.taxamnt = getValueFromString(value:txtTaxAmount.text)
                    item.unit = trimString(string: txtUnit.text!)
                    item.pno = trimString(string: txtPartno.text!)
                    item.supplierCost = getValueFromString(value: txtSupplierPrice.text)
                    if addEquipId == true {
                        item.equId = eqIdparm
                    }
                    addItemInviceOffline(itemdata: item)
                    
                }
            }else{
                let selecteditem = DetailedItemData() //item[selectedIndex!]
                selecteditem.itemId = itemID
                selecteditem.inm =  trimmedString
                selecteditem.serialNo = trimString(string:serialNoTxtFld.text!)
                selecteditem.rate =  getValueFromString(value: txtRate.text)
                selecteditem.discount = getValueFromString(value: txtDiscount.text)
                selecteditem.qty =  txtQlt.text == "" ? "1" : txtQlt.text
                selecteditem.des = trimString(string: txtDescription.text!)
                selecteditem.tax = taxes
                
                
                
                if selectedIndex != nil {
                    let selecteditem1 = item[selectedIndex!]
                    if selecteditem1.partTempId != "" {
                        
                        if selecteditem1.parentId == "0" {
                            self.itemGroupCond = false
                            selecteditem.isPartChild = "0"
                            selecteditem.isPartParent = "1"
                            
                        }else{
                            self.itemGroupCond = true
                            selecteditem.isPartChild = "1"
                            selecteditem.isPartParent = "0"
                        }
                    }
                    
                    
                    
                    if selecteditem1.isBillable == nil {
                        selecteditem.isBillableChange = isbillableTag
                        selecteditem.isBillable = isbillableTag
                    }else{
                        if selecteditem1.isBillable == "1"{
                            selecteditem.isBillableChange = isbillableTag
                            selecteditem.isBillable = isbillableTag
                            
                        }else if selecteditem1.isBillable == "0"{
                            selecteditem.isBillableChange = isbillableTag
                            selecteditem.isBillable = isbillableTag
                            
                        }
                    }
                    
                }else {
                    selecteditem.isBillableChange = isbillableTag
                    selecteditem.isBillable = isbillableTag
                }
                
                
                // selecteditem.isBillableChange = isbillableTag
                // selecteditem.isBillable = isbillableTag
                selecteditem.taxamnt = getValueFromString(value:txtTaxAmount.text)
                selecteditem.hsncode = trimString(string: txtHSNcode.text!)
                selecteditem.unit = trimString(string: txtUnit.text!)
                selecteditem.pno = trimString(string: txtPartno.text!)
                selecteditem.amount = getValueFromString(value:txtAmount.text)
                selecteditem.jtId =  (selectedInvType == .SERVICE) ? itemID : ""//selecteditem.jtId
                selecteditem.supplierCost = getValueFromString(value: txtSupplierPrice.text)
                
                selecteditem.itype = selectedInvType.rawValue.description
                
                upDateItemInviceOffline(itemdata: selecteditem)
                
            }
            
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
            
            //  ShowError(message: message, controller: windowController)
        }
    }
    
    func callforNonInventoryItem() -> Void {
        let item = newItemData()
        item.itemId = self.itemID
        item.inm =  trimString(string: txtItem.text!)
        item.ides = trimString(string: txtDescription.text!)
        item.qty =  txtQlt.text == "" ? "1" : txtQlt.text
        item.rate =  getValueFromString(value: txtRate.text)
        item.discount = getValueFromString(value: txtDiscount.text)
        item.serialNo = trimString(string: serialNoTxtFld.text!)
        item.tax = taxes
        item.isItemOrTitle = (selectedInvType == .SERVICE) ? "3" : "1"
        item.itype = selectedInvType.rawValue.description
        item.amount = getValueFromString(value:txtAmount.text)
        item.hsncode = trimString(string: txtHSNcode.text!)
        item.taxamnt = getValueFromString(value:txtTaxAmount.text)
        item.unit = trimString(string: txtUnit.text!)
        item.pno = trimString(string: txtPartno.text!)
        item.supplierCost = getValueFromString(value: txtSupplierPrice.text)
        item.jtId = (selectedInvType == .SERVICE) ? itemID : ""
       
        if isAdd {
            addServiceInviceOffline(itemdata: item)
        }else{
            // upDateItemInviceOffline(itemdata: selecteditem)
        }
        
    }
    
    @IBAction func deleteItemActn(_ sender: Any) {
        
        ShowAlert(title: LanguageKey.confirmation , message: AlertMessage.itemRemove, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.remove as NSString, style: .alert) { (cancel, remove) in
            if remove {
                if self.callbackDetailVC != nil {
                    var itemValue: [String] = []
                    let ijmmId = self.item[self.selectedIndex!].ijmmId
                    itemValue.append(ijmmId!)
                    self.deletetemInviceOffline(itemdata: itemValue)
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
            if inventoryItmSerch == true {
                if arrItemListOnline.count > 2000 {
                    return searchKeyItemListOnline.count
                }else {
                    return searchtemList.count
                }
                
            }else{
                if arrItemListOnline.count > 2000 {
                    return (isFilter ? filterItemListOnline.count : arrItemListOnline.count )
                }else {
                    if inventryOneItenSearch == true {
                        self.inventryOneItenSearch = true
                        return ( arrItemListOnlineOneItem.count )
                    }else{
                        return (isFilter ? filterItemList.count : arrItemList.count )
                    }
                    
                }
                
            }
            
            
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
            if inventoryItmSerch == true {
                if arrItemListOnline.count > 2000 {
                    let item = searchKeyItemListOnline[indexPath.row]
                    if let itemname = item.inm {
                        
                        let sas = item.searchKey
                        if sas == ""{
                            cell?.textLabel?.text = "\(itemname)"
                        }else{
                            cell?.textLabel?.text = "\(itemname)" + " ,\(sas!)"
                        }
                     
                    }else{
                        cell?.textLabel?.text = "Unknown item"
                    }
                }
                else {
                    let item = searchtemList[indexPath.row]
                    if let itemname = item.inm {
                        
                        let sas = item.searchKey
                        if sas == ""{
                            cell?.textLabel?.text = "\(itemname)"
                        }else{
                            cell?.textLabel?.text = "\(itemname)" + " ,\(sas!)"
                        }
                        // var dd = ""
                        
                    }else{
                        cell?.textLabel?.text = "Unknown item"
                    }
                }
            }else{
                if arrItemListOnline.count > 2000 {
                    let item = isFilter ? filterItemListOnline[indexPath.row] : arrItemListOnline[indexPath.row]
                    if let itemname = item.inm {
                        
                        let sas = item.searchKey
                        if sas == ""{
                            cell?.textLabel?.text = "\(itemname)"
                        }else{
                            cell?.textLabel?.text = "\(itemname)" + " ,\(sas!)"
                        }
                       
                    }else{
                        cell?.textLabel?.text = "Unknown item"
                    }
                } else {
                    if inventryOneItenSearch == true {
                        self.inventryOneItenSearch = true
                        let item = arrItemListOnlineOneItem[indexPath.row]
                        if let itemname = item.inm {
                            
                            let sas = item.searchKey
                            if sas == ""{
                                cell?.textLabel?.text = "\(itemname)"
                            }else{
                                cell?.textLabel?.text = "\(itemname)" + " ,\(sas!)"
                            }
                          
                        }else{
                            cell?.textLabel?.text = "Unknown item"
                        }
                        
                    }else {
                        let item = isFilter ? filterItemList[indexPath.row] : arrItemList[indexPath.row]
                        if let itemname = item.inm {
                            
                            let sas = item.searchKey
                            if sas == ""{
                                cell?.textLabel?.text = "\(itemname)"
                            }else{
                                cell?.textLabel?.text = "\(itemname)" + " ,\(sas!)"
                            }
                         
                        }else{
                            cell?.textLabel?.text = "Unknown item"
                        }
                    }
                }
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
        self.inventrySearchBool = true
        isNonInventory = false
        
        switch selectedInvType {
            
            //==========================
            // If Item selected
            //==========================
        case .ITEM:
            if inventoryItmSerch == true {
                
                if arrItemListOnline.count > 2000 {
                    let item = searchKeyItemListOnline[indexPath.row]
                    if let itemname = item.inm {
                        txtItem.text = itemname
                    }else{
                        txtItem.text = "Unknown item"
                    }
                  
                    // let item = items[indexPath.row]
                    let rate = getValueFromString(value: item.rate)
                    let discount = getValueFromString(value: item.discount)
                    let supplierCost = getValueFromString(value: item.supplierCost)
                    let qty = (txtQlt.text == "") ? "0.0" : txtQlt.text!
                   
                    itemID = item.itemId!
                    serialNoTxtFld.text = item.serialNo ?? ""
                    txtItem.text = item.inm ?? ""
                    txtQlt.text =  "1"
                    txtTax.text =  roundOff(value:Double("0.00")!)
                    txtRate.text =  rate
                    txtRateIncTxt.text =  rate
                    txtAmount.text =  roundOff(value:Double("0.00")!)
                    txtDiscount.text = discount
                    txtDescription.text = item.ides ?? ""
                    txtPartno.text = item.pno ?? ""
                    txtUnit.text = item.unit ?? ""
                    txtHSNcode.text = item.hsncode ?? ""
                    txtSupplierPrice.text = supplierCost
                    
                    self.taxes = []
                    if item.tax != nil {
                        let itemDatas = (item.tax as! [AnyObject])
                        for tax in self.taxList  {
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
                        let taxdetail = texDetail() // for get model of tax
                        taxdetail.taxId = tax.taxId
                        taxdetail.txRate = getValueFromString(value: String(tax.value ?? 0.0))
                        totalTax = totalTax + (tax.value ?? 0.0)
                        self.taxes.append(taxdetail)
                    }
                    DispatchQueue.main.async {
                        self.taxTable.reloadData()
                    }
                    
                    txtTax.text = roundOff(value: totalTax)
                    
                    let totalAmount =  calculateAmount(quantity: 1.0, rate: Double(rate)!, tax: Double(totalTax), discount: Double(discount)!)
                    txtAmount.text =  roundOff(value: totalAmount)
                  //  print("---- 2 \(self.txtAmount.text)")
                    // let taxAmount = calculateTaxAmount(amount: totalAmount, taxRateInPercentage: totalTax)
                    let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: Double(totalTax))
                    txtTaxAmount.text = roundOff(value: taxAmount)
                }
                else{
                    let item = searchtemList[indexPath.row]
                    if let itemname = item.inm {
                        txtItem.text = itemname
                    }else{
                        txtItem.text = "Unknown item"
                    }
                    
                    
                    
                    // let item = items[indexPath.row]
                    let rate = getValueFromString(value: item.rate)
                    let discount = getValueFromString(value: item.discount)
                    let supplierCost = getValueFromString(value: item.supplierCost)
                    let qty = (txtQlt.text == "") ? "0.0" : txtQlt.text!
                   
                    itemID = item.itemId!
                    serialNoTxtFld.text = item.serialNo ?? ""
                    txtItem.text = item.inm ?? ""
                    txtQlt.text =  "1"  //item.qty != "" ? ((Int(item.qty!)! > 0) ? item.qty : "1")   : "1"
                    txtTax.text =  roundOff(value:Double("0.00")!)
                    txtRate.text =  rate
                    txtRateIncTxt.text =  rate
                    txtAmount.text =  roundOff(value:Double("0.00")!)
                    txtDiscount.text = discount
                    txtDescription.text = item.ides ?? ""
                    txtPartno.text = item.pno ?? ""
                    txtUnit.text = item.unit ?? ""
                    txtHSNcode.text = item.hsncode ?? ""
                    txtSupplierPrice.text = supplierCost
                    
                    
                    self.taxes = []
                    if item.tax != nil {
                        let itemDatas = (item.tax as! [AnyObject])
                        for tax in self.taxList  {
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
                        let taxdetail = texDetail() // for get model of tax
                        taxdetail.taxId = tax.taxId
                        taxdetail.txRate = getValueFromString(value: String(tax.value ?? 0.0))
                        totalTax = totalTax + (tax.value ?? 0.0)
                        self.taxes.append(taxdetail)
                    }
                    DispatchQueue.main.async {
                        self.taxTable.reloadData()
                    }
                    
                    txtTax.text = roundOff(value: totalTax)
                    
                    let totalAmount =  calculateAmount(quantity: 1.0, rate: Double(rate)!, tax: Double(totalTax), discount: Double(discount)!)
                    txtAmount.text =  roundOff(value: totalAmount)
                 //   print("---- 3 \(self.txtAmount.text)")
                    // let taxAmount = calculateTaxAmount(amount: totalAmount, taxRateInPercentage: totalTax)
                    let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: Double(totalTax))
                    txtTaxAmount.text = roundOff(value: taxAmount)
                }
                
                
            }else{
                if arrItemListOnline.count > 2000 {
                    let item = isFilter ? filterItemListOnline[indexPath.row] : filterItemListOnline[indexPath.row]
                    if let itemname = item.inm {
                        txtItem.text = itemname
                    }else{
                        txtItem.text = "Unknown item"
                    }
                    
                    
                    
                    // let item = items[indexPath.row]
                    let rate = getValueFromString(value: item.rate)
                    let discount = getValueFromString(value: item.discount)
                    let supplierCost = getValueFromString(value: item.supplierCost)
                    let qty = (txtQlt.text == "") ? "0.0" : txtQlt.text!
                    
                    itemID = item.itemId!
                    serialNoTxtFld.text = item.serialNo ?? ""
                    txtItem.text = item.inm ?? ""
                    txtQlt.text =  "1"  //item.qty != "" ? ((Int(item.qty!)! > 0) ? item.qty : "1")   : "1"
                    txtTax.text =  roundOff(value:Double("0.00")!)
                    txtRate.text =  rate
                    txtRateIncTxt.text =  rate
                    txtAmount.text =  roundOff(value:Double("0.00")!)
                    txtDiscount.text = discount
                    txtDescription.text = item.ides ?? ""
                    txtPartno.text = item.pno ?? ""
                    txtUnit.text = item.unit ?? ""
                    txtHSNcode.text = item.hsncode ?? ""
                    txtSupplierPrice.text = supplierCost
                    
                    
                    self.taxes = []
                    if item.tax != nil {
                        let itemDatas = (item.tax as! [AnyObject])
                        for tax in self.taxList  {
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
                        let taxdetail = texDetail() // for get model of tax
                        taxdetail.taxId = tax.taxId
                        taxdetail.txRate = getValueFromString(value: String(tax.value ?? 0.0))
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
                }
                else{
                    if inventryOneItenSearch == true {
                        let item = arrItemListOnlineOneItem[indexPath.row]
                        
                        self.getItemParts(partItemId: item.itemId ?? "")
                        if let itemname = item.inm {
                            txtItem.text = itemname
                        }else{
                            txtItem.text = "Unknown item"
                        }
                        self.removeOptionalView()
                        
                        let rate = getValueFromString(value: item.rate)
                        let discount = getValueFromString(value: item.discount)
                        let supplierCost = getValueFromString(value: item.supplierCost)
                        let qty = (txtQlt.text == "") ? "0.0" : txtQlt.text!
                        
                        itemID = item.itemId!
                        serialNoTxtFld.text = item.serialNo ?? ""
                        txtItem.text = item.inm ?? ""
                        txtQlt.text = "1"
                        txtTax.text = roundOff(value:Double("0.00")!)
                        txtRate.text = rate
                        txtRateIncTxt.text = rate
                        txtAmount.text = roundOff(value:Double("0.00")!)
                        txtDiscount.text = discount
                        txtDescription.text = item.ides ?? ""
                        txtPartno.text = item.pno ?? ""
                        txtUnit.text = item.unit ?? ""
                        txtHSNcode.text = item.hsncode ?? ""
                        txtSupplierPrice.text = supplierCost
                        
                        self.taxes = []
                        if item.tax != nil {
                            let itemDatas = (item.tax as! [AnyObject])
                            for itam1 in itemDatas {
                                guard let ijmt = itam1["rate"] as? String else { return  }
                                guard let ijmt1 = itam1["taxId"] as? String else { return  }
                                // print(ijmt)
                                txtTax.text = ijmt
                                globelCheckTxt = ijmt1
                            }
                            
                            for tax in self.taxListData  {
                                let data = itemDatas.filter{$0.taxId == tax.taxId}
                                if (data.count) > 0 {
                                    tax.value =  Double(getValueFromString(value: data[0].rate!))
                                }else{
                                    tax.value = Double(roundOff(value: 0.0))
                                }
                            }
                        }
                        
                        var totalTax : Double = Double(roundOff(value: 0.0))!
                        for tax in self.taxListData {
                            
                            let taxdetail = texDetail()
                            taxdetail.taxId = tax.taxId
                            taxdetail.txRate = getValueFromString(value: String(tax.value ?? 0.0))
                            totalTax = totalTax + (tax.value ?? 0.0)
                            self.taxes.append(taxdetail)
                        }
                        DispatchQueue.main.async {
                            self.taxTable.reloadData()
                        }
                        
                        let totalAmount =  calculateAmount(quantity: 1.0, rate: Double(rate)!, tax: Double(totalTax), discount: Double(discount)!)
                        txtAmount.text =  roundOff(value: totalAmount)
                        
                        let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: Double(totalTax))
                        txtTaxAmount.text = roundOff(value: taxAmount)
                        
                        
                    }else{
                        if self.filterItemList.count > 0 {
                            let item = isFilter ? filterItemList[indexPath.row] : filterItemList[indexPath.row]
                            if let itemname = item.inm {
                                txtItem.text = itemname
                            }else{
                                txtItem.text = "Unknown item"
                            }
                            
                            // let item = items[indexPath.row]
                            let rate = getValueFromString(value: item.rate)
                            let discount = getValueFromString(value: item.discount)
                            let supplierCost = getValueFromString(value: item.supplierCost)
                            let qty = (txtQlt.text == "") ? "0.0" : txtQlt.text!
                            
                            itemID = item.itemId!
                            serialNoTxtFld.text = item.serialNo ?? ""
                            txtItem.text = item.inm ?? ""
                            txtQlt.text =  "1"  //item.qty != "" ? ((Int(item.qty!)! > 0) ? item.qty : "1")   : "1"
                            txtTax.text =  roundOff(value:Double("0.00")!)
                            txtRate.text =  rate
                            txtRateIncTxt.text =  rate
                            txtAmount.text =  roundOff(value:Double("0.00")!)
                            txtDiscount.text = discount
                            txtDescription.text = item.ides ?? ""
                            txtPartno.text = item.pno ?? ""
                            txtUnit.text = item.unit ?? ""
                            txtHSNcode.text = item.hsncode ?? ""
                            txtSupplierPrice.text = supplierCost
                            
                            
                            self.taxes = []
                            if item.tax != nil {
                                let itemDatas = (item.tax as! [AnyObject])
                                for itam1 in itemDatas {
                                    guard let ijmt = itam1["rate"] as? String else { return  }
                                    guard let ijmt1 = itam1["taxId"] as? String else { return  }
                                    // print(ijmt)
                                    txtTax.text = ijmt
                                    
                                    globelCheckTxt = ijmt1
                                }
                                
                                for tax in self.taxListData  {
                                    let data = itemDatas.filter{$0.taxId == tax.taxId}
                                    if (data.count) > 0 {
                                        tax.value =  Double(getValueFromString(value: data[0].rate!))
                                    }else{
                                        tax.value = Double(roundOff(value: 0.0))
                                    }
                                }
                            }
                            
                            var totalTax : Double = Double(roundOff(value: 0.0))!
                            for tax in self.taxListData {
                                //Create taxDetail model for send on server
                                let taxdetail = texDetail() // for get model of tax
                                taxdetail.taxId = tax.taxId
                                taxdetail.txRate = getValueFromString(value: String(tax.value ?? 0.0))
                                totalTax = totalTax + (tax.value ?? 0.0)
                                self.taxes.append(taxdetail)
                            }
                            DispatchQueue.main.async {
                                self.taxTable.reloadData()
                            }
                            
                            //  txtTax.text = roundOff(value: totalTax)
                            
                            let totalAmount =  calculateAmount(quantity: 1.0, rate: Double(rate)!, tax: Double(totalTax), discount: Double(discount)!)
                            txtAmount.text =  roundOff(value: totalAmount)
                            // print("---- 5 \(self.txtAmount.text)")
                            // let taxAmount = calculateTaxAmount(amount: totalAmount, taxRateInPercentage: totalTax)
                            let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: Double(totalTax))
                            txtTaxAmount.text = roundOff(value: taxAmount)
                        }
                        
                    }
                }
            }
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
                //self.txtRateIncTxt.text =  rate
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
                    let taxdetail = texDetail() // for get model of tax
                    taxdetail.taxId = tax.taxId
                    taxdetail.txRate = getValueFromString(value: String(tax.value ?? 0.0))
                    totalTax = totalTax + (tax.value ?? 0.0)
                    self.taxes.append(taxdetail)
                }
                DispatchQueue.main.async {
                    self.taxTable.reloadData()
                }
                
                self.txtTax.text = roundOff(value: totalTax)
                
                
                let totalAmount =  calculateAmount(quantity: 1.0, rate: Double(rate)!, tax: Double(totalTax), discount: Double(discount)!)
                self.txtAmount.text =  roundOff(value: totalAmount)
              //  print("---- 6 \(self.txtAmount.text)")
                let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double("1")!, taxRateInPercentage: Double(self.txtTax.text ?? "0.0")!)
                self.txtTaxAmount.text = roundOff(value: taxAmount)
                
            }
            break
        }
        
        self.removeOptionalView()
        
        // showTaxDataOnTableViewJob(query : nil)
        
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
    
    
    //=======================================
    // MARK:- API method getLocationList
    //=======================================
    
    
    func getLocationList() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            killLoader()
            return
        }
        
        
        // showLoader()
        
        let  param  = Params()
        
        
        
        serverCommunicator(url: Service.getLocationList, param: nil) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(LocationListResp.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getLocationList)
                        if decodedData.data.count > 0 {
                            self.savegetLocationListInDataBase(data: decodedData.data)
                            
                        }
                        
                        
                        DispatchQueue.main.async {
                            self.showToast(message: "Report Download")
                            
                        }
                        
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                ShowError(message: AlertMessage.check_in_out_fail, controller: windowController)
            }
        }
        
    }
    
    
    
    //==============================
    // MARK:- Save data in DataBase
    //==============================
    func savegetLocationListInDataBase( data : [LocationList]) -> Void {
        // for jobs in data{
        let userJobs = DatabaseClass.shared.createEntity(entityName: "GetLocationList")
        // userJobs?.setValuesForKeys(jobs.toDictionary!)
        
        //   print("GetLocationListsave -----  \(userJobs)")
        //DatabaseClass.shared.saveEntity()
        // }
    }
    
    func getTitleList22() -> Void {
        let servicesList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "GetLocationList", query: nil) as! [GetLocationList]
        // print("GetLocationListget -----  \(servicesList)")
        
    }
    
    
    //=====================================
    // MARK:- Get Job Tittle  Service
    //=====================================
    
    func getJobTittle(){
        /*
         compId -> Company id
         limit -> limit
         index -> index value
         search -> search value
         dateTime -> date time
         
         */
        if !isHaveNetowork() {
            return
        }
        
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getJobTitleList) as? String
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "0"
        param.search = ""
        param.dateTime = lastRequestTime ?? ""
        
        serverCommunicator(url: Service.getJobTitleList, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ViewControllerResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        //Request time will be update when data comes otherwise time won't be update
                        UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getJobTitleList)
                        if decodedData.data?.count != 0 {
                            self.saveUserJobsTittleNmInDataBase(data: decodedData.data!)
                            
                        }
                        
                    }else{
                        //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        
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
                    //ShowAlert(title: "formate problem", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertControllerStyle.alert, callback: {_,_ in})
                }
            }else{
                //ShowAlert(title: "Network Error", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertControllerStyle.alert, callback: {_,_ in})
            }
        }
    }
    
    //==============================
    // MARK:- Save data in DataBase
    //==============================
    func saveUserJobsTittleNmInDataBase( data : [jobTittleListData]) -> Void {
        for jobs in data{
            let query = "jtId = '\(jobs.jtId!)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: query) as! [UserJobTittleNm]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                existingJob.setValuesForKeys(jobs.toDictionary!)
                getTitleList()
                //DatabaseClass.shared.saveEntity()
            }else{
                let userJobs = DatabaseClass.shared.createEntity(entityName: "UserJobTittleNm")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
                // DatabaseClass.shared.saveEntity()
            }
        }
        
        DatabaseClass.shared.saveEntity(callback: {_ in})
    }
    
    //=====================================
    // MARK:- get All Added Tags
    //=====================================
    
    func getItemParts(partItemId : String?){
        
        
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.jobTagList) as? String
        
        let param = Params()
        param.itemId = partItemId
        param.limit = "120"
        param.index = "0"
        
        serverCommunicator(url: Service.getItemParts, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(getItemPartsResp.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if let getItemPartsData = decodedData.data as? [getItemPartsData] {
                            self.getItemPartsArr = getItemPartsData
                            
                            DispatchQueue.main.async{
                                if self.getItemPartsArr.count > 0 {
                                    self.partItemVw.isHidden = false
                                }
                                self.partTableView.reloadData()
                            }
                        }
                        
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        if cancel {
                            showLoader()
                            //self.getItemParts()
                        }
                    })
                }
            }else{
                
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        //self.getItemParts()
                    }
                })
            }
            
        }
    }
}


extension ListItemVC : UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.partTableView {
       
            return self.getItemPartsArr.count
        } else {
            
            if isLocId == "0"{
                return self.taxListData.count
            }else{
                if isHiddenView == true {
                    return self.taxListData.count
                }else{
                    return NewtaxListData.count
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if tableView == self.partTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! InvoiceCell
            let aar = self.getItemPartsArr[indexPath.row]
            cell.lblName.text = aar.inm
            cell.qtyLbl.text = aar.qty
            cell.amountLbl.text = aar.rate
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "taxCell") as! TaxCell
            var locId = ""
            locId = UserDefaults.standard.value(forKey: "isLocId") as? String ?? ""
            
            var aaa = "0"
            
            if isLocId == "0"{
                let tax = self.taxListData[indexPath.row]
                cell.txtFieldPersentShow.text = "\(tax.label ?? "") " + "\(tax.percentage ?? "0.0")%"
                if inventrySearchBool == true{
                    if tax.taxId == globelCheckTxt {
                        cell.imgBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                    }else{
                        cell.imgBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                    }
                }
            }else{
                
                if isHiddenView == true {
                    let tax = self.taxListData[indexPath.row]
                    cell.txtFieldPersentShow.text = "\(tax.label ?? "") " + "\(tax.percentage ?? "0.0")%"
                }else{
                    let tax = self.NewtaxListData[indexPath.row]
                    cell.txtFieldPersentShow.text = "\(tax.label ?? "") " + "\(tax.percentage ?? "0.0")%"
                }
                
            }
            
            
            if inventrySearchBool == false{
                if isChecked != false {
                    if selectedRows.contains(indexPath.row){
                        
                        cell.imgBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                        
                    }else{
                        cell.imgBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                    }
                }else{
                    if selectedRows.contains(indexPath.row){
                        
                        cell.imgBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                        
                    }else{
                        cell.imgBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                    }
                }
            }
            
            cell.tapBtn.addTarget(self, action: #selector(buttonTapped( sender: )), for: .touchUpInside)
            cell.tapBtn.tag = indexPath.row
            cell.txtField.delegate = self
            cell.txtField.tag = indexPath.row + 1
            
            if isDisable == false {
                cell.txtField.isUserInteractionEnabled = false
                cell.txtField.textColor = UIColor.lightGray
            }
            
            if isHiddenView == true {
                if self.taxListData.count > 0 {
                    let obj = self.taxListData[indexPath.row]
                    print("taxListData obj.taxId is \(obj.taxId) and self.selectedTaxId is \(self.selectedTaxId)")
                    if self.selectedTaxId == obj.taxId {
                        cell.imgBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                    } else {
                        cell.imgBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                    }
                }
            } else {
                if self.NewtaxListData.count > 0 {
                    let obj = self.NewtaxListData[indexPath.row]
                    print("NewtaxListData obj.taxId is \(obj.taxId) and self.selectedTaxId is \(self.selectedTaxId)")
                    if self.selectedTaxId == obj.taxId {
                        cell.imgBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                    } else {
                        cell.imgBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                    }
                }
            }
            return cell
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
            let tax = self.taxListData[textField.tag-1]
            
            if  (textField.text?.count)! > 0 {
                tax.value = Double(textField.text!)!
            }else{
                tax.value = Double(roundOff(value: 0.0))!
                textField.text = roundOff(value:Double("0.00")!)
            }
        }
        
        if isCalculate {
            setCalculationForFinalAmount()
        }
    }
 
    @objc func buttonTapped(sender: UIButton) {

        self.taxtCancelBtn.isHidden = false
        inventrySearchBool = false
        taxes.removeAll()
        selectedRows.removeAll()
        selectData.removeAll()
        
        if isLocId == "0"{
                if self.selectedRows.contains(sender.tag){
                
                self.selectedRows.remove(at: self.selectedRows.firstIndex(of: sender.tag)!)
                var total_tax:Double = 0
                selectData.removeAll()
                for index in self.selectedRows {
                    let getValue = taxListData[index].percentage
                    var percent = (Double(getValue ?? "0.0"))
                    let getTaxId = taxListData[index].taxId
                    let taxdetail = texDetail() // for get model of tax
                    taxdetail.taxId = getTaxId
                    taxdetail.txRate = getValueFromString(value:getValue ?? "0.0")
                    taxes.append(taxdetail)
                    selectData.append(percent ?? 0.0)
                }
            
                for i in selectData{
                    total_tax = total_tax + (i)
                   
                }
                self.txtTax.text = String(total_tax)
                self.setCalculationForFinalAmount()
                self.taxTable.reloadData()
                
            }else  {
             
                self.selectedRows.append(sender.tag)
                var total_tax:Double = 0
                selectData.removeAll()
                for index in self.selectedRows {
                    let getValue = taxListData[index].percentage
                    let getTaxId = taxListData[index].taxId
                    var percent = (Double(getValue ?? "0.0"))
                    let taxdetail = texDetail() // for get model of tax
                    taxdetail.taxId = getTaxId
                    taxdetail.txRate = getValueFromString(value: String(getValue ?? "0.0" ))
                    taxes.append(taxdetail)
                    selectData.append(percent ?? 0.0)
                    if let taxId = getTaxId , taxId != "" {
                        self.selectedTaxId = taxId
                    }
                }
                
                for i in selectData {
                    total_tax = total_tax + (i)
                    
                }
                
                self.txtTax.text = String(total_tax)
                let totelText = Float((total_tax))
                let txtRateAm = Float(txtRate.text!)!
                let rateIn = txtRateAm + txtRateAm * totelText/100
                self.txtRateIncTxt.text = String(rateIn)
                self.setCalculationForFinalAmount()
                self.taxTable.reloadData()
                
            }
            
            DispatchQueue.main.async{
                self.taxTable.reloadData()
            }
            
        }else{
            
            if isHiddenView == true {
                
                if self.selectedRows.contains(sender.tag){
                    self.selectedRows.remove(at: self.selectedRows.firstIndex(of: sender.tag)!)
                    var total_tax:Double = 0
                    selectData.removeAll()
                    for index in self.selectedRows {
                        let getValue = taxListData[index].percentage
                        var percent = (Double(getValue ?? "0.0"))
                        let getTaxId = taxListData[index].taxId
                        let taxdetail = texDetail() // for get model of tax
                        taxdetail.taxId = getTaxId
                        taxdetail.txRate = getValueFromString(value:getValue ?? "0.0")
                        taxes.append(taxdetail)
                        selectData.append(percent ?? 0.0)
                    }
                    
                    for i in selectData{
                        total_tax = total_tax + (i)
                }
                    self.txtTax.text = String(total_tax)
                    self.setCalculationForFinalAmount()
                    self.taxTable.reloadData()
                    
                }else  {
                    
                    self.selectedRows.append(sender.tag) //when invoice redirection change selectedRows
                    var total_tax:Double = 0
                    selectData.removeAll()
                    self.arrTaxData.removeAll()
                    for index in self.selectedRows {
                        let getValue = taxListData[index].percentage
                        let getTaxId = taxListData[index].taxId
                        var percent = (Double(getValue ?? "0.0"))
                        let taxdetail = texDetail()
                        taxdetail.taxId = getTaxId
                        taxdetail.txRate = getValueFromString(value: String(getValue ?? "0.0" ))
                        taxes.append(taxdetail)
                        selectData.append(percent ?? 0.0)
                        let objTax = taxData()
                        objTax.taxId = getTaxId
                        objTax.rate = getValueFromString(value: String(getValue ?? "0.0" ))
                        objTax.tnm = taxListData[index].label
                        self.arrTaxData.append(objTax)
                        if let taxId = getTaxId , taxId != "" {
                            self.selectedTaxId = taxId
                        }
                    }
                    
                    for i in selectData {
                        total_tax = total_tax + (i)
                    }
                    self.txtTax.text = String(total_tax)
                    self.setCalculationForFinalAmount()
                    self.taxTable.reloadData()

                }
                
                DispatchQueue.main.async{
                    self.taxTable.reloadData()
                }
                
            }else{
                if self.selectedRows.contains(sender.tag){
                  
                    self.selectedRows.remove(at: self.selectedRows.firstIndex(of: sender.tag)!)
                    var total_tax:Double = 0
                    selectData.removeAll()
                    for index in self.selectedRows {
                        let getValue = NewtaxListData[index].percentage
                        var percent = (Double(getValue ?? "0.0"))
                        let getTaxId = NewtaxListData[index].taxId
                        let taxdetail = texDetail() // for get model of tax
                        taxdetail.taxId = getTaxId
                        taxdetail.txRate = getValueFromString(value:getValue ?? "0.0")
                        taxes.append(taxdetail)
                        selectData.append(percent ?? 0.0)
                    }
                    
                    for i in selectData{
                        total_tax = total_tax + (i)
                        
                    }
                    self.txtTax.text = String(total_tax)
                    self.setCalculationForFinalAmount()
                    self.taxTable.reloadData()
                    
                } else {
                    self.selectedRows.append(sender.tag) //when assign new item tax
                    var total_tax:Double = 0
                    selectData.removeAll()
                    self.arrTaxData.removeAll()
                    for index in self.selectedRows {
                        let getValue = NewtaxListData[index].percentage
                        let getTaxId = NewtaxListData[index].taxId
                        var percent = (Double(getValue ?? "0.0"))
                        let taxdetail = texDetail()
                        taxdetail.taxId = getTaxId
                        taxdetail.txRate = getValueFromString(value: String(getValue ?? "0.0" ))
                        taxdetail.label = NewtaxListData[index].label
                        taxes.append(taxdetail)
                        selectData.append(percent ?? 0.0)
                        let objTax = taxData()
                        objTax.taxId = getTaxId
                        objTax.rate = getValueFromString(value: String(getValue ?? "0.0" ))
                        objTax.tnm = NewtaxListData[index].label
                        self.arrTaxData.append(objTax)
                      
                        if let taxId = getTaxId , taxId != "" {
                            self.selectedTaxId = taxId 
                        }
                    }
                    
                    for i in selectData {
                        total_tax = total_tax + (i)
                }
                    
                    self.txtTax.text = String(total_tax)
                    let totelText = Float((total_tax))
                    let txtRateAm = Float(txtRate.text!)!
                    let rateIn = txtRateAm + txtRateAm * totelText/100
                    self.txtRateIncTxt.text = String(rateIn)
                    self.setCalculationForFinalAmount()
                    self.taxTable.reloadData()
                    
                }
                
                DispatchQueue.main.async{
                    self.taxTable.reloadData()
                }
            }
        }
    }

    
    func setCalculationForFinalAmount() -> Void {

        let tax = Double(getValueFromString(value: self.txtTax.text ?? "")) ?? 0.0
        let rate = Double(getValueFromString(value: self.txtRate.text ?? "")) ?? 0.0
        let quantity = Double(getValueFromString(value: self.txtQlt.text ?? "")) ?? 0.0
        let discount = Double(getValueFromString(value: self.txtDiscount.text ?? "")) ?? 0.0
        
        if let adminCalculationType = getDefaultSettings()?.disCalculationType , adminCalculationType == "0" {
            if let jobCalculationType = self.jobDetail.disCalculationType , jobCalculationType == "1" {
                let  result = calculateNormalDiscountAmount(quantity: quantity, rate: rate, tax: tax, discount: discount)
                self.txtRateIncTxt.text = roundOff(value: result.0)
                self.txtTaxAmount.text = roundOff(value: result.1)
                self.txtAmount.text = roundOff(value: result.2)
            } else {
                let result = calculateFlateDiscountAmount(quantity: quantity, rate: rate, tax: tax, discount: discount)
                self.txtRateIncTxt.text = roundOff(value: result.0)
                self.txtTaxAmount.text = roundOff(value: result.1)
                self.txtAmount.text = roundOff(value: result.2)
            }
        } else {
            if let jobCalculationType = self.jobDetail.disCalculationType , jobCalculationType == "1" {
                let  result = calculateNormalDiscountAmount(quantity: quantity, rate: rate, tax: tax, discount: discount)
                self.txtRateIncTxt.text = roundOff(value: result.0)
                self.txtTaxAmount.text = roundOff(value: result.1)
                self.txtAmount.text = roundOff(value: result.2)
            } else {
                let  result = calculatePercentageDiscountAmount(quantity: quantity, rate: rate, tax: tax, discount: discount)
                self.txtRateIncTxt.text = roundOff(value: result.0)
                self.txtTaxAmount.text = roundOff(value: result.1)
                self.txtAmount.text = roundOff(value: result.2)
            }
        }
    }
    
//    func calculateFinalAmount(quantity: Double, rate: Double, tax: Double, discount: Double) -> Double {
//        var finalAmount = Double()
//        if let enableCustomForm = jobDetail.disCalculationType { //getDefaultSettings()?.disCalculationType{ chng
//            if enableCustomForm == "0"{
//                let newRate = (rate - ((rate * discount) / 100));
//                finalAmount =  quantity * ( newRate + ((newRate * tax) / 100));
//                return finalAmount
//            }else{
//
//                let newRate = (rate);
//                finalAmount = quantity * ( newRate + ((newRate * tax) / 100)) - discount;
//                return finalAmount
//            }
//        }
//        return finalAmount
//    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == extraTxtFld {
            self.textFldTuchAct = true
     
        }else{
            self.textFldTuchAct = false
        
        }
     
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
  
    @objc func textFieldDidChange1(_ textField: UITextField) {
        self.txtRateIncTxt.text = self.txtRate.text
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        //calculationFunction()
        self.setCalculationForFinalAmount()
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
            }else if (textField == txtPartno) || (textField == txtHSNcode) || (textField == txtUnit)  || (textField == serialNoTxtFld){
                
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
            if result.count  == 0 {
                arrItemListOnlineOneItem.removeAll()
             
            }
            if result.count == 2 || result.count > 2 {
                switch selectedInvType {
                case .ITEM :
                    
                    isFilter = true
                    self.arrItemListOnline.removeAll()
                    self.getItems(txtSearch: result)
                    searchkey = result
                    
                    break
                    
                case .FIELDWORKER :
                    isFilter = true
                    self.filterFieldWorker(searchText: result)
                    break
                    
                case .SERVICE :
                    isFilter = true
                   
                    let removeTxt = result.replacingOccurrences(of: "\n", with: "")
                    self.filterTitles(searchText: removeTxt)
                    break
                }
                
            }else{
                self.removeOptionalView()
            }
        }
     
        return true
        
    }
 
    //================================================================================//
    // offline Delete Api calling function
    //================================================================================//
    
    
    func deletetemInviceOffline(itemdata: [String]){
        
        
        let  param  = Params()
        
        param.jobId = jobDetail.jobId
        param.ijmmId = itemdata //: []
       
        let dict =  param.toDictionary
        
        let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
        userJobs.apis = Service.deleteItemFromJob
        userJobs.parametres = dict?.toString
        
        userJobs.time = Date()
        
        DatabaseClass.shared.saveEntity(callback: {_ in
            DatabaseClass.shared.syncDatabase()
            deletedata(itemdata:itemdata)
            
        })
    }
    
    
    func deletedata(itemdata:[String]){
        let searchQuery = "jobId = '\(jobDetail.jobId ?? "")'"
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
                
            })
        }
        
    }
    
    
    func upDateItemInviceOffline(itemdata: DetailedItemData?){
        if isFistTimeAdd == false {
            isFistTimeAdd = true
            
            let itemDt = itemData()
            
            itemDt.itemId =  itemdata?.itemId
            itemDt.inm =  itemdata?.inm
            itemDt.des = itemdata?.des
            itemDt.qty =  itemdata?.qty
            itemDt.rate =  itemdata?.rate
            itemDt.discount = itemdata?.discount
            itemDt.serialNo = itemdata?.serialNo
           // itemDt.dataType = item[selectedIndex!].dataType
            if itemdata?.type != nil { 
                itemDt.dataType = itemdata?.type
            } else {
                itemDt.dataType = "1"
            }
            // itemDt.tax = itemdata.itemId
            itemDt.jobId = itemdata?.jobId
            //  itemDt.amount = itemdata?.amount
            itemDt.hsncode = itemdata?.hsncode
            itemDt.taxamnt = itemdata?.taxamnt
            
            itemDt.isBillable = itemdata?.isBillable
            itemDt.isBillableChange = itemdata?.isBillableChange
            
            itemDt.unit = itemdata?.unit
            itemDt.pno = itemdata?.pno
            itemDt.supplierCost = itemdata?.supplierCost
            itemDt.isGrouped = "0"
            itemDt.ijmmId = item[selectedIndex!].ijmmId ?? ""
            itemDt.itemType = selectedInvType.rawValue.description
            itemDt.type = selectedInvType.rawValue.description
            if self.arrTaxData.count > 0 {
                itemDt.tax = self.arrTaxData
            } else {
                itemDt.tax = []
            }

            let searchQuery = "jobId = '\(jobDetail.jobId ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                
                if existingJob.itemData != nil {
                    let item = (existingJob.itemData as! [AnyObject])
                    var arrItem = [Any]()
                    
                    for itam1 in item {
                        let ijmt = itam1["ijmmId"] as? String
                        if ijmt == itemDt.ijmmId{
                            
                            arrItem.append(itemDt.toDictionary as Any)
                        }else{
                            arrItem.append(itam1)
                        }
                    }
                    existingJob.itemData = arrItem as NSObject
                   
                }
                DatabaseClass.shared.saveEntity(callback: {_ in
                    
                })
                
            }
            
            let  param  = Params()
            
            param.jobId = jobDetail.jobId
            param.itemData = itemdata != nil ? [itemDt] : []
            param.groupData = []
            
            let dict =  param.toDictionary
          
            let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
            userJobs.apis = Service.updateItemInJobMobile
            userJobs.parametres = dict?.toString
            
            userJobs.time = Date()
            
            DatabaseClass.shared.saveEntity(callback: {_ in
                DatabaseClass.shared.syncDatabase()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            })
        }
        
    }
    
    func getTempIdForNewJob() -> String {
        
        return "Item-\(String(describing: getUserDetails()?.usrId ?? ""))-\(getCurrentTimeStamp())"
        
    }
    
    func addItemInviceOffline(itemdata: DetailedItemData?){
        if isFistTimeAdd == false {
            isFistTimeAdd = true
            let itemDt = itemData()
            itemDt.itemId = itemdata?.itemId
            itemDt.inm = itemdata?.inm
            itemDt.des = itemdata?.des
            itemDt.qty = itemdata?.qty
            itemDt.rate = itemdata?.rate
            itemDt.serialNo = itemdata?.serialNo
            itemDt.discount = itemdata?.discount
            itemDt.dataType = itemdata?.type
            
            itemDt.isBillable = itemdata?.isBillable
            itemDt.isBillableChange = itemdata?.isBillableChange
            // itemDt.tax = itemdata.itemId
            itemDt.jobId = itemdata?.jobId
            // itemDt.amount = itemdata?.amount
            itemDt.hsncode = itemdata?.hsncode
            itemDt.taxamnt = itemdata?.taxamnt
            itemDt.unit = itemdata?.unit
            itemDt.pno = itemdata?.pno
            itemDt.supplierCost = itemdata?.supplierCost
            itemDt.isGrouped = "0"
            itemDt.ijmmId = getTempIdForNewJob()
            itemDt.itemType = isNonInventory ? "1" : "0"
            itemDt.equId = itemdata?.equId
            
           
            itemDt.tax = []
            
            if let item = itemdata {
                for tax in (item.tax)! {
                    let tex = taxData()
                    
                     if (tax.txRate != "0.0000") && (tax.txRate != "0.000") && (tax.txRate != "0.00") && (tax.txRate != nil) {
                         tex.taxId = tax.taxId
                         tex.rate = tax.txRate
                         itemDt.tax?.append(tex)
                     }

                }
            }
            
            
            let searchQuery = "jobId = '\(jobDetail.jobId ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                
                if existingJob.itemData != nil {
                    var item = (existingJob.itemData as! [Any])
                    
                    item.append(itemDt.toDictionary as Any)
                   
                    existingJob.itemData = item as NSObject
                    
                } else {
                    existingJob.itemData = [itemDt.toDictionary] as NSObject
                }
                
                DatabaseClass.shared.saveEntity(callback: {_ in
                    
                })
                
            }
            
            
            let param = Params()
            if addEquipId == true {
            param.equId = eqIdparm
            }
            param.jobId = jobDetail.jobId
            

            param.itemData = itemdata != nil ? [itemDt] : []
            param.groupData = []
            
            let dict = param.toDictionary
          
            let ladksj = jobDetail.jobId!.components(separatedBy: "-")
            if ladksj.count > 0 {
                let tempId = ladksj[0]
                if tempId == "Job" {
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineJob") as! OfflineJob
                    userJobs.apis = Service.addItemOnJob
                    userJobs.parametres = dict?.toString
                    // print(dict)
                    userJobs.time = Date()
                    
                    DatabaseClass.shared.saveEntity(callback: {_ in
                        DatabaseClass.shared.syncDatabase()
                        // if self.callbackDetailVC != nil {
                        // callbackDetailVC!(false)
                        // }
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                    
                }else {
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
                    userJobs.apis = Service.addItemOnJob
                    userJobs.parametres = dict?.toString
                    // print(dict)
                    userJobs.time = Date()
                    
                    self.showToast(message: AlertMessage.add)
                    DatabaseClass.shared.saveEntity(callback: {_ in
                        DatabaseClass.shared.syncDatabase()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            if self.isAddEqup == true{
                               
                                let storyBoard : UIStoryboard = UIStoryboard(name: "MainJob", bundle:nil)
                                let addEqpmnt = storyBoard.instantiateViewController(withIdentifier: "AddEqupment") as! AddEqupment
                                addEqpmnt.objOfUserJodbList = self.jobDetail
                                addEqpmnt.itemName = self.txtItem.text ?? ""
                                addEqpmnt.tittelNm = self.hidenSigmentView
                             //   print(self.jobDetail.jobId)
                                self.navigationController?.pushViewController(addEqpmnt, animated: true)
                            
                            }else{
                                self.navigationController?.popViewController(animated: true)
                            }
                           
                        })
                    })
                }
            }
        }
        
    }
    
    func addServiceInviceOffline(itemdata: newItemData?){
        
        if isFistTimeAdd == false {
            isFistTimeAdd = true
            let itemDt = itemData()
            itemDt.itemId = itemdata?.itemId
            itemDt.inm = itemdata?.inm
            itemDt.des = itemdata?.ides
            itemDt.qty = itemdata?.qty
            itemDt.serialNo = itemdata?.serialNo
            
            itemDt.rate = itemdata?.rate
            itemDt.discount = itemdata?.discount
            itemDt.dataType = itemdata?.itype
            itemDt.type = itemdata?.itype
            itemDt.jobId = jobDetail.jobId
            // itemDt.amount = itemdata?.amount
            itemDt.hsncode = itemdata?.hsncode
            itemDt.taxamnt = itemdata?.taxamnt
            itemDt.unit = itemdata?.unit
            itemDt.pno = itemdata?.pno
            itemDt.supplierCost = itemdata?.supplierCost
            itemDt.isGrouped = "0"
            itemDt.jtId = itemdata?.jtId
            itemDt.ijmmId = getTempIdForNewJob()
            
            
            
            itemDt.tax = []
            
            if let item = itemdata {
                for tax in (item.tax)! {
                    let tex = taxData()
                    tex.taxId = tax.taxId
                    tex.rate = tax.txRate
                    itemDt.tax?.append(tex)
                }
            }
            
            
            let searchQuery = "jobId = '\(jobDetail.jobId ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                
                if existingJob.itemData != nil {
                    var item = (existingJob.itemData as! [Any])
                    
                    // let dic = ["itemId":"","inm":"","des":"","qty":"","discount":"","rate":"","dataType":"","jobId":"","hsncode":"","taxamnt":""]
                    item.append(itemDt.toDictionary as Any)
                    
                    //      print(item.count)
                    existingJob.itemData = item as NSObject
                    // print(item)
                    
                }else{
                    existingJob.itemData = [itemDt.toDictionary] as NSObject
                }
                
                
                
                // existingJob.setValuesForKeys(param.toDictionary!)
                
                //existingJob.kpr = (FltWorkerId.count == 0 ? [] : FltWorkerId) as NSObject?
                
            }
            
            let param = Params()
            
            param.jobId = jobDetail.jobId
            param.itemData = itemdata != nil ? [itemDt] : []
            param.groupData = []
            
            let dict = param.toDictionary
            
            // print(dict)
            
            let ladksj = jobDetail.jobId!.components(separatedBy: "-")
            if ladksj.count > 0 {
                let tempId = ladksj[0]
                if tempId == "Job" {
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineJob") as! OfflineJob
                    userJobs.apis = Service.addItemOnJob
                    userJobs.parametres = dict?.toString
                    // print(dict)
                    userJobs.time = Date()
                    
                    DatabaseClass.shared.saveEntity(callback: {_ in
                        DatabaseClass.shared.syncDatabase()
                        // if self.callbackDetailVC != nil {
                        // callbackDetailVC!(false)
                        // }
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                    
                } else {
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList
                    userJobs.apis = Service.addItemOnJob
                    userJobs.parametres = dict?.toString
                    
                    userJobs.time = Date()
                    
                    DatabaseClass.shared.saveEntity(callback: {_ in
                        DatabaseClass.shared.syncDatabase()
                        // if self.callbackDetailVC != nil {
                        // callbackDetailVC!(false)
                        // }
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                }
            }
            
        }
        
        
    }
    
    func addItemInInvoice(newItem: newItemData?, itemdata: DetailedItemData?) -> Void {
        
        
        //        if !isHaveNetowork() {
        //            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
        //            return
        //        }
        
        let itemDt = itemData()
        itemDt.itemId = itemdata?.itemId
        itemDt.inm = itemdata?.inm
        itemDt.desc = itemdata?.des
        itemDt.jobId = itemdata?.jobId
        itemDt.qty = itemdata?.qty
        itemDt.rate = itemdata?.rate
        itemDt.discount = itemdata?.discount
        itemDt.type = itemdata?.type
        itemDt.isGroup = "0"
        itemDt.tax = []
        
        if let item = itemdata {
            for tax in (item.tax)! {
                let tex = taxData()
                tex.taxId = tax.taxId
                tex.txRate = tax.txRate
                itemDt.tax?.append(tex)
            }
        }
   
        let  param  = Params()
        param.parentId = ""
        param.invId = ""
        param.jobId = jobDetail.jobId
        param.cltId =  ""
        param.nm = jobDetail.nm
        param.pro = ""
        param.compId = getUserDetails()?.compId
        param.invType = "1"
        param.adr = jobDetail.adr
        param.discount = "0"
        param.total = txtAmount.text
        param.note = ""
        param.paid = ""
        param.pono = ""
        param.invDate = convertSystemDateIntoLocalTimeZoneWithStaticTime(date: Date())
        param.dueDate = convertSystemDateIntoLocalTimeZoneWithStaticTime(date: Date())
        param.newItem = newItem != nil ? ([newItem] as! [newItemData]) : []
        param.itemData = itemdata != nil ? [itemDt] : []
        param.groupByData = []
        param.changeState = "0"
        param.cur = "" // currently by default 0
        param.isShowInList = "0"
        
       
        serverCommunicator(url: Service.addInvoice, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(InvoiceResponse.self, from: response as! Data) {
                    // print(decodedData)
                    
                    if decodedData.success == true{
                        if decodedData.data != nil{
                            self.invoiceRes!.success = decodedData.success
                            self.invoiceRes!.message = decodedData.message
                            self.invoiceRes!.data = decodedData.data
                            
                            if self.callbackDetailVC != nil {
                                self.callbackDetailVC!(false)
                            }
                        }
                        DispatchQueue.main.async{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
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

