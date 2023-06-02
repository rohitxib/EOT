//
//  JobVC.swift
//  EyeOnTask
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
class QuoteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate , UITextFieldDelegate{
    
    
    @IBOutlet weak var btnSearchText: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var extraButton: UIBarButtonItem!
    @IBOutlet var lblNoJob: UILabel!
    
    var arrOFUserData = [QuotationData]()
    var arrOFData = [QuotationData]()
    var filterDict = [String : [QuotationData]]()
    var arrOfFilterDict  = [[String : [QuotationData]]]()
    var filterTitleArray = [taskStatusType]()
    var filterjobsArray = [Int]()
    var isAdded = Bool()
    var isChanged = Bool()
    var isfirst = Bool()
    var selectedCell : IndexPath? = nil
    var selectedJobID : String? = nil
    var isOpenSerchView : Bool = false
    var count : Int = 0
    var previousInProgress : Bool = false
    var selectedDateRange : DateRange?
    @IBOutlet weak var searchVw_H: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearchfield: UITextField!
    @IBOutlet weak var heightOfArrowBtn: NSLayoutConstraint!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var collectionVw_H: NSLayoutConstraint!
    var searchTxt = ""
    var optionalVw : OptionalView?
    var refreshControl = UIRefreshControl()
    var customStartDate : Date?
    var customEndDate : Date?
    var selectedStatus : [String] = []
     var isEdited = false
    var isReavel = false
    
    var isDefaultView = false
    @IBOutlet weak var filterView: ASJTagsView!
    
    let dateRange = [DateRange.Today,
                     DateRange.Yesterday,
                     DateRange.Last7Days,
                     DateRange.Last30Days,
                     DateRange.ThisMonth,
                     DateRange.LastMonth,
                     DateRange.CustomRange]
    
    
    //=========================
    // MARK:- Initial methods
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
//        APP_Delegate.currentVC = "quote"
        self.collectionVw_H.constant = 0.0
        self.heightOfArrowBtn.constant = 0.0
      //  NotiyCenterClass.registerRefreshQuoteListNotifier(vc: self, selector: #selector(self.joblistRefresh(_:)))

        self.searchVw_H.constant = 0
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearchfield.frame.height))
        txtSearchfield.leftView = paddingView
        txtSearchfield.leftViewMode = UITextField.ViewMode.always
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtSearchfield.frame.height))
        txtSearchfield.rightView = paddingView1
        txtSearchfield.rightViewMode = UITextField.ViewMode.always
        
        
        isAdded = true
        isChanged = true
        
        
        lblNoJob.isHidden = true
        if let revealController = self.revealViewController(){
            revealViewController().delegate = self
            extraButton.target = revealViewController()
            extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealController.tapGestureRecognizer()
        }
        
        //title for the filter functionality, if you want to add any filter in this so simply add and these are automatically showing in UI.
        filterTitleArray = [.New,.Accepted,.OnHold,.Completed]

        showLoader()
        getQuoteListService()
        
        self.collectionVw.reloadData()
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        setLocalization()
        
        ActivityLog(module:Modules.quaotation.rawValue , message: ActivityMessages.quoteList)
//
//        if isDefaultView {
//                              SetBackBarHUmberg()
//                   //self.navigationController?.setNavigationBarHidden(true, animated: true)
//                          }else{
//                               APP_Delegate.currentVC = "job"
//                          }
    }
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.quotes
        lblNoJob .text =  LanguageKey.no_quotes_found //LanguageKey.err_no_jobs_found
        txtSearchfield.placeholder = LanguageKey.search_quote_code_client_name_address
        btnReset.setTitle(LanguageKey.reset, for: .normal)
    }

    
    @objc func joblistRefresh(_ notification: NSNotification){
        count = 0
        arrOFUserData.removeAll()
        self.getQuoteListService()
    }
    
    @objc func refreshControllerMethod() {
         arrOFUserData.removeAll()
         getQuoteListService()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        tableView.estimatedRowHeight = 200
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        if isEdited {
            isEdited = false
            getQuoteListService()
        }
        
        // this condition manage For the case of OFFLINE mode
//      if filterjobsArray.count > 0 {
//            filterDataFromDB()
//        }else{
//            createSection()
//        }
        
    }
    
    func SetBackBarHUmberg(){
             
                         self.navigationController?.setNavigationBarHidden(false, animated: true)
                         
                         let backButton = UIBarButtonItem (image: UIImage(named: "menu")!, style: .done, target: self, action: #selector(GoToBack))
                       self.navigationItem.leftBarButtonItem = backButton
                        self.navigationItem.hidesBackButton = true
    
                  }
    
    @objc func GoToBack(){

      self.navigationController!.popViewController(animated: true)
      self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.revealViewController()?.revealToggle(animated: true)
    }
    

    
    @IBAction func searchBtnAction(_ sender: Any) {
        if(!isOpenSerchView){
            self.view.bringSubviewToFront(searchView)
            self.searchVw_H.constant = 40
            //self.collectionVw_H.constant = 44
            self.btnDropDown.isHidden = true
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
            isOpenSerchView = true
            
            //Hide FilterView
            //self.heightOfArrowBtn.constant = 26.0
            UIView.animate(withDuration: 0.5){
                self.view.layoutIfNeeded()
            }
        }else{
            showDataOnTableView(query: nil)
            self.searchVw_H.constant = 0
            //self.collectionVw_H.constant = 80
            self.btnDropDown.isHidden = false
            self.txtSearchfield.text = ""
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
            isOpenSerchView = false
            
        }
    }
    
    //=======================
    // MARK:- Txt Field Delegates
    //========================
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

        if result.count == 0 {
            searchTxt = ""
            self.arrOFUserData.removeAll()
            self.getQuoteListService()
        }
        
        return true
    }
    
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtSearchfield.resignFirstResponder()
        return true
    }
    
    //=======================
    // searchApiCall
    //========================
    
    @IBAction func searchTextButton(_ sender: Any) {
           searchTxt =  trimString(string: txtSearchfield.text!)
        if searchTxt.count > 0 {
            showLoader()
            self.getQuoteListService()
        }
    }
    
    
 
    
    //=======================
    // Disable Pan gesture
    //========================
    func revealControllerPanGestureShouldBegin(_ revealController: SWRevealViewController!) -> Bool {
        return false
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
          if position == .left {
            
            if isReavel {
                 setLocalization()
                 getQuoteListService()
            }else{
                 isReavel = true
            }
          }
      }
    
    
    //==========================
    // MARK:- Tableview methods
    //==========================
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrOfFilterDict.count
    }
    
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
        let arr = firstKey.components(separatedBy: ",")
        let att = changeColoreOFDate(main_string: firstKey, string_to_color: arr[0])
        
        if(arr[0] == "Today" || arr[0] == "Yesterday" || arr[0] == "Tomorrow" ) {
            headerLabel.attributedText = att
        }else{
            headerLabel.text = att.string
        }
        
        
        headerLabel.textAlignment = .left;
        
        DispatchQueue.main.async {
            headerView.addSubview(headerLabel)
        }
        
        //headerView.addSubview(headerLabel)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
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
            return self.arrOfFilterDict.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
        
        let dict = self.arrOfFilterDict[indexPath.section]
        let firstKey = Array(dict.keys)[0] // or .first
        let arr = dict[firstKey]
        let job = arr![indexPath.row]
       // print("job data is here :", job)
        
        if selectedJobID == job.quotId {
            cell.rightView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            cell.leftBaseView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        }else{
            cell.rightView.backgroundColor = UIColor.white
            cell.leftBaseView.backgroundColor = UIColor.white
        }
        
        if let jobID = job.quotId {
            cell.name.text = "\(job.label != nil ? job.label! : "Apl\(jobID)" ) - " + (job.nm != nil ? String(format: "%@",  job.nm!) : "Unknown" )
        }
        
        
        var address = ""
        if let adr = job.adr {
            if adr != "" {
                address = "\(adr)"
            }
        }
        
//        if let city = job.city {
//            if city != "" {
//                if address != ""{
//                    address = address + ", \(city)".capitalized
//                }else{
//                    address = "\(city)"
//                }
//            }
//        }
        
        
        
        
        if  address != "" {
            cell.taskDescription.attributedText =  lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
        }else{
            cell.taskDescription.text = ""
        }
        
        var strTitle = ""

        if job.jtId!.count > 0 {
            for jtid in job.jtId! {
                if strTitle == ""{
                    strTitle = jtid.title!
                }else{
                    strTitle = "\(strTitle), \( jtid.title!)"
                }
            }
        }
//
//
       cell.lblTitle.text = strTitle
        
        if let date = job.quotDate, job.quotDate != "" {
            let tempTime = convertTimestampToDate(timeInterval: date)
            cell.time.text = tempTime.0
            cell.timeAMPM.text = tempTime.1
        } else {
            cell.time.text = ""
            cell.timeAMPM.text = ""
        }
        
        
        //temp code
        let status = quoteStatus(taskType: QuoteStatusType(rawValue: Int(job.status! == "0" ? "1" : job.status!)!)!)   //taskStatus(taskType: taskStatusType(rawValue: Int(job.status! == "0" ? "1" : job.status!)!)!)
        
        if taskStatusType(rawValue: Int(job.status! == "0" ? "1" : job.status!)!)! == taskStatusType.InProgress{
            cell.status.text = status.0
            cell.leftBaseView.backgroundColor = UIColor(red: 109.0/255.0, green: 209.0/255.0, blue: 32.0/255.0, alpha: 1.0)
            cell.status.textColor = UIColor.white
            cell.timeAMPM.textColor = UIColor.white
            cell.time.textColor = UIColor.white
            cell.statusImage.image  = UIImage.init(named: "inprogress_white")
        }else{
            
            cell.status.text = status.0.replacingOccurrences(of: " Task", with: "")
            cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
            cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
            cell.statusImage.image  = status.1
        }
        
//        if job.prty != "0" {
//            let priorityDetail = taskPriorityImage(Priority: taskPriorities(rawValue: Int(job.prty!)!)!)
//            cell.priorityImage.image = priorityDetail.1
//        }
        
        //if user add job in OFFLINE mode and job not sync on the server
        let ladksj  = job.quotId!.components(separatedBy: "-")
        if ladksj.count > 0 {
            let tempId = ladksj[0]
            if tempId == "Job" {
                
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        
        
        
        //Get Job ID
        let dict = self.arrOfFilterDict[indexPath.section]
        let firstKey = Array(dict.keys)[0] // or .first
        let arr = dict[firstKey]
        let quote = arr![indexPath.row]
        selectedJobID = quote.quotId
        
        
        let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        
        if quote.status != "7" {
            previousInProgress = false
            cell.leftBaseView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        }else{
            previousInProgress = true
        }
        self.selectedCell = indexPath
        cell.rightView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
        isEdited = true
        let itemDetailVC = storyboard?.instantiateViewController(withIdentifier: "quoteInvoice") as! QuoteInvoiceVC
        itemDetailVC.quotationData = quote
        //itemDetailVC.quotationRes = quo
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
    
    
//    //====================================================
//    //MARK:- OptionView Delegate Methods
//    //====================================================
//    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dateRange.count
//    }
//
//    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCell(withIdentifier:"cell")
//        if(cell == nil){
//            cell = UITableViewCell.init(style: .default, reuseIdentifier:"cell")
//        }
//
//        cell?.textLabel?.text = dateRange[indexPath.row].rawValue
//        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
//        cell?.backgroundColor = .clear
//        //cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
//        cell?.textLabel?.textColor = UIColor.darkGray
//
//        if selectedDateRange != nil && selectedDateRange == dateRange[indexPath.row] {
//            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
//        }else {
//            cell?.accessoryType = UITableViewCell.AccessoryType.none
//        }
//
//
//        return cell!
//    }
//
//
//    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.removeOptionalView()
//
//        if selectedDateRange != nil && selectedDateRange == dateRange[indexPath.row] {
//            selectedDateRange = nil
//        }else {
//            selectedDateRange = dateRange[indexPath.row]
//        }
//
//        showLoader()
//        getQuoteListService(searchText: searchTxt)
//
//    }
//
//
//    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 38.0
//    }
    
    
//    // ================================
//    //  MARK: Open Drop Down
//    // ================================
//    func openDwopDown() {
//
//        if (optionalVw == nil){
//           // self.backgroundView.isHidden = false
//            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
//            self.optionalVw?.setUpMethod(frame: CGRect(x: Int(UIScreen.main.bounds.width - 150), y: 0, width: 150, height: dateRange.count*38))
//            self.optionalVw?.delegate = self
//            self.view.addSubview( self.optionalVw!)
//            self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
//                self.removeOptionalView()
//            }
//        }else{
//            DispatchQueue.main.async {
//                self.removeOptionalView()
//            }
//        }
//    }
//
//    func removeOptionalView(){
//        if optionalVw != nil {
//           // self.backgroundView.isHidden = true
//            self.optionalVw?.removeFromSuperview()
//            self.optionalVw = nil
//        }
//    }
//
    func resetFilterOptions() -> Void {
        searchTxt = ""
        
         self.clearFilterChips()
        
        self.selectedStatus = []
        self.selectedDateRange = nil
        self.customEndDate = nil
        self.customStartDate = nil
    }
    
    @IBAction func pressedResetButton(_ sender: Any) {
        searchVw_H.constant = 0.0
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        resetFilterOptions()
        getQuoteListService()
    }
    
    func clearFilterChips() -> Void {
        //for delete all tags from tag view
        if let dateRng = self.selectedDateRange {
            if dateRng ==  DateRange.CustomRange {
                let startDt =  convertDateToString(date: self.customStartDate!, dateFormate: DateFormate.dd_MMM_yyyy)
                let endDt =  convertDateToString(date: self.customEndDate!, dateFormate: DateFormate.dd_MMM_yyyy)
                self.filterView.deleteTag("\(startDt) to \(endDt)")
            }else{
                self.filterView.deleteTag(dateRng.rawValue)
            }
        }
        
        
        for status in self.selectedStatus {
            self.filterView.deleteTag(quoteStatus(taskType: QuoteStatusType(rawValue: Int(status)!)!).0)
        }
        
        self.filterView.reload()
        self.selectedStatus.removeAll()
    }
    
    //===============================
    // MARK:- Data - Passing method
    //===============================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "quoteFilter" {
            let filterVC = segue.destination as! MultiFilterQuoteVC
            filterVC.callbackOfMultipleFilter = {(status : [QuoteStatusType], dateRange: DateRange?, dateArry : (Date?,Date?)) -> Void in
                
                
                self.clearFilterChips()
                
                //For add tags on tag view
                for statusType in status {
                    self.tagAdd(tagString: quoteStatus(taskType: statusType).0)
                    self.selectedStatus.append(String(statusType.rawValue))
                }
                
               
                
                if dateRange == DateRange.CustomRange {
                    self.customStartDate = dateArry.0
                    self.customEndDate = dateArry.1
                    let startDt =  convertDateToString(date: self.customStartDate!, dateFormate: DateFormate.dd_MMM_yyyy)
                    let endDt =  convertDateToString(date: self.customEndDate!, dateFormate: DateFormate.dd_MMM_yyyy)
                    self.tagAdd(tagString:"\(startDt) to \(endDt)")
                }else{
                    if dateRange != nil {
                        self.tagAdd(tagString: dateRange!.rawValue)
                    }
                }
                
                
                self.searchVw_H.constant = 80.0
                UIView.animate(withDuration: 0.5){
                    self.view.layoutIfNeeded()
                }
                self.selectedDateRange = dateRange
                showLoader()
                self.getQuoteListService()
            }
        }else if segue.identifier == "addQuote" {
            ActivityLog(module:Modules.quaotation.rawValue , message: ActivityMessages.quoteAdd)
             let addQuoteVC = segue.destination as! AddQuoteVC
            addQuoteVC.callbackForQuoteInvVC = {(isQuoteAdded : Bool) in
                if isQuoteAdded {
                    self.getQuoteListService()
                }
            }
        }

    }
    
    
    func tagAdd(tagString : String) -> Void {
        
        self.filterView.addTag(tagString, withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: true)
        self.filterView.deleteBlock = {(tagText : String ,idx : Int) -> Void in
            
            if let dateRng = self.selectedDateRange {
                if tagText == dateRng.rawValue || tagText.contains(" to ") {
                    self.selectedDateRange = nil
                    self.filterView.deleteTag(tagText)
                    showLoader()
                    self.getQuoteListService()
                    return
                }
            }
            
           
            self.filterView.deleteTag(tagText)
        
            for status in QuoteStatusType.allCases {
                let quoteType = quoteStatus(taskType: status)
                if quoteType.0 == tagText {
                    let index = self.selectedStatus.firstIndex(of: String(status.rawValue))
                    self.selectedStatus.remove(at: index!)
                    showLoader()
                    self.getQuoteListService()
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
        let cell = collectionVw.dequeueReusableCell(withReuseIdentifier: "jobCollCell", for: indexPath)as! jobCollectionCell
        
        let statusType : Int = filterTitleArray[indexPath.row].rawValue
        if filterjobsArray.firstIndex(of:statusType) != nil {
            cell.contentView.backgroundColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        }else{
            cell.contentView.backgroundColor = UIColor.clear
        }
        
        let statusData = taskStatus(taskType: filterTitleArray[indexPath.row])
        cell.lblTask.text = statusData.0.replacingOccurrences(of: " Task", with: "")
        cell.imgVw.image = statusData.1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell:UICollectionViewCell = collectionVw.cellForItem(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        
        let statusType : Int = filterTitleArray[indexPath.row].rawValue
        
        if let index = filterjobsArray.firstIndex(of:statusType) {
            selectedCell.contentView.backgroundColor = UIColor.clear
            filterjobsArray.remove(at: index)
        }else{
            filterjobsArray.append(statusType)
        }
        filterDataFromDB()
    }
    
    
    func filterDataFromDB() -> Void {
        let query = getQuery(arry: filterjobsArray)
        showDataOnTableView(query: query == "" ? nil : query)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth / 4
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func getQuery(arry : [Int]) -> String {
        var query  = ""
        for status in filterjobsArray {
            var str = "status = \(status)"
            
            if status == taskStatusType.Accepted.rawValue{
                str = "status = \(taskStatusType.Accepted.rawValue) OR status = \(taskStatusType.Travelling.rawValue) OR status = \(taskStatusType.Break.rawValue)"
            }
            
            if status == taskStatusType.OnHold.rawValue{
                str = "status = \(taskStatusType.OnHold.rawValue)"
            }
        
            
            if query == "" {
                query = str
            }else{
                query = "\(query) OR \(str)"
            }
        }
        return query
    }
    
//    @IBAction func filterBtn(_ sender: Any) {
//        openDwopDown()
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
        if selectedDateRange != nil{
            dates = getDateFromStatus(dateRange: selectedDateRange!)
        }
        
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
        print(dict!)
        
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
                            self.filterDict.removeAll()
                            self.arrOfFilterDict.removeAll()
                            self.arrOFUserData.removeAll()
                        }
                        
                        if let arryCount = decodedData.data{
                            //print(arr)
                            if arryCount.count > 0{
                                
                                self.arrOFUserData.append(contentsOf: decodedData.data!)
                                self.count += (decodedData.data?.count)!
                                
                                if !self.isfirst{
                                    
                                    if  self.filterjobsArray.count == 0{
                                        self.showDataOnTableView(query: nil)
//                                        if self.txtSearchfield.text!.count > 0 {
//                                                 self.showDataOnTableView(query: nil)
//                                        }else{
//                                            self.showDataOnTableView(query: nil) //Show joblist on tableview
//                                        }
                                    }else{
                                        self.filterDataFromDB()
                                    }
                                }
                            }else{
                                self.showDataOnTableView(query : "")
                            }
                        }else{
                            self.showDataOnTableView(query : "")
                        }
                        
                        if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                            self.resetFilterOptions()
                            self.getQuoteListService()
                        }else{
                            killLoader()
                            
                            if self.isfirst {

                                // 'isfirst' for second time will not call some api's which was called first time
                                self.isfirst = false
                                
                                // check if filter enable then data not reload on table
                                if  self.filterjobsArray.count == 0{
                                    self.showDataOnTableView(query: nil) //Show joblist on tableview
                                }
                            }
                            self.count = 0
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
    
    
    func showDataOnTableView(query : String?) -> Void {
        
        if arrOFUserData.count != 0 {
            self.createSection ()
        }else{
            
            if(self.arrOfFilterDict.count != 0){
                self.arrOFData.removeAll()
                self.filterDict.removeAll()
                self.arrOfFilterDict.removeAll()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            self.lblNoJob.isHidden = self.arrOFUserData.count > 0 ? true : false
        }
    }
    
    
    
    //=====================================
    // MARK:- SECTIONS for JOBLIST
    //=====================================
    
    func createSection(){
        
       
            if(self.arrOfFilterDict.count != 0){
                self.arrOFData.removeAll()
                self.filterDict.removeAll()
                self.arrOfFilterDict.removeAll()
            }
            
            var currentDate = ""
         
            self.arrOFUserData = self.arrOFUserData.sorted(by: { ($0.quotDate ?? "") > ($1.quotDate ?? "") })
            
            for  objOfUserData in self.arrOFUserData{
                let strDate = dayDifference(unixTimestamp: objOfUserData.quotDate ?? "")
                
                if(self.arrOfFilterDict.count > 0){
                    
                    // Below is new change implemented by Hemant
                    if currentDate == strDate {
                        var dictObj = self.arrOfFilterDict.last
                        dictObj![strDate]?.append(objOfUserData)
                        self.arrOfFilterDict[self.arrOfFilterDict.count-1] = dictObj!
                    }else{
                        currentDate = strDate
                        self.arrOFData.removeAll()
                        self.filterDict.removeAll()
                        self.arrOFData.append(objOfUserData)
                        self.filterDict[strDate] = self.arrOFData
                        self.arrOfFilterDict.append(self.filterDict)
                    }
                }else{
                    currentDate = strDate
                    self.arrOFData.append(objOfUserData)
                    self.filterDict[strDate] = self.arrOFData
                    self.arrOfFilterDict.append(self.filterDict)
                }
            }
        
        DispatchQueue.main.async{
             self.tableView.reloadData()
        }
    }
    

    @IBAction func collectionEnableBtnTapped(_ sender: UIButton) {
//        if self.collectionVw_H.constant == 0.0 {
//            self.collectionVw_H.constant = 80.0
//
//            UIView.animate(withDuration: 0.5){
//                self.view.layoutIfNeeded()
//                sender.setImage(UIImage(named:"top_pannel_arrow"), for: .normal)
//            }
//        }else{
//            self.collectionVw_H.constant = 0.0
//
//            UIView.animate(withDuration: 0.5) {
//                self.view.layoutIfNeeded()
//                sender.setImage(UIImage(named:"Down_pannel_arrow"), for: .normal)
//            }
//        }
    }
    
    func getDateFromStatus(dateRange : DateRange) -> (String,String) {
        switch dateRange {
            
                case .Today:
                    let fromDate = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.fromDateFormate)
                    let toDate = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.toDateFormate)
                    //print(fromDate,toDate)
                    return (fromDate,toDate)
            
                case .Yesterday:
                    let calender = Calendar.current
                    let date = calender.date(byAdding: .day, value: -1, to: Date())
                    let fromDate = convertDateToStringForServer(date: date!, dateFormate: DateFormate.fromDateFormate)
                    let toDate = convertDateToStringForServer(date: date!, dateFormate: DateFormate.toDateFormate)
                
                    //print(fromDate,toDate)
                    return (fromDate,toDate)
            
                case .Last7Days:
                    let calender = Calendar.current
                    let date = calender.date(byAdding: .day, value: -6, to: Date())
                    let fromDate = convertDateToStringForServer(date: date!, dateFormate: DateFormate.fromDateFormate)
                    let toDate = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.toDateFormate)
                    
                   /// print(fromDate,toDate)
                    return (fromDate,toDate)
            
                case .Last30Days:
                    let calender = Calendar.current
                    let date = calender.date(byAdding: .day, value: -29, to: Date())
                    let fromDate = convertDateToStringForServer(date: date!, dateFormate: DateFormate.fromDateFormate)
                    let toDate = convertDateToStringForServer(date: Date(), dateFormate: DateFormate.toDateFormate)
                    
                    //print(fromDate,toDate)
                    return (fromDate,toDate)
            
                case .ThisMonth:
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month], from: Date())
                    let startOfMonth = calendar.date(from: components)
                    
                    
                    var comps2 = DateComponents()
                    comps2.month = 1
                    comps2.day = -1
                    let endOfMonth = calendar.date(byAdding: comps2, to: startOfMonth!)
                    
                    let fromDate = convertDateToStringForServer(date: startOfMonth!, dateFormate: DateFormate.fromDateFormate)
                    let toDate = convertDateToStringForServer(date: endOfMonth!, dateFormate: DateFormate.toDateFormate)
                 
                    //print(fromDate,toDate)
                    return (fromDate,toDate)
            
                 case .LastMonth:
                    let calendar = Calendar.current
                    var components = calendar.dateComponents([.year, .month], from: Date())
                    components.month = components.month! - 1
                    let startOfMonth = calendar.date(from: components)
                    
                    
                    var comps2 = DateComponents()
                    comps2.month = 1
                    comps2.day = -1
                    let endOfMonth = calendar.date(byAdding: comps2, to: startOfMonth!)
                    
                    let fromDate = convertDateToStringForServer(date: startOfMonth!, dateFormate: DateFormate.fromDateFormate)
                    let toDate = convertDateToStringForServer(date: endOfMonth!, dateFormate: DateFormate.toDateFormate)
                    
                    //print(fromDate,toDate)
                    return (fromDate,toDate)
            
                case .CustomRange:
                    let fromDate = convertDateToStringForServer(date: customStartDate!, dateFormate: DateFormate.fromDateFormate)
                    let toDate = convertDateToStringForServer(date: customEndDate!, dateFormate: DateFormate.toDateFormate)
                   // print(fromDate,toDate)
                    return (fromDate,toDate)
               }
    }
    
}
