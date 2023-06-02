//
//  EditAppointmentVC.swift
//  EyeOnTask
//
//  Created by Dharmendra Gour on 13/07/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import CoreData

class EditAppointmentVC: UIViewController,OptionViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var objOFEditAppointmentVC : AppointmentList?
    
    @IBOutlet weak var endDateAndTime: UILabel!
    @IBOutlet weak var startAndDatrTim: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bntUpload: UIButton!
    @IBOutlet weak var lblScheduleTitle: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var txtDescription: FloatLabelTextField!
    @IBOutlet weak var txtMobileNo: FloatLabelTextField!
    @IBOutlet weak var txtEmail: FloatLabelTextField!
    @IBOutlet weak var txtAddress: FloatLabelTextField!
    @IBOutlet weak var txtStateName: FloatLabelTextField!
    @IBOutlet weak var txtPostalCode: FloatLabelTextField!
    @IBOutlet weak var lblAssignTo: UILabel!
    @IBOutlet weak var txtAddFieldWorker: UITextField!
    @IBOutlet weak var txtCityName: FloatLabelTextField!
    @IBOutlet weak var txtCountryName: FloatLabelTextField!
    @IBOutlet weak var txtClientName: FloatLabelTextField!
    @IBOutlet weak var assignView: ASJTagsView!
    @IBOutlet weak var txtAddAttechment: FloatLabelTextField!
    @IBOutlet weak var btnAttectment: UIButton!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var editAppointmentBtn: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var H_Des: NSLayoutConstraint!
    
    var imgArr = [ImageModel]()
    var stringToHtml = ""
    var arrImg = [UIImage]()
    var editArrayData1:AppointmentList?
    var editArrayData:CommanListDataModel?
    var imagePicker = UIImagePickerController()
    var FltWorkerId = [String]()
    var optionalVw : OptionalView?
    let param = Params()
    var startDates = Bool()
    var startDatee = Bool()
    var startTimes = Bool()
    var startTimee = Bool()
    var sltTxtField = UITextField()
    var sltDropDownTag : Int!
    let cellReuseIdentifier = "cell"
    var arrOfShow = [Any]()
    var arrOfShowData = [CustomFormDetals]()
    var callbackForAppointmentVC: ((Bool,Int) -> Void)?
    var callbackForJobVC: ((Bool) -> Void)?
    var sltDropDownBtnTag : Int!
    var sltIdex : Int?
    var arrImgData = [Data]()
    var isClear  = false
    var isStartScheduleBtn : Bool!
    var commanIdEdit = ""
    var commanIdBool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                if enableCustomForm == "0"{
                  datePickerView.locale = Locale.init(identifier: "en_US")
                }else{
                    datePickerView.locale = Locale.init(identifier: "en_gb")
                }
            }
        
        
      
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        setupMethod()
        
        
        txtClientName.textColor = UIColor.lightGray
        txtMobileNo.textColor = UIColor.lightGray
        txtEmail.textColor = UIColor.lightGray
        txtCountryName.textColor = UIColor.lightGray
        txtStateName.textColor = UIColor.lightGray
        txtEmail.text = editArrayData?.email
        txtMobileNo.text = editArrayData?.mob1
        txtCityName.text = editArrayData?.city
        txtPostalCode.text = editArrayData?.zip
        txtAddFieldWorker.delegate = self
      
        setLocalization()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
             self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)

      }
    
    
    func setLocalization() -> Void {
        
        self.navigationItem.title = LanguageKey.appointment_edit
        startAndDatrTim.text =  LanguageKey.start_date_and_time
        endDateAndTime.text =  LanguageKey.end_date_and_time
        lblScheduleTitle.text =  LanguageKey.appointment_schedule
        txtAddFieldWorker.text =  LanguageKey.add_fieldworker
        lblAssignTo.text = "\(LanguageKey.assign_to)"
        txtAddress.placeholder = "\(LanguageKey.address)"
        txtPostalCode.placeholder = "\(LanguageKey.postal_code)"
        txtCityName.placeholder = "\(LanguageKey.city)"
        txtStateName.placeholder = "\(LanguageKey.state)"
        txtCountryName.placeholder = "\(LanguageKey.country)"
        txtClientName.placeholder = "\(LanguageKey.clients)*"
       // txtDescription.placeholder = "\(LanguageKey.description)"
        txtMobileNo.placeholder = "\(LanguageKey.mob_no)"
        txtEmail.placeholder = "\(LanguageKey.email)"
        doneBtn.setTitle(LanguageKey.done, for: .normal)
        cancelBtn.setTitle(LanguageKey.cancel, for: .normal)
        editAppointmentBtn.setTitle(LanguageKey.update_appointment, for: .normal)
        
    }
    
    
    func getCountry() -> NSArray {
        return getJson(fileName: "countries")["countries"] as! NSArray
    }
    
    func getStates() -> NSArray {
        return getJson(fileName: "states")["states"] as! NSArray
    }
    
    func filterStateAccrdToCountry(serchCourID : String, searchPredicate : String , arr : [Any])-> [Any]{
        let bPredicate: NSPredicate = NSPredicate(format:"self.%@ == %@", searchPredicate ,serchCourID )
        return (arr as NSArray).filtered(using: bPredicate)
        
    }
    // setup method
    
    func setupMethod() -> Void {
       
        txtClientName.text = editArrayData?.nm != nil ? editArrayData?.nm : "Unknown"
        
        // Append Address detail==============================
        let adr = editArrayData?.adr != "" ? editArrayData?.adr : ""
       
        var ctry = editArrayData?.ctry != "" ? editArrayData?.ctry : ""
        var stt = editArrayData?.state != "" ? editArrayData?.state : ""
       
        
        param.state = stt
        param.ctry = ctry
        
        
        if(ctry != ""){
            let name = filterStateAccrdToCountry(serchCourID: (ctry)!, searchPredicate: "id", arr: getCountry() as! [Any])
            ctry = name.count != 0 ? (name[0] as? [String : Any])!["name"] as? String  : ""
        }
        
        
        if(stt != ""){
            let statename = filterStateAccrdToCountry(serchCourID: (stt)!, searchPredicate: "id", arr: getStates() as! [Any])
            stt = statename.count != 0 ? (statename[0] as? [String : Any])!["name"] as? String : ""
        }
        txtStateName.text = stt
        txtCountryName.text = ctry
        
        var address = ""
        
        if adr! != "" {
            if address == "" {
                address =  "\(adr!)"
            }
        }
        
        if let mark = editArrayData?.landmark {
            
            if address != "" {
                if  mark != "" {
                    address = address + ", \(mark.capitalizingFirstLetter())"
                }
            } else {
                address = mark.capitalizingFirstLetter()
            }
        }
        
        
        
        if  address != "" {
            txtAddress.attributedText =  lineSpacing(string: address.capitalized, lineSpacing: 7.0)
        }else{
            txtAddress.text = ""
        }
        
        
        // Description and Instruction, Skype, Twitter ==============================
//        if  editArrayData?.des != "" {
//            txtDescription.attributedText =  lineSpacing(string: (editArrayData?.des?.capitalizingFirstLetter())!, lineSpacing: 7.0)
//        }else{
//            txtDescription.text = ""
//        }
        
        //  time End Date Show
        
        if textView.text == "" {
                            H_Des.constant = 61
                        }else{
                            H_Des.constant = 61*7
                        }
                        
                        
                        //txtViewDes.sizeToFit()
                        DispatchQueue.global(qos: .background).async {
                           
                           
                            let htmlString = self.editArrayData?.des
                            let attributedString = htmlString?.htmlToAttributedString
                            DispatchQueue.main.async {
                                self.textView.attributedText = attributedString
                                killLoader()
                                print("Successfully converted string to HTML")
                            }
                        }
        
        if editArrayData?.schdlStart != "" {
            

            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                        if enableCustomForm == "0"{
                           
                            let startDate = (editArrayData?.schdlStart != nil) ? convertTimeStampToString(timestamp: (editArrayData?.schdlStart!)!, dateFormate: DateFormate.dd_MM_yyyy) : ""
                            
                            
                            if (startDate != "") {
                                let arr = startDate.components(separatedBy: " ")
                                
                                if arr.count > 0 {
                                    lblStartDate.text = arr[0]
                                    lblStartTime.text = arr[1] + " " + arr[2]
                                }
                            }
                            let endDate = (editArrayData?.schdlFinish != nil) ? convertTimeStampToString(timestamp: editArrayData!.schdlFinish!, dateFormate: DateFormate.dd_MM_yyyy) : ""
                            
                            if (endDate != "") {
                                let arr = endDate.components(separatedBy: " ")
                                
                                if arr.count > 0 {
                                    lblEndDate.text = arr[0]
                                    lblEndTime.text = arr[1] + " " + arr[2]
                                }
                            }
                        }else{
                           
                            let startDate = (editArrayData?.schdlStart != nil) ? convertTimeStampToString(timestamp: (editArrayData?.schdlStart!)!, dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                            
                            
                            if (startDate != "") {
                                let arr = startDate.components(separatedBy: " ")
                                
                                if arr.count > 0 {
                                    lblStartDate.text = arr[0]
                                    lblStartTime.text = arr[1] //+ " " + arr[2]
                                }
                            }
                            let endDate = (editArrayData?.schdlFinish != nil) ? convertTimeStampToString(timestamp: editArrayData!.schdlFinish!, dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""
                            
                            if (endDate != "") {
                                let arr = endDate.components(separatedBy: " ")
                                
                                if arr.count > 0 {
                                    lblEndDate.text = arr[0]
                                    lblEndTime.text = arr[1] //+ " " + arr[2]
                                }
                            }
                        }
                    }
            
            
        }else{
            DispatchQueue.main.async {
                self.lblEndDate.text = "--/--/--"
                self.lblEndTime.text = "--:--"
                self.lblStartDate.text = "--/--/--"
                self.lblStartTime.text = "--:--"
            }
            
        }
        
        if commanIdBool == true {
            let searchQuery = "appId = '\(commanIdEdit ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: searchQuery) as! [AppointmentList]
            if isExist.count > 0 {
                let dta = isExist[0]
                
             //   print(dta.kpr as Any)
                
                
                
                if dta.kpr != nil {
                    for kprData in (dta.kpr as! [AnyObject]) {
                        if kprData is String {
                            //  DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
                            let searchQueryFld = "usrId = '\(kprData)'"
                            let tagData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: searchQueryFld) as! [FieldWorkerDetails]
                            
                            if tagData.count > 0 {
                                let tag = tagData[0]
                                
                                
                                DispatchQueue.main.async {
                                    self.createTags(strName: (tag.fnm)!, view: self.assignView)
                                }
                                
                                
                                self.FltWorkerId.append(tag.usrId!)
                                
                            }
                            
                            
                            
                        } else {
                            
                            let searchQueryFld = "usrId = '\((kprData as! [String:String])["usrId"] ?? "")'"
                            let tagData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: searchQueryFld) as! [FieldWorkerDetails]
                            
                            if tagData.count > 0 {
                                let tag = tagData[0]
                                
                                
                                DispatchQueue.main.async {
                                    self.createTags(strName: (tag.fnm)!, view: self.assignView)
                                }
                                
                                
                                self.FltWorkerId.append(tag.usrId!)
                                
                            }
                            
                        }
                    }
                    
                } else {
                  //  print("Not for you null")
                }
                
              //  print( self.FltWorkerId)
                
            }
            
        }else{
            let searchQuery = "appId = '\(editArrayData?.commonId! ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: searchQuery) as! [AppointmentList]
            if isExist.count > 0 {
                let dta = isExist[0]
                
             //   print(dta.kpr as Any)
                
                
                
                if dta.kpr != nil {
                    for kprData in (dta.kpr as! [AnyObject]) {
                        if kprData is String {
                            //  DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
                            let searchQueryFld = "usrId = '\(kprData)'"
                            let tagData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: searchQueryFld) as! [FieldWorkerDetails]
                            
                            if tagData.count > 0 {
                                let tag = tagData[0]
                                
                                
                                DispatchQueue.main.async {
                                    self.createTags(strName: (tag.fnm)!, view: self.assignView)
                                }
                                
                                
                                self.FltWorkerId.append(tag.usrId!)
                                
                            }
                            
                            
                            
                        } else {
                            
                            let searchQueryFld = "usrId = '\((kprData as! [String:String])["usrId"] ?? "")'"
                            let tagData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: searchQueryFld) as! [FieldWorkerDetails]
                            
                            if tagData.count > 0 {
                                let tag = tagData[0]
                                
                                
                                DispatchQueue.main.async {
                                    self.createTags(strName: (tag.fnm)!, view: self.assignView)
                                }
                                
                                
                                self.FltWorkerId.append(tag.usrId!)
                                
                            }
                            
                        }
                    }
                    
                } else {
                  //  print("Not for you null")
                }
                
              //  print( self.FltWorkerId)
                
            }
            
        }
        
    }
    
    
    func showDateAndTimePicker(){
    // self.dateAndTimePicker.minimumDate = Date()
     self.bigView.isHidden = false
     UIView.animate(withDuration: 0.2)  {
         let frame = CGRect(x: 0, y: self.view.frame.size.height - 240, width: self.view.frame.size.width, height: 240)
         self.bigView.frame = frame

     }
    }
    
    @IBAction func btnDateTimeStrt(_ sender: Any) {
        removeOptionalView()
               isStartScheduleBtn = true
               self.bigView.isHidden = false
               self.showDateAndTimePicker()
    }
   
    @IBAction func btnDateTimeEnd(_ sender: Any) {
        removeOptionalView()
                     isStartScheduleBtn = false
                     self.bigView.isHidden = false
                     self.showDateAndTimePicker()
    }
    
   
    @IBAction func startDateBtn(_ sender: Any) {
        self.datePickerView.datePickerMode = .date
        
       
             
             let calendar = Calendar(identifier: .gregorian)
              var comps = DateComponents()
              comps.year = -5
              let minDate = calendar.date(byAdding: comps, to: Date())
             
               datePickerView.minimumDate = minDate
        startDates = true
        startDatee = false
        startTimes = false
        startTimee = false
        self.view.endEditing(true)
        self.bigView.isHidden = false
    }
    
    @IBAction func endDateBtn(_ sender: Any) {
        self.datePickerView.datePickerMode = .date
        let formatter = DateFormatter()
               formatter.dateFormat = "dd-MM-yyyy"
                  let dateText = formatter.date(from: lblStartDate.text!)
                  self.datePickerView.minimumDate = dateText
        
        startDates = false
        startDatee = true
        startTimes = false
        startTimee = false
        self.view.endEditing(true)
        self.bigView.isHidden = false
    }
    
    @IBAction func startTimeBtn(_ sender: Any) {
        self.datePickerView.datePickerMode = .time
        startTimes = true
        startDates = false
        startDatee = false
        startTimee = false
        self.view.endEditing(true)
        self.bigView.isHidden = false
    }
    
    @IBAction func endTmeBtn(_ sender: Any) {
        self.datePickerView.datePickerMode = .time
        startTimee = true
        startDates = false
        startDatee = false
        startTimes = false
        self.view.endEditing(true)
        self.bigView.isHidden = false
    }
    
    @IBAction func clientNameBtn(_ sender: Any) {
    }
    
    @IBAction func addFieldWorkerBtn(_ sender: Any) {
    }
    @IBAction func editAppointmentBtn(_ sender: Any) {
//        EditAppointment()
        if !isHaveNetowork() {
            if imgArr.count > 0 {
                
                ShowError(message: LanguageKey.offline_feature_alert, controller: windowController)
                
            }else{
                EditAppointment()
            }
        }else{
            OnlineEditAppointment()
        }
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.bigView.isHidden = true
    }
    @IBAction func attechmentBtn(_ sender: Any) {
        
        // openGallary()
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        
        isClear = false
        
        self.bigView.isHidden = true
        let date = self.datePickerView.date
        let formatter = DateFormatter()
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
               formatter.dateFormat = "dd-MM-yyyy h:mm a"
            }else{
                formatter.dateFormat = "dd-MM-yyyy HH:mm"
            }
        }
      //
        formatter.timeZone = TimeZone.current
        
        if let langCode = getCurrentSelectedLanguageCode() {
            formatter.locale = Locale(identifier: langCode)
        }
        
        let strDate = formatter.string(from: date)
        if(isStartScheduleBtn){
            let arr = strDate.components(separatedBy: " ")
            
            if arr.count == 2 {
                lblStartDate.text = arr[0]
                lblStartTime.text = arr[1]
            }else{
                lblStartDate.text = arr[0]
                lblStartTime.text = arr[1] + " " + arr[2]
            }
            
           
            
        }else{
            
            
            let schStartDate = self.lblStartDate.text! + " " +  self.lblStartTime.text!
            
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                if enableCustomForm == "0"{
                      let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy)
                            if(value == "orderedDescending"){
                                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                            }else{
                                let arr = strDate.components(separatedBy: " ")
                                
                                if arr.count == 2 {
                                    lblEndDate.text = arr[0]
                                    lblEndTime.text = arr[1]
                                }else{
                                    lblEndDate.text = arr[0]
                                    lblEndTime.text = arr[1] + " " + arr[2]
                                }
                            }
                  
                }else{
                       let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy_HH_mm)
                            if(value == "orderedDescending"){
                                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                            }else{
                                let arr = strDate.components(separatedBy: " ")
                                
                                if arr.count == 2 {
                                    lblEndDate.text = arr[0]
                                    lblEndTime.text = arr[1]
                                }else{
                                    lblEndDate.text = arr[0]
                                    lblEndTime.text = arr[1] + " " + arr[2]
                                }
                            }

                }
            }
            
        
        
        

        }
    }
    
    
    func callMethodforOpenDwop(tag : Int){
        if(self.optionalVw != nil){
            self.removeOptionalView()
            return
        }
        
        switch tag {
        case 0:
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 0
                
                self.arrOfShow = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
                if(arrOfShow.count > 0){
                    self.openDwopDown(txtField: self.txtAddFieldWorker, arr: self.arrOfShow)
                }
                //self.openDwopDown( txtField: txtAddFieldWorker, arr: arrOfShowData)
            }else{
                self.removeOptionalView()
            }
            
            
            break
            
        default:
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sltTxtField = textField
        self.sltDropDownBtnTag = textField.tag
        
        
        if txtAddFieldWorker == textField {
            self.callMethodforOpenDwop(tag: 0)
        }
        
        
    }
    
    
    //==============================================================//
    // open gallary method
    //==============================================================//
    
    func openGallary() {
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
                   
                    
                })
            }
        }
        
        let document = UIAlertAction(title: LanguageKey.document, style: .default)
        { _ in
            
           
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document", "com.microsoft.excel.xls","org.openxmlformats.spreadsheetml.sheet"], in: .import)
            //  documentPicker.delegate = self
            APP_Delegate.showBackButtonTextForFileMan()
            self.present(documentPicker, animated: true, completion: nil)
        }
        
        actionSheetControllerIOS8.addAction(gallery)
        actionSheetControllerIOS8.addAction(camera)
        actionSheetControllerIOS8.addAction(document)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           killLoader()
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
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
//            imgView.image = image as? UIImage
            
            if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
                                   let imgStruct = ImageModel_EditAppointmentVC(img: (info[.originalImage] as? UIImage)?.resizeImage_EditAppointmentVC(targetSize: CGSize(width: 1000.0, height: 10000.0)))
                               // imgView.image = (imgStruct.img!)
                
                self.addImageInline(image: (info[.originalImage] as? UIImage)!)
                                     let imgStructDes = ImageModel(img: (info[.originalImage] as? UIImage)?.resizeImage(targetSize: CGSize(width: 200.0, height: 200.0)), id: getTempIdForNewAttechment(newId: 0))
                                     imgArr.append(imgStructDes)
                                     self.H_Des.constant = 100
                                     stringToHtmlFormate()
        }
        
        
        
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
    //        if isarrOfShowData11 == true{
    //                          self.txtFieldData  = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
    //
    //              }else {
           // self.sltDropDownBtnTag = textField.tag
            let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            
            if (textField == txtPostalCode) {
                      
                      if (string != "") && (textField.text?.count)! > 7 {
                          return false
                      }
            }
        return true
    }
    
    //=====================================
    // MARK:- Optional view Detegate
    //=====================================
    
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if (sltDropDownTag == 0) {
            return arrOfShow.count
        }
        
        return 0
        
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.textLabel?.text = (self.arrOfShow[indexPath.row] as? FieldWorkerDetails)?.fnm?.capitalizingFirstLetter()
       
        
        return cell!
        
    }
    
    
    func optionView(_ OptiontableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if (sltDropDownTag == 0) {
            self.view.endEditing(true)
            let isExist = self.FltWorkerId.contains(((self.arrOfShow[indexPath.row] as? FieldWorkerDetails)?.usrId)!)
            if(!isExist){
                createTags(strName: ((self.arrOfShow[indexPath.row] as? FieldWorkerDetails)?.fnm)!, view: self.assignView)
                self.FltWorkerId.append(((self.arrOfShow[indexPath.row] as? FieldWorkerDetails)?.usrId)!)
            }
            self.txtAddFieldWorker.text = ""
            
        }
        
        self.removeOptionalView()
        
    }
    
    
    func removeOptionalView(){
        if optionalVw != nil {
            optionalVw?.removeFromSuperview()
            optionalVw = nil
        }
    }
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        
        
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
    
    func openDwopDownForConstactHeight(txtField : UITextField , arr : [Any]) {
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x:10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height ), width: self.view.frame.size.width - 20, height: 100))
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
    
    //====================================================
    //MARK:-  Create Tags
    //====================================================
    func createTags(strName : String , view : ASJTagsView){
        view.addTag(strName, withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: true)
        view.deleteBlock = {(tagText : String ,idx : Int) -> Void in
            view.deleteTag(at: idx)
            self.FltWorkerId.remove(at: idx)
        }
    }
    
    
    
    func getTempIdForNewJob(newId : Int) -> String {
        
        return "Appointment-\(String(describing: getUserDetails()?.usrId ?? ""))-\(getCurrentTimeStamp())"
        
    }
    
    //====================================================
    //MARK:-  Edit Appointment
    //====================================================
    
    func EditAppointment(){
        
        let param = Params()
        param.cltId = editArrayData?.cltId
        param.conId = editArrayData?.conId
        param.siteId = editArrayData?.siteId
        param.appId = editArrayData?.commonId
        param.des = txtDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.mob1 = txtMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.mob2 = ""//txtField_AltMobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.adr = txtAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.cnm = ""//txtClientName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.city = txtCityName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.zip = txtPostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        param.memIds = (FltWorkerId.count == 0 ? [] : FltWorkerId)
        param.clientForFuture = ""
        param.siteForFuture = "0"
        param.contactForFuture = "0"
        
        var schTime12 = ""
        var endTime12 = ""
        
        let dateFormatter = DateFormatter()
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                dateFormatter.dateFormat = "h:mm a"
            }else{
                dateFormatter.dateFormat = "HH:mm"
            }
        }
      //  dateFormatter.dateFormat = "h:mm a"
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter.locale = Locale(identifier: langCode)
        }
        let date = dateFormatter.date(from: self.lblStartTime.text!)
        dateFormatter.dateFormat = "HH:mm:ss"
        schTime12 = dateFormatter.string(from: date!)
        
        
        let dateFormatter1 = DateFormatter()
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                dateFormatter1.dateFormat = "h:mm a"
            }else{
                dateFormatter1.dateFormat = "HH:mm"
            }
        }
       // dateFormatter1.dateFormat = "h:mm a"
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter1.locale = Locale(identifier: langCode)
        }
        let date1 = dateFormatter1.date(from: self.lblEndTime.text!)
        dateFormatter1.dateFormat = "HH:mm:ss"
        endTime12 = dateFormatter1.string(from: date1!)
     
        
        param.schdlStart =  (self.lblStartDate.text! + " " + schTime12)
        param.schdlFinish =  (self.lblEndDate.text! + " " + endTime12)
        
        var schdlStartDateTime = ""
        var schdlFinishDateTime = ""
        
        if param.schdlStart != "" {
            schdlStartDateTime = convertDateStringToTimestampAppoiment(dateString: param.schdlStart!)
        }
        
        if param.schdlFinish != "" {
            schdlFinishDateTime = convertDateStringToTimestampAppoiment(dateString: param.schdlFinish!)
        }
        //
        param.schdlStart = schdlStartDateTime
        param.schdlFinish = schdlFinishDateTime
        
        if commanIdBool == true {
            let searchQuery = "appId = '\(commanIdEdit ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: searchQuery) as! [AppointmentList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                existingJob.setValuesForKeys(param.toDictionary!)
                existingJob.kpr = (FltWorkerId.count == 0 ? [] : FltWorkerId) as NSObject?
                
            }
        }else {
            let searchQuery = "appId = '\(editArrayData?.commonId! ?? "")'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: searchQuery) as! [AppointmentList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                existingJob.setValuesForKeys(param.toDictionary!)
                existingJob.kpr = (FltWorkerId.count == 0 ? [] : FltWorkerId) as NSObject?
                
            }
        }
       
        
        
        DatabaseClass.shared.saveEntity(callback: {isSuccess in
           
            param.schdlStart =  (self.lblStartDate.text! + " " + schTime12)
            param.schdlFinish =  (self.lblEndDate.text! + " " + endTime12)
            
            DatabaseClass.shared.saveOffline(service: Service.updateAppointment, param: param)
            self.navigationController?.popToRootViewController(animated: true)
        })
        
    
    }
    
    func OnlineEditAppointment(){
       var params = [String: Any]()
       let param = Params()
       params["cltId"] = editArrayData?.cltId
       params["conId"] = editArrayData?.conId
       params["siteId"] = editArrayData?.siteId
       params["appId"] = editArrayData?.commonId
       params["des"] = self.stringToHtml //txtDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       params["email"] = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       params["mob1"] = txtMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       params["mob2"] = ""//txtField_AltMobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       params["adr"] = txtAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       params["cnm"] = ""//txtClientName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       params["city"] = txtCityName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       params["zip"] = txtPostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       params["memIds"] = (FltWorkerId.count == 0 ? [] : FltWorkerId)
       params["clientForFuture"] = ""
       params["siteForFuture"] = "0"
       params["contactForFuture"] = "0"
       
       var schTime12 = ""
       var endTime12 = ""
       
       let dateFormatter = DateFormatter()
       if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
           if enableCustomForm == "0"{
               dateFormatter.dateFormat = "h:mm a"
           }else{
               dateFormatter.dateFormat = "HH:mm"
           }
       }
     //  dateFormatter.dateFormat = "h:mm a"
       if let langCode = getCurrentSelectedLanguageCode() {
           dateFormatter.locale = Locale(identifier: langCode)
       }
       let date = dateFormatter.date(from: self.lblStartTime.text!)
       dateFormatter.dateFormat = "HH:mm:ss"
       schTime12 = dateFormatter.string(from: date!)
       
       
       let dateFormatter1 = DateFormatter()
       if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
           if enableCustomForm == "0"{
               dateFormatter1.dateFormat = "h:mm a"
           }else{
               dateFormatter1.dateFormat = "HH:mm"
           }
       }
      // dateFormatter1.dateFormat = "h:mm a"
       if let langCode = getCurrentSelectedLanguageCode() {
           dateFormatter1.locale = Locale(identifier: langCode)
       }
       let date1 = dateFormatter1.date(from: self.lblEndTime.text!)
       dateFormatter1.dateFormat = "HH:mm:ss"
       endTime12 = dateFormatter1.string(from: date1!)
    
       
       params["schdlStart"] =  (self.lblStartDate.text! + " " + schTime12)
       params["schdlFinish"] =  (self.lblEndDate.text! + " " + endTime12)
       
       var schdlStartDateTime = ""
       var schdlFinishDateTime = ""
       
       if param.schdlStart != "" {
         //  schdlStartDateTime = convertDateStringToTimestampAppoiment(dateString: param.schdlStart!)
       }
       
       if param.schdlFinish != "" {
          // schdlFinishDateTime = convertDateStringToTimestampAppoiment(dateString: param.schdlFinish!)
       }
       //
      // param.schdlStart = schdlStartDateTime
       //param.schdlFinish = schdlFinishDateTime
        print(param.toDictionary)
    
        
        serverCommunicatorUplaodImageInArrayForInputField(url: Service.updateAppointment, param: params, images: imgArr , imagePath:"appDoc[]") { (response, success) in
               killLoader()
               DispatchQueue.main.async {
                   self.navigationController?.popToRootViewController(animated: true)
               }
               if(success){
                   let decoder = JSONDecoder()
                   if let decodedData = try? decoder.decode(AddAppointmentRes.self, from: response as! Data) {
                       // self.navigationController?.popToRootViewController(animated: true)
                       if decodedData.success == true{
                           
                           DispatchQueue.main.async {
                               killLoader()
                               self.navigationController?.popToRootViewController(animated: true)
                               self.showToast(message:LanguageKey.update_appointment)
                                self.navigationController?.popViewController(animated: true)
                           }
                       }else{
                           ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                       }
                   }else{
                       
                       // ShowError(message: AlertMessage.formatProblem, controller: windowController)
                   }
               }else{
                   //ShowError(message: "Please try again!", controller: windowController)
               }
           }
    }
    
    @IBAction func btnAddImage(_ sender: Any) {
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
                 showLoader()
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = false
                APP_Delegate.showBackButtonText()
                self.present(self.imagePicker, animated: true, completion: {
                    
                    
                })
            }
        }
        actionSheetControllerIOS8.addAction(gallery)
        actionSheetControllerIOS8.addAction(camera)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
}

struct ImageModel_EditAppointmentVC {
    var img: UIImage?
   
}

extension UIImage {
    func resizeImage_EditAppointmentVC(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

//=================================
//MARK: View controller Extension
//=================================
extension EditAppointmentVC{
    
    func getTempIdForNewAttechment(newId : Int) -> String {
        
        return "\(getCurrentTimeStamp())"
        
    }
    //PickerView Delegate Methods
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        self.addImageInline(image: (info[.originalImage] as? UIImage)!)
//
//
//        let imgStruct = ImageModel(img: (info[.originalImage] as? UIImage)?.resizeImage(targetSize: CGSize(width: 200.0, height: 200.0)), id: getTempIdForNewAttechment(newId: 0))
//        imgArr.append(imgStruct)
//        self.H_JobDes.constant = self.H_JobDes.constant+100
//
//
//
//        stringToHtmlFormate()
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("Did cancel")
//        //self.H_JobDes.constant = 50
//        picker.dismiss(animated: true, completion: nil)
//    }

    //=================================
    //MARK: Other methods
    //=================================
    func addImageInline(image: UIImage) {
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        //images.append(image)
        let oldwidth: CGFloat = textAttachment.image?.size.width ?? 0

        let scaleFactor = oldwidth/150 // resize image
        textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)

        textView.textStorage.insert(attrStringWithImage, at: textView.selectedRange.location)
    }

    //====================================================//
    // convert string to html formate
    //====================================================//
    func stringToHtmlFormate(){
        let finalText = self.textView.attributedText

        DispatchQueue.global(qos: .background).async {
            self.stringToHtml = finalText!.toHtml() ?? ""
            let urlPaths = self.stringToHtml.imagePathsFromHTMLString()
            //print(urlPaths)// get all images fake paths

            for (index,model) in self.imgArr.enumerated() {
                let imageId = "_jobAttSeq_\(index)_"
                if imageId != "" {
                     self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
                }
               // self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
            }

            //print(self.stringToHtml)

            DispatchQueue.main.async {
                  killLoader()
                print("Successfully converted string to HTML")
            }
        }
    }
}
