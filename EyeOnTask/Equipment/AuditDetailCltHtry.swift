//
//  AuditDetailCltHtry.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 25/03/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit
import MessageUI
import ContactsUI
import CoreData

class AuditDetailCltHtry: UIViewController  , MFMailComposeViewControllerDelegate, OptionViewDelegate  {

    var auditDetailHstry : AuditHWorkHistry?
    
   
            @IBOutlet weak var Equipmnt_Hieght: NSLayoutConstraint!
            @IBOutlet weak var attechmnt_Img: UIImageView!
            
            @IBOutlet weak var equip_Img: UIImageView!
            @IBOutlet weak var accept_WrBtn: NSLayoutConstraint!
            
            @IBOutlet weak var H_fieldworkersView: NSLayoutConstraint!
            
            @IBOutlet weak var btnOkContact: UIButton!
            @IBOutlet weak var btnOkChat: UIButton!
            @IBOutlet weak var btbOkDescription: UIButton!
            @IBOutlet weak var btnCancelPicker: UIButton!
            @IBOutlet weak var btnDonePicker: UIButton!
            @IBOutlet weak var lblTags: UILabel!
            @IBOutlet weak var lblStart: UILabel!
            @IBOutlet weak var lblEnd: UILabel!
            
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
            
            @IBOutlet weak var tagsView: ASJTagsView!
            @IBOutlet weak var statusTwoButtons_H: NSLayoutConstraint!
            @IBOutlet var lbl_SkypeId: UITextView!
            @IBOutlet var lbl_TwitterId: UITextView!
            @IBOutlet var nameLbl: UILabel!
            @IBOutlet var jobCodeLbl: UILabel!
            @IBOutlet var titleLbl: UILabel!
            @IBOutlet var timeLbl: UILabel!
            @IBOutlet var priorityLbl: UILabel!
            @IBOutlet var locationLbl: UILabel!
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
            
            @IBOutlet weak var mailBtnWidth: NSLayoutConstraint!
            
            @IBOutlet weak var mailBtnHeight: NSLayoutConstraint!
            
            @IBOutlet weak var lblStartTime: UILabel!
            @IBOutlet weak var lblEndTime: UILabel!
            
            @IBOutlet weak var lblStartDate: UILabel!
            @IBOutlet weak var lblEndDate: UILabel!
            
            var callbackDetailVC: ((Bool,NSManagedObject) -> Void)?
            
            var optionalVw : OptionalView?
           // var jobArray = [AuditListData]()
       // var jobArray  : AllEquipment?
        
        var allEqpData : AuditDetailData?
           // var arrOfCustomForm = [TestDetails]()
            
            var arrTypeStatus : [taskStatusType] = [.Start, .OnHold, .Completed]
            
            @IBOutlet var firstViewHeightConstrant: NSLayoutConstraint!
        //    var auditDetail : AuditListData?
            var auditDetail : AuditDetailData?
            
            var isFirst = Bool()
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
            
            
            override func viewDidLoad() {
                super.viewDidLoad()
                
                getAuditDetail()
                /// jugal comnt by ----------------------------------------------------
    //            var someArray = [String]()
    //
    //            if auditDetail?.equArray == someArray as NSObject {
    //             self.equip_Img.isHidden = true
    //                 self.Equipmnt_Hieght.constant = 0
    //
    //                     }else{
    //                 self.Equipmnt_Hieght.constant = 14
    //                 self.equip_Img.isHidden = false
    //                 self.equip_Img.image =  UIImage.init(named: "equip")
    //             }
    //
    //            if auditDetail?.attachCount == "0"  {
    //                    self.attechmnt_Img.isHidden = true
    //
    //                                    }else{
    //            if auditDetail?.attachCount == nil  {
    //                    self.attechmnt_Img.isHidden = true
    //                                    }else{
    //
    //                   self.attechmnt_Img.isHidden = false
    //                    self.attechmnt_Img.image =  UIImage.init(named: "icons8@-attech")
    //
    //                            }
    //
    //                        }
                
                
                //////////////creat new audit when already start button show 1st time :-
                
                
               // statusViewEnable(isEnable: false)
    //             ButtonAnimator(animationOnButton: acceptBtn, x_space:  rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
    //            acceptBtn.tag = taskStatusType.InProgress.rawValue
    //            self.acceptBtn.setTitle("Start", for: .normal)
    //            //self.declineBtn.setTitle("Startfgdgdfg", for: .normal)
    //            self.accept_WrBtn.constant = -325
    //            self.declineBtn.isHidden = true
    //            ///////////
                     setLocalization()
              
    //            self.navigationItem.rightBarButtonItem = nil;
    //            ActivityLog(module:Modules.audit.rawValue , message: ActivityMessages.auditDetails)
            }
            
            func setLocalization() -> Void {
                self.navigationItem.title = LanguageKey.detail_audit //LanguageKey.job_details
                lblJobCode.text = "\(LanguageKey.audit_code) :" //LanguageKey.job_code
                lblStatus.text = LanguageKey.status_radio_btn
                lblLocation1.text = LanguageKey.location
                lblDescription1.text = LanguageKey.description
                lblInstuction1.text = LanguageKey.instr
                lblContactName.text = LanguageKey.contact_name
                lblFieldworkers.text = LanguageKey.auditors
                lblTags.text = LanguageKey.tags
                lblStart.text = LanguageKey.start
                lblEnd.text = LanguageKey.end
                
                btnInstructionView.setTitle(LanguageKey.view , for: .normal)
                viewBtn.setTitle(LanguageKey.view , for: .normal)
                mapBtn.setTitle(LanguageKey.map , for: .normal)
               // declineBtn.setTitle(LanguageKey.reject , for: .normal)
               // acceptBtn.setTitle(LanguageKey.accept , for: .normal)
                btnCancelPicker.setTitle(LanguageKey.cancel , for: .normal)
                btnDonePicker.setTitle(LanguageKey.done , for: .normal)
                
                btbOkDescription.setTitle(LanguageKey.ok , for: .normal)
            //    btnOkChat.setTitle(LanguageKey.ok , for: .normal)
               // btnOkContact.setTitle(LanguageKey.ok , for: .normal)
                
            }
            
            func setupMethod() -> Void {

                //for enable swipe functionality
                swipe()

                //Hide background view
                backgroundView.isHidden = true


                if auditDetail?.schdlStart != "" {

                    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                        if enableCustomForm == "0"{
                            
                            let startDate = (auditDetail?.schdlStart != nil) ? convertTimeStampToString(timestamp: auditDetail!.schdlStart!, dateFormate: DateFormate.ddMMMyyyy_hh_mma) : ""


                                                     if (startDate != "") {
                                                         let arr = startDate.components(separatedBy: " ")

                                                         if arr.count > 0 {
                                                             lblStartDate.text = arr[0]
                                                             lblStartTime.text = arr[1]
                                                         }
                                                     }
                                              let endDate = (auditDetail?.schdlFinish != nil) ? convertTimeStampToString(timestamp: auditDetail!.schdlFinish!, dateFormate: DateFormate.ddMMMyyyy_hh_mma) : ""

                                                     if (endDate != "") {
                                                         let arr = endDate.components(separatedBy: " ")

                                                         if arr.count > 0 {
                                                             lblEndDate.text = arr[0]
                                                             lblEndTime.text = arr[1]
                                                         }
                                                     }
                            
                        }else{
                            let startDate = (auditDetail?.schdlStart != nil) ? convertTimeStampToString(timestamp: auditDetail!.schdlStart!, dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""


                                                     if (startDate != "") {
                                                         let arr = startDate.components(separatedBy: " ")

                                                         if arr.count > 0 {
                                                             lblStartDate.text = arr[0]
                                                             lblStartTime.text = arr[1]
                                                         }
                                                     }
                                              let endDate = (auditDetail?.schdlFinish != nil) ? convertTimeStampToString(timestamp: auditDetail!.schdlFinish!, dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""

                                                     if (endDate != "") {
                                                         let arr = endDate.components(separatedBy: " ")

                                                         if arr.count > 0 {
                                                             lblEndDate.text = arr[0]
                                                             lblEndTime.text = arr[1]
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

              //  nameLbl.text = "Start : \(startDate)"

        //        let endDate = (auditDetail?.schdlFinish != nil) ? convertTimeStampToString(timestamp: auditDetail!.schdlFinish!, dateFormate: DateFormate.ddMMMyyyy_hh_mma) : ""
        //
        //        if (endDate != "") {
        //            let arr = endDate.components(separatedBy: " ")
        //
        //            if arr.count > 0 {
        //                lblEndDate.text = arr[0]
        //                lblEndTime.text = arr[1]
        //            }
        //        }



                jobCodeLbl.text = auditDetail?.label

                let kprVar = auditDetail?.kpr
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
                let adr = auditDetail?.adr != "" ? auditDetail?.adr : ""
                var ctry = auditDetail?.ctry != "" ? auditDetail?.ctry : ""
                var stt = auditDetail?.state != "" ? auditDetail?.state : ""
                let city = auditDetail?.city != "" ? auditDetail?.city : ""
               // let snm = auditDetail?.snm != "" ? auditDetail?.snm : ""


                if(ctry != ""){
                    let name = filterStateAccrdToCountry(serchCourID: (ctry)!, searchPredicate: "id", arr: getCountry() as! [Any])
                    ctry = name.count != 0 ? (name[0] as? [String : Any])!["name"] as? String  : ""
                }


                if(stt != ""){
                    let statename = filterStateAccrdToCountry(serchCourID: (stt)!, searchPredicate: "id", arr: getStates() as! [Any])
                    stt = statename.count != 0 ? (statename[0] as? [String : Any])!["name"] as? String : ""
                }

                var address = ""

                if let mark = auditDetail?.landmark {
                    if mark != "" {
                        address = mark.capitalizingFirstLetter()
                    }
                }


                if adr! != "" {
                    if address != "" {
                        address = address + ", \(adr!)"
                    } else {
                        address = "\(adr!)"
                    }


                }

        //        if snm! != "" {
        //            if address != "" {
        //                address = address + ", \(snm!)"
        //            } else {
        //                address = "\(snm!),"
        //            }
        //        }


                if city! != "" {
                    if address != ""{
                        address = address + ", \(city!)".capitalized
                    }else{
                        address = "\(city!),"
                    }
                }


                if stt! != "" {
                    if address != ""{
                        address = address + ", \(stt!)".capitalized
                    }else{
                        address = "\(stt!),"
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
                    locationLbl.attributedText =  lineSpacing(string: address.capitalized, lineSpacing: 7.0)
                }else{
                    locationLbl.text = ""
                }


                // Description and Instruction, Skype, Twitter ==============================
                if  auditDetail?.des != "" {
                    descriptionLbl.attributedText =  lineSpacing(string: (auditDetail?.des?.capitalizingFirstLetter())!, lineSpacing: 7.0)
                }else{
                    descriptionLbl.text = ""
                }


                if  auditDetail?.inst != "" {
                    instructionLbl.attributedText =  lineSpacing(string: (auditDetail?.inst?.capitalizingFirstLetter())!, lineSpacing: 7.0)
                }else{
                    instructionLbl.text = ""
                }

                if auditDetail?.mob1 != "" {
                    btnMob1.setTitle(auditDetail?.mob1, for: .normal)
                }else{
                    btnMob1.isUserInteractionEnabled = false
                    btnMob1.setTitle(LanguageKey.not_available, for: .normal)
                    btnMob1.setTitleColor(UIColor.lightGray, for: .normal)
                }

                if auditDetail?.mob2 != "" {
                    btnMob2.setTitle(auditDetail?.mob2, for: .normal)
                }else{
                    btnMob2.isUserInteractionEnabled = false
                    btnMob2.setTitle(LanguageKey.not_available, for: .normal)
                    btnMob2.setTitleColor(UIColor.lightGray, for: .normal)
                }


                //For Twitter and Skype
        //        if auditDetail?.skype != nil && auditDetail?.skype !=  ""{
        //            self.lbl_SkypeId.text = auditDetail?.skype
        //        }else{
        //            self.lbl_SkypeId.text = LanguageKey.not_available
        //        }
        //
        //        if auditDetail?.twitter != nil && auditDetail?.twitter !=  ""{
        //            self.lbl_TwitterId.text = auditDetail?.twitter
        //        }else{
        //            self.lbl_TwitterId.text = LanguageKey.not_available
        //        }


                //        let tempTime = convertTimestampToDate(timeInterval: (auditDetail?.schdlStart)!)
                //        timeLbl.text = tempTime.0 + tempTime.1

                if auditDetail?.schdlStart != "" {
                    let tempTime = convertTimestampToDate(timeInterval: (auditDetail?.schdlStart)!)
                    timeLbl.text = tempTime.0 + tempTime.1
                } else {
                    timeLbl.text = ""
                }


                if let statusId = auditDetail?.status{
                    let status = taskStatus(taskType: taskStatusType(rawValue: Int(statusId == "0" ? "1" : (statusId))!)!)
                    let statusName = status.0.replacingOccurrences(of: " Task", with: "")
                    lblTaskStatus.text = statusName
                    imgStatus.image = status.1
                    currentStatusID = auditDetail?.status

                    DispatchQueue.main.async {
                        self.rectAcceptBtn = self.acceptBtn.frame
                        self.rectDeclineBtn = self.declineBtn.frame
                        self.isFirst = true
                       // self.ChangeButtonsAccordingToStatusType(status: taskStatusType(rawValue: Int(statusId == "0" ? "1" : (statusId))!)!)
                        self.isFirst = false
                    }

                }else{
                    lblTaskStatus.text = ""
                    imgStatus.image = nil
                }






                if auditDetail?.cnm == "" {
                    contactNmaeLbl.text = ""
                }else{
                    contactNmaeLbl.text = auditDetail?.cnm?.capitalizingFirstLetter()
                }
                ////
    //            if auditDetail!.tagData != nil {
    //            for tag in (auditDetail!.tagData! as! [AnyObject]) {
    //
    //                self.tagsView.appendTags([tag["tnm"] as! String], withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: false)
    //                }
    //            }
                
                ////
        //        if (auditDetail?.tagData != nil  && (auditDetail!.tagData!).count > 0 ){
        //            for tag in (auditDetail!.tagData!) {
        //                self.tagsView.appendTags([tag.tnm!], withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: false)
        //            }
        //        }

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
    //
    //            LocationManager.shared.startStatusLocTracking()
    //
    //            self.tabBarController?.navigationItem.title = LanguageKey.detail_audit
    //
    //            if let button = self.parent?.navigationItem.rightBarButtonItem {
    //                button.isEnabled = false
    //                button.tintColor = UIColor.clear
    //            }
    //
    //            APP_Delegate.mainArr.removeAll()
    //
    //
    //            if UIScreen.main.sizeType == .iPhone5 {
    //                self.nameLbl.font = nameLbl.font.withSize(14.0)
    //            }
    //
    //            if getDefaultSettings()?.isHideContact == "1" && auditDetail?.status == String(taskStatusType.Start.rawValue){
    //                contactDetailViewHeight.constant = 0
    //                topViewConnect.constant = 0
    //                //contactDetailView.isHidden = true
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
            
            @IBAction func acceptBtn(_ sender: UIButton) {
                
                LocationManager.shared.isHaveLocation()
                
                let status : taskStatusType = taskStatusType(rawValue: sender.tag)!
                
                if currentStatusID != String(status.rawValue) {
                    if UserDefaults.standard.bool(forKey: "permission") {
                        statusId = status
                        showDateAndTimePicker()
                    }else{
                        
                        if (sender.titleLabel!.text!.contains("Resume")) || (isHaveNetowork() == false){ // In case of 'Job Resume' and 'Travel Resume' not showing custom form on these two buttons
                            if currentStatusID != String(status.rawValue) {
                              //  self.ChangeButtonsAccordingToStatusType(status: status)
                            }
                            return
                        }
                        
                            if currentStatusID != String(status.rawValue) {
                               // self.ChangeButtonsAccordingToStatusType(status: status)
                            }
                        
                    }
                }
                
            }
            
            
    //        func ChangeButtonsAccordingToStatusType(status : taskStatusType){
    //
    //            if !isFirst{
    //
    //                if status == taskStatusType.InProgress{
    //                    for job in jobArray {
    //                        if job.status == String(taskStatusType.InProgress.rawValue){
    //                            job.status = String(taskStatusType.OnHold.rawValue)
    //                            job.updateDate = getCurrentTimeStamp()
    //                        }
    //                    }
    //                }
    //
    //                auditDetail?.status = String(status.rawValue)
    //                auditDetail?.updateDate = getCurrentTimeStamp()
    //
    //
    //                changeJobStatus(statusId: status.rawValue, audit: auditDetail!)
    //            }
    //
    //            let statusDetail = taskStatus(taskType: status)
    //            let statusName = statusDetail.0.replacingOccurrences(of: " Task", with: "")
    //            imgStatus.image = statusDetail.1
    //            lblTaskStatus.text = statusName
    //
    //            switch status {
    //
    //            //-----------------------------------------------------------------------
    //            case .Start:
    //
    //                statusViewEnable(isEnable: false)
    //
    //                ButtonAnimator(animationOnButton: acceptBtn, x_space:  rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
    //
    //                acceptBtn.tag = taskStatusType.InProgress.rawValue
    //                self.acceptBtn.setTitle("Start", for: .normal)
    //                   //self.declineBtn.setTitle("Startfgdgdfg", for: .normal)
    //                 self.accept_WrBtn.constant = -325
    //                self.declineBtn.isHidden = true
    //              // acceptBtn.center.y = self.view.center.y
    //               // let widthContraints =  NSLayoutConstraint(item: accept_WrBtn, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 325.0)
    //
    //               // NSLayoutConstraint.activate([widthContraints])
    //                //accept_WrBtn.widthAnchor.constraintEqualToConstant(30.0).isActive = true
    //                //accept_WrBtn.widthAnchor.constraint(equalToConstant: 325.0).isActive = true
    //                break
    //
    //
    //            case .InProgress:
    //                self.accept_WrBtn.constant = 10.5
    //                self.declineBtn.isHidden = false
    //                statusViewEnable(isEnable: true)
    //
    //                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width)
    //
    //                ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x, width_constant: rectDeclineBtn.size.width)
    //
    //                acceptBtn.tag = taskStatusType.OnHold.rawValue
    //                self.acceptBtn.setTitle("On Hold", for: .normal)
    //
    //                declineBtn.tag = taskStatusType.Completed.rawValue
    //                self.declineBtn.setTitle("Complete", for: .normal)
    //
    //                break
    //
    //            //-----------------------------------------------------------------------
    //            case .Completed :
    //                   self.accept_WrBtn.constant = 10.5
    //                  self.declineBtn.isHidden = false
    //                ButtonAnimator(animationOnButton: acceptBtn, x_space:  rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
    //
    //                statusViewEnable(isEnable: false)
    //
    //                self.acceptBtn.setTitle("Completed", for: .normal)
    //                self.acceptBtn.backgroundColor = UIColor.init(red: 115.0/255.0, green: 216.0/255.0, blue: 21.0/255.0, alpha: 1.0)
    //                self.acceptBtn.isUserInteractionEnabled = false
    //                self.declineBtn.isUserInteractionEnabled = false
    //                self.btnStatusType.isUserInteractionEnabled = false
    //                statusTwoButtons_H.constant =  10.0
    //                self.view.layoutIfNeeded()
    //
    //                break
    //
    //
    //            //-----------------------------------------------------------------------
    //            case .OnHold:
    //                   self.accept_WrBtn.constant = 10.5
    //                  self.declineBtn.isHidden = false
    //                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width)
    //
    //                ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x, width_constant: rectDeclineBtn.size.width)
    //
    //                acceptBtn.tag = taskStatusType.InProgress.rawValue
    //                self.acceptBtn.setTitle("Resume", for: .normal)
    //
    //                declineBtn.tag = taskStatusType.Completed.rawValue
    //                self.declineBtn.setTitle("Complete", for: .normal)
    //
    //                break
    //            //-----------------------------------------------------------------------
    //            case .Closed:
    //                   self.accept_WrBtn.constant = 10.5
    //                  self.declineBtn.isHidden = false
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
            
            
            override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
                if identifier == "MapVC" {
                    if auditDetail?.lat == nil || auditDetail?.lng == nil || auditDetail?.lat == "" || auditDetail?.lng == "" || auditDetail?.lat == "0" || auditDetail?.lng == "0" {
                        ShowError(message: AlertMessage.locationNotAvailable , controller: self)
                        return false
                    }
                }
                return true
            }
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "MapVC"{
                    let mapVw = segue.destination as! MapVC
                    mapVw.lattitude = auditDetail?.lat
                    mapVw.longitude = auditDetail?.lng
                    mapVw.address = locationLbl.text
                }
            }
            
            
            // ================================
            // MARK: Button Functionality
            //================================
            
            @IBAction func tapOnBackgrounVw(_ sender: Any) {
                hideBackgroundView()
                detailDatePicker.isHidden = true
                pickerTabView.isHidden = true
            }
            
            
            @IBAction func detailDecriptionViewBtn(_ sender: Any) {
    //            if auditDetail?.des == nil || auditDetail?.des == "" {
    //                ShowError(message: AlertMessage.descriptionNotAvailable , controller: self)
    //                return
    //            }
    //
    //            showBackgroundView()
    //            textDescriptionView.text = auditDetail?.des?.capitalizingFirstLetter()
    //            textDescriptionView.textContainerInset = UIEdgeInsets.init(top: 8,left: 5,bottom: 8,right: 8); // top, left, bottom, right
    //            view.addSubview(descriptionView)
    //            descriptionView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
    //            descriptionHeadingLbl.text = LanguageKey.description
            }
            
            
            @IBAction func detailInstructionViewBtn(_ sender: Any) {
    //            if auditDetail?.inst == nil || auditDetail?.inst == "" {
    //                ShowError(message: AlertMessage.instructionNotAvailable, controller: self)
    //                return
    //            }
    //            showBackgroundView()
    //            textDescriptionView.text = auditDetail?.inst?.capitalizingFirstLetter()
    //            textDescriptionView.textContainerInset = UIEdgeInsets.init(top: 8,left: 5,bottom: 8,right: 8); // top, left, bottom, right
    //            view.addSubview(descriptionView)
    //            descriptionView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
    //            descriptionHeadingLbl.text = LanguageKey.instr
            }
            
            
            @IBAction func closeDetailBtn(_ sender: Any) {
                hideBackgroundView()
            }
            
            @IBAction func emailBtn(_ sender: Any) {
    //            if auditDetail?.email == nil || auditDetail?.email == "" {
    //                ShowError(message: AlertMessage.emailNotAvailable, controller: self)
    //                return
    //            }
    //
    //            let mailComposeViewController = configuredMailComposeViewController()
    //            if MFMailComposeViewController.canSendMail() {
    //                APP_Delegate.showBackButtonText()
    //                self.present(mailComposeViewController, animated: true, completion: nil)
    //            }
            }
            
            @IBAction func chatBtn(_ sender: Any) {
        //        if ((auditDetail?.skype == "") && (auditDetail?.twitter == "") && (auditDetail?.skype == nil) && (auditDetail?.skype == nil)) {
        //            ShowError(message: AlertMessage.chatNotAvailable, controller: windowController)
        //            return
        //        }
        //
        //        showBackgroundView()
        //        view.addSubview(chatView)
        //        chatView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
            }
            
            @IBAction func closeChatViewBtn(_ sender: Any) {
                hideBackgroundView()
            }
            
            @IBAction func callBtn(_ sender: Any) {
                
    //            if ((auditDetail?.mob1 == "") && (auditDetail?.mob2 == "")) {
    //                ShowError(message: AlertMessage.contactNotAvailable , controller: windowController)
    //                return
    //            }
    //
    //
    //            showBackgroundView()
    //            view.addSubview(contactNoView)
    //            contactNoView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
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
            
            //================================
            // MARK: Email Functionality
            // ================================
            
         //   func configuredMailComposeViewController() -> MFMailComposeViewController {
    //            APP_Delegate.showBackButtonText()
    //
    //            let mailComposerVC = MFMailComposeViewController()
    //            mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
    //            // print((auditDetail?.email)!)
    //            mailComposerVC.setToRecipients([(auditDetail?.email)!])
    //            mailComposerVC.setCcRecipients([])
    //            mailComposerVC.setBccRecipients([])
    //            if #available(iOS 11.0, *) {
    //                mailComposerVC.setPreferredSendingEmailAddress("abc@xyz.com")
    //            } else {
    //                // Fallback on earlier versions
    //            }
    //            return mailComposerVC
           // }
            
            
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
            func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return arrTypeStatus.count
            }
            
            func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                var cell = tableView.dequeueReusableCell(withIdentifier:"cell")
                if(cell == nil){
                    cell = UITableViewCell.init(style: .default, reuseIdentifier:"cell")
                }
                
                let status : String = String(describing: arrTypeStatus[indexPath.row])
                cell?.textLabel?.text = status.capitalizingFirstLetter()
                cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
                cell?.backgroundColor = .clear
                //cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
                cell?.textLabel?.textColor = UIColor.darkGray
                
                return cell!
            }
            
            
            func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                self.removeOptionalView()
                
                LocationManager.shared.isHaveLocation()
                let status : taskStatusType = arrTypeStatus[indexPath.row]
                
                if currentStatusID != String(status.rawValue) {
                    if UserDefaults.standard.bool(forKey: "permission") {
                        statusId = status
                        showDateAndTimePicker()
                    }else{
                        
                        if isHaveNetowork() ==  false {
                            if currentStatusID != String(status.rawValue) {
                             //   ChangeButtonsAccordingToStatusType(status: arrTypeStatus[indexPath.row])
                            }
                            return
                        }
                        

                        if currentStatusID != String(status.rawValue) {
                           // ChangeButtonsAccordingToStatusType(status: arrTypeStatus[indexPath.row])
                        }
                    }
                }
            }
            
            
            func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 38.0
            }
            
            
        //    func changeJobStatus(statusId : Int, audit : AuditListData){
        //        if(audit.audId == nil){
        //            return
        //        }
        //        //Change currentid variable
        //        currentStatusID = String(statusId)
        //
        //
        //
        //        if LocationManager.shared.isCheckLocation() {
        //            self.updateStatusOnServer(lat: "\(LocationManager.shared.currentLattitude)", lon: "\(LocationManager.shared.currentLongitude)", statusId: statusId, audit: audit)
        //        }else{
        //            updateStatusOnServer(lat: "0.0", lon: "0.0", statusId: statusId, audit: audit)
        //        }
        //    }
            func changeJobStatus(statusId : Int, audit : AuditOfflineList){
                   if(audit.audId == nil){
                       return
                   }
                   //Change currentid variable
                   currentStatusID = String(statusId)
                   
                   
                   
                   if LocationManager.shared.isCheckLocation() {
                       self.updateStatusOnServer(lat: "\(LocationManager.shared.currentLattitude)", lon: "\(LocationManager.shared.currentLongitude)", statusId: statusId, audit: audit)
                   }else{
                       updateStatusOnServer(lat: "0.0", lon: "0.0", statusId: statusId, audit: audit)
                   }
               }
            
            func updateStatusOnServer(lat:String,lon:String, statusId : Int, audit : AuditOfflineList) -> Void {
                
                
                /*
                 "audId -> audit id
                 usrId -> user id
                 status -> Audit status
                 dateTime -> date time (dd-mm-yyy hh:mm:ss pm)
                 device_Type ->[0 - desktop, 1 - android,2 -  iOS]
                 lat->latitude
                 lng->logitude"
                 */
                
                let param = Params()
                param.audId = audit.audId
                param.usrId = getUserDetails()?.usrId
                param.status =   String(format: "%d",statusId)
                param.lat = lat
                param.lng = lon
                param.device_Type = "2"
                
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
                formatter.timeZone = TimeZone.current
                formatter.locale = Locale(identifier: "en_US")
                let strDate = formatter.string(from: Date())
                
                param.dateTime = self.sltDate != "" ? self.sltDate : strDate
                self.sltDate = ""
                
                serverCommunicator(url: Service.changeAuditStatus, param: param.toDictionary) { (response, success) in
                    if(success){
                        let decoder = JSONDecoder()

                        if let decodedData = try? decoder.decode(CommonResponse.self, from: response as! Data) {

                            if decodedData.success == true{
                               // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            }else{
                                ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            }
                        }else{
                            ShowAlert(title: "formate problem", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                        }
                    }else{
                        //ShowError(message: "Please try again!", controller: windowController)
                    }
                }
               
            }
            
            
            
            @IBAction func pickerBtn(_ sender: UIButton) {
    //            if sender.tag == 0{
    //                let dateFormmater = DateFormatter()
    //                dateFormmater.dateFormat = "dd-MM-yyyy hh:mm:ss a"
    //                dateFormmater.timeZone = TimeZone.current
    //                dateFormmater.locale = Locale(identifier: "en_US")
    //                sltDate = dateFormmater.string(from: detailDatePicker.date)
    //
    //                detailDatePicker.isHidden = true
    //                pickerTabView.isHidden = true
    //                hideBackgroundView()
    //              //  ChangeButtonsAccordingToStatusType(status: statusId!)
    //            }else{
    //                detailDatePicker.isHidden = true
    //                pickerTabView.isHidden = true
    //                hideBackgroundView()
    //            }
            }
            
            
            func showDateAndTimePicker(){
                showBackgroundView()
                pickerTabView.isHidden = false
                detailDatePicker.isHidden = false
                detailDatePicker?.backgroundColor = UIColor.white
            }
            
            //==================================
            // MARK:- Equipement LIST Service methods
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
                
                param.audId = auditDetailHstry?.audId
            
                
                serverCommunicator(url: Service.getAuditDetail, param: param.toDictionary) { (response, success) in
                    
                    
                    if(success){
                        let decoder = JSONDecoder()
                        
                        if let decodedData = try? decoder.decode(EquipmentAuditDetail.self, from: response as! Data) {
                            if decodedData.success == true{
                                killLoader()
                          //  if decodedData.data!.count > 0 {
                                self.auditDetail = decodedData.data
                                
                                print(self.auditDetail?.kpr)
                                  DispatchQueue.main.async {
                                    self.setupMethod()
                                }
                                // }
    //p
    //                                DispatchQueue.main.async {
    //                                    var nm = "Equipment Service "
    //                                    self.serviceCount.text! = "\(nm): \(String(self.allEqpHistrySer.count))"
    //
    //
    //                                    var arrs = self.allEqpHistrySer.count
    //                                    if arrs == 0{
    //                                        self.viewAllSerBtn.isHidden = true
    //                                        self.serviceView_H.constant = 0
    //                                    }else{
    //                                        self.viewAllSerBtn.isHidden = false
    //                                        self.serviceView_H.constant = 140
    //                                    }
    //
    //                                    self.serviceTblView.reloadData()
    //                                    //
    //                                    //  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
    //
    //                                    killLoader()
    //                                }
       //                         }else{
    //                                //   print("jugal")
    //                                //self.equipments.removeAll()
    //                                DispatchQueue.main.async {
    //                                    var nm = "Equipment Service "
    //                                    self.serviceCount.text! = "\(nm): \(String(self.allEqpHistrySer.count))"
    //
    //
    //                                    var arrs = self.allEqpHistrySer.count
    //                                    if arrs == 0{
    //                                        self.serviceView_H.constant = 0
    //                                        self.viewAllSerBtn.isHidden = true
    //                                    }else{
    //                                        self.viewAllSerBtn.isHidden = false
    //                                        self.serviceView_H.constant = 140
    //                                    }
    //                                    // self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
    //                                    self.serviceTblView.reloadData()
    //                                }
    //
     //                               killLoader()
    //                            }
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
        
            
        }

        // Helper function inserted by Swift 4.2 migrator.
        fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
            return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
        }
