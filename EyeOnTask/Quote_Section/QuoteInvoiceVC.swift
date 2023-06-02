//
//  QuoteInvoiceVC.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 12/07/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import JJFloatingActionButton

class QuoteInvoiceVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,OptionViewDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var printview: UIView!
    @IBOutlet weak var lblquoteview: UILabel!
    @IBOutlet weak var txtquote: UITextField!
    @IBOutlet weak var btnquote: UIButton!
    @IBOutlet weak var btnPayPopup: UIButton!
    @IBOutlet weak var txtPayFullpop: UITextField!
    @IBOutlet weak var txtPayPartialpop: UITextField!
    @IBOutlet weak var lblPyPrtlPopUp: UILabel!
    @IBOutlet weak var lblPyFullPopUp: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblInvoiceDate: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var listItemView: UIView!
    @IBOutlet weak var H_address: NSLayoutConstraint!
    @IBOutlet weak var H_Name: NSLayoutConstraint!
    @IBOutlet weak var H_gstnumber: NSLayoutConstraint!
    @IBOutlet weak var alertLogo: UILabel!
    @IBOutlet weak var backGroubdView: UIView!
    @IBOutlet weak var deleteCellBtn: UIButton!
    @IBOutlet weak var viewDateDtl: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var arryCount: UILabel!
    @IBOutlet weak var deleteCellImg: UIImageView!
    @IBOutlet weak var createdDateLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var compninameLbl: UILabel!
    @IBOutlet weak var adrsLbl: UILabel!
    @IBOutlet weak var lblGst: UILabel!
    
    var templateVelue = ""
    var templateId = ""
    let cellReuseIdentifier = "cell"
    var optionalVw : OptionalView?
    var sltDropDownTag : Int!
    var refreshControl = UIRefreshControl()
    var selectedRows:[Int] = []
    var quotationRes = QuotationDetailRes()
    var quotationData : QuotationData!
    var selectedCell : IndexPath? = nil
    var isDisable = true
    var QuotaTemplateArr = [JobCardTemplat2]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        getQuotaTemplates()
        self.backgroundView.isHidden = true

        self.title = LanguageKey.quote_detail
        self.lblDueDate.text = LanguageKey.quotes_end_date
        self.lblInvoiceDate.text = LanguageKey.quotes_start_date
        
        nameLbl.text = quotationData.nm
        compninameLbl.text = quotationData.adr
        self.dueDateLbl.text = convertTimestampToDateForPayment(timeInterval: (quotationData.duedate)!)
        self.createdDateLbl.text = convertTimestampToDateForPayment(timeInterval: (quotationData.quotDate)!)
        amountLbl.text = roundOff(value: Double(quotationData.total ?? "0.0")!)
        adrsLbl.text = " "
        
        let actionButton = JJFloatingActionButton()
        actionButton.buttonAnimationConfiguration = .rotation(toAngle: 0.0)
        actionButton.buttonImage = UIImage(named: "FloatIcon")
        actionButton.itemAnimationConfiguration = .slideIn(withInterItemSpacing: 20)
        actionButton.buttonColor  = UIColor(red: 55.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1.0)
        
        isDisable = compPermissionVisible(permission: compPermission.isItemEnable)

        if isDisable {
            actionButton.addItem(title: LanguageKey.add_new_item , image: UIImage(named: "floatNewitem")?.withRenderingMode(.alwaysOriginal)) { item in
               
                if !isHaveNetowork() {
                    ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    return
                }
                 ActivityLog(module:Modules.quaotation.rawValue , message: ActivityMessages.quoteAddNewProduct)
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.performSegue(withIdentifier: "add", sender: nil)
            }
        }
        
        
        actionButton.addItem(title: LanguageKey.print_quote, image: UIImage(named: "floatPrint")?.withRenderingMode(.alwaysOriginal)) { item in
           
            if !isHaveNetowork() {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                return
            }
            
            self.backgroundView.isHidden = false
            self.printview.isHidden = false
            self.openbackgorunVw()
        }
        
        actionButton.addItem(title: LanguageKey.email_quote, image: UIImage(named: "floatEmail")) { item in
            
            if !isHaveNetowork() {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                return
            }
            
            ActivityLog(module:Modules.quaotation.rawValue , message: ActivityMessages.quoteEmail)
            let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EMAILINVOICE") as! EmailInvoiceVC
            vc.invoiceid = (self.quotationRes.data?.quotId)!
            vc.isInvoice = false
            vc.arrayTypeBool = true
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
        actionButton.addItem(title: LanguageKey.quote_to_job , image: UIImage(named: "floatNewitem")) { item in
            if !isHaveNetowork() {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                return
            }
            
             self.convertQuotationToJob()
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
        
        //  actionButton.display(inViewController: self)
        
        
        // self.height_HeaderView.constant = 140.0
        
        // createdDateLbl.text = schStartDate(timeInterval: (stu?.data?.createdate!)!)
        // self.createdDateLbl.text = dateFormateWithMonthandDayAndYears(timeInterval: ((stu?.data?.duedate)!))
        
        //-----------text height scroll method -------------
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 165
        
        backGroubdView.isHidden = true
        
        if isDisable == false {
            deleteCellBtn.isHidden = true
            deleteCellImg.isHidden = true
        }
        
        
        self.viewDateDtl.layer.cornerRadius = 20
        self.viewDateDtl.layer.shadowColor = UIColor.black.cgColor
        self.viewDateDtl.layer.shadowOpacity = 0.5
        self.viewDateDtl.layer.shadowRadius = 7
        
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        showLoader()
        self.getQuotationRecord()
        
        ActivityLog(module:Modules.quaotation.rawValue , message: ActivityMessages.quoteDetails)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //showLoader()
        // getQuotationRecord()
        
        self.backgroundView.isHidden = true
        if self.parent?.navigationItem.rightBarButtonItem == nil {
            let image = UIImage(named:"Edit.png")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        }
        
        
    }
    
    func setLocalization() -> Void {
        lblquoteview.text = LanguageKey.select_template
        btnquote.setTitle(LanguageKey.print_quote , for: .normal)
    }
    
    func openbackgorunVw(){
        self.showBackgroundView()
        view.addSubview(self.printview)
        printview.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
    }
    
    @objc func refreshControllerMethod() {
         getQuotationRecord()
    }
    
    
    @objc func addTapped() -> Void {
        performSegue(withIdentifier: "editQuote", sender: nil)
    }
    
    @IBAction func btnquote(_ sender: Any) {
        
        ActivityLog(module:Modules.quaotation.rawValue , message: ActivityMessages.quotePrint)
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pdfvc") as! ShowPdfVC
        vc.invoiceid = (self.quotationRes.data?.quotId)!
        vc.invoiceCode = (self.quotationRes.data?.label)!
        vc.isInvoice = false
        vc.templateIdPrint = templateId
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
        self.backgroundView.isHidden = true
        self.printview.isHidden = true
        removeOptionalView()
        hideBackgroundView()
        
    }
       
       @IBAction func btndrop(_ sender: UIButton) {
           self.sltDropDownTag = sender.tag
           switch  sender.tag {
           case 0:
               
               if(self.optionalVw == nil){
                   
                   //  arrOfShowData = getJson(fileName: "location")["Server_location"] as! [Any]
                   self.openDwopDown( txtField: self.txtquote, arr: QuotaTemplateArr)
                   
               }else{
                   self.removeOptionalView()
               }
               
               break
               
               
           default:
             //  print("Defalt")
               break
               
           }
       }
    
    @IBAction func deleteCellBtnActn(_ sender: UIButton) {
        
        if self.selectedRows.count == 0 {
            return
        }
        
        if (self.selectedRows.count == self.quotationRes.data?.invData?.itemData?.count){
            ShowAlert(title: nil , message: AlertMessage.itemRemoveAllItem, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (_,_) in }
            return
        }
        
        
        
        ShowAlert(title:LanguageKey.confirmation , message: AlertMessage.itemRemove, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.remove as NSString, style: .alert) { (cancel, remove) in
            if remove {
                
                var selectedItems: [String] = []
                self.selectedRows = self.selectedRows.sorted(by: >)
                let items = self.quotationRes.data?.invData?.itemData!
                for index in  self.selectedRows  {
                    selectedItems.append(items![index].iqmmId!)
                }
                
                self.selectedRows.removeAll()
                self.deleteItemsOnServer(items: selectedItems)
                self.deleteCellImg.image = UIImage(named: "trash")
            }
        }
    }
    
    //======================================================
    // MARK: Optional View method
    //======================================================
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
  
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return QuotaTemplateArr.count
      }
      
      func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
          if(cell == nil){
              cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
          }
          
          
          cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
          cell?.backgroundColor = .clear
         
          cell?.textLabel?.textColor = UIColor.darkGray
          if QuotaTemplateArr.count != 0 {
          cell?.textLabel?.text = QuotaTemplateArr[indexPath.row].tempJson1?.quoDetail![0].inputValue
        //  cell?.textLabel?.text = status?.capitalizingFirstLetter()
          }
         
          return cell!
      }
      
      func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          self.txtquote.text = QuotaTemplateArr[indexPath.row].tempJson1?.quoDetail![0].inputValue
          self.templateId = QuotaTemplateArr[indexPath.row].quoTempId ?? ""
          self.removeOptionalView()
      }
      
     
    func showBackgroundView() {
        backgroundView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.backgroundColor = UIColor.black
            self.backgroundView.alpha = 0.5
        })
    }
    
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
            self.optionalVw?.removeFromSuperview()
            self.optionalVw = nil
        }
    }
    
    func hideBackgroundView() {
        
        if ((optionalVw) != nil){
            removeOptionalView()
        }
        
        if (printview != nil) {
            printview.removeFromSuperview()
        }
        
        self.backgroundView.isHidden = true
        self.backgroundView.backgroundColor = UIColor.clear
        self.backgroundView.alpha = 1
    }
    //======================================================
    // MARK: Segue method
    //======================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            ActivityLog(module:Modules.quaotation.rawValue , message: ActivityMessages.quoteUpdateProduct)
            if let addVC = segue.destination as? QuoteAddEditItem {
                addVC.isAdd = true
                addVC.quoteDetails = self.quotationRes.data
                addVC.callbackDetailVC = {( _ : Bool) in
                    //showLoader()
                    self.getQuotationRecord()
                }
            }
        }else
            if segue.identifier == "editQuote" {
                
            ActivityLog(module:Modules.quaotation.rawValue , message: ActivityMessages.quoteUpdate)
            let addQuoteVC = segue.destination as! AddQuoteVC
            addQuoteVC.quoteDetailData = quotationRes.data
            addQuoteVC.callbackForQuoteInvVC = {(isBack : Bool) -> Void in
               // print("Recieve callback from edit quote")
                //showLoader()
                self.getQuotationRecord()
            }
        }
            
    }
    
    //======================================================
    // MARK: Get Invoice Data
    //======================================================
    func getQuotationRecord() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            return
        }
        
       
        let param = Params()
        param.quotId = quotationData?.quotId
        
      //  print("====================quotationData?.quotId\(quotationData?.quotId)")
        
        
         serverCommunicator(url: Service.getQuoteDetailForMobile, param: param.toDictionary) { (response, success) in
            killLoader()
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(QuotationDetailRes.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        self.quotationRes = decodedData
                        
                        if let taxType = self.quotationRes.data?.invData?.taxCalculationType {
                            taxCalculationType = taxType
                        }else{
                            taxCalculationType = "0"
                        }
  
                        self.setupInvoiceResponseModel()
                    }else{
                        if (decodedData.statusCode != nil) && decodedData.statusCode == "401" {
                            ShowAlert(title:  getServerMsgFromLanguageJson(key: decodedData.message!) , message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
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
    
    func setupInvoiceResponseModel() -> Void {
        
        if let data =  self.quotationRes.data{
            
            self.setAddress(data: data)
           
            for item in (self.quotationRes.data?.invData?.itemData)! {
                var tax : Double = 0.0
                for tx in item.tax! {
                    tax = tax + Double((tx.rate == "") ? roundOff(value:Double("0.00")!) : tx.rate!)!
                }
                let qty = (item.qty == "") ? "0" : item.qty!
                let rate = (item.rate == "") ? "0.0" : item.rate!
                let discount = (item.discount == "") ? "0.0" : item.discount!
               
                if let enableCustomForm = getDefaultSettings()?.disCalculationType{ //This is round off digit for invoice
                    if enableCustomForm == "0"{
                        let totalAmount = calculateAmount(quantity: Double(qty)!, rate: Double(rate)!, tax: tax, discount: Double(discount)!)
                        item.amount = roundOff(value: totalAmount)
                        
                        let taxAmount = calculateTaxAmount(rate: Double(rate)!,qty: Double(qty)!, taxRateInPercentage: tax)
                        
                        item.taxamnt = roundOff(value: taxAmount)
                        
                    }else{
                        let totalAmount = calculateAmountFlateDiscount(quantity: Double(qty)!, rate: Double(rate)!, tax: tax, discount: Double(discount)!)
                        item.amount = roundOff(value: totalAmount)
                        
                        let taxAmount = calculateTaxAmount(rate: Double(rate)!,qty: Double(qty)!, taxRateInPercentage: tax)
                        
                        item.taxamnt = roundOff(value: taxAmount)
                   
                    }
                }
            
            }
            
            DispatchQueue.main.async{
                self.amountLbl.text = roundOff(value: Double(data.invData?.total ?? "0.0")!)
                self.dueDateLbl.text = convertTimestampToDateForPayment(timeInterval: (data.invData?.duedate)!)
                self.createdDateLbl.text = convertTimestampToDateForPayment(timeInterval: (data.invData?.invDate)!)
                self.arryCount.text = "\(LanguageKey.list_item) \((data.invData?.itemData?.count)!)"

                if self.quotationRes.data?.invData?.itemData!.count == 0 && self.quotationRes.data?.invData?.shippingItem!.count == 0{
                    self.showNoDataAlert()
                }else{
                    self.hideNoDataAlert()
                }
                self.tableView.reloadData()
            }
        }else{
            self.showNoDataAlert()
        }
        
    }
    
    
    func setAddress(data : QuotationDetailData) -> Void {
        
        var address = ""
        if (data.city != nil) && (data.city != "") {
            address = data.city!
        }
        
        if (data.ctrynm != nil) && (data.ctrynm != "") {
            if address.count > 0 {
                address =  address + " \(data.ctrynm!)"
            }else{
                address = data.ctrynm!
            }
        }
        
        DispatchQueue.main.async {
            
            if let name = data.nm{
                
                if name.count > 0 {
                    self.nameLbl.text = name.capitalizingFirstLetter()
                }else{
                    self.H_Name.constant = 0.0
                }
            }else{
                self.nameLbl.text = "Unknown"
            }
            
            if (data.adr != nil) && (data.adr != "") {
                self.compninameLbl.text = data.adr!
            }else{
                self.H_address.constant = 0.0
            }
            
            
            let attributedString = NSMutableAttributedString(string: address.capitalizingFirstLetter())
            
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 6 // Whatever line spacing you want in points
            
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            // *** Set Attributed String to your label ***
            self.adrsLbl.attributedText = attributedString
        }
    }
    
    
    
    //======================================================
    // MARK: Convert Quotation To Job
    //======================================================
    
    func convertQuotationToJob() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            return
        }
        
        
         showLoader()
        let param = Params()
        param.quotId = quotationData?.quotId
        
        serverCommunicator(url: Service.convertQuotationToJob, param: param.toDictionary) { (response, success) in
            killLoader()
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AddQuoteResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        //print("Successfully converted")
                        self.showToast(message: getServerMsgFromLanguageJson(key: decodedData.message!)!)
                       //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }else{
                         ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
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
    
    
    //======================================================
    // MARK: Convert Quotation To Job
    //======================================================
    
    func deleteItemsOnServer(items:[String]) {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            return
        }
        
        
        showLoader()
        let param = Params()
        param.iqmmId = items
        param.invId = quotationRes.data?.invData?.invId
        //iqmmId -> quotation item id (In array)
        
        serverCommunicator(url: Service.deleteQuotItemForMobile, param: param.toDictionary) { (response, success) in
            
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AddQuoteResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        self.getQuotationRecord()
                    }else{
                        killLoader()
                        ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        self.showNoDataAlert()
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
    
    
    //======================================================
    // MARK: Show hide alert
    //======================================================
    
    func showNoDataAlert() -> Void {
        DispatchQueue.main.async{
            //self.topView.isHidden = true
            self.listItemView.isHidden = true
            self.alertMessage.isHidden = false
            self.alertLogo.isHidden = false
            self.alertMessage.text =  AlertMessage.noneitems
        }
    }
    
    func hideNoDataAlert() -> Void {
        DispatchQueue.main.async{
            //self.topView.isHidden = false
            self.listItemView.isHidden = false
            self.alertMessage.isHidden = true
            self.alertLogo.isHidden = true
            self.alertMessage.text =  AlertMessage.noneitems
        }
    }
    
    //============================
    //MARK: Table View Delegate
    //============================
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            
            if let items = self.quotationRes.data?.invData?.shippingItem{
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
            return self.quotationRes.data?.invData?.itemData! == nil ? 0 :  (self.quotationRes.data?.invData?.itemData?.count)!
        }else{
            return self.quotationRes.data?.invData?.shippingItem == nil ? 0 :  (self.quotationRes.data?.invData?.shippingItem?.count)!
        }
        
        
       
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! InvoiceCell
            let aar = self.quotationRes.data?.invData?.itemData?[indexPath.row]
            if selectedCell == indexPath {
                cell.view.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            }else{
                cell.view.backgroundColor = UIColor.white
            }

            var myrate = aar!.rate
            if (myrate?.count)! > 0 {
                myrate = roundOff(value: Double(myrate!)!)
            }else{
                myrate = roundOff(value:Double("0.00")!)
            }


            var mydiscount = aar!.discount
            if (mydiscount?.count)! > 0 {
                mydiscount = roundOff(value: Double(mydiscount!)!)
            }else{
                mydiscount = roundOff(value:Double("0.00")!)
            }



            cell.lblName.text = aar?.inm?.capitalized
            cell.desLbl.text = aar?.des?.capitalized

            let qty = LanguageKey.qty

            cell.qtyLbl.text = "\(qty): " + aar!.qty!
            cell.amountLbl.text = (aar?.amount)!

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
        
        
            cell.isUserInteractionEnabled = true
            return cell
       }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "shipCell",for: indexPath) as! ShippingItemCell
            let shippingItem = self.quotationRes.data?.invData?.shippingItem![indexPath.row]
            cell.itemName.text = shippingItem?.inm
            //cell.desLbl.text = shippingItem?.des?.capitalized
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            return
        }
        
        let itemDetailVC = storyboard?.instantiateViewController(withIdentifier: "quoteAddItem") as! QuoteAddEditItem
        if (selectedCell != nil) {

            //If selected cell exist on visible indexpaths
            let isExist = tableView.indexPathsForVisibleRows?.contains(selectedCell!)
            if isExist!{
                let cellPrevious = tableView.cellForRow(at: selectedCell!) as! InvoiceCell
                cellPrevious.view.backgroundColor = .white
            }
        }

        let cell = tableView.cellForRow(at: indexPath) as! InvoiceCell
        cell.view.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.selectedCell = indexPath

        itemDetailVC.selectedIndex = indexPath.row
        itemDetailVC.quoteDetails = self.quotationRes.data
        itemDetailVC.isAdd = false
        itemDetailVC.callbackDetailVC =  {(isDelete : Bool) -> Void in
            if isDelete {
                let item = self.quotationRes.data?.invData?.itemData![indexPath.row]
                 showLoader()
                self.deleteItemsOnServer(items: [item!.iqmmId!])
            }else{
               // showLoader()
                self.getQuotationRecord()
            }
        }

        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
    
    
    @objc func buttonTapped(sender: UIButton) {
        
        if self.selectedRows.contains(sender.tag){
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: sender.tag)!)
        }else  {
            self.selectedRows.append(sender.tag)
        }
        
        if  selectedRows.count == 0 {
            deleteCellImg.image = UIImage(named: "trash")
        } else{
            deleteCellImg.image = UIImage(named: "trash (2)")
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        
    }
    
    
    //=====================================
    // MARK:- getQuotaTemplates  Service
    //=====================================
    
     func getQuotaTemplates(){

            serverCommunicator(url: Service.getQuotaTemplates, param: nil) { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(QuotaTemplateRs.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            self.QuotaTemplateArr = decodedData.data as! [JobCardTemplat2]
                            DispatchQueue.main.async {
                                let arr = self.QuotaTemplateArr[0]
                                //print( "\(String(describing: arr.tempJson1?.quoDetail![0].inputValue ?? ""))")
                                self.templateVelue = "\(String(describing: arr.tempJson1?.quoDetail![0].inputValue ?? ""))"
                                self.txtquote.text = self.templateVelue
                                self.templateId = arr.quoTempId ?? ""
                            }
                            
                        }else{
                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{
                        
                       // ShowError(message: AlertMessage.formatProblem, controller: windowController)
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
                }
            }
            
        }
    

}
