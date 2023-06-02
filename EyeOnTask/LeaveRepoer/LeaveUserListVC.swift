//
//  LeaveUserListVC.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 12/11/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class LeaveUserListVC: UIViewController , SWRevealViewControllerDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var notFountMsg: UILabel!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var extraButton: UIBarButtonItem!
    @IBOutlet weak var normalSearchView: UIView!
    @IBOutlet weak var advanceFilterview: UIView!
    @IBOutlet weak var normalSearch_H: NSLayoutConstraint!
    @IBOutlet weak var advanceFilter_H: NSLayoutConstraint!
    @IBOutlet weak var txtSearchfield: UITextField!
    @IBOutlet weak var tableExpence: UITableView!
    
    var isNotificationClick = false
    var refreshControl = UIRefreshControl()
    var expences = [Expence]()
    var expences1 = [ResLeave]()
    var searchTxt = ""
    var filteredExpence = [[String : [Expence]]]()
    var filteredExpence1 = [[String : [ResLeave]]]()
    var arrOFData = [ResLeave]()
    var filterDict = [String : [ResLeave]]()
    let expencesForFilter : [expenceStatus1] = expenceStatus1.allCases
    var selectedExpencesforFilter = [Int]()
    var filterjobsArray = [Int]()
    var selectedCell : IndexPath? = nil
    var selectedExpenceID : String? = nil
    var objOfUserJobListInDetail : UserJobList!
    var isfirst = Bool()
    var isDataLoading:Bool = false
    var pageNo:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLeaveList()
        createDateViseSection()
        NotiyCenterClass.registerRefreshLeaveNotifier(vc: self, selector: #selector(self.joblistRefresh(_:)))
        if(isNotificationClick){
            self.extraButton.isEnabled = false
            SetBackBarButtonCustom()
        }
        showLoader()
        
        setLocalization()
        
        
        advanceFilter_H.constant = 0.0
        normalSearch_H.constant = 0.0
        
        
        if let revealController = self.revealViewController(){
            revealViewController().delegate = self
            extraButton.target = revealViewController()
            extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealController.tapGestureRecognizer()
        }
        
        
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableExpence.addSubview(refreshControl) // not required when using UITableViewController
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserLeaveList()
        tableExpence.reloadData()
        
    }
    
    //==============================
    //Mark: - Page Nation
    //==============================
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pageNo = 1
    }
    
    func loadMoreItemsForList(){
        self.pageNo += 1
        getUserLeaveList()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isDataLoading){
            if !isDataLoading{
                isDataLoading = true
                self.loadMoreItemsForList()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    //==============================
    
    @objc func joblistRefresh(_ notification: NSNotification){
        if let controllers = self.navigationController?.viewControllers{
            for view in controllers{
                if (view .isKind(of: AuditVC.self)){
                    self.navigationController?.popToViewController(view, animated: true)
                }
            }
            self.getUserLeaveList()
        }
    }
    
    func SetBackBarButtonCustom()
    {
        //Back buttion
        
        let button = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(LeaveUserListVC.onClcikBack))
        
        self.navigationItem.leftBarButtonItem  = button
        //      self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(redirect), userInfo: nil, repeats: true)
        
        
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.user_leave
        notFountMsg.text = "Leave list not found"
        txtSearchfield.placeholder = LanguageKey.expense_search_name
    }
    
    
    @objc func refreshControllerMethod() {
        
        filteredExpence1.removeAll()
        
    }
    
    @objc func onClcikBack(){
        if isNotificationClick {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func showDataOnTableView(query : String?) -> Void {
        
        if filteredExpence1.count != 0 {
            self.createSection ()
        }else{
            DispatchQueue.main.async {
                if(self.filteredExpence1.count != 0){
                    
                    self.arrOFData.removeAll()
                    self.filterDict.removeAll()
                    self.filteredExpence1.removeAll()
                }
                self.tableExpence.reloadData()
                
                
            }
        }
        
        DispatchQueue.main.async {
            self.notFountMsg.isHidden = self.filteredExpence1.count > 0 ? true : false
        }
    }
    
    
    
    //=======================
    // MARK:- Txt Field Delegates
    //========================
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if result.count == 0 {
            searchTxt = ""
            self.filteredExpence1.removeAll()
            
            
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtSearchfield.resignFirstResponder()
        return true
    }
    
    
    //=========================
    // MARK:- Button methods
    //=========================
    
    
    @IBAction func btnAdvanceFilter(_ sender: Any) {
        
       
        if self.advanceFilter_H.constant == 0 {
            advanceFilter_H.constant = 55.0
            advanceFilterview.layoutIfNeeded()
        }else{
            advanceFilter_H.constant = 0.0
            advanceFilterview.layoutIfNeeded()
        }
        
        func hideloader() -> Void {
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            
            killLoader()
        }
        
        
    }
    
    
    func hideloader() -> Void {
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
        
        killLoader()
    }
    
    @IBAction func btnNormalSearch(_ sender: Any) {
        //             print ("asdfasdfsadf")
        //
        //                    DispatchQueue.main.async {
        //                               if self.normalSearch_H.constant == 0 {
        //                                self.normalSearch_H.constant = 55.0
        //                                self.normalSearchView.layoutIfNeeded()
        //
        //                            UIView.animate(withDuration: 0.3, animations: {
        //                                    self.view.layoutIfNeeded()
        //                              }) { (isComplete) in
        //
        //                                  if isComplete {
        //            self.collectionVw.reloadData()
        //
        //                                  }
        //                              }
        //
        //
        //                        }else{
        //                                self.showDataOnTableView(query: nil)
        //                                self.normalSearch_H.constant = 0.0
        //                                self.normalSearchView.layoutIfNeeded()
        //
        //                            UIView.animate(withDuration: 0.3, animations: {
        //                                    self.view.layoutIfNeeded()
        //                              }) { (isComplete) in
        //
        //                                  if isComplete {
        //
        //                                  }
        //                              }
        //                        }
        //                    }
    }
    
    
    
    
    func createDateViseSection() {
        
        
        var currentDate = ""
        self.expences1 = self.expences1.sorted(by: { $0.startDateTime! > $1.startDateTime! })
        
        for  expence in self.expences1 {
            let strDate = dayDifference(unixTimestamp: (expence.startDateTime!))
            
            if(self.filteredExpence1.count > 0){
                
                // Below is new change implemented by Hemant
                if currentDate == strDate {
                    var dictObj = self.filteredExpence1.last
                    dictObj![strDate]?.append(expence)
                    self.filteredExpence1[self.filteredExpence1.count-1] = dictObj!
                }else{
                    currentDate = strDate
                    self.arrOFData.removeAll()
                    self.filterDict.removeAll()
                    self.arrOFData.append(expence)
                    self.filterDict[strDate] = self.arrOFData
                    self.filteredExpence1.append(self.filterDict)
                }
            }else{
                currentDate = strDate
                self.arrOFData.append(expence)
                self.filterDict[strDate] = self.arrOFData
                self.filteredExpence1.append(self.filterDict)
            }
        }
        
        
        
        DispatchQueue.main.async {
            self.tableExpence.reloadData()
        }
        
    }
    
    //=================================
    // MARK:- getUserLeaveList Service
    //=================================
    
    func getUserLeaveList(){
        
        
        let param = Params()
        param.usrId = (getUserDetails()?.usrId)
        param.limit = "\(5*pageNo)"
        param.index = "0"
        showLoader()
        
        serverCommunicator(url: Service.getUserLeaveList, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ResponseLeave.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        if let totalExpences1 = decodedData.data{
                            if totalExpences1.count > 0 {
                                self.expences1 = totalExpences1
                                self.createSection()
                                
                            }else{
                                killLoader()
                                
                                DispatchQueue.main.async {
                                    
                                    self.filteredExpence1.removeAll()
                                    self.tableExpence.reloadData()
                                    
                                }
                                
                            }
                        }
                        
                        
                    }else{
                        self.showToast(message: decodedData.message!)
                    }
                }else{
                    
                    // ShowError(message: "\(msg)", controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
        
    }
    
    
}



extension LeaveUserListVC : UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //=========================
    // MARK:- TableView methods
    //=========================
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredExpence1.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.filteredExpence1.count != 0){
            let dict = self.filteredExpence1[section]
            let firstKey = Array(dict.keys)[0] // or .first
            let arr = dict[firstKey]
            return arr!.count
        }else{
            return filteredExpence1.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: Int(self.tableExpence.frame.size.width), height: 30)
        headerView.backgroundColor = UIColor(red: 246.0/255.0, green: 242.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        
        let headerLabel = UILabel(frame: CGRect(x: 14, y: 10, width:
                                                    headerView.bounds.size.width-20, height: 20))
        headerLabel.font = Font.ArimoBold(fontSize: 13.0)
        headerLabel.textColor = UIColor(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
        if  self.filteredExpence1.count > 0 {
            let dict = self.filteredExpence1[section]
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
        }
    
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30.0
        
    }
    
    // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // return 103.0
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenceCell") as! ExpenceListCell
        if self.filteredExpence1.count > 0 {
            let dict = self.filteredExpence1[indexPath.section]
            let firstKey = Array(dict.keys)[0] // or.first
            let arr = dict[firstKey]
            let expence1 = arr![indexPath.row]
            
            cell.lblExpenceName.text = expence1.note// note
            cell.lblDes.text = expence1.reason//
            cell.userList.text = expence1.leaveType
            
            if expence1.startDateTime != "" {
                let date = dateFormateWithMonthandDay(timeInterval: expence1.startDateTime!)////startDate
                let endDate = dateFormateWithMonthandDay(timeInterval: expence1.finishDateTime!)///endDate
                let year = dateFormateWithYeat(timeInterval: expence1.startDateTime!)
                let startTime = dateFormateWithYeat1(timeInterval: expence1.startDateTime!)/////////startTime
                let endTime = dateFormateWithYeat1(timeInterval: expence1.finishDateTime!)/////////endTime
                
                cell.endDateShedulLbl.text = endDate // endDate
                cell.price.text = date // startDate
                cell.lblGroupName.text = startTime // startTime
                cell.lblCategory.text = endTime
                cell.lblTime.text = year
                //cell.lblAMPM.text = year
                
            } else {
                cell.lblTime.text = ""
                cell.lblAMPM.text = ""
            }
            
            
            
            if let statusValue = expence1.status {
                if statusValue != "" {
                    let status = expenceStatusDetails1(taskType: expenceStatus1(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)!)
                    cell.lblTaskStatus.text = status.0
                    cell.imgTaskStatus.image = status.1
                }else{
                    cell.lblTaskStatus.text = nil
                    cell.imgTaskStatus.image = nil
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //            let dict = self.filteredExpence1[indexPath.section]
        //                       let firstKey = Array(dict.keys)[0] // or .first
        //                       let arr = dict[firstKey]
        //                       let expence = arr![indexPath.row]
        //             let storyBoard : UIStoryboard = UIStoryboard(name: "Expence", bundle:nil)
        //             let detailCon = storyBoard.instantiateViewController(withIdentifier: "ExpenceDetailVC") as! ExpenceDetailVC
        //             self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        //            detailCon.inDetail =  expence
        //            self.navigationController?.pushViewController(detailCon, animated: true)
    }
    
    
    
    @IBAction func btnSearch(_ sender: Any) {
        
        searchTxt =  trimString(string: txtSearchfield.text!)
        if searchTxt.count > 0 {
            showLoader()
            
            
        }
        self.txtSearchfield.resignFirstResponder()
        
        
        
    }
    //===============================
    // MARK:- CollectionView methods
    //===============================
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expencesForFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionVw.dequeueReusableCell(withReuseIdentifier: "jobCollCell", for: indexPath)as! jobCollectionCell
        
        let statusType : Int = expencesForFilter[indexPath.row].rawValue
        let statusData = expenceStatusDetails1(taskType: expencesForFilter[indexPath.row])
        cell.lblTask.text = statusData.0.replacingOccurrences(of: " Task", with: "")
        
        
        if selectedExpencesforFilter.firstIndex(of:statusType) != nil {
            cell.greenView.backgroundColor = .init(red: 40.0/255.0, green: 166.0/255.0, blue: 70.0/255.0, alpha: 1.0)
            cell.lblTask.textColor = .white
            cell.imgCrossWidth.constant = 13.0
            cell.imgVw.image = statusData.1
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
        return CGSize(width: widthPerItem, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let statusType : Int = expencesForFilter[indexPath.row].rawValue
        if let index = selectedExpencesforFilter.firstIndex(of:statusType) {
            selectedExpencesforFilter.remove(at: index)
        }else{
            
            selectedExpencesforFilter.append(statusType)
        }
        
        createSection()
        collectionView.reloadData()
    }
    
    
    
    //=====================================
    // MARK:- SECTIONS for JOBLIST
    //=====================================
    
    func createSection(){
        
        self.filteredExpence1.removeAll()
        var arrOFData = [ResLeave]()
        var filterDict = [String : [ResLeave]]()
        var LatestFilterDict  = [[String : [ResLeave]]]()
        
        var currentDate = ""
        
        var expenceList = [ResLeave]()
        
        if selectedExpencesforFilter.count > 0 && self.expences1.count > 0 {
            expenceList =  self.expences1.filter({selectedExpencesforFilter.contains(Int($0.status!)!)})
            expenceList = expenceList.sorted(by: { ($0.startDateTime ?? "") > ($1.startDateTime ?? "") })
        }else{
            expenceList = self.expences1.sorted(by: { ($0.startDateTime ?? "") > ($1.startDateTime ?? "") })
        }
        
        
        for  objOfUserData in expenceList {
            let strDate = dayDifference(unixTimestamp: objOfUserData.startDateTime ?? "")
            
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
            self.filteredExpence1 = LatestFilterDict
            self.tableExpence.reloadData()
            killLoader()
        }
    }
    
}


