//
//  CheckInOutAtchemntVC.swift
//  EyeOnTask
//
//  Created by Ayush Purohit on 15/02/22.
//  Copyright © 2022 Jugal. All rights reserved.
//

import UIKit
import Photos
class CheckInOutAtchemntVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var editImgBtn: UIButton!
    @IBOutlet weak var editImg: UIImageView!
    @IBOutlet weak var H_attchBtn: NSLayoutConstraint!
    @IBOutlet weak var H_btnImg: NSLayoutConstraint!
    @IBOutlet weak var H_attechLbl: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var H_View: NSLayoutConstraint!
    @IBOutlet weak var addAtchmntLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var textFild: UITextView!
    @IBOutlet weak var checkInOut: UIButton!
    @IBOutlet weak var extraBtn: UIBarButtonItem!
    @IBOutlet weak var H_deleteBtn: NSLayoutConstraint!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var H_topLbl: NSLayoutConstraint!
    @IBOutlet weak var btnLblImg: UIImageView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var setTimeBtn: UIButton!
    @IBOutlet weak var checkInOutView: UIView!
    @IBOutlet weak var H_textView: NSLayoutConstraint!
    @IBOutlet weak var checkOutConfm_PopUp: UIView!
    @IBOutlet weak var datePikerView: UIView!
    @IBOutlet weak var datePiker: UIDatePicker!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var showLastCheckInLbl: UILabel!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var showDateLbl: UILabel!
    @IBOutlet weak var showTimeLbl: UILabel!
    
    var permision = false
    var callbackParm: ((String) -> Void)?
    var callbackAtch: ((UIImage,String,String) -> Void)?
    var imagePicker = UIImagePickerController()
    var uploadImage : UIImage? = nil
    var uploadImageNill : UIImage? = nil
    var Dis = ""
    var newCheckTime = ""
    var showCheckPoUp1 = false
    var isAutoCheckoutEnable = true
    var newTimeChang = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                newTimeChang = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.dd_MM_yyyy)
                
            }else{
                newTimeChang = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.dd_MM_yyyy_HH_mm)
                
            }
        }
        
        
        newCheckTime = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.yyyy_MM_dd_HH_mm_ss)
        self.datePikerView.isHidden = true
        self.checkInOutView.isHidden = true
        self.checkOutConfm_PopUp.isHidden = true
        isAutoCheckoutEnable = compPermissionVisible(permission: compPermission.isAutoCheckoutEnable)
        self.setTimeBtn.setTitle("" , for: .normal)
        self.checkInOutView.layer.cornerRadius = 8
        setUpMethod()
        setLocalization()
        var checkInTime1 = getLocalTime()
        self.editImgBtn.isHidden = true
        self.editImg.isHidden = true
        self.deleteBtn.isHidden = true
        self.editImgBtn.isHidden = true
        self.editImg.isHidden = true
        
        if isAutoCheckoutEnable == false {
            let check = getCheckInId()
            if check == "" {
                self.checkInOutView.isHidden = false
                self.checkOutConfm_PopUp.isHidden = true
                self.datePikerView.isHidden = true
                if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == true) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == true) {
                    
                    
                    self.H_View.constant = 254
                    
                    
                }else{
                    
                    if isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false{
                        self.editImgBtn.isHidden = true
                        self.editImg.isHidden = true
                        self.deleteBtn.isHidden = true
                        self.addAtchmntLbl.isHidden = true
                        self.imageView.isHidden = true
                        self.okBtn.isHidden = true
                        self.btnLblImg.isHidden = true
                        self.H_View.constant = 200
                        self.H_textView.constant = 75
                        self.H_attchBtn.constant = 0
                        self.H_btnImg.constant = 0
                        self.H_attechLbl.constant = 0
                        self.H_topLbl.constant = 0
                    }
                    
                    if isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false{
                        self.noteLbl.isHidden = true
                        self.H_View.constant = 150
                        self.H_textView.constant = 0
                        self.H_attchBtn.constant = 40
                    }
                }
                
            }else{
                if showCheckPoUp1 == true {
                    self.setTimeBtn.setTitle("" , for: .normal)
                    self.checkOutConfm_PopUp.isHidden = false
                    let checkInTime = fullgetLocalTime()
                    let lastChekIn = LanguageKey.the_last_checkin
                    let changCheckOut = LanguageKey.do_you_want_to
                    showLastCheckInLbl.text = "\(lastChekIn) \(checkInTime ?? "") \(changCheckOut)"
                    if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == true) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == true) {
                        
                        self.checkOutBtn.setTitle(LanguageKey.cancel, for: .normal)
                        
                    }else{
                        if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false) {
                            self.checkOutBtn.setTitle(LanguageKey.check_out , for: .normal)
                        }else{
                            
                            if isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false{
                                self.checkOutBtn.setTitle(LanguageKey.cancel , for: .normal)
                            }else{
                                if isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false{
                                    self.checkOutBtn.setTitle(LanguageKey.cancel , for: .normal)
                                }else{
                                    self.checkOutBtn.setTitle(LanguageKey.check_out , for: .normal)
                                }
                            }
                            
                        }
                    }
                    
                  
                }else{
                    
                    self.checkInOutView.isHidden = false
                    self.checkOutConfm_PopUp.isHidden = true
                    self.datePikerView.isHidden = true
                    if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == true) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == true) {
                        
                        
                        self.H_View.constant = 254
                        
                        
                    }else{
                        
                        if isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false{
                            self.editImgBtn.isHidden = true
                            self.editImg.isHidden = true
                            self.deleteBtn.isHidden = true
                            self.addAtchmntLbl.isHidden = true
                            self.imageView.isHidden = true
                            self.okBtn.isHidden = true
                            self.btnLblImg.isHidden = true
                            self.H_View.constant = 200
                            self.H_textView.constant = 75
                            self.H_attchBtn.constant = 0
                            self.H_btnImg.constant = 0
                            self.H_attechLbl.constant = 0
                            self.H_topLbl.constant = 0
                        }
                        
                        if isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false{
                            self.noteLbl.isHidden = true
                            self.H_View.constant = 150
                            self.H_textView.constant = 0
                            self.H_attchBtn.constant = 40
                        }
                    }
                    
                }
            }
            
            
        }else{
            self.checkInOutView.isHidden = false
            self.checkOutConfm_PopUp.isHidden = true
            self.datePikerView.isHidden = true
            if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == true) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == true) {
                
                
                self.H_View.constant = 254
                
                
            }else{
                
                if isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false{
                    self.editImgBtn.isHidden = true
                    self.editImg.isHidden = true
                    self.deleteBtn.isHidden = true
                    self.addAtchmntLbl.isHidden = true
                    self.imageView.isHidden = true
                    self.okBtn.isHidden = true
                    self.btnLblImg.isHidden = true
                    self.H_View.constant = 200
                    self.H_textView.constant = 75
                    self.H_attchBtn.constant = 0
                    self.H_btnImg.constant = 0
                    self.H_attechLbl.constant = 0
                    self.H_topLbl.constant = 0
                }
                
                if isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false{
                    self.noteLbl.isHidden = true
                    self.H_View.constant = 150
                    self.H_textView.constant = 0
                    self.H_attchBtn.constant = 40
                }
            }
            
        }
        
        
        // Do any additional setup after loading the view.
        
        if let id = getCheckInId() {
            if id != "" {
                self.checkInOut.setTitle(LanguageKey.check_out , for: .normal)
            }else{
                self.checkInOut.setTitle(LanguageKey.check_in , for: .normal)
            }
        }
    }
    
    func setUpMethod(){
        
        // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
                 var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
                 duration = updateDefaultTime(duration ?? "01:00")
        let arrOFDurationTime = duration?.components(separatedBy: ":")
        
        // let currentTime : String? = getDefaultSettings()?.
        // old
        let currentTime : String? = updateDefaultTime(getDefaultSettings()?.jobCurrentTime ?? "01:00")
        if(currentTime != "" && currentTime != nil){
            let arrOFCurntTime = currentTime?.components(separatedBy: ":")
            let strDate = getSchuStartAndEndDateForAgoTime(Hrs:Int(arrOFCurntTime![0])!, min: Int(arrOFCurntTime![1])!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
            
            let arr = strDate.0.components(separatedBy: " ")
            
            if arr.count == 2 {
                showDateLbl.text = arr[0]
                showTimeLbl.text = arr[1]
               
            }else{
                showDateLbl.text = arr[0]
                showTimeLbl.text = arr[1] + " " + arr[2]
                
            }
            
            
        }else{
            let adminSchTime : String? = getDefaultSettings()?.jobSchedule
            if(adminSchTime != "" && adminSchTime != nil){
                // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
                         var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
                         duration = updateDefaultTime(duration ?? "01:00")
                let arrOFDurationTime = duration?.components(separatedBy: ":")
                
                let strDate = getSchStartandEndDateAndTimeForSchDate(timeInterval: (getDefaultSettings()?.jobSchedule)!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
                
                
                let arr = strDate.0.components(separatedBy: " ")
                if arr.count == 2 {
                    showDateLbl.text = arr[0]
                    showTimeLbl.text = arr[1]
                   
                }else{
                    showDateLbl.text = arr[0]
                    showTimeLbl.text = arr[1] + " " + arr[2]
                   
                }
                
            }
        }
    }
    
    func showDateAndTimePicker(){
        // self.dateAndTimePicker.minimumDate = Date()
        self.datePikerView.isHidden = false
        UIView.animate(withDuration: 0.2)  {
            let frame = CGRect(x: 0, y: self.view.frame.size.height - 240, width: self.view.frame.size.width, height: 240)
            self.datePikerView.frame = frame
            
        }
    }
    
    func setLocalization() -> Void {
        
        self.addAtchmntLbl.text = LanguageKey.add_attachment
        self.noteLbl.text = LanguageKey.notes
    }
    
    @IBAction func setCheckOutTimeBtn(_ sender: Any) {
        
        
        if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == true) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == true) {
         
            
            self.checkInOutView.isHidden = false
            self.checkOutConfm_PopUp.isHidden = true
            self.datePikerView.isHidden = true
            if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == true) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == true) {
                
                    
                    self.H_View.constant = 254
                    
                    
            }else{
                
                if isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false{
                    self.editImgBtn.isHidden = true
                    self.editImg.isHidden = true
                    self.deleteBtn.isHidden = true
                    self.addAtchmntLbl.isHidden = true
                    self.imageView.isHidden = true
                    self.okBtn.isHidden = true
                    self.btnLblImg.isHidden = true
                    self.H_View.constant = 200
                    self.H_textView.constant = 75
                    self.H_attchBtn.constant = 0
                    self.H_btnImg.constant = 0
                    self.H_attechLbl.constant = 0
                    self.H_topLbl.constant = 0
                }

                if isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false{
                    self.noteLbl.isHidden = true
                    self.H_View.constant = 150
                    self.H_textView.constant = 0
                    self.H_attchBtn.constant = 40
                }
            }
        

        }else{
            if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false) {
                self.setTimeBtn.setTitle(LanguageKey.check_out , for: .normal)
                let yourImage: UIImage = UIImage(named: "default-thumbnail")!
                if callbackAtch != nil {
                    if uploadImage != nil {
                        callbackAtch!(uploadImage!,Dis,newCheckTime)

                    }else{

                        callbackAtch!(yourImage,Dis,newCheckTime)
                    }
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                
                
                   if isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false{
                       self.permision = true
             
                   }

                   if isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false{
                       self.permision = true
                   
                   }
                   
                   if self.permision == true{
                       self.checkInOutView.isHidden = false
                       self.checkOutConfm_PopUp.isHidden = true
                       self.datePikerView.isHidden = true
                       if isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false{
                           self.editImgBtn.isHidden = true
                           self.editImg.isHidden = true
                           self.deleteBtn.isHidden = true
                           self.addAtchmntLbl.isHidden = true
                           self.imageView.isHidden = true
                           self.okBtn.isHidden = true
                           self.btnLblImg.isHidden = true
                           self.H_View.constant = 200
                           self.H_textView.constant = 75
                           self.H_attchBtn.constant = 0
                           self.H_btnImg.constant = 0
                           self.H_attechLbl.constant = 0
                           self.H_topLbl.constant = 0
                       }

                       if isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false{
                           self.noteLbl.isHidden = true
                           self.H_View.constant = 150
                           self.H_textView.constant = 0
                           self.H_attchBtn.constant = 40
                       }
                   }else{
                       self.setTimeBtn.setTitle(LanguageKey.check_out , for: .normal)
                       let yourImage: UIImage = UIImage(named: "default-thumbnail")!
                       if callbackAtch != nil {
                           if uploadImage != nil {
                               callbackAtch!(uploadImage!,Dis,newCheckTime)

                           }else{

                               callbackAtch!(yourImage,Dis,newCheckTime)
                           }
                       }else{
                           self.navigationController?.popViewController(animated: true)
                       }
                   }
                   
            }
         
        }
      
        
    }
    
    @IBAction func deleteBtnAct(_ sender: Any) {
        self.editImgBtn.isHidden = true
        self.editImg.isHidden = true
        self.deleteBtn.isHidden = true
        self.okBtn.isHidden = false
        self.btnLblImg.isHidden = false
        if isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false{
            self.H_View.constant = 200
        }else{
            
             if isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false{
                 self.H_View.constant = 150
            }else{
                self.H_View.constant = 254
            }
           
        }
        
        
        uploadImage = nil
       
        self.imageView.image = nil
    }
    
    
    @IBAction func removeCheckInOutVw(_ sender: Any) {
        var activityIndcaterStop = "True"
        UserDefaults.standard.set(activityIndcaterStop, forKey: "activityIndcaterStop")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkInOutAtchAct(_ sender: Any) {
        var activityIndcaterStop = "False"
        UserDefaults.standard.set(activityIndcaterStop, forKey: "activityIndcaterStop")
        self.Dis = textFild.text
        let yourImage: UIImage = UIImage(named: "default-thumbnail")!
        if callbackAtch != nil {
            if uploadImage != nil {
                callbackAtch!(uploadImage!,Dis,newCheckTime)
                
            }else{
                
                callbackAtch!(yourImage,Dis,newCheckTime)
            }
        }else{
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func editImgActn(_ sender: Any) {
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                
                ShowError(message: LanguageKey.err_check_network, controller: windowController)
                
            }
            return
        }
        
        openGallary()
    }
    
    @IBAction func upLoadImageBtn(_ sender: Any) {
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                
                ShowError(message: LanguageKey.err_check_network, controller: windowController)
                
            }
            return
        }
        
        openGallary()
    }
    
    @IBAction func changCheckOutTimeBtn(_ sender: Any) {
       
        self.datePikerView.isHidden = false
        self.showDateAndTimePicker()
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.datePikerView.isHidden = true
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        
        if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == true) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == true) {
            self.checkOutBtn.setTitle(LanguageKey.done , for: .normal)
        }else{
            if (isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false) && (isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false) {
                self.checkOutBtn.setTitle(LanguageKey.check_out , for: .normal)
            }else{
                if isPermitForShow(permission: permissions.isCheckInOutAttAdd) == false{
                    self.checkOutBtn.setTitle(LanguageKey.done , for: .normal)
                }else{
                    if isPermitForShow(permission: permissions.isCheckInOutDescAdd) == false{
                        self.checkOutBtn.setTitle(LanguageKey.done , for: .normal)
                    }else{
                        self.checkOutBtn.setTitle(LanguageKey.check_out , for: .normal)
                    }
                }
            }
        }
        
       
        let date = self.datePiker.date
        let formatter = DateFormatter()
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                formatter.dateFormat = "dd-MM-yyyy h:mm a"
            }else{
                formatter.dateFormat = "dd-MM-yyyy HH:mm"
            }
        }
        
        
        formatter.timeZone = TimeZone.current
        
        if let langCode = getCurrentSelectedLanguageCode() {
            formatter.locale = Locale(identifier: langCode)
        }
        
        let strDate = formatter.string(from: date)
        
        let arr = strDate.components(separatedBy: " ")
        
        if arr.count == 2 {
            var getTime = arr[0] + " " + arr[1]
            var CheckInTm = fullgetLocalTime()
            
            
            if getTime >= CheckInTm ?? "" {
                
                if getTime <= newTimeChang {
                    self.datePikerView.isHidden = true
                    showDateLbl.text = arr[0]
                    showTimeLbl.text = arr[1]
                    newCheckTime = arr[1]
                }else{
                    ShowError(message: LanguageKey.checkout_time_greater_current_time , controller: windowController)
                }
            }else{
                ShowError(message: LanguageKey.checkout_time_less_checkin_time, controller: windowController)
            }
            
        }else{
            var getTime = arr[0] + " " + arr[1] + " " + arr[2]
            var CheckInTm = fullgetLocalTime()
          
          
            
            if getTime >= CheckInTm ?? "" {
                
                if getTime <= newTimeChang {
                    self.datePikerView.isHidden = true
                    showDateLbl.text = arr[0]
                    showTimeLbl.text = arr[1] + " " + arr[2]
                    newCheckTime = arr[0] + " " + arr[1] + " " + arr[2]
                }else{
                    ShowError(message: LanguageKey.checkout_time_greater_current_time , controller: windowController)
                }
            }else{
                ShowError(message: LanguageKey.checkout_time_less_checkin_time, controller: windowController)
            }
            
        }
        
    }
    // FOR SAVE DEFAULT IMAGE :-
    
    func saveImageInUserDefault(img:UIImage, key:String) {
        UserDefaults.standard.set(img.pngData(), forKey: key)
    }
    
    
    //==============================================================//
    // Open Gallary Method
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
        
        
        actionSheetControllerIOS8.addAction(gallery)
        actionSheetControllerIOS8.addAction(camera)
        
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
                        
                        if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
                            let imgStruct = ImageModel_LinkEquipmentReport(img: (info[.originalImage] as? UIImage)?.resizeImage_LinkEquipmentReport(targetSize: CGSize(width: 1000.0, height: 10000.0)))
                            DispatchQueue.main.async {
                                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                                
                                vc.image = (imgStruct.img!)
                                vc.name = trimString(string: imgName)
                                vc.OnlyForCrop = false
                                vc.OnlyForHideAllTxtView = true
                                vc.hideAfternBeforeBtn = true
                                vc.OnlycheckMarkCompl = true
                                vc.callback = {(modifiedImage, imageName, imageDescription) in
                                    self.uploadImage = modifiedImage
                                    self.imageView.image =   self.uploadImage
                                    self.H_View.constant = 436
                                    self.editImgBtn.isHidden = false
                                    self.editImg.isHidden = false
                                   
                                    self.deleteBtn.isHidden = false
                                    self.okBtn.isHidden = true
                                    self.btnLblImg.isHidden = true
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
    
    
    
}
