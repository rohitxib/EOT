//
import UIKit
import CoreData
import JJFloatingActionButton

class CalenderVC: UIViewController,SWRevealViewControllerDelegate,CVCalendarMenuViewDelegate,CVCalendarViewDelegate,CVCalendarViewAppearanceDelegate {
    
    @IBOutlet weak var noAppoimentFound: UILabel!
    @IBOutlet weak var calenderVw_Hieght: NSLayoutConstraint!
    @IBOutlet weak var tableView_job: UITableView!
    @IBOutlet weak var extrabtn: UIBarButtonItem!
    @IBOutlet weak var view_empty: UIView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var heightConst_calenderView: NSLayoutConstraint!
    private var currentCalendar: Calendar?
    @IBOutlet weak var monthButton: UIButton!
    
    var isSortList = false
    var refresher: UIRefreshControl!
    private var animationFinished = true
    var notiArr =  [String]()
    var arrDate = [String]()
    var statDate : String?
    var endDate : String?
    var isWeekCalender : Bool = true
    var isNotificationClick = false
    var refreshControl = UIRefreshControl()
    var arrOfFilterDict  = [[String : [UserJobList]]]()
    var arrOFUserData = [UserJobList]()
    var arrOFAppointmentData = [AppointmentList]()
    var isAdded = Bool()
    var jobTabVC : JobTabController?
    var merageArray = [Any]()
    var isDisable = true
    var arrFilterData = [CommanListDataModel]()
    var arrFilterDataNotyData = [CommanListDataModel]()
    var count : Int = 0
    var isUserfirstLogin = Bool()
    var currentDate = Date()
    var appointmentDetainVC : DetailAppointmentVC?
    var auditDetalVc:AuditTabController?
    var arrOfUserAudit = [AuditOfflineList]()
    var selectedStatus : [String] = []
    var searchTxt = ""
     //var refreshControl = UIRefreshControl()
    var arrOFUserDataQuot = [QuotationData]()
    var arrOFData = [QuotationData]()
    var quotation : QuotationData!
    var timer:Timer?
    var notificationData = false
    var appCommanId = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //  killLoader() Shorting icon 4
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "Shorting-24"), style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = leftButton
        let persimissionOn = "Off"
        UserDefaults.standard.set(persimissionOn, forKey: "persimissionOn")
        //   getAuditListService()
        hideloader()
        UserDefaults.standard.set("0", forKey: "myFirstLoging")
        //  groupUserListForChat()
        
        // getAllCompanySettings()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        NotiyCenterClass.fireRefreshJobListNotifier(vc: self, selector: #selector(self.joblistRefreshWhenAdd(_:)))
        NotiyCenterClass.AppointmentregisterRefreshAuditListNotifier(vc: self, selector: #selector(self.joblistRefresh(_:)))
        floatinActionButton()
        //self.navigationController?.title = "Calender"
        setLocalization()
        if let revealController = self.revealViewController(){
            revealViewController().delegate = self
            extrabtn.target = revealViewController()
            extrabtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealController.tapGestureRecognizer()
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableView_job.addSubview(refreshControl) // not required when using UITableViewController
        
        getAppoinmentListService()
        
        
        //  getQuoteListService()
        // Calender
        killLoader()
        self.calendarView.calendarAppearanceDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
        isUserfirstLogin =  (UserDefaults.standard.value(forKey: "ShowProgressBarOnce") as? Bool) ?? false
        
        setUpMethod()
        
        
        if(isNotificationClick){
            self.extrabtn.isEnabled = false
            SetBackBarButtonCustom()
        }else{
            // getAuditListService()
        }
        
    }
    
    @objc func addTapped(){
        
        if self.arrFilterData.count != 0 {
            if self.isSortList == true {
                self.arrFilterData = self.arrFilterData.sorted { $0.schdlStart?.localizedCaseInsensitiveCompare($1.schdlStart!) == ComparisonResult.orderedDescending }
                self.isSortList = false
            } else {
                self.arrFilterData = self.arrFilterData.sorted { $0.schdlStart?.localizedCaseInsensitiveCompare($1.schdlStart!) == ComparisonResult.orderedAscending }
                self.isSortList = true
            }
        } 
        DispatchQueue.main.async {
            self.tableView_job.reloadData()
        }
        
    }
    
      @objc func popToAuditVC(_ notification: NSNotification){
              let vc =  UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC;
              let navCon = NavClientController(rootViewController: vc)
              navCon.modalPresentationStyle = .fullScreen
              self.present(navCon, animated: true, completion: nil)
          }
       
    @objc func joblistRefresh(_ notification: NSNotification){
        if let controllers = self.navigationController?.viewControllers{
            for view in controllers{
                if (view .isKind(of: CalenderVC.self)){
                    self.navigationController?.popToViewController(view, animated: true)
                }
            }
        }
    }
      
    @objc func joblistRefreshWhenAdd(_ notification: NSNotification){
          self.getAuditListService()
          self.getJobListService()
          self.getAppoinmentListService()
          self.tableView_job.reloadData()
      }
      
      func SetBackBarButtonCustom()
    {
        
        let button = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(CalenderVC.onClcikBack))
        
        self.navigationItem.leftBarButtonItem  = button
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(redirect), userInfo: nil, repeats: true)
        
    }

    @objc  func redirect(){
        
        notificationData = true
        if arrFilterDataNotyData.count > 0 {
            performSegue(withIdentifier: "Details", sender: self)
        }
      
      timer?.invalidate()
      timer = nil
      
      }
    
          @objc func onClcikBack(){
               if isNotificationClick {
          
                   self.dismiss(animated: true, completion: nil)
               }else{
                    self.navigationController?.popViewController(animated: true)
               }
          }
    
      func setLocalization() -> Void {
        
          DispatchQueue.main.async {
            self.noAppoimentFound.text = "\(LanguageKey.appointment_not_found) "
        }
       
      }
    func floatinActionButton() {
        let actionButton = JJFloatingActionButton()
        actionButton.buttonAnimationConfiguration = .rotation(toAngle: 0.0)
        actionButton.buttonImage = UIImage(named: "add")
        actionButton.itemAnimationConfiguration = .slideIn(withInterItemSpacing: 20)
        actionButton.buttonColor  = UIColor(red: 55.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1.0)
        
        isDisable = compPermissionVisible(permission: compPermission.isItemEnable)
        
        actionButton.addItem(title: LanguageKey.add_appointment , image: UIImage(named: "Layer 14-1")?.withRenderingMode(.alwaysOriginal)) { item in
            // do somethin5
            
            ActivityLog(module:Modules.invoice.rawValue , message:"Add Appointment")
            let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddAppointmentVC") as! AddAppointmentVC
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
        actionButton.addItem(title:LanguageKey.title_add_job, image: UIImage(named: "Layer 15-1")) { item in
            // do something
            ActivityLog(module:Modules.invoice.rawValue , message:"Edit Appointment")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddJobVC") as! AddJobVC
            vc.appoinmentDate = true
            
            vc.callbackForJobVC = {(isBack : Bool) -> Void in
                self.isAdded = true
                self.filterArrToDate(date: self.currentDate)
                
            }
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
        if isPermitForShow(permission: permissions.isAuditVisible) == true{ //  show and hide permission of Audit
            actionButton.addItem(title:LanguageKey.title_add_audit, image: UIImage(named: "Artboard")) { item in
                // do something
                
                let storyboard = UIStoryboard(name: "MainAudit", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddAudit") as! AddAudit
                
                vc.appoinmentDateAudit = true
                vc.callbackForJobVC = {(isBack : Bool) -> Void in
                    self.isAdded = true
                    self.filterArrToDate(date: self.currentDate)
                    
                }
                
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
        for button in actionButton.items { // change button color of items
            button.buttonColor = UIColor(red: 55.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1.0)
        }
        
        view.addSubview(actionButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        } else {
            // Fallback on earlier versions
        }
    }
      

          
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
             
       
          getJobListService()
          self.getAppoinmentListService()
          getAuditListService()
          
        notificationData = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
             isAdded = true
          
          // self.getClientListFromDBjob()
          filterArrToDate(date: currentDate)
        
        calendarView.contentController.refreshPresentedMonth()
        
      }
      

      @objc func refreshControllerMethod() {
          getAuditListService()
          getJobListService()
          self.getAppoinmentListService()
          tableView_job.reloadData()
          
      }
    
      func setUpMethod(){
          
          calendarView.commitCalendarViewUpdate()
          calendarView.layoutIfNeeded()
          calendarView.layoutSubviews()
          menuView.commitMenuViewUpdate()
          
          
          monthButton.setTitle(calendarView.presentedDate.globalDescription, for: .normal)
          
          self.calendarView.changeMode(.weekView)
          
      }
      
      //==================================================================
      // MARK:-CVCalendarMenuViewDelegate & CVCalendarViewDelegate,
      //==================================================================
      func presentationMode() -> CalendarMode{
          return .monthView
      }
      func firstWeekday() -> Weekday{
          return .monday
      }
      
      func dayOfWeekTextColor() -> UIColor { return .white }
      
      func dayOfWeekBackGroundColor() -> UIColor { return .clear } //Bg Color of menu view
      
      //func disableScrollingBeforeDate() -> Date { return Date() }
      
      func maxSelectableRange() -> Int { return 60 }
      
      func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
          
          print("didSelectDayView",dayView.date as Any)
          
          // self.arrOFUserData = self.arrOFUserData.sorted(by: { $0.schdlStart! > $1.schdlStart! })
          currentDate = dayView.date.convertedDate()!
          filterArrToDate(date: dayView.date.convertedDate()!)
          
          let yr = dayView.date.year
          let date = dayView.date.day
          let mnth = dayView.date.month
          
          
          var dateFormt = "\(date)-"+"\(mnth)"+"-\(yr)"
          var clickDate = dateFormt
          UserDefaults.standard.set(clickDate, forKey: "clickDate")
          print(dateFormt)
          
          dayView.date
      }
    
      func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {

             let selectDate = currentDateToStringDate(date:dayView.date.convertedDate()!)
            
            if arrDate.contains(selectDate){
                return true
            }
            
            return false
        }
     
        func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
            return [UIColor.init(red: 49/255.0, green: 182/255.0, blue: 84/255.0, alpha: 1.0)]
        }
        func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
            return 16
        }

      
      //MARK:- Array filter data according to date
    func filterArrToDateNoti(date : Date ){
        let selectDate = currentDateToStringDate(date:date)
        
        self.getClientListFromDBjob()
       
        var ApmtArr = APP_Delegate.appoinmentRes
        
        for arrAp in self.arrOFAppointmentData {
            arrAp.label == ApmtArr
        }
        let quote = self.arrOFAppointmentData.filter({$0.label == ApmtArr})
        print("contect - - \(quote)")
        //if quote != [] {
            
            let dta = quote[0]
            
            let date = convertTimestampToDateFormate(timeInterval: dta.schdlStart!)
            arrDate.append(date)
            
            let dic = CommanListDataModel(adr: dta.adr, athr: dta.athr, city: dta.city, cltId: dta.cltId, cnm: dta.cnm, conId: dta.conId, createDate: dta.createDate, ctry: dta.ctry, des: dta.des, email: dta.email, kpr: [], label: dta.label, lat: dta.lat, lng: dta.lng, mob1: dta.mob1, mob2: dta.mob2, nm: dta.nm, parentId: "", prty: "", quotId: "", schdlFinish: dta.schdlFinish, schdlStart: dta.schdlStart, siteId: dta.siteId, skype: "", snm: "", state: dta.state, status: dta.status, twitter: "", type: dta.type, updateDate: "", zip: dta.zip, isdelete: "dta.isdelete", tempId: "dta.tempId", landmark: dta.landmark, complNote: "", compid: "", JobType: "2")
            
            arrFilterDataNotyData.append(dic)
       // }
        
    }
    
    
    func filterArrToDate(date : Date ){
        let selectDate = currentDateToStringDate(date:date)
        
        self.getClientListFromDBjob()
        
        arrFilterData.removeAll()
        arrDate.removeAll()
        
        if merageArray.count>0 {
            
            for job in merageArray {
                //  print(merageArray)
                
                if let dta = job as? AuditOfflineList {
            
                    let date = convertTimestampToDateFormate(timeInterval: dta.schdlStart!)
                    arrDate.append(date)
                    
                    if selectDate == date {
                        
                        
                        let dic = CommanListDataModel(adr: dta.adr, athr: dta.athr, city: dta.city, cltId: dta.cltId, cnm: dta.cnm, conId: dta.conId, createDate: dta.createDate, ctry: dta.ctry, des: dta.des, email: dta.email, inst: dta.inst, commonId: dta.audId, kpr: [], label: dta.label, lat: dta.lat, lng: dta.lng, mob1: dta.mob1, mob2: dta.mob2, nm: dta.nm, parentId: "", prty: "", quotId: "", schdlFinish: dta.schdlFinish, schdlStart: dta.schdlStart, siteId: dta.siteId, skype: "", snm: "", state: dta.state, status: dta.status, twitter: "", type: dta.type, updateDate: "", zip: dta.zip, isdelete: "dta.isdelete", tempId: "dta.tempId", landmark: dta.landmark, complNote: "", compid: "", JobType: "3")
                        
                        arrFilterData.append(dic)
                        
                        
                    }
               
                }
                
                
                if let dta = job as? UserJobList {
              
                  
                    let date = convertTimestampToDateFormate(timeInterval: dta.schdlStart!)
                    arrDate.append(date)
                    
                    if selectDate == date {
                         // let itemDetails = dta.itemData as? NSArray
                        var itemCount = ""
                        if let itemDetails = dta.itemData as? NSArray, itemDetails != nil, itemDetails.count > 0 {
                            itemCount = "\(itemDetails.count)"
                        }
                        
                      
                      var equipmentCount = ""
                      if let equipmntDetails = dta.equArray as? NSArray, equipmntDetails != nil, equipmntDetails.count > 0 {
                          equipmentCount = "\(equipmntDetails.count)"
                      }
                        
                        
                        let dic = CommanListDataModel(adr: dta.adr, athr: dta.athr, city: dta.city, cltId: dta.cltId, cnm: dta.cnm, conId: dta.conId, createDate: dta.createDate, ctry: dta.ctry, des: dta.des, email: dta.email, inst: dta.inst, commonId: dta.jobId, kpr: [], label: dta.label, lat: dta.lat, lng: dta.lng, mob1: dta.mob1, mob2: dta.mob2, nm: dta.nm, parentId: "", prty: "", quotId: "", schdlFinish: dta.schdlFinish, schdlStart: dta.schdlStart, siteId: dta.siteId, skype: "", snm: "", state: dta.state, status: dta.status, twitter: "", type: dta.type, updateDate: "", zip: dta.zip, isdelete: dta.isdelete, tempId: dta.tempId, landmark: dta.landmark, complNote: "", compid: "", JobType: "1",attachments:dta.attachCount,itemData: itemCount,equArray: equipmentCount)
                        
                        arrFilterData.append(dic)
                      //  print("dic -- \(dic)")
                      //  print("arrFilterData -- \(arrFilterData)")
                        
                    }
                   
                } else {
                    if let dta = job as? AppointmentList {
                        
                        let ladksj = dta.appId!.components(separatedBy: "-")
                        if ladksj.count > 0 {
                            let tempId = ladksj[0]
                            if tempId == "Appointment" {
                                
                                let date = convertTimestampToDateFormate(timeInterval: dta.schdlStart!)
                                arrDate.append(date)
                                if selectDate == date {
                                    
                                    self.dataApendArray(dta:dta)
                                    
                                    
                                }
                            } else {
                                if dta.kpr != nil {
                                    for kprData in (dta.kpr as! [AnyObject]) {
                                        if kprData is String {
                                            
                                            if (kprData as! String) == getUserDetails()?.usrId {
                                                let date = convertTimestampToDateFormate(timeInterval: dta.schdlStart!)
                                                arrDate.append(date)
                                                if selectDate == date {
                                                    self.dataApendArray(dta:dta)
                                                    
                                                }
                                            }
                                            
                                        } else if (kprData as! [String:String])["usrId"] == getUserDetails()?.usrId {
                                            
                                            let date = convertTimestampToDateFormate(timeInterval: dta.schdlStart!)
                                            arrDate.append(date)
                                            if selectDate == date {
                                                
                                                self.dataApendArray(dta:dta)
                                                
                                            }
                                        } else {
                                            // print("Not for you")
                                        }
                                    }
                                    
                                } else {
                                    // print("Not for you null")
                                }
                            }
                        }
                        
                    }
                }
                
            }
            
            self.arrFilterData = self.arrFilterData.sorted(by: { $0.schdlStart! > $1.schdlStart! })
            
            
        }
        
        
        DispatchQueue.main.async {
            self.tableView_job.reloadData()
            if self.arrFilterData.count>0 {
                self.view_empty.isHidden = true
            } else {
                self.view_empty.isHidden = false
            }
        }
      
    }
      

      func dataApendArray(dta:AppointmentList) {
        let dic = CommanListDataModel(adr: dta.adr, athr: dta.athr, city: dta.city, cltId: dta.cltId, cnm: dta.cnm, conId: dta.conId, createDate: dta.createDate, ctry: dta.ctry, des: dta.des, email: dta.email, inst: "", commonId: dta.appId, kpr: [], label: dta.label, lat: dta.lat, lng: dta.lng, mob1: dta.mob1, mob2: dta.mob2, nm: dta.nm, parentId: "", prty: "", quotId: dta.quotId, schdlFinish: dta.schdlFinish, schdlStart: dta.schdlStart, siteId: dta.siteId, skype: "", snm: "", state: dta.state, status: dta.status, twitter: "", type: dta.type, updateDate: "", zip: dta.zip, isdelete: dta.isdelete, tempId: dta.tempId, landmark: dta.landmark, complNote: "", compid: "", JobType: "2",quotLabel:dta.quotLabel,attachments:dta.attachments as? String)
                                                         
      arrFilterData.append(dic)
          
      }
      
      //=====================Range=================================
      
      
      func earliestSelectableDate() -> Date { return Date() }
      
      
      func presentedDateUpdated(_ date: CVDate) {
          
          monthButton.setTitle(date.globalDescription, for: .normal)
          var persimissionOn = "On"
          UserDefaults.standard.set(persimissionOn, forKey: "persimissionOn")
      }
      
      
      //=====================================================
      // MARK:- CVCalendarViewAppearance Delegate Methods
      //=====================================================
      func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
          switch (weekDay, status, present) {
          case (_, .selected, _), (_, .highlighted, _): return headerGreenColor()
          case (.sunday, .in, _): return UIColor.white
          case (.sunday, _, _): return UIColor.white
          case (_, .in, _): return UIColor.white
          default: return UIColor.white
          }
      }
      
      func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? { // Dot color
          return   UIColor.white
      }
      
      
      
      
      func hideloader() -> Void {
          DispatchQueue.main.async {
              if self.refreshControl.isRefreshing {
                  self.refreshControl.endRefreshing()
              }
          }
          
          killLoader()
      }
      
      //MARK:- IBAction Button
      
      @IBAction func btnMonthTogle_Action(_ sender: Any) {
          
          if isWeekCalender == true{
              isWeekCalender = false
              // heightConst_calenderView.constant = 250
              calendarView.changeMode(.monthView)
              monthButton.setImage(UIImage.init(named: "sort-up"), for: .normal)
          } else {
              
              isWeekCalender = true
              // heightConst_calenderView.constant = 100
              
              self.calendarView.changeMode(.weekView)
              monthButton.setImage(UIImage.init(named: "sort-down"), for: .normal)
          }
          
      }
      
      
      // MARK:- JobId methods
      //=======================
      
      func showDataOnTableViewJob(query : String?) -> Void {
        merageArray.removeAll()

        arrOFUserData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]

        self.arrOFUserData = self.arrOFUserData.sorted(by: { $0.schdlStart! > $1.schdlStart! })

        merageArray.append(contentsOf: self.arrOFUserData)

        self.arrOFAppointmentData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: nil) as! [AppointmentList]
        self.arrOFAppointmentData = self.arrOFAppointmentData.sorted(by: { $0.schdlStart! > $1.schdlStart! })

        merageArray.append(contentsOf: self.arrOFAppointmentData)

         if isPermitForShow(permission: permissions.isAuditVisible) == true{
        arrOfUserAudit = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: query) as! [AuditOfflineList]

        self.arrOfUserAudit = self.arrOfUserAudit.sorted(by: { $0.schdlStart! > $1.schdlStart! })

        merageArray.append(contentsOf: self.arrOfUserAudit)
        }
  
      }
      
      func getClientListFromDBjob() -> Void {
          
          
          showDataOnTableViewJob(query: nil)
          
      }
      
      
      //=======================================
      // MARK:- Appoinment LIST Service methods
      //=======================================
    func getAppoinmentListService(){
        
        if !isHaveNetowork() {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            return
        }
        killLoader()
        hideloader()
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getAppoinmentList) as? String
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.limit = "120"
        param.index = "\(count)"
        param.search = ""
        param.dateTime = lastRequestTime ?? ""
        
        let dict = param.toDictionary
        
        serverCommunicator(url: Service.getAppoinmentList, param: dict) { [self] (response, success) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(AppointmentListRes.self, from: response as! Data) {
                    
                    
                    if decodedData.success == true{
                        if self.isNotificationClick == true {
                            if decodedData.count ?? "" > "0" {
                                if let arrayData = decodedData.data, arrayData.count != 0 {
                                    self.appCommanId = arrayData[0].appId ?? ""
                                  
                                }
                            }
                        }
                        
                        if let arryCount = decodedData.data{
                            if arryCount.count > 0 {
                                
                                self.count += (decodedData.data?.count)!
                                
                                if !self.isUserfirstLogin {
                                    
                                    self.saveUserJobsInDataBase(data: decodedData.data!)
                                    
                                    //Request time will be update when data comes otherwise time won't be update
                                    UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getAppoinmentList)
                                    
                                    
                                    self.showDataOnTableView(query: nil) //Show joblist on tableview
                                    
                                }else{
                                    self.saveAllUserJobsInDataBase(data: decodedData.data!)
                                }
                            }else{
                                if self.arrOFUserData.count == 0{
                                    DispatchQueue.main.async {
                                        self.tableView_job.reloadData()
                                        self.view_empty.isHidden = self.arrOFUserData.count > 0 ? true : false
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                
                                self.filterArrToDate(date: self.currentDate)
                            }
                            
                        }
                        
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                            self.getAppoinmentListService()
                        }else{
                            
                            
                            if self.isUserfirstLogin {
                                
                                //Request time will be update when data comes otherwise time won't be update
                                UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getAppoinmentList)
                                
                            }
                            
                            
                            self.saveAllGetDataInDatabase(callback: { isSuccess in
                                if APP_Delegate.apiCallFirstTime {
                                    APP_Delegate.apiCallFirstTime = false
                                    self.groupUserListForChat()
                                    
                                }else{
                                    killLoader()
                                }
                            })
                        }
                    }else{
                        
                        self.hideloader()
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
                    self.hideloader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        
                        if cancel {
                            showLoader()
                            self.getAppoinmentListService()
                        }
                    })
                }
            }else{
                self.hideloader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getAppoinmentListService()
                    }
                })
            }
        }
    }
      
      func showDataOnTableView(query : String?) -> Void {
          
          filterArrToDate(date: currentDate)
          hideloader()
        
      }
      
      func saveAllUserJobsInDataBase( data : [AppointmentListData]) -> Void {
          for job in data{
              if(job.isdelete != "0"){
                  if (Int(job.status!) != taskStatusType.Cancel.rawValue) &&
                      (Int(job.status!) != taskStatusType.Reject.rawValue) &&
                      (Int(job.status!) != taskStatusType.Closed.rawValue)
                  {
                      let userJobs = DatabaseClass.shared.createEntity(entityName: "AppointmentList")
                      userJobs?.setValuesForKeys(job.toDictionary!)
                      // DatabaseClass.shared.saveEntity()
                  }
              }
          }
      }
      
      
      func saveUserJobsInDataBase( data : [AppointmentListData]) -> Void {
          
          for job in data{
              let query = "appId = '\(job.appId!)'"
              let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: query) as! [AppointmentList]
              if isExist.count > 0 {
                  let existingJob = isExist[0]
                  //if Job status Cancel, Reject, Closed so this job is delete from Database
                  
                  if(job.isdelete == "0") {
                      ChatManager.shared.removeJobForChat(jobId: existingJob.appId!)
                      DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                  }else if (Int(job.status!) == taskStatusType.Cancel.rawValue) ||
                      (Int(job.status!) == taskStatusType.Reject.rawValue) ||
                      (Int(job.status!) == taskStatusType.Closed.rawValue)
                  {
                      ChatManager.shared.removeJobForChat(jobId: existingJob.appId!)
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
                          let userJobs = DatabaseClass.shared.createEntity(entityName: "AppointmentList")
                          userJobs?.setValuesForKeys(job.toDictionary!)
                          //DatabaseClass.shared.saveEntity()
                          
                          let query = "appId = '\(job.tempId!)'"
                          let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: query) as! [AppointmentList]
                          
                          if isExistJob.count > 0 {
                              let existing = isExistJob[0]
                              DatabaseClass.shared.deleteEntity(object: existing, callback: { (_) in})
                          }
                          
                      }
                  }
              }
          }
            getClientListFromDBjob()
          
      }
      
      func saveAllGetDataInDatabase(callback:(Bool)  -> Void) -> Void {
          self.count = 0
          DatabaseClass.shared.saveEntity(callback: callback)
      }
      
      
      
      //===============================
      // MARK:- Data - Passing method
      //===============================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "show" {
            if let indexPath = tableView_job.indexPathForSelectedRow {
                
                let data = arrFilterData[indexPath.row]
                
                if data.JobType == "1" {
                    let searchQuery = "jobId = '\(String(describing: data.commonId!))'"
                    let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
                    if isExist.count > 0 {
                        let existingJob = isExist[0]
                        
                        jobTabVC = (segue.destination as! JobTabController)
                        APP_Delegate.currentJobTab = jobTabVC
                        
                        jobTabVC!.jobs = isExist // as! [UserJobList]
                        jobTabVC!.objOfUserJobList = existingJob // as? UserJobList
                        jobTabVC!.callback = {(isDelete : Bool, object : NSManagedObject) -> Void in
                            if isDelete{
                                DispatchQueue.main.async {
                                    
                                    self.isAdded = true
                                    
                                    self.getClientListFromDBjob()
                                    
                                    self.jobTabVC!.navigationController?.popViewController(animated: true)
                                    self.jobTabVC = nil
                                }
                            }
                        }
                        
                        
                    }else {
                        jobTabVC = (segue.destination as! JobTabController)
                        APP_Delegate.currentJobTab = jobTabVC
                        
                        jobTabVC!.jobs = isExist // as! [UserJobList]
                        jobTabVC!.objOfUserJobList = arrOFUserData[indexPath.row] // as? UserJobList
                        jobTabVC!.callback = {(isDelete : Bool, object : NSManagedObject) -> Void in
                            if isDelete{
                                DispatchQueue.main.async {
                                    
                                    self.isAdded = true
                                    
                                    self.getClientListFromDBjob()
                                    
                                    self.jobTabVC!.navigationController?.popViewController(animated: true)
                                    self.jobTabVC = nil
                                }
                            }
                        }
                    }
                  
                }

            }
        } else if segue.identifier == "Details" {
            
            if notificationData == true {
                //self.filterArrToDateNoti(date: self.currentDate)
                if let indexPath = tableView_job.indexPathForSelectedRow {
                    let data = arrFilterData[indexPath.row]
                    appointmentDetainVC = (segue.destination as! DetailAppointmentVC)
                    appointmentDetainVC!.commanIdBool = true
                    appointmentDetainVC!.commanId = appCommanId
                    appointmentDetainVC!.appintDetainsDicCommon =  data//arrFilterDataNotyData[0]
                    appointmentDetainVC!.callback = {(isDelete : Bool, object : NSManagedObject) -> Void in
                        if isDelete{
                            DispatchQueue.main.async {
                                self.isAdded = true
                                self.appointmentDetainVC!.navigationController?.popViewController(animated: true)
                                self.appointmentDetainVC = nil
                            }
                        }
                    }
                }
            }else{
                if let indexPath = tableView_job.indexPathForSelectedRow {
                    
                    let data = arrFilterData[indexPath.row]
                    
                    if data.JobType == "2" {
                        appointmentDetainVC = (segue.destination as! DetailAppointmentVC)
                        appointmentDetainVC!.appintDetainsDicCommon = data
                        appointmentDetainVC!.callback = {(isDelete : Bool, object : NSManagedObject) -> Void in
                            if isDelete{
                                DispatchQueue.main.async {
                                    self.isAdded = true
                                    self.appointmentDetainVC!.navigationController?.popViewController(animated: true)
                                    self.appointmentDetainVC = nil
                                }
                            }
                        }
                    }
                }
            }
            
        } else if segue.identifier == "add" {
            let addJobVC = segue.destination as! AddAppointmentVC
            addJobVC.callbackForJobVC = {(isBack : Bool) -> Void in
                self.isAdded = true
                
            }
        }else{
            
            if let indexPath = tableView_job.indexPathForSelectedRow {
                
                // let dict = arrOFUserDataQuot[indexPath.row]
                let data = arrFilterData[indexPath.row]
                
                if data.JobType == "3" {
                    
                    let searchQuery = "audId = '\(String(describing: data.commonId!))'"
                    let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: searchQuery) as! [AuditOfflineList]
                    
                    if isExist.count > 0 {
                        let existingJob = isExist[0]
                        
                        auditDetalVc = (segue.destination as! AuditTabController)
                        
                        //appointmentDetainVC!.quotation = dict
                        auditDetalVc!.objOfUserJobList = existingJob
                        auditDetalVc!.callback = {(isDelete : Bool, object : NSManagedObject) -> Void in
                            if isDelete{
                                DispatchQueue.main.async {
                                    
                                    
                                    self.isAdded = true
                                    
                                    self.auditDetalVc!.navigationController?.popViewController(animated: true)
                                    self.auditDetalVc = nil
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //==================================
    // MARK:- Audit LIST Service methods
    //==================================
    func getAuditListService(){
        
       if !isHaveNetowork() {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            return
        }
       // showLoader()
        var dates = ("","")
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.usrId = getUserDetails()?.usrId
        param.limit = ContentLimit
        param.index = "0"
        param.search = ""
        param.dtf = dates.0
        param.dtt = dates.1
        param.isCallFromCurrent = "1"
        var dict = param.toDictionary
        //dict!["status"] = selectedStatus
        
        serverCommunicator(url: Service.getAuditList, param: dict) { (response, success) in
            
            
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.tableView_job.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(AuditListResponse.self, from: response as! Data) {
                    
                    killLoader()
                    
                    if decodedData.success == true{
                        
                        
                        if let arryCount = decodedData.data{
                            if arryCount.count > 0 {
                                
                               // self.count += (decodedData.data?.count)!
                                
                                if !self.isUserfirstLogin {
                                  
                                    self.saveUserAuditsInDataBase(data: decodedData.data!)
                                    
                                    DispatchQueue.main.async {
                                        self.filterArrToDate(date: self.currentDate)
                                   // self.tableView_job.reloadData()
                                    }
                                    //Request time will be update when data comes otherwise time won't be update
                                    UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getAuditList)
                                    
                                    
                                }else{
                                    self.saveAllUserAuditInDataBase(data: decodedData.data!)
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }
    }
    
    //=====================================
    // MARK:- save offline  in AuditList
    //=====================================
            
            func saveAllUserAuditInDataBase( data : [AuditListData]) -> Void {
                for job in data{
                    //if(job.isdelete != "0"){
                        if (Int(job.status!) != taskStatusType.Cancel.rawValue) &&
                            (Int(job.status!) != taskStatusType.Reject.rawValue) &&
                            (Int(job.status!) != taskStatusType.Closed.rawValue)
                        {
                            let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
                            userJobs?.setValuesForKeys(job.toDictionary!)
                            //DatabaseClass.shared.saveEntity(callback: {_ in
                                
                            //})
                        }
                    }
               // }
            }
            
            func saveUserAuditsInDataBase( data : [AuditListData]) -> Void {

                     for job in data{
                         let query = "audId = '\(job.audId!)'"
                         let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: query) as! [AuditOfflineList]

                 
                         if isExist.count > 0 {
                             let existingJob = isExist[0]
                             //if Job status Cancel, Reject, Closed so this job is delete from Database

                             if(job.isdelete == "0") {
                                 ChatManager.shared.removeJobForChat(jobId: existingJob.audId!)
                                 DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                             }else if (Int(job.status!) == taskStatusType.Cancel.rawValue) ||
                                 (Int(job.status!) == taskStatusType.Reject.rawValue) ||
                                 (Int(job.status!) == taskStatusType.Closed.rawValue)
                             {
                                 ChatManager.shared.removeJobForChat(jobId: existingJob.audId!)
                                 DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                             }else{
                                 existingJob.setValuesForKeys(job.toDictionary!)
    //                        DatabaseClass.shared.saveEntity(callback: {_ in
    //
    //                        })
                            }
                         }else{
                             if(job.isdelete != "0") {
                                 if (Int(job.status!) != taskStatusType.Cancel.rawValue) &&
                                     (Int(job.status!) != taskStatusType.Reject.rawValue) &&
                                     (Int(job.status!) != taskStatusType.Closed.rawValue)
                                 {
                                     let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
                                     userJobs?.setValuesForKeys(job.toDictionary!)
                          //  print(userJobs)
    //                                 //DatabaseClass.shared.saveEntity()

                                     let query = "audId = '\(job.tempId ?? "")'"
                                     let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: query) as! [AuditOfflineList]

                                     if isExistJob.count > 0 {
                                         let existing = isExistJob[0]
                                         DatabaseClass.shared.deleteEntity(object: existing, callback: { (_) in})
                                     }

                                 }
                             }
                         }
                     }

                 }
      
  }
  //MARK:- UITableView
  extension CalenderVC : UITableViewDelegate, UITableViewDataSource{
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return arrFilterData.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentListCell") as! AppointmentListCell
          
         //=======
         // cell.itemImg.isHidden = true
         // cell.equipmentImg.isHidden = true
     
          if arrFilterData.count > 0 {
              let job = arrFilterData[indexPath.row]
              
              //==
              var someArray = [String]()
              if job.itemData  == "" {
                  cell.itemImg.isHidden = true
                  cell.withItmImg.constant = 0
                  
              }else{
                  cell.itemImg.image =  UIImage.init(named: "40x40")
                  cell.withItmImg.constant = 14
                  cell.itemImg.isHidden = false
              }
              
              if job.equArray  == ""{
                  cell.equipmentImg.isHidden = true
                  cell.wightEquipImg.constant = 0
                 
              }else{
                  
                  cell.wightEquipImg.constant = 14
                  cell.equipmentImg.isHidden = false
                  cell.equipmentImg.image =  UIImage.init(named: "equip")
              }
              //==
              
              if job.attachments == "0"  {
                  cell.attechmentImg.isHidden = true
                  
              }else{
                  if job.attachments == nil  {
                      cell.attechmentImg.isHidden = true
                  }else{
                      
                      cell.attechmentImg.isHidden = false
                      cell.attechmentImg.image =  UIImage.init(named: "icons8@-attech")
                }
                  
              }
              
            //========
              
     
              if job.JobType == "1" {
                  if job.commonId != nil {
                      let jobID = job.commonId
                          
                          cell.lblName.text = "\(job.label != nil ? job.label! : "Apl\(jobID)" ) - " + (job.nm != nil ? String(format: "%@", job.nm!) : "Unknown" )
                         
                    //}
                    
                  }
                  
                  var address = ""
                  if let adr = job.adr {
                      if adr != "" {
                          address = "\(String(describing: adr))"
                      }
                  }
                  
                  
                  if address != "" {
                      cell.lblAddress.attributedText = lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
                  }else{
                      cell.lblAddress.text = ""
                  }
                  
                  if job.schdlStart != "" {
                      let tempTime = convertTimestampToDate(timeInterval: (job.schdlStart!))
                      cell.lblTime.text = tempTime.0 + " " + tempTime.1
                  } else {
                      cell.lblTime.text = ""
                  }
                  
                  let ladksj = job.commonId!.components(separatedBy: "-")
                  if ladksj.count > 0 {
                      let tempId = ladksj[0]
                      if tempId == "Job" {
                          
                          cell.lblName.textColor = UIColor.red
                          cell.lblName.text = LanguageKey.job_not_sync
                          //cell.isUserInteractionEnabled = false
                          
                      }else{
                          cell.isUserInteractionEnabled = true
                          if job.status != "7"{
                              //cell.lblName.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                              cell.lblName.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                              cell.lblTime.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                              // cell.status.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                              
                              cell.lblTime.textColor = UIColor.init(red: 80.0/255.0, green: 164.0/255.0, blue: 181.0/255.0, alpha: 1.0)
                              cell.lblVertical.backgroundColor = UIColor.init(red: 80.0/255.0, green: 164.0/255.0, blue: 181.0/255.0, alpha: 1.0)
                              cell.lblStatus.textColor = UIColor.init(red: 80.0/255.0, green: 164.0/255.0, blue: 181.0/255.0, alpha: 1.0)
                          }
                      }
                      
                      cell.ViewBgJob.backgroundColor = UIColor.init(red: 230/255.0, green: 245/255.0, blue: 248/255.0, alpha: 1.0)
                  }
                  
                  cell.lblStatus.text = "\(LanguageKey.job) "
                  cell.doneBtn.isHidden = true
                  
                  
              } else if job.JobType == "2"{
                  
                  if let jobID = job.commonId {
                      
                      
                      cell.lblName.text = "\(String(describing: job.label != nil ? job.label! : "Apl\(jobID)") ) - " + (job.nm != nil ? String(format: "%@", job.nm! ) : "Unknown" )
                  }
                  
                  
                  var address = ""
                  if let adr = job.adr {
                      if adr != "" {
                          address = "\(String(describing: adr))"
                      }
                  }
                  
                  
                  if address != "" {
                      cell.lblAddress.attributedText = lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
                  }else{
                      cell.lblAddress.text = ""
                  }
                  
                  
                  let ladksj = job.commonId!.components(separatedBy: "-")
                  if ladksj.count > 0 {
                      let tempId = ladksj[0]
                      if tempId == "Appointment" {
                          
                          cell.lblName.textColor = UIColor.red
                          cell.lblName.text = "\(LanguageKey.appointment_not_sync) "
                          
                          
                          if job.schdlStart != "" {
                              let tempTime = convertTimestampToDate(timeInterval: (job.schdlStart!))
                              cell.lblTime.text = tempTime.0 + " " + tempTime.1
                          } else {
                              cell.lblTime.text = ""
                          }
                      }else{
                          cell.isUserInteractionEnabled = true
                          if job.status != "7"{
                              //cell.lblName.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                              cell.lblName.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                              
                          }
                          
                          if job.schdlStart != "" {
                              let tempTime = convertTimestampToDate(timeInterval: (job.schdlStart!))
                              cell.lblTime.text = tempTime.0 + " " + tempTime.1
                          } else {
                              cell.lblTime.text = ""
                          }
                      }
                      
                      cell.lblVertical.backgroundColor = UIColor.init(red: 64.0/255.0, green: 158/255.0, blue: 104/255.0, alpha: 1.0)
                      cell.lblTime.textColor = UIColor.init(red: 64.0/255.0, green: 158/255.0, blue: 104/255.0, alpha: 1.0)
                      cell.lblStatus.textColor = UIColor.init(red: 64.0/255.0, green: 158/255.0, blue: 104/255.0, alpha: 1.0)
                      
                      cell.ViewBgJob.backgroundColor = UIColor.init(red: 237/255.0, green: 248/255.0, blue: 238/255.0, alpha: 1.0)
                  }
                  cell.lblStatus.text = "\(LanguageKey.appointment) "
                  
                  
                  if job.status == "9"
                  {
                      cell.doneBtn.setImage(UIImage(named: "done.png"), for: .normal)
                      cell.doneBtn.isHidden = false
                  }else{
                      cell.doneBtn.isHidden = true
                  }
                  
                  
              } else if job.JobType == "3"{
                  
                  if let jobID = job.commonId {
                      ////
                      
                      //            if job.label != ""{
                      //            cell.name.text = "\(job.label != nil ? job.label! : "Apl\(jobID)" ) - " + (job.nm != nil ? String(format: "%@",  job.nm!) : "Unknown" )
                      //            }else{
                      //                cell.name.text = "Unknown"
                      //            }
                      
                      if job.label != nil {
                          cell.lblName.text = "\(String(describing: job.label != nil ? job.label! : "Apl\(jobID)") )"// + (job.cnm != nil ? String(format: "%@", job.cnm! ) : "Unknown" )
                      }else{
                          cell.lblName.text = "Unknown"
                      }
                      
                  }
                  
                  
                  var address = ""
                  if let adr = job.adr {
                      if adr != "" {
                          address = "\(String(describing: adr))"
                      }
                  }
                  
                  
                  if address != "" {
                      cell.lblAddress.attributedText = lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
                  }else{
                      cell.lblAddress.text = ""
                  }
                  
                  
                  let ladksj = job.commonId!.components(separatedBy: "-")
                  if ladksj.count > 0 {
                      let tempId = ladksj[0]
                      if tempId == "Job" {
                          
                          
                          cell.lblName.textColor = UIColor.red
                          cell.lblName.text = "\(LanguageKey.audit_not_sync) "
                          
                          
                          if job.schdlStart != "" {
                              let tempTime = convertTimestampToDate(timeInterval: (job.schdlStart!))
                              cell.lblTime.text = tempTime.0 + " " + tempTime.1
                          } else {
                              cell.lblTime.text = ""
                          }
                      }else{
                          cell.isUserInteractionEnabled = true
                          if job.status != "7"{
                              //cell.lblName.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                              cell.lblName.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                              
                          }
                          
                          if job.schdlStart != "" {
                              let tempTime = convertTimestampToDate(timeInterval: (job.schdlStart!))
                              cell.lblTime.text = tempTime.0 + " " + tempTime.1
                          } else {
                              cell.lblTime.text = ""
                          }
                      }
                      
                      cell.lblVertical.backgroundColor = UIColor.init(red: 64.0/255.0, green: 158/255.0, blue: 104/255.0, alpha: 1.0)
                      cell.lblTime.textColor = UIColor.init(red: 64.0/255.0, green: 158/255.0, blue: 104/255.0, alpha: 1.0)
                      cell.lblStatus.textColor = UIColor.init(red: 64.0/255.0, green: 158/255.0, blue: 104/255.0, alpha: 1.0)
                      
                      cell.ViewBgJob.backgroundColor = UIColor.init(red: 237/255.0, green: 248/255.0, blue: 238/255.0, alpha: 1.0)
                  }
                  cell.lblStatus.text = "\(LanguageKey.audit_nav) "
                  cell.doneBtn.isHidden = true
                  var someArray = [String]()
                  
                  if arrOfUserAudit[0].equArray == someArray as NSObject {
                      cell.equipmentImg.isHidden = true
                      // cell.heightConstrant_Equipment.constant = 0
                      // cell.imgItems.image =  UIImage.init(named: "fw_icon")
                  }else{
                      cell.equipmentImg.isHidden = true
                      cell.equipmentImg.image =  UIImage.init(named: "equip")
                  }
                  
              }
              
          }
          
          return cell
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let job = arrFilterData[indexPath.row]
             // let dta = job as? UserJobList
             if job.JobType == "1" {
             performSegue(withIdentifier: "show", sender: self)
             } else if job.JobType == "2" {
             performSegue(withIdentifier: "Details", sender: self)
             } else {
             performSegue(withIdentifier: "auditTab", sender: self)
             }
         }
      
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
      }
    
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
                        
                        
                        saveCheckInId(checkinId: (decodedData.data?.checkId)!) //Save checkin id in Local
                        
                        saveDefaultSettings(userDetails: decodedData.data!) // Save All Default Settings in Local
                        
                        // self.processForCreateNode() // Intailise firebase
                        
                        if let round = getDefaultSettings()?.numAfterDecimal{ //This is round off digit for invoice
                            roundOff = round
                        }
                        let expireStatusCheck = decodedData.data!
                        if expireStatusCheck.expireStatus == 0
                        {
                            // self.getSubscriptionData()
                        }else{
                            
                            
                        }
                        
                        let existingDefLanguage = getDefaultLanugage()
                        if (decodedData.data?.language?.isLock == "1") || (existingDefLanguage == nil) || (existingDefLanguage?.fileName != decodedData.data?.language!.fileName) || (existingDefLanguage?.version != decodedData.data?.language!.version){
                            
                            var langName = ""
                            
                            if let language = decodedData.data!.languageList?.filter({$0.fileName == decodedData.data!.language?.fileName!}) {
                                langName = (language as [languageDetails])[0].nativeName!
                            }
                            
                            LanguageManager.shared.setLanguage(filename: (decodedData.data?.language!.fileName)!, filePath: (decodedData.data?.language!.filePath)!, languageName: langName, version: (decodedData.data?.language!.version)!, alert: false, callBack: { (success) in
                                if success {
                                    //killLoader()
                                    saveDefaultLanugage(lanugage: (decodedData.data?.language)!)
                                    self.setLocalization()
                                    // APP_Delegate.isLanguageChanged = true
                                    // self.performSegue(withIdentifier: "RevealView", sender: self)
                                }
                            })
                        }
                        
                        
                        let appVersion : Float = Float(String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!))!
                        if let ver = decodedData.data!.forceupdate_version {
                            if let forceVersion = Float(ver){
                                if forceVersion > appVersion{
                                    killLoader()
                                    navigateToLoginPage()
                                    
                                    //self.showUpdateAlert(isCancel: false)
                                    return
                                }
                            }
                        }
                        
                        
                        
                        let checkDate = UserDefaults.standard.value(forKey: "versionCheckDt") as? Date
                        
                        if (checkDate == nil) {
                            if let latestVersion = Float(decodedData.data!.version!) {
                                if latestVersion > appVersion {
                                    UserDefaults.standard.set(Date(), forKey: "versionCheckDt")
                                    killLoader()
                                }
                            }
                        }else{
                            let currentdat = CurrentLocalDate()
                            let previoursdt = convertInlocalDate(date: checkDate!)
                            
                            if previoursdt.compare(currentdat) == .orderedAscending {
                                // print("First Date is smaller then second date")
                                if let latestVersion = Float(decodedData.data!.version!){
                                    if latestVersion > appVersion{
                                        UserDefaults.standard.set(Date(), forKey: "versionCheckDt")
                                        killLoader()
                                    }
                                }
                            }
                        }
                        
                        
                        
                        ChatManager.shared.admins = (decodedData.data!.adminIds)!
                        
                        
                        DispatchQueue.main.async {
                            if isPermitForShow(permission: permissions.isJobAddOrNot) == true {
                                //self.btnAddJob.isHidden = false
                            }else{
                                //self.btnAddJob.isHidden = true
                            }
                        }
                        
                        
                        if !APP_Delegate.isOnlyLogin { // when user autologin then call this AutoLogin activity url otherwise not called
                            ActivityLog(module:Modules.login.rawValue , message: ActivityMessages.autoLogin)
                        }else{
                            APP_Delegate.isOnlyLogin = false
                        }
                        
                        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.joblist)
                        
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
    
    
    //=====================================
        // MARK:- get All users
        //=====================================

        func groupUserListForChat() {

            if !isHaveNetowork() {
              ShowError(message: AlertMessage.networkIssue, controller: windowController)
            hideloader()
                return
            }
            

            
            showLoader()
            let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.groupUserListForChat) as? String
            let param = Params()
            param.limit = ContentLimit
            param.index = "\(count)"
            param.search = ""
            param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
            
             serverCommunicator(url: Service.groupUserListForChat, param: param.toDictionary) { (response, success) in
                 // killLoader()
                 if(success){
                     let decoder = JSONDecoder()
                     if let decodedData = try? decoder.decode(AdminChatRes.self, from: response as! Data) {
                         if decodedData.success == true{
                           // DispatchQueue.main.async{
                                if decodedData.data!.count > 0 {
                                     self.saveUsersInDataBase(data: decodedData.data!)
                                    
    //                                var nameString = ""
    //                                for string in decodedData.data! {
    //                                    nameString = nameString + ", \(string.fnm!) \(string.lnm!)"
    //                                }
    //
    //
    //                                ShowError(message:"\((decodedData.data?.count)!) \(nameString)", controller: windowController)
                                    
                                    
                                     self.count += (decodedData.data?.count)!
                                 }
                                 
                                 if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                                     self.groupUserListForChat()
                                 }else{
                                    
                                    if self.isUserfirstLogin {
                                      //  self.changePercentage(apiNumber: 8, title: LanguageKey.title_chat)
                                        self.isUserfirstLogin = false
                                        UserDefaults.standard.set(false, forKey: "ShowProgressBarOnce")
                                    }
                                    
                                    //Request time will be update when response comes otherwise time won't be update
                                    UserDefaults.standard.set(CurrentDateTime(), forKey: Service.groupUserListForChat)
                                     
                                     self.saveAllGetDataInDatabase(callback: { isSucsess in
                                            self.getAllCompanySettings()
                                     })
                                 }
                            // }
                         }else{
                             ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                         }
                     }else{
                         ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                             if cancel {
                                 showLoader()
                                 self.groupUserListForChat()
                             }
                         })
                     }
                 }else{
                     ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                         if cancelButton {
                             showLoader()
                             self.groupUserListForChat()
                         }
                     })
                 }
             }
          }
        
        func saveUsersInDataBase( data : [AdminChat]) -> Void {
               for jobs in data{
                   let userJobs = DatabaseClass.shared.createEntity(entityName: "Users")
                   userJobs?.setValuesForKeys(jobs.toDictionary!)
                   //DatabaseClass.shared.saveEntity()
               }
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
        param.dateTime = lastRequestTime//currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
        
      //  print(param.toDictionary)
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
                        
                        //print("jugaljob \(decodedData)")
                        
                        if let arryCount = decodedData.data{
                            // if arryCount.count > 0{
                            
                            
                            
                            self.count += (decodedData.data?.count)!
                            
                            if !self.isUserfirstLogin {
                                
                                self.saveUserJobsInDataBase(data: decodedData.data!)
                                
                                //Request time will be update when data comes otherwise time won't be update
                                UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getJobList)
                                
                            }else{
                                self.saveAllUserJobsInDataBase(data: decodedData.data!)
                            }
                            
                        }else{
                            if self.arrOFUserData.count == 0{
                                DispatchQueue.main.async {
                                    
                                }
                            }
                        }
                        
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                            self.getJobListService()
                        }else{
                            
                            
                            if self.isUserfirstLogin {
                                
                                //Request time will be update when data comes otherwise time won't be update
                                UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getJobList)
                                
                                
                                
                                self.saveAllGetDataInDatabase(callback: { isSuccess in
                                    if APP_Delegate.apiCallFirstTime {
                                        APP_Delegate.apiCallFirstTime = false
                                        self.groupUserListForChat()
                                        // self.getAllCompanySettings()
                                    }else{
                                        killLoader()
                                    }
                                })
                            }
                        }
                    }
                }
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
                        
                        
                        //Create listner for new job
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
    
  }


extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
