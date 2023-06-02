//
//  AppoinmentDetailCltHstry.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 25/03/21.
//  Copyright © 2021 Hemant. All rights reserved.
//


import UIKit
import MessageUI
import Photos
import CoreData
import MobileCoreServices
import JJFloatingActionButton

class AppoinmentDetailCltHstry: UIViewController , MFMailComposeViewControllerDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{


    
    var allAppoinmentDetailHstry : AppoinmentHWorkHistry?
    var appoinmentDetail : ApppinmentDetailData?
    
    


    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var statusView: UIView!

    @IBOutlet weak var height_JobView: NSLayoutConstraint!
    @IBOutlet weak var jobView: UIView!
    @IBOutlet weak var recentJobId: UILabel!
    @IBOutlet weak var jobLabelOne: UILabel!
    @IBOutlet weak var jonTittle: UILabel!
    @IBOutlet weak var detailLinkJob: UIButton!
    @IBOutlet weak var lblQuotTitle: UILabel!
    @IBOutlet weak var quotHieght: NSLayoutConstraint!
    @IBOutlet weak var quotView: UIView!
    @IBOutlet weak var linkLbl: UILabel!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var lblQuotation: UILabel!
    @IBOutlet weak var pdfBtn: UIButton!
    @IBOutlet weak var pdfImg: UIImageView!
    @IBOutlet var bigViewPdf: UIView!
    @IBOutlet weak var exportBtn: UIButton!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnEmailAction: UIButton!
    @IBOutlet var emailView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lblPhoneNo: UIButton!
    @IBOutlet weak var lblmobileNo: UIButton!
    @IBOutlet var viewContact: UIView!
    @IBOutlet weak var btnAddNewAtteche: UIButton!
    @IBOutlet weak var btnViewMap: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDescriptionTitle: UILabel!
    @IBOutlet weak var lblAttechment: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblSchdduleTitle: UILabel!
    @IBOutlet weak var lblDesDetail: UILabel!
    @IBOutlet weak var imgEmtAttch: UIImageView!
    @IBOutlet weak var lblAleartMsg: UILabel!
    @IBOutlet weak var height_ExportDoc: NSLayoutConstraint!
    @IBOutlet weak var height_Selectall: NSLayoutConstraint!


     var jobLabelId : String?
     var appIdData : String?
     var isNewParam = Bool()
     var isAdded = Bool()
     var currentDate = Date()
     var objOfUserJobListInDetail : UserJobList!
     var selectedRows:[Int] = []
     var isDisable = true
     var arrOfFilterData:AddAppointment?
     var objOfUserJobListInDoc = UserJobList()
     var uploadImage : UIImage? = nil
     var arrOfShowData : AddAppointment?
     var imagePicker = UIImagePickerController()
     let screenWidth = UIScreen.main.bounds.width
     let screenHeight = UIScreen.main.bounds.height
     var callback: ((Bool,NSManagedObject) -> Void)?
     var appintDetainsDic : AppointmentList?
     var isQuotData : Bool = false
 //    var appintDetainsDicCommon : CommanListDataModel?
     var isSync : Bool = false
     var arrNotSyncImg = [String]()
     var FltWorkerId = [String]()
     var count : Int = 0
     var selectedStatus : [String] = []
     var searchTxt = ""
     var refreshControl = UIRefreshControl()
     var arrOFUserDataQuot = [QuotationData]()
     var arrOFData = [QuotationData]()
     var quotation : QuotationData!
     var arrOFUserData = [UserJobList]()

    override func viewDidLoad() {
        super.viewDidLoad()

          getAppoinmentDetail()

        
        print(appoinmentDetail?.des)
         self.selectAllBtn.isHidden = true
         self.exportBtn.isHidden = true
         self.height_ExportDoc.constant = 0
         self.height_Selectall.constant = 0
         // selectAllBtn.imageView?.image = UIImage(named: "BoxOFUncheck")
         selectAllBtn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
         hideBackgroundView()
           self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
//
       // floatinActionButton()
      //  floatingButtonAction()
         getQuoteListService()
//        let appoint = appoinmentDetail?.commonId?.components(separatedBy: "-")
//               if appoint!.count > 0 {
//                   let appId = appoint![0]
//                   if appId == "Appointment"{
//
//                       self.collectionView.isHidden = true
//                    self.imgEmtAttch.isHidden = false
//                       lblAleartMsg.text = LanguageKey.appointment_not_sync  //"Data Not Sync"
//                       isSync = false
//                        let image = appoinmentDetail?.attachments
//                       if image != nil && image != "" {
//                            self.collectionView.isHidden = false
//
//                           arrNotSyncImg.append(image ?? "")
//
//                           self.collectionView.reloadData()
//                       }
//
//                   }else {
//                        isSync = true
//                        getDocumentsList()
//                   }
//               }


        let quot = appoinmentDetail?.quotLabel
               if quot == nil{
                   quotHieght.constant = 0
                   lblQuotation.isHidden = true
                   lblQuotTitle.isHidden = true
               }else{
                   quotView.isHidden = false
               }

//               let isExist = self.arrOFUserDataQuot.contains(where: {$0.quotId == appintDetainsDicCommon?.quotId})
//               if !isExist {
//                   quotHieght.constant = 0
//                   lblQuotation.isHidden = true
//                   lblQuotTitle.isHidden = true
//               }else{
//                   quotView.isHidden = false
//               }


         setLocalization()
       //  setupMethod()
         arrOFUserData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: nil) as! [UserJobList]


    }
     override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        hideloader()


         }

    //==================================
             // MARK:- Equipement Appoinment Service methods
             //==================================
             func getAppoinmentDetail(){

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

               param.appId = allAppoinmentDetailHstry?.appId


                 serverCommunicator(url: Service.getAppointmentDetail, param: param.toDictionary) { (response, success) in


                     if(success){
                         let decoder = JSONDecoder()


                              if let decodedData = try? decoder.decode(ApppinmentDetailDataHstry.self, from: response as! Data) {
                                                       if decodedData.success == true{
                                                           killLoader()
                                                     //  if decodedData.data!.count > 0 {
                                                           self.appoinmentDetail = decodedData.data

                                                           //print(self.auditDetail?.kpr)
                                                            // DispatchQueue.main.async {
                                                             //  self.setupMethod()
                                                           //}
                                                           // }
                               //p
                                                               DispatchQueue.main.async {
                                                                 self.setupMethod()
                                                        }
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



    func hideloader() -> Void {
        DispatchQueue.main.async {
//            if self.refreshControl.isRefreshing {
//                self.refreshControl.endRefreshing()
           // }
        }

        killLoader()
    }

    func setLocalization() -> Void {
          self.navigationItem.title = LanguageKey.appointment_details
          lblDescriptionTitle.text = "\(LanguageKey.description) "
          lblSchdduleTitle.text = LanguageKey.appointment_schedule
          lblAttechment.text = LanguageKey.attachment

          lblAleartMsg.text = LanguageKey.appointment_attach_msg
         // btnAddNewAtteche.setTitle(LanguageKey.document , for: .normal)
          btnAddNewAtteche.setTitle(LanguageKey.appointment_add_new_attach , for: .normal)
          emailBtn.setTitle(LanguageKey.send_email , for: .normal)
          btnViewMap.setTitle(LanguageKey.view_on_map , for: .normal)
          btnEmail.setTitle(LanguageKey.ok , for: .normal)
          btnOk.setTitle(LanguageKey.ok , for: .normal)

          exportBtn.setTitle(LanguageKey.export_document , for: .normal)
          selectAllBtn.setTitle(LanguageKey.select_all , for: .normal)
          pdfBtn.setTitle(LanguageKey.view , for: .normal)
          lblQuotTitle.text = LanguageKey.quotation_label
          lblQuotation.text = LanguageKey.recent_quote
          recentJobId.text = LanguageKey.recent_job
          jonTittle.text =  LanguageKey.job
          lblStatus.text = LanguageKey.mark_as_done
    }


    // setup method

        func setupMethod() -> Void {

           //Hide background view
                   backgroundView.isHidden = true
                   lblName.text = appoinmentDetail?.nm != nil ? appoinmentDetail?.nm : "Unknown"

                   // Append Address detail==============================
                   let adr = appoinmentDetail?.adr != "" ? appoinmentDetail?.adr : ""

                   let city = appoinmentDetail?.city != "" ? appoinmentDetail?.city : ""

                 let des = appoinmentDetail?.des != "" ? appoinmentDetail?.des : ""
                   lblDesDetail.text = des
            let linkQout = appoinmentDetail?.quotLabel != "" ? appoinmentDetail?.quotLabel : ""
            linkLbl.text = linkQout



        if appoinmentDetail?.mob1 != "" {
            lblmobileNo.setTitle(appoinmentDetail?.mob1, for: .normal)
        }else{
            lblmobileNo.isUserInteractionEnabled = false
            lblmobileNo.setTitle(LanguageKey.not_available, for: .normal)
            lblmobileNo.setTitleColor(UIColor.lightGray, for: .normal)
        }

        if appoinmentDetail?.mob2 != "" {
            lblPhoneNo.setTitle(appoinmentDetail?.mob2, for: .normal)
        }else{
            lblPhoneNo.isUserInteractionEnabled = false
            lblPhoneNo.setTitle(LanguageKey.not_available, for: .normal)
            lblPhoneNo.setTitleColor(UIColor.lightGray, for: .normal)
        }


                   if appoinmentDetail?.email != "" {
                             btnEmailAction.setTitle(appoinmentDetail?.email, for: .normal)
                          }else{
                             btnEmailAction.isUserInteractionEnabled = false
                              btnEmailAction.setTitle(LanguageKey.not_available, for: .normal)
                              btnEmailAction.setTitleColor(UIColor.lightGray, for: .normal)
                          }


                                 var ctry = appoinmentDetail?.ctry != "" ? appoinmentDetail?.ctry : ""
                                 var stt = appoinmentDetail?.state != "" ? appoinmentDetail?.state : ""


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

                   if let mark = appoinmentDetail?.landmark {

                       if address != "" {
                           if  mark != "" {
                               address = address + ", \(mark.capitalizingFirstLetter())"
                           }
                       } else {
                           address = mark.capitalizingFirstLetter()
                       }
                   }

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
                       lblAddress.attributedText =  lineSpacing(string: address.capitalized, lineSpacing: 7.0)
                   }else{
                       lblAddress.text = ""
                   }

          //  time End Date Show

            if appoinmentDetail?.schdlStart != "" {

                if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                    if enableCustomForm == "0"{
                        let startDate = (appoinmentDetail?.schdlStart != nil) ? convertTimeStampToString(timestamp: (appoinmentDetail?.schdlStart!)!, dateFormate: DateFormate.ddMMMyyyy_hh_mma) : ""


                                               if (startDate != "") {
                                                   let arr = startDate.components(separatedBy: " ")

                                                   if arr.count > 0 {
                                                    lblStartDate.text = arr[0]
                                                       lblStartTime.text = arr[1]
                                                   }
                                               }
                                        let endDate = (appoinmentDetail?.schdlFinish != nil) ? convertTimeStampToString(timestamp: appoinmentDetail!.schdlFinish!, dateFormate: DateFormate.ddMMMyyyy_hh_mma) : ""

                                               if (endDate != "") {
                                                   let arr = endDate.components(separatedBy: " ")

                                                   if arr.count > 0 {
                                                       lblEndDate.text = arr[0]
                                                       lblEndTime.text = arr[1]
                                                   }
                                               }
                    }else{
                       let startDate = (appoinmentDetail?.schdlStart != nil) ? convertTimeStampToString(timestamp: (appoinmentDetail?.schdlStart!)!, dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""


                                               if (startDate != "") {
                                                   let arr = startDate.components(separatedBy: " ")

                                                   if arr.count > 0 {
                                                    lblStartDate.text = arr[0]
                                                       lblStartTime.text = arr[1]
                                                   }
                                               }
                                        let endDate = (appoinmentDetail?.schdlFinish != nil) ? convertTimeStampToString(timestamp: appoinmentDetail!.schdlFinish!, dateFormate: DateFormate.dd_MM_yyyy_HH_mm) : ""

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

//            let searchQuery = "appId = '\(appoinmentDetail?.commonId! ?? "")'"
//                                           let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: searchQuery) as! [AppointmentList]
//                                           if isExist.count > 0 {
//                                               let dta = isExist[0]
//
//                                           //   print(dta.kpr as Any)
//
//
//
//                                                  if dta.kpr != nil {
//                                                             for kprData in (dta.kpr as! [AnyObject]) {
//                                                              if kprData is String {
//                                                                 //  DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
//                                                                  let searchQueryFld = "usrId = '\(kprData)'"
//                                                               let tagData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: searchQueryFld) as! [FieldWorkerDetails]
//
//                                                                  if tagData.count > 0 {
//                                                                      let tag = tagData[0]
//
//                                                                      self.FltWorkerId.append(tag.usrId!)
//
//                                                                  }
//
//                                                              } else {
//
//                                                                  let searchQueryFld = "usrId = '\((kprData as! [String:String])["usrId"] ?? "")'"
//                                                                  let tagData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: searchQueryFld) as! [FieldWorkerDetails]
//
//                                                                  if tagData.count > 0 {
//                                                                      let tag = tagData[0]
//
//
//                                                                      self.FltWorkerId.append(tag.usrId!)
//
//                                                                  }
//
//                                                               }
//                                                          }
//
//                                                       } else {
//                                                     // print("Not for you null")
//                                                  }
//
//                                            //  print( self.FltWorkerId)
//
//                              }



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


        if (viewContact != nil) {
            viewContact.removeFromSuperview()
        }
        if (emailView != nil) {
            emailView.removeFromSuperview()
        }


        self.backgroundView.isHidden = true
        self.backgroundView.backgroundColor = UIColor.clear
        self.backgroundView.alpha = 1
    }

    //================================
     // MARK: Email Functionality
     // ================================

     func configuredMailComposeViewController() -> MFMailComposeViewController {
         APP_Delegate.showBackButtonText()

         let mailComposerVC = MFMailComposeViewController()
         mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
         // print((objOfUserJobListInDetail?.email)!)
        //mailComposerVC.setToRecipients([(objOfUserJobListInDetail?.lblEmail.text)!])
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

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
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

    @IBAction func cancelBtnbigview(_ sender: Any) {
         self.hideBackgroundView()
        self.bigViewPdf.isHidden = true
    }
    @IBAction func sendEmailBtn(_ sender: Any) {
//        self.selectedRows = self.selectedRows.sorted(by: >)
//                                       var itemValue: [String] = []
//                                       for index in self.selectedRows{
//
//                                           let index = self.arrOfShowData?.attachments?[index]
//                                           let getIjmmId  = index?.attachmentId
//                                           itemValue.append(getIjmmId ?? "")
//                                       }
//
//        ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoiceEmail)
//                  let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
//                  let vc = storyboard.instantiateViewController(withIdentifier: "EMAILINVOICE") as! EmailInvoiceVC
//                 // vc.invoiceid = (self.invoiceRes.data?.invId)!
//                  vc.pdfDetailAppoinment = true
//                 vc.pdfDetailAppoinmentarr = itemValue
//                  vc.str = appoinmentDetail?.commonId ?? ""
//                  self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
//                  self.navigationController!.pushViewController(vc, animated: true)
    }
    @IBAction func pdfBtmSnd(_ sender: Any) {

//        if self.selectedRows.count == 0 {
//                             return
//                         }
//              self.selectedRows = self.selectedRows.sorted(by: >)
//                                 var itemValue: [String] = []
//                                 for index in self.selectedRows{
//
//                                     let index = self.arrOfShowData?.attachments?[index]
//                                     let getIjmmId  = index?.attachmentId
//                                     itemValue.append(getIjmmId ?? "")
//                                 }
//
//              ActivityLog(module:Modules.quaotation.rawValue , message: ActivityMessages.quotePrint)
//              let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
//              let vc = storyboard.instantiateViewController(withIdentifier: "pdfvc") as! ShowPdfVC
//              vc.pdfDetailAppoinment = true
//              vc.pdfDetailAppoinmentarr = itemValue
//              vc.appId = appoinmentDetail?.commonId ?? ""
//              self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
//              self.navigationController!.pushViewController(vc, animated: true)


    }

    @IBAction func linkJob(_ sender: Any) {



           let quote = self.arrOFUserData.filter({$0.jobId == self.arrOfShowData?.jobId})

           if quote.count > 0 {
               let storyboard: UIStoryboard = UIStoryboard(name: "MainJob", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "detailJobVC") as! DetailJobVC
               vc.objOfUserJobListInDetail = quote[0]
               self.navigationController?.pushViewController(vc, animated: true)
           }else{

           }

    }


    @IBAction func linkQuotationBtn(_ sender: Any) {


//        let isExist = self.arrOFUserDataQuot.contains(where: {$0.quotId == appoinmentDetail?.quotId})
//
//        let quote = self.arrOFUserDataQuot.filter({$0.quotId == appoinmentDetail?.quotId})
//
//        if quote.count > 0 {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Quote", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "quoteInvoice") as! QuoteInvoiceVC
//            vc.quotationData = quote[0]
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//
//        }

    }


    @IBAction func selectAllBtnAct(_ sender: Any) {
          if(selectAllBtn.imageView?.image == UIImage(named: "BoxOFCheck")){
                    self.selectAllBtn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)


                    self.selectedRows.removeAll()
                    collectionView.reloadData()


                 }else{
                    self.selectAllBtn.setImage(UIImage(named: "BoxOFCheck"), for: .normal)

                  for i in 0..<(self.arrOfShowData?.attachments?.count)!{

                    let pdf =  self.arrOfShowData?.attachments?[i].attachFileActualName

                    let splitName = pdf?.split(separator: ".")
                         //  let name = splitName.first!
                    let filetype = splitName?.last!.lowercased()
                    if filetype == "pdf" || filetype == "doc" || filetype == "xlsx" || filetype == "csv" {
                        ShowError(message: LanguageKey.select_doc_validation, controller: windowController)

                    }else{
                           if selectedRows.contains(i) == false{
                               selectedRows.append(i)
                            //   print(selectedRows)
                           }
                    }

                  }
                  collectionView.reloadData()
                    }

    }

    @IBAction func statusActionBtn(_ sender: UIButton) {

           self.statusView.backgroundColor = UIColor(red: 230/255.0, green: 238/255.0, blue: 249/255.0, alpha: 1)
           statusImg.image = UIImage(named: "Group 292")
           lblStatus.text = "Compeleted"
           lblStatus.textColor = UIColor(red: 176/256, green: 180/256, blue: 189/256, alpha: 1.0)
         if appoinmentDetail?.status == "12" {
        //     UpadateAppointment()
         }

           //statusBtn.isEnabled = false

         }

    @IBAction func expotrBtnAct(_ sender: Any) {
          self.bigViewPdf.isHidden = false
          showBackgroundView()
                      view.addSubview(bigViewPdf)
                      bigViewPdf.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)


    }

    @IBAction func callBtn_Action2(_ sender: UIButton) {
        if sender.titleLabel?.text != LanguageKey.not_available{
            callNumber(phoneNumber: (sender.titleLabel?.text)!)
            hideBackgroundView()
        }
    }
    @IBAction func callBtn1_Action(_ sender: UIButton) {
        if sender.titleLabel?.text != LanguageKey.not_available{
            callNumber(phoneNumber: (sender.titleLabel?.text)!)
            hideBackgroundView()
        }
    }
    @IBAction func btnMap_Action(_ sender: Any) {


//        if (appoinmentDetail?.lat == nil && appoinmentDetail?.lng == nil) ||  (appoinmentDetail?.lat == "" && appoinmentDetail?.lng == "")  {
//
//            if (lblAddress.text != nil && lblAddress.text != "")  {
//                if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
//                    openGoogleMap(latitude: "", longitude: "",locationAddress: self.lblAddress.text!)
//                } else  {
//                    openAppleMap(lat: "", long: "", locationAddress: self.lblAddress.text!)
//                }
//            } else {
//                ShowError(message: AlertMessage.locationNotAvailable , controller: self)
//            }
//
//        } else {
//            if appoinmentDetail?.lat != "" && appoinmentDetail?.lng != ""  {
//                if appoinmentDetail?.lat == "0" {
//                    if (lblAddress.text != nil && lblAddress.text != "")  {
//                        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
//                            openGoogleMap(latitude: "", longitude: "",locationAddress: self.lblAddress.text!)
//                        } else  {
//                            openAppleMap(lat: "", long: "", locationAddress: self.lblAddress.text!)
//                        }
//                    } else {
//                        ShowError(message: AlertMessage.locationNotAvailable , controller: self)
//                    }
//                } else {
//                    if  UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
//                                       openGoogleMap(latitude: appoinmentDetail!.lat!, longitude: appoinmentDetail!.lng!)
//                                   } else  {
//                                     //  print(appintDetainsDicCommon!.lat!)
//                                       openAppleMap(lat: appoinmentDetail!.lat!, long: appoinmentDetail!.lng!)
//                                   }
//                }
//
//            } else {
//                ShowError(message: AlertMessage.locationNotAvailable , controller: self)
//            }
//        }

    }
    
    @IBAction func emailBtnAction(_ sender: Any) {
    }

    @IBAction func btnAddNew_Action(_ sender: Any) {
        if isSync == true {
            if !isHaveNetowork() {
                       DispatchQueue.main.async {
                          //self.lblAlertMess.isHidden = false
                          // self.collectionView.isHidden = true
                          //  self.lblAleartMsg.text = LanguageKey.err_check_network
                            ShowError(message: LanguageKey.err_check_network, controller: windowController)

                       }
                       return
                   }
             openGallary()
        }else{

        }

    }

    //==============================================================//
       // Data pass method
    //==============================================================//

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
//        if segue.identifier == "edit" {
//        if segue.destination is EditAppointmentVC
//        {
//            let vc = segue.destination as? EditAppointmentVC
//            vc?.editArrayData = appoinmentDetail
//        }
//    }

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

                                               // self.imgView.isHidden = true
                                                //self.HightTopView.constant = 55

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

                                                //self.imgView.isHidden = true
                                                //self.HightTopView.constant = 55

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
                                    let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeCommaSeparatedText),kUTTypeXls,kUTTypeXlsx,kUTTypeDOCX,kUTTypeDOC], in: .import)
                                    documentPicker.delegate = self
                                       APP_Delegate.showBackButtonTextForFileMan()
                                       self.present(documentPicker, animated: true, completion: nil)
                                   }

                                    actionSheetControllerIOS8.addAction(gallery)
                                    actionSheetControllerIOS8.addAction(camera)
                                    actionSheetControllerIOS8.addAction(document)
                                    self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
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
                        if let image = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{

                            DispatchQueue.main.async {
                                  let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
                                  let vc = storyboard.instantiateViewController(withIdentifier: "DocumentEditorVC") as! DocumentEditorVC
                                  vc.image = (image as! UIImage)
                                  vc.name = trimString(string: imgName)
                                  vc.callback = {(modifiedImage, imageName, imageDescription) in
                                    self.uploadImage = modifiedImage
//                                    self.uploadDocuments(imgName: imageName, imageDes: imageDescription) { () -> (Void) in
//                                        DispatchQueue.main.async {
//                                             vc.navigationController?.popViewController(animated: true)
//                                        }
//                                    }
                                }
                                  self.navigationController!.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }


    func convertTimestampToDateFormate( timeInterval : String) -> String{

        if timeInterval != "" {
            let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              //  dateFormatter.dateFormat = "HH:mm a"
                //dateFormatter.locale = Locale(identifier: "en_US")
                if let langCode = getCurrentSelectedLanguageCode() {
                    dateFormatter.locale = Locale(identifier: langCode)
                }
                let strTime = dateFormatter.string(from: date as Date)


                return strTime
        }

        return " "
    }

       //=====================================
       // MARK:- Document upload Service
       //=====================================

//  func uploadDocuments(imgName : String, imageDes : String, completion : @escaping (()->(Void))) -> Void {
//
//           if !isHaveNetowork() {
//               DispatchQueue.main.async {
//                   ShowError(message: AlertMessage.checkNetwork, controller: windowController)
//               }
//               return
//           }
//
//           showLoader()
//           let param = Params()
//           param.usrId = getUserDetails()?.usrId
//           param.appId = appoinmentDetail?.commonId
//           param.type = "2"
//           param.device_Type = "2"
//           param.des = imageDes
//
//
//           serverCommunicatorUplaodImage(url: Service.uploadAppmtDocument, param: param.toDictionary, image: uploadImage, imagePath: "ja", imageName: imgName) { (response, success) in
//               if(success){
//                   let decoder = JSONDecoder()
//
//                   completion()
//
//                   if let decodedData = try? decoder.decode(AppoimentDocumentRes.self, from: response as! Data) {
//                       if decodedData.success == true{
//                           DispatchQueue.main.async{
//
//                               killLoader()
//
//                               if(decodedData.data!.count > 0){
//                                   self.lblAleartMsg.isHidden = true
//                                   self.imgEmtAttch.isHidden = true
//                                   self.collectionView.isHidden = false
//                                   self.arrOfShowData?.attachments?.insert(decodedData.data![0], at: 0)
//                                   self.collectionView.reloadData()
//                                   ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
//
//                               }else{
//                                   killLoader()
//                                   ShowAlert(title: LanguageKey.success, message:getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
//                               }
//                           }
//                       }else{
//                           killLoader()
//                           if let code =  decodedData.statusCode{
//                               if(code == "401"){
//                                   ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
//                                       if (Ok){
//                                           DispatchQueue.main.async {
//                                               (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
//                                           }
//                                       }
//                                   })
//                               }
//                           }else{
//                               ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
//                           }
//                       }
//                   }else{
//                       killLoader()
//                       ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
//                   }
//               }else{
//                   killLoader()
//                   ShowError(message: errorString, controller: windowController)
//               }
//           }
//       }


    // contact view detail

    @IBAction func btnCall_Action(_ sender: Any) {
        if ((appoinmentDetail?.mob1 == "") && (appoinmentDetail?.mob2 == "")) {
                   ShowError(message: AlertMessage.contactNotAvailable , controller: windowController)
                   return
               }


               showBackgroundView()
               view.addSubview(viewContact)
               viewContact.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)


    }

    @IBAction func btnMail_Action(_ sender: Any) {

        if appoinmentDetail?.email == nil || appoinmentDetail?.email == "" {
            ShowError(message: AlertMessage.emailNotAvailable, controller: self)
            return
        }

        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            APP_Delegate.showBackButtonText()
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        showBackgroundView()
                  view.addSubview(emailView)
                  emailView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)

    }

    @IBAction func btnOk_Action(_ sender: Any) {
        self.hideBackgroundView()
    }

    @IBAction func btnEmail_Action(_ sender: Any) {
        self.hideBackgroundView()
    }


    //=====================================
    // MARK:- Map functionality
    //=====================================


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


            guard let url = URL(string: directionsRequest) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

        } else {
            if let address = locationAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                 let directionsRequest: String = "comgooglemaps://" + "?daddr=\(address)" + "&x-success=sourceapp://?resume=true&x-source=AirApp"


                let directionsURL: NSURL = NSURL(string: directionsRequest)!
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(directionsURL as URL)) {
                    application.open(directionsURL as URL, options: [:], completionHandler: nil)
                }
            }
        }

    }

    //=====================================
    // MARK:- Get all Document List Service
    //=====================================

//    func getDocumentsList(){
//
//        if !isHaveNetowork() {
//            DispatchQueue.main.async {
//               //self.lblAlertMess.isHidden = false
//                self.collectionView.isHidden = true
//                 self.lblAleartMsg.text = LanguageKey.err_check_network
//
//             }
//            return
//        }
//
//
//        let param = Params()
//
//        param.appId = appoinmentDetail?.commonId
//
//        //print(param.toDictionary)
//
//        serverCommunicator(url: Service.getAppointmentDocument, param: param.toDictionary) { (response, success) in
//            killLoader()
//
//            if(success){
//                let decoder = JSONDecoder()
//                if let decodedData = try? decoder.decode(AddAppointmentRes.self, from: response as! Data) {
//                    DispatchQueue.main.async {
//
//                    }
//
//                    if decodedData.success == true {
//
//                        DispatchQueue.main.async{
//
//                                                  killLoader()
//
//                                                   self.collectionView.isHidden = false
//                                                   self.arrOfShowData  = decodedData.data!
//                                                   self.appIdData = self.arrOfShowData?.appId
//                                                   self.jobLabelId = self.arrOfShowData?.jobLabel
//
//                            if  self.jobLabelId == "" {
//                                  self.height_JobView.constant = 0
//                            }else{
//                                self.height_JobView.constant = 59
//
//                            }
//                                                   self.jobLabelOne.text = self.jobLabelId
//                                                   self.collectionView.reloadData()
//
//                                                  if (self.arrOfShowData?.attachments?.count)! == 0
//                                                        {
//                                                            self.collectionView.isHidden = true
//                                                           self.lblAleartMsg.text = LanguageKey.appointment_attach_msg//"Appointment Attechtment will apear here "
//                                                            self.imgEmtAttch.isHidden = false
//                                                        }else{
//                                                            self.collectionView.isHidden = false
//                                                     self.imgEmtAttch.isHidden = true
//                                                     self.lblAleartMsg.isHidden = true
//                                    }
//                         }
//
//                    }else{
//
//                         ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
//
//
//                    }
//                }else{
////                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
//                }
//            }else{
//                ShowError(message: errorString, controller: windowController)
//            }
//        }
//    }


    //=====================================
    // MARK:- Update Document Description
    //=====================================

    func updateDocumentDescription(documentid : String, documentDescription : String, completion : @escaping (()->(Void))) {


        if !isHaveNetowork() {
            DispatchQueue.main.async {

                self.collectionView.isHidden = true

            }
            return
        }


         showLoader()
        let param = Params()
        param.jaId = documentid
        param.des = documentDescription

        serverCommunicator(url: Service.updateDocument, param: param.toDictionary) { (response, success) in
            killLoader()

//            DispatchQueue.main.async {
//                if self.refreshControl.isRefreshing {
//                    self.refreshControl.endRefreshing()
//                }
//            }
//
            completion()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(CommonResponse.self, from: response as! Data) {
                    DispatchQueue.main.async {

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



}
extension AppoinmentDetailCltHstry: UICollectionViewDelegate,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

               if isSync == false {
                   return self.arrNotSyncImg.count
                } else {
             return  self.arrOfShowData?.attachments?.count ?? 0
          }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageDetailCell", for: indexPath as IndexPath) as! ImageDetailCell

        if isSync == false {

            let arrData = self.arrNotSyncImg[indexPath.row]
            if arrData is String && arrData != "" {


                              let dataDecoded:NSData = NSData(base64Encoded: arrData as! String, options: NSData.Base64DecodingOptions(rawValue: 0))!

                              let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!

                              cell.imageView.image = decodedimage


                    }
                } else {


        let docResDataDetailsObj = self.arrOfShowData?.attachments?[indexPath.row]

        cell.lblfileName.text = docResDataDetailsObj?.attachFileActualName
        if let img = docResDataDetailsObj?.attachThumnailFileName {
            let imageUrl = Service.BaseUrl + img
            cell.imageView.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: docResDataDetailsObj?.image_name ?? "unknownDoc"))
        }else{
            cell.imageView.image = UIImage(named: "unknownDoc")
        }
            if selectedRows.contains(indexPath.row){

                           cell.checkMarkBtn.isSelected = true
                                          }else{

                            cell.checkMarkBtn.isSelected = false
                                          }

                           cell.btnTap.addTarget(self, action: #selector(buttonTapped( sender: )), for: .touchUpInside)
                           cell.btnTap.tag = indexPath.row

        }
        return cell

    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            let docResDataDetailsObj = self.arrOfShowData?.attachments?[indexPath.row]


        if let fileUrl = URL(string: (Service.BaseUrl + docResDataDetailsObj!.attachFileName!)) {
                  let customView = CustomDocView.instanceFromNib() as? CustomDocView
                  let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
                      backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)

            customView!.setupMethod(url: fileUrl, image: nil, imageName: docResDataDetailsObj!.attachFileActualName ?? "", imageDescription:docResDataDetailsObj?.des ?? "") //docResDataDetailsObj.des ?? "")
                      customView?.completionHandler = {(editedName,editedDes) in

                          if docResDataDetailsObj!.des != editedDes {
                            self.updateDocumentDescription(documentid: docResDataDetailsObj?.attachmentId! ?? "", documentDescription: editedDes) {
                                docResDataDetailsObj?.des = editedDes
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


        }

    }

    @objc func buttonTapped(sender: UIButton) {

        if self.selectedRows.contains(sender.tag){
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: sender.tag)!)

        }else  {
            let pdf =  self.arrOfShowData?.attachments?[sender.tag].attachFileActualName

            let splitName = pdf?.split(separator: ".")
                 //  let name = splitName.first!
            let filetype = splitName?.last!.lowercased()
            if filetype == "pdf" || filetype == "doc" || filetype == "xlsx" || filetype == "csv" {
            ShowError(message: LanguageKey.select_doc_validation, controller: windowController)

            }else{
                   self.selectedRows.append(sender.tag)
            }


        }


                                           if  selectedRows.count == 0 {
                                            selectAllBtn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                                              self.selectAllBtn.isHidden = true
                                              self.exportBtn.isHidden = true
                                              self.height_ExportDoc.constant = 0
                                              self.height_Selectall.constant = 0

        } else{


                                             self.selectAllBtn.isHidden = false
                                             self.exportBtn.isHidden = false
                                             self.height_ExportDoc.constant = 30
                                             self.height_Selectall.constant = 26

        }

        if selectedRows.count ==  self.arrOfShowData?.attachments?.count{
             self.selectAllBtn.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
        }

        DispatchQueue.main.async{
            self.collectionView.reloadData()
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

extension AppoinmentDetailCltHstry: UIDocumentPickerDelegate {

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
//                          self.uploadDocuments(imgName: imageName, imageDes: imageDescription) { () -> (Void) in
//                              DispatchQueue.main.async {
//                                   vc.navigationController?.popViewController(animated: true)
//                              }
//                          }
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
                  let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
                  let vc = storyboard.instantiateViewController(withIdentifier: "DocumentEditorVC") as! DocumentEditorVC
                  //vc.image = (image as! UIImage)
                  vc.name = trimString(string: String(name))
                  vc.docUrl = url
                  vc.callbackForDocument = {(fileName, fileDescription) in
//                    self.uploadMediaDocuments(fileUrl: url, fileName: fileName, description: fileDescription) { () -> (Void) in
//                         DispatchQueue.main.async {
//                             vc.navigationController?.popViewController(animated: true)
//                        }
//                    }

                }
                  self.navigationController!.pushViewController(vc, animated: true)
            }

        }

    }


//    func uploadMediaDocuments(fileUrl : URL ,fileName : String, description : String, completion : @escaping (()->(Void))) -> Void {
//
//        if !isHaveNetowork() {
//            DispatchQueue.main.async {
//                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
//            }
//            return
//        }
//
//        showLoader()
//        let param = Params()
//        param.usrId = getUserDetails()?.usrId
//        param.appId = appoinmentDetail?.commonId
//        param.type = "2"
//        param.device_Type = "2"
//        param.des = description
//
//        serverCommunicatorUplaodDocuments(url: Service.uploadAppmtDocument, param: param.toDictionary, docUrl: fileUrl, DocPathOnServer: "ja", docName: fileName) { (response, success) in
//
//            completion()
//
//            if(success){
//
//
//                let decoder = JSONDecoder()
//                if let decodedData = try? decoder.decode(AppoimentDocumentRes.self, from: response as! Data) {
//                    if decodedData.success == true{
//                        DispatchQueue.main.async{
//
//                            killLoader()
//
//                            if(decodedData.data!.count > 0){
//                               self.lblAleartMsg.isHidden = true
//                                 self.imgEmtAttch.isHidden = true
//                                   self.collectionView.isHidden = false
//                                self.arrOfShowData?.attachments?.insert(decodedData.data![0], at: 0)
//                                   self.collectionView.reloadData()
//                                   ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
//
//                            }else{
//                                killLoader()
//                                ShowAlert(title: LanguageKey.success, message:getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
//                            }
//                        }
//                    }else{
//                        killLoader()
//                        if let code =  decodedData.statusCode{
//                            if(code == "401"){
//                                ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
//                                    if (Ok){
//                                        DispatchQueue.main.async {
//                                            (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
//                                        }
//                                    }
//                                })
//                            }
//                        }else{
//                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
//                        }
//                    }
//                }else{
//                    killLoader()
//                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
//                }
//            }else{
//                killLoader()
//                ShowError(message: errorString, controller: windowController)
//            }
//        }
//
//    }


    //==================================
    // MARK:- JOB LIST Service methods
    //==================================

            func getQuoteListService(){

                if !isHaveNetowork() {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    return
                }



                var dates = ("","")
    //            if selectedDateRange != nil{
    //                dates = getDateFromStatus(dateRange: selectedDateRange!)
    //            }

                let param = Params()
                param.compId = getUserDetails()?.compId
                param.usrId = getUserDetails()?.usrId
                param.limit = ContentLimit
                param.index = "\(count)"
                param.search = searchTxt
                param.dtf = dates.0
                param.dtt = dates.1
                var dict = param.toDictionary
                dict!["status"] = selectedStatus
             //   print(dict!)

                serverCommunicator(url: Service.getAdminQuoteList, param: dict) { (response, success) in

                    DispatchQueue.main.async {
                        if self.refreshControl.isRefreshing {
                            self.refreshControl.endRefreshing()
                        }
                    }

                    if(success){
                        let decoder = JSONDecoder()

                        if let decodedData = try? decoder.decode(QuotationRes.self, from: response as! Data) {
                            if decodedData.success == true{

                                if self.count == 0 {
                                    self.arrOFData.removeAll()
                                    self.arrOFUserDataQuot.removeAll()
    //                                self.filterDict.removeAll()
    //                                self.arrOfFilterDict.removeAll()
                                }

                                if let arryCount = decodedData.data{
                                    //print(arr)
                                    if arryCount.count > 0{
                                        //self.quotation = decodedData
                                        self.arrOFUserDataQuot.append(contentsOf: decodedData.data!)

                                        self.count += (decodedData.data?.count)!
                                       // self.quotation = decodedData.data as! [QuotationData]

                                    }else{
                                       // self.showDataOnTableView(query : "")
                                    }
                                }else{
                                   // self.showDataOnTableView(query : "")
                                }

                                if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                                    //self.resetFilterOptions()
                                    self.getQuoteListService()
                                }else{
                                    killLoader()


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
                                    self.getQuoteListService()
                                }
                            })
                        }
                    }else{
                        ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                            if cancelButton {
                                showLoader()
                                self.getQuoteListService()
                            }
                        })
                    }
                }
            }


         //====================================================
        //MARK:-  Edit Appointment
        //====================================================

//        func UpadateAppointment(){
//
//            let param = Params()
//            param.cltId = appoinmentDetail?.cltId
//            param.conId = appoinmentDetail?.conId
//            param.siteId = appoinmentDetail?.siteId
//            param.appId = appoinmentDetail?.commonId
//            param.nm = appoinmentDetail?.nm
//            param.des = appoinmentDetail?.des//txtDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.email = appoinmentDetail?.email//txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.mob1 = appoinmentDetail?.mob1//txtMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.mob2 = appoinmentDetail?.mob2//txtField_AltMobNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.adr = appoinmentDetail?.adr//txtAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.cnm = appoinmentDetail?.cnm//txtClientName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.city = appoinmentDetail?.city//txtCityName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            param.zip = appoinmentDetail?.des
//            param.memIds = (FltWorkerId.count == 0 ? [] : FltWorkerId)
//            param.clientForFuture = ""
//            param.siteForFuture = "0"
//            param.contactForFuture = "0"
//            param.status = "9"
//
//    //        var schTime12 = ""
//    //        var endTime12 = ""
//    //
//    //        let dateFormatter = DateFormatter()
//    //        dateFormatter.dateFormat = "h:mm a"
//    //        if let langCode = getCurrentSelectedLanguageCode() {
//    //            dateFormatter.locale = Locale(identifier: langCode)
//    //        }
//    //        let date = dateFormatter.date(from: self.lblStartTime.text!)
//    //        dateFormatter.dateFormat = "HH:mm:ss"
//    //        schTime12 = dateFormatter.string(from: date!)
//    //
//    //
//    //        let dateFormatter1 = DateFormatter()
//    //        dateFormatter1.dateFormat = "h:mm a"
//    //        if let langCode = getCurrentSelectedLanguageCode() {
//    //            dateFormatter1.locale = Locale(identifier: langCode)
//    //        }
//    //        let date1 = dateFormatter1.date(from: self.lblEndTime.text!)
//    //        dateFormatter1.dateFormat = "HH:mm:ss"
//    //        endTime12 = dateFormatter1.string(from: date1!)
//    //
//    //
//    //        param.schdlStart =  (self.lblStartDate.text! + " " + schTime12)
//    //        param.schdlFinish =  (self.lblEndDate.text! + " " + endTime12)
//
//    //        var schdlStartDateTime = ""
//    //        var schdlFinishDateTime = ""
//    //
//    //        if param.schdlStart != "" {
//    //            schdlStartDateTime = convertDateStringToTimestampAppoiment(dateString: (appintDetainsDicCommon?.schdlStart)!)
//    //        }
//    //
//    //        if param.schdlFinish != "" {
//    //            schdlFinishDateTime = convertDateStringToTimestampAppoiment(dateString: (appintDetainsDicCommon?.schdlFinish)!)
//    //        }
//            //
//
//
//            var invDate : String = ""
//            var dueDate : String = ""
//
//
//            let startDate = appoinmentDetail?.schdlStart
//            dueDate = convertTimeStampToString(timestamp:startDate!, dateFormate:DateFormate.dd_MM_yyyy_HH_mm_ss)
//            let endDate = appoinmentDetail?.schdlFinish
//            invDate = convertTimeStampToString(timestamp:endDate!, dateFormate:DateFormate.dd_MM_yyyy_HH_mm_ss)
//            //dueDate = convertDateToStringForServer(date: startDate, dateFormate: DateFormate.dd_MM_yyyy_hh_mm_ss_a)
//            param.schdlStart = appoinmentDetail?.schdlStart
//            param.schdlFinish = appoinmentDetail?.schdlFinish
//
//
//            let searchQuery = "appId = '\(appoinmentDetail?.commonId! ?? "")'"
//            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: searchQuery) as! [AppointmentList]
//            if isExist.count > 0 {
//                let existingJob = isExist[0]
//                existingJob.setValuesForKeys(param.toDictionary!)
//                existingJob.kpr = (FltWorkerId.count == 0 ? [] : FltWorkerId) as NSObject?
//
//            }
//
//
//            DatabaseClass.shared.saveEntity(callback: {isSuccess in
//
//                param.schdlStart =  dueDate
//                param.schdlFinish = invDate
//
//                DatabaseClass.shared.saveOffline(service: Service.updateAppointment, param: param)
//               // self.navigationController?.popToRootViewController(animated: true)
//            })
//
//
//        }

}


