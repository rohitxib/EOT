//
//  PaymentVC.swift
//  EyeOnTask
//
//  Created by Mac on 25/04/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Photos
import UIKit
import IQKeyboardManagerSwift
class PaymentVC: UIViewController,OptionViewDelegate,UITextViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var attchmntImgHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDocumnt: UILabel!
    @IBOutlet weak var lblUpload: UILabel!
    @IBOutlet weak var attchmntImg: UIImageView!
    @IBOutlet var mailperView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var paymentRcptBtn: UIButton!
    @IBOutlet weak var btnDoneBgView: UIButton!
    @IBOutlet weak var btnCancelBgView: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblPaidAmount: UILabel!
    @IBOutlet weak var lblDueAmount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var dueAmntLbl: UILabel!
    @IBOutlet weak var paidAmntLbl: UILabel!
    @IBOutlet weak var totalAmntLbl: UILabel!
    @IBOutlet weak var datePiker: UIDatePicker!
    @IBOutlet weak var bigview: UIView!
    @IBOutlet weak var paymentTypeTxt: FloatLabelTextField!
    @IBOutlet weak var paymentDateTxt: FloatLabelTextField!
    @IBOutlet weak var txtAmount: FloatLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtVwNote: UITextView!
    @IBOutlet weak var emailtextSend: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    var amountdemoveli = ""
    var activtiLogArr = [OfflineListArray]()
    var arrDemo = [String]()
    var confirmationTriggerArray = [String]()
    var confirmationTriggerForNill = [String]()
    var emailSendStatus = ""
    var emailpermision:Bool = false
    var isEmailSendOrNot = false
    var selectedIndex : Int?
    var invoiceRes = InvoiceResponse()
    var objOfUserJobListInDetail : UserJobList!
    let param = Params()
    let cellReuseIdentifier = "cell"
    var arrOfAccType = [UserAccType]()
    var sltTxtField = UITextField()
    var optionalVw : OptionalView?
    var Cash = LanguageKey.cash
    var Cheque =  LanguageKey.cheque
    var CreditCard =  LanguageKey.credit_card
    var DebitCard =  LanguageKey.Debit_card
    var WireTransfer = LanguageKey.wire_transfer
    var Paypal = LanguageKey.paypal
    var Stripe =  LanguageKey.stripe
    var paymentTypes = [PaymentType.Cash, PaymentType.Cheque, PaymentType.CreditCard, PaymentType.DebitCard,PaymentType.WireTransfer, PaymentType.Paypal, PaymentType.Stripe]
    var selectedPayType : Int  = 0
    var selectedDate : Date?
    var uploadImage : UIImage? = nil
    var imagePicker = UIImagePickerController()
    var getTotelAmount = ""
    var getPaidAmount = ""
    var getDueAmount = ""
    var getDueAmountWithOutCurrancy = ""
    
    //=======================
    //MARK:- Initialise methods
    //=======================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.isHidden = true
        self.paymentRcptBtn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
        self.title = LanguageKey.title_payment
        getInvoiceRecord()
        setupMethod()
        
        paymentRcptBtn.setTitle(LanguageKey.send_payment_reciept, for: .normal)
        btnDoneBgView.setTitle(LanguageKey.done, for: .normal)
        btnCancelBgView.setTitle(LanguageKey.cancel, for: .normal)
        btnSave.setTitle(LanguageKey.save_btn, for: .normal)
        lblNote.text = LanguageKey.notes
        lblPaidAmount.text = LanguageKey.paid_amt
        lblDueAmount.text = LanguageKey.due_amt
        lblTotalAmount.text = LanguageKey.total_inv_amt
        emailtextSend.text = LanguageKey.send_client_mail
        yesBtn.setTitle(LanguageKey.yes , for: .normal)
        noBtn.setTitle(LanguageKey.no , for: .normal)
        
        if let langCode = getCurrentSelectedLanguageCode() {
            datePiker.locale = Locale(identifier: langCode)
        }
        
        paymentDateTxt.placeholder = LanguageKey.pay_date
        paymentTypeTxt.placeholder = LanguageKey.lable_pay_type
        txtAmount.placeholder = LanguageKey.amt
        txtAmount.text = roundOff(value: Double("0.0")!)
        IQKeyboardManager.shared.enable = true
        self.activtiLogArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineListArray", query: nil) as! [OfflineListArray]
        
        let ActvtyLgarr = DatabaseClass.shared.createEntity(entityName: "OfflineListArray") as! OfflineListArray
        ActvtyLgarr.module  = Modules.job.rawValue
        ActvtyLgarr.msg = ActivityMessages.jobPayment
        activtiLogArr.append(ActvtyLgarr)
        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobPayment)
        
        //===============================
        //MARK : - For AcrivityLog Array
        //===============================
        
        getAllCompanySettings()
        
        if self.attchmntImg.image == nil { 
            self.attchmntImgHeight.constant = 0
            self.attchmntImg.isHidden = true
        } else {
            self.attchmntImgHeight.constant = 130
            self.attchmntImg.isHidden = false
        }
    }
    
    
    //================================
     //  MARK: showing And Hiding Background
     //================================
     
     func showBackgroundView() {
         backgroundView.isHidden = false
         UIView.animate(withDuration: 0.2, animations: {
             self.backgroundView.backgroundColor = UIColor.black
             self.backgroundView.alpha = 0.5
         })
     }
     
     func hideBackgroundView() {
         
         if ((optionalVw) != nil){
             removeOptionalView()
         }
         
         if (mailperView != nil) {
             mailperView.removeFromSuperview()
         }
         
         
         self.backgroundView.isHidden = true
         self.backgroundView.backgroundColor = UIColor.clear
         self.backgroundView.alpha = 1
     }
    
    //============================================================
    // FOR IMG :-
    //============================================================
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
        
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == .denied || status == .restricted) {
            ShowAlert(title: "", message: LanguageKey.photo_denied, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
            return
        }else{
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                if authStatus == .authorized{
                    let imageAsset = PHAsset.fetchAssets(with: .image, options: nil)
                    
                    if imageAsset.count > 0{
                        let asset = imageAsset.firstObject
                        let imgFullName = asset?.value(forKey: "filename") as! String
                        let arr = imgFullName.components(separatedBy: ".")
                        let imgExtension = arr.last
                        let imgName = imgFullName.replacingOccurrences(of: ".\(imgExtension!)", with: "")
                        
                        if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
                            let imgStruct = ImageModel_AddEqupment(img: (info[.originalImage] as? UIImage)?.resizeImage_AddEqupment(targetSize: CGSize(width: 1000.0, height: 10000.0)))
                            
                            DispatchQueue.main.async {
                                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                                vc.image = (imgStruct.img!)
                                
                                vc.name = trimString(string: imgName)
                                vc.OnlyForCrop = false
                                vc.OnlycheckMarkCompl = true
                                vc.OnlyForHideAllTxtView = true
                                vc.callback = {(modifiedImage, imageName, imageDescription) in
                                    self.uploadImage = modifiedImage
                                    self.attchmntImg.image =   self.uploadImage
                                    self.attchmntImgHeight.constant = 130
                                    self.attchmntImg.isHidden = false
                                    vc.navigationController?.popViewController(animated: true)
                                    
                                }
                                self.navigationController!.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        APP_Delegate.hideBackButtonText()
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    @IBAction func attchmntBtn(_ sender: Any) {
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: LanguageKey.please_select, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: LanguageKey.cancel , style: .cancel) { _ in
           
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let camera = UIAlertAction(title: LanguageKey.camera, style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera;
                self.imagePicker.allowsEditing = false
                APP_Delegate.showBackButtonText()
                self.present(self.imagePicker, animated: true, completion: {
                 
                })
            }
        }
        
        let gallery = UIAlertAction(title: LanguageKey.gallery, style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = false
                APP_Delegate.showBackButtonText()
                self.present(self.imagePicker, animated: true, completion: {
                    self.attchmntImgHeight.constant = 0
                    self.attchmntImg.isHidden = true
                  
                })
            }
        }
        
        actionSheetControllerIOS8.addAction(gallery)
        actionSheetControllerIOS8.addAction(camera)
      self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
  
    @IBAction func mailYesAct(_ sender: Any) {
        self.emailSendStatus = "1"
        hideBackgroundView()
        
        if selectedPayType != 0 {
            if txtAmount.text?.count != 0 && Double(txtAmount.text!)! != 0 {
                getInvoicePaymentRecieve()
            }else{
                ShowError(message: AlertMessage.enterAmount, controller: windowController)
            }
        }else{
            ShowError(message: AlertMessage.nonPaymentType, controller: windowController)
        }
        
    }
    
    @IBAction func mailNoAct(_ sender: Any) {
        self.emailSendStatus = "0"
        hideBackgroundView()
        
        if selectedPayType != 0 {
            if txtAmount.text?.count != 0 && Double(txtAmount.text!)! != 0 {
                getInvoicePaymentRecieve()
            }else{
                ShowError(message: AlertMessage.enterAmount, controller: windowController)
            }
        }else{
            ShowError(message: AlertMessage.nonPaymentType, controller: windowController)
        }
     
    }
    
    func setupMethod() -> Void {
        
        paymentTypeTxt.text = LanguageKey.cash//paymentTypes[0].name
        selectedPayType = 1// paymentTypes[0].value
        
        //For By default date
        selectedDate = Date()
        let strDate = convertDateToString(date: selectedDate!, dateFormate: DateFormate.dd_MMM_yyyy)
        paymentDateTxt.text = strDate
    }
   

    //=======================
    //MARK:- Date Picker methods
    //=======================
    
    @IBAction func saveDatePkrActn(_ sender: Any) {
        hideDatePicker()
        selectedDate = datePiker.date
        let strDate = convertDateToString(date: datePiker.date, dateFormate: DateFormate.dd_MMM_yyyy)
        paymentDateTxt.text = strDate
    }

    @IBAction func cancelDatePkr(_ sender: Any) {
         hideDatePicker()
    }

    @IBAction func showDatePicker(_ sender: Any) {
        self.bigview.isHidden = false
        txtAmount.resignFirstResponder()
        txtVwNote.resignFirstResponder()
    }
    
    func hideDatePicker() -> Void {
        self.bigview.isHidden = true
    }
    
    //=======================
    //MARK:- DropDown methods
    //=======================
    @IBAction func pymntTypDrpdwnBtn(_ sender: UIButton) {
        if (sender.tag == 1) {
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.paymentTypeTxt , arr: paymentTypes)
            }else{
                self.removeOptionalView()
            }
        }
    }
    
    func removeOptionalView(){
        if optionalVw != nil {
            self.optionalVw?.removeFromSuperview()
            self.optionalVw = nil
        }
    }
    
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        hideDatePicker()
        txtVwNote.resignFirstResponder()
        txtAmount.resignFirstResponder()
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                self.removeOptionalView()
            }
        }else{
            DispatchQueue.main.async {
                self.removeOptionalView()
            }
        }
    }
    
    //==========================
    //MARK:- Other Methods
    //==========================
    
    @IBAction func paymentRcptBtn(_ sender: Any) {
        
        if(paymentRcptBtn.imageView?.image == UIImage(named: "BoxOFUncheck")){
            self.paymentRcptBtn.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
            isEmailSendOrNot = true
            
        }else{
            isEmailSendOrNot = false
            self.paymentRcptBtn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
        }
    }

    @IBAction func saveBtnActn(_ sender: Any) {
        
        if emailpermision == true {
            
            showBackgroundView()
            view.addSubview(mailperView)
            mailperView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
        }else{
           
            if selectedPayType != 0 {
                
                if txtAmount.text?.count != 0 && Double(txtAmount.text!)! != 0 {
                    var allAmount:Double = Double(txtAmount.text!)!
                    var getAmount:Double = Double(self.getDueAmountWithOutCurrancy)!
                
                   if (allAmount) <= (getAmount){
                        getInvoicePaymentRecieve()
                    }else{
                        self.txtAmount.text = ""
                        ShowError(message:LanguageKey.amount_error, controller: windowController)
                    }
                }else{
                    ShowError(message: AlertMessage.enterAmount, controller: windowController)
                }
              
            }else{
                ShowError(message: AlertMessage.nonPaymentType, controller: windowController)
            }
            
        }
    }
    
    //=====================================
    // MARK:- Optional view Detegate
    //=====================================
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  ["\(self.Cash ?? "")","\(self.Cheque ?? "")", "\(self.CreditCard ?? "")", "\(self.DebitCard ?? "")","\(self.WireTransfer ?? "")", "\(self.Paypal ?? "")", "\(self.Stripe ?? "")"].count//paymentTypes.count
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
       var arr = ["\(self.Cash ?? "")","\(self.Cheque ?? "")", "\(self.CreditCard ?? "")", "\(self.DebitCard ?? "")","\(self.WireTransfer ?? "")", "\(self.Paypal ?? "")", "\(self.Stripe ?? "")"]
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.textLabel?.text = arr[indexPath.row]
      
      if paymentTypes[indexPath.row].value == selectedPayType {
        cell!.accessoryType = UITableViewCell.AccessoryType.checkmark
    }else{
        cell!.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell!
        
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var arr = ["\(self.Cash ?? "")","\(self.Cheque ?? "")", "\(self.CreditCard ?? "")", "\(self.DebitCard ?? "")","\(self.WireTransfer ?? "")", "\(self.Paypal ?? "")", "\(self.Stripe ?? "")"]
        paymentTypeTxt.text = arr[indexPath.row]
        selectedPayType = paymentTypes[indexPath.row].value
        self.removeOptionalView()
        
    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
    
    //=====================================
    // MARK:- TextField and Textview Detegates
    //=====================================
    func textFieldDidBeginEditing(_ textField: UITextField) {
       hideDatePicker()
     
        if (textField == txtAmount){
            let number = Double(textField.text!)
            if number == 0 {
                textField.text = ""
            }
        }
    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if(textField == txtAmount){
            if (result.containsAmountCharactor){
                return false
            }
            
            let insensitiveCount = result.lowercased().filter{ $0 == Character(String(".").lowercased())}
            if insensitiveCount.count > 1 {
                return false
            }
            
            let minusCount = result.lowercased().filter{ $0 == Character(String("-").lowercased())}
            if minusCount.count > 0  {
                if minusCount.count == 1 {
                    if !result.hasPrefix("-"){
                        return false
                    }
                }else{
                    return false
                }
            }
            
            let aSet = NSCharacterSet(charactersIn:"0123456789-.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if self.getDueAmount == "0.00" || self.getDueAmount == "0.000" {
                
                if txtAmount.text!.count >= 0  {
                    self.txtAmount.text = ""
                    ShowError(message:LanguageKey.amount_error, controller: windowController)
                    return false
                }
            }
            
            if (self.getTotelAmount == self.getPaidAmount) && (self.getDueAmount == self.dueAmntLbl.text) {
                
                if txtAmount.text!.count >= 0  {
                    self.txtAmount.text = ""
                    ShowError(message:LanguageKey.amount_error, controller: windowController)
                    return false
                }
            }
            
            amountdemoveli = result
            return string == numberFiltered
        }
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtAmount {
            if txtAmount.text?.count == 0 {
                txtAmount.text = roundOff(value:Double("0.00")!)
            }else{
                txtAmount.text = roundOff(value: Double(txtAmount.text!)!)
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        hideDatePicker()
    }
    
    //======================================================
    // MARK:- Get Invoice Data
    //======================================================
    
    func getInvoiceRecord() {
       
        let param = Params()
        param.jobId = objOfUserJobListInDetail?.jobId
        param.invId = ""
        param.isCallFromBackward = "0"
        
        serverCommunicator(url: Service.getInvoiceDetailMobile, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(InvoiceResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                     
                         self.invoiceRes = decodedData
                        
                        let total = Double(self.invoiceRes.data!.total ?? roundOff(value:Double("0.00")!) )
                        let paid = Double(self.invoiceRes.data!.paid ?? roundOff(value:Double("0.00")!) )
                        let due : Double = (total ?? 0.0) - (paid ?? 0.0)
                        let currency = self.invoiceRes.data!.curSym ?? ""
                        
                        DispatchQueue.main.async{
                            
                            self.getTotelAmount = "\(currency)" + roundOff(value: total!)
                            self.getPaidAmount = "\(currency)" + roundOff(value: paid!)
                            self.getDueAmount = "\(currency)" + roundOff(value: due)
                            self.txtAmount.text = roundOff(value: due)
                            self.getDueAmountWithOutCurrancy = roundOff(value: due)
                            self.totalAmntLbl.text = "\(currency)" + roundOff(value: total!)
                            self.paidAmntLbl.text = "\(currency)" + roundOff(value: paid!)
                            self.dueAmntLbl.text = "\(currency)" + roundOff(value: due)
                        }
                    }else{
                        ShowError(message:getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    
    func getInvoicePaymentRecieve() {

        if !isHaveNetowork(){
             ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
      
        showLoader()
        let param = Params()
       
        var invI = self.invoiceRes.data?.invId
        if invI != nil {
            param.invId = self.invoiceRes.data?.invId
        }else{
            param.invId = ""
            param.jobId = objOfUserJobListInDetail?.jobId
        }
       
        param.amt = txtAmount.text!
        param.ref =  self.invoiceRes.data!.nm
        param.paytype = String(selectedPayType)
        param.paydate  = convertDateToStringForServer(date: selectedDate!, dateFormate: DateFormate.yyyy_MM_dd)
        param.note = trimString(string: txtVwNote.text!)
        param.isEmailSendOrNot = isEmailSendOrNot
        param.isMailSentToClt = emailSendStatus
        
        let images = (attchmntImg.image != nil) ? attchmntImg.image! : nil
        serverCommunicatorUplaodImage(url: Service.invoicePaymentRecieve, param:  param.toDictionary, image: images, imagePath: "paymentImg", imageName: "image" ){(response, success) in
   
            killLoader()
            if(success){
            
                ShowError(message: AlertMessage.paymentRecieved, controller: windowController)
               
                DispatchQueue.main.async {
                    let total = Double(self.invoiceRes.data!.total ?? roundOff(value:Double("0.00")!))
                    var paid = Double(self.invoiceRes.data!.paid ?? roundOff(value:Double("0.00")!))
                    paid = paid! + Double(self.txtAmount.text!)!
                    let due : Double = total! - paid!
                    let currency = self.invoiceRes.data!.curSym ?? ""
                    
                    self.invoiceRes.data!.paid = String(paid!)
                    self.invoiceRes.data!.total = String(total!)
                    self.dueAmntLbl.text = "\(currency)" + roundOff(value: due)
                    self.paidAmntLbl.text = "\(currency)" +  roundOff(value: paid!)
                    self.txtVwNote.text = ""
                    self.txtAmount.text =  roundOff(value:Double("0.00")!)
                    
                }
            }
        }
    }
    
    
    //=====================================
    // MARK:- get All Company Settings
    //=====================================
    
    func getAllCompanySettings(){
        
        ChatManager.shared.ref.database.goOnline() // make sure online realtime database
        
        let param = Params()
        param.usrId = getUserDetails()!.usrId
        param.devType = "2"
        
        serverCommunicator(url: Service.getMobileDefaultSettings, param: param.toDictionary) { (response, success) in
            
            if success {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(DefaultSettingResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        self.confirmationTriggerArray = (decodedData.data!.confirmationTrigger)!
                        for admin in self.confirmationTriggerArray {
                            
                            var aa = "11"
                            if aa == admin {
                                self.emailpermision = true
                                
                            }else{
                                self.emailpermision = false
                            }
                        }
                    }
                }else{
                    killLoader()
                }
            }else {
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getAllCompanySettings()
                    }
                })
            }
        }
    }
    
}




