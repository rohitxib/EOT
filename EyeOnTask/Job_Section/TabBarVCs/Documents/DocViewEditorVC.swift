//
//  DocViewEditorVC.swift
//  EyeOnTask
//
//  Created by Hemant's mac on 15/04/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import WebKit

class DocViewEditorVC: UIViewController, PhotoEditorDelegate {

    var image : UIImage?
    private var editedimage : UIImage?
    var name : String?
    var docUrl : URL?
    var buttondd : Bool = false
    var isSignature = false
    var buttonSwitched : Bool = false
    var OnlyForCrop = false
    var OnlyForShowAllTxtView = false
    var OnlyForHideAllTxtView = false
    var hideAfternBeforeBtn = false
    var OnlycheckMarkCompl = false
    var beforeAfterString = ""
    var isSaveComplationNotes  = ""
    var isSaveNotes = 0
    var isCompletionBack = true
    
    @IBOutlet weak var removeAfterBtn: UIButton!
    @IBOutlet weak var afterCancekImg: UIButton!
    @IBOutlet weak var beforeCancelmg: UIButton!
    
    @IBOutlet weak var afterView: UIView!
    @IBOutlet weak var beforeView: UIView!
    @IBOutlet weak var RemoveTgBtn: UIButton!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var afterBtn: UIButton!
    @IBOutlet weak var afterRadioImg: UIButton!
    @IBOutlet weak var afterLbl: UILabel!
    @IBOutlet weak var beforeBtn: UIButton!
    @IBOutlet weak var beforeRadioImg: UIButton!
    @IBOutlet weak var beforeLbl: UILabel!
    @IBOutlet weak var beforeAfterView: UIView!
    @IBOutlet weak var checkMarkSaveCompNotes: UIView!
    @IBOutlet weak var saveCompNotsLbl: UILabel!
    @IBOutlet weak var claim_rembrImg: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var lblDocDes: UILabel!
    @IBOutlet weak var lblDocname: UILabel!
    @IBOutlet weak var btnCustomise: UIButton!
    @IBOutlet weak var backgroundWhitVw: UIView!
    @IBOutlet weak var equalWidth: NSLayoutConstraint!
    @IBOutlet weak var custmiseButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var trailingUploadbutton: NSLayoutConstraint!
    @IBOutlet weak var textView_Height: NSLayoutConstraint!
    @IBOutlet weak var theNewlyaddCompLbl: UILabel!
    @IBOutlet weak var H_NewelyCompLbl: NSLayoutConstraint!
    @IBOutlet weak var H_titleLbl: NSLayoutConstraint!
    @IBOutlet weak var H_txtTittleVw: NSLayoutConstraint!
    
    var callback: ((UIImage,String,String) -> Void)?
    var callbackForComplictionNotes: ((UIImage,String,String,Int,Bool)-> Void)?
    var callbackForDocument: ((String,String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackBarButtonCustom()
        if OnlyForHideAllTxtView == true {
            self.backgroundWhitVw.isHidden = false
            self.OnlyForShowAllTxtView = true
            showLoader()
            self.navigationItem.title = ""
            self.showPhotoEditor(withImage:image! ,andImageName: trimString(string: name ?? ""))
        }else{
            self.navigationItem.title = LanguageKey.attachment
            self.backgroundWhitVw.isHidden = true
        }

        beforeCancelmg.isHidden = true
        afterCancekImg.isHidden = true
        let on = "Hide"
        UserDefaults.standard.set(on, forKey: "RemoveTagBtn")
        RemoveTgBtn.isHidden = true
        removeAfterBtn.isHidden = true
        beforeView.isHidden = false
        afterView.isHidden = false
        afterRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        beforeRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
       
        self.isSaveComplationNotes = "false"
        UserDefaults.standard.set(isSaveComplationNotes, forKey: "SaveComplationNotesKey")
        if OnlyForCrop == true {
            
            self.beforeAfterView.isHidden = true
            self.checkMarkSaveCompNotes.isHidden = true
            self.lblDocname.isHidden = true
            self.txtname.isHidden = true
            self.lblDocDes.isHidden = true
            self.textView_Height.constant = 0
        }else{
            self.beforeAfterView.isHidden = false
            if OnlycheckMarkCompl == true {
                H_NewelyCompLbl.constant = 0
                self.theNewlyaddCompLbl.isHidden = true
                self.checkMarkSaveCompNotes.isHidden = true
            }else{
                
                var yourImage: UIImage = UIImage(named: "BoxOFCheck.png")!
                claim_rembrImg.image = yourImage
                isSaveNotes = 1
                theNewlyaddCompLbl.text = LanguageKey.update_desc_append_complition
                self.isSaveComplationNotes = "true"
                H_NewelyCompLbl.constant = 34
                UserDefaults.standard.set(isSaveComplationNotes, forKey: "SaveComplationNotesKey")
                //   H_NewelyCompLbl.constant = 0
                self.checkMarkSaveCompNotes.isHidden = false
            }
            
            self.textView_Height.constant = 103
            self.lblDocname.isHidden = false
            self.txtname.isHidden = false
            self.lblDocDes.isHidden = false
        }
        
        self.removeAfterBtn.isHidden = true
        self.RemoveTgBtn.isHidden = true
        self.tagView.isHidden = true
        
        lblDocname.text = LanguageKey.doc_name
        lblDocDes.text = LanguageKey.doc_des_op//description
        btnUpload.setTitle(LanguageKey.save_btn, for: .normal)
        btnCustomise.setTitle(LanguageKey.customize, for: .normal)
        afterLbl.text = LanguageKey.after
        beforeLbl.text = LanguageKey.before
        saveCompNotsLbl.text = LanguageKey.save_as_completion_notes
        txtname.text = name ?? ""
        
        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobDocumentDetails)
        
        if let img = image {
            imgView.image = img
            webView.isHidden = true
            editedimage = img
        }else{
            
            if isSignature {
                self.beforeAfterView.isHidden = true
                self.checkMarkSaveCompNotes.isHidden = true
                lblDocname.isHidden  = true
                txtname.isHidden = true
                lblDocDes.isHidden = true
                txtView.isHidden = true
                btnCustomise.isHidden = true
                btnUpload.isHidden = true
            }
            
            if let fileUrl = docUrl {
                self.webView.load(NSURLRequest(url: fileUrl) as URLRequest)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        
        self.txtname.isUserInteractionEnabled = true
        if hideAfternBeforeBtn == true {
            self.beforeAfterView.isHidden = true
            self.beforeAfterView.isHidden = true
        }
        
        
        if OnlyForHideAllTxtView == true {
             self.backgroundWhitVw.isHidden = false
            self.OnlyForShowAllTxtView = true
             self.navigationItem.title = ""
        }else{
            self.navigationItem.title = LanguageKey.attachment
             killLoader()
             self.backgroundWhitVw.isHidden = true
           
            if OnlyForShowAllTxtView == true {
                
            
            self.H_titleLbl.constant = 0
            self.H_txtTittleVw.constant = 0
            self.textView_Height.constant = 0
            self.lblDocDes.isHidden = true
            self.checkMarkSaveCompNotes.isHidden = true
            self.btnCustomise.isHidden = true
            }
        }

        var isSwitchOff = ""
        isSwitchOff =   UserDefaults.standard.value(forKey: "RemoveTagBtn") as? String ?? ""
        
        if isSwitchOff == "Hide" {
            buttondd = true
             self.removeAfterBtn.isHidden = true
            RemoveTgBtn.isHidden = true
                      afterRadioImg.isHidden = false
                      beforeRadioImg.isHidden = false
                      beforeCancelmg.isHidden = true
                      afterCancekImg.isHidden = true
            beforeView.isHidden = false
            afterView.isHidden = false
            
            afterRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
            beforeRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        }
        if isSwitchOff == "UnHide" {
            buttondd = false
             self.removeAfterBtn.isHidden = false
             RemoveTgBtn.isHidden = false
         
        }
        
        var isSwitchOff1 = ""
        isSwitchOff1 =   UserDefaults.standard.value(forKey: "SaveTag1") as? String ?? ""
        if isSwitchOff1 == "On" {
            self.removeAfterBtn.isHidden = true
              RemoveTgBtn.isHidden = true
              beforeCancelmg.isHidden = true
              afterCancekImg.isHidden = true
            
            beforeView.isHidden = false
            afterView.isHidden = false
            afterRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
            beforeRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        }
        
    }
    
    
    @IBAction func beforeBtnAct(_ sender: Any) {
        
        let onn1 = ""
        UserDefaults.standard.set(onn1, forKey: "SaveTag1")
        let onn2 = ""
               UserDefaults.standard.set(onn2, forKey: "SaveTag")
        let onn = ""
                          UserDefaults.standard.set(onn, forKey: "RemoveTag")
 
       beforeAfterString = "before"
        self.afterView.isHidden = true
        if image != nil{
        self.showPhotoEditorAfterAndBefore(withImage:image! ,andImageName: trimString(string: name ?? ""))
        }
         buttondd = true
        afterCancekImg.isHidden = false
        beforeCancelmg.isHidden = false
        afterRadioImg.isHidden = true
        beforeRadioImg.isHidden = true
   
          self.removeAfterBtn.isHidden = false
        RemoveTgBtn.isHidden = false
        self.tagView.isHidden = true
        tagLbl.text = "Before"
        beforeLbl.text = "Before"
        afterRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        beforeRadioImg.setImage(UIImage(named:"radio-selected"), for: .normal)
    }
    
    @IBAction func afterBtnAct(_ sender: Any) {
       
        let onn2 = ""
                      UserDefaults.standard.set(onn2, forKey: "SaveTag")
        let onn1 = ""
        UserDefaults.standard.set(onn1, forKey: "SaveTag1")
        let onn = ""
                     UserDefaults.standard.set(onn, forKey: "RemoveTag")
    
        self.beforeView.isHidden = true
         beforeAfterString = "after"
        if image != nil{
        self.showPhotoEditorAfterAndBefore(withImage:image! ,andImageName: trimString(string: name ?? ""))
        }
         buttondd = true
        afterCancekImg.isHidden = false
        beforeCancelmg.isHidden = false
        afterRadioImg.isHidden = true
        beforeRadioImg.isHidden = true
     
          self.removeAfterBtn.isHidden = false
        RemoveTgBtn.isHidden = false
        tagLbl.text = "After"
        self.tagView.isHidden = true
        afterLbl.text = "After"
        beforeRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        afterRadioImg.setImage(UIImage(named:"radio-selected"), for: .normal)
    }
    
    @IBAction func removeTagBtnActAfter(_ sender: Any) {
        
        let onn2 = ""
        UserDefaults.standard.set(onn2, forKey: "SaveTag")
        let onn1 = ""
        UserDefaults.standard.set(onn1, forKey: "SaveTag1")
        buttondd = false
        let onn = "On"
        UserDefaults.standard.set(onn, forKey: "RemoveTag")
        
        if image != nil{
            
            self.showPhotoEditorAfterAndBefore(withImage:image! ,andImageName: trimString(string: name ?? ""))
        }
        beforeAfterString = "remove"
        tagLbl.text = ""
        self.tagView.isHidden = true
        afterRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        beforeRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        afterView.isHidden = false
        removeAfterBtn.isHidden = true
        RemoveTgBtn.isHidden = true
        beforeView.isHidden = false
        afterRadioImg.isHidden = false
        beforeRadioImg.isHidden = false
        beforeCancelmg.isHidden = true
        afterCancekImg.isHidden = true
        afterRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        beforeRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        
    }
    @IBAction func removeTagBtnAct(_ sender: Any) {
       
        let onn2 = ""
                      UserDefaults.standard.set(onn2, forKey: "SaveTag")
        let onn1 = ""
        UserDefaults.standard.set(onn1, forKey: "SaveTag1")
         buttondd = false
        let onn = "On"
              UserDefaults.standard.set(onn, forKey: "RemoveTag")
      
        if image != nil{
       
        self.showPhotoEditorAfterAndBefore(withImage:image! ,andImageName: trimString(string: name ?? ""))
            
        }
        beforeAfterString = "remove"
        tagLbl.text = ""
        self.tagView.isHidden = true
        afterRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        beforeRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
        afterView.isHidden = false
        RemoveTgBtn.isHidden = true
        beforeView.isHidden = false
          removeAfterBtn.isHidden = true
       
           afterRadioImg.isHidden = false
           beforeRadioImg.isHidden = false
           beforeCancelmg.isHidden = true
           afterCancekImg.isHidden = true
           afterRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
           beforeRadioImg.setImage(UIImage(named:"radio_unselected"), for: .normal)
    }
    @IBAction func saveCompletionNotsAct(_ sender: Any) {
        
        self.buttonSwitched = !self.buttonSwitched
        
        if self.buttonSwitched
        {
            
            var yourImage: UIImage = UIImage(named: "BoxOFCheck.png")!
            claim_rembrImg.image = yourImage
            isSaveNotes = 1
            theNewlyaddCompLbl.text = LanguageKey.update_desc_append_complition
            self.isSaveComplationNotes = "true"
            H_NewelyCompLbl.constant = 34
            UserDefaults.standard.set(isSaveComplationNotes, forKey: "SaveComplationNotesKey")
            
        }
        else
        {
            
            var yourImage: UIImage = UIImage(named: "BoxOFUncheck.png")!
            claim_rembrImg.image = yourImage
            isSaveNotes = 0
            H_NewelyCompLbl.constant = 0
            self.isSaveComplationNotes = "false"
            UserDefaults.standard.set(isSaveComplationNotes, forKey: "SaveComplationNotesKey")
            
        }
    }
    
    @IBAction func tapAction(_ sender: Any) {
        EXPhotoViewer.showImage(from: imgView)
    }
    
    
    @IBAction func btnUplaod(_ sender: Any) {
        
        if callback != nil {
            windowController.showToast(message: "Attachment uploaded successfully.")
            callback!(editedimage!,txtname.text!,txtView.text!)
        }
        
        if callbackForDocument != nil {
            callbackForDocument!(txtname.text!,txtView.text!)
        }
        
        if callbackForComplictionNotes != nil {
            UserDefaults.standard.set(txtView.text, forKey: "forCompSuggesion")
            callbackForComplictionNotes!(editedimage!,txtname.text!,txtView.text!,isSaveNotes,isCompletionBack)
        }
    }
    
    
    @IBAction func btnCustomise(_ sender: Any) {
        self.showPhotoEditor(withImage:image! ,andImageName: trimString(string: name ?? ""))
    }
    
    func setBackBarButtonCustom() {
         //Back buttion
         let button = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(AuditVC.onClcikBack))
         self.navigationItem.leftBarButtonItem  = button
     }
     
        @objc func onClcikBack() {
            _ = self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    
    func showPhotoEditor(withImage:UIImage, andImageName:String) -> Void {
        DispatchQueue.main.async {
            
            if  self.buttondd == true {
                let onn = "On"
                UserDefaults.standard.set(onn, forKey: "RemoveTag")
            }
            if  self.buttondd == false {
                let onn = ""
                UserDefaults.standard.set(onn, forKey: "RemoveTag")
            }
            let onn = "On"
            UserDefaults.standard.set(onn, forKey: "SaveTag")
            
            let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
            photoEditor.photoEditorDelegate = self
            photoEditor.hiddenControls = [.sticker, .text, .save, .share]
            photoEditor.image = withImage
            photoEditor.imageName = andImageName
            photoEditor.imageNamePlaceholder = LanguageKey.enter_file_name
            photoEditor.isJobDocument = true
            self.OnlyForHideAllTxtView = false
            photoEditor.modalPresentationStyle = .fullScreen
            self.present(photoEditor, animated: true, completion: nil)
        }
    }
    
    func showPhotoEditorAfterAndBefore(withImage:UIImage, andImageName:String) -> Void {
         DispatchQueue.main.async {
             let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
             photoEditor.photoEditorDelegate = self
             photoEditor.hiddenControls = [.sticker, .text, .save, .share]
             photoEditor.image = withImage
             photoEditor.beforeAfterStringOne = self.beforeAfterString
             photoEditor.hideCrop = "true"
             photoEditor.imageName = andImageName
             photoEditor.imageNamePlaceholder = LanguageKey.enter_file_name
             photoEditor.isJobDocument = true
             photoEditor.modalPresentationStyle = .fullScreen
          
             self.present(photoEditor, animated: true, completion: nil)
             }
     }
     
     
     func doneEditing(image: UIImage, imageName: String) {
       
         self.editedimage = image
        
         DispatchQueue.main.async {
             self.imgView.image = image
         }
     }
   
     func canceledEditing() {

     }
     
}
