//
//  FeedbackVC.swift
//  EyeOnTask
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController, YPSignatureDelegate,OptionViewDelegate {
   
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblSignature: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblSendYourFeedback: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    
    
    @IBOutlet var signautrePadView: YPDrawSignatureView!
    @IBOutlet var smilyImage: UIImageView!
    @IBOutlet var muteImage: UIImageView!
    @IBOutlet var sadImage: UIImageView!
    @IBOutlet var smileBtn: UIButton!
    @IBOutlet var muteBtn: UIButton!
    @IBOutlet var sadBtn: UIButton!
    
    
  
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var signaturePadHeight: NSLayoutConstraint!
    
   
    @IBOutlet weak var submitBtn: NSLayoutConstraint!
    
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
    var selectedCell : IndexPath? = nil
    var objOfUserJobListInDetail : UserJobList?
    var moodSelection = Int()
    
    var pressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moodSelection = 3
        signautrePadView.delegate = self
        self.signautrePadView.layer.zPosition = 1
        
        setLocalization()
        
        
        let isItem = isPermitForShow(permission: permissions.isItemVisible)
        if !isItem {
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
             swipeLeft.direction = UISwipeGestureRecognizer.Direction.right
             self.view.addGestureRecognizer(swipeLeft)
        }
        
        getJobCardTemplates()
        
        self.EmailView.isHidden = true
        let kprVar = objOfUserJobListInDetail?.kpr
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
            self.SelectSingnaturetxtfied.text = ("\(String(describing: fw.fnm!)) \(String(describing: fw.lnm!))")
            
        }

       
       
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationResive), name: Notification.Name ("FeedbackVC"), object: nil)
        
    }
    
    
    @objc func NotificationResive(){
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FeedbackVC") , object: nil)
        showBackgroundView()
        view.addSubview(EmailView)
        self.EmailView.isHidden = false
        EmailView.center = CGPoint(x: backgoundView.frame.width/2, y: backgoundView.frame.height/2)
        print("tep")
    }
//    @objc func NotificationResive(){
//        showBackgroundView()
//         self.EmailView.isHidden = false
//    }
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
        vc.jobIdDetail = objOfUserJobListInDetail?.jobId as! String
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
        vc.pdfDetailJobId =  objOfUserJobListInDetail?.jobId as! String
        vc.jobIdLabel = objOfUserJobListInDetail?.label as! String
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
  
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.title_feedback
        lblSendYourFeedback.text = LanguageKey.feed_head
        lblDes.text = LanguageKey.feed_sub_head
        lblDescription.text = LanguageKey.description
        lblSignature.text = LanguageKey.sign
        btnClear.setTitle(LanguageKey.clear , for: .normal)
        btnSubmit.setTitle(LanguageKey.submit_btn , for: .normal)
       
    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
         if gesture.direction == .right {
             if (self.tabBarController?.selectedIndex)! > 0 {
                 self.tabBarController?.selectedIndex -= 1
             }
         }
     }

    override func viewWillAppear(_ animated: Bool) {
       // self.parent?.title = "Feedback"
        
       
        self.EmailView.isHidden = true
        self.backgoundView.isHidden = true
        
        
        
        self.tabBarController?.navigationItem.title = LanguageKey.title_feedback
        
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = true
            button.tintColor = UIColor.white
        }
        
        resetView()
        
        if UIScreen.main.sizeType == .iPhone5 {
           self.descriptionHeight.constant = 70
           self.signaturePadHeight.constant = 150
           self.submitBtn.constant = 25

        }
        
//        if UIScreen.main.sizeType == .iPhoneX {
//            self.descriptionHeight.constant = 135
//            self.signaturePadHeight.constant = 250
//        }
        
        if UIDevice.current.hasNotch {
           self.descriptionHeight.constant = 135
           self.signaturePadHeight.constant = 250
        }
        
       
    }
    
   
    
    //=====================================
    // MARK: Feedback Button Functionality
    //=====================================
    

    @IBAction func feedbackBtn(_ sender: UIButton) {
        moodSelection = sender.tag
        feedbackEmoji(moodSelection: moodSelection )
    }
    
    func feedbackEmoji(moodSelection : Int) -> Void {
        switch moodSelection {
        case 1:
            self.sadImage.image = UIImage(named: "sad_face_2.png")
            self.smilyImage.image = UIImage(named: "smily_face.png")
            self.muteImage.image = UIImage(named: "mute_face.png")
            break
            
        case 2:
            self.muteImage.image = UIImage(named: "mute_face_2.png")
            self.smilyImage.image = UIImage(named: "smily_face.png")
            self.sadImage.image = UIImage(named: "sad_face.png")
            break
        default:
            self.smilyImage.image = UIImage(named: "smily_face_2.png")
            self.muteImage.image = UIImage(named: "mute_face.png")
            self.sadImage.image = UIImage(named: "sad_face.png")
        }
    }
    

    //==================================
    // MARK: Signaure_Pad Functionality
    //===================================
    
    @IBAction func submitBtn(_ sender: Any) {
        
        let feedbackString = trimString(string: txtDescription.text!)
       // if signautrePadView.doesContainSignature || feedbackString.count > 0 {
            self.feedbackService(feebBackTxt: feedbackString)
       // }
        
    }
    
    @IBAction func clrBtn(_ sender: Any) {
        self.signautrePadView.clear()
    }

    
    func feedbackService(feebBackTxt : String) -> Void {
        
        /*
         usrId -> User id
         jobId -> Job id
         des -> Description
         rating -> 1 - Poor , 2 - Happy , 3 - Very happy
         sign -> File object
         */
        
//        var image = UIImage()
        
        showLoader()
        
        var image : UIImage? = nil
        
        if let signatureImage = self.signautrePadView.getSignature(scale: 1) {
           
            image = signatureImage
            
            // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
            self.signautrePadView.clear()
        }
        
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.jobId = objOfUserJobListInDetail?.jobId
        param.des = feebBackTxt
        param.rating = String(moodSelection)
        
        txtDescription.resignFirstResponder()
        self.txtDescription.text = ""
        self.signautrePadView.clear()
        
        serverCommunicatorUplaodImage(url: Service.addFeedback, param: param.toDictionary, image: image, imagePath: "sign", imageName: "image") { (response, success) in
            
            killLoader()
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(FeedBackRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        DispatchQueue.main.async{
                            if( decodedData.data.count > 0){
                                let obj = decodedData.data[0]
                                if (obj.jobid != nil && obj.jobid != ""){ //Only For Remove job when Admin Unassign job for FW
                                    var dict = [String : Any]()
                                    dict["data"] = [ "status_code" : obj.status_code! ,
                                                     "jobid" : obj.jobid!]
                                    NotiyCenterClass.fireJobRemoveNotifier(dict: (dict))
                                    self.tabBarController?.navigationController?.popToRootViewController(animated: true)
                                    
                                }
                            }else{
                                 self.showToast(message:getServerMsgFromLanguageJson(key: decodedData.message!)!)
                                
                            }
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
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                ShowError(message: errorString, controller: windowController)
            }
        }
    }
    
    func resetView() -> Void {
        txtDescription.resignFirstResponder()
        self.txtDescription.text = ""
        self.feedbackEmoji(moodSelection : 3)
        self.signautrePadView.clear()
    }
    
    //======================================================
    // MARK: Signature delegate methods
    //======================================================
    
    
    func didStart() {
        //print("Start Signature")
    }
    
    func didFinish() {
        // print("Finish Signature")
    }

    
}

