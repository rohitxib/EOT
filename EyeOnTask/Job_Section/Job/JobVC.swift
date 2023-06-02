//
//  JobVC.swift
//  EyeOnTask
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//


enum SortType : Int {
    case SortByDate = 1
    case SortByRecent
}

import UIKit
import CoreData
import CoreLocation
import Firebase

class JobVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate , UITextFieldDelegate{
    
    
    @IBOutlet var subcriptionView: UIView!
    @IBOutlet weak var lblLogoName: UILabel!
    @IBOutlet weak var logoImgVeiw: UIImageView!
    @IBOutlet weak var lblSubcriptionMsg: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnSortRecent: UIButton!
    @IBOutlet weak var btnSortDate: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnAddJob: UIButton!
    // @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var extraButton: UIBarButtonItem!
    @IBOutlet var lblNoJob: UILabel!
    @IBOutlet weak var searchVw_H: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearchfield: UITextField!
    @IBOutlet weak var radioButtonDate: UIImageView!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var radioButtonRecent: UIImageView!
    @IBOutlet weak var filterTagsView: ASJTagsView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var collectionVw_H: NSLayoutConstraint!
    @IBOutlet var sortView: UIView!
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filtertagHeight: NSLayoutConstraint!
    @IBOutlet weak var btnInProgress: UIButton!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var btnInprogressW: NSLayoutConstraint!
    @IBOutlet weak var btnTodayW: NSLayoutConstraint!
    
    var refreshControl = UIRefreshControl()
    var jobStatusArr = [JobStatusList]()
    var arrOFUserData = [UserJobList]()
    var arrOFNotyData = [UserJobList]()
    var arrOFData = [UserJobList]()
    var filterDict = [String : [UserJobList]]()
    var arrOfFilterDict  = [[String : [UserJobList]]]()
    var filterTitleArray = [taskStatusTypeForDispatch]()
    var filterjobsArray = [Int]()
    var isAdded = Bool()
    var isChanged = Bool()
    var isUserfirstLogin = Bool()
    var selectedCell : IndexPath? = nil
    var selectedJobID : String? = nil
    var queue = OperationQueue()
    var jobTabVC : JobTabController?
    var multiFilterArray = [[String : String]]()
    var isOpenSerchView : Bool = false
    var count : Int = 0
    var count1 : Int = 300
    var count2: Int = 500
    var arrItemListOnlineCont = [ContactRespsDetails]()
    var searchkry:Bool = false
    var addcount : Int = 0
    var globel :Int = 0
    var searchInventroryCount : Int = 0
    var previousInProgress : Bool = false
    var sorting : SortType = SortType.SortByRecent
    var callbackDetailVC: ((Bool) -> Void)?
    var subcriptionData:SubcriptionResponse?
    var isBarcodeScanner = false
    var arrOFUserData2 = [UserJobList]()
    var isJob = false
    var isJobBarcodeSceen = false
    var jobTabVc : LinkEquipmentReport?
    var isBackRemark = false
    var isFistTimegetClientContactSink = Bool()
    var timer:Timer?
    var PurchaseOrderArr = [PurchaseOrderData]()
    var PurchaseOrderArrList = [PurchaseOrderList]()
    var clientNmPerm = ""
    var globleimgStatus = ""
    var globleImg = UIImage()
    var sortBtnTag = 0
    var isBackButton = false
    var inprogressIndexpath : IndexPath?
    var todaySectionIndexpath : IndexPath?
    var isFirstLoginTime = ""
    var notificationData = false
    var arrItemListOnline1GetJobTittle = [taxListRes]()
    var searchkryGetJobTittle:Bool = false
    var countGetJobTittle : Int = 0
    var addcountGetJobTittle : Int = 0
    var countIndex :Int = 0
    var addIndexCount:Int = 0
    var globelGetJobTCount:Int = 0
    var oneTimeGetJob:Bool = false
    var counFortGetJob:Int = 0
    var addcountForGetJob:Int = 0
    var getAllDataCountForGetJob:Int = 0
    var globelGetJobTittle :Int = 0
    var searchInventroryCountGetJobTittle : Int = 0
    var arrgetForClientSink = [ClientListData]()
    var searchkryForClientSink:Bool = false
    var countForClientSink : Int = 0
    var addcountForClientSink : Int = 0
    var globelForClientSink :Int = 0
    var searchForClientSink : Int = 0
    var ForClientSink:Bool = false
    var isCompAdrShowFirstMobile = true
    var DemoarrItemListOnline1GetJobTittle = [UserJobList]()
    var DemosearchkryGetJobTittle:Bool = false
    var DemoglobelGetJobTittle :Int = 0
    var DemocountGetJobTittle : Int = 0
    var DemoaddcountGetJobTittle : Int = 0
    var DemosearchInventroryCountGetJobTittle : Int = 0
    var dispatchIsShow = ""
    var dispatchIsSelect = ""
    var acceptedIsShow = ""
    var acceptedIsSelect = ""
    var breakIsShow = ""
    var breakIsSelect = ""
    var CompletedIsShow = ""
    var CompletedIsSelect = ""
    var onHoldIsShow = ""
    var onHoldIsSelcet = ""
    var dispatchedParm = false
    var acceptedParm = false
    var onHoldParm = false
    var jobBreakParm = false
    var someJobArchive = false
    
    //=========================
    // MARK:- Initial methods
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFormName()
    
        let on = "Off"
        UserDefaults.standard.set(on, forKey: "ForGetuserJoblistRefresh")
        
        self.jobStatusArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]

        for job in self.jobStatusArr{
            
            switch job.id {
            case "1":
                
                if job.isStatusShow == "0"{
                    self.dispatchIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        
                        self.dispatchIsSelect = "0"
                    }else{
                        
                        self.dispatchIsSelect = "1"
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
               
            case "8":
                
                if job.isStatusShow == "0"{
                    
                    self.breakIsShow = "0"
                    
                }else{
                    if job.isFwSelect == "0"{
                        self.breakIsSelect = "0"
                    }else{
                        self.breakIsSelect = "1"
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
          
            default: break
                
            }
        }
        filterTitleArray = [.Dispatched,.Accepted,.OnHold,.JobBreak,.Completed]
        
        if  acceptedIsShow == "0" {
            acceptedParm = true
            let index = 1
            filterTitleArray.remove(at:index)
        }else{
            acceptedParm = false
        }
       
        if  onHoldIsShow == "0" {
            onHoldParm = true
            if acceptedParm == true {
                let index = 1
                filterTitleArray.remove(at:index)
            }else{
                let index = 2
                filterTitleArray.remove(at:index)
            }
        }else{
            onHoldParm = false
        }
       
        if  breakIsShow == "0" {
           
            if acceptedParm == true &&  onHoldParm == true {
                let index = 1
                filterTitleArray.remove(at:index)
            }else{
                
                if acceptedParm == true ||  onHoldParm == true {
                    let index = 2
                    filterTitleArray.remove(at:index)
                }else{
                    let index = 3
                    filterTitleArray.remove(at:index)
                }
               
            }
        }
        self.collectionVw.reloadData()
        isCompAdrShowFirstMobile = compPermissionVisible(permission: compPermission.isCompAdrShowFirstMobile)
        
        getPurchaseOrderList()
        getJobStatusList()
        
        if !self.isUserfirstLogin {
            self.showDataOnTableView(query: nil)
          
        }
        
        isFirstLoginTime = UserDefaults.standard.value(forKey: "myFirstLoging") as? String ?? ""
   
        
        getJobTittle()
        if isJob == true{
          
            let  barcodeValue = UserDefaults.standard.value(forKey: "barcodeString") as! String
            CommonClass.shared.jobEquipment(barcodeString: barcodeValue, arrOfData: arrOFUserData2)
        }
        
        hideBackgroundView()
        //--------Configure chat-------------------------------------
       
        self.navigationItem.title = ""
        var rect = self.sortView.frame //Set sortview frame
        rect.origin.y = btnSort.frame.origin.y + btnSort.frame.size.height - 5
        rect.origin.x = btnSort.frame.origin.x + 10
        self.sortView.frame = rect
        self.view.addSubview(self.sortView)
        self.navigationController?.isToolbarHidden = true
     
        NotiyCenterClass.someJobArchivedOrUnarchived(vc: self, selector: #selector(self.joblistRefreshForSomeArchiveJobs(_:)))
        NotiyCenterClass.registerRefreshJobListNotifier(vc: self, selector: #selector(self.joblistRefresh(_:)))
        NotiyCenterClass.addJobRefreshJobList(vc: self, selector: #selector(self.addJobRefreshJobList(_:))) 
        NotiyCenterClass.fireRefreshJobListNotifier(vc: self, selector: #selector(self.addJobRefreshJobList(_:)))
        NotiyCenterClass.registerJobRemoveNotifier(vc: self, selector: #selector(self.removeJobs(_:)))
        NotiyCenterClass.registerBatteryLevelNotifier()
        
        self.searchVw_H.constant = 0
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearchfield.frame.height))
        txtSearchfield.leftView = paddingView
        txtSearchfield.leftViewMode = UITextField.ViewMode.always
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtSearchfield.frame.height))
        txtSearchfield.rightView = paddingView1
        txtSearchfield.rightViewMode = UITextField.ViewMode.always
        
        
        if isPermitForShow(permission: permissions.isJobAddOrNot) == true {
            self.btnAddJob.isHidden = false
        }
       
        isAdded = true
        isChanged = true
        
        DatabaseClass.shared.callbackForJobVC = {( isReload : Bool?) -> Void in
            if(isReload)!{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
       
        lblNoJob.isHidden = true
        if let revealController = self.revealViewController(){
            revealViewController().delegate = self
            extraButton.target = revealViewController()
            extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealController.tapGestureRecognizer()
        }
        
        //Database sync
        DatabaseClass.shared.syncDatabase()
        
        DatabaseClass.shared.progressBackground.isHidden = true
        //Show progress bar when firstTime load details of any user OR switch any user
        isUserfirstLogin =  (UserDefaults.standard.value(forKey: "ShowProgressBarOnce") as? Bool) ?? false
        if isUserfirstLogin {
          
            DispatchQueue.main.async {
                showLoader()
            }
            
            showProgressBar()
            getJobTittle()
           
        }else{
            self.navigationItem.title = LanguageKey.jobs
          
            if !isHaveNetowork() {
                killLoader()
            }
            
            getJobListFromDB()
           
        }
   
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        setLocalization()
        
        if isBackButton {
            self.extraButton.isEnabled = false
            SetBackBarButtonCustom()
       
        }else{
            APP_Delegate.currentVC = "job"
        }
        
        if someJobArchive {
            self.extraButton.isEnabled = false
            SetBackBarButtonCustomForArchive()
       
        }
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 103.0, right: 0)
        self.tableView.contentInset = insets
      
    }
    
    @objc func joblistRefresh1(_ notification: NSNotification){
      if let controllers = self.navigationController?.viewControllers{
          for view in controllers{
              if (view .isKind(of: AuditVC.self)){
                  self.navigationController?.popToViewController(view, animated: true)
              }
          }
          self.getJobListService()
      }
    }
    
    @objc  func redirectJob(){
        
        notificationData = true
        
        if isJobBarcodeSceen != true {
        performSegue(withIdentifier: "show", sender: self)
        }
        
        timer?.invalidate()
        timer = nil
        
    }
    
    @objc func redirectJobByNotification() {
        
        notificationData = true
        if isJobBarcodeSceen != true {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "show", sender: self)
            }
        }
        
        timer?.invalidate()
        timer = nil
        
    }
    
    @objc  func redirect(){
      
        let vc = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC
       
        self.navigationController?.pushViewController(vc, animated: true)
        
        timer?.invalidate()
        timer = nil
        
    }
    
    @objc func GoToBack(){
        
        self.navigationController!.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.revealViewController()?.revealToggle(animated: true)
    }
    
    func addShadowOnButton() {
        btnInProgress.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnInProgress.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnInProgress.layer.shadowOpacity = 1.0
        btnInProgress.layer.shadowRadius = 0.0
        btnInProgress.layer.masksToBounds = false
        btnInProgress.layer.cornerRadius = 4.0
    }
    
    var lastContentOffset: CGFloat = 0
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            var isUp : Bool?
            if self.lastContentOffset < scrollView.contentOffset.y {
               
                isUp = true
            } else if self.lastContentOffset > scrollView.contentOffset.y {
                
                isUp = false
            }
            bottomButtonShowHide(isUp: isUp)
        }
    }
    
    func viewWillAppear(animated: Bool) {
       
        super.viewWillAppear(animated) // No need for semicolon
        if let revealController = self.revealViewController(){
            revealViewController().delegate = self
            extraButton.target = revealViewController()
            extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealController.tapGestureRecognizer()
        }
    }

    func bottomButtonShowHide(isUp : Bool?) {
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            
            if inprogressIndexpath == nil || indexPaths.contains(inprogressIndexpath!) {
                self.btnInprogressW.constant = 0.0
                self.btnInProgress.isHidden = true
            }else{
                self.btnInprogressW.constant = 107.0
                self.btnInProgress.isHidden = false
                if let isup = isUp {
                    if isup {
                        btnInProgress.setImage(UIImage.init(named: "Up arrow"), for: .normal)
                    }else{
                        btnInProgress.setImage(UIImage.init(named: "Down arrow" ), for: .normal)
                    }
                }
            }
        
            if todaySectionIndexpath == nil || indexPaths.contains(todaySectionIndexpath!) {
                self.btnTodayW.constant = 0.0
                self.btnToday.isHidden = true
            }else{
                self.btnTodayW.constant = 103.0
                self.btnToday.isHidden = false
                if let isup = isUp {
                    if isup {
                        btnToday.setImage(UIImage.init(named: "Up arrow"), for: .normal)
                    }else{
                        btnToday.setImage(UIImage.init(named: "Down arrow" ), for: .normal)
                    }
                }
            }
            
        }
    }

    func setLocalization() -> Void {
        DispatchQueue.main.async {
            // self.changeSortButton(tag: self.sortBtnTag)
            if (self.isFirstLoginTime == "1") {
                self.lblNoJob .text = ""
            }else{
                
                self.lblNoJob .text = LanguageKey.err_no_jobs_found
       
            }
            
            self.txtSearchfield.placeholder = LanguageKey.search_job_code_client_name_address
            self.btnReset.setTitle(LanguageKey.reset, for: .normal)
            
            if DatabaseClass.shared.progressBackground.isHidden == true{
                self.navigationItem.title = LanguageKey.jobs
            }
        }
    }
    
    
    func showProgressBar() -> Void {
        DatabaseClass.shared.InitializeProgressBar()
        DatabaseClass.shared.progressBackground.isHidden = false
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
        changePercentage(apiNumber:0,title: LanguageKey.Job_title)
    }
 
    func changePercentage(apiNumber : Int, title : String) -> Void {
        DispatchQueue.main.async {
            let count = (apiNumber*100)/8
            DatabaseClass.shared.label.text = "\(title).....\(Int(count))%"
            DatabaseClass.shared.progressView.progress = Float(count)/100
            
            if count == 100 {
                self.progressBarHidden()
                if (self.isFirstLoginTime == "1") {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.redirect), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    func progressBarHidden() -> Void {
        
        if DatabaseClass.shared.progressBackground.isHidden == false {
            DispatchQueue.main.async {
                DatabaseClass.shared.progressBackground.isHidden = true
                self.navigationItem.title = LanguageKey.jobs
                UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
                DatabaseClass.shared.progressView.progress = 0.0
                DatabaseClass.shared.label.text = "\(LanguageKey.sync_alert).....0%"
              
            }
        }
    }
    
    @objc func joblistRefresh(_ notification: NSNotification){
       
        count = 0
        self.getJobListService()
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.redirectJobByNotification), userInfo: nil, repeats: false)
        
    }
    
    @objc func joblistRefreshForSomeArchiveJobs(_ notification: NSNotification){
       
        count = 0
        self.getJobListService()
     
    }
    
    @objc func refreshControllerMethod() {
        getJobListService()
    }
    
    @objc func addJobRefreshJobList(_ notification: NSNotification) {
           if isHaveNetowork() {
           count = 0
           self.getJobListService()
           } else {
               showDataOnTableView(query: nil)
               killLoader()
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        getJobStatusList()
        self.jobStatusArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
        if isBackRemark{
            
            SetBackBarButtonCustomRemark()
           
        }
    
        var forRefresh = ""
        forRefresh = UserDefaults.standard.value(forKey: "ForGetuserJoblistRefresh") as? String ?? ""
        
        if forRefresh == "On"{
            getJobListService()
        }
     
        // ChatManager.shared.listenerForjob?.remove()
        APP_Delegate.arrOFCustomForm.removeAll()
        
        tableView.estimatedRowHeight = 200
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
    
        // this condition manage For the case of OFFLINE mode
        if self.multiFilterArray.count > 0 {
            DispatchQueue.main.async {
               
                for dict in self.multiFilterArray {
                    if (dict["Status"] != nil) {
                        self.filterTagsView.deleteTag(dict["Status"]!)
                    }else{
                        self.filterTagsView.deleteTag(dict["Tag"]!)
                    }
                }
                self.getQuryFormMultipleFilter(isDelete: false)
            }
        }else if filterjobsArray.count > 0 {
            filterDataFromDB()
        }else{
            if isBarcodeScanner {
                self.extraButton.isEnabled = false
                SetBackBarButtonCustom()
                createSection2()
                
            }else{
              //  self.showDataOnTableView(query: nil)
                createSection()
            }
        }
    }
    
    func SetBackBarButtonCustomRemark(){
        let button = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(onClcikBack1))
        self.navigationItem.leftBarButtonItem  = button
    }
    
    @objc func onClcikBack1(){
        
        self.dismiss(animated: true, completion: nil)
       
    }
    
    func SetBackBarButtonCustomForArchive(){
        let button = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(JobVC.onClcikBack))
        self.navigationItem.leftBarButtonItem  = button
        
    }
    
    func SetBackBarButtonCustom(){
        let button = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(JobVC.onClcikBack))
        self.navigationItem.leftBarButtonItem  = button
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
            self.redirectJobByNotification()
        }
       
    }
    
    @objc func onClcikBack(){
       
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        progressBarHidden()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        
        ActivityLog(module: Modules.logout.rawValue, message: ActivityMessages.sideMenuLogout)
        
        logoutFromAllEnvirements()
        
        if isHaveNetowork() {
            let param = Params()
            param.udId = getUserDetails()?.udId

            serverCommunicator(url: Service.logout, param: param.toDictionary) { (response, success) in
                
            }
        }else{
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
        }
        
        let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
        appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        
        hideBackgroundView()
        
    }
    @IBAction func searchBtnAction(_ sender: Any) {
        if(!isOpenSerchView){
            self.view.bringSubviewToFront(searchView)
            self.searchVw_H.constant = 44
            self.collectionVw_H.constant = 44
          
            isOpenSerchView = true
         
            self.filterView.isHidden = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }) { (isComplete) in
                
                if isComplete {
                    self.filterjobsArray.removeAll()
                    self.collectionVw.reloadData()
                    self.showDataOnTableView(query: nil)
                }
            }
        }else{
            showDataOnTableView(query: nil)
            self.searchVw_H.constant = 0
            self.collectionVw_H.constant = 50
           
            self.txtSearchfield.text = ""
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
            isOpenSerchView = false
        }
    }
    
    func createSection2(){
        
        arrOfFilterDict.removeAll()
        var arrOFData = [UserJobList]()
        var filterDict = [String : [UserJobList]]()
        var LatestFilterDict = [[String : [UserJobList]]]()
        
        var currentDate = ""
      
        for objOfUserData in self.arrOFUserData2{
            let strDate = dayDifference(unixTimestamp: objOfUserData.createDate ?? "")
            
            if(LatestFilterDict.count > 0){
                
                // Below is new change implemented by Hemant
                if currentDate == strDate {
                    var dictObj = LatestFilterDict.last
                    dictObj![strDate]?.append(objOfUserData)
                    LatestFilterDict[LatestFilterDict.count-1] = dictObj!
                }else{
                    currentDate = strDate
                    arrOFData.removeAll()
                    filterDict.removeAll()
                    arrOFData.append(objOfUserData)
                    filterDict[strDate] = arrOFData
                    LatestFilterDict.append(filterDict)
                }
            }else{
                currentDate = strDate
                arrOFData.append(objOfUserData)
                filterDict[strDate] = arrOFData
                LatestFilterDict.append(filterDict)
            }
        }
        
        DispatchQueue.main.async{
            self.arrOfFilterDict = LatestFilterDict
            self.tableView.reloadData()
            //self.hideloader()
        }
        
    }
    
    
    //========================
    // MARK:- Txt Field Delegates
    //========================
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        var query = ""
        if result.count > 2 || result.count == 0 {
            if result != "" {
                query = "nm CONTAINS[c] '\(result)' OR adr CONTAINS[c] '\(result)' OR label CONTAINS[c] '\(result)' OR city CONTAINS[c] '\(result)'"
            }
            
            showDataOnTableView(query: query == "" ? nil : query)
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtSearchfield.resignFirstResponder()
        return true
    }
    //=======================
    // Disable Pan gesture
    //========================
    func revealControllerPanGestureShouldBegin(_ revealController: SWRevealViewController!) -> Bool {
        return false
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if position == .left {
            setLocalization()
            //getJobListService()
        }
    }
    
    //==========================
    // MARK:- Tableview methods
    //==========================
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrOfFilterDict.count
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Section \(section)"
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: Int(self.tableView.frame.size.width), height: 30)
        headerView.backgroundColor = UIColor(red: 246.0/255.0, green: 242.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        
        let headerLabel = UILabel(frame: CGRect(x: 14, y: 10, width:
            headerView.bounds.size.width-20, height: 20))
        headerLabel.font = Font.ArimoBold(fontSize: 13.0)
        headerLabel.textColor = UIColor(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
        
        let dict = self.arrOfFilterDict[section]
        let firstKey = Array(dict.keys)[0]
        var arr = firstKey.components(separatedBy: ",")
      
        let att = changeColoreOFDate(main_string: firstKey, string_to_color: arr[0])
        
        if(arr[0] == "Today" || arr[0] == "Yesterday" || arr[0] == "Tomorrow" ) {
            
            
            headerLabel.attributedText = att // with date
        }else{
            headerLabel.text = att.string // without date
            
        }
        
        if (arr[0] == ""){
            headerLabel.text = "Unschedule Jobs"
            
        }
  
        headerLabel.textAlignment = .left;
        
        DispatchQueue.main.async {
            headerView.addSubview(headerLabel)
        }
        
        return headerView
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(self.arrOfFilterDict.count != 0){
            let dict = self.arrOfFilterDict[section]
            let firstKey = Array(dict.keys)[0]
            
            if ((firstKey as String) == "") && (section == 0) {
                return 30.0
            }
            return 30.0
        }else{
            return 30.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        if(self.arrOfFilterDict.count != 0){
            let dict = self.arrOfFilterDict[section]
            let firstKey = Array(dict.keys)[0] // or .first
            let arr = dict[firstKey]
            return arr!.count
        }else{
            return arrOfFilterDict.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
        let dict = self.arrOfFilterDict[indexPath.section]
        let firstKey = Array(dict.keys)[0] // or .first
        let arr = dict[firstKey]
        let job = arr![indexPath.row]
        cell.imgItems.isHidden = true
        cell.imgEquipment.isHidden = true
        cell.Attchment.isHidden = true
        
        if selectedJobID == job.jobId {
            cell.rightView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            cell.leftBaseView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        }else{
            cell.rightView.backgroundColor = UIColor.white
            cell.leftBaseView.backgroundColor = UIColor.white
        }
        
        var someArray = [String]()
        if job.itemData  == someArray as NSObject || job.itemData == nil {
            cell.imgItems.isHidden = true
            cell.heightConstrant_Item.constant = 0
            
        }else{
            cell.imgItems.image =  UIImage.init(named: "40x40")
            cell.heightConstrant_Item.constant = 14
            cell.imgItems.isHidden = false
        }
        
        if job.equArray == someArray as NSObject || job.equArray == nil {
            cell.imgEquipment.isHidden = true
            cell.heightConstrant_Equipment.constant = 0
           
        }else{
            
            cell.heightConstrant_Equipment.constant = 14
            cell.imgEquipment.isHidden = false
            cell.imgEquipment.image =  UIImage.init(named: "equip")
        }
        
        if job.attachCount == "0"  {
            cell.Attchment.isHidden = true
            
        }else{
            if job.attachCount == nil  {
                cell.Attchment.isHidden = true
            }else{
                
                cell.Attchment.isHidden = false
                cell.Attchment.image =  UIImage.init(named: "icons8@-attech")
                
            }
            
        }
        
        var isSwitchOff = ""
        isSwitchOff =   UserDefaults.standard.value(forKey: "TokenOff") as? String ?? ""
        
        var adf = "Off"
        var adf1 = "On"
        
        if (isSwitchOff == "Off") {
            
            cell.selfLbl_H.constant = 0
            
        }else{
            cell.selfLbl.text = job.snm
            cell.selfLbl_H.constant = 13
        }
        
        if job.jobId != nil {
            let ladksjy  = job.jobId!.components(separatedBy: "-")
            if ladksjy.count > 0 {
                let tempId = ladksjy[0]
                if tempId == "Job" {
                    if job.jobId != nil {
                        
                        if isCompAdrShowFirstMobile == false {
                            
                            var address1 = ""
                            if let adr = job.adr {
                                if adr != "" {
                                    address1 = "\(adr)"
                                }
                            }
                            
                            if let city = job.city {
                                if city != "" {
                                    if address1 != ""{
                                        address1 = address1 + ", \(city)".capitalized
                                    }else{
                                        address1 = "\(city)"
                                    }
                                }
                            }
                            
                            if  address1 != "" {
                                cell.name.attributedText =  lineSpacing(string: address1.capitalizingFirstLetter(), lineSpacing: 5.0)
                            }else{
                                cell.name.text = ""
                            }
                            clientNmPerm = "\(job.label != nil ? job.label! : "Job - Client" ) - " + (job.nm != nil ? String(format: "%@",  job.nm!) : "Unknown" )
                        }else{
                            cell.name.text = "\(job.label != nil ? job.label! : "Job - Client" ) - " + (job.nm != nil ? String(format: "%@",  job.nm!) : "Unknown" )
                        }
                  
                        let jj = job.attachCount
                        
                    }
                    
                }else{
                    cell.isUserInteractionEnabled = true
                    if job.status != "7"{
                        if let jobID = job.jobId {
                            let jj = job.attachCount
                            
                            if isCompAdrShowFirstMobile == false {
                                
                                var address1 = ""
                                if let adr = job.adr {
                                    if adr != "" {
                                        address1 = "\(adr)"
                                    }
                                }
                                
                                if let city = job.city {
                                    if city != "" {
                                        if address1 != ""{
                                            address1 = address1 + ", \(city)".capitalized
                                        }else{
                                            address1 = "\(city)"
                                        }
                                    }
                                }
                                
                                if  address1 != "" {
                                    cell.name.attributedText =  lineSpacing(string: address1.capitalizingFirstLetter(), lineSpacing: 5.0)
                                }else{
                                    cell.name.text = ""
                                }
                                clientNmPerm = "\(job.label != nil ? job.label! : "Apl\(jobID)" ) - " + (job.nm != nil ? String(format: "%@",  job.nm!) : "Unknown" )
                            }else{
                                if job.label != ""{
                                  
                                    cell.name.text = "\(job.label != nil ? job.label! : "Apl\(jobID)" ) - " + (job.nm != nil ? String(format: "%@",  job.nm!) : "Unknown" )
                                }else{
                                    cell.name.text = "Unknown"
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }
        var address = ""
        if let adr = job.adr {
            if adr != "" {
                address = "\(adr)"
            }
        }
        
        if let city = job.city {
            if city != "" {
                if address != ""{
                    address = address + ", \(city)".capitalized
                }else{
                    address = "\(city)"
                }
            }
        }
        
        
        if isCompAdrShowFirstMobile == false {
           
                cell.taskDescription.text =  clientNmPerm
   
        }else{
            if  address != "" {
                cell.taskDescription.attributedText =  lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
            }else{
                cell.taskDescription.text = ""
            }
        }
  
        var strTitle = ""
        
        if job.jtId != nil {
            for jtid in (job.jtId as! [AnyObject]) {
                if strTitle == ""{
                    strTitle = (jtid as! [String:String])["title"] ?? ""
                }else{
                    strTitle = "\(strTitle), \((jtid as! [String:String])["title"] ?? "")"
                }
            }
        }

        cell.lblTitle.text = strTitle
        
        if job.schdlStart != "" && job.schdlStart != nil{
            let tempTime = convertTimestampToDate(timeInterval: job.schdlStart!)
            cell.time.text = tempTime.0
            cell.timeAMPM.text = tempTime.1
        } else {
            cell.time.text = ""
            cell.timeAMPM.text = ""
        }

        let status = job.status ?? "" == "0" ? "1" : job.status  ?? ""
        if (job.status ?? "" == "0" ? "1" : job.status ?? "") == "7"{
            
            var someArray = [String]()
            if job.itemData  == someArray as NSObject {
                cell.imgItems.isHidden = true
                cell.heightConstrant_Item.constant = 0
                
            }else{
                cell.imgItems.image =  UIImage.init(named: "40x40")
                cell.heightConstrant_Item.constant = 14
                cell.imgItems.isHidden = false
            }
            
            if job.equArray == someArray as NSObject {
                cell.imgEquipment.isHidden = true
                cell.heightConstrant_Equipment.constant = 0
                
            }else{
                
                cell.heightConstrant_Equipment.constant = 14
                cell.imgEquipment.isHidden = false
                cell.imgEquipment.image =  UIImage.init(named: "equip")
            }
            
            if job.attachCount == "0"  {
                cell.Attchment.isHidden = true
                
            }else{
                if job.attachCount == nil  {
                    cell.Attchment.isHidden = true
                }else{
                    
                    cell.Attchment.isHidden = false
                    cell.Attchment.image =  UIImage.init(named: "icons8@-attech")
                    
                }
                
            }
            
            if let jobID = job.jobId {
            
                if isCompAdrShowFirstMobile == false {
                    
                    var address1 = ""
                    if let adr = job.adr {
                        if adr != "" {
                            address1 = "\(adr)"
                        }
                    }
                    
                    if let city = job.city {
                        if city != "" {
                            if address1 != ""{
                                address1 = address1 + ", \(city)".capitalized
                            }else{
                                address1 = "\(city)"
                            }
                        }
                    }
                    
                    if  address1 != "" {
                        cell.name.attributedText =  lineSpacing(string: address1.capitalizingFirstLetter(), lineSpacing: 5.0)
                    }else{
                        cell.name.text = ""
                    }
                    cell.taskDescription.text = "\(job.label != nil ? job.label! : "Apl\(jobID)" ) - " + (job.nm != nil ? String(format: "%@",  job.nm!) : "Unknown" )
                }else{
                    if job.label != ""{
                        
                        
                        cell.name.text = "\(job.label != nil ? job.label! : "Apl\(jobID)" ) - " + (job.nm != nil ? String(format: "%@",  job.nm!) : "Unknown" )
                    }else{
                        cell.name.text = "Unknown"
                    }
                }
       
            }
            
            for arr in jobStatusArr {
                if arr.id == status {
                    cell.status.text = arr.text
                }
            }
     
            cell.leftBaseView.backgroundColor = UIColor(red: 109.0/255.0, green: 209.0/255.0, blue: 32.0/255.0, alpha: 1.0)
            cell.status.textColor = UIColor.white
            cell.timeAMPM.textColor = UIColor.white
            cell.time.textColor = UIColor.white
            cell.statusImage.image  = UIImage.init(named: "inprogress_white")
        }else{
            
            if  status == "13" {
                cell.status.text = "Dispatched"
            }else{
              
                for arr in jobStatusArr {
                    if arr.id == status {
                       
                        cell.status.text = arr.text
                    }
                }
            }
           
            cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
            cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
           // cell.statusImage.image  = status.1
            if status == "1" {
                cell.statusImage.image = UIImage(named: "New_Task")
            }  else if status == "2" {
                cell.statusImage.image = UIImage(named: "Accepted_task")
            } else if status == "3" {
                cell.statusImage.image = UIImage(named: "Rejected_task")
            } else if status == "4" {
                cell.statusImage.image = UIImage(named: "cancel_task")
            } else if status == "5" {
                cell.statusImage.image = UIImage(named: "Travelling_task")
            } else if status == "6" {
                cell.statusImage.image = UIImage(named: "break_task")
            } else if status == "7" {
                cell.statusImage.image = UIImage(named: "In_progress_task")
            } else if status == "8" {
                cell.statusImage.image = UIImage(named: "job_break")
            } else if status == "9" {
                cell.statusImage.image = UIImage(named: "Complete_task")
            } else if status == "10" {
                cell.statusImage.image = UIImage(named: "closed_task")
            } else if status == "11" {
                cell.statusImage.image = UIImage(named: "whiteMulti_task")
            } else if status == "12" {
                cell.statusImage.image = UIImage(named: "Pending_task")
            }else{
                if (status != "13") ||  (status != "2") || (status != "3") || (status != "4") || (status != "5") || (status != "6") || (status != "7") || (status != "8") || (status != "9") ||  (status != "10") || (status != "11") || (status != "12"){
                    for arr in jobStatusArr {
                        if arr.id == status {
                           // DispatchQueue.main.async {
                            if arr.url != "" &&  arr.url != nil {
                                DispatchQueue.global().async { [weak self] in
                                let ar = URL(string: Service.BaseUrl)?.absoluteString
                                let ab = arr.url
                                if let data = try? Data(contentsOf: URL(string: ar! + ab!)!) {
                                    if let image = UIImage(data: data) {
                                        DispatchQueue.main.async {
                                            cell.statusImage.image = image
                                        }
                                    }
                                }
                            }
                            }else{
                                cell.statusImage.image = UIImage(named: "")
                            }
                        }
                    }
                } else{
                    cell.statusImage.image = UIImage(named: "")
                }
           
            } 
        }
        
        if job.prty != "0" && job.prty != nil && job.prty != ""{
            let priorityDetail = taskPriorityImage(Priority: taskPriorities(rawValue: Int(job.prty ?? "")!)!)
            cell.priorityImage.image = priorityDetail.1
        }
        
        //if user add job in OFFLINE mode and job not sync on the server
        let jobIdCount  = job.jobId
        if jobIdCount != nil &&  jobIdCount != "" {
            let ladksj  = job.jobId!.components(separatedBy: "-")
            if ladksj.count > 0 {
                let tempId = ladksj[0]
                if tempId == "Job" {
                    cell.heightConstrant_Item.constant = 0
                    cell.imgItems.isHidden = true
                    cell.imgEquipment.isHidden = true
                    cell.heightConstrant_Equipment.constant = 0
                    cell.Attchment.isHidden = true
                    cell.name.textColor = UIColor.lightGray
                    cell.lblTitle.textColor = UIColor.lightGray
                    cell.time.textColor = UIColor.lightGray
                    cell.timeAMPM.textColor = UIColor.lightGray
                    cell.status.textColor = UIColor.lightGray
                    cell.taskDescription.textColor = UIColor.red
                    cell.taskDescription.text = LanguageKey.job_not_sync
                    cell.isUserInteractionEnabled = false
                }else{
                    cell.isUserInteractionEnabled = true
                    if job.status != "7"{
                        cell.name.textColor =  UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        cell.lblTitle.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        cell.taskDescription.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        cell.time.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                        cell.timeAMPM.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                        cell.status.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                    }
                }
            }
        }
     
        let model = ChatManager.shared.chatModels.filter { (modelData : ChatModel) -> Bool in
            if modelData.jobId == job.jobId {
                return true
            }
            return false
        }
        
        if model.count > 0{
            
            model[0].cell = cell
            
            if model[0].count > 0{
                cell.lblBadge.text = "\(model[0].totelCount)"
                cell.lblBadge.isHidden = false
            }else{
                cell.lblBadge.isHidden = true
            }
        }
        
        if (job.status ?? "") == "11" {
            cell.isUserInteractionEnabled = false
        }else{
            cell.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notificationData = false
        if (selectedCell != nil) {
            //If selected cell exist on visible indexpaths
            let isExist = tableView.indexPathsForVisibleRows?.contains(selectedCell!)
            if isExist!{
                let cellPrevious = tableView.cellForRow(at: selectedCell!) as! TaskTableViewCell
                if previousInProgress ==  false {
                    cellPrevious.rightView.backgroundColor = UIColor.white
                    cellPrevious.leftBaseView.backgroundColor = UIColor.white
                }else{
                    cellPrevious.rightView.backgroundColor = UIColor.white
                }
            }
        }
        if isJob == true{
            if isJobBarcodeSceen != true {
            performSegue(withIdentifier: "linEquipment", sender: self)
            }
        }else {
            performSegue(withIdentifier: "show", sender: self)
        }
        
        //Get Job ID
        let dict = self.arrOfFilterDict[indexPath.section]
        let firstKey = Array(dict.keys)[0] // or .first
        let arr = dict[firstKey]
        let job = arr![indexPath.row]
        selectedJobID = job.jobId
       
        var kpr = job.kpr
        UserDefaults.standard.set(kpr, forKey: "kprVelue")
        
        var arrw = firstKey.components(separatedBy: ",")
        
        if arrw.count == 3 {
            var combainStr = "\(arrw[1])" + " - \(arrw[2])"
            
            UserDefaults.standard.set(combainStr , forKey: "UpDateStr")
        } else if arrw.count == 2 {
            var combainStr = "\(arrw[0])" + " - \(arrw[1])"
            
            UserDefaults.standard.set(combainStr , forKey: "UpDateStr")
        }else {
            var combainStr = " "
            
            UserDefaults.standard.set(combainStr , forKey: "UpDateStr")
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        
        if job.status != "7" {
            previousInProgress = false
            cell.leftBaseView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        }else{
            previousInProgress = true
        }
        self.selectedCell = indexPath
        cell.rightView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
    }
    
    
    //===============================
    // MARK:- Data - Passing method
    //===============================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if isJob == true
        {
           
            if segue.identifier == "linEquipment" {
           
                if let indexPath = tableView.indexPathForSelectedRow {
                    
                    jobTabVc = (segue.destination as! LinkEquipmentReport)
                    jobTabVc!.equipment = CommonClass.shared.equipmentDataJob[indexPath.section]
                    jobTabVc!.callback = {(isDelete : Bool, object : NSManagedObject) -> Void in
                        if isDelete{
                            DispatchQueue.main.async {
                                
                                self.isAdded = true
                                self.jobTabVc?.navigationController?.popViewController(animated: true)
                                self.jobTabVc = nil
                            }
                        }
                    }
                    
                }
            
            }
        }
        
        else if segue.identifier == "show" {
            
            if notificationData == true {
                
                var arrNoty = ""
                arrNoty = UserDefaults.standard.value(forKey: "ArrNotiLable") as? String ?? ""
                
                jobTabVC = (segue.destination as! JobTabController)
                APP_Delegate.currentJobTab = jobTabVC
                var jobRes = APP_Delegate.jobRes
                arrOFNotyData = self.arrOFUserData.filter({$0.label == arrNoty})
                
                if arrOFNotyData.count != nil &&  arrOFNotyData.count != 0{
                    jobTabVC!.jobs = self.arrOFUserData
                    jobTabVC!.objOfUserJobList = arrOFNotyData[0]
                    jobTabVC!.callback = {(isDelete : Bool, object : NSManagedObject) -> Void in
                        if isDelete{
                            DispatchQueue.main.async {
                                self.isAdded = true
                                self.isChanged = false
                                self.jobTabVC!.navigationController?.popViewController(animated: true)
                                self.jobTabVC = nil
                            }
                        }
                    }
                }
                
            }else{
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    
                    jobTabVC = (segue.destination as! JobTabController)
                  
                    APP_Delegate.currentJobTab = jobTabVC
                    var dict = self.arrOfFilterDict[indexPath.section]
                    let firstKey = Array(dict.keys)[0] 
                    var arr = dict[firstKey]
                    jobTabVC!.jobs = self.arrOFUserData
                   // jobTabVC!.objOfUserJobList = arr![indexPath.row]
                    if indexPath.row == arr?.count {
                        jobTabVC!.objOfUserJobList = arr![indexPath.row - 1]
                    } else {
                        jobTabVC!.objOfUserJobList = arr![indexPath.row]
                    }
                    jobTabVC!.callback = {(isDelete : Bool, object : NSManagedObject) -> Void in
                        if isDelete{
                            DispatchQueue.main.async {
                               
                                arr?.remove(at: indexPath.row)
                                dict[firstKey] = arr
                                self.arrOfFilterDict[indexPath.section] = dict
                                self.isAdded = true
                                self.isChanged = false
                                self.getJobListFromDB()
                                self.jobTabVC!.navigationController?.popViewController(animated: true)
                                self.jobTabVC = nil
                            }
                        }
                    }
                }
            }
         
            
        }else if segue.identifier == "AddJob" {
            let addJobVC = segue.destination as! AddJobVC
            addJobVC.callbackForJobVC = {(isBack : Bool) -> Void in
                self.isAdded = true
                self.isChanged = false
                self.getJobListFromDB()
            }
        }else if segue.identifier == "MultipleFilterVC"{
            let multipleFilterVC = segue.destination as! MultipleFilterVC
            multipleFilterVC.callbackOfMultipleFilter = {(jobCode : [[String : String]]) -> Void in
                
                DispatchQueue.main.async {
                    
                    if self.filterjobsArray.count > 0 {
                        self.filterjobsArray.removeAll()
                        self.collectionVw.reloadData()
                    }
                    
                    
                    //Remove all Tags via name of tag
                    for dict in self.multiFilterArray {
                        if (dict["Status"] != nil) {
                            self.filterTagsView.deleteTag(dict["Status"]!)
                        }else{
                            self.filterTagsView.deleteTag(dict["Tag"]!)
                        }
                    }
                    
                    //replace array with new filter elements
                    self.multiFilterArray = jobCode
                    
                    //Fire new filter query
                    self.getQuryFormMultipleFilter(isDelete: false)
                }
                //Remove serch View
                if(self.isOpenSerchView){
                    self.searchVw_H.constant = 0
                    //self.btnDropDown.isHidden = false
                    
                    UIView.animate(withDuration: 0.3){
                        self.view.layoutIfNeeded()
                    }
                    
                    self.txtSearchfield.text = ""
                    self.isOpenSerchView = false
                }
                
                self.collectionVw_H.constant = 55.0
                //self.heightOfArrowBtn.constant = 0.0
                self.filterView.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    
    
    func getQuryFormMultipleFilter(isDelete : Bool)-> Void{
        var query  = ""
        var str = ""
        var  prty = ""
        
        var tagFilterArray : [String] = []
        
        
        //Get query only for JOB STATUS and JOB PRIORITY
        for dict in multiFilterArray {
            
            
            //if STATUS key is not nil that means status and priority available otherwise TAG in else condition
            if (dict["Status"] != nil) {
                tagAdd(tagString: dict["Status"]!)
                
                //Replace condition for ACCEPTED and ON-HOLD
                var changeStatus = ""
          
                if dict["String"]! == "status = 8"{
                    changeStatus = "status = \(12)"
                }
           
                if dict["String"]!.hasPrefix("status =") { // true
                    if str != ""{
                        if changeStatus != "" {
                            str = "\(changeStatus) OR  \(str)"
                        }else{
                            str = "\(dict["String"]!) OR  \(str)"
                        }
                    }else{
                        if changeStatus != "" {
                            str = changeStatus
                        }else{
                            str = dict["String"]!
                        }
                    }
                }else{
                    if prty != ""{
                        if changeStatus != "" {
                            prty = "\(changeStatus) OR  \(prty)"
                        }else{
                            prty = "\(dict["String"]!) OR  \(prty)"
                        }
                    }else{
                        if changeStatus != "" {
                            prty = changeStatus
                        }else{
                            prty = dict["String"]!
                        }
                    }
                }
                
            }else{
                tagAdd(tagString: dict["Tag"]!)
                tagFilterArray.append(dict["Tag"]!)
            }
        }
        
        
        //make query with Combination of Status and Priority
        if prty != "" {
            if str == ""{
                str = prty
            }else{
                str = "(\(str)) AND (\(prty))"
            }
        }
        
        
        //Get final query
        query = str
        
        self.arrOFUserData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query == "" ? nil : query) as! [UserJobList]
        
        
        if tagFilterArray.count > 0 {
            self.arrOFUserData = self.arrOFUserData.filter { (job : UserJobList) -> Bool in
                let tagData = job.tagData as! [Any]
                
                for tagString in tagFilterArray {
                    if tagData.contains(where: { ($0 as! [String:String])["tnm"]! == tagString }) {
                        return true
                    }
                }
                return false
            }
        }
       
        if self.arrOFUserData.count != 0 {
            //            arrOFUserData = arrOFUserData.sorted(by: {
            //                $0.updateDate?.compare($1.updateDate!) == .orderedDescending
            //            })
            self.createSection()
        }else{
            DispatchQueue.main.async {
                if(self.arrOfFilterDict.count != 0){
                    self.arrOFData.removeAll()
                    self.filterDict.removeAll()
                    self.arrOfFilterDict.removeAll()
                }
                self.tableView.reloadData()
            }
        }
       
        DispatchQueue.main.async {
            self.lblNoJob.isHidden = self.arrOFUserData.count > 0 ? true : false
            // self.btnSort.isHidden = self.arrOFUserData.count > 0 ? false : true
        }
        
    }
   
    func tagAdd(tagString : String) -> Void {
        
        
        self.filterTagsView.addTag(tagString, withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: true)
        self.filterTagsView.deleteBlock = {(tagText : String ,idx : Int) -> Void in
            DispatchQueue.main.async {
                
                for dict in self.multiFilterArray {
                    if (dict["Status"] != nil) {
                        self.filterTagsView.deleteTag(dict["Status"]!)
                    }else{
                        self.filterTagsView.deleteTag(dict["Tag"]!)
                    }
                }
                
                self.multiFilterArray.remove(at: idx)
                
                if self.multiFilterArray.count == 0 {
                    self.btnResetForFilter((Any).self)
                }else{
                    self.getQuryFormMultipleFilter(isDelete: true)
                }
            }
        }
    }
 
    //===============================
    // MARK:- CollectionView methods
    //===============================
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return filterTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
         let cell = collectionVw.dequeueReusableCell(withReuseIdentifier: "jobCollCell", for: indexPath) as! jobCollectionCell
        
        let statusType : Int = filterTitleArray[indexPath.row].rawValue
        let statusData = taskStatusForDispatch(taskType: filterTitleArray[indexPath.row])
        cell.lblTask.text = statusData.0.replacingOccurrences(of: " Task", with: "")
        
        
        if filterjobsArray.firstIndex(of:statusType) != nil {
            cell.greenView.backgroundColor = .init(red: 40.0/255.0, green: 166.0/255.0, blue: 70.0/255.0, alpha: 1.0)
            cell.lblTask.textColor = .white
            cell.imgCrossWidth.constant = 13.0
            cell.imgVw.image = statusData.2
        }else{
            cell.greenView.backgroundColor = UIColor.white
            cell.lblTask.textColor = .init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            cell.imgCrossWidth.constant = 0.0
            cell.imgVw.image = statusData.1
        }
        
        
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth / 3
        return CGSize(width: widthPerItem, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let cell : jobCollectionCell = collectionView.cellForItem(at: indexPath) as! jobCollectionCell
        
        let statusType : Int = filterTitleArray[indexPath.row].rawValue
        if let index = filterjobsArray.firstIndex(of:statusType) {
            
            filterjobsArray.remove(at: index)
        }else{
            
            filterjobsArray.append(statusType)
        }
        
        DispatchQueue.main.async {
            self.collectionVw.reloadData()
        }
        filterDataFromDB()
    }
    
    //==================================
    // MARK:- Other methods
    //==================================
    
    func filterDataFromDB() -> Void {
        let query = getQuery(arry: filterjobsArray)
        showDataOnTableView(query: query == "" ? nil : query)
    }
 
    func getQuery(arry : [Int]) -> String {
           var query  = ""
           for status in filterjobsArray {
          
               var str = "status = '\(status)'"
               if status == taskStatusType.Accepted.rawValue {
                   str = "status = '2'"
               }
               
               if status == 12 {
                   str = "status = '12'"
               }
               
               if query == "" {
                   query = str
               } else {
                   query = "\(query) OR \(str)"
               }
           }
           return query
       }
    
    @IBAction func filterBtn(_ sender: Any) {
        
        let alert =   UIAlertController(title: "Coming Soon", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnResetForFilter(_ sender: Any) {
     
        self.collectionVw_H.constant = 50.0
        self.filterView.isHidden = true
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
      
        //Remove all Tags via name of tag
        for dict in self.multiFilterArray {
            if (dict["Status"] != nil) {
                self.filterTagsView.deleteTag(dict["Status"]!)
            }else{
                self.filterTagsView.deleteTag(dict["Tag"]!)
            }
        }
        
        self.multiFilterArray.removeAll()
        showDataOnTableView( query: nil)
      
    }
    
    @IBAction func btnPressedSort(_ sender: UIButton) {
        // self.sortView.isHidden = true
        sortBtnTag = sender.tag
        changeSortButton(tag: sortBtnTag)
    }
    
    func changeSortButton(tag : Int) -> Void {
        var title = ""
        var colorChangeText = ""
        
        if tag == 0 { // Sort-by Date
            radioButtonDate.image = UIImage(named: "radio-selected")
            radioButtonRecent.image = UIImage(named: "radio_unselected")
            btnSort.setImage(UIImage(named: "DateSort"), for: .normal)
            title = LanguageKey.sort_by_date
            colorChangeText = LanguageKey.date
            sorting = SortType.SortByRecent
            
        }else{ // Sort-by Recent
            radioButtonDate.image = UIImage(named: "radio_unselected")
            radioButtonRecent.image = UIImage(named: "radio-selected")
            btnSort.setImage(UIImage(named: "RecentSort"), for: .normal)
            // title = "Sort by Recent"
            title = LanguageKey.sort_by_recent
            colorChangeText =  LanguageKey.recent
            sorting = SortType.SortByDate
        }
        
        changeColorOfSortButton(fullText: title , willModifyText: colorChangeText)
        createSection()
    }
    
    
    func changeColorOfSortButton(fullText:String, willModifyText:String) -> Void {
        let range = (fullText as NSString).range(of: willModifyText)
        let range1 = (fullText as NSString).range(of:LanguageKey.sort_by)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 38.0/255.0, green: 151.0/255.0, blue: 159.0/255.0, alpha: 1.0), range: range)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: range1)
        attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.double.rawValue, range: range)
        btnSort.setAttributedTitle(attribute, for: .normal)
    }
    
    
    @IBAction func tapOnSelectedSortButton(_ sender: UIButton) {
        
        sender.tag = (sender.tag == 0) ? 1 : 0
        changeSortButton(tag: sender.tag)
    }
    
    //=====================================
    // MARK:- SECTIONS for JOBLIST
    //=====================================
    
    func createSection(){
        
        DispatchQueue.main.async{
            if(self.arrOfFilterDict.count != 0){
                self.arrOFData.removeAll()
                self.filterDict.removeAll()
                self.arrOfFilterDict.removeAll()
            }
            var currentDate = ""
            self.arrOFUserData = self.arrOFUserData.sorted(by: { $0.schdlStart ?? "" > $1.schdlStart ?? "" })
            var Tommarow = [[String : [UserJobList]]]()
            var arrToday = [[String : [UserJobList]]]()
            var arrUnsehdule = [[String : [UserJobList]]]()
            var arrOtherDate = [[String : [UserJobList]]]()
            let timestamp = NSDate().timeIntervalSince1970
            let myTimeInterval1 = TimeInterval(timestamp)
            let strTodayDate = dayDifference(unixTimestamp: String(myTimeInterval1)) // today date
            for objOfUserData in self.arrOFUserData{
                let strDate = dayDifference(unixTimestamp: (((self.sorting == SortType.SortByDate) ? objOfUserData.schdlStart : objOfUserData.schdlStart)!))

                if strDate == "" {
                    if arrUnsehdule.count == 0 {
                        self.arrOFData.removeAll()
                        self.filterDict.removeAll()
                        self.arrOFData.append(objOfUserData)
                        self.filterDict[strDate] = self.arrOFData
                        arrUnsehdule.append(self.filterDict)
                    }else {
                        var dictObj = arrUnsehdule.last
                        dictObj![strDate]?.append(objOfUserData)
                        arrUnsehdule[arrUnsehdule.count-1] = dictObj!
                    }
                }else {
                    
                    if currentDate == strDate {
                        var dictObj = arrOtherDate.last
                        dictObj![strDate]?.append(objOfUserData)
                        arrOtherDate[arrOtherDate.count-1] = dictObj!
                    }else{
                        currentDate = strDate
                        self.arrOFData.removeAll()
                        self.filterDict.removeAll()
                        self.arrOFData.append(objOfUserData)
                        self.filterDict[strDate] = self.arrOFData
                        arrOtherDate.append(self.filterDict)
                    }
                    
                }
            }
            if arrToday.count != 0 {
               // self.arrOfFilterDict.append(contentsOf: arrToday)
            }
            if arrUnsehdule.count != 0 {
                self.arrOfFilterDict.append(contentsOf: arrUnsehdule)
            }
            if arrOtherDate.count != 0 {
                self.arrOfFilterDict.append(contentsOf: arrOtherDate)
            }
        }
        DispatchQueue.main.async {
            self.addIndexpathForInProgressJob()
            self.addIndexpathForTodayTask()
            self.tableView.reloadData()
          
        }
    }
 
    func addIndexpathForInProgressJob()  {
        var inProgressRow : Int?
        let sectionIndex = self.arrOfFilterDict.firstIndex { (jobSection) -> Bool in
            let firstKey = Array(jobSection.keys)[0] // or .first
            let arr = jobSection[firstKey]
            
            let inProgressJobIndex =  arr!.firstIndex(where: {$0.status == String(7)})
            if let index = inProgressJobIndex {
                inProgressRow = index
                return true
            }
            return false
        }
        
        if let section = sectionIndex, let row = inProgressRow {
            inprogressIndexpath = IndexPath(row: row, section: section)
        }else{
            inprogressIndexpath = nil
        }
    }
    
    func addIndexpathForTodayTask()  {
        let sectionIndex = self.arrOfFilterDict.firstIndex { (jobSection) -> Bool in
            let firstKey = Array(jobSection.keys)[0]
            if firstKey.contains("Today") {
                return true
            }
            return false
        }
        
        if let section =  sectionIndex {
            todaySectionIndexpath = IndexPath(row: 0, section: section)
        }else{
            todaySectionIndexpath = nil
        }
    }
   
    @IBAction func btnInProgress(_ sender: Any) {
        if let indexpath = inprogressIndexpath {
            self.tableView.scrollToRow(at: indexpath, at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    
    
    @IBAction func btnTodayTask(_ sender: Any) {
        
        if let indexpath = todaySectionIndexpath  {
            self.tableView.scrollToRow(at: indexpath, at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    
    
    @IBAction func btnBottomRefresh(_ sender: Any) {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            return
        }
        
        showLoader()
        getJobListService()
    }
    
    
    @IBAction func collectionEnableBtnTapped(_ sender: UIButton) {
        if self.collectionVw_H.constant == 0.0 {
            self.collectionVw_H.constant = 50.0
            
            UIView.animate(withDuration: 0.5){
                self.view.layoutIfNeeded()
                sender.setImage(UIImage(named:"top_pannel_arrow"), for: .normal)
            }
        }else{
            self.collectionVw_H.constant = 0.0
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                sender.setImage(UIImage(named:"Down_pannel_arrow"), for: .normal)
            }
        }
    }
    
    @objc func removeJobs(_ notification: NSNotification){
        if let dict = notification.userInfo!["data"] as? [String : Any]{
           
            let query = "jobId = '\(dict["jobid"]!)'"
            let objOfUserJobList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
            
            if(objOfUserJobList.count > 0){
                let strDate : String = dayDifference(unixTimestamp: (objOfUserJobList[0].updateDate != nil ? objOfUserJobList[0].updateDate : objOfUserJobList[0].createDate)!)
                
                if let index = (self.arrOfFilterDict.firstIndex { (dict) -> Bool in    dict[strDate] != nil }){
                    var dictObj = self.arrOfFilterDict[index]
                    
                    if let idx = dictObj[strDate]?.firstIndex(of: objOfUserJobList[0]){
                        dictObj[strDate]?.remove(at: idx)
                        self.arrOfFilterDict[index] = dictObj
                    }
                }
                
                DatabaseClass.shared.deleteEntity(object: (objOfUserJobList[0]) , callback: { (isDelete : Bool) in
                  
                })
                
                self.isAdded = true
                self.isChanged =  false
                self.getJobListFromDB()
            }
        }
    }
    
    
    @objc func popToAuditVC(_ notification: NSNotification){
        let vc = UIStoryboard(name: "MainAudit", bundle: nil).instantiateViewController(withIdentifier: "audit") as! AuditVC;
        let navCon = NavClientController(rootViewController: vc)
        navCon.modalPresentationStyle = .fullScreen
        vc.isNotificationClick = true
        self.present(navCon, animated: true, completion: nil)
    }
    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "dd-MM-yyyy HH:mm"

        let time12 = df.string(from: date!)
       
        return time12
    }

    
    //=====================================
    // MARK:- JOB LIST Service methods  -
    //=====================================
    
    func getJobListService(){
        
        if !isHaveNetowork() {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            return
        }
        let param = Params()
        
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getJobList) as? String
        
        param.usrId = getUserDetails()?.usrId
        param.limit = "120"
        param.index = "\(count)"
        param.search = ""
        if self.isUserfirstLogin {
            showLoader()
            param.dateTime = ""
        }else{
            param.dateTime = lastRequestTime ?? ""
        }
        
        //  print("API ----------------------------------------------------------------------- getJobListService")
        
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
                  
                        if decodedData.count ?? "" > "0" {
                            if let arrayData = decodedData.data, arrayData.count != 0 {
                                let ArrNotiLable = arrayData[0].label ?? ""
                                UserDefaults.standard.set(ArrNotiLable, forKey: "ArrNotiLable")
                            }
                        }
                        
                        if let arryCount = decodedData.data{
                            if arryCount.count > 0{
                                self.count += (decodedData.data?.count)!
                                if !self.isUserfirstLogin {
                                    killLoader()
                                    self.saveUserJobsInDataBase(data: decodedData.data!)
                                    
                                    UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getJobList)
                              
                                    if self.multiFilterArray.count > 0 {
                                        DispatchQueue.main.async {
                                            
                                            for dict in self.multiFilterArray {
                                                if (dict["Status"] != nil) {
                                                    self.filterTagsView.deleteTag(dict["Status"]!)
                                                }else{
                                                    self.filterTagsView.deleteTag(dict["Tag"]!)
                                                }
                                            }
                                        
                                            self.getQuryFormMultipleFilter(isDelete: false)
                                        }
                                    }else if  self.filterjobsArray.count == 0{
                                        
                                        DispatchQueue.main.async {
                                            if self.txtSearchfield.text!.count > 0 {
                                                self.tableView.reloadData()
                                            }else{
                                                self.showDataOnTableView(query: nil)
                                            }
                                        }
                                    }else{
                                        self.filterDataFromDB()
                                    }
                                    
                                }else{
                                    APP_Delegate.apiCallFirstTime = true
                                    
                                    self.DemosaveUserJobsInDataBase(data: decodedData.data!)
                                    
                                }
                                
                            }else{
                                killLoader()
                                if self.arrOFUserData.count == 0{
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }else{
                            if self.arrOFUserData.count == 0{
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    self.lblNoJob.isHidden = self.arrOFUserData.count > 0 ? true : false
                                }
                            }
                        }
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!)! > self.count) && (Int(decodedData.count!)! != self.count){
                            self.getJobListService()
                        }else{
                            
                            if self.isUserfirstLogin {
                                
                                UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getJobList)
                                self.changePercentage(apiNumber:7,title: LanguageKey.completed)
                                
                                if  self.filterjobsArray.count == 0{
                                    UserDefaults.standard.set("true", forKey: "isSesondlogin")
                                    
                                }
                            }
                            
                            self.saveAllGetDataInDatabase(callback: { isSuccess in
                                if APP_Delegate.apiCallFirstTime {
                                    APP_Delegate.apiCallFirstTime = false
                                    self.groupUserListForChat()
                                    self.getAllCompanySettings()
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
    
    func DemosaveUserJobsInDataBase( data : [jobListData]) -> Void {
        
        
                for job in data{
                    let query = "jobId = '\(job.jobId!)'"
                    let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
                    if isExist.count > 0 {
                        let existingJob = isExist[0]
                        //if Job status Cancel, Reject, Closed so this job is delete from Database
        
                        if(job.isdelete == "0") {
                           // ChatManager.shared.removeJobForChat(jobId: existingJob.jobId!)
                            DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                        }else if (Int(job.status!) == 4) ||
                            (Int(job.status!) == 3) ||
                            (Int(job.status!) == 10)
                        {
                            //ChatManager.shared.removeJobForChat(jobId: existingJob.jobId!)
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
        
                                let query =  "jobId = '\(job.jobId!)'"
                                let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
        
                                if isExistJob.count > 0 {
                                    let existing = isExistJob[0]
                                    //DatabaseClass.shared.deleteEntity(object: existing, callback: { (_) in})
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
    
    
    func getJobListFromDB() -> Void {
        if self.isUserfirstLogin {
            showLoader()
        }
        if isAdded {
            
            var Sesondlogin =   UserDefaults.standard.value(forKey: "isSesondlogin") as? String ?? ""
            if  Sesondlogin == "true" {
                if self.isUserfirstLogin {
                    showLoader()
                }
                self.timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(redirectJobcll), userInfo: nil, repeats: true)
                UserDefaults.standard.set("false", forKey: "isSesondlogin")
              
            }else{
                UserDefaults.standard.set("false", forKey: "isSesondlogin")
                
                showDataOnTableView(query: nil)
            }
        }
        
        if isChanged {
            tableView.reloadData()
            getJobListService()
        }
        //  showLoader()
        isChanged = true
        isAdded = false
        
    }
    @objc func redirectJobcll (){
        showDataOnTableView(query: nil)
        killLoader()
    }
    
    func showDataOnTableView(query: String?) -> Void {
        self.arrOFUserData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
        
        if self.arrOFUserData.count != 0 {
            self.createSection ()
        } else {
            DispatchQueue.main.async {
                if(self.arrOfFilterDict.count != 0){
                    self.arrOFData.removeAll()
                    self.filterDict.removeAll()
                    self.arrOfFilterDict.removeAll()
                }
                self.tableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            self.lblNoJob.isHidden = self.arrOFUserData.count > 0 ? true : false
        }
    }
    
    
    //=====================================
    // MARK:- CLIENT LIST  Service
    //=====================================
    
    func getClientSink(){
    
        if isHaveNetowork() {
            showLoader()
        }
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientSink) as? String
        
        if lastRequestTime != nil{
            self.changePercentage(apiNumber: 3, title: LanguageKey.sites_screen_title)
            self.count = 0
            self.getClientSiteSink()
            return
       
        }
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "\(count)"
        param.dateTime = ""

      //  print("API ----------------------------------------------------------------------- getClientSink")
        serverCommunicator(url: Service.getClientSink, param: param.toDictionary) { (response, success) in
            
            if(success){
               // killLoader()
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ClientResponse.self, from: response as! Data) {
                    if decodedData.success == true{
          
                        if decodedData.data.count > 0 {
                            self.saveClintInDataBase(data: decodedData.data)
                            self.count += decodedData.data.count
                        }

                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!)! > self.count) && (Int(decodedData.count!)! != self.count){
                            self.getClientSink()
                        }else{
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSink)
                            self.changePercentage(apiNumber: 3, title: LanguageKey.sites_screen_title)
                            self.saveAllGetDataInDatabase(callback: { isSucsess in
                            
                                self.getClientSiteSink()
                            })
                        }
                       
                    }else{
                       
                        //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        if cancel {
                            showLoader()
                            self.getClientSink()
                        }
                    })
                }
            }else{
                
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getClientSink()
                    }
                })
            }
        }
    }
    
    
    func saveClintInDataBase( data : [ClientListData]) -> Void {
    
        for jobs in data{
            let query = "cltId = '\(String(describing: jobs.cltId ?? ""))'"
            if let jodDicData = jobs.toDictionary {
                if let ClientList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as? [ClientList], ClientList.count > 0 {
                    if(jobs.isdelete == "0"){
                        let existingJob = ClientList[0]
                        DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})

                    }else{
                        let existingJob = ClientList[0]
                        existingJob.setValuesForKeys(jobs.toDictionary!)
                       
                    }
                } else {
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientList")
                    userJobs?.setValuesForKeys(jodDicData)
                }

                DatabaseClass.shared.saveEntity(callback: { _ in })
            }
        }
    }
    
    //=====================================
    // MARK:- SITE LIST Service
    //=====================================
    
    func getClientSiteSink(){
        
        if isHaveNetowork() {
            showLoader()
        }
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientSiteSink) as? String
        
        
        if lastRequestTime != nil{
            self.changePercentage(apiNumber: 4, title: LanguageKey.sites_screen_title)
            self.count = 0
            self.getClientContactSink()
            return
        }
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "\(count)"
        param.dateTime =  ""
 
      //  print("API ----------------------------------------------------------------------- getClientSiteSink")
        serverCommunicator(url: Service.getClientSiteSink, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(SiteVCResp.self, from: response as! Data) {
                    if decodedData.success == true{
                     
                     
                        if decodedData.data.count > 0 {
                          
                            self.saveSiteInDataBase(data: decodedData.data)
                            self.count += decodedData.data.count
                        }
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!)! > self.count) && (Int(decodedData.count!)! != self.count){
                           
                            self.getClientSiteSink()
                         
                        }else{
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSiteSink)
                            self.changePercentage(apiNumber: 4, title: LanguageKey.contacts_screen_title)
                            self.saveAllGetDataInDatabase(callback: { isSucsess in
                                self.getClientContactSink()
                            })
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        if cancel {
                            showLoader()
                            self.getClientSiteSink()
                        }
                    })
                }
            }else{
                    ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getClientSiteSink()
                    }
                })
            }
        }
     
    }
    
    
    func saveSiteInDataBase( data : [SiteVCRespDetails] ) -> Void {
      
        
        for jobs in data{
            if(jobs.isdelete != "0"){
                let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
                //DatabaseClass.shared.saveEntity()
            }
        }
    }
    
    //=====================================
    // MARK:- CONTACT LIST Service
    //=====================================
    
    func getClientContactSink(){
        if isHaveNetowork() {
            showLoader()
        }
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientContactSink) as? String
        
        if lastRequestTime != nil{
            self.changePercentage(apiNumber: 5, title: LanguageKey.tags)
            self.count = 0
            self.getTagListService()
            return
        }
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "\(count)"
        param.dateTime = ""
      //  print("API ----------------------------------------------------------------------- getClientContactSink")
        serverCommunicator(url: Service.getClientContactSink, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ContactResps.self, from: response as! Data) {
                    if decodedData.success == true{

                        if decodedData.data.count > 0 {
                        
                             self.saveUserContactInDataBase(data: decodedData.data)
                            self.count +=  decodedData.data.count
                        }
                        
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!)! > self.count) && (Int(decodedData.count!)! != self.count){
                  
                            self.getClientContactSink()
                            
                        }else{
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientContactSink)
                            self.changePercentage(apiNumber: 5, title: LanguageKey.tags)
                            self.saveAllGetDataInDatabase(callback: { isSucsess in
                                self.getTagListService()
                            })
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        if cancel {
                            showLoader()
                            self.getClientContactSink()
                        }
                    })
                }
            }else{

               
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getClientContactSink()
                    }
                })
            }
        }
        
    }
    
    
    func saveUserContactInDataBase( data : [ContactRespsDetails]) -> Void {

                for jobs in data{
                        if(jobs.isdelete != "0"){
                            let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientContactList")
                            userJobs?.setValuesForKeys(jobs.toDictionary!)
                           // DatabaseClass.shared.saveEntity()
                        }
                   }
    }
    
    
    //=====================================
    // MARK:- JOB-TITLE LIST Service
    //=====================================
    
    func getJobTittle(){
        
                if isHaveNetowork() {
                    showLoader()
                }
        
        
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getJobTitleList) as? String
        
        if lastRequestTime != nil{
            self.changePercentage(apiNumber: 1, title: LanguageKey.fieldworker)
            self.count = 0
            self.getFieldWorkerList()
            return
        }
        
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "\(count)"
        param.search = ""
        param.dateTime = lastRequestTime ?? ""
       // print("API ----------------------------------------------------------------------- getJobTitleList")
        serverCommunicator(url: Service.getJobTitleList, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ViewControllerResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                     
                        if decodedData.data?.count != 0 {
                            
                            self.saveUserJobsTittleNmInDataBase(data: decodedData.data!)
                            self.count += (decodedData.data?.count)!
                        }
                        
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                        
                            self.getJobTittle()
                        }else{
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getJobTitleList)
                            self.changePercentage(apiNumber: 1, title: LanguageKey.fieldworker)
                            self.saveAllGetDataInDatabase(callback: { isSucsess in
                                self.getFieldWorkerList()
                            })
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        if cancel {
                            showLoader()
                            self.getJobTittle()
                        }
                    })
                }
            } else{

                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getJobTittle()
                    }
                })
                
            }
        }
        
    }
    
    
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
    
    //=====================================
    // MARK:- FIELDWORKERS LIST Service
    //=====================================
    
    func getFieldWorkerList(){
        
        if isHaveNetowork() {
            showLoader()
        }
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getFieldWorkerList) as? String
        
        if lastRequestTime != nil{
            //Request time will be update when data comes otherwise time won't be update
            self.changePercentage(apiNumber: 2, title: LanguageKey.clients)
            self.count = 0
            self.getClientSink()
            
            
            return
        }
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "\(count)"
        param.search = ""
        param.dateTime =  ""
       // print("API ----------------------------------------------------------------------- getFieldWorkerList")
        serverCommunicator(url: Service.getFieldWorkerList, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(FldWorkerData.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                   
                        if decodedData.data?.count != 0 {
                            self.saveUserFieldWorkerNmInDataBase(data: decodedData.data!)
                            self.count += (decodedData.data?.count)!
                        }
                        
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                      
                            self.getFieldWorkerList()
                        }else{
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getFieldWorkerList)
                            self.changePercentage(apiNumber: 2, title: LanguageKey.clients)
                            self.saveAllGetDataInDatabase(callback: { isSucsess in
                                self.getClientSink()
                            })
                        }
                       
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        if cancel {
                            showLoader()
                            self.getFieldWorkerList()
                        }
                    })
                }
            }else{
                

                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getFieldWorkerList()
                    }
                })
            }
        }
        
    }
    
    
    func saveUserFieldWorkerNmInDataBase( data : [FldWorkerDetailsList]) -> Void {
        
        
        for jobs in data{

            let query = "fnm = '\(String(describing: jobs.fnm ?? ""))'"
            if query != "fnm = \'ba\'su\'" {
                let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: query) as! [FieldWorkerDetails]
                if isExist.count > 0 {
                    let existingJob = isExist[0]
                    existingJob.setValuesForKeys(jobs.toDictionary!)
                    //  DatabaseClass.shared.saveEntity()
                }else{
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "FieldWorkerDetails")
                    userJobs?.setValuesForKeys(jobs.toDictionary!)
                    // DatabaseClass.shared.saveEntity()
                }
            }
        }
        
    }
    
    func saveAllGetDataInDatabase(callback:(Bool)  -> Void) -> Void {
        self.count = 0
        DatabaseClass.shared.saveEntity(callback: callback)
    }
    
    
    //=====================================
    // MARK:- get All users
    //=====================================
    
    func groupUserListForChat() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            //  hideloader()
            return
        }
        
        
        
        showLoader()
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.groupUserListForChat) as? String
        let param = Params()
       // param.usrId = getUserDetails()!.usrId
        param.limit = ContentLimit
        param.index = "\(count)"
        param.search = ""
        param.dateTime = lastRequestTime ?? "" //  currentDateTime24HrsFormate()///
        if self.isUserfirstLogin {
            param.isIncludingTeam = "1"
        }
       // print("API ----------------------------------------------------------------------- groupUserListForChat")
        serverCommunicator(url: Service.groupUserListForChat, param: param.toDictionary) { (response, success) in
            // killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AdminChatRes.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        // DispatchQueue.main.async{
                        if decodedData.data!.count > 0 {
                            self.saveUsersInDataBase(data: decodedData.data!)
                            
                            self.count += (decodedData.data?.count)!
                        }
                        
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                            self.groupUserListForChat()
                        }else{
                            
                            if self.isUserfirstLogin {
                                self.changePercentage(apiNumber: 8, title: LanguageKey.title_chat)
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
                        self.groupUserListForChat2()
                       // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
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
    
    func groupUserListForChat2() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            //  hideloader()
            return
        }
    
        showLoader()
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.groupUserListForChat) as? String
        let param = Params()

        param.limit = ContentLimit
        param.index = "\(count)"
        param.search = ""
        param.dateTime = lastRequestTime ?? "" //  currentDateTime24HrsFormate()///
    
      //  print("API ----------------------------------------------------------------------- groupUserListForChat")
        serverCommunicator(url: Service.groupUserListForChat, param: param.toDictionary) { (response, success) in
            // killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AdminChatRes.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                     
                        if decodedData.data!.count > 0 {
                            self.saveUsersInDataBase(data: decodedData.data!)
                           
                            self.count += (decodedData.data?.count)!
                        }
                        
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                            self.groupUserListForChat()
                        }else{
                            
                            if self.isUserfirstLogin {
                                self.changePercentage(apiNumber: 8, title: LanguageKey.title_chat)
                                self.isUserfirstLogin = false
                                UserDefaults.standard.set(false, forKey: "ShowProgressBarOnce")
                            }
                            
                          
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.groupUserListForChat)
                            
                            self.saveAllGetDataInDatabase(callback: { isSucsess in
                                self.getAllCompanySettings()
                            })
                        }
                        
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
                        
                        self.processForCreateNode() // Intailise firebase
                        
                        if let round = getDefaultSettings()?.numAfterDecimal{ //This is round off digit for invoice
                            roundOff = round
                        }
                        let expireStatusCheck = decodedData.data!
                      
                        
                        let existingDefLanguage = getDefaultLanugage()
                        if (decodedData.data?.language?.isLock == "1") || (existingDefLanguage == nil) || (existingDefLanguage?.fileName != decodedData.data?.language!.fileName) || (existingDefLanguage?.version != decodedData.data?.language!.version){
                            
                            var langName = ""
                            
                            if let language  = decodedData.data!.languageList?.filter({$0.fileName == decodedData.data!.language?.fileName!}) {
                                langName = (language as [languageDetails])[0].nativeName!
                            }
                            
                            LanguageManager.shared.setLanguage(filename: (decodedData.data?.language!.fileName)!, filePath: (decodedData.data?.language!.filePath)!, languageName: langName, version: (decodedData.data?.language!.version)!, alert: false, callBack: { (success) in
                                if success {
                                   
                                    saveDefaultLanugage(lanugage: (decodedData.data?.language)!)
                                    self.setLocalization()
                                 
                                }
                            })
                        }
                        
                        
                        let appVersion : Float = Float(String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!))!
                        if let ver = decodedData.data!.forceupdate_version {
                            if let forceVersion = Float(ver){
                                if forceVersion > appVersion{
                                    killLoader()
                                    navigateToLoginPage()
                                    
                                    self.showUpdateAlert(isCancel: false)
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
                                self.btnAddJob.isHidden = false
                            }else{
                                self.btnAddJob.isHidden = true
                            }
                        }
                        
                        
                        if !APP_Delegate.isOnlyLogin { // when user autologin then call this AutoLogin activity url otherwise not called
                            ActivityLog(module:Modules.login.rawValue , message: ActivityMessages.autoLogin)
                        }else{
                            APP_Delegate.isOnlyLogin = false
                        }
                        
                        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.joblist)
                        
                    }else{
                        self.processForCreateNode() // Intailise firebase
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
    
    
    
    
    
    
    func startLocationGPS(settings : DefaultSettings , endTime : Int) -> Void {
        LocationManager.shared.gpsConfiguration(gpsStopTimeInterval: endTime)
        
        if let lat = settings.lat, let lng = settings.lng {
            if settings.lat != "" {
                LocationManager.shared.oldLocation = CLLocation(latitude: Double(lat)!, longitude: Double(lng)!)
            }else{
                LocationManager.shared.oldLocation = CLLocation(latitude: 0.0, longitude: 0.0)
            }
        }else {
            LocationManager.shared.oldLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        }
        
        LocationManager.shared.setNotificationCentreForlocation()
        LocationManager.shared.startTracking()
    }
    
    
    
    
    
    func showUpdateAlert(isCancel :  Bool) -> Void {
        
        if isCancel {
            ShowAlert(title: LanguageKey.new_version , message: AlertMessage.checkVersion, controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: LanguageKey.update as NSString, style: .alert) { (cancel, update) in
                if update {
                    if let link = URL(string: Constants.APPSTORE_URL) {
                        UIApplication.shared.open(link)
                    }
                }
            }
        }else{
            ShowAlert(title: LanguageKey.new_version, message: AlertMessage.checkVersion, controller: windowController, cancelButton: LanguageKey.update as NSString, okButton: nil, style: .alert) { (update, nil) in
                if update {
                    if let link = URL(string: Constants.APPSTORE_URL) {
                        UIApplication.shared.open(link)
                    }
                }
            }
        }
    }
    
    
    //=====================================
    // MARK:- get All Added Tags
    //=====================================
    
    func getTagListService(){
        
        if isHaveNetowork() {
            showLoader()
        }
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.jobTagList) as? String
        
        if lastRequestTime != nil{
            self.changePercentage(apiNumber: 6, title: LanguageKey.jobs)
            self.count = 0
            self.getJobListService()
            return
        }
        
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "0"
        param.search = ""
        param.dateTime = ""
        
     //   print("API ----------------------------------------------------------------------- jobTagList")
        serverCommunicator(url: Service.jobTagList, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(tagListResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                     
                        if decodedData.data?.count != 0 {
                            self.saveTagsNmInDataBase(data: decodedData.data!)
                            self.count += (decodedData.data?.count)!
                        }
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                  
                            self.getTagListService()
                        }else{
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.jobTagList)
                            self.changePercentage(apiNumber: 6, title: LanguageKey.jobs)
                            self.saveAllGetDataInDatabase(callback: { isSucsess in
                                self.getJobListService()
                            })
                        }
                       
                    }else{
                        //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        if cancel {
                            showLoader()
                            self.getTagListService()
                        }
                    })
                }
            }else{

               // Thread.callStackSymbols.toString ?? ""
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getTagListService()
                    }
                })
            }
        }
        
    }
    
    func saveTagsNmInDataBase( data : [tagElements]) -> Void {

        for jobs in data{
            let userJobs = DatabaseClass.shared.createEntity(entityName: "TagsList")
            userJobs?.setValuesForKeys(jobs.toDictionary!)
            //DatabaseClass.shared.saveEntity()
        }
    }
    
    
    
    //=========================
    // MARK:- Firebase methods
    //=========================
    
    func processForCreateNode() -> Void {
        if getDefaultSettings()?.staticJobId != nil{
            signinUserOnFirebase()
        }else{
            killLoader()
        }
    }
    
    
    
    func signinUserOnFirebase() -> Void {
        if ChatManager.shared.alreadyListnerCreated ==  false {
            if ChatManager.shared.isFirebaseAuthenticate() == true { // if user already exist so user can signin directly
                self.initialiseSomeFeatureforFirebase()
            }else{
              
                let userName = currentRegion()! + "_" + getUserDetails()!.usrId! + Constants.firebaseEmailSuffix
                ChatManager.shared.createOrSignInUserOnFirebase(email: userName, password: Constants.firebaseUserPassword, callback: {(isAuthenticate : Bool) in
                    if isAuthenticate {
                        self.initialiseSomeFeatureforFirebase()
                    }else{
                        killLoader()
                    }
                })
            }
        }else{
            killLoader()
        }
    }
    
    func initialiseSomeFeatureforFirebase() -> Void {
        self.addListnerForUserInactive { (isActive) in
            if isActive {
                self.initialiseLocation()
                self.createChatModelsWithFirestoreListner()
                self.createUsersModelsWithFirestoreListner()
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .none)
                }
                killLoader()
            }
        }
    }
    
    
    func addListnerForUserInactive(callBack : @escaping (Bool) -> (Void)) -> Void {
        ChatManager.shared.createObserverForSelfInactiveStatus { (isInactive) in
            if isInactive {
                killLoader()
                navigateToLoginPage()
                
                ShowAlert(title: LanguageKey.account_deactivated, message: LanguageKey.deactivated_msg, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert) { (_, _) in
                    
                }
            }else{
                callBack(true)
            }
        }
    }
    
    
    func createChatModelsWithFirestoreListner() -> Void {
        ChatManager.shared.alreadyListnerCreated = true
        for job in self.arrOFUserData {
            if job.jobId != nil{
                let model = ChatModel(from: job)
                ChatManager.shared.chatModels.append(model)
            }
        }
    }
    
    func createUsersModelsWithFirestoreListner() -> Void {
        let userList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "Users", query: nil) as? [Users]
        if userList != nil && userList!.count > 0 {
            for user in userList! {
                let userModel = UserModel(from: user)
                ChatManager.shared.userModels.append(userModel)
            }
            
            /////////////////////////////////////////////////////////////////////////////////////////FOR GROUP//////////////////////////////////////////////////////////////////////////////////////////////////////////
            ChatManager.shared.createListnerForUserslocationForGroup()
            /////////////////////////////////////////////////////////////////////////////////////////FOR GROUP//////////////////////////////////////////////////////////////////////////////////////////////////////////
            ChatManager.shared.createListnerForUserslocation()
            openOne2OneChatController()
        }
    }
    
    
    func openOne2OneChatController() -> Void {
        
        if let senderId = APP_Delegate.appOpenFrom121ChatNotificationUser {
            APP_Delegate.appOpenFrom121ChatNotificationUser = nil
            if ChatManager.shared.userModels.count > 0 {
                let userModel = ChatManager.shared.userModels.filter({$0.user?.usrId == senderId})
                if userModel.count > 0 {
                    let userDetails = userModel[0]
                    if let _ = userDetails.documentID {
                        self.navigate121ChatWindow(userDetails: userDetails)
                    }else{
                        userDetails.callbackForScreenNavigation = {
                            self.navigate121ChatWindow(userDetails: userDetails)
                        }
                    }
                }
            }
        }
    }
    
    
    func navigate121ChatWindow(userDetails : UserModel) {
        if userDetails.isInactive == false {
            let vc = UIStoryboard.init(name: "MainAdminChat", bundle: Bundle.main).instantiateViewController(withIdentifier: "GROUPCHAT") as? AdminChatVC
            vc?.userData = userDetails
            DispatchQueue.main.async {
                let navCon = NavClientController(rootViewController: vc!)
                navCon.modalPresentationStyle = .fullScreen
                windowController.present(navCon, animated: true, completion: nil)
            }
        }else{
            windowController.showToast(message: LanguageKey.trying_to_chat)
        }
    }
    
    
    
    func initialiseLocation()  {
        //This location code always put in main thread
        
        if let settings = getDefaultSettings() {
            if settings.isFWgpsEnable == "1" {
                if let startTime = settings.trkStartingHour , let endTime = settings.trkEndingHour{
                    let timeTupple = compareTime(serverStartTime: startTime, serverEndTime: endTime)
                    if timeTupple.0 {
                        
                        //this api will nil if user logout and switch
                        APP_Delegate.startLocationTask = DispatchWorkItem {
                            self.startLocationGPS(settings: settings, endTime: timeTupple.2)
                            APP_Delegate.startLocationTask?.cancel()
                            APP_Delegate.startLocationTask = nil
                        }
                        
                        if timeTupple.1 > 0 { // this means time will start then this is expired time
                            setGpsStatusOnFirebase(status: GPSstatus.Time_Expire) // setting this status on firebase
                        }
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(timeTupple.1), execute: APP_Delegate.startLocationTask!)
                    }else{
                        setGpsStatusOnFirebase(status: GPSstatus.Time_Expire) // setting this status on firebase
                    }
                }
            }else{
                setGpsStatusOnFirebase(status: GPSstatus.Admin_Permission_Issue) // setting this status on firebase
            }
            
            
            ChatManager.shared.setStatusOnline() // set user online
            ChatManager.shared.setBatteryStatusOnFirebase(batteryPercentage: batteryLevel)
        }
        
        
    }
    
    
    func  getSubscriptionData() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            //  hideloader()
            return
        }
      
        let param = Params()
        param.compId = getUserDetails()?.compId
     
        serverCommunicator(url: Service.getSubscriptionData, param: param.toDictionary) { (response, success) in
            // killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(SubcriptionResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        self.subcriptionData = decodedData
                        
                        DispatchQueue.main.async {
                            
                            self.showBackgroundView()
                            self.view.addSubview(self.subcriptionView)
                            self.lblSubcriptionMsg.text = getServerMsgFromLanguageJson(key: decodedData.message ?? "")
                            self.lblContact.text = LanguageKey.please_contact_admin
                            self.subcriptionView.isHidden = false
                            self.subcriptionView.center = CGPoint(x: self.backgroundView.frame.width / 2, y: self.backgroundView.frame.height / 2)
                        }
                        
                    }else{
                        
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        
                    }
                }else{
                
                    ShowAlert(title: "", message:"Subscription Expired Please contact your Eyeontask Super administrator." , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                        if (Ok){
                            DispatchQueue.main.async {
                                (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                            }
                        }
                    })
                }
            }else{
                //ShowError(message: AlertMessage.formatProblem, controller: windowController)
            }
        }
    }
    
    
    
    //================================
    //  MARK: showing And Hiding Background
    //================================
    
    func showBackgroundView() {
        DispatchQueue.main.async {
            self.backgroundView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundView.backgroundColor = UIColor.black
                self.backgroundView.alpha = 0.5
            })
        }
    }
    
    func hideBackgroundView() {
        
        if (subcriptionView != nil) {
            subcriptionView.removeFromSuperview()
        }
        
        self.backgroundView.isHidden = true
        self.backgroundView.backgroundColor = UIColor.clear
        self.backgroundView.alpha = 1
    }
    
    //==================================
    // MARK:- getTaxList Service methods
    //==================================
    
     func getTaxList() -> Void {
            
            if !isHaveNetowork() {
                // ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                return
            }
            
         
         let param = Params()
         
         param.limit = "120"
         if searchkryGetJobTittle == false {
             param.index = "\(countGetJobTittle)"
         }else{
             param.index = "\(addcountGetJobTittle)"
         }
         
       
            param.search = ""
            param.compId = getUserDetails()?.compId
      //   print("API ----------------------------------------------------------------------- getTaxList")
            serverCommunicator(url: Service.getTaxList, param: param.toDictionary) { (response, success) in
             
                
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(taxResponse.self, from: response as! Data) {
                        if decodedData.success == true{
                            
                            self.searchInventroryCountGetJobTittle = Int(decodedData.count!)!
                            
                            if Int(param.index!)! +  Int(param.limit!)! <= self.searchInventroryCountGetJobTittle {
    
                                self.globelGetJobTittle = Int(param.index!)! +  Int(param.limit!)!
                                self.addcountGetJobTittle = self.globelGetJobTittle
                                self.searchkryGetJobTittle = true
                                self.arrItemListOnline1GetJobTittle.append(contentsOf: decodedData.data as! [taxListRes])
                                self.getTaxList()
                        
                            }else{
                                
                                  self.arrItemListOnline1GetJobTittle.append(contentsOf: decodedData.data as! [taxListRes])
                                
                                  self.saveTaxList(data: self.arrItemListOnline1GetJobTittle)
                             
                                }
    
                        }else{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{
                     
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
    
    
      //====================================
      // MARK:- Save saveTaxList in DataBase
      //====================================
    
      func saveTaxList( data : [taxListRes]) -> Void {
          for jobs in data{
            
                  let userJobs = DatabaseClass.shared.createEntity(entityName: "TaxList")
                  userJobs?.setValuesForKeys(jobs.toDictionary!)
                 
          }
         
          DatabaseClass.shared.saveEntity(callback: { _ in })
       
      }
    
    
    func getPurchaseOrderList(){

           
           let param = Params()
           param.search = "po"
         
           serverCommunicator(url: Service.getPurchaseOrderList, param: param.toDictionary) { (response, success) in
              // killLoader()
               if(success){
                   let decoder = JSONDecoder()
                   if let decodedData = try? decoder.decode(PurchaseOrderResp.self, from: response as! Data) {

                       if decodedData.success == true{
                      
                           if let purchasOrderData = decodedData.data as? [PurchaseOrderData] {
                               self.PurchaseOrderArr = purchasOrderData
                               self.savegetPurchaseOrder(data:self.PurchaseOrderArr )
                           }

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

    
       //===================================
       // MARK:- Save getItems in DataBase
       //===================================
       func savegetPurchaseOrder( data : [PurchaseOrderData]) -> Void {
           for jobs in data{
               let query = "poId = '\(String(describing: jobs.poId ?? ""))'"
               if let jodDicData = jobs.toDictionary {
                   if let purchaseOrderList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "PurchaseOrderList", query: query) as? [PurchaseOrderList], purchaseOrderList.count > 0 {
                       let existingJob = purchaseOrderList[0]
                       existingJob.setValuesForKeys(jodDicData)
                   } else {
                       let userJobs = DatabaseClass.shared.createEntity(entityName: "PurchaseOrderList")
                       userJobs?.setValuesForKeys(jodDicData)
                   }
                   
                   DatabaseClass.shared.saveEntity(callback: { _ in })
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
                    
                      if(success){
                          let decoder = JSONDecoder()
                          if let decodedData = try? decoder.decode(JobStatusListRes.self, from: response as! Data) {

                              if decodedData.success == true{
                                  self.saveJobStatusList(data: decodedData.data! )
                                 
                              }else{
                                  ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
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
                
              }else{
                  let userJobs = DatabaseClass.shared.createEntity(entityName: "JobStatusList")
                  userJobs?.setValuesForKeys(jobs.toDictionary!)
                
              }
          }
          
           DatabaseClass.shared.saveEntity(callback: { _ in })
          
      }
 
    
    //   ================================
    //      MARK: getFormName
    //   ================================
   
    
    func getFormName(){
        if !isHaveNetowork() {
            return
        }
        
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getCustomFormNmList) as? String
        
        let param = Params()
     
        param.limit = "120"
        param.index = "\(count)"
        param.dateTime = ""
    
        serverCommunicator(url: Service.getCustomFormNmList, param: param.toDictionary) { (response, success) in
            
            //killLoader()
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(TestRes.self, from: response as! Data) {
                    
                        if decodedData.success == true{
                 
                               self.getCustomFormNmList(data: decodedData.data)

                    }else{
                        killLoader()
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                killLoader()
            }
        }
    }
    
    func getCustomFormNmList( data : [TestDetails]) -> Void {

        for jobs in data{
            let query = "frmId = '\(String(describing: jobs.frmId ?? ""))'"
            if let jodDicData = jobs.toDictionary {
                if let FormNmList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "CustomFormNmList", query: query) as? [CustomFormNmList], FormNmList.count > 0 {
                    let existingJob = FormNmList[0]
                    existingJob.setValuesForKeys(jobs.toDictionary!)

                }else{
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "CustomFormNmList")
                    userJobs?.setValuesForKeys(jodDicData)
                }

                DatabaseClass.shared.saveEntity(callback: { _ in })
            }

        }
   
    }
    
}
//END


