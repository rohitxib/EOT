//
//  JobDetailCltHstry.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 25/03/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit
import MessageUI
import ContactsUI
import CoreData
import CoreLocation


class JobDetailCltHstry: UIViewController , MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var jobDetailHstry : JobHWorkHistry?
    
    var jobDetailServ : ServiceDetailData?
        
    
    
    @IBOutlet weak var tableView_H: NSLayoutConstraint!
    
    @IBOutlet weak var attchCollView: UICollectionView!
    @IBOutlet weak var attechLbl: UILabel!
    @IBOutlet weak var attechImg: UIImageView!
    
    @IBOutlet weak var attechmntView_H: NSLayoutConstraint!
    @IBOutlet weak var itemList: UILabel!
    @IBOutlet weak var tableView: UITableView!
        
            @IBOutlet weak var backGroundBtn: UIButton!
            @IBOutlet weak var emailJobBtn: UIButton!
            @IBOutlet weak var printJobBtn: UIButton!
            @IBOutlet weak var emailView: UIView!
            @IBOutlet weak var desTextView: UITextView!
            @IBOutlet weak var item_Height: NSLayoutConstraint!
            @IBOutlet weak var equip_Height: NSLayoutConstraint!
            @IBOutlet weak var attechmentImg: UIImageView!
            @IBOutlet weak var itemImg: UIImageView!
            @IBOutlet weak var equipmentImg: UIImageView!
            
            
            @IBOutlet weak var velueCoustomFld: UILabel!
            @IBOutlet weak var customFld_Hight: NSLayoutConstraint!
            @IBOutlet weak var coustemFldDes: UILabel!
            @IBOutlet weak var coustomFldBtn: UIButton!
            
            @IBOutlet weak var coustomFld: UILabel!
            @IBOutlet weak var rescheduleBtn: UIButton!
            @IBOutlet weak var requestForVisite: UIButton!
            @IBOutlet weak var locationTxtView: UITextView!
            @IBOutlet weak var H_fieldworkersView: NSLayoutConstraint!
            
            @IBOutlet weak var btnOkContact: UIButton!
            @IBOutlet weak var btnOkChat: UIButton!
            @IBOutlet weak var btbOkDescription: UIButton!
            @IBOutlet weak var btnCancelPicker: UIButton!
            @IBOutlet weak var btnDonePicker: UIButton!
            @IBOutlet weak var lblTags: UILabel!
            
            @IBOutlet weak var lblFieldworkers: UILabel!
            @IBOutlet weak var lblContactName: UILabel!
            @IBOutlet weak var lblInstuction1: UILabel!
            @IBOutlet weak var lblDescription1: UILabel!
            
            @IBOutlet weak var lblLocation1: UILabel!
            
            @IBOutlet weak var lblStatus: UILabel!
            @IBOutlet weak var lblJobCode: UILabel!
            @IBOutlet weak var topViewConnect: NSLayoutConstraint!
            @IBOutlet weak var contactDetailViewHeight: NSLayoutConstraint!
            @IBOutlet weak var fwTagsView: ASJTagsView!
            @IBOutlet weak var desTextView_H: NSLayoutConstraint!
            
            @IBOutlet weak var tagsView: ASJTagsView!
            @IBOutlet weak var statusTwoButtons_H: NSLayoutConstraint!
            @IBOutlet var lbl_SkypeId: UITextView!
            @IBOutlet var lbl_TwitterId: UITextView!
            @IBOutlet var nameLbl: UILabel!
            @IBOutlet var jobCodeLbl: UILabel!
            @IBOutlet var titleLbl: UILabel!
            @IBOutlet var timeLbl: UILabel!
            @IBOutlet var priorityLbl: UILabel!
            @IBOutlet var taskStatusLbl: UILabel!
            
            @IBOutlet var descriptionLbl: UILabel!
            @IBOutlet var contactNmaeLbl: UILabel!
            @IBOutlet weak var instructionLbl: UILabel!
            
            @IBOutlet weak var descriptionHeadingLbl: UILabel!
            @IBOutlet weak var btnMob1: UIButton!
            @IBOutlet weak var btnMob2: UIButton!
            
            @IBOutlet weak var H_statusVwBottom: NSLayoutConstraint!
            @IBOutlet weak var H_statusVw: NSLayoutConstraint!
            @IBOutlet weak var statusVw: UIView!
            // @IBOutlet weak var lblStatus: UILabel!
            
            @IBOutlet weak var imgStatus: UIImageView!
            @IBOutlet weak var btnStatusType: UIButton!
            
            @IBOutlet weak var lblTaskStatus: UILabel!
            @IBOutlet var backgroundView: UIView!
            @IBOutlet var chatView: UIView!
            @IBOutlet var contactNoView: UIView!
            @IBOutlet var descriptionView: UIView!
            @IBOutlet var textDescriptionView: UITextView!
            @IBOutlet var firstView: UIView!
            @IBOutlet var acceptBtn: UIButton!
            @IBOutlet var declineBtn: UIButton!
            
            @IBOutlet weak var btnInstructionView: UIButton!
            @IBOutlet var mapBtn: UIButton!
            @IBOutlet var viewBtn: UIButton!
            @IBOutlet var mailBtn: UIButton!
            @IBOutlet var socialBtn: UIButton!
            @IBOutlet var callBtn: UIButton!
            @IBOutlet var detailDatePicker: UIDatePicker!
            @IBOutlet var pickerTabView: UIView!
            
            @IBOutlet weak var lblCompletiondetail: UILabel!
            @IBOutlet weak var lblTitleCompletion: UILabel!
            @IBOutlet weak var btnAddNotes: UIButton!
            
            var arrOfShowData = [CustomFormDetals]()
            var arrOfShowDatas : GetDetail!
            var objOFTestVC : TestDetails?
            var Strjhing = String()
            var Strjhings = String()
            var callbackDetailVC: ((Bool,NSManagedObject) -> Void)?
            var optionalVw : OptionalView?
            var jobArray = [UserJobList]()
            var arrOfCustomForm = [TestDetails]()
            var arrTypeStatus : [taskStatusType] = [.Reject, .Cancel, .InProgress, .OnHold, .Completed]
            var Reject = LanguageKey.reject
            var Cancel = LanguageKey.cancel
            var InProgress = LanguageKey.In_progress
            var OnHold = LanguageKey.on_hold
            var Completed = LanguageKey.completed
            
            @IBOutlet var firstViewHeightConstrant: NSLayoutConstraint!
            var objOfUserJobListInDetail : ServiceDetailData?
            var itemListDetail = [itemListInfoList]()
            var isFirst = Bool()
            var isComplite = true
            var isTapped = true
            var animator = UIViewPropertyAnimator()
            var rectAcceptBtn = CGRect()
            var rectDeclineBtn = CGRect()
            var lattitude : String? = nil
            var longitude : String? = nil
            var currentStatusID : String? = nil
            @IBOutlet weak var scrollVw: UIScrollView!
            //For send date time on server from user input
            var job : UserJobList?
            var statusId : taskStatusType?
            var sltDate : String? = ""
            var jobLocation = CLLocationCoordinate2D()
            var arr = [getQuestionsBy]()
            var arre : getQuestionsBy?
           
    
    var imgName = ""
    var arrOfShowDataAttch = [DocResDataDetails]()
 
    
            override func viewDidLoad() {
                super.viewDidLoad()
                self.getDocumentsList()
                self.attechmntView_H.constant = 400
                      getItemListRecord()
                 getAuditDetail()
                //desTextView.textColor = UIColor.lightGray
          
                self.backGroundBtn.isHidden = true
                 self.emailView.isHidden = true

                
                self.item_Height.constant = 0
                self.equip_Height.constant = 0
                self.attechmentImg.isHidden = true
                self.itemImg.isHidden = true
                self.equipmentImg.isHidden = true
                //self.coustemFldDes.text = "\(self.arr[0].des ?? "")"
                
                var isCustomFieldEnable = true
                if let enableCustomForm = getDefaultSettings()?.isCustomFieldEnable{ //This is round off digit for invoice
                    if enableCustomForm == "0"{
                        self.customFld_Hight.constant = 0
                        self.coustomFldBtn.isHidden = true
                    }else{
                        self.customFld_Hight.constant = 95
                      //  self.coustomFldBtn.isHidden = false
                    }
                }
                
                /////////////
                getFormDetail()
                
                ///////////
                self.requestForVisite.isHidden = true
                
                if isPermitForShow(permission: permissions.isJobRescheduleOrNot) == true{
                    self.rescheduleBtn.isHidden = true
                    
                }else{
                   // self.rescheduleBtn.isHidden = false
                }
                
                
                
                // self.requestForVisite.isHidden = true
                self.locationTxtView.tintColor = UIColor.red
                setLocalization()
              //  setupMethod()
                self.navigationItem.rightBarButtonItem = nil;
                
                ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobDetails)
            }
            
            
            @objc func onClcikBack1(){
                        
                            //self.dismiss(animated: true, completion: nil)
                      
                   }
              @objc func addTapped(){
                
            }
            
            func setLocalization() -> Void {
                self.navigationItem.title = LanguageKey.job_details
                lblJobCode.text = LanguageKey.job_code
                coustomFld.text = LanguageKey.title_cutom_field
                lblStatus.text = LanguageKey.status_radio_btn
                lblLocation1.text = LanguageKey.location
                lblDescription1.text = LanguageKey.description
                lblInstuction1.text = LanguageKey.instr
                lblContactName.text = LanguageKey.contact_name
                lblFieldworkers.text = LanguageKey.fieldworkers
                lblTags.text = LanguageKey.tags
                btnInstructionView.setTitle(LanguageKey.view , for: .normal)
                viewBtn.setTitle(LanguageKey.view , for: .normal)
                mapBtn.setTitle(LanguageKey.map , for: .normal)
                btnCancelPicker.setTitle(LanguageKey.cancel , for: .normal)
                btnDonePicker.setTitle(LanguageKey.done , for: .normal)
                btbOkDescription.setTitle(LanguageKey.ok , for: .normal)
                btnOkChat.setTitle(LanguageKey.ok , for: .normal)
                btnOkContact.setTitle(LanguageKey.ok , for: .normal)
                lblTitleCompletion.text = LanguageKey.completion_note
                rescheduleBtn.setTitle(LanguageKey.reschedule , for: .normal)
                requestForVisite.setTitle(LanguageKey.require_revisit , for: .normal)
                coustomFldBtn.setTitle(LanguageKey.add , for: .normal)
                itemList.text = LanguageKey.list_item
                
            }
            
            func setupMethod() -> Void {
                
                ////////////
    //            var someArray = [String]()
    //            if objOfUserJobListInDetail?.itemData  == someArray as NSObject {
    //                print("iteam data nil")
    //                self.item_Height.constant = 0
    //                self.itemImg.isHidden = true
    //
    //            }else{
    //                self.item_Height.constant = 14
    //                self.itemImg.isHidden = false
    //                self.itemImg.image = UIImage.init(named: "40x40")
    //                print("iteam data fill")
    //
    //            }
    //
    //            if objOfUserJobListInDetail?.equArray == someArray as NSObject {
    //                print("EquArray data nil")
    //                self.equipmentImg.isHidden = true
    //                self.equip_Height.constant = 0
    //            }else{
    //                self.equip_Height.constant = 14
    //                self.equipmentImg.isHidden = false
    //                print("EquArray data fill ")
    //
    //                self.equipmentImg.image =  UIImage.init(named: "equip")
    //            }
    //
    //            if objOfUserJobListInDetail?.attachCount == "0"  {
    //                self.attechmentImg.isHidden = true
    //
    //            }else{
    //                if objOfUserJobListInDetail?.attachCount == nil  {
    //                    self.attechmentImg.isHidden = true
    //                }else{
    //
    //                    self.attechmentImg.isHidden = false
    //                    self.attechmentImg.image =  UIImage.init(named: "icons8@-attech")
    //
    //                }
    //            }
                
                //////////
                
                //for enable swipe functionality
                swipe()
                
                //Hide background view
                backgroundView.isHidden = true
                
                nameLbl.text = objOfUserJobListInDetail?.nm != nil ? objOfUserJobListInDetail?.nm : "Unknown"
                jobCodeLbl.text = objOfUserJobListInDetail?.label
                
                
                
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
                
                let fiewldWorkers = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: query) as! [FieldWorkerDetails]
                var nameArr = [Any]()
                
                for fw in fiewldWorkers {
                    nameArr.append(("\(String(describing: fw.fnm!)) \(String(describing: fw.lnm!))"))
                }
                
                self.fwTagsView.appendTags(nameArr as! [String], withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: false)
                
                //   self.fwTagsView
                
                
                
                ////////////////////////
                
                // Append Address detail==============================
                let adr = objOfUserJobListInDetail?.adr != "" ? objOfUserJobListInDetail?.adr : ""
                var ctry = objOfUserJobListInDetail?.ctry != "" ? objOfUserJobListInDetail?.ctry : ""
                var stt = objOfUserJobListInDetail?.state != "" ? objOfUserJobListInDetail?.state : ""
                let city = objOfUserJobListInDetail?.city != "" ? objOfUserJobListInDetail?.city : ""
                // let snm = objOfUserJobListInDetail?.snm != "" ? objOfUserJobListInDetail?.snm : ""
                
                
                if(ctry != ""){
                    let name = filterStateAccrdToCountry(serchCourID: (ctry)!, searchPredicate: "id", arr: getCountry() as! [Any])
                    ctry = name.count != 0 ? (name[0] as? [String : Any])!["name"] as? String  : ""
                }
                
                
                if(stt != ""){
                    let statename = filterStateAccrdToCountry(serchCourID: (stt)!, searchPredicate: "id", arr: getStates() as! [Any])
                    stt = statename.count != 0 ? (statename[0] as? [String : Any])!["name"] as? String : ""
                }
                
                
                var address = ""
                
                if adr! != "" {
                    if address == "" {
                        address =  "\(adr!)"
                    }
                }
                
                if let mark = objOfUserJobListInDetail?.landmark {
                    
                    if address != "" {
                        if  mark != "" {
                            address = address + ", \(mark.capitalizingFirstLetter())"
                        }
                    } else {
                        address = mark.capitalizingFirstLetter()
                    }
                }
                
                //        if snm! != "" {
                //            if address != "" {
                //                address = address + ", \(snm!)"
                //            } else {
                //                address = "\(snm!)"
                //            }
                //        }
                
                if city! != "" {
                    if address != ""{
                        address = address + ", \(city!)".capitalized
                    }else{
                        address = "\(city!)"
                    }
                }
                
                
                if stt! != "" {
                    if address != ""{
                        address = address + ", \(stt!)".capitalized
                    }else{
                        address = "\(stt!)"
                    }
                }
                
                if ctry! != "" {
                    if address != ""{
                        address = address + ", \(ctry!)".capitalized
                    }else{
                        address = "\(ctry!)"
                    }
                }
                
                
                if  address != "" {
                    locationTxtView.attributedText =  lineSpacing(string: address.capitalized, lineSpacing: 7.0)
                }else{
                    locationTxtView.text = ""
                }
                
                
                // Description and Instruction, Skype, Twitter ==============================
                if  objOfUserJobListInDetail?.des != "" {
                    descriptionLbl.attributedText =  lineSpacing(string: (objOfUserJobListInDetail?.des?.capitalizingFirstLetter())!, lineSpacing: 7.0)
                }else{
                    descriptionLbl.text = ""
                }
                
                if  objOfUserJobListInDetail?.complNote != nil && objOfUserJobListInDetail?.complNote != "" {
                    btnAddNotes.setTitle(LanguageKey.edit, for: .normal)
                    lblCompletiondetail.attributedText =  lineSpacing(string: (objOfUserJobListInDetail?.complNote?.capitalizingFirstLetter())!, lineSpacing: 7.0)
                }else{
                    btnAddNotes.setTitle(LanguageKey.add, for: .normal)
                    lblCompletiondetail.text = ""
                }
                
                
                
                if  objOfUserJobListInDetail?.inst != "" {
                    instructionLbl.attributedText =  lineSpacing(string: (objOfUserJobListInDetail?.inst?.capitalizingFirstLetter())!, lineSpacing: 7.0)
                }else{
                    instructionLbl.text = ""
                }
                
                if objOfUserJobListInDetail?.mob1 != "" {
                    btnMob1.setTitle(objOfUserJobListInDetail?.mob1, for: .normal)
                }else{
                    btnMob1.isUserInteractionEnabled = false
                    btnMob1.setTitle(LanguageKey.not_available, for: .normal)
                    btnMob1.setTitleColor(UIColor.lightGray, for: .normal)
                }
                
                if objOfUserJobListInDetail?.mob2 != "" {
                    btnMob2.setTitle(objOfUserJobListInDetail?.mob2, for: .normal)
                }else{
                    btnMob2.isUserInteractionEnabled = false
                    btnMob2.setTitle(LanguageKey.not_available, for: .normal)
                    btnMob2.setTitleColor(UIColor.lightGray, for: .normal)
                }
                
                
                //For Twitter and Skype
    //            if objOfUserJobListInDetail?.skype != nil && objOfUserJobListInDetail?.skype !=  ""{
    //                self.lbl_SkypeId.text = objOfUserJobListInDetail?.skype
    //            }else{
    //                self.lbl_SkypeId.text = LanguageKey.not_available
    //            }
    //
    //            if objOfUserJobListInDetail?.twitter != nil && objOfUserJobListInDetail?.twitter !=  ""{
    //                self.lbl_TwitterId.text = objOfUserJobListInDetail?.twitter
    //            }else{
    //                self.lbl_TwitterId.text = LanguageKey.not_available
    //            }
                
                
                //        let tempTime = convertTimestampToDate(timeInterval: (objOfUserJobListInDetail?.schdlStart)!)
                //        timeLbl.text = tempTime.0 + tempTime.1
                
                if objOfUserJobListInDetail?.schdlStart != "" {
                    let tempTime = convertTimestampToDate(timeInterval: (objOfUserJobListInDetail?.schdlStart)!)
                    timeLbl.text = tempTime.0 + tempTime.1
                } else {
                    timeLbl.text = ""
                }
                
                
                if objOfUserJobListInDetail?.prty != "0" {
    //                let priorityDetail = taskStatus(taskType: taskStatusType(rawValue: Int((objOfUserJobListInDetail?.prty)!)!)!)
    //                let statusName = priorityDetail.0.replacingOccurrences(of: " Task", with: "")
    //                imgStatus.image = priorityDetail.1
    //                lblTaskStatus.text = statusName
                    
                    
                    let priorityDetail = taskPriorityImage(Priority: taskPriorities(rawValue: Int((objOfUserJobListInDetail?.prty)!)!)!)
                    priorityLbl.text = priorityDetail.0
                   // imgStatus.image = priorityDetail.1
                }
                
                
                if let statusId = objOfUserJobListInDetail?.status {
                    let status = taskStatus(taskType: taskStatusType(rawValue: Int(statusId == "0" ? "1" : (statusId))!)!)
                    let statusName = status.0.replacingOccurrences(of: " Task", with: "")
                    lblTaskStatus.text = statusName
                    currentStatusID = objOfUserJobListInDetail?.status
                    
                    DispatchQueue.main.async {
                        self.rectAcceptBtn = self.acceptBtn.frame
                        self.rectDeclineBtn = self.declineBtn.frame
                        self.isFirst = true
                    //    self.ChangeButtonsAccordingToStatusType(status: taskStatusType(rawValue: Int(statusId == "0" ? "1" : (statusId))!)!)
                        self.isFirst = false
                    }
                }else {
                    lblTaskStatus.text = ""
                    imgStatus.image = nil
                }
                
                
                
                if objOfUserJobListInDetail?.cnm == "" {
                    let query = "cltId = '\(objOfUserJobListInDetail?.cltId! ?? "unknown")'"
                    
                    let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as? [ClientList]
                    if isExist?.count != 0 && isExist != nil{
                        let cltDetails = isExist![0]
                        contactNmaeLbl.text = cltDetails.nm?.capitalizingFirstLetter()
                    }else{
                        contactNmaeLbl.text = ""
                    }
                }else{
                    contactNmaeLbl.text = objOfUserJobListInDetail?.cnm?.capitalizingFirstLetter()
                }
                
    //            if (objOfUserJobListInDetail?.tagData != nil  && (objOfUserJobListInDetail?.tagData as! [Any]).count > 0 ){
    //                for tag in (objOfUserJobListInDetail?.tagData as! [Any]) {
    //                    self.tagsView.appendTags([(tag as! [String:String])["tnm"]!], withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: false)
    //                }
    //            }
                
                //For showing title
                var strTitle = ""
    //            for jtid in (objOfUserJobListInDetail?.jtId as! [AnyObject]) {
    //                if strTitle == ""{
    //                    strTitle = (jtid as! [String:String])["title"]!
    //                }else{
    //                    strTitle = "\(strTitle), \((jtid as! [String:String])["title"]!)"
    //                }
    //            }
                
                if  strTitle != "" {
                    titleLbl.attributedText =  lineSpacing(string: strTitle, lineSpacing: 4.0)
                }else{
                    descriptionLbl.text = ""
                }
                
                if objOfUserJobListInDetail?.des == nil || objOfUserJobListInDetail?.des == "" {
                    self.desTextView_H.constant = 0
                   
                    return
                }
                showLoader()
                self.desTextView_H.constant = 175
                
                
                DispatchQueue.global(qos: .background).async {
                    let htmlString = self.objOfUserJobListInDetail?.des
                    let attributedString = htmlString!.htmlToAttributedString
                    DispatchQueue.main.async {
                        self.desTextView.attributedText = attributedString
                        killLoader()
                        print("Successfully converted string to HTML")
                    }
                }
                
                
            }
            
            
            
            
            func getAllThings(withIds ids: [String]) -> [FieldWorkerDetails] {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FieldWorkerDetails")
                fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
                
                do {
                    if let things = try context.fetch(fetchRequest) as? [FieldWorkerDetails] {
                        return things
                    }
                } catch {
                    // handle error
                }
                
                return []
            }
            
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                
//                let image = UIImage(named:"send_icon-1")
//                    let leftButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
//                    self.navigationItem.rightBarButtonItem = leftButton
                
                
                getFormDetail()
                LocationManager.shared.startStatusLocTracking()
                
                self.tabBarController?.navigationItem.title = LanguageKey.job_details
                
                if let button = self.parent?.navigationItem.rightBarButtonItem {
                    button.isEnabled = false
                    button.tintColor = UIColor.clear
                }
                
                APP_Delegate.mainArr.removeAll()
                
                
                if UIScreen.main.sizeType == .iPhone5 {
                    self.nameLbl.font = nameLbl.font.withSize(14.0)
                }
                
                if getDefaultSettings()?.isHideContact == "1" && objOfUserJobListInDetail?.status == String(taskStatusType.New.rawValue){
                    contactDetailViewHeight.constant = 0
                    topViewConnect.constant = 0
                    //contactDetailView.isHidden = true
                }
            }
            
            @IBAction func backGroundBtnActn(_ sender: Any) {
                 self.backGroundBtn.isHidden = true
                 self.emailView.isHidden = true
            }
            
            @IBAction func printJob(_ sender: Any) {
                  self.backGroundBtn.isHidden = false
                  self.emailView.isHidden = true
                let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "pdfvc") as! ShowPdfVC
                                    vc.pdfDetailJob = true
                                    vc.pdfDetailJobId =  objOfUserJobListInDetail?.jobId as! String
                                    vc.jobIdLabel = objOfUserJobListInDetail?.label as! String
                                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                                    self.navigationController!.pushViewController(vc, animated: true)
            }
            
            
            @IBAction func emailJob(_ sender: Any) {
                                  self.backGroundBtn.isHidden = false
                                  self.emailView.isHidden = true
                                  ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoiceEmail)
                                  let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
                                  let vc = storyboard.instantiateViewController(withIdentifier: "EMAILINVOICE") as! EmailInvoiceVC
                                // vc.invoiceid = (self.invoiceRes.data?.invId)!
                                   vc.isJobDetail = true
                                   vc.jobIdDetail = objOfUserJobListInDetail?.jobId as! String
                              //  vc.pdfDetailAppoinmentarr = itemValue
                               //  vc.str = appintDetainsDicCommon?.commonId ?? ""
                                  self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                                  self.navigationController!.pushViewController(vc, animated: true)
            }
            
            
            @IBAction func emailSndBtn(_ sender: Any) {
        //        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        //                     let vc = storyboard.instantiateViewController(withIdentifier: "pdfvc") as! ShowPdfVC
        //                     vc.pdfDetailJob = true
        //                     vc.pdfDetailJobId =  objOfUserJobListInDetail?.jobId as! String
        //                     vc.jobIdLabel = objOfUserJobListInDetail?.label as! String
        //                     self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        //                     self.navigationController!.pushViewController(vc, animated: true)
                self.emailView.isHidden = false
                 self.backGroundBtn.isHidden = false
            }
            
            @IBAction func coustomFldAcn(_ sender: Any) {
                
    //            //let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
    //            let feedVC = storyboard?.instantiateViewController(withIdentifier: "CoustomField") as! CoustomField
    //            // feedVC.fff = arrOfShowDatas
    //            feedVC.sltNaviCount = 0
    //            feedVC.clickedEvent = nil
    //            feedVC.isCameFrmStatusBtnClk = true
    //            feedVC.objOfUserJobList = self.objOfUserJobListInDetail!
    //            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
    //            self.navigationController?.pushViewController(feedVC, animated: true)
            }
            
            @IBAction func rescheduleBtn(_ sender: Any) {
    //
    //            if isComplite == false {
    //                ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.close_completed_job_msg )!, controller: windowController)
    //                return
    //            }
    //
    //            let ladksj  = self.objOfUserJobListInDetail!.jobId!.components(separatedBy: "-")
    //            if ladksj.count > 0 {
    //                let tempId = ladksj[0]
    //                if tempId == "Job" {
    //
    //                    ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.job_not_sync)!, controller: windowController)
    //
    //
    //                }else{
    //                    let vc = storyboard?.instantiateViewController(withIdentifier: "RescheduleVC") as! RescheduleVC
    //                    vc.jobDetailData = objOfUserJobListInDetail
    //                    // vc.boolQuat = true
    //                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
    //                    self.navigationController!.pushViewController(vc, animated: true)
    //                }
    //            }
            }
            
            @IBAction func requestForVisite(_ sender: Any) {
                
    //            if objOfUserJobListInDetail?.parentId != "0"  {
    //                ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.revisit_msg_validation)!, controller: windowController)
    //                return
    //            }
    //
    //            let ladksj  = self.objOfUserJobListInDetail!.jobId!.components(separatedBy: "-")
    //            if ladksj.count > 0 {
    //                let tempId = ladksj[0]
    //                if tempId == "Job" {
    //
    //                    ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.job_not_sync)!, controller: windowController)
    //
    //
    //                }else{
    //                    let vc = storyboard?.instantiateViewController(withIdentifier: "Revisit") as! Revisit
    //                    vc.arrr = self.objOfUserJobListInDetail
    //                    // vc.boolQuat = true
    //                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
    //                    self.navigationController!.pushViewController(vc, animated: true)
    //                }
    //            }
                
                
            }
            
            @IBAction func BtnStatusPressed(_ sender: Any) {
                self.openDwopDown()
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
            
            //=============================================
            // MARK: Accept and Reject Btn Functionality
            //=============================================
            
            @IBAction func completionNots_Action(_ sender: Any) {
                
    //
    //            if !isHaveNetowork(){
    //                ShowError(message: AlertMessage.networkIssue, controller: windowController)
    //                return
    //            }
    //
    //            let vc = UIStoryboard(name: "MainJob", bundle: nil).instantiateViewController(withIdentifier: "CompletionNotsVC") as! CompletionNots
    //            let navCon = NavClientController(rootViewController: vc)
    //            vc.jobModel = self.objOfUserJobListInDetail!
    //            vc.callback = {(note) in
    //                if  note != "" {
    //                    self.btnAddNotes.setTitle(LanguageKey.edit, for: .normal)
    //                    self.lblCompletiondetail.attributedText =  lineSpacing(string: (note.capitalizingFirstLetter()), lineSpacing: 7.0)
    //                }else{
    //                    self.btnAddNotes.setTitle(LanguageKey.add, for: .normal)
    //                    self.lblCompletiondetail.text = ""
    //                }
    //            }
    //            APP_Delegate.showBackButtonText()
    //            self.navigationController?.present(navCon, animated: true, completion: nil)
            }
            
            
            @IBAction func acceptBtn(_ sender: UIButton) {
    //            if isPermitForShow(permission: permissions.isJobRevisitOrNot) == false{
    //                self.requestForVisite.isHidden = false
    //                // let expence = SideMenuModel(id: 10, name: LanguageKey.title_appointments, subMenu: [], image: "Appointment", isCollaps: false)
    //                // menus.append(expence) // for Expence
    //            }else{
    //                self.requestForVisite.isHidden = true
    //            }
    //            LocationManager.shared.isHaveLocation()
    //
    //            let status : taskStatusType = taskStatusType(rawValue: sender.tag)!
    //
    //            if currentStatusID != String(status.rawValue) {
    //                if UserDefaults.standard.bool(forKey: "permission") {
    //                    statusId = status
    //                    showDateAndTimePicker()
    //                }else{
    //
    //                    if (sender.titleLabel!.text!.contains("Resume")) || (isHaveNetowork() == false){ // In case of 'Job Resume' and 'Travel Resume' not showing custom form on these two buttons
    //                        if currentStatusID != String(status.rawValue) {
    //                            self.ChangeButtonsAccordingToStatusType(status: status)
    //                        }
    //                        return
    //                    }
    //
    //                    let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
    //                        if(Int(obj.event!)! == status.rawValue) &&  (Int(obj.totalQues!)! != 0) {
    //                            return true
    //                        }else{
    //                            return false
    //                        }
    //                    }
    //
    //                    if(arrOFShowTabForm.count > 0){
    //                        let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
    //                        customFormVC.objOFTestVC = arrOFShowTabForm[0]
    //                        customFormVC.sltNaviCount = 0
    //                        customFormVC.isCameFrmStatusBtnClk = false
    //                        customFormVC.clickedEvent = status.rawValue
    //                        customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
    //
    //                        customFormVC.callBackFofDetailJob = { (success) in
    //                            if(success){
    //                                self.ChangeButtonsAccordingToStatusType(status: status)
    //                            }
    //
    //                        }
    //                        self.navigationController?.navigationBar.topItem?.title = " "
    //                        self.navigationController?.pushViewController(customFormVC, animated: true)
    //                    }else{
    //
    //                        if currentStatusID != String(status.rawValue) {
    //                            self.ChangeButtonsAccordingToStatusType(status: status)
    //                        }
    //                    }
    //
    //                }
    //            }
                
            }
            
            
    //        func ChangeButtonsAccordingToStatusType(status : taskStatusType){
    //
    //            if !isFirst{
    //                if status == taskStatusType.InProgress{
    //                    for job in jobArray {
    //                        if job.status == String(taskStatusType.InProgress.rawValue){
    //                            job.status = String(taskStatusType.OnHold.rawValue)
    //                            job.updateDate = getCurrentTimeStamp()
    //                        }
    //                    }
    //                }
    //
    //
    //                if ((status.rawValue != taskStatusType.Reject.rawValue) &&
    //                    (status.rawValue != taskStatusType.Cancel.rawValue))
    //                {
    //                    changeJobStatus(statusId: status.rawValue, job: objOfUserJobListInDetail!)
    //                    objOfUserJobListInDetail?.status = String(status.rawValue)
    //                    objOfUserJobListInDetail?.updateDate = getCurrentTimeStamp()
    //                    DatabaseClass.shared.saveEntity(callback: { _ in })
    //                }
    //            }
    //
    //
    //
    //            if ((status.rawValue != taskStatusType.Reject.rawValue) &&
    //                (status.rawValue != taskStatusType.Cancel.rawValue) )
    //            {
    //
    //                // let status1 : String = String(describing: status)
    //                let priorityDetail = taskStatus(taskType: status)
    //                let statusName = priorityDetail.0.replacingOccurrences(of: " Task", with: "")
    //                imgStatus.image = priorityDetail.1
    //                lblTaskStatus.text = statusName
    //
    //                if !isFirst {
    //                    // timeLbl.text = CurrentTime()
    //                }
    //            }else{
    //                if isFirst{
    //                    statusViewEnable(isEnable: false)
    //                    return
    //                }
    //            }
    //
    //            switch status {
    //
    //            //-----------------------------------------------------------------------
    //            case .New:
    //                // print("Not started")
    //
    //
    //                statusViewEnable(isEnable: false)
    //
    //                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width)
    //
    //                ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x, width_constant: rectDeclineBtn.size.width)
    //
    //                acceptBtn.tag = taskStatusType.Accepted.rawValue
    //                self.acceptBtn.setTitle("Accept", for: .normal)
    //
    //                declineBtn.tag = taskStatusType.Reject.rawValue
    //                self.declineBtn.setTitle("Reject", for: .normal)
    //
    //                break
    //
    //            //-----------------------------------------------------------------------
    //            case .Accepted :
    //
    //                statusViewEnable(isEnable: true)
    //                contactDetailViewHeight.constant = 80.0
    //                topViewConnect.constant = 2.0
    //
    //                if getDefaultSettings()?.isHideTravelBtn == "1"{
    //                    ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
    //                    acceptBtn.tag = taskStatusType.InProgress.rawValue
    //                    self.acceptBtn.setTitle("Job Start", for: .normal)
    //                }else{
    //                    ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
    //                    acceptBtn.tag = taskStatusType.Travelling.rawValue
    //                    self.acceptBtn.setTitle("Travel Start", for: .normal)
    //                    if isPermitForShow(permission: permissions.isJobRevisitOrNot) == false{
    //                        self.requestForVisite.isHidden = false
    //                        // let expence = SideMenuModel(id: 10, name: LanguageKey.title_appointments, subMenu: [], image: "Appointment", isCollaps: false)
    //                        // menus.append(expence) // for Expence
    //                    }else{
    //                        self.requestForVisite.isHidden = true
    //
    //                    }
    //                }
    //
    //
    //
    //
    //
    //
    //                break
    //
    //            //-----------------------------------------------------------------------
    //            case .Reject:
    //
    //                ShowAlert(title: LanguageKey.reject, message: AlertMessage.rejectJob, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.reject as NSString, style: .alert, callback: { (Cancel, ok) in
    //                    if ok {
    //
    //                        //delete this job
    //                        // print("status change = Reject")
    //                        self.changeJobStatus(statusId: status.rawValue, job: self.objOfUserJobListInDetail!)
    //                        ChatManager.shared.removeJobForChat(jobId: self.objOfUserJobListInDetail!.jobId!)
    //                        DatabaseClass.shared.deleteEntity(object: self.objOfUserJobListInDetail!, callback: { (isDelete : Bool) in
    //                            if (self.callbackDetailVC != nil){
    //                                self.callbackDetailVC!(true, self.objOfUserJobListInDetail!)
    //                            }
    //                        })
    //                    }
    //                })
    //
    //                break
    //            //-----------------------------------------------------------------------
    //            case .Cancel:
    //                //print("Not started")
    //                self.requestForVisite.isHidden = true
    //                self.rescheduleBtn.isHidden = true
    //                ShowAlert(title: LanguageKey.cancel, message: AlertMessage.cancelJob , controller: windowController, cancelButton: LanguageKey.no as NSString, okButton: LanguageKey.yes as NSString, style: .alert, callback: { (Cancel, ok) in
    //                    if ok {
    //
    //                        //delete this job
    //                        //print("status change = Cancel")
    //                        self.changeJobStatus(statusId: status.rawValue, job: self.objOfUserJobListInDetail!)
    //                        ChatManager.shared.removeJobForChat(jobId: self.objOfUserJobListInDetail!.jobId!)
    //                        DatabaseClass.shared.deleteEntity(object: self.objOfUserJobListInDetail!, callback: { (isDelete : Bool) in
    //                            if (self.callbackDetailVC != nil){
    //                                self.callbackDetailVC!(true, self.objOfUserJobListInDetail! )
    //                            }
    //                        })
    //                        self.requestForVisite.isHidden = true
    //                        self.rescheduleBtn.isHidden = true
    //                    }
    //                })
    //
    //
    //
    //                break
    //
    //
    //            //-----------------------------------------------------------------------
    //            case .Travelling :
    //
    //                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width - 30)
    //
    //                ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x - 30, width_constant: rectDeclineBtn.size.width + 30)
    //
    //                acceptBtn.tag = taskStatusType.Break.rawValue
    //                self.acceptBtn.setTitle("Break", for: .normal)
    //
    //                declineBtn.tag = taskStatusType.InProgress.rawValue
    //                self.declineBtn.setTitle("Travel Finish & Job Start", for: .normal)
    //
    //                //self.buttonsDisable(isDisable: false)
    //
    //                detailDatePicker.isHidden = true
    //                pickerTabView.isHidden = true
    //                hideBackgroundView()
    //
    //                break
    //
    //            //-----------------------------------------------------------------------
    //            case .Break:
    //
    //                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width - 30)
    //
    //                ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x - 30, width_constant: rectDeclineBtn.size.width + 30)
    //
    //                acceptBtn.tag = taskStatusType.Travelling.rawValue
    //                self.acceptBtn.setTitle("Travel Resume", for: .normal)
    //
    //                declineBtn.tag = taskStatusType.InProgress.rawValue
    //                self.declineBtn.setTitle("Travel Finish & Job Start", for: .normal)
    //
    //                //self.buttonsDisable(isDisable: true)
    //
    //                break
    //
    //            //-----------------------------------------------------------------------
    //            case .InProgress:
    //
    //                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width)
    //
    //                ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x, width_constant: rectDeclineBtn.size.width)
    //
    //                acceptBtn.tag = taskStatusType.OnHold.rawValue
    //                self.acceptBtn.setTitle("On Hold", for: .normal)
    //
    //                declineBtn.tag = taskStatusType.Completed.rawValue
    //                self.declineBtn.setTitle("Job Finish", for: .normal)
    //
    //
    //
    //                // self.buttonsDisable(isDisable: false)
    //
    //                break
    //
    //            //-----------------------------------------------------------------------
    //            case .Completed :
    //
    //                ButtonAnimator(animationOnButton: acceptBtn, x_space:  rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
    //
    //                statusViewEnable(isEnable: false)
    //
    //                self.acceptBtn.setTitle("Completed", for: .normal)
    //                self.acceptBtn.backgroundColor = UIColor.init(red: 115.0/255.0, green: 216.0/255.0, blue: 21.0/255.0, alpha: 1.0)
    //                self.acceptBtn.isUserInteractionEnabled = false
    //                self.declineBtn.isUserInteractionEnabled = false
    //                self.btnStatusType.isUserInteractionEnabled = false
    //
    //                statusTwoButtons_H.constant =  10.0
    //                //UIView.animate(withDuration: 0.0) {
    //                self.view.layoutIfNeeded()
    //                // }
    //
    //                // lblStatus.textColor = UIColor.init(red: 115.0/255.0, green: 216.0/255.0, blue: 21.0/255.0, alpha: 1.0)
    //
    //                //self.navigationController?.popViewController(animated: true)
    //
    //                // self.firstViewHeightConstrant.constant = 155
    //                isComplite = false
    //                self.requestForVisite.isHidden = false
    //
    //                // self.rescheduleBtn.isHidden = true
    //                break
    //
    //
    //            //-----------------------------------------------------------------------
    //            case .OnHold:
    //
    //                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width)
    //
    //                ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x, width_constant: rectDeclineBtn.size.width)
    //
    //                acceptBtn.tag = taskStatusType.InProgress.rawValue
    //                self.acceptBtn.setTitle("Job Resume", for: .normal)
    //
    //                declineBtn.tag = taskStatusType.Completed.rawValue
    //                self.declineBtn.setTitle("Job Finish", for: .normal)
    //
    //                break
    //            //-----------------------------------------------------------------------
    //            case .Closed:
    //                print("do something when third button is tapped")
    //                break
    //
    //
    //            default:
    //                print("default")
    //            }
    //        }
            
            
            func statusViewEnable(isEnable : Bool) -> Void {
                H_statusVw.constant = isEnable ? 50.0 : 0.0
                // H_statusVwBottom.constant = isEnable ? 4.0 : 0.0
                UIView.animate(withDuration:isFirst ? 0.0 : 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
            
            
            //    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
            //        if identifier == "MapVC" {
            //
            //
            //        }
            //        return true
            //    }
            //
            //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            //         if segue.identifier == "MapVC"{
            //            let mapVw = segue.destination as! MapVC
            //
            //            if objOfUserJobListInDetail?.lat == nil && objOfUserJobListInDetail?.lng == nil ||  objOfUserJobListInDetail?.lat == "" && objOfUserJobListInDetail?.lng == ""  {
            //                mapVw.lattitude = jobLocation.latitude.description
            //                mapVw.longitude = jobLocation.longitude.description
            //            } else {
            //                mapVw.lattitude = objOfUserJobListInDetail?.lat
            //                mapVw.longitude = objOfUserJobListInDetail?.lng
            //            }
            //             mapVw.address = locationTxtView.text
            //        }
            //    }
            
            //MARK:- Convert Address to Latitude and longitude
            
            func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(address) { (placemarks, error) in
                    
                    if let location = placemarks?.first?.location?.coordinate  {
                        completion(location)
                    }
                    else {
                        ShowError(message: AlertMessage.locationNotAvailable , controller: self)
                        return
                    }
                }
            }
            
            
            // ================================
            // MARK: Button Functionality
            //================================
            
            @IBAction func btnMap_Action(_ sender: Any) {
                
                if (objOfUserJobListInDetail?.lat == nil && objOfUserJobListInDetail?.lng == nil) ||  (objOfUserJobListInDetail?.lat == "" && objOfUserJobListInDetail?.lng == "")  {
                    
                    if (locationTxtView.text != nil && locationTxtView.text != "")  {
                        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
                            openGoogleMap(latitude: "", longitude: "",locationAddress: self.locationTxtView.text)
                        } else  {
                            openAppleMap(lat: "", long: "", locationAddress: self.locationTxtView.text)
                        }
                    } else {
                        ShowError(message: AlertMessage.locationNotAvailable , controller: self)
                    }
                    
                } else {
                    if objOfUserJobListInDetail?.lat != "" && objOfUserJobListInDetail?.lng != ""  {
                        if  UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
                            openGoogleMap(latitude: objOfUserJobListInDetail!.lat!, longitude: objOfUserJobListInDetail!.lng!)
                        } else  {
                            openAppleMap(lat: objOfUserJobListInDetail!.lat!, long: objOfUserJobListInDetail!.lng!)
                        }
                    } else {
                        ShowError(message: AlertMessage.locationNotAvailable , controller: self)
                    }
                }
            }
            
            
            func openAppleMap(lat: String?,long: String?,locationAddress: String = ""){
                
                var components = URLComponents()
                components.scheme = "https"
                components.host = "maps.apple.com"
                components.path = "/"
                
                if locationAddress == "" {
                    components.queryItems = [
                        // URLQueryItem(name: "saddr", value: "\(curruntlat),\(curruntlong)"),
                        URLQueryItem(name: "daddr", value: "\(lat?.description ?? ""),\(long?.description ?? "")"),
                    ]
                } else {
                    components.queryItems = [
                        // URLQueryItem(name: "saddr", value: "\(curruntlat),\(curruntlong)"),
                        URLQueryItem(name: "daddr", value: locationAddress),
                    ]
                }
                
                // Getting a URL from our components is as simple as
                let ur1l = components.url
                guard let url = ur1l else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
            
            func openGoogleMap(latitude: String?,longitude:String?, locationAddress : String = "") {
                
                if locationAddress == "" {
                    
                    let directionsRequest: String = "comgooglemaps://" + "?daddr=\(latitude ?? ""),\(longitude ?? "")" + "&x-success=sourceapp://?resume=true&x-source=AirApp"
                    
                    //    let strUrl = String(format: "comgooglemaps://?saddr=%@,%@&daddr=%@,%@&directionsmode=driving&zoom=14&views=traffic", lat, long, latitude ?? "", longitude ?? "")
                    
                    guard let url = URL(string: directionsRequest) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                } else {
                    if let address = locationAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                        let directionsRequest: String = "comgooglemaps://" + "?daddr=\(address)" + "&x-success=sourceapp://?resume=true&x-source=AirApp"
                        //    let strUrl = String(format: "comgooglemaps://?saddr=%@,%@&daddr=%@&directionsmode=driving&zoom=14&views=traffic", lat, long, address)
                        
                        let directionsURL: NSURL = NSURL(string: directionsRequest)!
                        let application:UIApplication = UIApplication.shared
                        if (application.canOpenURL(directionsURL as URL)) {
                            application.open(directionsURL as URL, options: [:], completionHandler: nil)
                        }
                    }
                }
                
            }
            
            @IBAction func tapOnBackgrounVw(_ sender: Any) {
                hideBackgroundView()
                detailDatePicker.isHidden = true
                pickerTabView.isHidden = true
            }
            
            
            @IBAction func detailDecriptionViewBtn(_ sender: Any) {
                //        if objOfUserJobListInDetail?.des == nil || objOfUserJobListInDetail?.des == "" {
                //            ShowError(message: AlertMessage.descriptionNotAvailable , controller: self)
                //            return
                //        }
                //
                //        showBackgroundView()
                //        textDescriptionView.text = objOfUserJobListInDetail?.des?.capitalizingFirstLetter()
                //        textDescriptionView.textContainerInset = UIEdgeInsets.init(top: 8,left: 5,bottom: 8,right: 8); // top, left, bottom, right
                //        view.addSubview(descriptionView)
                //        descriptionView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
                //        descriptionHeadingLbl.text = LanguageKey.description
                //        if objOfUserJobListInDetail?.des == nil || objOfUserJobListInDetail?.des == "" {
                //        ShowError(message: AlertMessage.descriptionNotAvailable , controller: self)
                //        return
                //        }
                //        // HTMLImageCorrector(HTMLString: (objOfUserJobListInDetail?.des)!)
                //        showBackgroundView()
                //
                //        DispatchQueue.global(qos: .background).async {
                //        let htmlString = self.objOfUserJobListInDetail?.des
                //        let attributedString = htmlString!.htmlToAttributedString
                //        DispatchQueue.main.async {
                //        self.desTextView.attributedText = attributedString
                //        print("Successfully converted string to HTML")
                //        }
                //        }
                //        //textDescriptionView.text = objOfUserJobListInDetail?.des?.capitalizingFirstLetter()
                //        textDescriptionView.textContainerInset = UIEdgeInsets.init(top: 8,left: 5,bottom: 8,right: 8); // top, left, bottom, right
                //        view.addSubview(descriptionView)
                //        descriptionView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
                //        descriptionHeadingLbl.text = LanguageKey.description
                
            }
            
            
            @IBAction func detailInstructionViewBtn(_ sender: Any) {
                if objOfUserJobListInDetail?.inst == nil || objOfUserJobListInDetail?.inst == "" {
                    ShowError(message: AlertMessage.instructionNotAvailable, controller: self)
                    return
                }
                showBackgroundView()
                textDescriptionView.text = objOfUserJobListInDetail?.inst?.capitalizingFirstLetter()
                textDescriptionView.textContainerInset = UIEdgeInsets.init(top: 8,left: 5,bottom: 8,right: 8); // top, left, bottom, right
                view.addSubview(descriptionView)
                descriptionView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
                descriptionHeadingLbl.text = LanguageKey.instr
            }
            
            
            @IBAction func closeDetailBtn(_ sender: Any) {
                hideBackgroundView()
            }
            
            @IBAction func emailBtn(_ sender: Any) {
                if objOfUserJobListInDetail?.email == nil || objOfUserJobListInDetail?.email == "" {
                    ShowError(message: AlertMessage.emailNotAvailable, controller: self)
                    return
                }
                
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    APP_Delegate.showBackButtonText()
                    self.present(mailComposeViewController, animated: true, completion: nil)
                }
            }
            
            @IBAction func chatBtn(_ sender: Any) {
    //            if ((objOfUserJobListInDetail?.skype == "") && (objOfUserJobListInDetail?.twitter == "") && (objOfUserJobListInDetail?.skype == nil) && (objOfUserJobListInDetail?.skype == nil)) {
    //                ShowError(message: AlertMessage.chatNotAvailable, controller: windowController)
    //                return
    //            }
                
                showBackgroundView()
                view.addSubview(chatView)
                chatView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
            }
            
            @IBAction func closeChatViewBtn(_ sender: Any) {
                hideBackgroundView()
            }
            
            @IBAction func callBtn(_ sender: Any) {
                
                if ((objOfUserJobListInDetail?.mob1 == "") && (objOfUserJobListInDetail?.mob2 == "")) {
                    ShowError(message: AlertMessage.contactNotAvailable , controller: windowController)
                    return
                }
                
                
                showBackgroundView()
                view.addSubview(contactNoView)
                contactNoView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
            }
            
            @IBAction func closeCallBtn(_ sender: Any) {
                hideBackgroundView()
            }
            
            
            @IBAction func callButtonPressed(_ sender: UIButton) {
                if sender.titleLabel?.text != LanguageKey.not_available{
                    callNumber(phoneNumber: (sender.titleLabel?.text)!)
                    hideBackgroundView()
                }
            }
            
            @IBAction func twitterBtn(_ sender: Any) {
                
                
                if(self.lbl_TwitterId.text != LanguageKey.not_available){
                    if (chatView != nil) {
                        hideBackgroundView()
                    }
                    let installed = UIApplication.shared.canOpenURL(NSURL(string: "twitter:")! as URL)
                    if installed {
                        
                        if self.lbl_TwitterId.text.count > 0 {
                            let str = String(format: "twitter://user?id=%@", self.lbl_TwitterId.text)
                            let urlString = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            UIApplication.shared.open(URL(string: urlString!)!, options: [:], completionHandler: nil)
                        }
                    } else {
                        
                        ShowError(message: AlertMessage.twitterApp , controller: windowController)
                    }
                }
                
            }
            
            @IBAction func skypeBtn(_ sender: Any) {
                if(self.lbl_SkypeId.text != LanguageKey.not_available){
                    if (chatView != nil) {
                        hideBackgroundView()
                    }
                    let installed = UIApplication.shared.canOpenURL(NSURL(string: "skype:")! as URL)
                    if installed {
                        
                        if self.lbl_SkypeId.text.count > 0 {
                            let str = String(format: "skype:%@?chat", self.lbl_SkypeId.text)
                            let urlString = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            UIApplication.shared.open(URL(string: urlString!)!, options: [:], completionHandler: nil)
                        }
                    } else {
                        
                        ShowError(message: AlertMessage.skypeApp , controller: windowController)
                    }
                }
                
            }
            
            func ButtonAnimator(animationOnButton: UIButton, x_space : CGFloat, width_constant : CGFloat) -> Void {
                animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                    animationOnButton.frame = CGRect(x: x_space, y: animationOnButton.frame.origin.y, width: width_constant , height: animationOnButton.frame.size.height)
                }); animator.startAnimation()
            }
            
            
            //================================
            // MARK: Swipe Functionality
            //================================
            
            func swipe() {
                let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
                swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                self.view.addGestureRecognizer(swipeRight)
                
                let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
                swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                self.view.addGestureRecognizer(swipeLeft)
                
                // Do any additional setup after loading the view.
            }
            
            
            func buttonsDisable(isDisable : Bool) -> Void {
                if isDisable {
                    self.mapBtn.isUserInteractionEnabled = false
                    self.viewBtn.isUserInteractionEnabled = false
                    self.socialBtn.isUserInteractionEnabled = false
                    self.mailBtn.isUserInteractionEnabled = false
                    self.callBtn.isUserInteractionEnabled = false
                    self.btnInstructionView.isUserInteractionEnabled = false
                    
                    self.mapBtn.alpha = 0.5
                    self.viewBtn.alpha = 0.5
                    self.socialBtn.alpha = 0.5
                    self.mailBtn.alpha = 0.5
                    self.callBtn.alpha = 0.5
                    self.btnInstructionView.alpha = 0.5
                }else{
                    self.mapBtn.isUserInteractionEnabled = true
                    self.viewBtn.isUserInteractionEnabled = true
                    self.socialBtn.isUserInteractionEnabled = true
                    self.mailBtn.isUserInteractionEnabled = true
                    self.callBtn.isUserInteractionEnabled = true
                    self.btnInstructionView.isUserInteractionEnabled = true
                    
                    self.mapBtn.alpha = 1.0
                    self.viewBtn.alpha = 1.0
                    self.socialBtn.alpha = 1.0
                    self.mailBtn.alpha = 1.0
                    self.callBtn.alpha = 1.0
                    self.btnInstructionView.alpha = 1.0
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
                
                if (contactNoView != nil) {
                    contactNoView.removeFromSuperview()
                }
                
                if (descriptionView != nil) {
                    descriptionView.removeFromSuperview()
                }
                
                if (chatView != nil) {
                    chatView.removeFromSuperview()
                }
                
                self.backgroundView.isHidden = true
                self.backgroundView.backgroundColor = UIColor.clear
                self.backgroundView.alpha = 1
            }
            
            //    func showOnExternalMap() -> Void {
            //        var components = URLComponents()
            //        components.scheme = "https"
            //        components.host = "maps.apple.com"
            //        components.path = "/"
            //        components.queryItems = [
            //            URLQueryItem(name: "saddr", value: address),
            //            URLQueryItem(name: "daddr", value: "Jain Son Kirana Store, 110,Dr. Ambedkar Nagar, Indore, Madhya Pradesh 452001"),
            //            // URLQueryItem(name: "&dirflg", value: "r")
            //        ]
            //        // Getting a URL from our components is as simple as
            //        let ur1l = components.url
            //        guard let url = ur1l else {
            //            return
            //        }
            //        if #available(iOS 10.0, *) {
            //            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //        } else {
            //            UIApplication.shared.openURL(url)
            //        }
            //    }
            
            
            //================================
            // MARK: Email Functionality
            // ================================
            
            func configuredMailComposeViewController() -> MFMailComposeViewController {
                APP_Delegate.showBackButtonText()
                
                let mailComposerVC = MFMailComposeViewController()
                mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
                // print((objOfUserJobListInDetail?.email)!)
                mailComposerVC.setToRecipients([(objOfUserJobListInDetail?.email)!])
                mailComposerVC.setCcRecipients([])
                mailComposerVC.setBccRecipients([])
                if #available(iOS 11.0, *) {
                    mailComposerVC.setPreferredSendingEmailAddress("abc@xyz.com")
                } else {
                    // Fallback on earlier versions
                }
                return mailComposerVC
            }
            
            
            // MARK: MFMailComposeViewControllerDelegate Method
            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                
                switch result {
                case .cancelled:
                    print("Mail cancelled")
                case .saved:
                    print("Mail saved")
                case .sent:
                    print("Mail sent")
                    ShowError(message: AlertMessage.mailSend, controller: windowController)
                case .failed:
                    print("Mail sent failure: \(error?.localizedDescription ?? "")")
                default:
                    break
                }
                
                
                
                controller.dismiss(animated: true, completion: {
                    APP_Delegate.hideBackButtonText()
                })
            }
            
            
            // ================================
            //  MARK: Displaying Mobile No.
            // ================================
            private func callNumber(phoneNumber:String) {
                if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
                    
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL)) {
                        application.open(phoneCallURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                }
            }
            
            //    // ================================
            //    //  MARK: Moving FirstView Up
            //    // ================================
            //    func viewToTop() {
            //        if self.firstViewHeightConstrant.constant == 185.0 {
            //            self.firstViewHeightConstrant.constant = 155.0
            //            UIView.animate(withDuration: 0.5) {
            //                self.view.layoutIfNeeded()
            //            }
            //        }else{
            //            self.firstViewHeightConstrant.constant = 0.0
            //            UIView.animate(withDuration: 0.5) {
            //                self.view.layoutIfNeeded()
            //            }
            //        }
            //    }
            
            // ================================
            //  MARK: Open Drop Down
            // ================================
            func openDwopDown() {
                
                if (optionalVw == nil){
                    self.backgroundView.isHidden = false
                    self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
                    let sltTxtfldFrm = statusVw.convert(statusVw.bounds, from: self.view)
                    self.optionalVw?.setUpMethod(frame: CGRect(x: 20, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height-5), width: self.view.frame.size.width - 40, height: 150))
                  //  self.optionalVw?.delegate = self
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
            
            func removeOptionalView(){
                if optionalVw != nil {
                    self.backgroundView.isHidden = true
                    self.optionalVw?.removeFromSuperview()
                    self.optionalVw = nil
                }
            }
            
            
            //====================================================
            //MARK:- OptionView Delegate Methods
            //====================================================
    //        func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //            var LangArray  = ["\(self.Reject)","\(self.Cancel)","\(self.InProgress)","\(self.OnHold)","\(self.Completed)"]
    //            return LangArray.count
    //        }
    //
    //        func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //            var cell = tableView.dequeueReusableCell(withIdentifier:"cell")
    //            if(cell == nil){
    //                cell = UITableViewCell.init(style: .default, reuseIdentifier:"cell")
    //            }
    //            var LangArray  = ["\(self.Reject)","\(self.Cancel)","\(self.InProgress)","\(self.OnHold)","\(self.Completed)"]
    //            let status : String = String(describing: LangArray[indexPath.row])
    //            cell?.textLabel?.text = status.capitalizingFirstLetter()
    //            cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
    //            cell?.backgroundColor = .clear
    //            //cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
    //            cell?.textLabel?.textColor = UIColor.darkGray
    //
    //            return cell!
    //        }
    //
    //
    //        func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //            self.removeOptionalView()
    //
    //            LocationManager.shared.isHaveLocation()
    //            let status : taskStatusType = arrTypeStatus[indexPath.row]
    //
    //            if currentStatusID != String(status.rawValue) {
    //                if UserDefaults.standard.bool(forKey: "permission") {
    //                    statusId = status
    //                    showDateAndTimePicker()
    //                }else{
    //
    //                    if isHaveNetowork() ==  false {
    //                        if currentStatusID != String(status.rawValue) {
    //                            ChangeButtonsAccordingToStatusType(status: arrTypeStatus[indexPath.row])
    //                        }
    //                        return
    //                    }
    //
    //
    //
    //                    let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
    //                        if(Int(obj.event!)! == status.rawValue &&  (Int(obj.totalQues!)! != 0)){
    //                            return true
    //                        }else{
    //                            return false
    //                        }
    //                    }
    //                    if(arrOFShowTabForm.count > 0){
    //                        let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
    //                        customFormVC.objOFTestVC = arrOFShowTabForm[0]
    //                        customFormVC.sltNaviCount = 0
    //                        customFormVC.isCameFrmStatusBtnClk = false
    //                        customFormVC.clickedEvent = status.rawValue
    //                        customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
    //
    //                        customFormVC.callBackFofDetailJob = { (success) in
    //                            if(success){
    //                                self.ChangeButtonsAccordingToStatusType(status:  self.arrTypeStatus[indexPath.row])
    //                            }
    //
    //                        }
    //                        self.navigationController?.navigationBar.topItem?.title = " "
    //                        self.navigationController?.pushViewController(customFormVC, animated: true)
    //                    }else{
    //
    //                        if currentStatusID != String(status.rawValue) {
    //                            ChangeButtonsAccordingToStatusType(status: arrTypeStatus[indexPath.row])
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //
    //
    //        func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //            return 38.0
    //        }
            
            
            func changeJobStatus(statusId : Int, job : UserJobList){
                if(job.jobId == nil){
                    return
                }
                //Change currentid variable
                currentStatusID = String(statusId)
                
                
                
                if LocationManager.shared.isCheckLocation() {
                    self.updateStatusOnServer(lat: "\(LocationManager.shared.currentLattitude)", lon: "\(LocationManager.shared.currentLongitude)", statusId: statusId, job: job)
                }else{
                    updateStatusOnServer(lat: "0.0", lon: "0.0", statusId: statusId, job: job)
                }
            }
            
            func updateStatusOnServer(lat:String,lon:String, statusId : Int, job : UserJobList) -> Void {
                let param = Params()
                param.jobId = job.jobId
                param.usrId = getUserDetails()?.usrId
                param.type = job.type
                param.status =   String(format: "%d",statusId)
                param.lat = lat
                param.lng = lon
                param.device_Type = "2"
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
                formatter.timeZone = TimeZone.current
                formatter.locale = Locale(identifier: "en_US")
                let strDate = formatter.string(from: Date())
                
                //=====================================================converttimezone
                var converTimeZone = ""

                if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
                    if isAutoTimeZone == "0"{
                        converTimeZone = strDate
                    }else{
                        let timeZoneDemo11 = strDate
                       converTimeZone = convertTimeZoneForAllDateTime(dateStr: timeZoneDemo11, dateFormate: formatter.dateFormat) ?? ""
                    }
                }
                //=====================================================converttimezone
                
                param.dateTime = self.sltDate != "" ? self.sltDate : converTimeZone
                self.sltDate = ""
                
                //Save data in OFFLINELIST entity
                let ladksj = job.jobId?.components(separatedBy: "-")
                if ladksj!.count > 0 {
                    let tempId = ladksj?[0]
                    if tempId == "Job" {
                        let dict = param.toDictionary
                        let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineJob") as! OfflineJob
                        userJobs.apis = Service.addItemOnJob
                        userJobs.parametres = dict?.toString
                        // print(dict)
                        userJobs.time = Date()
                        
                        DatabaseClass.shared.saveEntity(callback: {_ in
                            DatabaseClass.shared.syncDatabase()
                            
                        })
                    } else {
                        DatabaseClass.shared.saveOffline(service: Service.changeJobStatus, param: param)
                    }
                }
            }
            
            
            
            @IBAction func pickerBtn(_ sender: UIButton) {
                if sender.tag == 0{
                    let dateFormmater = DateFormatter()
                    dateFormmater.dateFormat = "dd-MM-yyyy hh:mm:ss a"
                    dateFormmater.timeZone = TimeZone.current
                    dateFormmater.locale = Locale(identifier: "en_US")
                    sltDate = dateFormmater.string(from: detailDatePicker.date)
                    
                    detailDatePicker.isHidden = true
                    pickerTabView.isHidden = true
                    hideBackgroundView()
                   // ChangeButtonsAccordingToStatusType(status: statusId!)
                }else{
                    detailDatePicker.isHidden = true
                    pickerTabView.isHidden = true
                    hideBackgroundView()
                }
            }
            
            
            func showDateAndTimePicker(){
                showBackgroundView()
                pickerTabView.isHidden = false
                detailDatePicker.isHidden = false
                detailDatePicker?.backgroundColor = UIColor.white
            }
            
            
            
            //================================
            //  MARK: getFormName
            //================================
            /*
             compId -> Company id
             limit -> limit
             index -> index value
             search -> search value
             dateTime -> date time
             
             compId -> Company id
             limit -> limit
             index -> index value
             search -> search value
             dateTime -> date time
             jobId-> job id
             jtId ->job title array ("jtId":[{"jtId":"26","title":"plumbing","labour":""}]})
             */
            
            //    func getFormName(){
            //
            //        let param = Params()
            //        param.compId = getUserDetails()?.compId
            //        param.limit = "120"
            //        param.index = "0"
            //        param.search = ""
            //        param.dateTime = ""
            //        param.jobId = objOfUserJobListInDetail?.jobId
            //
            //        var arrOFjit_Id = [jtIdParam]()
            //        for jtid in (objOfUserJobListInDetail?.jtId as! [AnyObject]) {
            //             let jitIdObj = jtIdParam()
            //            jitIdObj.jtId = (jtid as! [String:String])["jtId"]!
            //            jitIdObj.title = (jtid as! [String:String])["title"]!
            //            arrOFjit_Id.append(jitIdObj)
            //
            //        }
            //        param.jtId = arrOFjit_Id
            //
            //        var dict =  param.toDictionary
            //        var ids = [String]()
            //        let titles : [[String : String]] = dict!["jtId"] as! [[String : String]]
            //
            //        for title in titles {
            //            ids.append(title["jtId"]!)
            //        }
            //        dict!["jtId"] = ids
            //
            //
            //        serverCommunicator(url: Service.getCustomFormNmList, param: dict) { (response, success) in
            //            if(success){
            //                let decoder = JSONDecoder()
            //
            //                if let decodedData = try? decoder.decode(TestRes.self, from: response as! Data) {
            //
            //                    if decodedData.success == true{
            //
            //                        if decodedData.data.count > 0 {
            //                            //
            //                            DispatchQueue.main.async {
            //                               APP_Delegate.arrOFCustomForm = decodedData.data
            //                               // self.collection_View.reloadData()
            //                            }
            //
            //                        }else{
            ////                            if self.arrOfShowData.count == 0{
            ////                                DispatchQueue.main.async {
            ////                                   // self.collection_View.isHidden = true
            ////                                }
            ////                            }
            //                        }
            //                    }else{
            //                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
            //                    }
            //                }else{
            //                    ShowAlert(title: "formate problem", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertControllerStyle.alert, callback: {_,_ in})
            //                }
            //            }else{
            //                //ShowError(message: "Please try again!", controller: windowController)
            //            }
            //        }
            //    }
            
            //////////////////
            //===============================
            // MARK:- GetQuestionsList
            //===============================
            /*
             ansId -> Answer id
             parentId->parentId
             frmId-> form id
             usrId->user id
             jobId->job id
             
             */
            
    func getQuestionsByParentId(patmid:String){
        
        
        // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getQuestionsByParentId) as? String
        //  showLoader()
        let param = Params()
        param.ansId =  "-1"
        param.frmId = patmid
        // param.usrId = getUserDetails()?.usrId
        param.jobId = jobDetailHstry?.jobId //self.objOfUserJobListInDetail?.jobId
        
        serverCommunicator(url: Service.getQuestionsByParentId, param: param.toDictionary) { (response, success) in
            
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(getQuestionsByParent.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        if decodedData.data.count > 0 {
                            DispatchQueue.main.async {
                                // self.lbl_AlertMess.isHidden = true
                                //self.footerView.isHidden = false
                                
                                self.arr = decodedData.data as! [getQuestionsBy]
                                var ascs = self.arr
                                
                                
                                var strTitless = ""
                                var asc = self.arr
                                var strTitle = ""
                                for jtid in asc {
                                    let dare = jtid.des
                                    ///
                                    strTitless = strTitless + dare!
                                    //                                    for jtid in asc {
                                    let dares = jtid.ans
                                    
                                    if dares.count > 0 {
                                        for ans in dares {
                                            let ans1 = ans.value
                                            
                                            if strTitless == "" {
                                                strTitless = ans1 ?? ""
                                            }else{
                                                
                                                if let sss = Int(ans1 ?? ""){
                                                    if dare == "What" {
                                                        strTitless = "\(strTitless): \(ans1!)\n"
                                                        self.Strjhings = strTitless
                                                    }else{
                                                        
                                                        var ss = ""
                                                        
                                                        if dare == "jay" || dare == "dear"{
                                                            ss = DateFormate.dd_MMM_yyyy.rawValue
                                                            
                                                        }else{
                                                            ss =  DateFormate.hh_mm_a.rawValue
                                                        }
                                                        
                                                        let sssa =  timeStampToDateFormate(timeInterval:sss.description, dateFormate:ss)
                                                        strTitless = "\(strTitless): \(sssa)\n"
                                                        self.Strjhings = strTitless
                                                    }
                                                    
                                                    
                                                    
                                                }else{
                                                    strTitless = "\(strTitless): \(ans1 ?? "")\n"
                                                    self.Strjhings = strTitless
                                                }
                                                
                                            }
                                            
                                            print( ans1)
                                        }
                                    }else{
                                        strTitless = strTitless + ": \n"
                                    }
                                    
                                    
                                }
                                
                                
                                self.coustemFldDes.text = strTitless
                                //self.velueCoustomFld.text = self.Strjhings
                                print(self.coustemFldDes.text)
                                
                            }
                            
                        }else{
                            if self.arrOfShowData.count == 0{
                                DispatchQueue.main.async {
                                    // self.tableView.isHidden = true
                                    // self.lbl_AlertMess.isHidden = false
                                    // self.footerView.isHidden = true
                                }
                            }
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
     
            func getFormDetail(){
                
                //        if !isHaveNetowork() {
                //            if self.refreshControl.isRefreshing {
                //                self.refreshControl.endRefreshing()
                //            }
                //            return
                //        }
                // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getFormDetail) as? String
                
                let param = Params()
                
                param.frmId = ""
                param.type = "1"
                // param.dateTime = lastRequestTime ?? ""
                
                serverCommunicator(url: Service.getFormDetail, param: param.toDictionary) { (response, success) in
                    if(success){
                        let decoder = JSONDecoder()
                        
                        //                DispatchQueue.main.async {
                        //                    if self.refreshControl.isRefreshing {
                        //                        self.refreshControl.endRefreshing()
                        //                    }
                        //                }
                        
                        if let decodedData = try? decoder.decode(FormDetail.self, from: response as! Data) {
                            
                            if decodedData.success == true{
                                
                                //                            if decodedData.data.count > 0 {
                                //                                //
                                //                                DispatchQueue.main.async {
                                //
                                self.arrOfShowDatas = decodedData.data
                                
                                self.getQuestionsByParentId(patmid: decodedData.data.frmId!)
                                //                              //  self.table_View.reloadData()
                                //                                }
                                //
                                //                            }else{
                                //                                if self.arrOfShowData.count == 0{
                                //                                    DispatchQueue.main.async {
                                //                                      //  self.table_View.isHidden = true
                                //                                    }
                                //                                }
                                //                            }
                            }else{
                                ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            }
                        }else{
                            ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                        }
                    }else{
                        //ShowError(message: "Please try again!", controller: windowController)
                    }
                }
            }
            
            
            

            //==================================
            // MARK:- Equipement getJobDetail methods
            //==================================
            func getAuditDetail(){
                
                if !isHaveNetowork() {
                    // if self.refreshControl.isRefreshing {
                    //   self.refreshControl.endRefreshing()
                    // }
                    killLoader()
                    ShowError(message: AlertMessage.networkIssue, controller: windowController)
                    
                    return
                }
                
                showLoader()
                
                
                let param = Params()
                
                param.jobId = jobDetailHstry?.jobId
            //////////////jugal
                
                serverCommunicator(url: Service.getJobDetail, param: param.toDictionary) { (response, success) in
                    
                    
                    if(success){
                        let decoder = JSONDecoder()

                        if let decodedData = try? decoder.decode(EquipmentServiceData.self, from: response as! Data) {
                            if decodedData.success == true{
                                killLoader()
                          //  if decodedData.data!.count > 0 {
                            //    self.jobDetailServ = decodedData.data
                                self.objOfUserJobListInDetail = decodedData.data
                                //print(self.auditDetail?.kpr)
                                  DispatchQueue.main.async {
                                    self.setupMethod()
                                }

                            }else{
                                killLoader()
                            }
                        }else{
                            killLoader()
                            ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in

                                if cancel {
                                    showLoader()
                                    //  self.getAdminEquipementList()
                                }
                            })
                        }
                    }else{
                        killLoader()
                        ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                            if cancelButton {
                                showLoader()
                                // self.getAdminEquipementList()
                            }
                        })
                    }
                }
            }
            
            //////////////////
            
            //======================================================
            // MARK: Get ItemList Data
            //======================================================
                       
                       func getItemListRecord() {
                           
                           if !isHaveNetowork() {
                               //ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                              // if self.refreshControl.isRefreshing {
                                //   self.refreshControl.endRefreshing()
                              // }
                             //   setData()
                               return
                           }
                           
                          // showLoader()
                           let param = Params()
                           param.jobId = jobDetailHstry?.jobId
                          // param.invId = ""
                           
                           serverCommunicator(url: Service.getItemFromJob, param: param.toDictionary) { (response, success) in
                               killLoader()
    //                           DispatchQueue.main.async {
    //                               if self.refreshControl.isRefreshing {
    //                                   self.refreshControl.endRefreshing()
    //                               }
                              // }
                               if(success){
                                   let decoder = JSONDecoder()
                                   if let decodedData = try? decoder.decode(ItemGetListResList.self, from: response as! Data) {
                                       
                                       if decodedData.success == true{
                                        self.itemListDetail = decodedData.data as! [itemListInfoList]
                                          /// self.itemlistData = decodedData.data!
                   //                        taxCalculationType = (self.invoiceRes.data?.taxCalculationType)!
                                          //  self.replaceJobItemDataID(dict:  decodedData.data!)


                                                   
                                                       DispatchQueue.main.async{
                                                        //    self.setData()
                                                        //   self.arryCount.text = "\(self.loc_listItem) \(self.itemDetailedData.count)"
                                                           if decodedData.data?.count == 0{
                                                          //     self.showNoDataAlert()
                                                               self.tableView_H.constant = 0
                                                                self.tableView.isHidden = true
                                                           }else{
                                                               if decodedData.data?.count == 1 || decodedData.data?.count == 2 || decodedData.data?.count == 3{
                                                                   self.tableView_H.constant = 250
                                                               }
                                                             self.tableView.isHidden = false
                                                           //    self.hideNoDataAlert()
                                                           }
                                                           self.tableView.reloadData()
                                                          
                                                      
                                               }
                                      }else{
                                         //  self.setData()//
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
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemListDetail.count
                    }
        
             func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                  let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! ItemListEqupCell
                            let customFormDetals = itemListDetail[indexPath.row]
                cell.itemName.text = customFormDetals.inm //"asd"
                
                var qTY = LanguageKey.qty
                let qty =  customFormDetals.qty!
                cell.itemQty.text = "\(qTY): \(qty)"
                
               let pr = customFormDetals.rate
               cell.itemAmount.text = String(format: "%.2f", Float(pr  ?? "0.0") ?? 0.0)
              
                return cell
                
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
                self.attchCollView.isHidden = true
                 killLoader()
            }
            return
        }
        
        // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getDocumentsList) as? String
        showLoader()
        let param = Params()
        param.jobId = jobDetailHstry?.jobId
        param.usrId = getUserDetails()?.usrId
        
        serverCommunicator(url: Service.getDocumentsList, param: param.toDictionary) { (response, success) in
            killLoader()
            
//            DispatchQueue.main.async {
//                if self.refreshControl.isRefreshing {
//                    self.refreshControl.endRefreshing()
//                }
//            }
            
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(DocumentRes.self, from: response as! Data) {
                    DispatchQueue.main.async {
                       // self.lblAlertMess.isHidden = true
                    }
                    
                    if decodedData.success == true{
                        
                        if (decodedData.data?.count ?? 0) > 0 {
                            
                             self.arrOfShowDataAttch.removeAll()
                            
                            DispatchQueue.main.async {
                                
                                
                                let obj = decodedData.data![0]
                                if (obj.jobid != nil && obj.jobid != ""){ //Only For Remove job when Admin Unassign job for FW
                                    ShowAlert(title: "", message: AlertMessage.removeJobFromAdmin, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (isCancel, isOk) in
//                                        if(isCancel){
//                                            ChatManager.shared.removeJobForChat(jobId: obj.jobid!)
//                                            DatabaseClass.shared.deleteEntity(object: self.objOfUserJobListInDoc, callback: { (isDelete : Bool) in
//                                                if (self.callback != nil){
//                                                    self.callback!(true, self.objOfUserJobListInDoc)
//                                                }
//                                            })
//                                        }
                                    })
                                }else{
                                    self.attchCollView.isHidden = false
                                    self.arrOfShowDataAttch = decodedData.data!
                                    self.attchCollView.reloadData()
                                }
                                
                            }
                            
                        }else{
                            
                            DispatchQueue.main.async {
                                self.attechImg.isHidden = true
                                self.attechLbl.isHidden = true
                              //  self.lblAlertMess.isHidden = false
                                self.attechmntView_H.constant = 0
                                self.attchCollView.isHidden = true
                                
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
        
        }

        // Helper function inserted by Swift 4.2 migrator.
        fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
            return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
        }

        
        
extension JobDetailCltHstry: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.arrOfShowDataAttch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "docCell", for: indexPath as IndexPath) as! DocumentCell
        let docResDataDetailsObj =  self.arrOfShowDataAttch[indexPath.row]
        
        cell.lblName.text = docResDataDetailsObj.attachFileActualName
        imgName = cell.lblName.text ?? ""
        if let img = docResDataDetailsObj.attachThumnailFileName {
            let imageUrl = Service.BaseUrl + img
            cell.img.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: docResDataDetailsObj.image_name ?? "unknownDoc"))
        }else{
            cell.img.image = UIImage(named: "unknownDoc")
        }
        return cell
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let DocResDataDetailsObj = self.arrOfFilterData.count > 0 ? self.arrOfFilterData[indexPath.item] :  self.arrOfShowData[indexPath.item]
//
//
//        if DocResDataDetailsObj.type == "1" {
//            DispatchQueue.main.async {
//                if let fileUrl = URL(string: (Service.BaseUrl + DocResDataDetailsObj.attachFileName!)) {
//                    let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
//                        vc.name = trimString(string: DocResDataDetailsObj.attachFileActualName ?? "")
//                        vc.docUrl = fileUrl
//                        vc.isSignature = true
//                        self.navigationController!.pushViewController(vc, animated: true)
//                }
//            }
//             return
//        }
//
//
//
//
//        if let fileUrl = URL(string: (Service.BaseUrl + DocResDataDetailsObj.attachFileName!)) {
//            let customView = CustomDocView.instanceFromNib() as? CustomDocView
//            let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
//                backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
//
//            customView!.setupMethod(url: fileUrl, image: nil, imageName: DocResDataDetailsObj.attachFileActualName ?? "", imageDescription: DocResDataDetailsObj.des ?? "")
//                customView?.completionHandler = {(editedName,editedDes) in
//
//                    if DocResDataDetailsObj.des != editedDes {
//                        self.updateDocumentDescription(documentid: DocResDataDetailsObj.attachmentId!, documentDescription: editedDes) {
//                               DocResDataDetailsObj.des = editedDes
//                               DispatchQueue.main.async {
//                                    customView?.removeFromSuperview()
//                                    backgroundView.removeFromSuperview()
//                                }
//
//                           }
//                    }else{
//                        DispatchQueue.main.async {
//                            customView?.removeFromSuperview()
//                            backgroundView.removeFromSuperview()
//                        }
//                    }
//                }
//
//              let viewWidth = self.view.bounds.width
//              let viewHeight = self.view.bounds.height
//
//               customView!.frame = CGRect(x: (viewWidth/2-(customView!.bounds.width/2)), y: (viewHeight/2-(customView!.bounds.height/2)), width: customView!.bounds.width, height:  customView!.bounds.height)
//
//               self.view.addSubview(backgroundView)
//               self.view.addSubview(customView!)
//        }else{
//            ShowError(message: LanguageKey.format_problem, controller: windowController)
//        }
//
//
//
//
//    }
    
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
