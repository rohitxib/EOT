//
//  InvoiceVC.swift
//  EyeOnTask
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//
import UIKit
import JJFloatingActionButton

class InvoiceVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,OptionViewDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var printView: UIView!
    @IBOutlet weak var lblInvoiceView: UILabel!
    @IBOutlet weak var txtInvoice: UITextField!
    @IBOutlet weak var btnInvoice: UIButton!
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
    @IBOutlet weak var lblGst: UILabel!
    
    var InvoiceTemplateArr = [JobCardTemplat1]()
    var templateVelue = ""
    var templateId = ""
    let cellReuseIdentifier = "cell"
    var optionalVw : OptionalView?
    var sltDropDownTag : Int!
    var displayMsg = ""
    let loc_listItem = LanguageKey.list_item
    var refreshControl = UIRefreshControl()
    var isDelete : Bool!
    var invoiceRes = InvoiceResponse()
    var selectedRows:[Int] = []
    var objOfUserJobListInDetail : UserJobList!
    var chatConPosition : Int = 0
    var selectedCell : IndexPath? = nil
    var currency = ""
    var isDisable = true
    var itemDetailedDatanew = [DetailedItemData]()
    var itemDetailedData = [ItemDic]()
    var isHidenBillableView = true
    var invoiceId = ""
    var addNewInvc = false
    var count : Int = 0
    var isUserfirstLogin = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        getJobListService()
        setLocalization()
        self.backgroundView.isHidden = true
        getInvoiceTemplates()
        //print(objOfUserJobListInDetail)
        if addNewInvc == true {
            self.setupInvoiceResponseModel()
        }else{
            getInvoiceRecordnew()
        }
      
        
       // print(invoiceRes.data)
        self.title = LanguageKey.title_invoice
        self.lblDueDate.text = LanguageKey.due_date
        self.lblInvoiceDate.text = LanguageKey.invoice_date
        
        let actionButton = JJFloatingActionButton()
        actionButton.buttonAnimationConfiguration = .rotation(toAngle: 0.0)
        actionButton.buttonImage = UIImage(named: "FloatIcon")
        actionButton.itemAnimationConfiguration = .slideIn(withInterItemSpacing: 20)
        actionButton.buttonColor  = UIColor(red: 55.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1.0)
    
        isDisable = compPermissionVisible(permission: compPermission.isItemEnable)

        if isDisable {
            actionButton.addItem(title: LanguageKey.add_new_item , image: UIImage(named: "floatNewitem")?.withRenderingMode(.alwaysOriginal)) { item in
                
                if self.invoiceRes.data ==  nil {
                    ShowAlert(title: LanguageKey.dialog_error_title, message: LanguageKey.offline_feature_alert, controller: windowController, cancelButton: nil, okButton: LanguageKey.ok as NSString, style: .alert) { (cancel, ok) in
                        if ok  {
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    return
                }
                
                ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoiceAddNewProduct)
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.performSegue(withIdentifier: "add", sender: nil)
            }
        }
       

        actionButton.addItem(title: LanguageKey.print_invoice, image: UIImage(named: "floatPrint")?.withRenderingMode(.alwaysOriginal)) { item in
            // do something
            self.backgroundView.isHidden = false
            self.printView.isHidden = false
            self.openbackgorunVw()
      
        }

        actionButton.addItem(title: LanguageKey.email_invoice, image: UIImage(named: "floatEmail")) { item in
            // do something
            ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoiceEmail)
            let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EMAILINVOICE") as! EmailInvoiceVC
            vc.invoiceid = (self.invoiceRes.data?.invId)!
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
            self.navigationController!.pushViewController(vc, animated: true)
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
        ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoice)
        NotiyCenterClass.fireRefreshInvoiceAmount(vc: self, selector: #selector(self.updateInvoiceAmount(_:)))
    }
    
    @objc func updateInvoiceAmount(_ notification: NSNotification) {
        self.getInvoiceRecordnew()
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.title_invoice
        lblInvoiceView.text = LanguageKey.select_template
        btnInvoice.setTitle(LanguageKey.print_invoice , for: .normal)
    }
    
    @objc func refreshControllerMethod() {
       // getInvoiceRecord()
        getItemListRecord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.navigationItem.title = LanguageKey.title_invoice
        setData()
        if  self.itemDetailedData.count == 0{
           // let data =  self.invoiceRes.data
          //  self.amountLbl.text = roundOff(value: Double(data!.total ?? "0.0")!)
            showNoDataAlert()
        }else{
            hideNoDataAlert()
        }
         getItemListRecord()
        self.getInvoiceRecordnew()
    }

    
    @IBAction func tapOnBackgrounVw(_ sender: Any) {
//        hideBackgroundView()
//        self.backgroundView.isHidden = true
//        self.printView.isHidden = true
    }
    
    @IBAction func btnInvoicePrint(_ sender: Any) {
        
        ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoicePrint)
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pdfvc") as! ShowPdfVC
        vc.invoiceid = (self.invoiceRes.data?.invId)!
        vc.invoiceCode = (self.invoiceRes.data?.code)!
        vc.templateIdPrint = templateId
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
        self.backgroundView.isHidden = true
        self.printView.isHidden = true
        removeOptionalView()
        hideBackgroundView()
        
    }
       
       @IBAction func btnInvoicedrop(_ sender: UIButton) {
           self.sltDropDownTag = sender.tag
           switch  sender.tag {
           case 0:
               
               if(self.optionalVw == nil){
                   
                   //  arrOfShowData = getJson(fileName: "location")["Server_location"] as! [Any]
                   self.openDwopDown( txtField: self.txtInvoice, arr: InvoiceTemplateArr)
                   
               }else{
                   self.removeOptionalView()
               }
               
               break
               
               
           default:
              // print("Defalt")
               break
               
           }
       }
    
    func setData(){
              itemDetailedData.removeAll()
        if objOfUserJobListInDetail.itemData != nil {
            for item in (objOfUserJobListInDetail.itemData as! [AnyObject]) {
                
                //  print(item)
                if let dta = item as? itemData {
                    
                    //   print(dta)
                    
                }else{
                    if item["tax"] != nil {
                        let tax =  item["tax"] as! [AnyObject]
                        if tax.count > 0 {
                            var arrTac = [texDic]()
                            for taxDic in tax {
                                arrTac.append(texDic(ijtmmId: taxDic["ijtmmId"] as? String, ijmmId: taxDic["ijmmId"] as? String, taxId: taxDic["taxId"] as? String, rate: taxDic["rate"] as? String, label: taxDic["label"] as? String))
                                
                                
                            }
                            let ammount = amounc(qty:  item["qty"] as? String, rate: item["rate"] as? String, discount:  item["discount"] as? String,arrTax: arrTac)
                            let dic = ItemDic(ijmmId:  item["ijmmId"] as? String, itemId:  item["itemId"] as? String, jobId:  objOfUserJobListInDetail.jobId , groupId:  item["groupId"] as? String, des: item["des"] as? String, inm:  item["inm"] as? String, qty:  item["qty"] as? String, rate:  item["rate"] as? String, discount:  item["discount"] as? String, amount: ammount, tax: arrTac, hsncode:  item["hsncode"] as? String, pno:  item["pno"] as? String, unit:  item["unit"] as? String, taxamnt:  item["taxamnt"] as? String, supplierCost:  item["supplierCost"] as? String,dataType: item["dataType"] as? String,isBillable: item["isBillable"] as? String, isBillableChange: item["isBillableChange"] as? String)
                            
                            
                            itemDetailedData.append(dic)
                        } else {
                            let ammount = amounc(qty:  item["qty"] as? String, rate: item["rate"] as? String, discount:  item["discount"] as? String)
                            
                            
                            let dic = ItemDic(ijmmId:  item["ijmmId"] as? String, itemId:  item["itemId"] as? String, jobId:  objOfUserJobListInDetail.jobId , groupId:  item["groupId"] as? String, des: item["des"] as? String, inm:  item["inm"] as? String, qty:  item["qty"] as? String, rate:  item["rate"] as? String, discount:  item["discount"] as? String, amount: ammount, tax: [], hsncode:  item["hsncode"] as? String, pno:  item["pno"] as? String, unit:  item["unit"] as? String, taxamnt:  item["taxamnt"] as? String, supplierCost:  item["supplierCost"] as? String,dataType: item["dataType"] as? String,isBillable: item["isBillable"] as? String, isBillableChange: item["isBillableChange"] as? String)
                            itemDetailedData.append(dic)
                        }
                        
                    }
                }
                
                
                
            }
            //            if itemDetailedData.count > 0 {
            //                CelculateAmount()
            //            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.arryCount.text = "\(self.loc_listItem) \(self.itemDetailedData.count)"
                if self.itemDetailedData.count == 0{
                    self.showNoDataAlert()
                }else{
                    self.hideNoDataAlert()
                }
            }
            
            //    print(itemDetailedData)
            
        }
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
           
           
           let totalAmount = calculateAmountForItemVc1(quantity: Double(qty1)!, rate: Double(rate1)!, tax: tax, discount: Double(discount1)!)
           return roundOff(value: totalAmount)
           
           
           
           
           //                                                         let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Int(qty)!, taxRateInPercentage: tax)
           //                                                         item1.taxamnt = roundOff(value: taxAmount)
           
           
       }
      
    
    //---------------------------- callback ---------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            if let addVC = segue.destination as? ListItemVC {
                addVC.isAdd = true
                addVC.invoiceRes = invoiceRes
                addVC.isHiddenView = isHidenBillableView
                addVC.jobDetail = objOfUserJobListInDetail
                addVC.callbackDetailVC =  {(isUpdate : Bool ) -> Void in
                    
                    if isUpdate {
                        self.displayMsg = AlertMessage.add
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
    

    //    //=================================================//
    //        //MARK:- Delete Item Api Calling
    //    //=================================================//
      func deletetemInviceOffline(itemdata:[String]){
                  
             
                  
                  let  param  = Params()
                  
                  param.jobId = objOfUserJobListInDetail.jobId
                  param.ijmmId = itemdata //: []
                 // param.groupData = []
                  
                  let dict =  param.toDictionary
                  
           //   print(dict as Any)
                  
                  
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
    
    // Text Field Delegate ==============
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        payPartialAmnt.resignFirstResponder()
        return true
    }
    
    //======================================================
    // MARK: Optional View method
    //======================================================
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
  
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InvoiceTemplateArr.count
      }
      
      func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
          if(cell == nil){
              cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
          }
          
          
          cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
          cell?.backgroundColor = .clear
         
          cell?.textLabel?.textColor = UIColor.darkGray
       
              if InvoiceTemplateArr.count != 0 {
              cell?.textLabel?.text = InvoiceTemplateArr[indexPath.row].tempJson1?.invDetail![0].inputValue
       
          }
         
          return cell!
      }
      
      func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          self.txtInvoice.text = InvoiceTemplateArr[indexPath.row].tempJson1?.invDetail![0].inputValue
          self.templateId = InvoiceTemplateArr[indexPath.row].invTempId  ?? ""
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
        
        if (printView != nil) {
            printView.removeFromSuperview()
        }
        
        self.backgroundView.isHidden = true
        self.backgroundView.backgroundColor = UIColor.clear
        self.backgroundView.alpha = 1
    }
    
    func openbackgorunVw(){
        self.showBackgroundView()
        view.addSubview(self.printView)
        printView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
    }
    
    //======================================================
    // MARK: Table View Delegate
    //======================================================

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let aar = itemDetailedData[indexPath.row]
//
//              if aar.isBillable == "1"{
//                 return 78
//              }else{
//                 return 0
//        }
//
//
//    }
//
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
            //return self.invoiceRes.data?.itemData! == nil ? 0 :  (self.invoiceRes.data?.itemData?.count)!
            return self.itemDetailedData.count
            
        }else{
            return self.invoiceRes.data?.shippingItem! == nil ? 0 :  (self.invoiceRes.data?.shippingItem?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if self.itemDetailedData.count > 0 {
                let aar = itemDetailedData[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! InvoiceCell
                if aar.isBillable == "1"{
                
                    if selectedCell == indexPath {
                        cell.view.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                    }else{
                        cell.view.backgroundColor = UIColor.white
                    }
                    
                    var myrate = aar.rate
                    if (myrate?.count)! > 0 {
                        myrate = roundOff(value: Double(myrate!)!)
                    }else{
                        myrate = roundOff(value:Double("0.00")!)
                    }
                    
                    var mydiscount = aar.discount
                    if (mydiscount?.count)! > 0 {
                        mydiscount = roundOff(value: Double(mydiscount!)!)
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
                            cell.discountLbl.text = ""
                            cell.desLbl.text = aar.des?.capitalized
                        }
                    }
                
                    let qty = LanguageKey.qty
                    
                    cell.qtyLbl.text = "\(qty): " + aar.qty!
                    // cell.discountLbl.text = "ITC " + mydiscount! + " %"
                    cell.amountLbl.text = (aar.amount)!
                    
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
                    cell.billingLbl.isHidden = true
                    cell.billingView.isHidden = true
                    return cell
                }else{
                   
                    cell.isHidden = true
                    cell.billingLbl.isHidden = true
                    cell.billingView.isHidden = true
         
                    
                }
             
                return cell
            }
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
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            return
        }
        
        
        ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoiceProductUpdate)
        
        let itemDetailVC = storyboard?.instantiateViewController(withIdentifier: "ListItemVC") as! ListItemVC
        
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
        
        itemDetailVC.item = itemDetailedData
         itemDetailVC.jobDetail = objOfUserJobListInDetail
        // var invoiceRes : InvoiceResponse?
        itemDetailVC.selectedIndex = indexPath.row
        itemDetailVC.isHiddenView = isHidenBillableView
        itemDetailVC.invoiceRes = invoiceRes
        itemDetailVC.isAdd = false
        itemDetailVC.callbackDetailVC =  {(student : Bool) -> Void in
           // showLoader()
            self.displayMsg = AlertMessage.updated
           // self.isUpdateItem = false
           // self.updateInvoiceOnServer()
        }
        
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
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
            deleteCellImg.image = UIImage(named: "trash")
        } else{
            deleteCellImg.image = UIImage(named: "trash (2)")
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
                //self.getInvoiceRecordnew()
                //self.updateInvoiceOnServer()
            }
        }
    }
    
  
    //======================================================
    // MARK: Get Invoice Data
    //======================================================
    func getInvoiceRecord() {

        if !isHaveNetowork() {
           // ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            self.showToast(message: AlertMessage.checkNetwork)
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
       
         self.replaceJobItemDataID(dict:  self.invoiceRes)
        if let data =  self.invoiceRes.data{
            
            if let address = self.invoiceRes.data?.inv_client_address {
                if address == "" {
                    DispatchQueue.main.async {
                        self.nameLbl.text = ""
                        self.compninameLbl.text = ""
                        self.adrsLbl.text = ""
                        self.lblGst.text = ""
                        
                        self.H_Name.constant = 0
                        self.H_gstnumber.constant = 0
                        self.H_address.constant = 0
                    }
                }else{
                    self.setAddress(addressString: address)
                }
            }
            
            
            for item in (self.invoiceRes.data?.itemData)! {
                var tax : Double = 0.0
                for tx in item.tax! {
                    tax = tax + Double((tx.rate == "") ? roundOff(value:Double("0.00")!) : tx.rate!)!
                }
                let qty = (item.qty == "") ? "0" : item.qty!
                let rate = (item.rate == "") ? "0.0" : item.rate!
                let discount = (item.discount == "") ? "0.0" : item.discount!
                
                if let enableCustomForm = objOfUserJobListInDetail.disCalculationType { //getDefaultSettings()?.disCalculationType{ chng
                    if enableCustomForm == "0"{
                        let totalAmount = calculateAmount(quantity: Double(qty)!, rate: Double(rate)!, tax: tax, discount: Double(discount)!)
                        item.amount = roundOff(value: totalAmount)
                        
                        let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: tax)
                        item.taxamnt = roundOff(value: taxAmount)
                    }else{
                      //  let totalAmount = calculateAmountForItemVc1(quantity: Double(qty)!, rate: Double(rate)!, tax: tax, discount: Double(discount)!)
                    let totalAmount = calculateAmountFlateDiscount(quantity: Double(qty)!, rate: Double(rate)!, tax: tax, discount: Double(discount)!)
                        item.amount = roundOff(value: totalAmount)
                        let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: tax)
                        item.taxamnt = roundOff(value: taxAmount)
                    }
                }
                
//                let totalAmount = calculateAmount(quantity: Double(qty)!, rate: Double(rate)!, tax: tax, discount: Double(discount)!)
//                item.amount = roundOff(value: totalAmount)
//
//                let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: tax)
//
//                item.taxamnt = roundOff(value: taxAmount)
            }
            
            DispatchQueue.main.async{
                self.amountLbl.text = roundOff(value: Double(data.total ?? "0.0")!)
                
                var ass = ""
                if data.duedate != ass  {
                     self.dueDateLbl.text = convertTimestampToDateForPayment(timeInterval: (data.duedate ?? ""))
                }else{
                     self.dueDateLbl.text = ""
                }
                 if data.duedate != ass  {
                     self.createdDateLbl.text = convertTimestampToDateForPayment(timeInterval: (data.invDate ?? ""))
                 }else{
                      self.createdDateLbl.text = ""
                }
               
               
                self.arryCount.text = "\(self.loc_listItem) \(data.itemData!.count)"
                self.currency = data.curSym!
                
                if self.invoiceRes.data!.itemData!.count == 0{
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
    
    func replaceJobItemDataID( dict :InvoiceResponse) -> Void {
                    
                       
            let item = dict.data
                    
                    //Replace Contact id in ClientContactList Entity
            let searchQuery = "jobId = '\(objOfUserJobListInDetail?.jobId ?? "")'"
                    let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
                    if isExist.count > 0 {
                        let existingJob = isExist[0]
                        
                        if existingJob.itemData != nil {
                       // let item = (existingJob.itemData as! [AnyObject])
                            var arrItem = [Any]()
                            if  let itemd = item?.itemData {
                                
                                for item in itemd {
                                    arrItem.append(item.toDictionary!)
                                }
                                
                                
                               existingJob.itemData = arrItem as NSObject?
                            }
                        }
                        //existingJob.label = dict["label"] as? String
                    
                       
                    }
                    
            DatabaseClass.shared.saveEntity(callback: {isSuccess in
    //                    if self.callbackForJobVC != nil {
    //                        self.callbackForJobVC!(true)
                self.setData()
    //                    }
                    })
            
            
                    
                    
                }
    
    
    func setAddress(addressString : String) -> Void {
        let decoder = JSONDecoder()
        let data = addressString.data(using: .utf8)!
        do {
            if (try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]) != nil
            {
                if let addressData = try? decoder.decode(addressRes.self, from: data) {
                    
                    
                    var address = ""
                    
                    if (addressData.city != nil) && (addressData.city != "") {
                        address = addressData.city!
                    }
                    
                    if (addressData.country != nil) && (addressData.country != "") {
                        if address.count > 0 {
                            address =  address + " \(addressData.country!)"
                        }else{
                            address = addressData.country!
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        if let name = addressData.nm{
                            
                            if name.count > 0 {
                                self.nameLbl.text = name.capitalizingFirstLetter()
                            }else{
                                self.H_Name.constant = 0.0
                            }
                        }else{
                            self.nameLbl.text = "Unknown"
                        }
                        
                        if (addressData.adr != nil) && (addressData.adr != "") {
                            self.compninameLbl.text = addressData.adr!
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
                        
                        
                       // self.adrsLbl.text = address.capitalizingFirstLetter()
                       // self.adrsLbl.text = "312 orbitmall near by teleperformance indore, pincode - 452001"
                        
                        if let gst = addressData.gst{
                            if gst.count > 0 {
                                self.lblGst.text = gst
                            }else{
                                self.H_gstnumber.constant = 0.0
                            }
                        }else{
                             self.H_gstnumber.constant = 0.0
                        }
                        
                        
                        
                    }
                }
                
            } else {
               // print("bad json")
                DispatchQueue.main.async {
                    self.nameLbl.text = ""
                    self.compninameLbl.text = ""
                    self.adrsLbl.text = ""
                }
            }
        } catch _ as NSError {
            DispatchQueue.main.async {
                self.nameLbl.text = ""
                self.compninameLbl.text = ""
                self.adrsLbl.text = ""
            }
        }
    }
    
    
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
                           // self.itemlistData = decodedData.data!
    //                        taxCalculationType = (self.invoiceRes.data?.taxCalculationType)!
                             self.replaceJobItemDataID(dict:  decodedData.data!)


                                    
                                        DispatchQueue.main.async{
                                             self.setData()
                                            self.arryCount.text = "\(self.loc_listItem) \(self.itemDetailedData.count)"
                                            if decodedData.data?.count == 0{
                                                self.showNoDataAlert()
                                            }else{
                                                self.hideNoDataAlert()
                                            }
                                            //self.tableView.reloadData()
                                           
                                       
                                }
                       }else{
                            self.setData()
    //                        if (decodedData.statusCode != nil) && decodedData.statusCode == "401" {
    //                            ShowAlert(title:  getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
    //                                if (Ok){
    //                                    DispatchQueue.main.async {
    //                                        (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
    //                                    }
    //                                }
    //                            })
    //                        }else{
    //                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
    //                        }
                          //  self.showNoDataAlert()
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


       // let item = dict.data
            if (dict.count) > 0 {
        let searchQuery = "jobId = '\(objOfUserJobListInDetail?.jobId ?? "")'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
        if isExist.count > 0 {
        let existingJob = isExist[0]

        if existingJob.itemData != nil {
        // let item = (existingJob.itemData as! [AnyObject])
        var arrItem = [Any]()
       // if let itemd = dict {

        for item in dict {
        arrItem.append(item.toDictionary!)
        }


        existingJob.itemData = arrItem as NSObject?
       // }
        }
        //existingJob.label = dict["label"] as? String


        }

        DatabaseClass.shared.saveEntity(callback: {isSuccess in
        // if self.callbackForJobVC != nil {
        // self.callbackForJobVC!(true)
        self.setData()
        // }
        })
        }
        //Replace Contact id in ClientContactList Entity





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
                        
                        let data =  self.invoiceRes.data
                        
                        for item in (data!.itemData)! {
                            var tax : Double = 0.0
                            for tx in item.tax! {
                                tax = tax + Double((tx.rate == "") ? roundOff(value:Double("0.00")!) : tx.rate!)!
                            }
                            
                            let qty = (item.qty == "") ? "0" : item.qty!
                            let rate = (item.rate == "") ? "0.0" : item.rate!
                            let discount = (item.discount == "") ? "0.0" : item.discount!
                            
                            let totalAmount = calculateAmount(quantity: Double(qty)!, rate: Double(rate)!, tax: tax, discount: Double(discount)!)
                            item.amount = roundOff(value: totalAmount)
                            
                            let taxAmount = calculateTaxAmount(rate: Double(rate)!, qty: Double(qty)!, taxRateInPercentage: tax)
                            item.taxamnt = roundOff(value: taxAmount)
                        }
                        
                        
                        DispatchQueue.main.async{
                            self.arryCount.text = "\(self.loc_listItem) \(data!.itemData!.count)"
                           
                            self.amountLbl.text = roundOff(value: Double(data!.total ?? "0.0")!) 
                            if data!.itemData!.count == 0{
                                self.showNoDataAlert()
                            }else{
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
    
    ///////////////////////////////////////////////
    
    func getInvoiceRecordnew() {
           
           if !isHaveNetowork() {
               self.showToast(message: AlertMessage.checkNetwork)
              // ShowError(message: AlertMessage.checkNetwork, controller: windowController)
               return
           }
           
           showLoader()
           let param = Params()
           param.jobId = objOfUserJobListInDetail.jobId
           param.invId = ""
    //    param.isCallFromBackward = "0"
           
           serverCommunicator(url: Service.getInvoiceDetailMobile, param: param.toDictionary) { (response, success) in
               killLoader()
               if(success){
                   let decoder = JSONDecoder()
                   if let decodedData = try? decoder.decode(InvoiceResponse.self, from: response as! Data) {
                       
                       if decodedData.success == true{
                     
                           
                          
                      //  self.itemDetailedDatanew = (decodedData.data?.itemData) as! [DetailedItemData]
                           
                           if let invId = decodedData.data?.invId{
                               self.invoiceId = invId
                           }
                           
                           
                           if decodedData.data?.itemData?.count == 0 {
                               
                            //   let data =    (self.objOfUserJobList?.itemData as! [AnyObject])
//                               if data.count > 0 {
//
//                               } else {
//                                   ShowAlert(title: AlertMessage.invoiceNotGenerate, message: "" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {(_,_) in})
//                                   return
//                               }
                               //                                ShowAlert(title: AlertMessage.invoiceNotGenerate, message: "" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {(_,_) in})
                               //                            return
                           }
                           
                           if decodedData.data?.isShowInList == "0" {
                               ShowAlert(title: AlertMessage.invoiceAndPreview, message: "" , controller: windowController, cancelButton:LanguageKey.no as NSString , okButton:LanguageKey.yes as NSString , style: .alert, callback: {(no,yes) in
                                   
                                   if yes {
                                       self.generateInvoice(invoiceRes: decodedData)
                                   }
                               })
                               return
                           }
                           
                           self.invoiceRes = decodedData
                           
                           self.setupInvoiceResponseModel()
                          // self.navigateToInvoicePage(invoiceRes: decodedData)
                           
                       }else{
                           if (decodedData.statusCode != nil) && decodedData.statusCode == "401" {
                               ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                   if (Ok){
                                       DispatchQueue.main.async {
                                           (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                       }
                                   }
                               })
                           }else{
                               ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
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
       
    
    func generateInvoice(invoiceRes : InvoiceResponse) {
        
        if !isHaveNetowork() {
           // ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            self.showToast(message: AlertMessage.checkNetwork)
            return
        }
        
        showLoader()
        let param = Params()
        param.isShowInList = "1"
        param.invId = invoiceId
        
        serverCommunicator(url: Service.generateInvoice, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(CommonResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        invoiceRes.data?.isShowInList = "1"
                        
                        self.invoiceRes = invoiceRes
                        
                        self.setupInvoiceResponseModel()
                        //self.navigateToInvoicePage(invoiceRes: invoiceRes)
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
    
    //=====================================
    // MARK:- getInvoiceTemplates  Service
    //=====================================
    
     func getInvoiceTemplates(){

            serverCommunicator(url: Service.getInvoiceTemplates, param: nil) { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(InvoiceTemplateRs.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            self.InvoiceTemplateArr = decodedData.data as! [JobCardTemplat1]
                            DispatchQueue.main.async {
                                let arr = self.InvoiceTemplateArr[0]
                               // print( "\(String(describing: arr.tempJson1?.invDetail![0].inputValue ?? ""))")
                                self.templateVelue = "\(String(describing: arr.tempJson1?.invDetail![0].inputValue ?? ""))"
                                self.txtInvoice.text = self.templateVelue
                                self.templateId = arr.invTempId ?? ""
                            }
                            
                        }else{
                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{
                        
                      //  ShowError(message: AlertMessage.formatProblem, controller: windowController)
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
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
        param.dateTime = lastRequestTime ?? ""
        
        
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
                            }
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
    
    func calculateAmountForItemVc1(quantity:Double, rate:Double, tax:Double, discount:Double) -> Double {

            var arr = Double()
            if let enableCustomForm = objOfUserJobListInDetail.disCalculationType { //getDefaultSettings()?.disCalculationType{ chng
                if enableCustomForm == "0"{
                    let newRate = (rate - ((rate * discount) / 100));
                    arr =  quantity * ( newRate + ((newRate * tax) / 100));
                    return arr
                }else{
                    
                    let newRate = (rate);
                
                    arr = calculateNormalDiscountAmount(quantity: quantity, rate: newRate, tax: tax, discount: discount).2
                   // arr = calculateFlateDiscountAmount(quantity: quantity, rate: newRate, tax: tax, discount: discount).2
                    return arr
                }
            }
            return arr
       
    }
}
