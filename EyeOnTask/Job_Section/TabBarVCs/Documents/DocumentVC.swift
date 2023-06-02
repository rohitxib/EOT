//
//  DocumentVC.swift
//  EyeOnTask
//
//  Created by mac on 09/10/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import CoreData
import Photos
import MobileCoreServices
import IQKeyboardManagerSwift

class DocumentVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,OptionViewDelegate {
    
    @IBOutlet weak var collectionVwDocs: UICollectionView!
    @IBOutlet weak var lblAlertMess: UILabel!
    @IBOutlet weak var txtSearchField: UITextField!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet var backgoundView: UIView!
    @IBOutlet weak var DefaultJobCrdView: UIView!
    @IBOutlet weak var SelectSingnatureView: UIView!
    @IBOutlet weak var EmailJobCrdView: UIView!
    @IBOutlet weak var PrntJobCardView: UIView!
    @IBOutlet weak var EmailJobLbl: UILabel!
    @IBOutlet weak var SelectTemplatetxtfild: FloatLabelTextField!
    @IBOutlet weak var SelectSingnaturetxtfied: FloatLabelTextField!
    @IBOutlet weak var PrintJobLbl: UILabel!
    var imgpalecholdar : UIImage?
    var optionalVw : OptionalView?
    var arrayTypes =  ""
    var templatId = ""
    var jobIdPrint11  = ""
    var templateVelues = ""
    var demoArr11 = ["1","2","3"]
    var fwAr = [Any]()
    var jobIdPrints  = [Any]()
    var JobCardTemplatAr = [JobCardTemplat]()
    var query : String = ""
  
    var imagePicker = UIImagePickerController()
    var objOfUserJobListInDoc = UserJobList()
    var arrOfShowData = [DocResDataDetails]()
    var arrOfFilterData = [DocResDataDetails]()
    var uploadImage : UIImage? = nil
    var callback: ((Bool,NSManagedObject) -> Void)?
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var refreshControl = UIRefreshControl()
    var imgName = ""
     var imgArr = [ImageModel_DocumentVC]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgoundView.isHidden = true
        var isJobCardHide = "False"
        UserDefaults.standard.set(isJobCardHide, forKey: "isJobCardHide")
        
        self.title = LanguageKey.title_documents
        txtSearchField.placeholder = LanguageKey.search
        lblAlertMess.text = LanguageKey.documet_appear
        self.setUpMethod()
        self.getDocumentsList()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: screenWidth/2 - 7, height: screenWidth/2 - 7)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        collectionVwDocs!.collectionViewLayout = layout
        
        
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        collectionVwDocs.addSubview(refreshControl) // not required when using UITableViewController
        
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
              swipeRight.direction = UISwipeGestureRecognizer.Direction.right
              self.view.addGestureRecognizer(swipeRight)
              
              let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
              swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
              self.view.addGestureRecognizer(swipeLeft)
              
        
        
        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobDocuments)
        
        getJobCardTemplates()
        
        self.EmailView.isHidden = true
        let kprVar = objOfUserJobListInDoc.kpr
        let kprArr = kprVar?.components(separatedBy: ",")
        
        var count : Int = 0
        var query : String = ""
        for item in kprArr! {

            if  count == 0 {
                query = "(usrId = \(item))"
            }else{
                query = query + " OR (usrId = \(item))"
            }
            count = count + 1
        }
       
        let fildW = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: query) as! [FieldWorkerDetails]
        for fw in fildW {
            fwAr.append(("\(String(describing: fw.fnm!)) \(String(describing: fw.lnm!))"))
            jobIdPrints.append(("\(String(describing: fw.usrId!))"))
            self.SelectSingnaturetxtfied.text = "\(String(describing: fw.fnm!)) \(String(describing: fw.lnm!))"
        }

        let leftButton = UIBarButtonItem(title: LanguageKey.job_card_bold, style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = leftButton
       NotificationCenter.default.addObserver(self, selector: #selector(NotificationResive), name: Notification.Name ("DocumentVC"), object: nil)
        
    }


    @objc func NotificationResive(){
      //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DocumentVC") , object: nil)
        showBackgroundView()
        view.addSubview(EmailView)
        self.EmailView.isHidden = false
        EmailView.center = CGPoint(x: backgoundView.frame.width/2, y: backgoundView.frame.height/2)
        print("tepdocument")
    }
    
    @objc func addTapped(){
    }
    func showBackgroundView() {
        self.backgoundView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.backgoundView.backgroundColor = UIColor.black
            self.backgoundView.alpha = 0.5
        })
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
        if (EmailView != nil) {
            EmailView.removeFromSuperview()
        }
        
        self.backgoundView.isHidden = true
        self.backgoundView.backgroundColor = UIColor.clear
        self.backgoundView.alpha = 1
    }
    @IBAction func SelectTemplatebtn(_ sender: UIButton) {
        arrayTypes = "2"
        self.forDefaultJobCrdOpenDwopDown()

    }
    
    @IBAction func SelectSingnaturebtn(_ sender: UIButton) {
        
        arrayTypes = "1"
        self.foSelectSingnatureOpenDwopDown()
    }
    
    @IBAction func EmailJobBtn(_ sender: Any) {
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        self.backgoundView.isHidden = false
        self.EmailView.isHidden = true
        ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoiceEmail)
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EMAILINVOICE") as! EmailInvoiceVC
        vc.isJobDetail = true
        vc.jobIdDetail = objOfUserJobListInDoc.jobId as! String
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func PrintJobBtn(_ sender: Any) {
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        self.backgoundView.isHidden = false
        self.EmailView.isHidden = true
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pdfvc") as! ShowPdfVC
        vc.pdfDetailJob = true
        vc.pdfDetailJobId =  objOfUserJobListInDoc.jobId!
        vc.jobIdLabel = objOfUserJobListInDoc.label as! String
        vc.templateIdPrint = templatId
        vc.jobIdForPrint = jobIdPrint11
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
    
    }
    
    @IBAction func topOnbackgud(_ sender: Any) {
        hideBackgroundView()
       
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayTypes == "1" {
            return fwAr.count
        }else if self.arrayTypes == "2" {
            return JobCardTemplatAr.count
        }
        return jobIdPrints.count
        
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"cell")
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier:"cell")
        }
        if self.arrayTypes == "1" {
            if demoArr11.count != 0 {
                var ar = jobIdPrints[indexPath.row] as! String
                cell?.textLabel?.text = fwAr[indexPath.row] as! String
            }
        }else if self.arrayTypes == "2" {
            if fwAr.count != 0 {
                cell?.textLabel?.text = JobCardTemplatAr[indexPath.row].tempJson1?.clientDetails![0].inputValue
            }
            
        }
        
        
        return cell!
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrayTypes == "1" {
            self.SelectSingnaturetxtfied.text = fwAr[indexPath.row] as! String
            self.jobIdPrint11 = jobIdPrints[indexPath.row] as! String
            self.removeOptionalView()
         
           
        }else if self.arrayTypes == "2" {
            self.SelectTemplatetxtfild.text = JobCardTemplatAr[indexPath.row].tempJson1?.clientDetails![0].inputValue
            self.templatId = JobCardTemplatAr[indexPath.row].jcTempId ?? ""
            self.removeOptionalView()
          
        }
        
     
    }
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
    // ================================
    //  MARK: Open Drop Down jobcard
    // ================================
    func foSelectSingnatureOpenDwopDown() {

        if (optionalVw == nil){
            self.backgoundView.isHidden = false
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = SelectSingnatureView.convert(SelectSingnatureView.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 20, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height-5), width: self.view.frame.size.width - 40, height: 150))
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

    func forDefaultJobCrdOpenDwopDown() {

        if (optionalVw == nil){
            self.backgoundView.isHidden = false
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = DefaultJobCrdView.convert(DefaultJobCrdView.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 20, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height-5), width: self.view.frame.size.width - 40, height: 150))
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
   
    func getJobCardTemplates(){

        let param = Params()
       
        param.limit = "120"
        
        serverCommunicator(url: Service.getJobCardTemplates, param: param.toDictionary) { (response, success) in
               killLoader()
               if(success){
                   let decoder = JSONDecoder()
                   if let decodedData = try? decoder.decode(JobCardTemplatesRs.self, from: response as! Data) {
                       
                       if decodedData.success == true{
                           
                           self.JobCardTemplatAr = decodedData.data as! [JobCardTemplat]
                           DispatchQueue.main.async {
                               let arr = self.JobCardTemplatAr[0]
                               print( "\(String(describing: arr.tempJson1?.clientDetails![0].inputValue ?? ""))")
                               
                               self.templateVelues = "\(String(describing: arr.tempJson1?.clientDetails![0].inputValue ?? ""))"
                               self.SelectTemplatetxtfild.text =  self.templateVelues
                             //  self.txtFldInvoiceTmplt.text = self.templateVelue
                               self.templatId = arr.jcTempId ?? ""
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
   

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = LanguageKey.title_documents
        
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = true
            button.tintColor = UIColor.white
        }
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
      
    
    @objc func refreshControllerMethod() {
        getDocumentsList()
    }
    
    
    func setUpMethod(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearchField.frame.height))
        txtSearchField.leftView = paddingView
        txtSearchField.leftViewMode = UITextField.ViewMode.always
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtSearchField.frame.height))
        txtSearchField.rightView = paddingView1
        txtSearchField.rightViewMode = UITextField.ViewMode.always
    }
    
    
    
    
    @IBAction func galleryBtn(_ sender: Any) {
        openGallery()
    }
    
    //=============================
    // MARK:- Open gallery methods
    //=============================
    func openGallery(){
        
        
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: LanguageKey.please_select, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: LanguageKey.cancel , style: .cancel) { _ in
            // print("Cancel")
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
            
            
            let kUTTypeDOC = "com.microsoft.word.doc" // for Doc file
            let kUTTypeDOCX = "org.openxmlformats.wordprocessingml.document" // for Docx file
            let kUTTypeXls = "com.microsoft.excel.xls"
            let kUTTypeXlsx = "org.openxmlformats.spreadsheetml.sheet"
            
            //'jpg','png','jpeg','pdf','doc','docx','xlsx','csv','xls'
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePNG),String(kUTTypeJPEG),String(kUTTypePDF),String(kUTTypeCommaSeparatedText),kUTTypeXls,kUTTypeXlsx,kUTTypeDOCX,kUTTypeDOC], in: .import)
            documentPicker.delegate = self
            APP_Delegate.showBackButtonTextForFileMan()
            self.present(documentPicker, animated: true, completion: nil)
        }
        
        actionSheetControllerIOS8.addAction(gallery)
        actionSheetControllerIOS8.addAction(camera)
        actionSheetControllerIOS8.addAction(document)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
       // let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
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
                    // for index in 0..<imageAsset.count{
                    
                    if imageAsset.count > 0{
                        let asset = imageAsset.firstObject
                        let imgFullName = asset?.value(forKey: "filename") as! String
                        let arr = imgFullName.components(separatedBy: ".")
                        let imgExtension = arr.last
                        let imgName = imgFullName.replacingOccurrences(of: ".\(imgExtension!)", with: "")
                       // if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
         if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
                let imgStruct = ImageModel_DocumentVC(img: (info[.originalImage] as? UIImage)?.resizeImage_DocumentVC(targetSize: CGSize(width: 3042, height: 4032)))// 3042x4032
                            DispatchQueue.main.async {
                                  let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                  let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                                    // vc.image = (image as! UIImage)
                                      vc.image = (imgStruct.img!)
                                  vc.name = trimString(string: imgName)
                                  vc.callback = {(modifiedImage, imageName, imageDescription) in
                                    self.uploadImage = modifiedImage
                                      self.imgpalecholdar = vc.imgView.image
                                    self.uploadDocuments(imgName: imageName, imageDes: imageDescription) { () -> (Void) in
                                        DispatchQueue.main.async {
                                             vc.navigationController?.popViewController(animated: true)
                                        }
                                    }
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
    
//    func openImageNameAlert(imgName : String, fileUrl:URL){
//        
//        ////////////// Alert Method //////////////
//        let alert = UIAlertController(title:"", message: AlertMessage.changeImageName, preferredStyle: .alert)
//        var txtField = UITextField()
//        alert.addTextField { (textField) in
//            let textField = alert.textFields![0]
//            textField.text = imgName
//            txtField = textField
//        }
//        
//        
//        
//        alert.addAction(UIAlertAction(title: LanguageKey.cancel, style: .default, handler: { ( done ) in
//        }))
//        
//        alert.addAction(UIAlertAction(title: LanguageKey.done, style: .cancel, handler: { ( done ) in
//            self.uploadMediaDocuments(fileUrl: fileUrl, fileName: txtField.text!)
//        }))
//        
//        windowController.present(alert, animated: true, completion: nil)
//        
//    }
    //==========================
    // MARK:- Textfield methods
    //==========================
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        self.arrOfFilterData.removeAll()
        
        if result.count > 2 || result.count == 0 {
            if result != "" {
                self.arrOfFilterData = self.arrOfShowData.filter() { ($0.attachFileActualName?.lowercased().contains(result.lowercased()))! }
            }
            
            self.collectionVwDocs.isHidden = ((self.arrOfFilterData.count > 0) || (result == "")) ? false : true
            
            DispatchQueue.main.async {
                self.collectionVwDocs.reloadData()
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    //=====================================
    // MARK:- Get all Document List Service
    //=====================================
    
    func getDocumentsList(){
        /*
         jobId -> Job  id
         */
        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                self.lblAlertMess.isHidden = false
                self.collectionVwDocs.isHidden = true
                 killLoader()
            }
            return
        }
        
        // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getDocumentsList) as? String
        showLoader()
        let param = Params()
        param.jobId = objOfUserJobListInDoc.jobId
        param.usrId = getUserDetails()?.usrId
        
        serverCommunicator(url: Service.getDocumentsList, param: param.toDictionary) { (response, success) in
            killLoader()
            
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(DocumentRes.self, from: response as! Data) {
                    DispatchQueue.main.async {
                        self.lblAlertMess.isHidden = true
                    }
                    
                    if decodedData.success == true{
                        
                        if (decodedData.data?.count ?? 0) > 0 {
                            
                             self.arrOfShowData.removeAll()
                            
                            DispatchQueue.main.async {
                                
                                
                                let obj = decodedData.data![0]
                                if (obj.jobid != nil && obj.jobid != ""){ //Only For Remove job when Admin Unassign job for FW
                                    ShowAlert(title: "", message: AlertMessage.removeJobFromAdmin, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (isCancel, isOk) in
                                        if(isCancel){
                                            ChatManager.shared.removeJobForChat(jobId: obj.jobid!)
                                            DatabaseClass.shared.deleteEntity(object: self.objOfUserJobListInDoc, callback: { (isDelete : Bool) in
                                                if (self.callback != nil){
                                                    self.callback!(true, self.objOfUserJobListInDoc)
                                                }
                                            })
                                        }
                                    })
                                }else{
                                    self.collectionVwDocs.isHidden = false
                                    self.arrOfShowData = decodedData.data!
                                    self.collectionVwDocs.reloadData()
                                }
                                
                            }
                            
                        }else{
                            
                            DispatchQueue.main.async {
                                self.lblAlertMess.isHidden = false
                                self.collectionVwDocs.isHidden = true
                                
                            }
                        }
                        
                        
                    }else{
                        
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
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                ShowError(message: errorString, controller: windowController)
            }
        }
    }
    
    
    //=====================================
    // MARK:- Update Document Description
    //=====================================
    
    func updateDocumentDescription(documentid : String, documentDescription : String, completion : @escaping (()->(Void))) {
        /*
         jobId -> Job  id
         */
        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                self.lblAlertMess.isHidden = false
                self.collectionVwDocs.isHidden = true
                
            }
            return
        }
        var isSaveComplationNotes = ""
               isSaveComplationNotes =   UserDefaults.standard.value(forKey: "SaveComplationNotesKey") as? String ?? ""
        // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getDocumentsList) as? String
         showLoader()
        let param = Params()
        param.jaId = documentid
        param.des = documentDescription
      //  param.isAddAttachAsCompletionNote = isSaveComplationNotes
        
        serverCommunicator(url: Service.updateDocument, param: param.toDictionary) { (response, success) in
            killLoader()
            
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            
            completion()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(CommonResponse.self, from: response as! Data) {
                    DispatchQueue.main.async {
                        self.lblAlertMess.isHidden = true
                    }
                    
                    if decodedData.success == true{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }else{
                        
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
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                ShowError(message: errorString, controller: windowController)
            }
        }
    }
    
    
    
    //=====================================
    // MARK:- Upload Document Service
    //=====================================
    
    func uploadDocuments(imgName : String, imageDes : String, completion : @escaping (()->(Void))) -> Void {
        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            }
            return
        }
        var isSaveComplationNotes = ""
        isSaveComplationNotes = UserDefaults.standard.value(forKey: "SaveComplationNotesKey") as? String ?? ""
        
        //showLoader()
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.jobId = objOfUserJobListInDoc.jobId
        param.type = "2"
        param.device_Type = "2"
        param.des = imageDes
        param.docNm = imgName
      //  param.isAddAttachAsCompletionNote = isSaveComplationNotes
        
        serverCommunicatorUplaodImage(url: Service.uploadDocument, param: param.toDictionary, image: uploadImage, imagePath: "ja", imageName: imgName) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                
                completion()
                
                if let decodedData = try? decoder.decode(AddDocumentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            
                            killLoader()
                            
                            if(decodedData.data!.count > 0){
                                self.lblAlertMess.isHidden = true
                                self.collectionVwDocs.isHidden = false
                                self.arrOfShowData.insert(decodedData.data![0], at: 0)
                                self.collectionVwDocs.reloadData()
                             
                               // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                
                            }else{
                                killLoader()
                                ShowAlert(title: LanguageKey.success, message:getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                            }
                        }
                    }else{
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
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                killLoader()
                ShowError(message: errorString, controller: windowController)
            }
        }
    }

}

extension DocumentVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfFilterData.count > 0 ? self.arrOfFilterData.count :  self.arrOfShowData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "docCell", for: indexPath as IndexPath) as! DocumentCell
        let docResDataDetailsObj = self.arrOfFilterData.count > 0 ? self.arrOfFilterData[indexPath.row] :  self.arrOfShowData[indexPath.row]
        
        cell.lblName.text = docResDataDetailsObj.attachFileActualName
        imgName = cell.lblName.text ?? ""
        
        if indexPath.row == 0 {
            
            cell.loader.isHidden = false
            cell.loader.startAnimating()
            if let img = docResDataDetailsObj.attachThumnailFileName {
                let imageUrl = Service.BaseUrl + img
                cell.img.sd_setImage(with:  URL(string: imageUrl), placeholderImage:self.imgpalecholdar, completed: { [weak self] (image, error, cacheType, imageURL) in
                    cell.loader.isHidden = true
                    cell.loader.stopAnimating()
                })
                
            }else{
                cell.img.image = UIImage(named: "unknownDoc")
            }
        }else {
            cell.loader.isHidden = true
            cell.loader.stopAnimating()
            if let img = docResDataDetailsObj.attachThumnailFileName {
                let imageUrl = Service.BaseUrl + img
                cell.img.sd_setImage(with:  URL(string: imageUrl), placeholderImage: getImage(fileType: docResDataDetailsObj.attachThumnailFileName ?? "unknownDoc"), completed: { [weak self] (image, error, cacheType, imageURL) in
                    cell.img.image = image
                })
            }else{
                cell.img.image = UIImage(named: "unknownDoc")
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let DocResDataDetailsObj = self.arrOfFilterData.count > 0 ? self.arrOfFilterData[indexPath.item] :  self.arrOfShowData[indexPath.item]
        
        
        if DocResDataDetailsObj.attachFileActualName != "signature" {
            
            if DocResDataDetailsObj.type == "1" {
                DispatchQueue.main.async {
                    if let fileUrl = URL(string: (Service.BaseUrl + DocResDataDetailsObj.attachFileName!)) {
                        let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                            vc.name = trimString(string: DocResDataDetailsObj.attachFileActualName ?? "")
                            vc.docUrl = fileUrl
                            vc.isSignature = true
                            self.navigationController!.pushViewController(vc, animated: true)
                    }
                }
                 return
            }
            
            
            if let fileUrl = URL(string: (Service.BaseUrl + DocResDataDetailsObj.attachFileName!)) {
                let customView = CustomDocView.instanceFromNib() as? CustomDocView
                let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
                    backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
                    
                customView!.setupMethod(url: fileUrl, image: nil, imageName: DocResDataDetailsObj.attachFileActualName ?? "", imageDescription: DocResDataDetailsObj.des ?? "")
                    customView?.completionHandler = {(editedName,editedDes) in
               
                        if DocResDataDetailsObj.des != editedDes {
                            self.updateDocumentDescription(documentid: DocResDataDetailsObj.attachmentId!, documentDescription: editedDes) {
                                   DocResDataDetailsObj.des = editedDes
                                   DispatchQueue.main.async {
                                        customView?.removeFromSuperview()
                                        backgroundView.removeFromSuperview()
                                    }
                                      
                               }
                        }else{
                            DispatchQueue.main.async {
                                customView?.removeFromSuperview()
                                backgroundView.removeFromSuperview()
                            }
                        }
                    }
                             
                  let viewWidth = self.view.bounds.width
                  let viewHeight = self.view.bounds.height
                   
                   customView!.frame = CGRect(x: (viewWidth/2-(customView!.bounds.width/2)), y: (viewHeight/2-(customView!.bounds.height/2)), width: customView!.bounds.width, height:  customView!.bounds.height)

                   self.view.addSubview(backgroundView)
                   self.view.addSubview(customView!)
            }else{
                ShowError(message: LanguageKey.format_problem, controller: windowController)
            }
            
            
        }
  
    }
    
    func getImage(fileType : String) -> UIImage {
        
        //'jpg','png','jpeg','pdf','doc','docx','xlsx','csv','xls'
        
        let filename: NSString = fileType as NSString
        let pathExtention = filename.pathExtension
        
        var imageName = ""
        switch pathExtention {
        case "jpg","png","jpeg":
            imageName = "default-thumbnail"
            
        case "pdf":
            imageName = "pdf"
            
        case "doc","docx":
            imageName = "word"
            
        case "xlsx","xls":
            imageName = "excel"
            
        case "csv":
            imageName = "csv"
            
        default:
            imageName = "unknownDoc"
        }
        
        let image = UIImage(named: imageName)
        return image!
        
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


extension DocumentVC: UIDocumentPickerDelegate {

    //=============================
    // MARK:- Document picker methods
    //=============================
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        APP_Delegate.hideBackButtonText()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        
        let filename = url.lastPathComponent
        let splitName = filename.split(separator: ".")
        let name = splitName.first!
        let filetype = splitName.last!.lowercased()
        
        APP_Delegate.hideBackButtonText()
        
        //'jpg','png','jpeg'
        if filetype == "jpg" || filetype == "png" || filetype == "jpeg" {
            
                do {
                    let imageData = try Data(contentsOf: url as URL)
    
                    if let image = UIImage(data: imageData) {
                        let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                        vc.image = (image )
                        vc.name = trimString(string: String(name))
                        vc.callback = {(modifiedImage, imageName, imageDescription) in
                          self.uploadImage = modifiedImage
                          self.uploadDocuments(imgName: imageName, imageDes: imageDescription) { () -> (Void) in
                              DispatchQueue.main.async {
                                   vc.navigationController?.popViewController(animated: true)
                              }
                          }
                      }
                        DispatchQueue.main.async {
                          self.navigationController!.pushViewController(vc, animated: true)
                        }
                    }
                }catch {
                    // can't load image data
                }
        }else{
            
            DispatchQueue.main.async {
                  let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                  let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                  //vc.image = (image as! UIImage)
                  vc.name = trimString(string: String(name))
                  vc.docUrl = url
                  vc.callbackForDocument = {(fileName, fileDescription) in
                    self.uploadMediaDocuments(fileUrl: url, fileName: fileName, description: fileDescription) { () -> (Void) in
                         DispatchQueue.main.async {
                             vc.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                }
                  self.navigationController!.pushViewController(vc, animated: true)
            }
        
        }
        
    }
    
    func uploadMediaDocuments(fileUrl : URL ,fileName : String, description : String, completion : @escaping (()->(Void))) -> Void {
        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            }
            return
        }
        
      //  showLoader()
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.jobId = objOfUserJobListInDoc.jobId
        param.type = "2"
        param.device_Type = "2"
        param.des = description
        
        serverCommunicatorUplaodDocuments(url: Service.uploadDocument, param: param.toDictionary, docUrl: fileUrl, DocPathOnServer: "ja", docName: fileName) { (response, success) in
            
            completion()
            
            if(success){
                
                
                
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AddDocumentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            
                            killLoader()
                            
                            if(decodedData.data!.count > 0){
                                self.lblAlertMess.isHidden = true
                                self.collectionVwDocs.isHidden = false
                                self.arrOfShowData.insert(decodedData.data![0], at: 0)
                                self.collectionVwDocs.reloadData()
                               // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                
                            }else{
                                killLoader()
                                ShowAlert(title: LanguageKey.success, message:getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                            }
                        }
                    }else{
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
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                killLoader()
                ShowError(message: errorString, controller: windowController)
            }
        }
        
        
        
        //        let storageRef = Storage.storage().reference().child("\((getUserDetails()?.compId)!)/\(objOfUserJobListInDetail!.jobId!)/\(getCurrentTimeStamp())_\(fileName)")
        //
        //        // let uploadTask =    storageRef.putData(uploadData, metadata: metaData){ (metadata, error) in
        //        let uploadTask =    storageRef.putData(uploadData, metadata: nil){ (metadata, error) in
        //            if error != nil {
        //                //print("error")
        //                completion(nil, nil)
        //            } else {
        //                let imageURL = Storage.storage().reference(forURL:  Storage.storage().reference().description).child((metadata?.path!)!)
        //                imageURL.downloadURL(completion: { (url, error) in
        //                    completion("\(url!)", metadata?.contentType)
        //                })
        //            }
        //        }
        //
        //
        //        //When uploading  is inprogress ....
        //        uploadTask.observe(.progress, handler: { (snapshot) in
        //            guard let progress = snapshot.progress else {
        //                return
        //            }
        //
        //            let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
        //            if self.loadingNotification == nil{
        //                self.loadingNotification = MBProgressHUD.showAdded(to: windowController.view, animated: true)
        //            }
        //            self.loadingNotification!.mode = MBProgressHUDMode.determinateHorizontalBar
        //            self.loadingNotification!.label.text = "\(Int(percentage))%"
        //            self.loadingNotification?.detailsLabel.text = "Uploading..."
        //            self.loadingNotification!.progressObject = progress
        //        })
        //
        //        //When uploading completed...
        //        uploadTask.observe(.success) { snapshot in
        //            DispatchQueue.main.async {
        //                MBProgressHUD.hide(for: windowController.view, animated: true)
        //                self.loadingNotification = nil
        //            }
        //        }
    }
    
}

struct ImageModel_DocumentVC {
    var img: UIImage?
   
}

extension UIImage {
    func resizeImage_DocumentVC(targetSize: CGSize) -> UIImage {
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
