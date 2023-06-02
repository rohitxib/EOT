//
//  DetailJobVC.swift
//  EyeOnTask
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import MessageUI
import ContactsUI
import CoreData
import CoreLocation
import MapKit
import FirebaseAuth


class DetailJobVC: UIViewController, MFMailComposeViewControllerDelegate, OptionViewDelegate ,YPSignatureDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var instrucn_H: NSLayoutConstraint!
    @IBOutlet weak var travelTimeImg: UIImageView!
    @IBOutlet weak var actualDropDwnImg: UIImageView!
    @IBOutlet weak var actualTimeImage: UIImageView!
    @IBOutlet weak var travelCompView_H: NSLayoutConstraint!
    @IBOutlet weak var actualCompView_H: NSLayoutConstraint!
    @IBOutlet weak var editTravelCompDetail: UIButton!
    @IBOutlet weak var editActualComDetail: UIButton!
    @IBOutlet weak var complationCancelBtn: UIButton!
    @IBOutlet weak var complationDetailView: UIView!
    @IBOutlet weak var tittleLbl: UILabel!
    @IBOutlet weak var compltnStartDateLbl: UILabel!
    @IBOutlet weak var compltnStartDate: UILabel!
    @IBOutlet weak var compltnEndDateLbl: UILabel!
    @IBOutlet weak var compltnEndDate: UILabel!
    @IBOutlet weak var compltnDetailSaveBtn: UIButton!
    @IBOutlet weak var actualJobVw_H: NSLayoutConstraint!
    @IBOutlet weak var actualJobLbl: UILabel!
    @IBOutlet weak var actualstartDateTmLbl: UILabel!
    @IBOutlet weak var actualendDateTmLbl: UILabel!
    @IBOutlet weak var travelJobVw_H: NSLayoutConstraint!
    @IBOutlet weak var travelJobLbl: UILabel!
    @IBOutlet weak var travelStartDateTmLbl: UILabel!
    @IBOutlet weak var travelEndDateTmLbl: UILabel!
    @IBOutlet weak var H_itemLbl: NSLayoutConstraint!
    @IBOutlet weak var H_addItemBtn: NSLayoutConstraint!
    @IBOutlet weak var prntJobCardView: UIView!
    @IBOutlet weak var emailJobCrdView: UIView!
    @IBOutlet weak var addEquipmentBtnActn: UIButton!
    @IBOutlet weak var equipmentLbl: UILabel!
    @IBOutlet weak var addItemBtnActn: UIButton!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var selectSingnatureTxtFld: FloatLabelTextField!
    @IBOutlet weak var selectTemplateTxtFld: FloatLabelTextField!
    @IBOutlet weak var selectSingnatureView: UIView!
    @IBOutlet weak var defaultJobCrdView: UIView!
    @IBOutlet weak var selectTmpltLbl: UILabel!
    @IBOutlet weak var H_equipmentView: NSLayoutConstraint!
    @IBOutlet weak var smallSingView: UIView!
    @IBOutlet weak var uploadSinngBtn: UIButton!
    @IBOutlet weak var H_singnatureView: NSLayoutConstraint!
    @IBOutlet weak var singnatureView: UIView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var equipmntTableView: UITableView!
    @IBOutlet weak var equipmentView: UIView!
    @IBOutlet weak var H_attechmntView: NSLayoutConstraint!
    @IBOutlet weak var attchmentView: UIView!
    @IBOutlet weak var recurMsgHieght: NSLayoutConstraint!
    @IBOutlet weak var recurMsgBtn: UIButton!
    @IBOutlet weak var recurMsgView: UIView!
    @IBOutlet weak var lblRecurMsg: UILabel!
    @IBOutlet weak var jobRecurLbl: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var disView: UIView!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var complationView: UIView!
    @IBOutlet weak var customFldView: UIView!
    @IBOutlet weak var fielfWrkrView: UIView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var jobRecrView: UIView!
    @IBOutlet weak var naviBackBtn: UIButton!
    @IBOutlet weak var emailtextSend: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var poNumbetLbl: UILabel!
    @IBOutlet weak var poNumber: UILabel!
    @IBOutlet weak var lingQuatBtn: UIButton!
    @IBOutlet var mailPerView: UIView!
    @IBOutlet weak var titleTagVw: ASJTagsView!
    @IBOutlet weak var lblMapNotFound: UILabel!
    @IBOutlet weak var TimeLblSecond: UILabel!
    @IBOutlet weak var compTop_H: NSLayoutConstraint!///////c
    @IBOutlet weak var complationLbl_H: NSLayoutConstraint!
    @IBOutlet weak var complationNts_H: NSLayoutConstraint!
    @IBOutlet weak var selfNmLbl: UILabel!
    @IBOutlet weak var AdrsNotFound: UILabel!
    @IBOutlet weak var defaultMapView: UIView!
    @IBOutlet weak var statusJobView: UILabel!
    @IBOutlet weak var singlLbl: UILabel!
    @IBOutlet weak var singnatureImg: UIImageView!
    @IBOutlet weak var collectImgCount: UILabel!
    @IBOutlet weak var collectionTblView: UICollectionView!
    @IBOutlet weak var desNotsTop_H: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblPrintJobCrd: UILabel!
    @IBOutlet weak var emailJobCrd_H: NSLayoutConstraint!
    @IBOutlet weak var printJobCrd_H: NSLayoutConstraint!
    @IBOutlet weak var customerSingOnJobCrd: UILabel!
    @IBOutlet weak var uploadSingLbl_H: NSLayoutConstraint!
    @IBOutlet weak var signaturePadView: YPDrawSignatureView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet var costomerSingView: UIView!
    @IBOutlet weak var uploadCustomerSing: UILabel!
    @IBOutlet weak var printJobLbl: UILabel!
    @IBOutlet weak var emailJobLbl: UILabel!
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
    @IBOutlet weak var schedulerAndOtherLbl: UILabel!
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
    @IBOutlet weak var instLbl: UITextView!
    @IBOutlet weak var lblLocation1: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblJobCode: UILabel!
    @IBOutlet weak var topViewConnect: NSLayoutConstraint!//c
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
    @IBOutlet weak var tagBigView: UIView!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var contactNmaeLbl: UILabel!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var descriptionHeadingLbl: UILabel!
    @IBOutlet weak var btnMob1: UIButton!
    @IBOutlet weak var btnMob2: UIButton!
    @IBOutlet weak var jobCardBtn: UIButton!
    @IBOutlet weak var H_statusVwBottom: NSLayoutConstraint!//c
    @IBOutlet weak var H_statusVw: NSLayoutConstraint!//c
    @IBOutlet weak var statusVw: UIView!
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
    @IBOutlet weak var quatView: UIView!
    @IBOutlet weak var quatTitleLbl: UILabel!
    @IBOutlet weak var quatLbl: UILabel!
    @IBOutlet weak var quatView_H: NSLayoutConstraint!
    @IBOutlet weak var bottemQuatVw_H: NSLayoutConstraint!//n
    @IBOutlet var firstViewHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var scrollVw: UIScrollView!
  
    var complitationHightView = false
    var TravelVelidationEditTm = false
    var isEditJobAndTravelTime = true
    var isaForActualAadTravel = Bool()
    var isactualAndTravel = Bool()
    var poIdNam = ""
    var equipmentsStatus = [getEquipmentStatusDate]()
    var actualStartDateTimeFor = ""
    var actualEndDateTimeFor = ""
    var travelStartDateTimeFor = ""
    var travelEndDateTimeFor = ""
    var completionDetailArr = [LocationObject1]()
    var travelEndDateTime:Bool = false
    var travelStartDateTime:Bool = false
    var actualEndDateTime:Bool = false
    var actualStartDateTime:Bool = false
    var itemDetailedData = [ItemDic]()
    var isUserfirstLogin = Bool()
    var count : Int = 0
    var count1 : Int = 0
    var searchTxt = ""
    var selectedStatus : [String] = []
    var arrOFData = [QuotationData]()
    var onHold:Bool = false
    var new:Bool = false
    var accepted:Bool = false
    var reject:Bool = false
    var cancel:Bool = false
    var travelling:Bool = false
    var break1:Bool = false
    var inProgress:Bool = false
    var completed:Bool = false
    var jobBreak:Bool = false
    var CustomStatus:Bool = false
    var arrOFUserDataQuot = [QuotationData]()
    var rejectVelue = "0"
    var confirmationTriggerArray = [String]()
    var emailSendStatus = ""
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var imgName = ""
    var arrOfShowDataCom = [DocResDataDetails]()
    var dateStr = ""
    var isJobCardEnableMobile = true
    var isCompNmShowMobile = true
    var isQuoteNoShowOnJob = true
    var latitude1:Double = 0.0
    var longitude2:Double = 0.0
    var isDisableCustomSing = true
    var arrOfShowData = [CustomFormDetals]()
    var arrOfShowDatas : GetDetail!
    var objOFTestVC : TestDetails?
    var Strjhing = String()
    var Strjhings = String()
    var callbackDetailVC: ((Bool,NSManagedObject) -> Void)?
    var optionalVw : OptionalView?
    var jobArray = [UserJobList]()
    var arrOfCustomForm = [TestDetails]()
    var jobStatusArr = [JobStatusList]()
    
    var arrTypeStatusPermitionRevi : [taskStatusType] = [.Reschedule, .Reject, .Cancel, .InProgress, .OnHold, .Completed,.JobBreak] //-Revisit
    var arrTypeStatus : [taskStatusType] = [.Reschedule, .Revisit,.Reject, .Cancel, .InProgress, .OnHold, .Completed,.JobBreak]
    var arrTypeStatus1 : [taskStatusType] = [.Reschedule, .Revisit, .Cancel, .InProgress, .OnHold, .Completed,.JobBreak] //-reject
    var arrTypeStatusPermitionRevi1 : [taskStatusType] = [.Reschedule, .Cancel, .InProgress, .OnHold, .Completed,.JobBreak] //-Revisit,.Reject
    var Reject = LanguageKey.reject
    var Cancel = LanguageKey.cancel
    var InProgress = LanguageKey.In_progress
    var OnHold = LanguageKey.new_on_hold
    var Completed = LanguageKey.completed
    var Reschedule = LanguageKey.reschedule
    var Revisit = LanguageKey.require_revisit
    var JobBreak = LanguageKey.on_hold
    var revisiteOne = LanguageKey.revisit
    var titelArr = [String]()
    var objOfUserJobListInDetail : UserJobList?
    var isFirst = Bool()
    var isComplite = true
    var isTapped = true
    var animator = UIViewPropertyAnimator()
    var rectAcceptBtn = CGRect()
    var rectDeclineBtn = CGRect()
    var lattitude : String? = nil
    var longitude : String? = nil
    var currentStatusID : String? = nil
    var job : UserJobList?
    var statusId : taskStatusType?
    var sltDate : String? = ""
    var jobLocation = CLLocationCoordinate2D()
    var arr = [getQuestionsBy]()
    var arre : getQuestionsBy?
    var acceptStatus = "false"
    var isCompliteBool = "false"
    var isCustomStatusBool = "false"
    var add_custom_recur = LanguageKey.add_custom_recur
    var custom_recur_msg1 = LanguageKey.custom_recur_msg1
    var starting_on = "day(s)starting on"
    var custom_recur_msg2 = LanguageKey.custom_recur_msg2
    var custom_recur_msg3 = LanguageKey.custom_recur_msg3
    var infinity = LanguageKey.infinity
    var weeks_on = LanguageKey.weeks_on
    var schel_start = LanguageKey.schel_start
    var imgCount:Int = 0
    var PurchaseOrderArrList1 = [PurchaseOrderList]()
    var equipDataPartArr = [equipDataPartArray]()
    var equipmentData = [equipDataArray]()
    var filterequipmentData = [equipDataArray]()
    var isDropDwon = true
    var equipIdName = ""
    var buttonIsSelected = false
    var arrayType =  ""
    var demoArr1 = ["1","2","3"]
    var demoArr2 = ["A","B","C"]
    var arrDemo = ["a","b","c"]
    var fwArr = [Any]()
    var JobCardTemplatArr = [JobCardTemplat]()
    var JobCompletionDetailArr = [getJobCompletionDetailData]()
    var templateId = ""
    var templateVelue = ""
    var jobIdPrint  = [Any]()
    var defaultTechIdSet = ""
    var jobIdPrint1  = ""
    let isfooter = getDefaultSettings()?.footerMenu
    let JobItemQuantityFormEnable = getDefaultSettings()?.isJobItemQuantityFormEnable
    var buttonSwitched : Bool = true
    var reshualArr = false
    var shedulerId =  false
    // - JobStatus -----
    
    var dispatchIsShow = ""
    var dispatchIsSelect = ""
    var acceptedIsShow = ""
    var acceptedIsSelect = ""
    var rejectIsShow = ""
    var rejectIsSelect = ""
    var cancelIsShow = ""
    var cancelIsSelect = ""
    var travelingIsShow = ""
    var travelingIsSelect = ""
    var breakIsShow = ""
    var breakIsSelect = ""
    var inProgressIsShow = ""
    var inProgressIsSelect = ""
    var jobBreakIsShow = ""
    var jobBreakIsSelect = ""
    var CompletedIsShow = ""
    var CompletedIsSelect = ""
    var closedIsShow = ""
    var closedIsSelect = ""
    var multiStatusIsShow = ""
    var multiStatusIsSelect = ""
    var onHoldIsShow = ""
    var onHoldIsSelcet = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        PurchaseOrderArrList1 = DatabaseClass.shared.fetchDataFromDatabse(entityName: "PurchaseOrderList", query: nil) as! [PurchaseOrderList]
       
        getJobStatusList()
        
        self.jobStatusArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
         
        self.instructionView.isHidden = true
        self.instrucn_H.constant = 0
        self.actualstartDateTmLbl.isHidden = true
        self.actualendDateTmLbl.isHidden = true
        self.editActualComDetail.isHidden = true
        self.travelJobLbl.isHidden = true
        self.travelStartDateTmLbl.isHidden = true
        self.travelEndDateTmLbl.isHidden = true
        self.editTravelCompDetail.isHidden = true
        self.actualTimeImage.isHidden = true
        self.travelTimeImg.isHidden = true
        self.complationNts_H.constant = 240
        self.actualCompView_H.constant = 30
        
     
        isEditJobAndTravelTime = compPermissionVisible(permission: compPermission.isEditJobAndTravelTime)
        if isEditJobAndTravelTime == false {
            self.editTravelCompDetail.isHidden = true
            self.editActualComDetail.isHidden = true
        }else{
            
            if buttonSwitched == true {
                self.editTravelCompDetail.isHidden = true
                self.editActualComDetail.isHidden = true
            }else{
                self.editTravelCompDetail.isHidden = false
                self.editActualComDetail.isHidden = false
            }
         
        }
        getEquipmentStatus()
        getJobCompletionDetail()
        
        // Complitation Detail -
        
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "d-MMM-yyyy HH:mm a"
        dateFormmater.timeZone = TimeZone.current
        dateFormmater.locale = Locale(identifier: "en_US")
        actualstartDateTmLbl.text = LanguageKey.actual_start_date_time
        actualendDateTmLbl.text = LanguageKey.actual_end_date_time
        travelStartDateTmLbl.text = LanguageKey.travel_start_date_time
        travelEndDateTmLbl.text = LanguageKey.travel_end_date_time
        
        // FOR ITEM PART IS HIDEN :-
        let  isItem = isPermitForShow(permission: permissions.isItemVisible)
        if isfooter?.count != nil {
            for i in 0 ..< isfooter!.count{
                if i < 4 {
                    
                    if isfooter![i].isEnable == "1"{
                        if JobItemQuantityFormEnable == "0" {
                            if isItem && isfooter![i].menuField == "set_itemMenuOdrNo"{
                                self.addItemBtnActn.isHidden = false
                                self.itemLbl.isHidden = false
                            }
                        }
                        
                    }else{
                        
                        self.addItemBtnActn.isHidden = true
                        self.itemLbl.isHidden = true
                        self.H_attechmntView.constant = 0
                        self.H_itemLbl.constant = 0
                        self.H_addItemBtn.constant = 0
                        
                    }
                    
                }
            }
        }
      
        getJobCardTemplates()
        
        let kprVar = objOfUserJobListInDetail?.kpr
        let kprArr = kprVar?.components(separatedBy: ",")
        var count : Int = 0
        var query : String = ""
        if kprArr?.count ?? 0 > 0 {
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
                fwArr.append(("\(String(describing: fw.fnm!)) \(String(describing: fw.lnm!))"))
                jobIdPrint.append(("\(String(describing: fw.usrId!))"))
                defaultTechIdSet = (("\(String(describing: fw.usrId!))"))
            }
        }
        self.itemTableView.dataSource = self
        self.itemTableView.delegate = self
        self.equipmntTableView.dataSource = self
        self.equipmntTableView.delegate = self
        
        var controllers = [UIViewController]()
    
        desTextView.isEditable = false
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationResive), name: Notification.Name ("DetailJobVC"), object: nil)
          let image = UIImage(named:"menu3Dots")
        
          let leftButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
          self.navigationItem.rightBarButtonItem = leftButton
      
       getQuoteListService()
        
       var  isSwitchOff =   UserDefaults.standard.value(forKey: "TokenOff") as? String ?? ""

        if (isSwitchOff == "Off") {
            
            selfNmLbl.isHidden = true
            
        }else{
            selfNmLbl.isHidden = false
        }
       
        var Notification = objOfUserJobListInDetail?.jobId
        UserDefaults.standard.set(Notification, forKey: "ForNotification")
        
         self.lblMapNotFound.isHidden = true
     self.AdrsNotFound.isHidden = true
     self.defaultMapView.isHidden = true
        
        getDocumentsList()
        
        let cellSize = CGSize(width:160 , height:105)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 1.0
        collectionTblView.setCollectionViewLayout(layout, animated: true)
        collectionTblView.reloadData()
        
        isCompNmShowMobile = compPermissionVisible(permission: compPermission.isCompNmShowMobile)
        isJobCardEnableMobile = compPermissionVisible(permission: compPermission.isJobCardEnableMobile)
        isDisableCustomSing = compPermissionVisible(permission: compPermission.isJcSignEnable)

        if isDisableCustomSing == false {
            self.H_singnatureView.constant = 0
            self.uploadSinngBtn.isHidden = true
            
        }else{
            if objOfUserJobListInDetail?.signature == "" {
                self.smallSingView.isHidden = true
                self.uploadSinngBtn.isHidden = false
                self.H_singnatureView.constant = 50
            }else{
                self.uploadSinngBtn.isHidden = true
                self.H_singnatureView.constant = 121
                self.smallSingView.isHidden = false
            }
        }
        
        if isJobCardEnableMobile == false {
            self.prntJobCardView.isHidden = true
            self.emailJobCrdView.isHidden = true
        }
        
        if isCompNmShowMobile == false {
         
            self.nameLbl.isHidden = true
        }
        
        self.quatView.layer.cornerRadius = 8
        self.quatView.layer.shadowColor = UIColor.black.cgColor
        self.quatView.layer.shadowOpacity = 0.1
        self.quatView.layer.shadowRadius = 5
        
        self.addressView.layer.cornerRadius = 8
        self.addressView.layer.shadowColor = UIColor.black.cgColor
        self.addressView.layer.shadowOpacity = 0.1
        self.addressView.layer.shadowRadius = 5
        
        self.contactView.layer.cornerRadius = 8
        self.contactView.layer.shadowColor = UIColor.black.cgColor
        self.contactView.layer.shadowOpacity = 0.1
        self.contactView.layer.shadowRadius = 5
        
        self.statusView.layer.cornerRadius = 8
        self.statusView.layer.shadowColor = UIColor.black.cgColor
        self.statusView.layer.shadowOpacity = 0.1
        self.statusView.layer.shadowRadius = 5
        
        self.disView.layer.cornerRadius = 8
        self.disView.layer.shadowColor = UIColor.black.cgColor
        self.disView.layer.shadowOpacity = 0.1
        self.disView.layer.shadowRadius = 5
        
        self.fielfWrkrView.layer.cornerRadius = 8
        self.fielfWrkrView.layer.shadowColor = UIColor.black.cgColor
        self.fielfWrkrView.layer.shadowOpacity = 0.1
        self.fielfWrkrView.layer.shadowRadius = 5
        
        self.instructionView.layer.cornerRadius = 8
        self.instructionView.layer.shadowColor = UIColor.black.cgColor
        self.instructionView.layer.shadowOpacity = 0.1
        self.instructionView.layer.shadowRadius = 5
        
        self.complationView.layer.cornerRadius = 8
        self.complationView.layer.shadowColor = UIColor.black.cgColor
        self.complationView.layer.shadowOpacity = 0.1
        self.complationView.layer.shadowRadius = 5
        
        self.customFldView.layer.cornerRadius = 8
        self.customFldView.layer.shadowColor = UIColor.black.cgColor
        self.customFldView.layer.shadowOpacity = 0.1
        self.customFldView.layer.shadowRadius = 5
        
        self.tagBigView.layer.cornerRadius = 8
        self.tagBigView.layer.shadowColor = UIColor.black.cgColor
        self.tagBigView.layer.shadowOpacity = 0.1
        self.tagBigView.layer.shadowRadius = 5
        
        self.jobRecrView.layer.cornerRadius = 8
        self.jobRecrView.layer.shadowColor = UIColor.black.cgColor
        self.jobRecrView.layer.shadowOpacity = 0.1
        self.jobRecrView.layer.shadowRadius = 5
        
        self.attchmentView.layer.cornerRadius = 8
        self.attchmentView.layer.shadowColor = UIColor.black.cgColor
        self.attchmentView.layer.shadowOpacity = 0.1
        self.attchmentView.layer.shadowRadius = 5
        
        self.equipmentView.layer.cornerRadius = 8
        self.equipmentView.layer.shadowColor = UIColor.black.cgColor
        self.equipmentView.layer.shadowOpacity = 0.1
        self.equipmentView.layer.shadowRadius = 5
        
        self.singnatureView.layer.cornerRadius = 8
        self.singnatureView.layer.shadowColor = UIColor.black.cgColor
        self.singnatureView.layer.shadowOpacity = 0.1
        self.singnatureView.layer.shadowRadius = 5
        
        var singImage = objOfUserJobListInDetail?.signature ?? ""
        if singImage != "" {
            if let img = objOfUserJobListInDetail!.signature {
                let imageUrl = Service.BaseUrl + img
                singnatureImg.sd_setImage(with: URL(string: imageUrl) )
            }else{
                singnatureImg.image = UIImage(named: "unknownDoc")
            }
        }
       
        showMap()
        
        signaturePadView.delegate = self
        self.signaturePadView.layer.zPosition = 1
        
         if isPermitForShow(permission: permissions.isRecur) == false{
            
            self.recurMsgView.isHidden = true
            
         }else{
            
             self.recurMsgView.isHidden = false
         }
     
        if objOfUserJobListInDetail!.recurData != nil {
            if objOfUserJobListInDetail!.recurData as! Array<NSObject?> == [] {
            recurMsgView.isHidden = true
            }
        }
       
        self.backGroundBtn.isHidden = true
        self.emailView.isHidden = true
        self.complationDetailView.isHidden = true
        self.item_Height.constant = 0
        self.equip_Height.constant = 0
        self.attechmentImg.isHidden = true
        self.itemImg.isHidden = true
        self.equipmentImg.isHidden = true
       
        var isCustomFieldEnable = true

        getFormDetail()
        
        self.requestForVisite.isHidden = true
        
        if isPermitForShow(permission: permissions.isJobRescheduleOrNot) == true{
            self.rescheduleBtn.isHidden = true
            
        }else{
            self.rescheduleBtn.isHidden = false
        }
        
        self.locationTxtView.tintColor = UIColor.red
        setLocalization()
        setupMethod()
        setData ()
        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobDetails)
        getAllCompanySettings()
        setDataForItem()
        setDataforEquipment()
  
    }
 
    @objc func addTapped(){
        view.addSubview(emailView)
    }
    
    @objc func NotificationResive(){
         self.emailView.isHidden = false
         self.backGroundBtn.isHidden = false
    }
 
     //============================================
     // MARK: - Open MapView
     //============================================
        
    func showMap(){
        
        var str = objOfUserJobListInDetail?.lat!
        var str1 = objOfUserJobListInDetail?.lng!
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = str?.rangeOfCharacter(from: decimalCharacters)
        if str == "0" && str1 == "0"{
            self.lblMapNotFound.isHidden = false
            self.AdrsNotFound.isHidden = false
            self.defaultMapView.isHidden = false
         
        }else{
            self.lblMapNotFound.isHidden = false
            self.AdrsNotFound.isHidden = false
            self.defaultMapView.isHidden = false
            
            let latDelta:Double = 0.0
            let lngDelta:Double = 0.0
            self.mapView.mapType = MKMapType.standard
            
            let myStringLat =  objOfUserJobListInDetail?.lat!
            let myFloatLat = (myStringLat as! NSString).doubleValue
            let myStringLng =  objOfUserJobListInDetail?.lng!
            let myFloatLng = (myStringLng as! NSString).doubleValue
            
            let locationcoordinates = CLLocationCoordinate2D(latitude: myFloatLat, longitude: myFloatLng)
            let zoomSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: locationcoordinates, span: zoomSpan)
            
            if decimalRange != nil {
                self.lblMapNotFound.isHidden = true
                self.AdrsNotFound.isHidden = true
                self.defaultMapView.isHidden = true
                if myFloatLat <= 100 && myFloatLng <= 100 {
                    self.mapView.setRegion(region, animated: true)
                }
               
            }
            let annotaion  = MKPointAnnotation()
            annotaion.coordinate = locationcoordinates
            
            mapView.addAnnotation(annotaion)
        }
        
    }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationReuseId = "Place"
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseId)
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
            } else {
                anView!.annotation = annotation
            }
            anView?.image = UIImage(named: "placeholder")
            anView?.backgroundColor = UIColor.clear
            anView?.canShowCallout = false
            return anView
            
        }
    
    
    func setLocalization() -> Void {
   
        itemLbl.text = LanguageKey.item
        equipmentLbl.text = LanguageKey.equipment
        poNumbetLbl.text = LanguageKey.po_number
        quatTitleLbl.text = LanguageKey.quotes_details
        quatLbl.text = LanguageKey.quotes_num
        AdrsNotFound.text = LanguageKey.location_not_found
        statusJobView.text = LanguageKey.status_radio_btn
        singlLbl.text = LanguageKey.customer_signature
        lblJobCode.text = LanguageKey.job_code
        coustomFld.text = LanguageKey.title_cutom_field
        lblStatus.text = LanguageKey.status_radio_btn
        lblLocation1.text = LanguageKey.location
        lblDescription1.text = LanguageKey.description
        lblInstuction1.text = LanguageKey.instr
        lblContactName.text = LanguageKey.contact_details
        lblFieldworkers.text = LanguageKey.fieldworkers
        schedulerAndOtherLbl.text = LanguageKey.schedule_details
        lblTags.text = LanguageKey.job_tags
        btnInstructionView.setTitle(LanguageKey.view , for: .normal)
        viewBtn.setTitle(LanguageKey.view , for: .normal)
        mapBtn.setTitle(LanguageKey.get_direction, for: .normal)
        btnCancelPicker.setTitle(LanguageKey.cancel , for: .normal)
        btnDonePicker.setTitle(LanguageKey.done , for: .normal)
        btbOkDescription.setTitle(LanguageKey.ok , for: .normal)
        btnOkChat.setTitle(LanguageKey.ok , for: .normal)
        btnOkContact.setTitle(LanguageKey.ok , for: .normal)
        lblTitleCompletion.text = LanguageKey.completion_note
        rescheduleBtn.setTitle(LanguageKey.reschedule , for: .normal)
        requestForVisite.setTitle(LanguageKey.require_revisit , for: .normal)
        coustomFldBtn.setTitle(LanguageKey.add , for: .normal)
        emailJobLbl.text = LanguageKey.email_job_card
        printJobLbl.text = LanguageKey.print_job_card
        recurMsgBtn.setTitle(LanguageKey.stop_recur , for: .normal)
        jobRecurLbl.text = LanguageKey.job_recur
        uploadCustomerSing.text = LanguageKey.menu_upload_sign
        customerSingOnJobCrd.text = LanguageKey.customer_sign_head
        clearBtn.setTitle(LanguageKey.clear , for: .normal)
        uploadBtn.setTitle(LanguageKey.expense_upload , for: .normal)
        closeBtn.setTitle(LanguageKey.close , for: .normal)
        emailtextSend.text = LanguageKey.send_client_mail
        yesBtn.setTitle(LanguageKey.yes , for: .normal)
        noBtn.setTitle(LanguageKey.no , for: .normal)
        selectSingnatureTxtFld.placeholder = LanguageKey.tech_sign
        selectTemplateTxtFld.placeholder = LanguageKey.select_template
        addItemBtnActn.setTitle(LanguageKey.add , for: .normal)
        addEquipmentBtnActn.setTitle(LanguageKey.add , for: .normal)
        uploadSinngBtn.setTitle(LanguageKey.menu_upload_sign , for: .normal)
        editTravelCompDetail.setTitle(LanguageKey.edit , for: .normal)
        editActualComDetail.setTitle(LanguageKey.edit , for: .normal)
        complationCancelBtn.setTitle(LanguageKey.cancel , for: .normal)
        compltnDetailSaveBtn.setTitle(LanguageKey.save_btn , for: .normal)
    }
    
    func setData (){
        var recuDataArray = [TransVarData]()
        let searchQuery = "jobId = '\(objOfUserJobListInDetail?.jobId ?? "")'"
        let isExistRecur = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
        if isExistRecur.count > 0 {
            recuDataArray.removeAll()
            for recur in isExistRecur {
                
                if recur.recurData != nil {
                    for recurMsg in (recur.recurData as! [AnyObject]) {
                        //  print(recurMsg)
                        if let dicTransVar = recurMsg["transVar"] as? [String:String]{
                            let mode = dicTransVar["mode"]
                            let endRecurMode = dicTransVar["endRecurMode"]
                            let interval = dicTransVar["interval"]
                            let start_date = dicTransVar["startDate"]
                            let occurence = dicTransVar["occurences"]
                            let endDate = dicTransVar["endDate"]
                            let occur_days = dicTransVar["occur_days"]
                            let week_num = dicTransVar["week_num"]
                            let day_num = dicTransVar["day_num"]
                            let single_or_multi = dicTransVar["single_or_multi"]
                            
                            // for daily recur msg
                            
                            if objOfUserJobListInDetail!.recurType == "1"
                            {
                                if mode == "1" {
                                    if endRecurMode == "0"{
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: interval!)) \(self.starting_on) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(self.infinity)"
                                    }
                                    else if endRecurMode == "1" {
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: interval!)) \(self.starting_on) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(String(describing: occurence!)) \(self.custom_recur_msg3) \(String(describing: endDate!))"
                                        
                                    }else if endRecurMode == "2" {
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: interval!)) \(self.starting_on) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(String(describing: occurence!)) \(self.custom_recur_msg3) \(String(describing: endDate!))"
                                        
                                        
                                    }
                                }
                                
                                if mode == "2" {
                                    if endRecurMode == "0"{
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(("weekDay")) \(self.starting_on) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(self.infinity)"
                                    }
                                    else if endRecurMode == "1" {
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(("weekDay")) \(self.starting_on) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(String(describing: occurence!)) \(self.custom_recur_msg3) \(String(describing: endDate!))"
                                        
                                    }else if endRecurMode == "2" {
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(("weekDay")) \(self.starting_on) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(String(describing: occurence!)) \(self.custom_recur_msg3) \(String(describing: endDate!))"
                                        
                                        
                                    }
                                }
                                
                            }
                            // for Weekly recur msg
                            
                            else if objOfUserJobListInDetail!.recurType == "2"
                            {
                                if mode == "1" {
                                    if endRecurMode == "0"{
                                        
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: occur_days!)) \("every") \(interval!) \(single_or_multi!) \(self.schel_start) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(self.infinity)"
                                    }
                                    else if endRecurMode == "1" {
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: occur_days!)) \("every") \(String(describing: interval!)) \(single_or_multi!) \(self.schel_start) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                                        
                                    }else if endRecurMode == "2" {
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: occur_days!)) \("every") \(String(describing: interval!)) \(single_or_multi!) \(self.schel_start) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                                        
                                    }
                                }
                            }
                            
                            // for monthly recur msg
                            
                            else if objOfUserJobListInDetail!.recurType == "3" {
                                if mode == "1" {
                                    if endRecurMode == "0"{
                                        
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: week_num!)) \("every") \(interval!) \("month(s)") \(self.schel_start) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(self.infinity)"
                                    }
                                    else if endRecurMode == "1" {
                                        
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: week_num!)) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                                        
                                    }else if endRecurMode == "2" {
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: week_num!)) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                                        
                                    }
                                }
                                
                                if mode == "2" {
                                    
                                    if endRecurMode == "0"{
                                        
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(("weekDay")) \(self.starting_on) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(self.infinity)"
                                    }
                                    else if endRecurMode == "1" {
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: week_num!)) \(day_num!) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                                        
                                    }else if endRecurMode == "2" {
                                        lblRecurMsg.text! = "\(self.custom_recur_msg1) \(String(describing: week_num!)) \(day_num!) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: start_date!)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                }else {
                    recurMsgView.isHidden = true
                }
            }
        }
    }
    
    
    func setupMethod() -> Void {
        getJobStatusList()
        
        var someArray = [String]()
        if objOfUserJobListInDetail?.itemData  == someArray as NSObject {
            // print("iteam data nil")
            self.item_Height.constant = 0
            self.itemImg.isHidden = true
            
        }else{
            self.item_Height.constant = 14
            self.itemImg.isHidden = false
            self.itemImg.image = UIImage.init(named: "40x40")
            
        }
        
        if objOfUserJobListInDetail?.equArray == someArray as NSObject {
            
            self.equipmentImg.isHidden = true
            self.equip_Height.constant = 0
        }else{
            self.equip_Height.constant = 14
            self.equipmentImg.isHidden = false
            self.equipmentImg.image =  UIImage.init(named: "equip")
        }
        
        if objOfUserJobListInDetail?.attachCount == "0"  {
            self.attechmentImg.isHidden = true
            
        }else{
            if objOfUserJobListInDetail?.attachCount == nil  {
                self.attechmentImg.isHidden = true
            }else{
                
                self.attechmentImg.isHidden = false
                self.attechmentImg.image =  UIImage.init(named: "icons8@-attech")
                
            }
        }
        
        //for enable swipe functionality
        swipe()
        
        //Hide background view
        backgroundView.isHidden = true
        
        nameLbl.text = objOfUserJobListInDetail?.nm != nil ? objOfUserJobListInDetail?.nm : "Unknown"
        jobCodeLbl.text = objOfUserJobListInDetail?.label
        selfNmLbl.text = objOfUserJobListInDetail?.snm != nil ? objOfUserJobListInDetail?.snm : ""
        isQuoteNoShowOnJob = compPermissionVisible(permission: compPermission.isQuoteNoShowOnJob)
        
        if isQuoteNoShowOnJob == false {
            self.quatTitleLbl.isHidden = true
            self.quatLbl.isHidden = true
            self.quatView_H.constant = 0
        }else{
            self.quatTitleLbl.isHidden = false
            self.quatLbl.isHidden = false
            self.quatView_H.constant = 80
        }
        
        let kprVar1 = objOfUserJobListInDetail?.quotLabel
        
        if kprVar1 != "nill" {
            lingQuatBtn.setTitle(kprVar1 , for: .normal)
        }else{
            lingQuatBtn.setTitle("" , for: .normal)
        }
        
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
            self.selectSingnatureTxtFld.text = ("\(String(describing: fw.fnm!)) \(String(describing: fw.lnm!))")
        }
        
        if  nameArr.count  > 0 {
            
            self.fwTagsView.appendTags(nameArr as! [String], withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: false)
            
        }else{
            lblFieldworkers.text = ""
        }
        
        let adr = objOfUserJobListInDetail?.adr != "" ? objOfUserJobListInDetail?.adr : ""
        var ctry = objOfUserJobListInDetail?.ctry != "" ? objOfUserJobListInDetail?.ctry : ""
        var stt = objOfUserJobListInDetail?.state != "" ? objOfUserJobListInDetail?.state : ""
        let city = objOfUserJobListInDetail?.city != "" ? objOfUserJobListInDetail?.city : ""
        
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
        
        if  objOfUserJobListInDetail?.poId != "" {
            for poIdnm in PurchaseOrderArrList1 {
                
                if  poIdnm.poId == objOfUserJobListInDetail?.poId {
                    
                    self.poIdNam = poIdnm.poNum ?? ""
                    
                }
            }
            
            poNumber.text = poIdNam
            self.poNumbetLbl.isHidden = false
        }
        if  objOfUserJobListInDetail?.pono != "" {
            poNumber.text = objOfUserJobListInDetail?.pono
            self.poNumbetLbl.isHidden = false
        }else{
            self.poNumbetLbl.isHidden = true
            self.poNumber.text = ""
        }
        
        // Description and Instruction, Skype, Twitter ==============================
        if  objOfUserJobListInDetail?.des != "" {
            descriptionLbl.attributedText =  lineSpacing(string: (objOfUserJobListInDetail?.des?.capitalizingFirstLetter())!, lineSpacing: 7.0)
        }else{
            descriptionLbl.text = ""
        }
        
        if  objOfUserJobListInDetail?.complNote != nil && objOfUserJobListInDetail?.complNote != "" {
            
            if self.objOfUserJobListInDetail?.complNote != ""{
                self.complationNts_H.constant = 150
            }else{
                self.complationNts_H.constant = 110
            }
            
            btnAddNotes.setTitle(LanguageKey.edit, for: .normal)
            lblCompletiondetail.attributedText =  lineSpacing(string: (objOfUserJobListInDetail?.complNote?.capitalizingFirstLetter())!, lineSpacing: 7.0)
        }else{
            if objOfUserJobListInDetail?.complNote != nil && self.objOfUserJobListInDetail?.complNote != "" {
                self.complationNts_H.constant = 150
            }else{
                self.complationNts_H.constant = 80
            }
            btnAddNotes.setTitle(LanguageKey.add, for: .normal)
            lblCompletiondetail.text = ""
        }
        
        if  objOfUserJobListInDetail?.inst != "" {
            instLbl.attributedText =  lineSpacing(string: (objOfUserJobListInDetail?.inst?.capitalizingFirstLetter())!, lineSpacing: 7.0)
        }else{
            instLbl.text = ""
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
        if objOfUserJobListInDetail?.skype != nil && objOfUserJobListInDetail?.skype !=  ""{
            self.lbl_SkypeId.text = objOfUserJobListInDetail?.skype
        }else{
            self.lbl_SkypeId.text = LanguageKey.not_available
        }
        
        if objOfUserJobListInDetail?.twitter != nil && objOfUserJobListInDetail?.twitter !=  ""{
            self.lbl_TwitterId.text = objOfUserJobListInDetail?.twitter
        }else{
            self.lbl_TwitterId.text = LanguageKey.not_available
        }
        
        let strDate = dayDifferenceJobDetail(unixTimestamp: objOfUserJobListInDetail?.createDate ?? "")
        
        if objOfUserJobListInDetail?.schdlStart != "" {
            let tempTime = convertTimestampToDate(timeInterval: (objOfUserJobListInDetail?.schdlStart)!)
            let tempTime1 = convertTimestampToDate(timeInterval: (objOfUserJobListInDetail?.schdlFinish)!)
            
            let strDate = (objOfUserJobListInDetail?.schdlStart != nil) ? convertTimeStampToStringForDetailJob(timestamp: objOfUserJobListInDetail!.schdlStart!, dateFormate: DateFormate.dd_MMM_yyyy_HH_mm) : ""
            
            if (strDate != "") {
                let arr1 = strDate.components(separatedBy: " ")
                let start1 = LanguageKey.start
                let str = LanguageKey.end
                if arr1.count > 0 {
                    let arrLastDate1 = arr1[0]
                    timeLbl.text = "\(start1) :"+" \(arrLastDate1),"+" \(tempTime.0 + tempTime.1)"
                }
            }
            
            let endDate = (objOfUserJobListInDetail?.schdlFinish != nil) ? convertTimeStampToStringForDetailJob(timestamp: objOfUserJobListInDetail!.schdlFinish!, dateFormate: DateFormate.dd_MMM_yyyy_HH_mm) : ""
            
            if (endDate != "") {
                let arr = endDate.components(separatedBy: " ")
                let start = LanguageKey.start
                let end = LanguageKey.end
                if arr.count > 0 {
                    let arrLastDate = arr[0]
                    
                    TimeLblSecond.text = "\(end)  :"+" \(arrLastDate),"+" \(tempTime1.0 + tempTime1.1)"
                }
            }
            
        } else {
            timeLbl.text = ""
            TimeLblSecond.text = ""
        }
        
        
        if objOfUserJobListInDetail?.prty != "0" {
            let priorityDetail = taskPriorityImage(Priority: taskPriorities(rawValue: Int((objOfUserJobListInDetail?.prty)!)!)!)
            priorityLbl.text = priorityDetail.0
            
        }
        
        if let statusId = objOfUserJobListInDetail?.status {
            
            for arr in jobStatusArr {
                if arr.id == statusId {
                    lblTaskStatus.text = arr.text
                }
            }
            
            currentStatusID = objOfUserJobListInDetail?.status
            DispatchQueue.main.async {
                self.rectAcceptBtn = self.acceptBtn.frame
                self.rectDeclineBtn = self.declineBtn.frame
                self.isFirst = true
                self.ChangeButtonsAccordingToStatusType(status: statusId == "Reschedule" ? "1" : (statusId))
                
                self.isFirst = false
            }
        }else {
            lblTaskStatus.text = ""
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
        
        if (objOfUserJobListInDetail?.tagData != nil  && (objOfUserJobListInDetail?.tagData as! [Any]).count > 0 ){
            for tag in (objOfUserJobListInDetail?.tagData as! [Any]) {
                self.tagsView.appendTags([(tag as! [String:String])["tnm"]!], withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: false)
            }
        }
        
        
        var strTitle = ""
        for jtid in (objOfUserJobListInDetail?.jtId as! [AnyObject]) {
            if strTitle == ""{
                strTitle = (jtid as! [String:String])["title"]!
                titelArr.append(strTitle)
            }else{
                strTitle = "\((jtid as! [String:String])["title"]!)"
                titelArr.append(strTitle)
            }
        }
        
        if  titelArr.count  > 0 {
            
            self.titleTagVw.appendTags(titelArr as! [String], withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: false)
            
        }else{
            descriptionLbl.text = ""
        }
        
        if objOfUserJobListInDetail?.des == nil || objOfUserJobListInDetail?.des == "" {
            self.desTextView_H.constant = 0
            self.lblDescription1.isHidden = true
            self.desTextView.isHidden = true
            
            return
        }
        
        self.lblDescription1.isHidden = false
        self.desTextView.isHidden = false
        if objOfUserJobListInDetail?.des == "Job Description" {
            
            self.desTextView_H.constant = 100
            
            DispatchQueue.global(qos: .background).async {
                let htmlString = self.objOfUserJobListInDetail?.des
                let attributedString = htmlString!.htmlToAttributedString
                DispatchQueue.main.async {
                    self.desTextView.attributedText = attributedString
                    killLoader()
                    
                }
            }
        }else{
            showLoader()
            
            self.desTextView_H.constant = 200
            
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

    @objc func done() { // remove @objc for Swift 3

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if isCustomFormListSelected == true {
            return
        } else {
            getEquipmentStatus()
        }
        getJobCompletionDetail()
        setDataforEquipment()
        setDataForItem()
        self.backGroundBtn.isHidden = true
        //setNavigationBar()
        let image = UIImage(named:"menu3Dots")
        let leftButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = leftButton
        
        navigationController?.setNavigationBarHidden(false, animated: animated)

       var UpDateStr = UserDefaults.standard.value(forKey: "UpDateStr") as? String ?? ""
        let strDate = dayDifferenceJobDetail(unixTimestamp: objOfUserJobListInDetail?.createDate ?? "")
         
        if objOfUserJobListInDetail?.schdlStart != "" && objOfUserJobListInDetail?.schdlStart != nil{
             let tempTime = convertTimestampToDate(timeInterval: (objOfUserJobListInDetail?.schdlStart)!)
             let tempTime1 = convertTimestampToDate(timeInterval: (objOfUserJobListInDetail?.schdlFinish)!)
             
            let strDate = (objOfUserJobListInDetail?.schdlStart != nil) ? convertTimeStampToStringForDetailJob(timestamp: objOfUserJobListInDetail!.schdlStart!, dateFormate: DateFormate.dd_MMM_yyyy_HH_mm) : ""
          
            if (strDate != "") {
                let arr1 = strDate.components(separatedBy: " ")
                let start1 = LanguageKey.start
                let str = LanguageKey.end
                if arr1.count > 0 {
                   let arrLastDate1 = arr1[0]
                    timeLbl.text = "\(start1) :"+" \(arrLastDate1),"+" \(tempTime.0 + tempTime.1)"
                  
                }
            }
            
            let endDate = (objOfUserJobListInDetail?.schdlFinish != nil) ? convertTimeStampToStringForDetailJob(timestamp: objOfUserJobListInDetail!.schdlFinish!, dateFormate: DateFormate.dd_MMM_yyyy_HH_mm) : ""
            
            if (endDate != "") {
                let arr = endDate.components(separatedBy: " ")
                let start = LanguageKey.start
                let end = LanguageKey.end
                if arr.count > 0 {
                   let arrLastDate = arr[0]
                
                   TimeLblSecond.text = "\(end)  :"+" \(arrLastDate),"+" \(tempTime1.0 + tempTime1.1)"
                }
            }
     
        } else {
            timeLbl.text = ""
            TimeLblSecond.text = ""
        }
      
        getDocumentsList()
        getFormDetail()
        LocationManager.shared.startStatusLocTracking()
        self.tabBarController?.navigationItem.title = LanguageKey.job_details
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = true
            button.tintColor = .white
        }
        self.emailView.isHidden = true
        APP_Delegate.mainArr.removeAll()
        
        if UIScreen.main.sizeType == .iPhone5 {
            self.nameLbl.font = nameLbl.font.withSize(14.0)
        }
        
        if getDefaultSettings()?.isHideContact == "1" && objOfUserJobListInDetail?.status == String(taskStatusType.New.rawValue){
            contactDetailViewHeight.constant = 0
           
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
            let image = UIImage(named:"icons8-menu-vertical-32")
            let leftButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
            self.navigationItem.rightBarButtonItem = leftButton
    }
    
    
    //==================================
    // Complitation Nots Button Metherd
    //==================================
    
    // FOR ACTUAL Button Metherd
    @IBAction func dropTravelCompViewActn(_ sender: Any) {
       // dont Use
    }
    
    @IBAction func dropActualCompViewActn(_ sender: Any) {
        
        self.buttonSwitched = !self.buttonSwitched
        
        if self.buttonSwitched
        {
            self.actualDropDwnImg.image = UIImage(named: "drop-down-blue")
            self.actualstartDateTmLbl.isHidden = true
            self.actualendDateTmLbl.isHidden = true
            self.editActualComDetail.isHidden = true
            self.travelJobLbl.isHidden = true
            self.travelStartDateTmLbl.isHidden = true
            self.travelEndDateTmLbl.isHidden = true
            self.editTravelCompDetail.isHidden = true
            self.actualTimeImage.isHidden = true
            // self.actualDropDwnImg.isHidden = true
            self.travelTimeImg.isHidden = true
            if complitationHightView == true{
                self.complationNts_H.constant = 240
            }else{
                if self.objOfUserJobListInDetail?.complNote != "" && self.objOfUserJobListInDetail?.complNote != nil{
                    self.complationNts_H.constant = 150
                }else{
                    self.complationNts_H.constant = 110
                }
            }
            
            self.actualCompView_H.constant = 30
        }
        else
        {
            self.actualDropDwnImg.image = UIImage(named: "icons8-sort-up-30")
            self.actualstartDateTmLbl.isHidden = false
            self.actualendDateTmLbl.isHidden = false
            self.editActualComDetail.isHidden = false
            self.travelJobLbl.isHidden = false
            self.travelStartDateTmLbl.isHidden = false
            self.travelEndDateTmLbl.isHidden = false
            if isEditJobAndTravelTime == false {
                self.editTravelCompDetail.isHidden = true
                self.editActualComDetail.isHidden = true
            }else{
                self.editTravelCompDetail.isHidden = false
                
            }
            self.actualTimeImage.isHidden = false
            self.travelTimeImg.isHidden = false
            if complitationHightView == true{
                self.complationNts_H.constant = 370
            }else{
                if self.objOfUserJobListInDetail?.complNote != "" && self.objOfUserJobListInDetail?.complNote != nil{
                    self.complationNts_H.constant = 290
                }else{
                    self.complationNts_H.constant = 250
                }
            }
            
            self.actualCompView_H.constant = 159
        }
        
    }
    
    @IBAction func actualStartDateTmActn(_ sender: Any) {
//        self.travelEndDateTime = false
//        self.travelStartDateTime = false
//        self.actualEndDateTime = false
//        self.actualStartDateTime = true
//        showDateAndTimePicker()
    }
    
    @IBAction func actualEndDateTmActn(_ sender: Any) {
        
//        self.travelEndDateTime = false
//        self.travelStartDateTime = false
//        self.actualEndDateTime = true
//        self.actualStartDateTime = false
//        showDateAndTimePicker()
    }
    
    @IBAction func actualJobTmEdit(_ sender: Any) {
        self.isaForActualAadTravel = true
        self.backGroundBtn.isHidden = false
        self.complationDetailView.isHidden = false
        self.tittleLbl.text = LanguageKey.modifdy
        self.compltnStartDateLbl.text = LanguageKey.select_start_date
        self.compltnEndDateLbl.text = LanguageKey.select_end_date_new
        self.compltnStartDate.text = actualstartDateTmLbl.text
        self.compltnEndDate.text = actualendDateTmLbl.text
        
    }
    
    // FOR Travel Button Metherd
    
    @IBAction func travelStartDateTmActn(_ sender: Any) {
//        self.travelEndDateTime = false
//        self.travelStartDateTime = true
//        self.actualEndDateTime = false
//        self.actualStartDateTime = false
//        showDateAndTimePicker()
    }
    
    @IBAction func travelEndDateTmActn(_ sender: Any) {
//        self.travelEndDateTime = true
//        self.travelStartDateTime = false
//        self.actualEndDateTime = false
//        self.actualStartDateTime = false
//        showDateAndTimePicker()
    }
    
    @IBAction func cancelComplationView(_ sender: Any) {
        hideBackgroundView()
        self.backGroundBtn.isHidden = true
        self.complationDetailView.isHidden = true
       // pickerTabView.isHidden = true
       // detailDatePicker.isHidden = true
    }
    
    @IBAction func compltnDetailSaveActn(_ sender: Any) { // FOR COMPLITATION SAVE BTN
        if isaForActualAadTravel == true {// FOR ACTUAL
            self.isactualAndTravel = true
            self.addCompletionDetail()
            self.backGroundBtn.isHidden = true
            self.complationDetailView.isHidden = true
            pickerTabView.isHidden = true
            detailDatePicker.isHidden = true
            
        }else{
            self.backGroundBtn.isHidden = true
            pickerTabView.isHidden = true
            detailDatePicker.isHidden = true
            self.complationDetailView.isHidden = true
            self.isactualAndTravel = false
            self.addCompletionDetail()
            
        }
    }
    
    @IBAction func endComplationBtn(_ sender: Any) {
        
        if isaForActualAadTravel == true {// FOR ACTUAL popupview
            self.actualEndDateTime = true
            self.actualStartDateTime = false
            
        }else{
            self.travelStartDateTime = false
            self.travelEndDateTime = true
        }
        
        showDateAndTimePicker()
    }

    @IBAction func startComplationBtn(_ sender: Any) {
     
        if isaForActualAadTravel == true { // FOR ACTUAL popupview
            self.actualStartDateTime = true
            self.actualEndDateTime = false
        }else{
            self.travelStartDateTime = true
            self.travelEndDateTime = false
        }
        
        showDateAndTimePicker()
    }
    
    @IBAction func travelJobTmEdit(_ sender: Any) { // for detail job
        self.backGroundBtn.isHidden = false
        self.isaForActualAadTravel = false// FOR TRAVEL
        self.complationDetailView.isHidden = false
        self.tittleLbl.text = LanguageKey.modifdy_reavel
        self.compltnStartDateLbl.text =   LanguageKey.select_start_date
        self.compltnEndDateLbl.text =  LanguageKey.select_end_date_new
        self.compltnStartDate.text = travelStartDateTmLbl.text
        self.compltnEndDate.text = travelEndDateTmLbl.text
        
    }
  
    
    @IBAction func selectSingnaturBtn(_ sender: Any) {
        
        arrayType = "2"
        self.foSelectSingnatureOpenDwopDown()
  
    }
    
    
    @IBAction func defaultJobCrdBtn(_ sender: Any) {
        arrayType = "3"
        self.forDefaultJobCrdOpenDwopDown()
        
    }
    
    @IBAction func uploadSingnatureActn(_ sender: Any) {
        
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        if objOfUserJobListInDetail?.signature == "" {
            self.smallSingView.isHidden = false
            self.uploadSinngBtn.isHidden = true
            self.H_singnatureView.constant = 121
            self.emailView.isHidden = true
            self.backGroundBtn.isHidden = true
            showBackgroundView()
            view.addSubview(costomerSingView)
            costomerSingView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
        }else{
            ShowAlert(title: nil, message:AlertMessage.sign_uploaded, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
        }
        
    }
    
     @IBAction func btnYesEmail(_ sender: Any) {
            self.emailSendStatus = "1"
            hideBackgroundView()
        
        }
        
        @IBAction func btnNoEmail(_ sender: Any) {
            self.emailSendStatus = "0"
             hideBackgroundView()
             
        }
    
    @IBAction func backGroundBtnActn(_ sender: Any) {
         self.backGroundBtn.isHidden = true
         self.emailView.isHidden = true
         self.complationDetailView.isHidden = true
        
    }
    
    @IBAction func naviBackBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func printJob(_ sender: Any) {
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        self.backGroundBtn.isHidden = false
        self.emailView.isHidden = true
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pdfvc") as! ShowPdfVC
        vc.pdfDetailJob = true
        vc.pdfDetailJobId =  objOfUserJobListInDetail?.jobId as! String
        vc.jobIdLabel = objOfUserJobListInDetail?.label as! String
        vc.templateIdPrint = templateId
        vc.titelForJobCare  = true
        if jobIdPrint1 != "" {
            vc.jobIdForPrint = jobIdPrint1
        }else{
            vc.jobIdForPrint = defaultTechIdSet
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.signaturePadView.clear()
        self.smallSingView.isHidden = true
        self.uploadSinngBtn.isHidden = false
        self.H_singnatureView.constant = 50
        hideBackgroundView()
        self.backGroundBtn.isHidden = true
        self.emailView.isHidden = true
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
        
        let signatureImage = self.signaturePadView.getSignature(scale: 1)
         
        if signatureImage != nil {
            feedbackService()
        }else{
            ShowError(message: AlertMessage.customer_sign_required, controller: windowController)
        }
        
    }
    
    @IBAction func linkQuatBtnAct(_ sender: Any) {
        
       // let isExist = self.arrOFUserDataQuot.contains(where: {$0.quotId == appintDetainsDicCommon?.quotId})

//             let quote = self.arrOFUserDataQuot.filter({$0.quotId == objOfUserJobListInDetail?.quotId})
//
//             if quote.count > 0 {
//                 let storyboard: UIStoryboard = UIStoryboard(name: "Quote", bundle: nil)
//                 let vc = storyboard.instantiateViewController(withIdentifier: "quoteInvoice") as! QuoteInvoiceVC
//                 vc.quotationData = quote[0]
//                 self.navigationController?.pushViewController(vc, animated: true)
//             }else{
//
//             }
    }
    
    @IBAction func clearBtn(_ sender: Any) {
          self.signaturePadView.clear()
    }
    
    @IBAction func uploadCustomerSing(_ sender: Any) {
        
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        if objOfUserJobListInDetail?.signature == "" {
            self.emailView.isHidden = true
            self.backGroundBtn.isHidden = true
            showBackgroundView()
            view.addSubview(costomerSingView)
            costomerSingView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
        }else{
            ShowAlert(title: nil, message:AlertMessage.sign_uploaded, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
        }
        
    }
    
    @IBAction func emailJob(_ sender: Any) {
        
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        self.backGroundBtn.isHidden = false
        self.emailView.isHidden = true
        ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoiceEmail)
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EMAILINVOICE") as! EmailInvoiceVC
        vc.isJobDetail = true
        vc.jobIdDetail = objOfUserJobListInDetail?.jobId as! String
        vc.selectJobId = templateId
        
        if jobIdPrint1 != "" {
            vc.jobIdForPrint = jobIdPrint1
        }else{
            vc.jobIdForPrint = defaultTechIdSet
        }
       
        vc.selectJobName = self.selectTemplateTxtFld.text ?? ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func emailSndBtn(_ sender: Any) {

         self.emailView.isHidden = false
         self.backGroundBtn.isHidden = false
    }
    
    @IBAction func coustomFldAcn(_ sender: Any) {
        
        let feedVC = storyboard?.instantiateViewController(withIdentifier: "CoustomField") as! CoustomField
        feedVC.sltNaviCount = 0
        feedVC.clickedEvent = nil
        feedVC.isCameFrmStatusBtnClk = true
        feedVC.objOfUserJobList = self.objOfUserJobListInDetail!
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(feedVC, animated: true)
    }
    
    @IBAction func rescheduleBtn(_ sender: Any) {
        
        if isComplite == false {
            ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.close_completed_job_msg )!, controller: windowController)
            return
        }
        
        let ladksj  = self.objOfUserJobListInDetail!.jobId!.components(separatedBy: "-")
        if ladksj.count > 0 {
            let tempId = ladksj[0]
            if tempId == "Job" {
                
                ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.job_not_sync)!, controller: windowController)
                
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "RescheduleVC") as! RescheduleVC
                vc.jobDetailData = objOfUserJobListInDetail
                // vc.boolQuat = true
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func requestForVisite(_ sender: Any) {
        
        if objOfUserJobListInDetail?.parentId != "0"  {
            ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.revisit_msg_validation)!, controller: windowController)
            return
        }
        
        let ladksj  = self.objOfUserJobListInDetail!.jobId!.components(separatedBy: "-")
        if ladksj.count > 0 {
            let tempId = ladksj[0]
            if tempId == "Job" {
                
                ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.job_not_sync)!, controller: windowController)
                
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "Revisit") as! Revisit
                vc.arrr = self.objOfUserJobListInDetail
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    @IBAction func BtnStatusPressed(_ sender: Any) {
        arrayType = "1"
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
        
        
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        let vc = UIStoryboard(name: "MainJob", bundle: nil).instantiateViewController(withIdentifier: "CompletionNotsVC") as! CompletionNots
        vc.modalPresentationStyle = .fullScreen
        let navCon = NavClientController(rootViewController: vc)
        vc.jobModel = self.objOfUserJobListInDetail!
        
        vc.doNotDublPrint = false
        vc.callback = {(note) in
            if  note != "" {
              //  self.getJobListService()
                
                self.btnAddNotes.setTitle(LanguageKey.edit, for: .normal)
                UserDefaults.standard.set(nil, forKey: "txtCompletionNotes")
                self.self.getDocumentsList()
                self.lblCompletiondetail.attributedText =  lineSpacing(string: (note.capitalizingFirstLetter()), lineSpacing: 7.0)
            }else{
              //  self.getJobListService()
                self.getDocumentsList()
                self.btnAddNotes.setTitle(LanguageKey.add, for: .normal)
                UserDefaults.standard.set(nil, forKey: "txtCompletionNotes")
                self.lblCompletiondetail.text = ""
            }
        }
       // vc.modalPresentationStyle = .fullScreen
        APP_Delegate.showBackButtonText()
        self.navigationController?.present(navCon, animated: true, completion: nil)
    }
    
    
    @IBAction func acceptBtn(_ sender: UIButton) {
        
      
        if isPermitForShow(permission: permissions.isJobRevisitOrNot) == false{
            self.requestForVisite.isHidden = false
            // let expence = SideMenuModel(id: 10, name: LanguageKey.title_appointments, subMenu: [], image: "Appointment", isCollaps: false)
            // menus.append(expence) // for Expence
        }else{
            self.requestForVisite.isHidden = true
        }
        LocationManager.shared.isHaveLocation()
        
       // let status : taskStatusType = taskStatusType(rawValue: sender.tag)!
        let status =  sender.tag
        
        if currentStatusID != String(status) {
            if UserDefaults.standard.bool(forKey: "permission") {
                //statusId = status
                showDateAndTimePicker()
            }else{
                
                if (sender.titleLabel!.text!.contains("Resume")) || (isHaveNetowork() == false){ // In case of 'Job Resume' and 'Travel Resume' not showing custom form on these two buttons
                    if currentStatusID != String(status) {
                        self.ChangeButtonsAccordingToStatusType(status: String(status))
                    }
                    return
                }
                
                let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
                    if(Int(obj.event!)! == status) &&  (Int(obj.totalQues!)! != 0) {
                        return true
                    }else{
                        return false
                    }
                }
                
                if(arrOFShowTabForm.count > 0){
                    let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
                    customFormVC.objOFTestVC = arrOFShowTabForm[0]
                    customFormVC.sltNaviCount = 0
                    customFormVC.isCameFrmStatusBtnClk = false
                    customFormVC.clickedEvent =  Int(status)
                    customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
                    customFormVC.optionID = "-1"

                    customFormVC.callBackFofDetailJob = { (success) in
                        if(success){
                            self.ChangeButtonsAccordingToStatusType(status:  String(status))
                        }
                        
                    }
                    self.navigationController?.navigationBar.topItem?.title = " "
                    self.navigationController?.pushViewController(customFormVC, animated: true)
                }else{
                    
                    if currentStatusID != String(status) {
                        self.ChangeButtonsAccordingToStatusType(status:  String(status))
                    }
                }
                
            }
        }
        
    }
    //[1 - Not Started, 2 - Accepted, 3 - Reject , 4 - Cancel, 5 - Travelling, 6 - Break, 7 - In Progress , 8 - Pending, 9 - Completed and 10- Closed]
    
    func ChangeButtonsAccordingToStatusType(status : String){
        
        //: MARK FOR JOB STATUS REFRESS : -----------------------------------------------
        getJobStatusList()
        self.jobStatusArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
        
        for job in self.jobStatusArr{
            
            switch job.id {
            case "1":
                
                if job.isStatusShow == "0"{
                    
                }else{
                    if job.isFwSelect == "0"{
                        
                    }
                }
                
            case "2":
                
                if job.isStatusShow == "0"{
                    self.acceptedIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        self.acceptedIsSelect = "0"
                    }else{
                        self.acceptedIsSelect = "1"
                    }
                }
                
            case "3":
                
                if job.isStatusShow == "0"{
                    
                    self.rejectIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        self.rejectIsSelect = "0"
                    }else{
                        self.rejectIsSelect = "1"
                    }
                }
                
            case "4":
                
                if job.isStatusShow == "0"{
                    
                    self.cancelIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        self.cancelIsSelect = "0"
                    }else{
                        self.cancelIsSelect = "1"
                    }
                }
                
            case "5":
                
                if job.isStatusShow == "0"{
                    
                    self.travelingIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        self.travelingIsSelect = "0"
                    }else{
                        self.travelingIsSelect = "1"
                    }
                }
                
            case "6":
                
                if job.isStatusShow == "0"{
                    
                    self.breakIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        self.breakIsSelect = "0"
                    }else{
                        self.breakIsSelect = "1"
                    }
                }
                
            case "7":
                if job.isStatusShow == "0"{
                    
                    self.inProgressIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        
                        self.inProgressIsSelect = "0"
                    }else{
                        self.inProgressIsSelect = "1"
                    }
                }
                
            case "8":
                
                if job.isStatusShow == "0"{
                    
                    self.jobBreakIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        self.jobBreakIsSelect = "0"
                    }else{
                        self.jobBreakIsSelect = "1"
                    }
                }
                
            case "9":
                
                if job.isStatusShow == "0"{
                    
                    self.CompletedIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        self.CompletedIsSelect = "0"
                    }else{
                        self.CompletedIsSelect = "1"
                    }
                }
                
            case "10":
                
                if job.isStatusShow == "0"{
                    
                    self.closedIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        self.closedIsSelect = "0"
                    }else{
                        self.closedIsSelect = "1"
                    }
                }
                
            case "12":
                
                if job.isStatusShow == "0"{
                    
                    self.onHoldIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        self.onHoldIsSelcet = "0"
                    }else{
                        self.onHoldIsSelcet = "1"
                    }
                }
                
            case "13":
                
                if job.isStatusShow == "0"{
                    
                }else{
                    if job.isFwSelect == "0"{
                        
                    }
                }
                
            default: break
                if job.isStatusShow == "0"{
                    
                }else{
                    
                    if job.isFwSelect == "0"{
                        
                    }
                }
            }
        }

        
        var resheduleAndrevisite = "true"
        switch status {
        case "Reschedule"://Reschedule:
            
            resheduleAndrevisite = "true"
            break
            
        case "Revisit"://.Revisit:
            resheduleAndrevisite = "true"
            break
            
        case "1"://.New:
            for admin in self.confirmationTriggerArray {
               
                var onHold = ""
                if onHold == admin {
                    self.new = true
                 
                }
                
            }
            
            acceptStatus = "false"
            resheduleAndrevisite = "false"
            break
            
        case "2"://.Accepted:
            for admin in self.confirmationTriggerArray {
                
                var onHold = "2"
                if onHold == admin {
                    self.accepted = true
                
                }
                
            }
            
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            
            break
        
        case "3"://.Reject:
            for admin in self.confirmationTriggerArray {
               
                
                var onHold = "3"
                if onHold == admin {
                    self.reject = true
                  
                }
                
            }
            
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            
            break
              
        case "4"://.Cancel:
            for admin in self.confirmationTriggerArray {
                
                
                var onHold = "4"
                if onHold == admin {
                    self.cancel = true
                  
                }
                
            }
            
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            
            break
            
        case "5"://.Travelling:
            for admin in self.confirmationTriggerArray {
                
                self.rejectVelue = "1"
                var onHold = "5"
                if onHold == admin {
                    self.travelling = true
                   
                }
                
            }
            
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            
            break
             
        case "6"://.Break:
            for admin in self.confirmationTriggerArray {
              
                
                var onHold = "6"
                if onHold == admin {
                    self.break1 = true
                   
                }
                
            }
            
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            
            break
           
        case "7"://.InProgress:
            for admin in self.confirmationTriggerArray {
                
                var onHold = "7"
                if onHold == admin {
                    self.inProgress = true
                  
                }
                
            }
            
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            
            break
             
        case "12"://.OnHold:
           
            for admin in self.confirmationTriggerArray {
               
                
                var onHold = "12"
                if onHold == admin {
                    self.onHold = true
                  
                }
                
            }
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            
            break
           
        case "9"://.Completed:
            for admin in self.confirmationTriggerArray {
                
                
                var onHold = "9"
                if onHold == admin {
                    self.completed = true
                   
                }
                
            }
            
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            isCompliteBool = "true"
            break
            
        case ""://""://.Start:
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            
            break
             
        case "8"://.JobBreak:
            
            for admin in self.confirmationTriggerArray {
               
                
                var onHold = "8"
                if onHold == admin {
                    self.jobBreak = true
                   
                }
                
            }
            
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            break
        default:
            self.isCustomStatusBool = "true"
            self.CustomStatus = true
            acceptStatus = "true"
            resheduleAndrevisite = "false"
            isCompliteBool = "true"
            
        break
          
        }
        
        if resheduleAndrevisite == "false"{
            if !isFirst{
                if status == "7" {//taskStatusType.InProgress{
                           for job in jobArray {
                               if job.status == "7"{//String(taskStatusType.InProgress.rawValue){
                                   job.status = "12"//String(taskStatusType.OnHold.rawValue)
                                   job.updateDate = getCurrentTimeStamp()
                               }
                           }
                       }
                   
                       if ((status != "3") &&
                           (status != "4"))
                       {
                           changeJobStatus(statusId: Int(status)!, job: objOfUserJobListInDetail!)
                           objOfUserJobListInDetail?.status = String(status)
                           objOfUserJobListInDetail?.updateDate = getCurrentTimeStamp()
                           DatabaseClass.shared.saveEntity(callback: { _ in })
                       }
                   }
                  
                   if ((status != "3") &&
                       (status != "4") )
                   {
               
                           for arr in jobStatusArr {
                               if arr.id == status {
                                   lblTaskStatus.text = arr.text
                               }
                           }
                       
                       if !isFirst {
                           // timeLbl.text = CurrentTime()
                       }
                   }else{
                       if isFirst{
                           statusViewEnable(isEnable: false)
                           return
                       }
                   }
        }
      
        switch status {
   
        case "Reschedule"://.Reschedule:
            
            if isComplite == false {
                ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.close_completed_job_msg )!, controller: windowController)
                return
            }
            
            let ladksj  = self.objOfUserJobListInDetail!.jobId!.components(separatedBy: "-")
            if ladksj.count > 0 {
                let tempId = ladksj[0]
                if tempId == "Job" {
                    
                    ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.job_not_sync)!, controller: windowController)
                    
                    
                }else{
                    let vc = storyboard?.instantiateViewController(withIdentifier: "RescheduleVC") as! RescheduleVC
                    vc.jobDetailData = objOfUserJobListInDetail
                    // vc.boolQuat = true
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                    self.navigationController!.pushViewController(vc, animated: true)
                }
            }
            
            break
        
        case "Revisit"://.Revisit:
            
            if objOfUserJobListInDetail?.parentId != "0"  {
                ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.cannot_raise_revisit_request_for_job_which_is_already_marked_as_recurring)!, controller: windowController)
                return
            }

            
            let ladksj  = self.objOfUserJobListInDetail!.jobId!.components(separatedBy: "-")
            if ladksj.count > 0 {
                let tempId = ladksj[0]
                if tempId == "Job" {
                    
                    ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.job_not_sync)!, controller: windowController)
                    
                    
                }else{
                    let vc = storyboard?.instantiateViewController(withIdentifier: "Revisit") as! Revisit
                    vc.arrr = self.objOfUserJobListInDetail
                    // vc.boolQuat = true
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                    self.navigationController!.pushViewController(vc, animated: true)
                }
            }
            
            break
          
        case "1"://.New:
           
            statusViewEnable(isEnable: false)
            
            ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width)
            
            ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x, width_constant: rectDeclineBtn.size.width)
            if (acceptedIsShow == "0" && rejectIsShow == "0") || (acceptedIsSelect == "0" && rejectIsSelect == "0") ||  (acceptedIsShow == "0" && rejectIsSelect == "0") || (acceptedIsSelect == "0" && rejectIsShow == "0") {
                if travelingIsShow == "0"{
                    //"job start buttion"//job start
                    ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
                    acceptBtn.tag = 7//taskStatusType.InProgress.rawValue
                    self.acceptBtn.setTitle(LanguageKey.job_start, for: .normal)
                    self.declineBtn.isHidden = true
                    
                }else{
                    if travelingIsSelect == "0"{
                        //"job start buttion"//job start
                        ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
                        acceptBtn.tag = 7//taskStatusType.InProgress.rawValue
                        self.acceptBtn.setTitle(LanguageKey.job_start, for: .normal)
                        self.declineBtn.isHidden = true
                    }else{
                        
                     //trav
                        
                        statusViewEnable(isEnable: true)
                        contactDetailViewHeight.constant = 80.0
                      //  topViewConnect.constant = 2.0
                        self.declineBtn.isHidden = true
                        
                        if travelingIsShow == "0"{
                            ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
                            acceptBtn.tag = 7//taskStatusType.InProgress.rawValue
                            self.acceptBtn.setTitle(LanguageKey.job_start, for: .normal)
                        }else{
                            if travelingIsSelect == "0"{
                                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
                                acceptBtn.tag = 7//taskStatusType.InProgress.rawValue
                                self.acceptBtn.setTitle(LanguageKey.job_start, for: .normal)
                            }else{
                                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
                                acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                                self.acceptBtn.setTitle(LanguageKey.travel_start, for: .normal)
                                if isPermitForShow(permission: permissions.isJobRevisitOrNot) == false{
                                    self.requestForVisite.isHidden = false
                                    // let expence = SideMenuModel(id: 10, name: LanguageKey.title_appointments, subMenu: [], image: "Appointment", isCollaps: false)
                                    // menus.append(expence) // for Expence
                                }else{
                                    self.requestForVisite.isHidden = true
                                    
                                }
                                self.declineBtn.isHidden = true
                            }
                            
                        }
                    }
                    
                }
                
                
            }else{
                
                if acceptedIsShow == "0"{
                    
                    
                    if travelingIsShow == "0" || travelingIsSelect == "0" {
                        
                        ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
                        acceptBtn.tag = 7//taskStatusType.InProgress.rawValue
                        self.acceptBtn.setTitle(LanguageKey.job_start, for: .normal)
                        self.declineBtn.isHidden = true
                    }else{
                        ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
                        acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                        self.acceptBtn.setTitle(LanguageKey.travel_start, for: .normal)
                        if isPermitForShow(permission: permissions.isJobRevisitOrNot) == false{
                            self.requestForVisite.isHidden = false
                            
                        }else{
                            self.requestForVisite.isHidden = true
                            
                        }
                        self.declineBtn.isHidden = true
                    }
                    
                }else{
                    if acceptedIsSelect == "0" {
                        acceptBtn.isHidden = true
                        acceptBtn.tag = 2//taskStatusType.Accepted.rawValue
                        self.acceptBtn.setTitle(LanguageKey.accept, for: .normal)
                        
                        declineBtn.tag = 3//taskStatusType.Reject.rawValue
                        self.declineBtn.setTitle(LanguageKey.reject, for: .normal)
                        declineBtn.isHidden = true
                    }else{
                        acceptBtn.isHidden = false
                        acceptBtn.tag = 2//taskStatusType.Accepted.rawValue
                        self.acceptBtn.setTitle(LanguageKey.accept, for: .normal)
                        
                        if rejectIsShow == "0" {
                            
                            declineBtn.tag = 3//taskStatusType.Reject.rawValue
                            self.declineBtn.setTitle(LanguageKey.reject, for: .normal)
                            declineBtn.isHidden = true
                            
                        }else{
                            if rejectIsSelect == "1"{
                                declineBtn.isHidden = false
                                declineBtn.tag = 3//taskStatusType.Reject.rawValue
                                self.declineBtn.setTitle(LanguageKey.reject, for: .normal)
                            }else{
                                declineBtn.tag = 3//taskStatusType.Reject.rawValue
                                self.declineBtn.setTitle(LanguageKey.reject, for: .normal)
                                declineBtn.isHidden = true
                            }
                        }
                        
                    }
                }
                
            }
            break
        
        case "2"://.Accepted :
            
            statusViewEnable(isEnable: true)
            contactDetailViewHeight.constant = 80.0
          //  topViewConnect.constant = 2.0
            self.declineBtn.isHidden = true
            
            if travelingIsShow == "0"{
                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
                acceptBtn.tag = 7//taskStatusType.InProgress.rawValue
                self.acceptBtn.setTitle(LanguageKey.job_start, for: .normal)
            }else{
                if travelingIsSelect == "0"{
                    ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
                    acceptBtn.tag = 7//taskStatusType.InProgress.rawValue
                    self.acceptBtn.setTitle(LanguageKey.job_start, for: .normal)
                }else{
                    ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
                    acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                    self.acceptBtn.setTitle(LanguageKey.travel_start, for: .normal)
                    if isPermitForShow(permission: permissions.isJobRevisitOrNot) == false{
                        self.requestForVisite.isHidden = false
                        
                    }else{
                        self.requestForVisite.isHidden = true
                        
                    }
                    self.declineBtn.isHidden = true
                }
                
            }
          
            break
   
        case "3"://.Reject:
            
            ShowAlert(title: LanguageKey.reject, message: AlertMessage.rejectJob, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.reject as NSString, style: .alert, callback: { (Cancel, ok) in
                if ok {
                    
                    if self.reject == true {
                        ShowAlert(title: "", message: LanguageKey.send_client_mail, controller: windowController, cancelButton: LanguageKey.no as NSString, okButton: LanguageKey.yes as NSString, style: .alert) { (NO, OK) in
                            if OK {
                                
                                
                                self.rejectVelue = "1"
                               
                                self.changeJobStatus(statusId: Int(status)!, job: self.objOfUserJobListInDetail!)
                                ChatManager.shared.removeJobForChat(jobId: self.objOfUserJobListInDetail!.jobId!)
                                DatabaseClass.shared.deleteEntity(object: self.objOfUserJobListInDetail!, callback: { (isDelete : Bool) in
                                    if (self.callbackDetailVC != nil){
                                        self.callbackDetailVC!(true, self.objOfUserJobListInDetail!)
                                    }
                                })
                                
                            }
                            
                            if NO {
                                self.rejectVelue = "2"
                               
                                self.changeJobStatus(statusId: Int(status)!, job: self.objOfUserJobListInDetail!)
                                ChatManager.shared.removeJobForChat(jobId: self.objOfUserJobListInDetail!.jobId!)
                                DatabaseClass.shared.deleteEntity(object: self.objOfUserJobListInDetail!, callback: { (isDelete : Bool) in
                                    if (self.callbackDetailVC != nil){
                                        self.callbackDetailVC!(true, self.objOfUserJobListInDetail!)
                                    }
                                })
                                
                            }
                        }
                        
                    }else{
                        self.rejectVelue = "0"
                        self.changeJobStatus(statusId: Int(status)!, job: self.objOfUserJobListInDetail!)
                        ChatManager.shared.removeJobForChat(jobId: self.objOfUserJobListInDetail!.jobId!)
                        DatabaseClass.shared.deleteEntity(object: self.objOfUserJobListInDetail!, callback: { (isDelete : Bool) in
                            if (self.callbackDetailVC != nil){
                                self.callbackDetailVC!(true, self.objOfUserJobListInDetail!)
                            }
                        })
                    }
                    
                }
            })
            
            break
    
        case "4"://.Cancel:
            //print("Not started")
            self.requestForVisite.isHidden = true
            self.rescheduleBtn.isHidden = true
            ShowAlert(title: LanguageKey.cancel, message: AlertMessage.cancelJob , controller: windowController, cancelButton: LanguageKey.no as NSString, okButton: LanguageKey.yes as NSString, style: .alert, callback: { (Cancel, ok) in
                if ok {
                    if self.cancel == true {
                        
                        ShowAlert(title: "", message: LanguageKey.send_client_mail, controller: windowController, cancelButton: LanguageKey.no as NSString, okButton: LanguageKey.yes as NSString, style: .alert) { (NO, OK) in
                            if OK {
                                
                                
                                self.rejectVelue = "1"
                                //delete this job
                                //print("status change = Cancel")
                                self.changeJobStatus(statusId: Int(status)!, job: self.objOfUserJobListInDetail!)
                                ChatManager.shared.removeJobForChat(jobId: self.objOfUserJobListInDetail!.jobId!)
                                DatabaseClass.shared.deleteEntity(object: self.objOfUserJobListInDetail!, callback: { (isDelete : Bool) in
                                    if (self.callbackDetailVC != nil){
                                        self.callbackDetailVC!(true, self.objOfUserJobListInDetail! )
                                    }
                                })
                                self.requestForVisite.isHidden = true
                                self.rescheduleBtn.isHidden = true
                                
                            }
                            if NO {
                                
                                
                                self.rejectVelue = "2"
                                //delete this job
                                //print("status change = Cancel")
                                self.changeJobStatus(statusId: Int(status)!, job: self.objOfUserJobListInDetail!)
                                ChatManager.shared.removeJobForChat(jobId: self.objOfUserJobListInDetail!.jobId!)
                                DatabaseClass.shared.deleteEntity(object: self.objOfUserJobListInDetail!, callback: { (isDelete : Bool) in
                                    if (self.callbackDetailVC != nil){
                                        self.callbackDetailVC!(true, self.objOfUserJobListInDetail! )
                                    }
                                })
                                self.requestForVisite.isHidden = true
                                self.rescheduleBtn.isHidden = true
                                
                            }
                        }
                        
                    }else{
                        
                        self.rejectVelue = "0"
                        
                        //delete this job
                        //print("status change = Cancel")
                        self.changeJobStatus(statusId: Int(status)!, job: self.objOfUserJobListInDetail!)
                        ChatManager.shared.removeJobForChat(jobId: self.objOfUserJobListInDetail!.jobId!)
                        DatabaseClass.shared.deleteEntity(object: self.objOfUserJobListInDetail!, callback: { (isDelete : Bool) in
                            if (self.callbackDetailVC != nil){
                                self.callbackDetailVC!(true, self.objOfUserJobListInDetail! )
                            }
                        })
                        self.requestForVisite.isHidden = true
                        self.rescheduleBtn.isHidden = true
                    }
                }
                
                
            })
            
            break
        
        case "5"://.Travelling :
            
            if self.travelling == true {
            
            ShowAlert(title: "", message: LanguageKey.send_client_mail, controller: windowController, cancelButton: LanguageKey.no as NSString, okButton: LanguageKey.yes as NSString, style: .alert) { (NO, OK) in
                if OK {
                     self.rejectVelue = "1"

               self.ButtonAnimator(animationOnButton: self.acceptBtn, x_space: self.rectAcceptBtn.origin.x, width_constant: self.rectAcceptBtn.size.width - 30)
                    
                    self.ButtonAnimator(animationOnButton: self.declineBtn, x_space: self.rectDeclineBtn.origin.x - 30, width_constant: self.rectDeclineBtn.size.width + 30)
                    
                    if self.breakIsShow == "0"{
                       
                            self.acceptBtn.isHidden = true
                            self.acceptBtn.tag = 6//taskStatusType.Break.rawValue
                            self.acceptBtn.setTitle(LanguageKey.breake, for: .normal)
                        
                    }else{
                        if self.breakIsSelect == "0" {
                            self.acceptBtn.isHidden = true
                            self.acceptBtn.tag = 6//taskStatusType.Break.rawValue
                            self.acceptBtn.setTitle(LanguageKey.breake, for: .normal)
                        }else{
                            self.acceptBtn.isHidden = false
                            self.acceptBtn.tag = 6//taskStatusType.Break.rawValue
                            self.acceptBtn.setTitle(LanguageKey.breake, for: .normal)
                        }
                    }
                  
                    
                    self.declineBtn.tag = 7//taskStatusType.InProgress.rawValue
                    self.declineBtn.setTitle(LanguageKey.status_tr_fin_st, for: .normal)
                    
                    //self.buttonsDisable(isDisable: false)
                    self.declineBtn.isHidden = false
                    self.detailDatePicker.isHidden = true
                    self.pickerTabView.isHidden = true
                    self.hideBackgroundView()
                    
                }
                
                if NO {
                    self.rejectVelue = "2"
                    

                    self.ButtonAnimator(animationOnButton: self.acceptBtn, x_space: self.rectAcceptBtn.origin.x, width_constant: self.rectAcceptBtn.size.width - 30)
                    
                    self.ButtonAnimator(animationOnButton: self.declineBtn, x_space: self.rectDeclineBtn.origin.x - 30, width_constant: self.rectDeclineBtn.size.width + 30)
                    
                    if self.breakIsShow == "0"{
                   
                        self.acceptBtn.isHidden = true
                        self.acceptBtn.tag = 6//taskStatusType.Break.rawValue
                        self.acceptBtn.setTitle(LanguageKey.breake, for: .normal)
                    
                }else{
                    if self.breakIsSelect == "0" {
                        self.acceptBtn.isHidden = true
                        self.acceptBtn.tag = 6//taskStatusType.Break.rawValue
                        self.acceptBtn.setTitle(LanguageKey.breake, for: .normal)
                    }else{
                        self.acceptBtn.isHidden = false
                        self.acceptBtn.tag = 6//taskStatusType.Break.rawValue
                        self.acceptBtn.setTitle(LanguageKey.breake, for: .normal)
                    }
                }
                    
                    self.declineBtn.tag = 7//taskStatusType.InProgress.rawValue
                    self.declineBtn.setTitle(LanguageKey.status_tr_fin_st, for: .normal)
                    
                    //self.buttonsDisable(isDisable: false)
                    
                    self.detailDatePicker.isHidden = true
                    self.pickerTabView.isHidden = true
                    self.hideBackgroundView()
                    self.declineBtn.isHidden = false
                        }
                }
            }else{
                 self.rejectVelue = "0"

                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width - 30)
                
                ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x - 30, width_constant: rectDeclineBtn.size.width + 30)
                
                if breakIsShow == "0"{
               
                    self.acceptBtn.isHidden = true
                    self.acceptBtn.tag = 6//taskStatusType.Break.rawValue
                    self.acceptBtn.setTitle(LanguageKey.breake, for: .normal)
                
            }else{
                if self.breakIsSelect == "0" {
                    self.acceptBtn.isHidden = true
                    self.acceptBtn.tag = 6//taskStatusType.Break.rawValue
                    self.acceptBtn.setTitle(LanguageKey.breake, for: .normal)
                }else{
                    self.acceptBtn.isHidden = false
                    self.acceptBtn.tag = 6//taskStatusType.Break.rawValue
                    self.acceptBtn.setTitle(LanguageKey.breake, for: .normal)
                }
            }
                
                declineBtn.tag = 7//taskStatusType.InProgress.rawValue
                self.declineBtn.setTitle(LanguageKey.status_tr_fin_st, for: .normal)
                
                //self.buttonsDisable(isDisable: false)
                 self.declineBtn.isHidden = false
                detailDatePicker.isHidden = true
                pickerTabView.isHidden = true
                hideBackgroundView()
                
            }
            
            break
   
        case "6"://.Break:
            
            
            if self.break1 == true {
                
                ShowAlert(title: "", message: LanguageKey.send_client_mail, controller: windowController, cancelButton: LanguageKey.no as NSString, okButton: LanguageKey.yes as NSString, style: .alert) { (NO, OK) in
                    if OK {
                        self.rejectVelue = "1"
                        
                        self.ButtonAnimator(animationOnButton: self.acceptBtn, x_space: self.rectAcceptBtn.origin.x, width_constant: self.rectAcceptBtn.size.width - 30)
                        
                        self.ButtonAnimator(animationOnButton: self.declineBtn, x_space: self.rectDeclineBtn.origin.x - 30, width_constant: self.rectDeclineBtn.size.width + 30)
                        
                        if self.jobBreakIsShow == "0"{
                           
                                self.acceptBtn.isHidden = true
                                self.acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                                self.acceptBtn.setTitle(LanguageKey.resume, for: .normal)
                            
                        }else{
                            if self.jobBreakIsSelect == "0" {
                                self.acceptBtn.isHidden = true
                                self.acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                                self.acceptBtn.setTitle(LanguageKey.resume, for: .normal)
                            }else{
                                self.acceptBtn.isHidden = false
                                self.acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                                self.acceptBtn.setTitle(LanguageKey.resume, for: .normal)
                            }
                        }
                     
                        self.declineBtn.tag = 7//taskStatusType.InProgress.rawValue
                        self.declineBtn.setTitle(LanguageKey.status_tr_fin_st, for: .normal)
                   
                    }
                    
                    if NO {
                        
                        self.rejectVelue = "2"
                        
                        self.ButtonAnimator(animationOnButton: self.acceptBtn, x_space: self.rectAcceptBtn.origin.x, width_constant: self.rectAcceptBtn.size.width - 30)
                        
                        self.ButtonAnimator(animationOnButton: self.declineBtn, x_space: self.rectDeclineBtn.origin.x - 30, width_constant: self.rectDeclineBtn.size.width + 30)
                        
                        if self.jobBreakIsShow == "0"{
                           
                                self.acceptBtn.isHidden = true
                                self.acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                                self.acceptBtn.setTitle(LanguageKey.resume, for: .normal)
                            
                        }else{
                            if self.jobBreakIsSelect == "0" {
                                self.acceptBtn.isHidden = true
                                self.acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                                self.acceptBtn.setTitle(LanguageKey.resume, for: .normal)
                            }else{
                                self.acceptBtn.isHidden = false
                                self.acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                                self.acceptBtn.setTitle(LanguageKey.resume, for: .normal)
                            }
                        }
                        
                        self.declineBtn.tag = 7//taskStatusType.InProgress.rawValue
                        self.declineBtn.setTitle(LanguageKey.status_tr_fin_st, for: .normal)
                        
                        //self.buttonsDisable(isDisable: true)
                        
                    }
                }
            }else{
                self.rejectVelue = "0"
                
                ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width - 30)
                
                ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x - 30, width_constant: rectDeclineBtn.size.width + 30)
                
                if jobBreakIsShow == "0"{
                   
                        self.acceptBtn.isHidden = true
                        self.acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                        self.acceptBtn.setTitle(LanguageKey.resume, for: .normal)
                    
                }else{
                    if self.jobBreakIsSelect == "0" {
                        self.acceptBtn.isHidden = true
                        self.acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                        self.acceptBtn.setTitle(LanguageKey.resume, for: .normal)
                    }else{
                        self.acceptBtn.isHidden = false
                        self.acceptBtn.tag = 5//taskStatusType.Travelling.rawValue
                        self.acceptBtn.setTitle(LanguageKey.resume, for: .normal)
                    }
                }
                
                declineBtn.tag = 7//taskStatusType.InProgress.rawValue
                self.declineBtn.setTitle(LanguageKey.status_tr_fin_st, for: .normal)
                
                //self.buttonsDisable(isDisable: true)
                
            }
           
            break

        case "7"://.InProgress:
            
            ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width)
            
            ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x, width_constant: rectDeclineBtn.size.width)
            if onHoldIsShow == "0" {
                
                    self.acceptBtn.isHidden = true
                    acceptBtn.tag = 12//taskStatusType.OnHold.rawValue
                    self.acceptBtn.setTitle(LanguageKey.new_on_hold, for: .normal)
                
            }else{
                if onHoldIsSelcet == "0"{
                    self.acceptBtn.isHidden = true
                    acceptBtn.tag = 12//taskStatusType.OnHold.rawValue
                    self.acceptBtn.setTitle(LanguageKey.new_on_hold, for: .normal)
                }else{
                    self.acceptBtn.isHidden = false
                    acceptBtn.tag = 12//taskStatusType.OnHold.rawValue
                    self.acceptBtn.setTitle(LanguageKey.new_on_hold, for: .normal)
                }
            }
            
            
            declineBtn.tag = 9//taskStatusType.Completed.rawValue
            self.declineBtn.setTitle(LanguageKey.job_finish, for: .normal)
            
            
            // self.buttonsDisable(isDisable: false)
            
            break
  
        case "9"://.Completed :
              isCompliteBool = "true"
            ButtonAnimator(animationOnButton: acceptBtn, x_space:  rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
            
            statusViewEnable(isEnable: false)
            
            self.acceptBtn.setTitle(LanguageKey.completed, for: .normal)
            self.acceptBtn.backgroundColor = UIColor.init(red: 115.0/255.0, green: 216.0/255.0, blue: 21.0/255.0, alpha: 1.0)
            self.acceptBtn.isUserInteractionEnabled = false
            self.declineBtn.isUserInteractionEnabled = false
          //  self.btnStatusType.isUserInteractionEnabled = false
            
            statusTwoButtons_H.constant =  10.0
            //UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded()
            isComplite = false
            self.requestForVisite.isHidden = false
            
            // self.rescheduleBtn.isHidden = true
            break
 
        case "12"://.OnHold:
            
            ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width)
            
            ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x, width_constant: rectDeclineBtn.size.width)
            
            acceptBtn.tag = 7//taskStatusType.InProgress.rawValue
            self.acceptBtn.setTitle(LanguageKey.job_resume, for: .normal)
            
            declineBtn.tag = 9//taskStatusType.Completed.rawValue
            self.declineBtn.setTitle(LanguageKey.job_finish, for: .normal)
            
            break
            
        case "8"://.JobBreak:
            
            ButtonAnimator(animationOnButton: acceptBtn, x_space: rectAcceptBtn.origin.x, width_constant: rectAcceptBtn.size.width)
            
            ButtonAnimator(animationOnButton: declineBtn, x_space: rectDeclineBtn.origin.x, width_constant: rectDeclineBtn.size.width)
            
            acceptBtn.tag = 7//taskStatusType.InProgress.rawValue
            self.acceptBtn.setTitle(LanguageKey.job_resume, for: .normal)
            
            declineBtn.tag = 9//taskStatusType.Completed.rawValue
            self.declineBtn.setTitle(LanguageKey.job_finish, for: .normal)
            
            break

        case "10"://.Closed:
          //  print("do something when third button is tapped")
            break
            
            
        default:
       //.custam Status :
              self.isCustomStatusBool = "true"
              isCompliteBool = "true"
            ButtonAnimator(animationOnButton: acceptBtn, x_space:  rectAcceptBtn.origin.x, width_constant: (rectDeclineBtn.size.width + rectDeclineBtn.origin.x) - rectAcceptBtn.origin.x)
            
            statusViewEnable(isEnable: false)
            
            self.acceptBtn.setTitle(LanguageKey.completed, for: .normal)
            self.acceptBtn.backgroundColor = UIColor.init(red: 115.0/255.0, green: 216.0/255.0, blue: 21.0/255.0, alpha: 1.0)
            self.acceptBtn.isUserInteractionEnabled = false
            self.declineBtn.isUserInteractionEnabled = false
       
            statusTwoButtons_H.constant =  10.0
           
            self.view.layoutIfNeeded()
         
            isComplite = false
            self.requestForVisite.isHidden = false
         
            break
        
        }
    }
    
    
    func statusViewEnable(isEnable : Bool) -> Void {
//        H_statusVw.constant = isEnable ? 50.0 : 0.0
//        // H_statusVwBottom.constant = isEnable ? 4.0 : 0.0
//        UIView.animate(withDuration:isFirst ? 0.0 : 0.5) {
//            self.view.layoutIfNeeded()
        //}
    }
    
    
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
               
                URLQueryItem(name: "daddr", value: "\(lat?.description ?? ""),\(long?.description ?? "")"),
            ]
        } else {
            components.queryItems = [
                
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
        windowController.showToast(message: "A mail has been sent successfully.")
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            APP_Delegate.showBackButtonText()
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        

    }
    
    @IBAction func chatBtn(_ sender: Any) {
        if ((objOfUserJobListInDetail?.skype == "") && (objOfUserJobListInDetail?.twitter == "") && (objOfUserJobListInDetail?.skype == nil) && (objOfUserJobListInDetail?.skype == nil)) {
            ShowError(message: AlertMessage.chatNotAvailable, controller: windowController)
            return
        }
        
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
        if (costomerSingView != nil) {
            costomerSingView.removeFromSuperview()
        }
        
        if (mailPerView != nil) {
            mailPerView.removeFromSuperview()
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
            //        case .cancelled:
            //            print("")
            //        case .saved:
            //            print("")
        case .sent:
            //            print("")
            ShowError(message: AlertMessage.mailSend, controller: windowController)
       // case .failed:
            // print("Mail sent failure: \(error?.localizedDescription ?? "")")
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
    
    func foSelectSingnatureOpenDwopDown() {
        
        if (optionalVw == nil){
            self.backgroundView.isHidden = false
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = selectSingnatureView.convert(selectSingnatureView.bounds, from: self.view)
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
            self.backgroundView.isHidden = false
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = defaultJobCrdView.convert(defaultJobCrdView.bounds, from: self.view)
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
    
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayType == "1"{

            
            var cell = tableView.dequeueReusableCell(withIdentifier:"cell")
            
            for job in self.jobStatusArr{
                
                switch job.id {
                case "1":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                case "2":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                          DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                    
                case "3":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                case "4":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                case "5":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                case "6":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                case "7":
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                case "8":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                case "9":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                case "10":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                case "11":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                case "12":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
//                case "13":
//
//                    if job.isStatusShow == "0"{ // its default status and is allwass hide in status list
//
//                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
//
//                    }else{
//                        if job.isFwSelect == "0"{ // its default status and is allwass hide in status list
//                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
//                        }
//                    }
                    
                case "14":
                    
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        
                    }else{
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                    }
                    
                default: break
                    if job.isStatusShow == "0"{
                        
                        DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                    }else{
                        
                        if job.isFwSelect == "0"{
                            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                        }
                        
                    }
                }
            }
            

            jobStatusArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
            
            return jobStatusArr.count
            
            
        } else if self.arrayType == "2" {
            return fwArr.count
        }else if self.arrayType == "3" {
            
            return JobCardTemplatArr.count
        }
        return jobIdPrint.count
        
        
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"cell")
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier:"cell")
        }
        
        if self.arrayType == "1"{

            
            let i1 = jobStatusArr.firstIndex(where: {$0.id == "Reschedule"})
            let i2 = jobStatusArr.firstIndex(where: {$0.id == "Revisit"})
            if let index1 = i1 {
                jobStatusArr.swapAt(0, index1 )
               
            }
            if  let index2 = i2 {
                jobStatusArr.swapAt(1, index2 )
              
            }
           
            
            let status1 : String = String(describing: jobStatusArr[indexPath.row])
            let status  =  jobStatusArr[indexPath.row]
            
            cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
            cell?.isUserInteractionEnabled = true
            cell?.textLabel?.textColor = UIColor.darkGray
            cell?.textLabel?.text = status.text!.capitalizingFirstLetter()
           
                
            switch status.id {
            case "Reschedule":
                
                cell?.isUserInteractionEnabled = true
                cell?.textLabel?.textColor = UIColor.orange
                cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
                
            case "Revisit":
                
                cell?.isUserInteractionEnabled = true
                cell?.textLabel?.textColor = UIColor.blue
                cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
                

            default: break
                
                cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
                cell?.isUserInteractionEnabled = true
                cell?.textLabel?.textColor = UIColor.darkGray
                
            }
          
            
            cell?.textLabel?.text = status.text!.capitalizingFirstLetter()
          
            
        } else if self.arrayType == "2" {
            if demoArr1.count != 0 {
                
                cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
                cell?.backgroundColor = .clear
                cell?.textLabel?.textColor = UIColor.darkGray
                var ar = jobIdPrint[indexPath.row] as! String
                cell?.textLabel?.text = fwArr[indexPath.row] as! String
            }
        }else if self.arrayType == "3" {
            if fwArr.count != 0 {
                
                cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
                cell?.backgroundColor = .clear
                cell?.textLabel?.textColor = UIColor.darkGray
                cell?.textLabel?.text = JobCardTemplatArr[indexPath.row].tempJson1?.clientDetails![0].inputValue
            }
            
        }
        
        return cell!
    }
    
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.arrayType == "1"{
          //  getJobStatusList()
          //  jobStatusArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
            self.removeOptionalView()
            
            if rejectIsShow == "0" {
              
                if isPermitForShow(permission: permissions.isJobRevisitOrNot) == false{
                    
                    LocationManager.shared.isHaveLocation()
                    
                   // let status : taskStatusType = arrTypeStatus1[indexPath.row]
                    let status = jobStatusArr[indexPath.row].id
                    if currentStatusID != status {
                        if UserDefaults.standard.bool(forKey: "permission") {
                            //statusId = status
                            showDateAndTimePicker()
                        }else{
                            
                            if isHaveNetowork() ==  false {
                                if currentStatusID != status {
                                    ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                }
                                return
                            }
                          
                            let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
                                if(Int(obj.event!)! == Int(status!) &&  (Int(obj.totalQues!)! != 0)){
                                    return true
                                }else{
                                    return false
                                }
                            }
                            if(arrOFShowTabForm.count > 0){
                                let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
                                customFormVC.objOFTestVC = arrOFShowTabForm[0]
                                customFormVC.sltNaviCount = 0
                                customFormVC.isCameFrmStatusBtnClk = false
                                customFormVC.clickedEvent = Int(status!)
                                customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
                                customFormVC.optionID = "-1"
                                
                                customFormVC.callBackFofDetailJob = { (success) in
                                    if(success){
                                        self.ChangeButtonsAccordingToStatusType(status: self.jobStatusArr[indexPath.row].id!)
                                    }
                                    
                                }
                                self.navigationController?.navigationBar.topItem?.title = " "
                                self.navigationController?.pushViewController(customFormVC, animated: true)
                            }else{
                                
                                if currentStatusID != status {
                                    ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                }
                            }
                        }
                    }
                }else{
                    
                    LocationManager.shared.isHaveLocation()
                    
                  //  let status : taskStatusType = arrTypeStatusPermitionRevi1[indexPath.row]
                    let status = jobStatusArr[indexPath.row].id
                    if currentStatusID != status {
                        if UserDefaults.standard.bool(forKey: "permission") {
                           // statusId = status
                            showDateAndTimePicker()
                        }else{
                            
                            if isHaveNetowork() ==  false {
                                if currentStatusID != status {
                                    ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                }
                                return
                            }
                       
                            let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
                                if(Int(obj.event!)! == Int(status!) &&  (Int(obj.totalQues!)! != 0)){
                                    return true
                                }else{
                                    return false
                                }
                            }
                            if(arrOFShowTabForm.count > 0){
                                let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
                                customFormVC.objOFTestVC = arrOFShowTabForm[0]
                                customFormVC.sltNaviCount = 0
                                customFormVC.isCameFrmStatusBtnClk = false
                                customFormVC.clickedEvent = Int(status!)
                                customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
                                customFormVC.optionID = "-1"
                                
                                customFormVC.callBackFofDetailJob = { (success) in
                                    if(success){
                                        self.ChangeButtonsAccordingToStatusType(status: self.jobStatusArr[indexPath.row].id!)
                                    }
                                    
                                }
                                self.navigationController?.navigationBar.topItem?.title = " "
                                self.navigationController?.pushViewController(customFormVC, animated: true)
                            }else{
                                
                                if currentStatusID != status {
                                    
                                   // ChangeButtonsAccordingToStatusType(status: "0")
                                    ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                }
                            }
                        }
                    }
                }
                
              
            }else{
                if rejectIsSelect == "1"{
                   
                    if isPermitForShow(permission: permissions.isJobRevisitOrNot) == false{ // Revisit show
                        LocationManager.shared.isHaveLocation()
                        
                       // let status : taskStatusType = arrTypeStatus[indexPath.row]
                        let status = jobStatusArr[indexPath.row].id
                        if currentStatusID != status {
                      //  if currentStatusID != String(status.rawValue) {
                            if UserDefaults.standard.bool(forKey: "permission") {
                              //  statusId = status
                                showDateAndTimePicker()
                            }else{
                                
                                if isHaveNetowork() ==  false {
                                    if currentStatusID != status {
                                        ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                    }
                                    return
                                }
                                
                                let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
                                    if(Int(obj.event!)! == Int(status!) &&  (Int(obj.totalQues!)! != 0)){
                                        return true
                                    }else{
                                        return false
                                    }
                                }
                                if(arrOFShowTabForm.count > 0){
                                    let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
                                    customFormVC.objOFTestVC = arrOFShowTabForm[0]
                                    customFormVC.sltNaviCount = 0
                                    customFormVC.isCameFrmStatusBtnClk = false
                                    customFormVC.clickedEvent =  Int(status!)
                                    customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
                                    customFormVC.optionID = "-1"
                                    customFormVC.callBackFofDetailJob = { (success) in
                                        if(success){
                                            self.ChangeButtonsAccordingToStatusType(status: self.jobStatusArr[indexPath.row].id!)
                                        }
                                        
                                    }
                                    self.navigationController?.navigationBar.topItem?.title = " "
                                    self.navigationController?.pushViewController(customFormVC, animated: true)
                                }else{
                                    
                                    if currentStatusID != status {
                                        ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                    }
                                }
                            }
                        }
                    }else{ /// Revisit Hiden
                        LocationManager.shared.isHaveLocation()
                        
                       // let status : taskStatusType = arrTypeStatusPermitionRevi[indexPath.row]
                        if reshualArr == true{
                            let status = "Reschedule"//jobStatusArr[indexPath.row].id
                            if currentStatusID != status {
                                if UserDefaults.standard.bool(forKey: "permission") {
                                  //  statusId = status
                                    showDateAndTimePicker()
                                }else{
                                    
                                    if isHaveNetowork() ==  false {
                                        if currentStatusID != status {
                                            if reshualArr == true{
                                                if self.isCustomStatusBool == "true" {
                                                    ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                                }else{
                                                ChangeButtonsAccordingToStatusType(status: "Reschedule")
                                                }
                                            }else{
                                                ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                            }
                                           
                                        }
                                        return
                                    }
                                   
                                    let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
                                        if(Int(obj.event!)! == Int(status) &&  (Int(obj.totalQues!)! != 0)){
                                            return true
                                        }else{
                                            return false
                                        }
                                    }
                                    if(arrOFShowTabForm.count > 0){
                                        let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
                                        customFormVC.objOFTestVC = arrOFShowTabForm[0]
                                        customFormVC.sltNaviCount = 0
                                        customFormVC.isCameFrmStatusBtnClk = false
                                        customFormVC.clickedEvent = Int(status)
                                        customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
                                        customFormVC.optionID = "-1"
                                        customFormVC.callBackFofDetailJob = { (success) in
                                            if(success){
                                                if self.currentStatusID != status {
                                                    if self.reshualArr == true{
                                                        
                                                        if self.isCustomStatusBool == "true"{
                                                            self.ChangeButtonsAccordingToStatusType(status: self.jobStatusArr[indexPath.row].id!)
                                                        }else{
                                                            self.ChangeButtonsAccordingToStatusType(status: "Reschedule")
                                                        }
                                                    }else{
                                                        self.ChangeButtonsAccordingToStatusType(status: self.jobStatusArr[indexPath.row].id!)
                                                    }
                                                   
                                                }
                                            }
                                            
                                        }
                                        self.navigationController?.navigationBar.topItem?.title = " "
                                        self.navigationController?.pushViewController(customFormVC, animated: true)
                                    }else{
                                        
                                        if currentStatusID != status {
                                            if currentStatusID != status {
                                                if reshualArr == true{
                                                    if self.isCustomStatusBool == "true"{
                                                        self.ChangeButtonsAccordingToStatusType(status: self.jobStatusArr[indexPath.row].id!)
                                                    }else{
                                                        if self.jobStatusArr[indexPath.row].id! == "Reschedule" {
                                                            self.ChangeButtonsAccordingToStatusType(status: "Reschedule")
                                                        }else{
                                                            ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                                        }
                                                       
                                                    }
                                                }else{
                                                    ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                                }
                                               
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            let status = jobStatusArr[indexPath.row].id
                            if currentStatusID != status {
                                if UserDefaults.standard.bool(forKey: "permission") {
                                  //  statusId = status
                                    showDateAndTimePicker()
                                }else{
                                    
                                    if isHaveNetowork() ==  false {
                                        if currentStatusID != status {
                                            ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                        }
                                        return
                                    }
                                 
                                    let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
                                        if(Int(obj.event!)! == Int(status!) &&  (Int(obj.totalQues!)! != 0)){
                                            return true
                                        }else{
                                            return false
                                        }
                                    }
                                    if(arrOFShowTabForm.count > 0){
                                        let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
                                        customFormVC.objOFTestVC = arrOFShowTabForm[0]
                                        customFormVC.sltNaviCount = 0
                                        customFormVC.isCameFrmStatusBtnClk = false
                                        customFormVC.clickedEvent = Int(status!)
                                        customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
                                        customFormVC.optionID = "-1"
                                        customFormVC.callBackFofDetailJob = { (success) in
                                            if(success){
                                                self.ChangeButtonsAccordingToStatusType(status:  self.jobStatusArr[indexPath.row].id!)
                                            }
                                            
                                        }
                                        self.navigationController?.navigationBar.topItem?.title = " "
                                        self.navigationController?.pushViewController(customFormVC, animated: true)
                                    }else{
                                        
                                        if currentStatusID != status {
                                            ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                        }
                                    }
                                }
                            }
                        }
                      
                    }
                    
                    
                }else{
                   
                    if isPermitForShow(permission: permissions.isJobRevisitOrNot) == false{
                        
                        LocationManager.shared.isHaveLocation()
                        
                       // let status : taskStatusType = arrTypeStatus1[indexPath.row]
                        let status = jobStatusArr[indexPath.row].id
                        if currentStatusID != status {
                            if UserDefaults.standard.bool(forKey: "permission") {
                                //statusId = status
                                showDateAndTimePicker()
                            }else{
                                
                                if isHaveNetowork() ==  false {
                                    if currentStatusID != status {
                                        ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                    }
                                    return
                                }
                                
                                
                                
                                let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
                                    if(Int(obj.event!)! == Int(status!) &&  (Int(obj.totalQues!)! != 0)){
                                        return true
                                    }else{
                                        return false
                                    }
                                }
                                if(arrOFShowTabForm.count > 0){
                                    let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
                                    customFormVC.objOFTestVC = arrOFShowTabForm[0]
                                    customFormVC.sltNaviCount = 0
                                    customFormVC.isCameFrmStatusBtnClk = false
                                    customFormVC.clickedEvent = Int(status!)
                                    customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
                                    customFormVC.optionID = "-1"
                                    customFormVC.callBackFofDetailJob = { (success) in
                                        if(success){
                                            self.ChangeButtonsAccordingToStatusType(status:   self.jobStatusArr[indexPath.row].id!)
                                        }
                                        
                                    }
                                    self.navigationController?.navigationBar.topItem?.title = " "
                                    self.navigationController?.pushViewController(customFormVC, animated: true)
                                }else{
                                    
                                    if currentStatusID != status {
                                        ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                    }
                                }
                            }
                        }
                    }else{
                        
                        LocationManager.shared.isHaveLocation()
                        
                      //  let status : taskStatusType = arrTypeStatusPermitionRevi1[indexPath.row]
                        let status = jobStatusArr[indexPath.row].id
                        if currentStatusID != status {
                            if UserDefaults.standard.bool(forKey: "permission") {
                               // statusId = status
                                showDateAndTimePicker()
                            }else{
                                
                                if isHaveNetowork() ==  false {
                                    if currentStatusID != status {
                                        ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                    }
                                    return
                                }
                           
                                let arrOFShowTabForm = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
                                    if(Int(obj.event!)! == Int(status!) &&  (Int(obj.totalQues!)! != 0)){
                                        return true
                                    }else{
                                        return false
                                    }
                                }
                                if(arrOFShowTabForm.count > 0){
                                    let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
                                    customFormVC.objOFTestVC = arrOFShowTabForm[0]
                                    customFormVC.sltNaviCount = 0
                                    customFormVC.isCameFrmStatusBtnClk = false
                                    customFormVC.clickedEvent = Int(status!)
                                    customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
                                    customFormVC.optionID = "-1"
                                    customFormVC.callBackFofDetailJob = { (success) in
                                        if(success){
                                            self.ChangeButtonsAccordingToStatusType(status: self.jobStatusArr[indexPath.row].id!)
                                        }
                                        
                                    }
                                    self.navigationController?.navigationBar.topItem?.title = " "
                                    self.navigationController?.pushViewController(customFormVC, animated: true)
                                }else{
                                    
                                    if currentStatusID != status {
                                        
                                       // ChangeButtonsAccordingToStatusType(status: "0")
                                        ChangeButtonsAccordingToStatusType(status: jobStatusArr[indexPath.row].id!)
                                    }
                                }
                            }
                        }
                    }
                  
                }
            }

            
        } else if self.arrayType == "2" {
            self.selectSingnatureTxtFld.text = fwArr[indexPath.row] as! String
            self.jobIdPrint1 = jobIdPrint[indexPath.row] as! String
            self.removeOptionalView()
            //self.backGroundBtn.isHidden = true
           // self.emailView.isHidden = true
           
        }else if self.arrayType == "3" {
            self.selectTemplateTxtFld.text = JobCardTemplatArr[indexPath.row].tempJson1?.clientDetails![0].inputValue
            self.templateId = JobCardTemplatArr[indexPath.row].jcTempId ?? ""
            self.removeOptionalView()
         
            
        }
        
         
    }
  
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
        
        if jobBreak == true || onHold == true || completed == true || inProgress == true || travelling == true || accepted == true || break1 == true {
            
            self.onHold = false
            self.jobBreak = false
            self.completed = false
            self.inProgress = false
            self.cancel = false
            self.reject = false
            self.travelling = false
            self.accepted = false
            self.break1 = false
            
            ShowAlert(title: "", message: LanguageKey.send_client_mail,controller: windowController, cancelButton: LanguageKey.no as NSString, okButton: LanguageKey.yes as NSString, style: .alert) { (NO, OK) in
                if OK {
            
                    let param = Params()
                    param.jobId = job.jobId
                    param.usrId = getUserDetails()?.usrId
                    param.type = job.type
                    param.status =   String(format: "%d",statusId)
                    print("JOB STATUS \(statusId)")
                    param.lat = lat
                    param.lng = lon
                    param.device_Type = "2"
                    param.isMailSentToClt = "1"
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
//                        let tempId = ladksj?[0]
//                        if tempId == "Job" {
//                            let dict = param.toDictionary
//                            let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineJob") as! OfflineJob
//                            userJobs.apis = Service.addItemOnJob
//                            userJobs.parametres = dict?.toString
//                            userJobs.time = Date()
//
//                            DatabaseClass.shared.saveEntity(callback: {_ in
//                                DatabaseClass.shared.syncDatabase()
//
//                            })
//                        } else {
                            DatabaseClass.shared.saveOffline(service: Service.changeJobStatus, param: param)
                        
                            let message = ChatMessageModelForJob1()
                            let message1 = ChatMessageModel()
                            message.usrId = self.objOfUserJobListInDetail?.kpr
                            message.action = "JobStatus"
                            message.msg = "A Job status of job \(self.objOfUserJobListInDetail?.label ?? "") has been updated by fieldworker \(getUserDetails()?.username ?? "")."
                            message.usrNm = trimString(string: "\(getUserDetails()?.fnm ?? "")")
                            message.usrType = "2"
                            message.id =  self.objOfUserJobListInDetail?.jobId
                            message.type = "JOB"
                            message.statusId =  String(format: "%d",statusId)
                            ChatManager.shared.sendClientdMessageForJob(jobid: self.objOfUserJobListInDetail?.jobId ?? "", messageDict: message)
                            
                       // }
                    }
                }
                
                if NO {
                    
                    
                    let param = Params()
                    param.jobId = job.jobId
                    param.usrId = getUserDetails()?.usrId
                    param.type = job.type
                    param.status =   String(format: "%d",statusId)
                    print("JOB STATUS1 \(statusId)")
                    param.lat = lat
                    param.lng = lon
                    param.device_Type = "2"
                    param.isMailSentToClt = "0"
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
                      //  let tempId = ladksj?[0]
//                        if tempId == "Job" {
//                            let dict = param.toDictionary
//                            let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineJob") as! OfflineJob
//                            userJobs.apis = Service.addItemOnJob
//                            userJobs.parametres = dict?.toString
//
//                            userJobs.time = Date()
//
//                            DatabaseClass.shared.saveEntity(callback: {_ in
//                                DatabaseClass.shared.syncDatabase()
//
//                            })
//                        } else {
                            DatabaseClass.shared.saveOffline(service: Service.changeJobStatus, param: param)
                          
                            let message = ChatMessageModelForJob1()
                            let message1 = ChatMessageModel()
                            message.usrId = self.objOfUserJobListInDetail?.kpr
                            message.action = "JobStatus"
                            message.msg = "A Job status of job \(self.objOfUserJobListInDetail?.label ?? "") has been updated by fieldworker \(getUserDetails()?.username ?? ""). "
                            message.usrNm = trimString(string: "\(getUserDetails()?.fnm ?? "")")
                            message.usrType = "2"
                            message.id =  self.objOfUserJobListInDetail?.jobId
                            message.type = "JOB"
                            message.statusId =  String(format: "%d",statusId)
                            
                            ChatManager.shared.sendClientdMessageForJob(jobid: self.objOfUserJobListInDetail?.jobId ?? "", messageDict: message)
                         
                       // }
                    }
                 
                }
            }
        
        }else{
            
            let param = Params()
            param.jobId = job.jobId
            param.usrId = getUserDetails()?.usrId
            param.type = job.type
            param.status = String(format: "%d",statusId)
            print("JOB STATUS2 \(statusId)")
            param.lat = lat
            param.lng = lon
            param.device_Type = "2"
            if rejectVelue == "0" {
                rejectVelue = "0"
                param.isMailSentToClt = ""
            }
            if rejectVelue == "1" {
                rejectVelue = "0"
                param.isMailSentToClt = "1"
            }
            if rejectVelue == "2" {
                rejectVelue = "0"
                param.isMailSentToClt = "0"
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//"dd-MM-yyyy hh:mm:ss a"
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
//                let tempId = ladksj?[0]
//                if tempId == "Job" {
//                    let dict = param.toDictionary
//                    let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineJob") as! OfflineJob
//                    userJobs.apis = Service.addItemOnJob
//                    userJobs.parametres = dict?.toString
//
//                    userJobs.time = Date()
//
//                    DatabaseClass.shared.saveEntity(callback: {_ in
//                        DatabaseClass.shared.syncDatabase()
//
//                    })
//                } else {
                    DatabaseClass.shared.saveOffline(service: Service.changeJobStatus, param: param)
                    
                    let message = ChatMessageModelForJob1()
                    let message1 = ChatMessageModel()
                    message.usrId = self.objOfUserJobListInDetail?.kpr
                    message.action = "JobStatus"
                    message.msg = "A Job status of job \(objOfUserJobListInDetail?.label ?? "") has been updated by fieldworker \(getUserDetails()?.username ?? ""). "
                    
                    message.usrNm = trimString(string: "\(getUserDetails()?.fnm ?? "")")
                    message.usrType = "2"
                    message.id =  self.objOfUserJobListInDetail?.jobId
                    message.type = "JOB"
                    message.time = getCurrentTimeStamp()
                    message.statusId =  String(format: "%d",statusId)
                    
                    ChatManager.shared.sendClientdMessageForJob(jobid: self.objOfUserJobListInDetail?.jobId ?? "", messageDict: message)
                    
               // }
            }
        }
    }

    @IBAction func pickerBtn(_ sender: UIButton) {
      
        if sender.tag == 0{
            
            if isaForActualAadTravel == true {// FOR ACTUAL
                if actualStartDateTime == true {
                    let dateFormmater1 = DateFormatter()
                    dateFormmater1.dateFormat =  "yyyy-MM-dd HH:mm:ss"
                    dateFormmater1.timeZone = TimeZone.current
                    dateFormmater1.locale = Locale(identifier: "en_US")
                    if let langCode = getCurrentSelectedLanguageCode() {
                        dateFormmater1.locale = Locale(identifier: langCode)
                    }
                    actualStartDateTimeFor = dateFormmater1.string(from: detailDatePicker.date)
                    
                    let dateFormmater = DateFormatter()
                    dateFormmater.dateFormat =  "d-MMM-yyyy HH:mm a"
                    dateFormmater.timeZone = TimeZone.current
                    dateFormmater.locale = Locale(identifier: "en_US")
                    if let langCode = getCurrentSelectedLanguageCode() {
                        dateFormmater1.locale = Locale(identifier: langCode)
                    }
                    self.compltnStartDate.text = dateFormmater.string(from: detailDatePicker.date)
                    detailDatePicker.isHidden = true
                    pickerTabView.isHidden = true
                    hideBackgroundView()
                  
                    self.backGroundBtn.isHidden = false
                    self.complationDetailView.isHidden = false
                    
                }else if actualEndDateTime == true {
                    let dateFormmater1 = DateFormatter()
                    dateFormmater1.dateFormat =  "yyyy-MM-dd HH:mm:ss"
                    dateFormmater1.timeZone = TimeZone.current
                    dateFormmater1.locale = Locale(identifier: "en_US")
                   
                    
                    let dateFormmater = DateFormatter()
                    dateFormmater.dateFormat =  "d-MMM-yyyy HH:mm a"
                    dateFormmater.timeZone = TimeZone.current
                    dateFormmater.locale = Locale(identifier: "en_US")
                    if let langCode = getCurrentSelectedLanguageCode() {
                        dateFormmater.locale = Locale(identifier: langCode)
                    }
                    self.compltnEndDate.text = dateFormmater.string(from: detailDatePicker.date)
                    if  String(self.compltnStartDate.text ?? "") <  String(self.compltnEndDate.text ?? "") {
                        if let langCode = getCurrentSelectedLanguageCode() {
                            dateFormmater1.locale = Locale(identifier: langCode)
                        }
                        actualEndDateTimeFor = dateFormmater1.string(from: detailDatePicker.date)
                        compltnEndDate.text = dateFormmater.string(from: detailDatePicker.date)
                        detailDatePicker.isHidden = true
                        pickerTabView.isHidden = true
                        hideBackgroundView()
                    }else{
                    
                        ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.error_actual_start_end)!, controller: windowController)
                        hideBackgroundView()
                        self.backGroundBtn.isHidden = false
                        self.complationDetailView.isHidden = false
                    }
                   
                }
                
            }else if isaForActualAadTravel == false {
                if travelStartDateTime == true {
                    let dateFormmater1 = DateFormatter()
                    dateFormmater1.dateFormat =  "yyyy-MM-dd HH:mm:ss"
                    dateFormmater1.timeZone = TimeZone.current
                    dateFormmater1.locale = Locale(identifier: "en_US")
                    if let langCode = getCurrentSelectedLanguageCode() {
                        dateFormmater1.locale = Locale(identifier: langCode)
                    }
                    travelStartDateTimeFor = dateFormmater1.string(from: detailDatePicker.date)
                    
                    let dateFormmater = DateFormatter()
                    dateFormmater.dateFormat =  "d-MMM-yyyy HH:mm a"
                    dateFormmater.timeZone = TimeZone.current
                    dateFormmater.locale = Locale(identifier: "en_US")
                    if let langCode = getCurrentSelectedLanguageCode() {
                        dateFormmater.locale = Locale(identifier: langCode)
                    }
                    self.compltnStartDate.text = dateFormmater.string(from: detailDatePicker.date)
                   
                    if  TravelVelidationEditTm == true {
                        ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.time_out_of_scope)!, controller: windowController)
                        hideBackgroundView()
                        self.backGroundBtn.isHidden = false
                        self.complationDetailView.isHidden = false
                        self.compltnStartDate.text = "Travel Start Date Time"
                        //self.backGroundBtn.isHidden = false
                    }else{
                        detailDatePicker.isHidden = true
                        pickerTabView.isHidden = true
                        hideBackgroundView()
                        self.backGroundBtn.isHidden = false
                        self.complationDetailView.isHidden = false
                    }
               
                }else if travelEndDateTime == true {
                    let dateFormmater1 = DateFormatter()
                    dateFormmater1.dateFormat =  "yyyy-MM-dd HH:mm:ss"
                    dateFormmater1.timeZone = TimeZone.current
                    dateFormmater1.locale = Locale(identifier: "en_US")
                    if let langCode = getCurrentSelectedLanguageCode() {
                        dateFormmater1.locale = Locale(identifier: langCode)
                    }
                    travelEndDateTimeFor = dateFormmater1.string(from: detailDatePicker.date)
                    
                    let dateFormmater = DateFormatter()
                    dateFormmater.dateFormat =  "d-MMM-yyyy HH:mm a"
                    dateFormmater.timeZone = TimeZone.current
                    dateFormmater.locale = Locale(identifier: "en_US")
                    if let langCode = getCurrentSelectedLanguageCode() {
                        dateFormmater.locale = Locale(identifier: langCode)
                    }
                    compltnEndDate.text = dateFormmater.string(from: detailDatePicker.date)
                    //==
                    
                    if  TravelVelidationEditTm == true {
                        ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.time_out_of_scope)!, controller: windowController)
                        hideBackgroundView()
                        self.backGroundBtn.isHidden = false
                        self.complationDetailView.isHidden = false
                        self.compltnStartDate.text = "Travel End Date Time"
                        //self.backGroundBtn.isHidden = false
                    }else{
                        detailDatePicker.isHidden = true
                        pickerTabView.isHidden = true
                        hideBackgroundView()
                        self.backGroundBtn.isHidden = false
                        self.complationDetailView.isHidden = false
                        
                    }
        
                }
            }else{
                let dateFormmater = DateFormatter()
                dateFormmater.dateFormat = "yyyy-MM-dd HH:mm:ss"//"dd-MM-yyyy hh:mm:ss a"
                dateFormmater.timeZone = TimeZone.current
                dateFormmater.locale = Locale(identifier: "en_US")
                sltDate = dateFormmater.string(from: detailDatePicker.date)
                detailDatePicker.isHidden = true
                pickerTabView.isHidden = true
                hideBackgroundView()
                //ChangeButtonsAccordingToStatusType(status: statusId!)
            }

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
    
    
    //===============================
    // MARK:- GetQuestionsList
    //===============================
 
    
    func getQuestionsByParentId(patmid:String){
        
       
        let param = Params()
        param.ansId =  "-1"
        param.frmId = patmid
        // param.usrId = getUserDetails()?.usrId
        param.jobId = self.objOfUserJobListInDetail?.jobId
        
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
                                    let daretype = jtid.type
                                    ///
                                    strTitless = strTitless + dare!
                                    //                                    for jtid in asc {
                                    let dares = jtid.ans
                                    
                                    if dares.count > 0 {
                                        for ans in dares {
                                            let ans1 = ans.value
                                            
                                            if ans1 != nil {
                                                self.coustomFldBtn.setTitle(LanguageKey.edit , for: .normal)
                                            }
                                            
                                            if strTitless == "" {
                                                strTitless = ans1 ?? ""
                                            }else{
                                                
                                                if let sss = Int(ans1 ?? ""){
                                                    if daretype == "2"{
                                                        strTitless = "\(strTitless): \(ans1 ?? "")\n"
                                                        self.Strjhings = strTitless
                                                    }else if  daretype == "3"{
                                                        strTitless = "\(strTitless): \(ans1 ?? "")\n"
                                                        self.Strjhings = strTitless
                                                    }else{
                                                        
                                                        var ss = ""
                                                        
                                                        if daretype == "5"{
                                                            ss = DateFormate.dd_MMM_yyyy.rawValue
                                                            let sssa =  createDateTimeForCustomFieldamdForm(timestamp:sss.description, dateFormate:ss)
                                                            strTitless = "\(strTitless): \(sssa ?? "")\n"
                                                            self.Strjhings = strTitless
                                                            
                                                        }else{
                                                            if daretype == "7"{
                                                                
                                                                if let is24hrFormatEnable = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                                                                    if is24hrFormatEnable == "0"{
                                                                        ss = DateFormate.ddMMMyyyy_hh_mm_a.rawValue
                                                                    }else{
                                                                        ss = DateFormate.ddMMMyyyy_hh_mm.rawValue
                                                                    }
                                                                }
                                                                
                                                               
                                                                let sssa =  createDateTimeForCustomFieldamdForm(timestamp:sss.description, dateFormate:ss)
                                                                strTitless = "\(strTitless): \(sssa ?? "")\n"
                                                                self.Strjhings = strTitless
                                                            }else{
                                                                if daretype == "4"{
                                                                    strTitless = "\(strTitless): \(ans1 ?? "")\n"
                                                                    self.Strjhings = strTitless

                                                                }else{
                                                                    ss = DateFormate.hh_mm_a.rawValue
                                                                    let sssa =  createDateTimeForCustomFieldamdForm(timestamp:sss.description, dateFormate:ss)
                                                                    strTitless = "\(strTitless): \(sssa ?? "")\n"
                                                                    self.Strjhings = strTitless
                                                                }
                                                            }
                                                           
                                                        }
                                                  
                                                    }
                                                  
                                                }else{
                                                    strTitless = "\(strTitless): \(ans1 ?? "")\n"
                                                    self.Strjhings = strTitless
                                                }
                                                
                                            }
                                        
                                        }
                                    }else{
                                        strTitless = strTitless + ": \n"
                                    }
                                    
                                }

                                self.coustemFldDes.text = strTitless
                            }
                            
                        }else{
                            if self.arrOfShowData.count == 0{
                                DispatchQueue.main.async {
                              
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
        
        let param = Params()
        
        param.frmId = ""
        param.type = "1"
   
        
        serverCommunicator(url: Service.getFormDetail, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                
                
                
                if let decodedData = try? decoder.decode(FormDetail.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                       
                        self.arrOfShowDatas = decodedData.data
                        
                        self.getQuestionsByParentId(patmid: decodedData.data.frmId!)
                   
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
    
    // this is by Dharmendra

    //===========================================
    //MARK:- Stop recur Api Calling Method
    //===========================================
    
    func getStopRecur(){
        showLoader()
        let param = Params()
        param.jobId = objOfUserJobListInDetail?.jobId

        serverCommunicator(url: Service.deleteRecur, param: param.toDictionary) { (response, success) in
            
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(DeleteRecur.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        DispatchQueue.main.async {
                            windowController.showToast(message:"Recur pattern deleted successfully.")
                        self.navigationController?.popViewController(animated: true)
                        }
                        
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                ShowError(message: "Please try again!", controller: windowController)
            }
        }
        
    }
    
    @IBAction func recurBtnDelete(_ sender: Any) {
   
        ShowAlert(title: "", message: LanguageKey.delete_recur_msg, controller: windowController, cancelButton: LanguageKey.no as NSString, okButton: LanguageKey.yes as NSString, style: .alert) { (NO, OK) in
            if OK {
                self.getStopRecur()
                }
            
            if NO {
            
            }
        }
       
    }
    
   func didStart() {
         // print("Start Signature")
      }
      
      func didFinish() {
         //  print("Finish Signature")
      }
    
    
       func feedbackService()  {

                  
                  showLoader()
                  var image : UIImage? = nil
                  if let signatureImage = self.signaturePadView.getSignature(scale: 1) {
                  image = signatureImage
                  // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
                  self.signaturePadView.clear()
                  }
                  
                  let param = Params()
               
                  param.jobId = objOfUserJobListInDetail?.jobId
                  self.signaturePadView.clear()
                  serverCommunicatorUplaodJobCardSignImage(url: Service.uploadJobCardSign, param: param.toDictionary, image: image, imagePath: "signImg", imageName: "image") { (response, success) in
                      
                      killLoader()
                      
                      if(success){
                         DispatchQueue.main.async{
                         // let decoder = JSONDecoder()
                        self.hideBackgroundView()
                               self.backGroundBtn.isHidden = true
                               self.emailView.isHidden = true
                        }
                        self.getJobListService()
                        ShowAlert(title: nil, message:"signature uploaded successfully", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
   
                      }else{
                          ShowError(message: errorString, controller: windowController)
                      }
                  }
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
                   self.collectionTblView.isHidden = true
                    killLoader()
               }
               return
           }
           
           // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getDocumentsList) as? String
          // showLoader()
           let param = Params()
        param.jobId = objOfUserJobListInDetail?.jobId
        param.usrId = getUserDetails()?.usrId
        param.type = "6"
           
           serverCommunicator(url: Service.getDocumentsList, param: param.toDictionary) { (response, success) in
               killLoader()
               
               DispatchQueue.main.async {

               }
               if(success){
                   let decoder = JSONDecoder()
                   if let decodedData = try? decoder.decode(DocumentRes.self, from: response as! Data) {
                       DispatchQueue.main.async {
                          // self.lblAlertMess.isHidden = true
                       }
                       
                       if decodedData.success == true{
                           
                           self.arrOfShowDataCom = decodedData.data!
                           

                       
                           if (decodedData.data?.count ?? 0) > 0 {
                               
                               DispatchQueue.main.async {
                                
                                   self.complitationHightView = true
                                    self.complationNts_H.constant = 290//221
                                   
                                   self.actualDropDwnImg.image = UIImage(named: "drop-down-blue")
                                   self.actualCompView_H.constant = 30
                                   self.actualstartDateTmLbl.isHidden = true
                                   self.actualendDateTmLbl.isHidden = true
                                   self.editActualComDetail.isHidden = true
                                   self.travelJobLbl.isHidden = true
                                   self.travelStartDateTmLbl.isHidden = true
                                   self.travelEndDateTmLbl.isHidden = true
                                   self.editTravelCompDetail.isHidden = true
                                   self.actualTimeImage.isHidden = true
                                   self.buttonSwitched = true
                                   self.travelTimeImg.isHidden = true
                              
                                self.collectionTblView.isHidden = false
                                self.collectionTblView.reloadData()

                               }
                               
                           }else{
                               
                               DispatchQueue.main.async {
                                   self.complitationHightView = false
                                 
                                   if self.objOfUserJobListInDetail?.complNote != "" && self.objOfUserJobListInDetail?.complNote != nil {
                                       self.complationNts_H.constant = 150//110 + 130
                                       self.actualDropDwnImg.image = UIImage(named: "drop-down-blue")
                                       self.actualCompView_H.constant = 30
                                       self.actualstartDateTmLbl.isHidden = true
                                       self.actualendDateTmLbl.isHidden = true
                                       self.editActualComDetail.isHidden = true
                                       self.travelJobLbl.isHidden = true
                                       self.travelStartDateTmLbl.isHidden = true
                                       self.travelEndDateTmLbl.isHidden = true
                                       self.editTravelCompDetail.isHidden = true
                                       self.actualTimeImage.isHidden = true
                                       self.buttonSwitched = true
                                       self.travelTimeImg.isHidden = true
                                  }else{
                                       self.complationNts_H.constant = 80//110 + 130
                                      self.actualDropDwnImg.image = UIImage(named: "drop-down-blue")
                                      self.actualCompView_H.constant = 30
                                      self.actualstartDateTmLbl.isHidden = true
                                      self.actualendDateTmLbl.isHidden = true
                                      self.editActualComDetail.isHidden = true
                                      self.travelJobLbl.isHidden = true
                                      self.travelStartDateTmLbl.isHidden = true
                                      self.travelEndDateTmLbl.isHidden = true
                                      self.editTravelCompDetail.isHidden = true
                                      self.actualTimeImage.isHidden = true
                                      self.buttonSwitched = true
                                      self.travelTimeImg.isHidden = true
                                  }
                                 
                                   self.collectionTblView.isHidden = true
                                   
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
     
     func updateDocumentDescription(documentid : String, documentDescription : String,  isAddAttachAsCompletionNote : Int , completion : @escaping (()->(Void))) {
         /*
          jobId -> Job  id
          */
         
         if !isHaveNetowork() {
             DispatchQueue.main.async {
                // self.lblAlertMess.isHidden = false
                 self.collectionTblView.isHidden = true
                 
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

             }
             
             completion()
             if(success){
                 let decoder = JSONDecoder()
                 if let decodedData = try? decoder.decode(CommonResponse.self, from: response as! Data) {
                     DispatchQueue.main.async {
                         //self.getJobListService()
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
    
    //=====================================
    // MARK:- get All Company Settings
    //=====================================
    
    func getAllCompanySettings(){
        
        ChatManager.shared.ref.database.goOnline() // make sure online realtime database
        
        let param = Params()
        param.usrId = getUserDetails()!.usrId
        param.devType = "2"
        
        serverCommunicator(url: Service.getMobileDefaultSettings, param: param.toDictionary) { (response, success) in
            
            if success {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(DefaultSettingResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                    
                        self.confirmationTriggerArray = (decodedData.data!.confirmationTrigger)!
                        
                        //print(self.confirmationTriggerArray)
                        
                        for admin in self.confirmationTriggerArray {
                                   // Get admin's path for notification messages add
                                   
                            
                               }

                        
                    }else{
                        //self.processForCreateNode() // Intailise firebase
                    }
                }else{
                    killLoader()
                }
            }else {
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getAllCompanySettings()
                    }
                })
            }
        }
    }
    
    
    
    //==================================
    // MARK:- JOB LIST Service methods
    //==================================
    
            func getQuoteListService(){
                
         
                
                
                var dates = ("","")
    
                 
                let param = Params()
                param.compId = getUserDetails()?.compId
                param.usrId = getUserDetails()?.usrId
                param.limit = ContentLimit
                param.index = "\(count1)"
                param.search = searchTxt
                param.dtf = dates.0
                param.dtt = dates.1
                var dict = param.toDictionary
                dict!["status"] = selectedStatus
             //   print(dict!)
                
                serverCommunicator(url: Service.getAdminQuoteList, param: dict) { (response, success) in
                    
//                    DispatchQueue.main.async {
//                        if self.refreshControl.isRefreshing {
//                            self.refreshControl.endRefreshing()
//                        }
//                    }
                    
                    if(success){
                        let decoder = JSONDecoder()
                        
                        if let decodedData = try? decoder.decode(QuotationRes.self, from: response as! Data) {
                            if decodedData.success == true{
                                
                                if self.count1 == 0 {
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
                                        
                                        self.count1 += (decodedData.data?.count)!
                                       // self.quotation = decodedData.data as! [QuotationData]
                                     
                                    }else{
                                       // self.showDataOnTableView(query : "")
                                    }
                                }else{
                                   // self.showDataOnTableView(query : "")
                                }
                                
                                if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count1){
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
       //==================================
       // MARK:- JOB LIST Service methods
       //==================================
    
    func getJobListService(){
           

           
           let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getJobList) as? String
           let param = Params()
           param.usrId = getUserDetails()?.usrId
           param.limit = "100"
           param.index = "0"
           param.search = ""
           param.dateTime = lastRequestTime ?? ""//currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
           
           
        serverCommunicator(url: Service.getUserJobListNew, param: param.toDictionary) { [self] (response, success) in
               

               
               if(success){
                   let decoder = JSONDecoder()
                   
                   if let decodedData = try? decoder.decode(jobListResponse.self, from: response as! Data) {
                       if decodedData.success == true{
                           
                           //print("jugaljob \(decodedData)")
                           
                           if let arryCount = decodedData.data{
                               if arryCount.count > 0{
                                   
                                   
                                   
                                   self.count += (decodedData.data?.count)!
                                   
                                   if !self.isUserfirstLogin {
                                       
                                       self.saveUserJobsInDataBase(data: decodedData.data!)
                                       
                                       //Request time will be update when data comes otherwise time won't be update
                                       UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getJobList)
                                       DispatchQueue.main.async {
                                       var singImage = objOfUserJobListInDetail?.signature ?? ""
                                       if singImage != "" {
                                           if let img = objOfUserJobListInDetail!.signature {
                                               let imageUrl = Service.BaseUrl + img
                                               singnatureImg.sd_setImage(with: URL(string: imageUrl) )
                                           }else{
                                               singnatureImg.image = UIImage(named: "unknownDoc")
                                           }
                                       }
                                       }
                                   }else{
                                       self.saveAllUserJobsInDataBase(data: decodedData.data!)
                                   }
                               }else{
                                   //
                               }
                           }else{
                               
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
                }else if (Int(job.status!) == 4) ||
                    (Int(job.status!) == 3) ||
                    (Int(job.status!) == 10)
                {
                    ChatManager.shared.removeJobForChat(jobId: existingJob.jobId!)
                    DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                }else{
                    existingJob.setValuesForKeys(job.toDictionary!)
                    // DatabaseClass.shared.saveEntity()
                }
            }else{
                if(job.isdelete != "0") {
                    if (Int(job.status!) != 4) &&
                        (Int(job.status!) != 3) &&
                        (Int(job.status!) != 10)
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
                if (Int(job.status!) != 4) &&
                    (Int(job.status!) != 3) &&
                    (Int(job.status!) != 10)
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
    
    func setDataforEquipment(){
        equipmentData.removeAll()
        let searchQuery = "jobId = '\(objOfUserJobListInDetail!.jobId ?? "")'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
        if isExist.count > 0{
            objOfUserJobListInDetail!.equArray = isExist[0].equArray
               if objOfUserJobListInDetail!.equArray != nil {
                   for item in (objOfUserJobListInDetail!.equArray as! [AnyObject]) {
                    if let dta = item as? equArray {
                    }else{
                        var arrTac = [AttechmentArry]()
                        
                        if item["attachments"] != nil {
                            
                            let attachments =  item["attachments"] as? [AnyObject]
                            if attachments?.count ?? 0 > 0 {
                                
                                for attechDic in attachments! {
                                    arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                                }
                             
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                                
                           
                                equipmentData.append(dic)

                                
                            }else {
                                let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                         
                                
                                equipmentData.append(dic)
                                
                              
                            }
                        }
                    }
                }
               }
        }
        equipDataPartArr.removeAll()
        filterequipmentData.removeAll()
        for dic in equipmentData {
           
            if dic.parentId == "0" {
                if dic.isPart == "0" {
                    let model = equipDataPartArray(equId: dic, equePartArr: [])
                    
                    equipDataPartArr.append(model)
                }else {
                    if equipDataPartArr.count > 0 {
                      
                        if let index = equipDataPartArr.index(where: {$0.equeDic?.equId ?? "0" == dic.parentId}) {
                            
                           // print(index)
                            equipDataPartArr[index].equePartArr?.append(dic)
                            
                        }else {
                            filterequipmentData.append(dic)
                            let model = equipDataPartArray(equId: dic, equePartArr: [])
                            equipDataPartArr.append(model)
                        }
                    }
                }
                
            }else {
                
                if let index = equipDataPartArr.index(where: {$0.equeDic?.equId ?? "0" == dic.parentId}) {
                    
                  //  print(index)
                    equipDataPartArr[index].equePartArr?.append(dic)
                    
                }else{
                    let model = equipDataPartArray(equId: dic, equePartArr: [])
                    equipDataPartArr.append(model)
                    
                }
                
                
            }
            
        }
        
    
        if equipDataPartArr.count == 0 {
            self.H_equipmentView.constant = 55
        }else if equipDataPartArr.count == 1 {
            self.H_equipmentView.constant = 155
        }else if equipDataPartArr.count == 2 {
            self.H_equipmentView.constant = 255
        }else if equipDataPartArr.count == 3 {
            self.H_equipmentView.constant = 355
        }else if equipDataPartArr.count == 4 {
            self.H_equipmentView.constant = 455
        }else if equipDataPartArr.count == 5 {
            self.H_equipmentView.constant = 555
        }else if equipDataPartArr.count == 6 {
            self.H_equipmentView.constant = 655
        }else if equipDataPartArr.count == 7 {
            self.H_equipmentView.constant = 755
        }else if equipDataPartArr.count == 8 {
            self.H_equipmentView.constant = 855
        }else if equipDataPartArr.count == 9 {
            self.H_equipmentView.constant = 955
        }else if equipDataPartArr.count == 10 {
            self.H_equipmentView.constant = 1055
        }
        
        
    }
    
    func setDataForItem(){
      itemDetailedData.removeAll()
        if objOfUserJobListInDetail!.itemData != nil {
            for item in (objOfUserJobListInDetail!.itemData as! [AnyObject]) {

            // print(item)
            if let dta = item as? itemData {

          //  print(dta)

            }else{
            if item["tax"] != nil {
            let tax = item["tax"] as! [AnyObject]
            if tax.count > 0 {
            var arrTac = [texDic]()
            for taxDic in tax {
            arrTac.append(texDic(ijtmmId: taxDic["ijtmmId"] as? String, ijmmId: taxDic["ijmmId"] as? String, taxId: taxDic["taxId"] as? String, rate: taxDic["rate"] as? String, label: taxDic["label"] as? String))


            }
            let ammount = amounc(qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String,arrTax: arrTac)
                let dic = ItemDic(ijmmId: item["ijmmId"] as? String, itemId: item["itemId"] as? String, jobId: objOfUserJobListInDetail!.jobId , groupId: item["groupId"] as? String, des: item["des"] as? String, inm: item["inm"] as? String, qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String, amount: ammount, tax: arrTac, hsncode: item["hsncode"] as? String, pno: item["pno"] as? String, unit: item["unit"] as? String, taxamnt: item["taxamnt"] as? String, supplierCost: item["supplierCost"] as? String,dataType: item["dataType"] as? String, serialNo: item["serialNo"] as? String,isBillable: item["isBillable"] as? String, isBillableChange: item["isBillableChange"] as? String , warrantyType: item["warrantyType"] as? String, warrantyValue: item["warrantyValue"] as? String)
                
            itemDetailedData.append(dic)
                
                
            } else {
            let ammount = amounc(qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String)
          

                let dic = ItemDic(ijmmId: item["ijmmId"] as? String, itemId: item["itemId"] as? String, jobId: objOfUserJobListInDetail!.jobId , groupId: item["groupId"] as? String, des: item["des"] as? String, inm: item["inm"] as? String, qty: item["qty"] as? String, rate: item["rate"] as? String, discount: item["discount"] as? String, amount: ammount, tax: [], hsncode: item["hsncode"] as? String, pno: item["pno"] as? String, unit: item["unit"] as? String, taxamnt: item["taxamnt"] as? String, supplierCost: item["supplierCost"] as? String,dataType: item["dataType"] as? String, serialNo: item["serialNo"] as? String,isBillable: item["isBillable"] as? String, isBillableChange: item["isBillableChange"] as? String, warrantyType: item["warrantyType"] as? String, warrantyValue: item["warrantyValue"] as? String)
            itemDetailedData.append(dic)
                
            }
                
            }
            }
                
            }

            
            // FOR ITEM PART IS HIDEN :-
            let  isItem = isPermitForShow(permission: permissions.isItemVisible)
            if isfooter?.count != nil {
                for i in 0 ..< isfooter!.count{
                    if i < 4 {
                        
                        if isfooter![i].isEnable == "1"{
                            if JobItemQuantityFormEnable == "0" {
                                if isItem && isfooter![i].menuField == "set_itemMenuOdrNo"{
                                    
                                    
                                    if itemDetailedData.count == 0 {
                                        self.H_attechmntView.constant = 55
                                    }else if itemDetailedData.count == 1 {
                                        self.H_attechmntView.constant = 155
                                    }else if itemDetailedData.count == 2 {
                                        self.H_attechmntView.constant = 255
                                    }else if itemDetailedData.count == 3 {
                                        self.H_attechmntView.constant = 355
                                    }else if itemDetailedData.count == 4 {
                                        self.H_attechmntView.constant = 455
                                    }else if itemDetailedData.count == 5 {
                                        self.H_attechmntView.constant = 555
                                    }else if itemDetailedData.count == 6 {
                                        self.H_attechmntView.constant = 655
                                    }else if itemDetailedData.count == 7 {
                                        self.H_attechmntView.constant = 755
                                    }else if itemDetailedData.count == 8 {
                                        self.H_attechmntView.constant = 855
                                    }else if itemDetailedData.count == 9 {
                                        self.H_attechmntView.constant = 955
                                    }else if itemDetailedData.count == 10 {
                                        self.H_attechmntView.constant = 1055
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
            
        self.itemTableView.reloadData()
        }
    
    @objc func partBtnPressedPart(_ sender: UIButton) {
        
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        buttonIsSelected = !buttonIsSelected
        if buttonIsSelected {
            let indexPath = IndexPath(row: sender.tag, section: 0)
            if let cell = self.equipmntTableView.cellForRow(at: indexPath) as?  EquipmentCell {
                self.isDropDwon = false
                cell.partView_H.constant = 232
                equipmntTableView.reloadRows(at: [indexPath], with: .none)
            }
        }else{
            let indexPath = IndexPath(row: sender.tag, section: 0)
            if let cell = self.equipmntTableView.cellForRow(at: indexPath) as?  EquipmentCell {
                self.isDropDwon = false
                cell.partView_H.constant = 45
                equipmntTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
    }
    
    @IBAction func equipmentBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
        let eqpmentvc = storyboard.instantiateViewController(withIdentifier: "LinlEquipment") as! LinlEquipment
        eqpmentvc.objOfUserJobListInDetails = objOfUserJobListInDetail
        self.navigationController?.pushViewController(eqpmentvc, animated: true)
       
    }
    
    @IBAction func itemBtn(_ sender: Any) {
        let storyboard1 = UIStoryboard(name: "Invoice", bundle: nil)
        let invoiceCon = storyboard1.instantiateViewController(withIdentifier: "items") as! ItemsVC
        invoiceCon.objOfUserJobListInDetail = objOfUserJobListInDetail
        self.navigationController?.pushViewController(invoiceCon, animated: true)
    }
    
    
    
    //=====================================
    // MARK:-  getJobCardTemplates  Service
    //=====================================
    
     func getJobCardTemplates(){

         let param = Params()
        
         param.limit = "120"
         
         serverCommunicator(url: Service.getJobCardTemplates, param: param.toDictionary) { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(JobCardTemplatesRs.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            
                            self.JobCardTemplatArr = decodedData.data as! [JobCardTemplat]
                            DispatchQueue.main.async {
                                let arr = self.JobCardTemplatArr[0]
                              //  print( "\(String(describing: arr.tempJson1?.clientDetails![0].inputValue ?? ""))")
                                
                                self.templateVelue = "\(String(describing: arr.tempJson1?.clientDetails![0].inputValue ?? ""))"
                                self.selectTemplateTxtFld.text =  self.templateVelue
                              //  self.txtFldInvoiceTmplt.text = self.templateVelue
                                self.templateId = arr.jcTempId ?? ""
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
    
    
    
    //=====================================
    // MARK:-  addCompletionDetail  Service
    //=====================================
    
     func addCompletionDetail(){
         self.completionDetailArr.removeAll()
         var isLogType = ""
         
         let usrId = getUserDetails()?.usrId ?? ""//"923"//self.objOfUserJobListInDetail?.userId ?? ""
        
         
         if isactualAndTravel == true {
             let tlogStart = ""
             let tlogEnd = ""
             let schdlStart = actualStartDateTimeFor
             let schdlFinish = actualEndDateTimeFor
             let job_iscalculate = "1"
             let tra_iscalculate = "1"
             isLogType = "1"
             let location = LocationObject1(usrId: usrId, tlogStart: tlogStart, tlogEnd: tlogEnd, schdlStart : schdlStart, schdlFinish: schdlFinish, job_iscalculate: job_iscalculate, tra_iscalculate:tra_iscalculate)
             completionDetailArr.append(location)
         }else if isactualAndTravel == false {
             let schdlStart = ""
             let schdlFinish = ""
             let tlogStart = travelStartDateTimeFor
             let tlogEnd = travelEndDateTimeFor
             let job_iscalculate = "1"
             let tra_iscalculate = "1"
             isLogType = "2"
             let location = LocationObject1(usrId: usrId, tlogStart: tlogStart, tlogEnd: tlogEnd, schdlStart : schdlStart, schdlFinish: schdlFinish, job_iscalculate: job_iscalculate, tra_iscalculate:tra_iscalculate)
             completionDetailArr.append(location)
         }
        
        
         let param = Params()
        
         param.jobId = self.objOfUserJobListInDetail?.jobId
         param.usrFor = getUserDetails()?.usrId//"923"//self.objOfUserJobListInDetail?.jobId ?? ""
         param.logType = isLogType
         param.completionDetail = completionDetailArr
    
         serverCommunicator(url: Service.addCompletionDetail, param:param.toDictionary) { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    DispatchQueue.main.async { [self] in
                        self.getJobCompletionDetail()
                        //self.getJobListService()
                        //success API//
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
                }
            }
            
        }
    
    //========================================
    // MARK:-  getJobCompletionDetail  Service
    //========================================
    
    func getJobCompletionDetail(){
        
        let param = Params()
   
        param.jobId = self.objOfUserJobListInDetail?.jobId
        param.usrId = getUserDetails()?.usrId
        param.type = "1"
        
        serverCommunicator(url: Service.getJobCompletionDetail, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(getJobCompletionDetailRs.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        self.JobCompletionDetailArr = decodedData.data as! [getJobCompletionDetailData]
                        
                        DispatchQueue.main.async {
                            
                            if self.JobCompletionDetailArr.count > 0 {
                                if self.JobCompletionDetailArr[0].loginTime != "" {
                                   
                                    self.TravelVelidationEditTm = true
                                    
                                    if self.JobCompletionDetailArr[0].loginTime == "0" {
                                        self.actualstartDateTmLbl.text  = LanguageKey.actual_start_date_time
                                    }else{
                                        self.actualstartDateTmLbl.text = convertTimestampToDateForComplationDetail(timeInterval: ( self.JobCompletionDetailArr[0].loginTime ?? ""))
                                    }
                                   
                                }
                               
                                
                                if self.JobCompletionDetailArr[0].logoutTime != "" {
                                    
                                    if self.JobCompletionDetailArr[0].logoutTime == "0" {
                                        self.actualendDateTmLbl.text = LanguageKey.actual_end_date_time
                                    }else{
                                        self.actualendDateTmLbl.text = convertTimestampToDateForComplationDetail(timeInterval: ( self.JobCompletionDetailArr[0].logoutTime ?? ""))
                                    }
                                    
                                }
                              
                                if self.JobCompletionDetailArr[0].travel_loginTime != "" {
                                    
                                    if self.JobCompletionDetailArr[0].travel_loginTime == "0" {
                                        self.travelStartDateTmLbl.text = LanguageKey.travel_start_date_time
                                    }else{
                                        self.travelStartDateTmLbl.text = convertTimestampToDateForComplationDetail(timeInterval: ( self.JobCompletionDetailArr[0].travel_loginTime ?? ""))
                                    }
                                    
                                    
                                }
                            
                                if self.JobCompletionDetailArr[0].tarvel_logoutTime != "" {
                                    
                                    if self.JobCompletionDetailArr[0].tarvel_logoutTime == "0" {
                                        self.travelEndDateTmLbl.text = LanguageKey.travel_end_date_time
                                    }else{
                                        self.travelEndDateTmLbl.text = convertTimestampToDateForComplationDetail(timeInterval: ( self.JobCompletionDetailArr[0].tarvel_logoutTime ?? ""))
                                    }
                                    
                                }
                                
                                
                                // For Actual -
                                if (self.JobCompletionDetailArr[0].loginTime != "") && (self.JobCompletionDetailArr[0].logoutTime != "") {
                                    let time1 =  self.actualstartDateTmLbl.text
                                    let time2 = self.actualendDateTmLbl.text
                                    
                                    let dateAsString1 =  time1
                                    let dateAsString2 =  time2
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                    
                                    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
                                        if isAutoTimeZone == "0"{
                                            dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                            dateFormatter.locale = Locale(identifier: "en_US")
                                        }else{
                                            let loginUsrTz = getDefaultSettings()?.loginUsrTz
                                            dateFormatter.timeZone = TimeZone(identifier: loginUsrTz ?? "")
                                            
                                        }
                                    }
                            
                                    if (self.JobCompletionDetailArr[0].loginTime == "0") || (self.JobCompletionDetailArr[0].logoutTime == "0") {
                                        self.actualJobLbl.text = "\(LanguageKey.actual_job_time)"+" 00:00 Hours"
                                    }else{
                                        let date11 = dateFormatter.date(from: dateAsString1!)
                                        let date22 = dateFormatter.date(from: dateAsString2!)
                                        let elapsedTime = date22!.timeIntervalSince(date11!)
                                        
                                        // convert from seconds to hours, rounding down to the nearest hour
                                        let hours = floor(elapsedTime / (60 * 60))
                                        var secontAfterHr = elapsedTime - hours * 60 * 60
                                        let minutes = secontAfterHr / 60
                                        
                                        self.actualJobLbl.text = "\(LanguageKey.actual_job_time)"+" \(Int(hours)):\(Int(minutes)) Hours"
                                    }
                                   
                                    
                                }else{
                                    self.actualJobLbl.text = "\(LanguageKey.actual_job_time)"+" 00:00 Hours"
                                }
                                
                                
                                //FOR Travel
                                if (self.JobCompletionDetailArr[0].travel_loginTime != "") && (self.JobCompletionDetailArr[0].tarvel_logoutTime != "") {
                                    let timetravel1 =  self.travelStartDateTmLbl.text
                                    let timetravel2 = self.travelEndDateTmLbl.text
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
                                        if isAutoTimeZone == "0"{
                                            dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                            dateFormatter.locale = Locale(identifier: "en_US")
                                        }else{
                                            let loginUsrTz = getDefaultSettings()?.loginUsrTz
                                            dateFormatter.timeZone = TimeZone(identifier: loginUsrTz ?? "")
                                            
                                        }
                                    }
                                    if (self.JobCompletionDetailArr[0].travel_loginTime == "0") && (self.JobCompletionDetailArr[0].tarvel_logoutTime == "0") {
                                        self.travelJobLbl.text = "\(LanguageKey.travel_job_time)"+" 00:00 Hours"
                                    }else{
                                        let dateTravel1 = dateFormatter.date(from: timetravel1!)
                                        let dateTravel2 = dateFormatter.date(from: timetravel2!)
                                        let elapsedTime1 = dateTravel2!.timeIntervalSince(dateTravel1!)
                                        
                                        
                                        let hours1 = floor(elapsedTime1 / (60 * 60))
                                        var secontAfterHr1 = elapsedTime1 - hours1 * 60 * 60
                                        let minutes1 = secontAfterHr1 / 60
                                        
                                        self.travelJobLbl.text = "\(LanguageKey.travel_job_time)"+" \(Int(hours1)):\(Int(minutes1)) Hours"
                                    }
                                    
                                    
                                }else{
                                    self.travelJobLbl.text = "\(LanguageKey.travel_job_time)"+" 00:00 Hours"
                                }
                                
                            }
                            
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
    //==================================
    // MARK:- Equipement LIST Service methods
    //==================================
    func getEquipmentStatus(){
        
        if !isHaveNetowork() {
//            if self.refreshControl.isRefreshing {
//                self.refreshControl.endRefreshing()
//            }
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        
        let param = Params()
   
        param.limit = ""
        param.index = "0"
        param.isCondition = "1"
      
        
        serverCommunicator(url: Service.getEquipmentStatus, param: param.toDictionary) { (response, success) in
            

            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(getEquipmentStatusRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data!.count > 0 {
                            self.equipmentsStatus = decodedData.data!
                            DispatchQueue.main.async {
                            self.equipmntTableView.reloadData()
                            }
                           // print(self.equipmentsStatus)
                            killLoader()
                        }
                    }else{
                        killLoader()
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        
                        if cancel {
                            showLoader()
                            self.getEquipmentStatus()
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getEquipmentStatus()
                    }
                })
            }
        }
    }
    
    //==========================================
    // MARK:- Get getJobStatusList List Service
    //==========================================
    
     func getJobStatusList(){

            let param = Params()
            param.index = "0"
            param.search = ""
            param.limit = "120"
      
            serverCommunicator(url: Service.getJobStatusList, param: param.toDictionary) { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(JobStatusListRes.self, from: response as! Data) {

                        if decodedData.success == true{
                            
                            
                            self.jobStatusArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
                            
                            for job in self.jobStatusArr{
                                
                                if(job.id == "Reschedule") {
                                    
                                    DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                }
                            }
                            for job in self.jobStatusArr{
                                
                                if(job.id == "Revisit") {
                                    
                                    DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                }
                            }
                            
                            self.saveJobStatusList(data: decodedData.data! )
                            
                            self.jobStatusArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
                            
                            for job in self.jobStatusArr{
                                
                                if(job.id == "11") {
                                    
                                    DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                }
                            }
                            
                            for job in self.jobStatusArr{
                                
                                if(job.id == "13") {
                                    
                                    DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                }
                            }
                            
                            
                            let jostatus = DatabaseClass.shared.createEntity(entityName: "JobStatusList") as! JobStatusList
                            jostatus.id  = "Reschedule" //0
                            jostatus.text = self.Reschedule
                            self.jobStatusArr.append(jostatus)
                            
                            
                            let jostatus1 = DatabaseClass.shared.createEntity(entityName: "JobStatusList") as! JobStatusList
                            jostatus1.id  = "Revisit"//01
                            jostatus1.text = self.Revisit
                            self.jobStatusArr.append(jostatus1)
                            
                            self.jobStatusArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
                            
                        }else{
                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{

                        ShowError(message: AlertMessage.formatProblem, controller: windowController)
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
                }
            }
            
        }


//===================================================
// MARK:- Save getJobStatusList data in DataBase
//===================================================

func saveJobStatusList( data : [JobStatusListResData]) -> Void {
    for jobs in data{
     let query = "id = '\(String(describing: jobs.id ?? ""))'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: query) as! [JobStatusList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            existingJob.setValuesForKeys(jobs.toDictionary!)
           // DatabaseClass.shared.saveEntity()
        }else{
            let userJobs = DatabaseClass.shared.createEntity(entityName: "JobStatusList")
            userJobs?.setValuesForKeys(jobs.toDictionary!)
           // DatabaseClass.shared.saveEntity()
        }
    }
    
     DatabaseClass.shared.saveEntity(callback: { _ in })
    
}
 
    func calculateAmountForItemVc(quantity:Double, rate:Double, tax:Double, discount:Double) -> Double {

            var arr = Double()
        if let enableCustomForm = objOfUserJobListInDetail?.disCalculationType {
                if enableCustomForm == "0"{
                    let newRate = (rate - ((rate * discount) / 100));
                    arr =  quantity * ( newRate + ((newRate * tax) / 100));
                    return arr
                }else{
                    
                    let newRate = (rate);
                    arr = quantity * ( newRate + ((newRate * tax) / 100)) - discount;
                    return arr
                }
            }
            return arr
      
    }
    
}
 
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

extension DetailJobVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return   self.arrOfShowDataCom.count //+ 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CompletionNotesCell
        imgCount = self.arrOfShowDataCom.count
        
        if self.arrOfShowDataCom.count == indexPath.row {
            //   cell.imgView.image = #imageLiteral(resourceName: "push8@")
            //cell.imgView.image = UIImage(named: "Group 453")
            // cell.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
           // cell.imgLabel.text = ""
        }else {
            let docResDataDetailsObj = self.arrOfShowDataCom[indexPath.row]
            
            cell.imgLabel.text = docResDataDetailsObj.attachFileActualName
            imgName = cell.imgLabel.text ?? ""
            if let img = docResDataDetailsObj.attachThumnailFileName {
                
                let imageUrl = Service.BaseUrl + img
                cell.imgView.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: docResDataDetailsObj.image_name ?? "unknownDoc"))
                
            }else{
                cell.imgView.image = UIImage(named: "unknownDoc")
            }
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.arrOfShowDataCom.count == indexPath.row {
            // openGallery()
        }else {
            
            let DocResDataDetailsObj =  self.arrOfShowDataCom[indexPath.item]
            
            
            if DocResDataDetailsObj.type == "1" {
                DispatchQueue.main.async {
                    if let fileUrl = URL(string: (Service.BaseUrl + DocResDataDetailsObj.attachFileName!)) {
                        let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "docViewEdit") as! DocViewEditorVC
                        vc.name = trimString(string: DocResDataDetailsObj.attachFileActualName ?? "")
                        vc.docUrl = fileUrl
                        vc.OnlyForShowAllTxtView = true
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
    
    func amounc(qty:String?, rate:String?, discount:String?,arrTax:[texDic]? = nil) -> String{
        var tax : Double = 0.0
        if let itemTex = arrTax {
            for tx in itemTex {
                tax = tax + Double((tx.rate == "") ? roundOff(value:Double("0.00")!) : tx.rate ?? "0.0" )!
            }
        }
        
        
        let qty1 = (qty == "") ? "0" : qty!
        let rate1 = (rate == "") ? "0.0" : rate!
        let discount1 = (discount == "") ? "0.0" : discount!
        
        let totalAmount = calculateAmountForItemVc(quantity: Double(qty1)!, rate: Double(rate1)!, tax: tax, discount: Double(discount1)!)
        
       // let totalAmount = calculateAmount(quantity: Double(qty1)!, rate: Double(rate1)!, tax: tax, discount: Double(discount1)!)
        return roundOff(value: totalAmount)
    
    }
    
}

struct ImageModel1w {
    var img: UIImage?
   
}

extension DetailJobVC : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100

       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        if  tableView == itemTableView {
            return self.itemDetailedData.count
        }
        if tableView == equipmntTableView {
            return self.equipDataPartArr.count
        }

        return self.itemDetailedData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if tableView == itemTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! InvoiceCell
            let aar = self.itemDetailedData[indexPath.row]
            
            
            var myrate = aar.rate
            if (myrate?.count)! > 0 {
                myrate = roundOff(value: Double((myrate)!)!)
            }else{
                myrate = roundOff(value:Double("0.00")!)
            }
            
            if aar.isBillable == nil {
                cell.billingLbl.isHidden = true
                cell.billingView.isHidden = true
            }else{
                
                if aar.isBillable == "1"{
                    
                    cell.billingLbl.isHidden = true
                    cell.billingView.isHidden = true
                }else{
                    
                    cell.billingLbl.isHidden = false
                    cell.billingView.isHidden = false
                    cell.billingLbl.textColor = .white
                    cell.billingLbl.text = LanguageKey.non_billable
                    
                }
                
            }
            
            
            //   print(aar.isBillable)
            var mydiscount = aar.discount
            if (mydiscount?.count)! > 0 {
                mydiscount = roundOff(value: Double((mydiscount)!)!)
            }else{
                mydiscount = roundOff(value:Double("0.00")!)
            }
            let ladksj  = aar.ijmmId?.components(separatedBy: "-")
            if ladksj!.count > 0 {
                let tempId = ladksj?[0]
                if tempId == "Item" {
                    cell.lblName.text = aar.inm?.capitalized
                    cell.discountLbl.text =
                    "\(LanguageKey.item_not_sync) " // aar.inm?.capitalized ?? "" + "  Not Sync"
                    cell.desLbl.text = aar.des?.capitalized
                }else  {
                    cell.lblName.text = aar.inm?.capitalized
                    //cell.discountLbl.textColor = UIColor.gray
                    cell.discountLbl.text = ""//aar.des?.capitalized
                    cell.desLbl.text = aar.des?.capitalized
                }
            }
            
            
            if aar.unit != "" {
                let qtyText = aar.unit! //LanguageKey.unit
                cell.qtyLbl.text = "\(qtyText): " + aar.qty!
            }else{
                let qtyText = LanguageKey.qty
                cell.qtyLbl.text = "\(qtyText): " + aar.qty!
            }
            
            
            cell.amountLbl.text = aar.amount ?? "0.0"
            
            
            return cell
            
        }else if (equipmntTableView != nil) == true {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "quipmentCell",for: indexPath) as! EquipmentCell
            if isDropDwon == true{
                cell.partView_H.constant = 0
            }
            
            //  cell.delegate = self
            //  cell.partView_H.constant = 45
            cell.btnDefaults.setTitle("View Details", for: .normal)
            //  cell.btnRemark.setTitle("  \(LanguageKey.remark)" , for: .normal)
            let modl = LanguageKey.model_no
            let serl = LanguageKey.serial_no
            // let equipmentrty = equipments[indexPath.row]/////////////////chang
            let cond = LanguageKey.condition
            let remark = LanguageKey.remark
            
            
            if self.equipDataPartArr.count > 0 {
                      if let equipment = equipDataPartArr[indexPath.row].equeDic {
          //  let equipment = equipDataPartArr[indexPath.row].equeDic!
            //  cell.setPartData(equipArray: equipDataPartArr[indexPath.row].equePartArr ?? [])
            
            if  equipment.equStatus == "1" {
                
                cell.deployView.isHidden = true
                
            }else{
                if  equipment.equStatus != "" {
                    
                    for poIdnm in equipmentsStatus {
                        
                        if  poIdnm.esId == equipment.equStatus {
                            
                            self.poIdNam = poIdnm.statusText ?? ""
                            
                            cell.deployLbl.text = poIdNam
                            if poIdNam == "Deployed" {
                                cell.deployLbl.text = LanguageKey.deployed
                                // self.replacePart = true
                                cell.deployView.backgroundColor =  UIColor(red: 238/255.0, green: 174/255.0, blue: 91/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor = UIColor.white
                            }else if poIdNam == "Discarded" {
                                cell.deployLbl.text = "Discarded"
                                // self.replacePart = false
                                cell.deployView.backgroundColor =  UIColor(red: 249/255.0, green: 110/255.0, blue: 114/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor =   UIColor.white
                            }else if poIdNam == "Available" {
                                cell.deployLbl.text = "Available"
                                // self.replacePart = true
                                cell.deployView.backgroundColor =  UIColor(red: 238/255.0, green: 174/255.0, blue: 91/255.0, alpha: 1.0)
                                cell.deployLbl.textColor =  UIColor.white
                                cell.deployDateLbl.textColor = UIColor.white
                            }
                            
                        }
                    }
                    
                }
            }
            
            if equipment.statusUpdateDate != "" {
                if equipment.statusUpdateDate != nil{
                    cell.deployDateLbl.text = convertTimestampToDateForPayment(timeInterval: (equipment.statusUpdateDate ?? ""))
                }else{
                    cell.deployDateLbl.text = ""
                }
            }else{
                cell.deployDateLbl.text = ""
            }
            let aa = equipment.image
            
            if aa != nil {
                let ar = URL(string: Service.BaseUrl)?.absoluteString
                let ab = equipment.image
                //load(url:(URL(string: ar! + (ab.attachThumnailFileName!))!
                //load(url:URL(string: ar! + ab!)!)
                
                var ii:URL = URL(string: ar! + ab!)!
                
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: ii) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.equipmentImg.image = image
                            }
                        }
                    }
                }
                
            }
            self.equipIdName = equipment.equId!
            
            //  print("equipIdName ============== \(equipIdName)")
            // print("parentIdName ============== \(equipment.parentId)")
            //self.typeId = equipment.type ?? ""
            if equipment.isPart == "0"{
                
                
                
                
                if equipment.attachments?.count == 1 {
                    
                    cell.imgFirst.isHidden = false
                    cell.imgCount.isHidden = true
                    cell.imgView_H.constant = 0
                    cell.imgSecond.isHidden = true
                    cell.imgThird.isHidden = true
                    //   cell.attechRemrkBtn.isHidden = true//n
                    if let img = equipment.attachments?[0].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgFirst.image = UIImage(named: "unknownDoc")
                        
                    }
                } else if equipment.attachments?.count == 2 {
                    cell.imgView_H.constant = 0
                    cell.imgCount.isHidden = true
                    cell.imgThird.isHidden = true
                    cell.imgFirst.isHidden = false
                    cell.imgSecond.isHidden = false
                    //   cell.attechRemrkBtn.isHidden = true//n
                    if let img = equipment.attachments?[0].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgFirst.image = UIImage(named: "unknownDoc")
                        
                    }
                    
                    if let img = equipment.attachments?[1].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgSecond.image = UIImage(named: "unknownDoc")
                        
                    }
                } else if equipment.attachments?.count == 3 {
                    cell.imgThird.isHidden = false
                    cell.imgFirst.isHidden = false
                    cell.imgSecond.isHidden = false
                    cell.imgView_H.constant = 0
                    cell.imgCount.isHidden = true
                    // cell.imgCount.text = "+\(equipment.attachments!.count)"
                    if let img = equipment.attachments?[0].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgFirst.image = UIImage(named: "unknownDoc")
                        
                    }
                    
                    if let img = equipment.attachments?[1].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgSecond.image = UIImage(named: "unknownDoc")
                        
                    }
                    if let img = equipment.attachments?[2].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgThird.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[2].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgThird.image = UIImage(named: "unknownDoc")
                        
                    }
                }else if equipment.attachments?.count == 0 {
                    
                    cell.imgCount.isHidden = true
                    cell.imgView_H.constant = 0
                    cell.imgSecond.isHidden = true
                    cell.imgFirst.isHidden = true
                    cell.imgThird.isHidden = true
                    //  cell.attechRemrkBtn.isHidden = true////n
                }else {
                    cell.imgCount.isHidden = false
                    cell.imgView_H.constant = 0
                    cell.imgCount.text = "+\(equipment.attachments!.count - 3)"
                    cell.imgSecond.isHidden = false
                    cell.imgFirst.isHidden = false
                    cell.imgThird.isHidden = false
                    
                    if let img = equipment.attachments?[0].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgFirst.image = UIImage(named: "unknownDoc")
                        
                    }
                    
                    if let img = equipment.attachments?[1].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgSecond.image = UIImage(named: "unknownDoc")
                        
                    }
                    if let img = equipment.attachments?[2].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgThird.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[2].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgThird.image = UIImage(named: "unknownDoc")
                        
                    }
                    
                }
                
                
                cell.remarkDisc.text = equipment.remark
                cell.lblName.text = equipment.equnm
                cell.partLbl.isHidden = true
                cell.partLbl.text = LanguageKey.parts
                cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
            }
            else{
                
                if equipment.attachments?.count == 1 {
                    
                    
                    cell.imgFirst.isHidden = false
                    cell.imgCount.isHidden = true
                    cell.imgView_H.constant = 0
                    cell.imgSecond.isHidden = true
                    cell.imgThird.isHidden = true
                    //  cell.attechRemrkBtn.isHidden = true///n
                    if let img = equipment.attachments?[0].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgFirst.image = UIImage(named: "unknownDoc")
                        
                    }
                } else if equipment.attachments?.count == 2 {
                    cell.imgView_H.constant = 0
                    cell.imgCount.isHidden = true
                    cell.imgThird.isHidden = true
                    //   cell.attechRemrkBtn.isHidden = true//n
                    cell.imgFirst.isHidden = false
                    cell.imgSecond.isHidden = false
                    if let img = equipment.attachments?[0].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgFirst.image = UIImage(named: "unknownDoc")
                        
                    }
                    
                    if let img = equipment.attachments?[1].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgSecond.image = UIImage(named: "unknownDoc")
                        
                    }
                } else if equipment.attachments?.count == 3 {
                    cell.imgThird.isHidden = false
                    cell.imgFirst.isHidden = false
                    cell.imgSecond.isHidden = false
                    cell.imgView_H.constant = 0
                    cell.imgCount.isHidden = true
                    // cell.imgCount.text = "+\(equipment.attachments!.count)"
                    if let img = equipment.attachments?[0].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgFirst.image = UIImage(named: "unknownDoc")
                        
                    }
                    
                    if let img = equipment.attachments?[1].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgSecond.image = UIImage(named: "unknownDoc")
                        
                    }
                    if let img = equipment.attachments?[2].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgThird.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[2].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgThird.image = UIImage(named: "unknownDoc")
                        
                    }
                }else if equipment.attachments?.count == 0 {
                    
                    cell.imgCount.isHidden = true
                    cell.imgView_H.constant = 0
                    cell.imgSecond.isHidden = true
                    cell.imgFirst.isHidden = true
                    cell.imgThird.isHidden = true
                    //   cell.attechRemrkBtn.isHidden = true///n
                    
                }else {
                    cell.imgCount.isHidden = false
                    cell.imgView_H.constant = 0
                    cell.imgCount.text = "+\(equipment.attachments!.count - 3)"
                    cell.imgSecond.isHidden = false
                    cell.imgFirst.isHidden = false
                    cell.imgThird.isHidden = false
                    
                    if let img = equipment.attachments?[0].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgFirst.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[0].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgFirst.image = UIImage(named: "unknownDoc")
                        
                    }
                    
                    if let img = equipment.attachments?[1].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgSecond.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[1].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgSecond.image = UIImage(named: "unknownDoc")
                        
                    }
                    if let img = equipment.attachments?[2].attachThumnailFileName {
                        let imageUrl = Service.BaseUrl + img
                        cell.imgThird.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: equipment.attachments?[2].image_name ?? "unknownDoc"))
                    }else{
                        cell.imgThird.image = UIImage(named: "unknownDoc")
                        
                    }
                    
                }
                
                cell.partLbl.isHidden = false
                cell.partLbl.text = LanguageKey.parts
                
                
                cell.remarkDisc.text = equipment.remark
                cell.lblName.text = equipment.equnm
                cell.lblName.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
                //cell.lblName.textColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
            }
            
            if equipment.status == "" &&  equipment.remark == ""{
                cell.remarkView_H.constant = 0
            }else{
                cell.remarkView_H.constant = 0
            }
            
            // cell.lblName.text = equipment.equnm
            cell.lblModelNo.text = "\(modl) : \(equipment.mno!)"
            cell.lblSerialNo.text = "\(serl) : \(equipment.sno!)"
            cell.lblAddress.text = equipment.location
            
            
            let status = Int(equipment.status!)
            
            
            //                if  equipment.status != "" {
            //
            //                    for poIdnm in equipmentsStatus {
            //
            //                        if  poIdnm.esId == equipment.status {
            //
            //                            self.poIdNam = poIdnm.statusText ?? ""
            //
            //                        }
            //
            //
            //                    }
            //
            //                    cell.conditationLbl.text = poIdNam
            //        //self.poNumbetLbl.isHidden = false
            //                }else{
            //
            //                   // self.poNumbetLbl.isHidden = true
            //                   // self.poNumber.text = ""
            //                }
            //
            //        for statusList in equipmentsStatus {
            //
            //            var statusVelue = statusList.esId
            //            if statusVelue == status {
            //                cell.conditationLbl.text = "Condition :" + " \(statusVelue)"
            //            }
            //
            //        }
            
            //        if status == 5663 {
            //
            //            cell.conditationLbl.text = "\(cond) : Good"
            //        } else if status == 5665 {
            //
            //            cell.conditationLbl.text = "\(cond) : Need to be Repaired"
            //        }else if status == 5666 {
            //
            //            cell.conditationLbl.text = "\(cond) : Not Working"
            //        }else if status == 5664 {
            //
            //            cell.conditationLbl.text = "\(cond) : Poor"
            //        }else{
            //            cell.conditationLbl.text = "\(LanguageKey.condition):"
            //        }
            //
            
            // cell.remarkLbl.text = "\(remark) : \(equipment.remark ?? "")"
            
            
            //
            if equipment.remark == ""  {
                //   cell.remarkEditBt.isHidden = true////////////////chang
                //   cell.btnRemark.isHidden = false////////////////chang
                //  cell.btnRemark.setTitle("\(LanguageKey.remark)", for: .normal)/////////////////chang
                // cell.btnRemark.setTitle("Add Remark", for: .normal)/////////////////chang
                
                
            }else{
                //   cell.remarkEditBt.isHidden = false////////////////chang
                //  cell.btnRemark.isHidden = true////////////////chang
                
                //   cell.btnRemark.setTitle("\(LanguageKey.remark_added)", for: .normal)/////////////////chang
                //  cell.btnRemark.setTitle("View Details", for: .normal)/////////////////chang
                // cell.imageEquip.image = UIImage(named: "Remak-added")
                
                //  cell.btnRemark.setTitleColor(UIColor.themeMoreButtonLink, for: .normal)/////////////////chang
                
            }
            cell.dropDownPartBtn.addTarget(self, action: #selector(partBtnPressedPart), for: .touchUpInside)
            cell.dropDownPartBtn.tag = indexPath.row
            
            cell.sizeToFit()
        }
    }
            
//               default:
//                   print("Some things Wrong!!")
//               }
        return cell
               }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  tableView == itemTableView {
            let storyboard1 = UIStoryboard(name: "Invoice", bundle: nil)
            let invoiceCon = storyboard1.instantiateViewController(withIdentifier: "items") as! ItemsVC
            invoiceCon.objOfUserJobListInDetail = objOfUserJobListInDetail
            self.navigationController?.pushViewController(invoiceCon, animated: true)
        }else if  tableView == equipmntTableView {
            
            let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
            let eqpmentvc = storyboard.instantiateViewController(withIdentifier: "LinlEquipment") as! LinlEquipment
            eqpmentvc.objOfUserJobListInDetails = objOfUserJobListInDetail
            self.navigationController?.pushViewController(eqpmentvc, animated: true)
        }
        
        
    }
    
}



extension UIImage {
    func resizeImage1w(targetSize: CGSize) -> UIImage {
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
class completionDetail: NSObject {
    
    var usrId : String!
    var tlogStart : String!
    var tlogEnd : String!
    var schdlStart : String!
    var schdlFinish : String!
    var job_iscalculate : String!
    var tra_iscalculate : String!
   
}

class LocationObject1 : Codable {
    //{"btryStatus":"44","datetime":"1577466240","lat":"22.68455932000001","lng":"75.82566356000518"}tlogStart
    var usrId : String?
    var tlogStart : String?
    var tlogEnd : String?
    var schdlStart : String?
    var schdlFinish : String?
    var job_iscalculate : String?
    var tra_iscalculate : String?
    
    
    init(usrId:String,tlogStart : String, tlogEnd : String, schdlStart : String,schdlFinish : String, job_iscalculate : String, tra_iscalculate : String ) {
        self.usrId = usrId
        self.tlogStart = tlogStart
        self.tlogEnd = tlogEnd
        self.schdlStart = schdlStart
        self.schdlFinish = schdlFinish
        self.job_iscalculate = job_iscalculate
        self.tra_iscalculate = tra_iscalculate
    }
}

