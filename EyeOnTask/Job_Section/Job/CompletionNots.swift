//
//  CompletionNots.swift
//  EyeOnTask
//
//  Created by Mojave on 04/02/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import Photos

class CompletionNots: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,OptionViewDelegate {
    
    @IBOutlet weak var fetchComplationBtn: UIButton!
    @IBOutlet weak var fetchDesLbl: UILabel!
    @IBOutlet weak var isTimeLbl: UILabel!
    @IBOutlet weak var cancleLbl: UILabel!
    @IBOutlet weak var doneLbl: UILabel!
    @IBOutlet weak var suggestionTxtField: UITextField!
    @IBOutlet weak var btnCompltionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAttechLbl: UILabel!
    @IBOutlet weak var completionNots_txtVw: UITextView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var viewSmall: UIView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var okLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    var doNotDublPrint = false
    var jobModel = UserJobList()
    var callback: ((String) -> Void)?
    var sltDropDownTag : Int!
    var optionalVw : OptionalView?
    let cellReuseIdentifier = "cell"
    var arrOfServicSuggestion = [UserJobTittleNm]()
    var arrOfsuggetionItem = [suggestionListData]()
    var userJobTittleNmRef : UserJobTittleNm?
    var arrOfSuggest = [suggestionListData]()
    var arrayOfSuggetion = [Any]()
    var ArrOfDic = [String:String]()
    var imagePicker = UIImagePickerController()
    var uploadImage : UIImage? = nil
    var refreshControl = UIRefreshControl()
    var arrOfShowData = [DocResDataDetails]()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var imgName = ""
    var imgAtch = ""
    var imgArr = [ImageModel1]()
    var selectedRows:[Int] = []
    var isCompletionBack = false
    // var jobDetail = UserJobList()
    var count : Int = 0
    var isUserfirstLogin = Bool() 
    override func viewDidLoad() {
        super.viewDidLoad()
        getJobTittle()
        setLocalization()
        self.okLbl.text = LanguageKey.ok
        self.okBtn.setTitle("", for: .normal)
        self.backGroundView.isHidden = true
        self.viewSmall.isHidden = true
        self.lblMsg.isHidden = true
        self.okLbl.isHidden = true
        self.okBtn.isHidden = true
        
        
        if self.arrOfShowData.count == 0 {
            collectionView.isHidden = true
        }else{
            btnCompltionView.isHidden = true
        }
        
        self.title = LanguageKey.completion_note
        self.getDocumentsList()
        completionNots_txtVw.becomeFirstResponder()
        if  jobModel.complNote != nil && jobModel.complNote != "" {
            completionNots_txtVw.text =  jobModel.complNote
            let saveBtn = UIBarButtonItem(title:  LanguageKey.update, style: .plain, target: self, action:  #selector(ActionButtonMethod))
            navigationItem.rightBarButtonItem = saveBtn
        }else{
            let saveBtn = UIBarButtonItem(title:  LanguageKey.save_btn, style: .plain, target: self, action:  #selector(ActionButtonMethod))
            navigationItem.rightBarButtonItem = saveBtn
           // completionNots_txtVw.text = ""
        }
        
        let backButton = UIBarButtonItem(title: LanguageKey.cancel, style: .plain, target: self, action:  #selector(backButtonMethod))
        navigationItem.leftBarButtonItem = backButton
        
        let cellSize = CGSize(width:160 , height:105)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 1.0
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
        
    }
    
    func setLocalization() -> Void {
        
        doneLbl.text = LanguageKey.done
        cancleLbl.text = LanguageKey.cancel
        isTimeLbl.text = LanguageKey.time_stemp
        fetchDesLbl.text = LanguageKey.fetch_des
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getJobListService()
        UserDefaults.standard.set(completionNots_txtVw.text, forKey: "txtCompletionNotes")
      if isCompletionBack == true {
            if jobModel.complNote != nil
            {
                
                if self.doNotDublPrint == false {
                   // print(self.jobModel.complNote!)
                   // print(self.completionNots_txtVw.text)
                    completionNots_txtVw.text = " \(self.jobModel.complNote!)"
                }else{
                    //completionNots_txtVw.text = ""
                    //completionNots_txtVw.text = " \(self.jobModel.complNote!)"
                }
              
                
                      UserDefaults.standard.set(nil, forKey: "txtCompletionNotes")
            }else{
                completionNots_txtVw.text = UserDefaults.standard.value(forKey: "txtCompletionNotes") as? String
           
            }
        }
       
        self.getDocumentsList()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // APP_Delegate.hideBackButtonText()
    }
    
    // For leftBarButtonItem :-
    
    @objc func backButtonMethod() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func ActionButtonMethod() -> Void {
        setCompletionNotes()
    }
    
    //=============================
    // MARK:- setCompletionNotes
    //=============================
    
    func setCompletionNotes(){
        
        completionNots_txtVw.resignFirstResponder()
        if !isHaveNetowork() {
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        showLoader()
        
        let param = Params()
        param.jobId = jobModel.jobId
        param.usrId = getUserDetails()!.usrId
        param.complNote = trimString(string: completionNots_txtVw.text)
        
        UserDefaults.standard.set(completionNots_txtVw.text, forKey: "txtCompletionNotes")
        serverCommunicator(url: Service.setCompletionNotes, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(CommonResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        DispatchQueue.main.async {
                            if self.callback != nil {
                                self.callback!(trimString(string: self.completionNots_txtVw.text))
                            }
                            
                            self.jobModel.complNote = trimString(string: self.completionNots_txtVw.text)
                            DatabaseClass.shared.saveEntity(callback: { _ in })
                            killLoader()
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }else{
                        if let msg = decodedData.message {
                            ShowError(message: getServerMsgFromLanguageJson(key: msg)!, controller: windowController)
                        }
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        if cancel {
                            showLoader()
                            
                        }
                    })
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
    
    
    @IBAction func btnAttachment(_ sender: Any) {
        self.doNotDublPrint = true
        openGallery()
        
    }
    
    @IBAction func okActnBtn(_ sender: Any) {
        
        self.backGroundView.isHidden = true
        self.viewSmall.isHidden = true
        self.lblMsg.isHidden = true
        self.okLbl.isHidden = true
        self.okBtn.isHidden = true
    }
    
    @IBAction func isTimeBtn(_ sender: Any) {
        
        let formatter = DateFormatter()
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{
            if enableCustomForm == "0"{
                formatter.dateFormat = "dd-MM-yyyy h:mm a"
            }else{
                formatter.dateFormat = "dd-MM-yyyy HH:mm"
            }
        }
        
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US")
        let CurntDateTime = formatter.string(from: Date())
        self.completionNots_txtVw.text += " \(CurntDateTime)"
    }
    
    
    @IBAction func doneBtnEmogi(_ sender: Any) {
     
        self.completionNots_txtVw.text += "✅"
        
    }
    
    @IBAction func fatchDesBtnEmogi(_ sender: Any) {
       
     
        var html = self.jobModel.desWithoutHtml //Convert html formate
        let attributes = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single]
        var atributs = NSAttributedString(string: html!, attributes: attributes)
        
        var velue = atributs.string
        DispatchQueue.main.async {
            let mailString = velue.replacingOccurrences(of: "<br>", with: "")
            self.completionNots_txtVw.text += " \(mailString)"
        }
       
        
//
//
//
//       // let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
//         let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
//         let partOne = NSMutableAttributedString(string: "This is an example ", attributes: normalFontAttributes)
//
//
//         let combination = NSMutableAttributedString()
//
//         combination.append(partOne)
//         combination.append(partTwo)
//        completionNots_txtVw.attributedText = combination
        
        
        
//            }
//        }
        //
//        DispatchQueue.global(qos: .background).async {
//            let htmlString = self.jobModel.desWithoutHtml //Convert html formate
//
//
//            DispatchQueue.main.async {
//                let mailString = self.jobModel.desWithoutHtml!.replacingOccurrences(of: "<br>", with: "")
//                self.completionNots_txtVw.text += mailString
//            }
//        }
   
    }
    
    @IBAction func cancelBtnEmogi(_ sender: Any) {
   
        self.completionNots_txtVw.text += "❌"
     
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
        
        actionSheetControllerIOS8.addAction(gallery)
        actionSheetControllerIOS8.addAction(camera)
        // actionSheetControllerIOS8.addAction(document)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    
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
                    // for index in 0..<imageAsset.count{
                    
                    if imageAsset.count > 0{
                        let asset = imageAsset.firstObject
                        let imgFullName = asset?.value(forKey: "filename") as! String
                        let arr = imgFullName.components(separatedBy: ".")
                        let imgExtension = arr.last
                        let imgName = imgFullName.replacingOccurrences(of: ".\(imgExtension!)", with: "")
                        
                        // if let image = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
                        if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
                            let imgStruct = ImageModel1(img: (info[.originalImage] as? UIImage)?.resizeImage1(targetSize: CGSize(width: 1000.0, height: 1000.0)))
                            DispatchQueue.main.async {
                                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                                vc.image = (imgStruct.img!)
                                // self.imgArr.append(imgStruct)
                                //   vc.image = imgStruct as! UIImage// self.imgArr as! [ImageModel1]//as? UIImage
                                vc.name = trimString(string: imgName)
                                vc.callbackForComplictionNotes = {(modifiedImage, imageName, imageDescription, isSave,isCompletionBack) in
                                    self.uploadImage = modifiedImage
                                    self.isCompletionBack = isCompletionBack
                                    self.uploadDocuments(imgName: imageName, imageDes: imageDescription, isSaveNotes:isSave) { () -> (Void) in
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
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
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
                // self.lblAlertMess.isHidden = false
                self.collectionView.isHidden = true
                killLoader()
            }
            return
        }
        
        // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getDocumentsList) as? String
        // showLoader()
        let param = Params()
        param.jobId = jobModel.jobId
        param.usrId = getUserDetails()?.usrId
        param.type = "6"
        
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
                        // self.lblAlertMess.isHidden = true
                    }
                    
                    if decodedData.success == true{
                        
                        if (decodedData.data?.count ?? 0) > 0 {
                            
                            // self.arrOfShowData.removeAll()
                            
                            DispatchQueue.main.async {
                                self.collectionView.isHidden = false
                                self.arrOfShowData = decodedData.data!
                                self.collectionView.reloadData()
                                if  self.jobModel.complNote == nil && self.jobModel.complNote == "" {
                                    self.completionNots_txtVw.text =  self.arrOfShowData[0].des
                                }else if self.jobModel.complNote != nil {
                                    if self.doNotDublPrint == true {
                                       // self.completionNots_txtVw.text = ""
                                       // self.completionNots_txtVw.text +=  " \(self.jobModel.complNote!)"
                                      
                                    }
                                
                                }else if self.isCompletionBack == true {
                                    if self.jobModel.complNote != nil {
                                        UserDefaults.standard.set(nil, forKey: "txtCompletionNotes")
                                        self.completionNots_txtVw.text =  self.jobModel.complNote
                                    }else{
                                        self.completionNots_txtVw.text = UserDefaults.standard.value(forKey: "txtCompletionNotes") as? String
                                    }
                                    
                                    
                                }else{
                                    self.completionNots_txtVw.text =  self.jobModel.complNote
                                }
                                // self.completionNots_txtVw.text =  self.arrOfShowData[0].des
                                
                                self.collectionView.reloadData()
                                
                                
                            }
                            
                        }else{
                            
                            DispatchQueue.main.async {
                                // self.lblAlertMess.isHidden = false
                                self.collectionView.isHidden = true
                                
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
    
    //============================================
    // MARK:- JobController/deleteDocument Service
    //============================================
    
    
    func deleteDocument() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            killLoader()
            return
        }
        
        showLoader()
        let param = Params()
        param.jaId = imgAtch
        
        serverCommunicator(url: Service.deleteDocument, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
               
                DispatchQueue.main.async {
                    
                    self.collectionView.reloadData()
                    self.showToast(message: "Delete Attechment")
                    self.getDocumentsList()
                   
                }
              
            }
            
        }
        
    }
    
    
    //=====================================
    // MARK:- Upload Document Service
    //=====================================
    
    func uploadDocuments(imgName : String, imageDes : String, isSaveNotes : Int ,completion : @escaping (()->(Void))) -> Void {
        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            }
            return
        }
        
        showLoader()
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.jobId = jobModel.jobId
        param.type = "2"
        param.device_Type = "2"
        param.des = imageDes
        param.docNm = imgName
        param.isAddAttachAsCompletionNote = isSaveNotes
        
        serverCommunicatorUplaodImage(url: Service.uploadDocument, param: param.toDictionary, image: uploadImage, imagePath: "ja", imageName: imgName) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                
                completion()
                
                if let decodedData = try? decoder.decode(AddDocumentRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            
                            killLoader()
                            
                            if(decodedData.data!.count > 0){
                                //                                   self.lblAlertMess.isHidden = true
                                //                                   self.collectionVwDocs.isHidden = false
                                //                                   self.arrOfShowData.insert(decodedData.data![0], at: 0)
                                //                                   self.collectionVwDocs.reloadData()
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
    }
    
    //=====================================
    // MARK:- Update Document Description
    //=====================================
    
    func updateDocumentDescription(documentid : String, documentDescription : String,  isAddAttachAsCompletionNote : Int , completion : @escaping (()->(Void))) {
        /*
         jobId -> Job  id
         */
        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                // self.lblAlertMess.isHidden = false
                self.collectionView.isHidden = true
                
            }
            return
        }
        
        // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getDocumentsList) as? String
        showLoader()
        let param = Params()
        param.jaId = documentid
        param.des = documentDescription
        param.isAddAttachAsCompletionNote = isAddAttachAsCompletionNote
        
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
                        self.getJobListService()
                        //self.lblAlertMess.isHidden = true
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
    
    
    @IBAction func BtnAddSuggestion(_ sender: UIButton) {
        setData()
        if arrOfSuggest.count > 0 {
            if(self.optionalVw == nil){
                
                self.openDwopDown( Buttion: fetchComplationBtn , arr: arrOfSuggest)
            }else{
                self.removeOptionalView()
            }
        }else{
            
            self.backGroundView.isHidden = false
            self.viewSmall.isHidden = false
            self.lblMsg.isHidden = false
            self.okLbl.isHidden = false
            self.okBtn.isHidden = false
           // ShowError(message: AlertMessage.no_suggesstion, controller: windowController)
        }
        
        
    }
    
        func openDwopDown(Buttion : UIButton , arr : [Any]) {
              
               if (optionalVw == nil){
                   self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
                   let sltTxtfldFrm = Buttion.convert(Buttion.bounds, from: self.view)
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
            //self.optionalVw?.table_View?.reloadData()
           }
        
        //==============================================
        // MARK:- optional view delegete
        //==============================================
        
        func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 50.0
        }
        
        func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return arrOfSuggest.count

        }
        
        
        func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            if(cell == nil){
                cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
            }
            
            cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
            cell?.backgroundColor = .clear
            
            cell?.textLabel?.textColor = UIColor.darkGray
            cell?.textLabel?.text =  arrOfSuggest[indexPath.row].complNoteSugg?.capitalizingFirstLetter()

            return cell!
        }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.completionNots_txtVw.text += "\(arrOfSuggest[indexPath.row].complNoteSugg ?? "")"
        
        self.removeOptionalView()
    }
    
    func removeOptionalView(){
        if optionalVw != nil {
            self.optionalVw?.removeFromSuperview()
            self.optionalVw = nil
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
                self.openDwopDown( Buttion: fetchComplationBtn, arr: arrOfShowData)
            }else{
                self.removeOptionalView()
            }
            
            
            break
            
        default:
            return
        }
        //self.optionalVw?.table_View?.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.sltDropDownTag = textField.tag
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        
        switch self.sltDropDownTag {
        case 0:
            
            if(self.optionalVw == nil){
                self.openDwopDown( Buttion: self.fetchComplationBtn, arr: arrOfSuggest)
            }
            DispatchQueue.main.async{
                if(self.arrOfSuggest.count > 0){
                    self.optionalVw?.isHidden = false
                    self.optionalVw?.table_View?.reloadData()
                }else{
                    self.optionalVw?.isHidden = true
                }
            }
            
            
            break
            
            
        default: break
            
        }
        
        
        return true
    }
    
    //=============================
    // MARK:- setCompletionNotes
    //=============================
    
    
    func setData(){

        for jtId in (jobModel.jtId as! [AnyObject]) {
            let getId = (jtId as! [String:String])["jtId"] ?? ""
            print(getId)
            let query = "jtId = '\(getId)'"
             let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: query) as! [UserJobTittleNm]
        
       // let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobTittleNm", query: nil) as! [UserJobTittleNm]
        for value in isExist {
        
            for des in (value.suggestionList as! [AnyObject]) {
                let dic  = (des as! [String:String])["complNoteSugg"] ?? ""
              
                if dic != "" {
                
                    let jtId  = (des as! [String:String])["jtId"] ?? ""
                    let complNoteSugg  = (des as! [String:String])["complNoteSugg"] ?? ""
                    let compId  = (des as! [String:String])["compId"] ?? ""
                    let updateDate  = (des as! [String:String])["updateDate"] ?? ""
                    let createdDate  = (des as! [String:String])["createdDate"] ?? ""
                    let suggId  = (des as! [String:String])["suggId"] ?? ""
                    let jtDesSugg  = (des as! [String:String])["jtDesSugg"] ?? ""
                    
                    arrOfSuggest.append(suggestionListData(suggId: suggId, compId: compId, jtId: jtId, jtDesSugg: jtDesSugg, complNoteSugg: complNoteSugg, createdDate: createdDate, updateDate: updateDate))
                }
                
                
             }
            
            
            
            }
           
        }
               
        var seen = Set<String>()
        var newData = [suggestionListData]()
        for message in arrOfSuggest {
            if !seen.contains(message.jtId!) {
                newData.append(message)
                seen.insert(message.jtId!)
            }
        }

           arrOfSuggest = newData
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
        param.dateTime =  ""
        
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
                //DatabaseClass.shared.saveEntity()
            }else{
                let userJobs = DatabaseClass.shared.createEntity(entityName: "UserJobTittleNm")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
                // DatabaseClass.shared.saveEntity()
            }
        }
        
        DatabaseClass.shared.saveEntity(callback: {_ in})
    }
}



extension CompletionNots: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return   self.arrOfShowData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CompletionNotesCell
        
        if self.arrOfShowData.count == indexPath.row {
            //   cell.imgView.image = #imageLiteral(resourceName: "push8@")
            cell.imgView.image = UIImage(named: "Group 453")
            // cell.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
            cell.imgLabel.text = ""
             cell.deleteBtn.isHidden = true
            
        }else {
            let docResDataDetailsObj = self.arrOfShowData[indexPath.row]
            
            cell.deleteBtn.addTarget(self, action: #selector(buttonTapped( sender: )), for: .touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.isHidden = false
        
            cell.imgLabel.text = docResDataDetailsObj.attachFileActualName
            imgName = cell.imgLabel.text ?? ""
            if let img = docResDataDetailsObj.attachThumnailFileName {
                let imageUrl = Service.BaseUrl + img
                cell.imgView.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: docResDataDetailsObj.image_name ?? "unknownDoc"))
            }else{
                // cell.deleteBtn.setTitle("", for: .normal)
                cell.imgView.image = UIImage(named: "unknownDoc")
            }
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.arrOfShowData.count == indexPath.row {
            doNotDublPrint = true
            openGallery()
        }else {
            
            let DocResDataDetailsObj =  self.arrOfShowData[indexPath.item]
            
            
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
                customView?.thenewlyAddedLblCompCheck = "true"
                customView!.setupMethod(url: fileUrl, image: nil, imageName: DocResDataDetailsObj.attachFileActualName ?? "", imageDescription: DocResDataDetailsObj.des ?? "")
                
                customView?.completionHandler = {(editedName,editedDes) in
                    
                    if DocResDataDetailsObj.des != editedDes {
                        if DocResDataDetailsObj.type == "6"
                        {
                            self.updateDocumentDescription(documentid: DocResDataDetailsObj.attachmentId!, documentDescription: editedDes,isAddAttachAsCompletionNote:1) {
                                DocResDataDetailsObj.des = editedDes
                                DispatchQueue.main.async {
                                    customView?.removeFromSuperview()
                                    backgroundView.removeFromSuperview()
                                }
                                
                            }
                            
                        }else {
                            self.updateDocumentDescription(documentid: DocResDataDetailsObj.attachmentId!, documentDescription: editedDes,isAddAttachAsCompletionNote:0) {
                                DocResDataDetailsObj.des = editedDes
                                DispatchQueue.main.async {
                                    customView?.removeFromSuperview()
                                    backgroundView.removeFromSuperview()
                                }
                                
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
    
    @objc func buttonTapped(sender: UIButton) {
        
        self.selectedRows.append(sender.tag)
        var tag = sender.tag
        self.selectedRows = self.selectedRows.sorted(by: >)
        self.imgAtch = self.arrOfShowData[tag].attachmentId!
        self.deleteDocument()
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
                                    DispatchQueue.main.async {
                                        
                                        if self.doNotDublPrint == true {
                                          
                                            var setCompSuggesion =  UserDefaults.standard.value(forKey: "forCompSuggesion") as? String
                                            
                                            
                                            self.completionNots_txtVw.text += setCompSuggesion ?? ""
                                           // self.completionNots_txtVw.text += " \(self.jobModel.complNote ?? "")"
                                        }
                                       
                                    }
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
                        //DatabaseClass.shared.saveEntity()
                        
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
}

struct ImageModel1 {
    var img: UIImage?
    
}

extension UIImage {
    func resizeImage1(targetSize: CGSize) -> UIImage {
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
