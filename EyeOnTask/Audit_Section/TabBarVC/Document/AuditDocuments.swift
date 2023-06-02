//
//  AuditDocuments.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 14/11/19.
//  Copyright © 2019 Hemant. All rights reserved.
//



import UIKit
import CoreData
import Photos
import MobileCoreServices
import IQKeyboardManagerSwift

class AuditDocuments: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var collectionVwDocs: UICollectionView!
    @IBOutlet weak var lblAlertMess: UILabel!
    @IBOutlet weak var txtSearchField: UITextField!
    var imagePicker = UIImagePickerController()
    var arrOfShowData = [AuditDocResDataDetails]()
    var arrOfFilterData = [AuditDocResDataDetails]()
    var uploadImage : UIImage? = nil
    var callback: ((Bool,NSManagedObject) -> Void)?
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
//    var auditDetail : AuditListData?
    var auditDetail : AuditOfflineList?
    
    var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title  = LanguageKey.title_documents
        txtSearchField.placeholder = LanguageKey.search
        lblAlertMess.text = LanguageKey.documet_appear
        self.setUpMethod()
       
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        collectionVwDocs.addSubview(refreshControl) // not required when using UITableViewController
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: screenWidth/2 - 7, height: screenWidth/2 - 7)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        collectionVwDocs!.collectionViewLayout = layout
        
        showLoader()
        self.getAuditAttachments()
        
        ActivityLog(module:Modules.audit.rawValue , message: ActivityMessages.auditDocuments)
    }
    
    @objc func refreshControllerMethod() {
        getAuditAttachments()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // self.parent?.title = "Feedback"
        
        self.tabBarController?.navigationItem.title = LanguageKey.title_documents
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = false
            button.tintColor = UIColor.clear
            
        }
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
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
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
                        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
                            self.showPhotoEditor(withImage:(image as! UIImage),andImageName: trimString(string: imgName))
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
    
    func openImageNameAlert(imgName : String, fileUrl:URL){
        
        ////////////// Alert Method //////////////
        let alert = UIAlertController(title:"", message: AlertMessage.changeImageName, preferredStyle: .alert)
        var txtField = UITextField()
        alert.addTextField { (textField) in
            let textField = alert.textFields![0]
            textField.text = imgName
            txtField = textField
        }
        
        
        
        alert.addAction(UIAlertAction(title: LanguageKey.cancel, style: .default, handler: { ( done ) in
        }))
        
        alert.addAction(UIAlertAction(title: LanguageKey.done, style: .cancel, handler: { ( done ) in
            self.uploadMediaDocuments(fileUrl: fileUrl, fileName: txtField.text!)
        }))
        
        windowController.present(alert, animated: true, completion: nil)
        
    }
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
    
    func getAuditAttachments(){

        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                self.lblAlertMess.isHidden = false
                self.collectionVwDocs.isHidden = true
                
            }
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        
        let param = Params()
        param.audId = auditDetail?.audId
        param.usrId = getUserDetails()?.usrId
        param.search = ""
        param.limit = ContentLimit
        param.index = "0"
        
        serverCommunicator(url: Service.getAuditAttachments, param: param.toDictionary) { (response, success) in
            killLoader()
          
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AuditDocRes.self, from: response as! Data) {
                    DispatchQueue.main.async {
                        self.lblAlertMess.isHidden = true
                    }
                    
                    if decodedData.success == true{
                        if (decodedData.data?.count ?? 0) > 0 {
                            
                            self.arrOfShowData.removeAll()
                            
                            
                            for imageRes in decodedData.data! {
//                                if imageRes.attachAuditSign != "" {
//                                    let signData =  AuditDocResDataDetails()
//                                    signData.attachmentId = imageRes.attachmentId
//                                    signData.deleteTable = imageRes.deleteTable
//                                    signData.image_name = imageRes.image_name
//                                    signData.audImg_name = imageRes.audImg_name
//                                    signData.userId = imageRes.userId
//                                    signData.attachFileName = imageRes.attachAuditSign
//                                    signData.attachThumnailFileName = imageRes.attachThumnailAuditSign
//                                    signData.attachFileActualName = imageRes.attachAuditActualSign
//                                    signData.attachAuditSign = imageRes.attachAuditSign
//                                    signData.attachThumnailAuditSign = imageRes.attachThumnailAuditSign
//                                    signData.attachAuditActualSign = imageRes.attachAuditActualSign
//                                    signData.type = imageRes.type
//                                    signData.createdate = imageRes.createdate
//                                    signData.name = imageRes.name
//                                    self.arrOfShowData.append(signData)
//                                }
                                
                                
                              //  if imageRes.attachFileName != "" {
                                    let signData =  AuditDocResDataDetails()
                                    signData.attachmentId = imageRes.attachmentId
                                    signData.deleteTable = imageRes.deleteTable
                                    signData.image_name = imageRes.image_name
                                    signData.audImg_name = imageRes.audImg_name
                                    signData.userId = imageRes.userId
                                    signData.attachFileName = imageRes.attachFileName
                                    signData.attachThumnailFileName = imageRes.attachThumnailFileName
                                    signData.attachFileActualName = imageRes.attachFileActualName
                                    signData.attachAuditSign = imageRes.attachAuditSign
                                    signData.attachThumnailAuditSign = imageRes.attachThumnailAuditSign
                                    signData.attachAuditActualSign = imageRes.attachAuditActualSign
                                    signData.type = imageRes.type
                                    signData.createdate = imageRes.createdate
                                    signData.name = imageRes.name
                                    self.arrOfShowData.append(signData)
                              //  }
                                
                               
                            }
                            
                            
                            
                            DispatchQueue.main.async {
                                    self.collectionVwDocs.isHidden = false
                                    self.collectionVwDocs.reloadData()
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
    // MARK:- up load AuditDocument Service
    //=====================================
    
    func uploadDocuments(imgName : String) -> Void {
        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            }
            return
        }
        
        showLoader()
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.audId = auditDetail?.audId
        // param.type = "2"
        param.device_Type = "2"
        
        
        serverCommunicatorUplaodImage(url: Service.uploadAuditDocument, param: param.toDictionary, image: uploadImage, imagePath: "ja", imageName: imgName) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AuditAddDocumentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            
                            killLoader()
                            
                            if(decodedData.data.count > 0){
                                self.lblAlertMess.isHidden = true
                                self.collectionVwDocs.isHidden = false
                                self.arrOfShowData.insert(decodedData.data[0], at: 0)
                              //  print(self.arrOfShowData)
                                self.collectionVwDocs.reloadData()
                               // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                self.showToast(message: getServerMsgFromLanguageJson(key: decodedData.message!)!)
                                
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
extension AuditDocuments: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfFilterData.count > 0 ? self.arrOfFilterData.count :  self.arrOfShowData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "docCell", for: indexPath as IndexPath) as! DocumentCell
        let docResDataDetailsObj = self.arrOfFilterData.count > 0 ? self.arrOfFilterData[indexPath.row] :  self.arrOfShowData[indexPath.row]
        
        cell.lblName.text = docResDataDetailsObj.attachFileActualName
        
        if let custImg = docResDataDetailsObj.attachThumnailFileName {
            let imageUrl = Service.BaseUrl + custImg
            cell.img.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: docResDataDetailsObj.image_name ?? "unknownDoc"))
        }
//            if let audtImg = docResDataDetailsObj.attachThumnailAuditSign {
//                let imageUrl1 = Service.BaseUrl + audtImg
//                cell.img.sd_setImage(with: URL(string: imageUrl1) , placeholderImage: getImage(fileType: docResDataDetailsObj.audImg_name ?? "unknownDoc"))
//            }
        else{
            cell.img.image = UIImage(named: "unknownDoc")
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let DocResDataDetailsObj = self.arrOfFilterData.count > 0 ? self.arrOfFilterData[indexPath.item] :  self.arrOfShowData[indexPath.item]
        if let url = URL(string: (Service.BaseUrl + DocResDataDetailsObj.attachFileName!)) {
            
            ActivityLog(module:Modules.audit.rawValue , message: ActivityMessages.auditDocumentDetails)
            
            let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "docViewVC") as! DocumentViewVC
            vc.fileUrl = url
            vc.isRename = false
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
            self.navigationController!.pushViewController(vc, animated: true)
            // UIApplication.shared.open(url)
        }else{
            ShowError(message: LanguageKey.format_problem, controller: windowController)
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


extension AuditDocuments: PhotoEditorDelegate, UIDocumentPickerDelegate {
    
    //=============================
    // MARK:- Image editor methods
    //=============================
    
    func showPhotoEditor(withImage:UIImage, andImageName:String) -> Void {
        IQKeyboardManager.shared.enable = true
    
    DispatchQueue.main.async {
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        photoEditor.hiddenControls = [.sticker, .text, .save, .share]
        photoEditor.image = withImage
        photoEditor.imageName = andImageName
        photoEditor.imageNamePlaceholder = LanguageKey.enter_file_name
        
            photoEditor.modalPresentationStyle = .fullScreen
            self.present(photoEditor, animated: true, completion: nil)
        }
    }
    
    
    func doneEditing(image: UIImage, imageName: String) {
        
        //IQKeyboardManager.shared.enable = true
        
        self.uploadImage = image
        DispatchQueue.main.async {
            APP_Delegate.hideBackButtonText()
            self.uploadDocuments(imgName: trimString(string: imageName))
        }
    }
    
    
    func canceledEditing() {
        // IQKeyboardManager.shared.enable = true
        DispatchQueue.main.async {
            APP_Delegate.hideBackButtonText()
        }
        // print("Canceled")
    }
    
    //=============================
    // MARK:- Document picker methods
    //=============================
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        APP_Delegate.hideBackButtonText()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        //  print(url)
        
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
                    APP_Delegate.showBackButtonText()
                    self.showPhotoEditor(withImage: image, andImageName: filename)
                }
            }
            catch {
                // can't load image data
            }
        }else{
            //openImageNameAlert(imgName: String(name), fileUrl: url)
            let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "docViewVC") as! DocumentViewVC
            let navController = UINavigationController(rootViewController: vc)
            vc.fileUrl = url
            vc.isRename = true
            vc.imageName = String(name)
            vc.callback = {(imageName,description) in
                self.uploadMediaDocuments(fileUrl: url, fileName: imageName)
            }
            DispatchQueue.main.async {
                self.navigationController!.present(navController, animated: true, completion: nil)
            }
            
            //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        }
        
    }
    
    func uploadMediaDocuments(fileUrl : URL ,fileName : String) {
        
        //  "audId-> Audit Id
        //  deviceType->Device Type
        //  usrId-> User Id
        // ja->for auidt attachments
        
        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            }
            return
        }
        
        showLoaderOnWindow()
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.audId = auditDetail?.audId
        // param.type = "2"
        param.device_Type = "2"
        
        serverCommunicatorUplaodDocuments(url: Service.uploadAuditDocument, param: param.toDictionary, docUrl: fileUrl, DocPathOnServer: "ja", docName: fileName) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AuditAddDocumentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            
                            killLoader()
                            
                            if(decodedData.data.count > 0){
                                self.lblAlertMess.isHidden = true
                                self.collectionVwDocs.isHidden = false
                                self.arrOfShowData.insert(decodedData.data[0], at: 0)
                                self.collectionVwDocs.reloadData()
                                ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                
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

