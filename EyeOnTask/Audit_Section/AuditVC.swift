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
      class AuditVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate , UITextFieldDelegate{
          
          
         // @IBOutlet weak var btnSearchText: UIButton!
          @IBOutlet weak var btnSearchText: UIBarButtonItem!
          @IBOutlet weak var btnReset: UIButton!
          @IBOutlet weak var btnDropDown: UIButton!
          @IBOutlet var tableView: UITableView!
          @IBOutlet var extraButton: UIBarButtonItem!
          @IBOutlet var lblNoJob: UILabel!
          var arrOFUserData = [AuditListData]()
          var arrOFUserData1 = [AuditOfflineList]()
          //var arrOFData = [AuditListData]()
         // var filterDict = [String : [AuditListData]]()
         // var arrOfFilterDict  = [[String : [AuditListData]]]()
          var arrOfFilterDict1  = [[String : [AuditOfflineList]]]()
          var notificataionData  = [[String : [AuditOfflineList]]]()
          var filterTitleArray = [taskStatusTypeAudit]()
          var filterjobsArray = [Int]()
          var barCodeResponse = [AuditListData]()
          var isAdded = Bool()
          var isChanged = Bool()
          var isfirst = Bool()
          var selectedCell : IndexPath? = nil
          var selectedAuditID : String? = nil
          var isOpenSerchView : Bool = false
          var count : Int = 0
          var previousInProgress : Bool = false
          var selectedDateRange : DateRange?
          var isBackButton = false
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
          var isBarcodeScanner = false
          var isNotificationClick = false
          var barcode : String!
          var isReavel = false
          var isUserfirstLogin = Bool()
          var jobTabVc : RemarkVC?
          var isAuditData = false
          var arrOFUserData2 = [AuditOfflineList]()
        var callback: ((Bool,NSManagedObject) -> Void)?
        var timer:Timer?
        var notificationData = false
       @IBOutlet weak var btnSortRecent: UIButton!
       
       @IBOutlet weak var btnSortDate: UIButton!

       @IBOutlet weak var btnAddJob: UIButton!
       
       
       var queue = OperationQueue()
       var jobTabVC : AuditTabController?
       var multiFilterArray = [[String : String]]()
      
      
       var sorting : SortType = SortType.SortByRecent
      
       
       @IBOutlet weak var radioButtonDate: UIImageView!
       @IBOutlet weak var btnSort: UIButton!
       @IBOutlet weak var radioButtonRecent: UIImageView!
       
       @IBOutlet weak var filterTagsView: ASJTagsView!
       @IBOutlet weak var filterView: UIView!
      
       
       @IBOutlet var sortView: UIView!
       @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
       
       @IBOutlet weak var filtertagHeight: NSLayoutConstraint!
       
      
       var sortBtnTag = 0
       
       
       
          //@IBOutlet weak var filterView: ASJTagsView!
          
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
              DispatchQueue.main.async {
                 // self.lblNoJob.isHidden = true
                  self.lblNoJob.isHidden = self.arrOFUserData1.count > 0 ? true : false
              }
              
           if isAuditData == true {
           // let barcodeValue = UserDefaults.standard.value(forKey: "code") as! String
           let barcodeValue = UserDefaults.standard.value(forKey: "barcodeString") as! String
           CommonClass.shared.auditEquipment(barcodeString: barcodeValue, arrOfData: arrOFUserData2)
           }
           
              self.extraButton.isEnabled = true
             
              
              
//              APP_Delegate.currentVC = "auditvc"
              self.collectionVw_H.constant = 0.0
              self.heightOfArrowBtn.constant = 0.0
            NotiyCenterClass.registerRefreshAuditListNotifier(vc: self, selector: #selector(self.joblistRefresh(_:)))

              self.searchVw_H.constant = 0
              
              let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearchfield.frame.height))
              txtSearchfield.leftView = paddingView
              txtSearchfield.leftViewMode = UITextField.ViewMode.always
              
              let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtSearchfield.frame.height))
              txtSearchfield.rightView = paddingView1
              txtSearchfield.rightViewMode = UITextField.ViewMode.always
              
              
              isAdded = true
              isChanged = true
              isfirst = true
              
              lblNoJob.isHidden = true
              if let revealController = self.revealViewController(){
                  revealViewController().delegate = self
                  extraButton.target = revealViewController()
                  extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
                  revealController.tapGestureRecognizer()
              }
              
              //title for the filter functionality, if you want to add any filter in this so simply add and these are automatically showing in UI.
              filterTitleArray = [.New,.Accepted,.OnHold,.Completed]

              //showLoader()
            
            
            if isBarcodeScanner {
                self.extraButton.isEnabled = false
                SetBackBarButtonCustom()
                copyDataInOtherArray()
                 createSection()
            }else if(isNotificationClick){
                self.extraButton.isEnabled = false
                SetBackBarButtonCustom()
            }else{
                getAuditListService()
                
            }
              
//            if isBackButton {
//                       SetBackBarHUmberg()
//            //self.navigationController?.setNavigationBarHidden(true, animated: true)
//                   }else{
//                        APP_Delegate.currentVC = "job"
//                   }
            
              self.collectionVw.reloadData()
              refreshControl.attributedTitle = NSAttributedString(string: " ")
              refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
              tableView.addSubview(refreshControl) // not required when using UITableViewController
              
              setLocalization()
              
            ActivityLog(module:Modules.audit.rawValue , message: ActivityMessages.auditList)
        }
        
        
    func copyDataInOtherArray() {
        self.arrOFUserData1.removeAll()
        let allAudits = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: nil) as! [AuditOfflineList]
        for audit in arrOFUserData2 {
        let filterAudit = allAudits.filter({$0.audId == audit.audId})
        if filterAudit.count > 0 {
        self.arrOFUserData1.append(filterAudit[0])

        }
        }

        }
//        func copyDataInOtherArray()  {
//            self.arrOFUserData1.removeAll()
//            let allAudits = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: nil) as! [AuditOfflineList]
//            for audit in arrOFUserData {
//                let filterAudit = allAudits.filter({$0.audId == audit.audId})
//                if filterAudit.count > 0 {
//                    self.arrOFUserData1.append(filterAudit[0])
//                }
//            }
//        }
        
       
       
       
       @objc func popToAuditVC(_ notification: NSNotification){
           let vc = UIStoryboard(name: "MainAudit", bundle: nil).instantiateViewController(withIdentifier: "audit") as! AuditVC;
           let navCon = NavClientController(rootViewController: vc)
           navCon.modalPresentationStyle = .fullScreen
           self.present(navCon, animated: true, completion: nil)
       }
       
          func setLocalization() -> Void {
              self.navigationItem.title = LanguageKey.audit_nav
              lblNoJob .text =  LanguageKey.audit_not_found //LanguageKey.err_no_jobs_found
              txtSearchfield.placeholder = LanguageKey.audit_search_hint
              btnReset.setTitle(LanguageKey.reset, for: .normal)
           
          }

   //
          @objc func joblistRefresh(_ notification: NSNotification){
            if let controllers = self.navigationController?.viewControllers{
                for view in controllers{
                    if (view .isKind(of: AuditVC.self)){
                        self.navigationController?.popToViewController(view, animated: true)
                    }
                }
                self.getAuditListService()
            }
          }

          @objc func refreshControllerMethod() {
               if isBarcodeScanner == true
               {
                let  barcodeValue = UserDefaults.standard.value(forKey: "barcodeString") as! String
                                   getEquipmentListFromBarcodeScannerOffline(barcodeString: barcodeValue)
                  // getEquipmentListFromBarcodeScanner(barcodeString : barcode )
               }else{
                   getAuditListService()
               }
          }
          
          
          override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
              
              DispatchQueue.main.async {
                 // self.lblNoJob.text = ""
                  self.lblNoJob.isHidden = self.arrOFUserData1.count > 0 ? true : false
              }
          if isBarcodeScanner == true{
                      print("hello")
                  }else{
                      getAuditListService()
                  }
             // self.navigationItem.title = LanguageKey.audit_nav
              tableView.estimatedRowHeight = 200
              tableView.estimatedRowHeight = UITableView.automaticDimension
              tableView.rowHeight = UITableView.automaticDimension
            
              // this condition manage For the case of OFFLINE mode
             if filterjobsArray.count > 0 {
                  filterDataFromDB()
              }else{
                if !isfirst {
                    createSection()
                 }
              }
            
             // No need for semicolon
//                   if let revealController = self.revealViewController(){
//                       revealViewController().delegate = self
//                       extraButton.target = revealViewController()
//                       extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
//                       revealController.tapGestureRecognizer()
//                   }
            
          }
        
        func viewWillAppear(animated: Bool) {
           
        }
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            if isNotificationClick && isfirst {
               // getAuditListService()
            }
            
            isfirst = false
        }
        
       
       func SetBackBarButtonCustom()
       {
           //Back buttion

           let button = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(AuditVC.onClcikBack))
           
           self.navigationItem.leftBarButtonItem  = button
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(redirect), userInfo: nil, repeats: true)
      
       
       }

        @objc  func redirect(){
            
            notificationData = true
            performSegue(withIdentifier: "ShowAuditTab", sender: self)
           
          
          timer?.invalidate()
          timer = nil
          
          }
        
       @objc func onClcikBack(){
            if isBarcodeScanner {
                self.dismiss(animated: true, completion: nil)
            }else if isNotificationClick {
                self.dismiss(animated: true, completion: nil)
            }else{
                 self.navigationController?.popViewController(animated: true)
            }
       }

         
          func SetBackBarHUmberg(){
              
              self.navigationController?.setNavigationBarHidden(false, animated: true)
              
              let backButton = UIBarButtonItem (image: UIImage(named: "menu")!, style: .done, target: self, action: #selector(GoToBack))
              self.navigationItem.leftBarButtonItem = backButton
              // self.navigationItem.hidesBackButton = true
              
              
          }
        
        @objc func GoToBack(){

          self.navigationController!.popViewController(animated: true)
          self.navigationController?.setNavigationBarHidden(true, animated: true)
           // self.revealViewController()?.revealToggle(animated: true)
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
                        txtSearchfield.resignFirstResponder()
                        isOpenSerchView = false

                    }
          }
          
          //=======================
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
              
              
              
              if result.count == 0 {
                  searchTxt = ""
                  self.arrOFUserData.removeAll()
                  self.getAuditListService()
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
                if isBarcodeScanner == true{
                    let  barcodeValue = UserDefaults.standard.value(forKey: "barcodeString") as! String
                                       getEquipmentListFromBarcodeScannerOffline(barcodeString: barcodeValue)
                  //  getEquipmentListFromBarcodeScanner(barcodeString : barcode )
                }else{
                    getAuditListService()
                }
              }
           self.txtSearchfield.resignFirstResponder()
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
                    getAuditListService()
                }else{
                     isReavel = true
                }
             }
          }
          
          
          //==========================
          // MARK:- Tableview methods
          //==========================
          
          func numberOfSections(in tableView: UITableView) -> Int {
              return self.arrOfFilterDict1.count
          }
          
          func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
              let headerView = UIView()
              headerView.frame = CGRect(x: 0, y: 0, width: Int(self.tableView.frame.size.width), height: 30)
              headerView.backgroundColor = UIColor(red: 246.0/255.0, green: 242.0/255.0, blue: 243.0/255.0, alpha: 1.0)
              
              let headerLabel = UILabel(frame: CGRect(x: 14, y: 10, width:
                  headerView.bounds.size.width-20, height: 20))
              headerLabel.font = Font.ArimoBold(fontSize: 13.0)
              headerLabel.textColor = UIColor(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
              
              let dict = self.arrOfFilterDict1[section]

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
              
              
              if(self.arrOfFilterDict1.count != 0){
                  let dict = self.arrOfFilterDict1[section]
                  let firstKey = Array(dict.keys)[0] // or .first
                  let arr = dict[firstKey]
                  return arr!.count
              }else{
                  return 0
              }
          }
          
          
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              
              let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
              cell.isUserInteractionEnabled = true
              let dict = self.arrOfFilterDict1[indexPath.section]
              
              let firstKey = Array(dict.keys)[0] // or .first
              let arr = dict[firstKey]
              let audit = arr![indexPath.row]
              
              cell.imgEquipment.isHidden = true
              cell.attchment_Audit.isHidden = true
              
              var isSwitchOff = ""
              isSwitchOff =   UserDefaults.standard.value(forKey: "TokenOff") as? String ?? ""
             
              
              if (isSwitchOff == "Off") {
                  
                  cell.auditSelf_H.constant = 0
                  
              }else{
                  cell.selfAuditLbl.text = audit.snm
                  cell.auditSelf_H.constant = 13
              }
              
              
              
              cell.imgEquipment.isHidden = true
              cell.attchment_Audit.isHidden = true
              
              if selectedAuditID == audit.audId {
                  cell.rightView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                  cell.leftBaseView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
              }else{
                  cell.rightView.backgroundColor = UIColor.white
                  cell.leftBaseView.backgroundColor = UIColor.white
              }
              var someArray = [String]()
              
              if audit.equArray == someArray as NSObject {
                  cell.imgEquipment.isHidden = true
                  cell.equipment_Height_Audit.constant = 0
                  
              }else{
                  cell.equipment_Height_Audit.constant = 14
                  cell.imgEquipment.isHidden = false
                  cell.imgEquipment.image =  UIImage.init(named: "equip")
              }
              
              if audit.attachCount == "0"  {
                  cell.attchment_Audit.isHidden = true
                  
              }else{
                  if audit.attachCount == nil  {
                      cell.attchment_Audit.isHidden = true
                  }else{
                      
                      cell.attchment_Audit.isHidden = false
                      cell.attchment_Audit.image =  UIImage.init(named: "icons8@-attech")
                      
                  }
                  
              }
              
              
              if let auditID = audit.audId {
                  cell.name.text = "\(audit.label != nil ? audit.label! : "Apl\(auditID)" )"
              }
              
              
              var address = ""
              if let adr = audit.adr {
                  if adr != "" {
                      address = "\(adr)"
                  }
              }
              
              
              if  address != "" {
                  cell.taskDescription.attributedText =  lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
              }else{
                  cell.taskDescription.text = ""
              }
              
              if audit.schdlStart != "" {
                  let tempTime = convertTimestampToDate(timeInterval: audit.schdlStart!)
                  cell.time.text = tempTime.0
                  cell.timeAMPM.text = tempTime.1
                  
              } else {
                  cell.time.text = ""
                  cell.timeAMPM.text = ""
              }
              
              
              //temp code // if status are nil .... taskStatusTypeAudit
              
              if let statusValue = audit.status {
                  if statusValue != "" {
                      let status =
                      taskStatusAudit(taskType: taskStatusTypeAudit(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)!)     //taskStatus(taskType: taskStatusType(rawValue: Int(job.status! == "0" ? "1" : job.status!)!)!)
                      
                      if taskStatusTypeAudit(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)! == taskStatusTypeAudit.InProgress{
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
                  }else{
                      cell.status.text = ""
                      cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                      cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                      cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                      cell.statusImage.image  = nil
                  }
              }else{
                  cell.status.text = ""
                  cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                  cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                  cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                  cell.statusImage.image  = nil
              }
              
              
              
              //if user add job in OFFLINE mode and job not sync on the server
              let ladksj  = audit.audId!.components(separatedBy: "-")
              if ladksj.count > 0 {
                  let tempId = ladksj[0]
                  if tempId == "Job" {
                      cell.imgEquipment.isHidden = true
                      cell.attchment_Audit.isHidden = true
                      cell.name.textColor = UIColor.lightGray
                      cell.time.textColor = UIColor.lightGray
                      cell.timeAMPM.textColor = UIColor.lightGray
                      cell.status.textColor = UIColor.lightGray
                      cell.taskDescription.textColor = UIColor.red
                      cell.taskDescription.text = LanguageKey.audit_not_sync
                      cell.isUserInteractionEnabled = false
                  }else{
                      
                      if audit.status != "7"{
                          cell.name.textColor =  UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                          //cell.lblTitle.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
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
              
              var on = "Off"
              UserDefaults.standard.set(on, forKey: "partView_H")
              
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
              
              if isAuditData{
              // remark
              performSegue(withIdentifier: "remark", sender: self)

              }else {
              performSegue(withIdentifier: "ShowAuditTab", sender: self)
              }
              
              //Get Job ID
              let dict = self.arrOfFilterDict1[indexPath.section]
              let firstKey = Array(dict.keys)[0] // or .first
              let arr = dict[firstKey]
              let quote = arr![indexPath.row]
              selectedAuditID = quote.audId
              
              
              let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
              
              if quote.status != "7" {
                  previousInProgress = false
                  cell.leftBaseView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
              }else{
                  previousInProgress = true
              }
              self.selectedCell = indexPath
              cell.rightView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
      
          }
          
      
          func resetFilterOptions() -> Void {
              searchTxt = ""
              
               self.clearFilterChips()
              
              self.selectedStatus = []
              self.selectedDateRange = nil
              self.customEndDate = nil
              self.customStartDate = nil
          }
       
       @IBAction func btnPressedSort(_ sender: UIButton) {
       }
       
       @IBAction func btnResetForFilter(_ sender: Any) {
    
                
       }
       
       @IBAction func filterBtn(_ sender: Any) {
       }
       
       @IBAction func tapOnSelectedSortButton(_ sender: UIButton) {
           
       }
          
          @IBAction func pressedResetButton(_ sender: Any) {
              searchVw_H.constant = 0.0
              UIView.animate(withDuration: 0.5){
                  self.view.layoutIfNeeded()
              }
              resetFilterOptions()
              getAuditListService()
          }
          
          func clearFilterChips() -> Void {
              
          }
          
          //===============================
          // MARK:- Data - Passing method
          //===============================
          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              
              if isAuditData == true {
                  // let barcodeValue = UserDefaults.standard.value(forKey: "barcodeString") as! String
                  //CommonClass.shared.auditEquipment(barcodeString: barcodeValue, arrOfData: [AuditOfflineList])
                  if segue.identifier == "remark" {
                      if let indexPath = tableView.indexPathForSelectedRow {
                          // var dict1 = equipmentData[indexPath.section]
                          // let firstKey1 = Array(dict1.keys)[0] // or .first
                          // var arr = dict1[firstKey1]
                          //let data = equipmentData[indexPath.row]
                          
                          jobTabVc = (segue.destination as! RemarkVC)
                          
                          // var data = equipmentData[indexPath.row]
                          jobTabVc!.equipment = CommonClass.shared.equipmentData[indexPath.section]
                          
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
              else if segue.identifier == "ShowAuditTab" {
                  
                  
                  
                  if notificationData == true {
                      jobTabVC = (segue.destination as! AuditTabController)
                      //  filterDataFromDB()
                      var ss = APP_Delegate.auditNotiRes
                      let quote = self.arrOFUserData1.filter({$0.label == ss})
                      jobTabVC!.jobs = arrOFUserData1
                      
                      jobTabVC!.objOfUserJobList = quote[0]
                      jobTabVC!.callback = {(isDelete : Bool, object : NSManagedObject) -> Void in
                          if isDelete{
                              DispatchQueue.main.async {
                                  //                arr?.remove(at: indexPath.row)
                                  //                dict[firstKey] = arr
                                  //                self.arrOfFilterDict1[indexPath.section] = dict
                                  
                                  
                                  self.isAdded = true
                                  self.isChanged = false
                                  
                                  //self.getJobListFromDB()
                                  
                                  self.jobTabVC!.navigationController?.popViewController(animated: true)
                                  self.jobTabVC = nil
                              }
                          }
                      }
                      
                  }else{
                      if let indexPath = tableView.indexPathForSelectedRow {
                          jobTabVC = (segue.destination as! AuditTabController)
                          var dict = self.arrOfFilterDict1[indexPath.section]
                          let firstKey = Array(dict.keys)[0] // or .first
                          var arr = dict[firstKey]
                          jobTabVC!.jobs = arrOFUserData1
                          
                          jobTabVC!.objOfUserJobList = arr![indexPath.row]
                          jobTabVC!.callback = {(isDelete : Bool, object : NSManagedObject) -> Void in
                              if isDelete{
                                  DispatchQueue.main.async {
                                      arr?.remove(at: indexPath.row)
                                      dict[firstKey] = arr
                                      self.arrOfFilterDict1[indexPath.section] = dict
                                      
                                      
                                      self.isAdded = true
                                      self.isChanged = false
                                      
                                      //self.getJobListFromDB()
                                      
                                      self.jobTabVC!.navigationController?.popViewController(animated: true)
                                      self.jobTabVC = nil
                                  }
                              }
                          }
                      }
                      
                      
                  }
              }else if segue.identifier == "AddAudit" {
                  let addJobVC = segue.destination as! AddAudit
                  addJobVC.callbackForJobVC = {(isBack : Bool) -> Void in
                      self.isAdded = true
                      self.isChanged = false
                      self.getAuditListFromDB()
                  }
              }
          }
          
      func getAuditListFromDB() -> Void {
                 
                 if isAdded {
                     showDataOnTableView(query: nil)
                 }
                 
                 if isChanged {
                     tableView.reloadData()
                     getAuditListService()
                 }
                 
                 isChanged = true
                 isAdded = false
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
              
              let statusData = taskStatusAudit(taskType: filterTitleArray[indexPath.row])
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
                  
                  if status == taskStatusTypeAudit.Accepted.rawValue{
                      str = "status = \(taskStatusTypeAudit.Accepted.rawValue) OR status = \(taskStatusTypeAudit.Travelling.rawValue) OR status = \(taskStatusTypeAudit.Break.rawValue)"
                  }
                  
                  if status == taskStatusTypeAudit.OnHold.rawValue{
                      str = "status = \(taskStatusTypeAudit.OnHold.rawValue)"
                  }
              
                  
                  if query == "" {
                      query = str
                  }else{
                      query = "\(query) OR \(str)"
                  }
              }
              return query
          }
       
          
          //==================================
          // MARK:- Audit LIST Service methods
          //==================================
          func getAuditListService(){
              
              if !isHaveNetowork() {
               // ShowError(message: AlertMessage.networkIssue, controller: windowController)
                
                hideloader()
                getClientListFromDBjob()
                  return
              }
                showLoader()
              var dates = ("","")
              if selectedDateRange != nil{
                  dates = getDateFromStatus(dateRange: selectedDateRange!)
              }
              let param = Params()
              param.compId = getUserDetails()?.compId
              param.usrId = getUserDetails()?.usrId
              param.limit = ContentLimit
              param.index = "0"
              param.search = searchTxt
              param.dtf = dates.0
              param.dtt = dates.1
              param.isCallFromCurrent = "1"
              var dict = param.toDictionary
              dict!["status"] = selectedStatus
              
            
            
              serverCommunicator(url: Service.getAuditList, param: dict) { (response, success) in
                  
                  DispatchQueue.main.async {
                      self.refreshControl.endRefreshing()
                  }
                
                  if(success){
                      let decoder = JSONDecoder()
                      
                      if let decodedData = try? decoder.decode(AuditListResponse.self, from: response as! Data) {
                        
                        killLoader()
                        
                       if decodedData.success == true{
                           
//                           if self.count == 0 {
//                               self.arrOFUserData.removeAll()
//                           }
//
//                           if let auditArry = decodedData.data{
//                                   self.arrOFUserData = auditArry
//                                   self.showDataOnTableView(query: nil)
//
//                           }else{
//                               self.showDataOnTableView(query : "")
//                           }
                        
                        if let arryCount = decodedData.data{
                            if arryCount.count > 0 {
                                
                                self.count += (decodedData.data?.count)!
                                
                                if !self.isUserfirstLogin {
                                    DispatchQueue.main.async {
                                        self.lblNoJob.isHidden =  true 
                                    }
                                    self.saveUserJobsInDataBase(data: decodedData.data!)
                                    
                                    //Request time will be update when data comes otherwise time won't be update
                                    UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getAuditList)
                                    
                                    
                                    self.showDataOnTableView(query: nil) //Show joblist on tableview
                                    
                                }else{
                                    self.saveAllUserJobsInDataBase(data: decodedData.data!)
                                }
                            }else{
                                if self.arrOFUserData1.count == 0{
                                    
                                    // self.tableView_job.reloadData()
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                    DispatchQueue.main.async {
                                        self.lblNoJob.isHidden = self.arrOFUserData1.count > 0 ? true : false
                                    }
                                    
                                }
                            }
                          
                            
                        }else{
                            
                        }
                        
                        //                                                 if(Int(decodedData.count!) != 0) && (Int(decodedData.count!) != self.count){
                        //                                                     self.getAuditListService()
                        //                                                 }else{
                        //
                        //
                        //                                                     if self.isUserfirstLogin {
                        //
                        //                                                         //Request time will be update when data comes otherwise time won't be update
                        //                                                         UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getAuditList)
                        //
                        //                                                     }
                        //
                        //
                        ////                                                     self.saveAllGetDataInDatabase(callback: { isSuccess in
                        ////                                                         if APP_Delegate.apiCallFirstTime {
                        ////                                                             APP_Delegate.apiCallFirstTime = false
                        ////
                        ////                                                         }else{
                        ////                                                             killLoader()
                        ////                                                         }
                        ////                                                     })
                        //                                                 }
                        
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
                                self.getAuditListService()
                              }
                          })
                      }
                  }else{
                    self.hideloader()
                      ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                          if cancelButton {
                              showLoader()
                              self.getAuditListService()
                          }
                      })
                  }
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
       
       
          func showDataOnTableView(query : String?) -> Void {
               arrOFUserData1 = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: query) as! [AuditOfflineList]
              if arrOFUserData1.count != 0 {
                  self.createSection ()
              }else{
                  DispatchQueue.main.async {
                      if(self.arrOfFilterDict1.count != 0){
                          self.arrOfFilterDict1.removeAll()
                      }
                   
                      self.tableView.reloadData()
                      
                      self.hideloader()

                }
              }
              
//              DispatchQueue.main.async {
//                  self.lblNoJob.isHidden = self.arrOFUserData1.count > 0 ? true : false
//              }
          }
       
           // Barcode Api Service
        
    
       func getEquipmentListFromBarcodeScannerOffline(barcodeString : String) -> Void {

       var equpDataArray = [equipDataArray]()

       let isExistAudit = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: nil) as! [AuditOfflineList]
       if isExistAudit.count > 0 {


       for audit in isExistAudit {
       for item in (audit.equArray as! [AnyObject]) {

       if item["barcode"] as? String == barcodeString
           {
           
           var arrTac = [AttechmentArry]()
           
           if item["attachments"] != nil {
               
               
               if (item["attachments"] is [AnyObject]) && ((item["attachments"] as! [AnyObject]).count > 0) {
                   let attachments =  item["attachments"] as! [AnyObject]
                   for attechDic in attachments {
                       arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
                   }
                   
                   
                   
                   // let dic1 = equipDataArray
                   
                   
                   let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                   
                   //                                                                var supId : String?
                   //                                                                    var supplier : String?
                   //                                                                    var cltId : String?
                   //                                                                    var nm : String?
                   //                                                                    var statusText : String?
                   //                                                                    var category : String?
                   //                                                                    var parentId : String?
                   //                                                                   var ecId : String?
                   //                                                                   var equComponent : [equpComponant]?
                   //                                                                    var notes : String?
                   // equipmentData.append(dic)
                   //equpDataArrayAudit.append(dic)
                   equpDataArray.append(dic)
                   // print(equipmentDic.self)
                   
                   // if let dta = item as? equipData {
                   // }
               }else {
                   let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
                   // equipmentData.append(dic)
                   //equpDataArrayAudit.append(dic)
                   equpDataArray.append(dic)
               }
               
               
           }else{
               
               let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:[], type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
               //
               equpDataArray.append(dic)
           }
           
       }
           
           
       }
       }
           
           
       }


       self.refreshControl.endRefreshing()
       self.arrOFUserData2 = isExistAudit
       self.createSection()




       }
          
          
          //=====================================
          // MARK:- SECTIONS for JOBLIST
          //=====================================
          
          func createSection(){

            
                   var arrOFData = [AuditOfflineList]()
                   var filterDict = [String : [AuditOfflineList]]()
                   var LatestFilterDict  = [[String : [AuditOfflineList]]]()
            
                  var currentDate = ""

                //  self.arrOFUserData1 = self.arrOFUserData1.sorted(by: { ($0.createDate ?? "") > ($1.createDate ?? "") })
                  self.arrOFUserData1 = self.arrOFUserData1.sorted(by: { ($0.schdlStart ?? "") > ($1.schdlStart ?? "") })
                  for  objOfUserData in self.arrOFUserData1{
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
                           self.arrOfFilterDict1 = LatestFilterDict
                           self.tableView.reloadData()
                           self.hideloader()
                      }
          }
          

          @IBAction func collectionEnableBtnTapped(_ sender: UIButton) {

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
        
        
        //=====================================
        // MARK:- save offline  in AuditList
        //=====================================
        
        func saveAllUserJobsInDataBase( data : [AuditListData]) -> Void {
            for job in data{
                //if(job.isdelete != "0"){
                    if (Int(job.status!) != taskStatusTypeAudit.Cancel.rawValue) &&
                        (Int(job.status!) != taskStatusTypeAudit.Reject.rawValue) &&
                        (Int(job.status!) != taskStatusTypeAudit.Closed.rawValue)
                    {
                        let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
                        userJobs?.setValuesForKeys(job.toDictionary!)
                        //DatabaseClass.shared.saveEntity(callback: {_ in
                            
                        //})
                    }
                }
           // }
        }
        
        func saveUserJobsInDataBase( data : [AuditListData]) -> Void {

                 for job in data{
                     let query = "audId = '\(job.audId!)'"
                     let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: query) as! [AuditOfflineList]

                  //  let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
                  //  userJobs?.setValuesForKeys(job.toDictionary!)
                    //DatabaseClass.shared.saveEntity()
                     if isExist.count > 0 {
                         let existingJob = isExist[0]
                         //if Job status Cancel, Reject, Closed so this job is delete from Database

                         if(job.isdelete == "0") {
                             ChatManager.shared.removeJobForChat(jobId: existingJob.audId!)
                             DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                         }else if (Int(job.status!) == taskStatusTypeAudit.Cancel.rawValue) ||
                             (Int(job.status!) == taskStatusTypeAudit.Reject.rawValue) ||
                             (Int(job.status!) == taskStatusTypeAudit.Closed.rawValue)
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
                             if (Int(job.status!) != taskStatusTypeAudit.Cancel.rawValue) &&
                                 (Int(job.status!) != taskStatusTypeAudit.Reject.rawValue) &&
                                 (Int(job.status!) != taskStatusTypeAudit.Closed.rawValue)
                             {
                                 let userJobs = DatabaseClass.shared.createEntity(entityName: "AuditOfflineList")
                                 userJobs?.setValuesForKeys(job.toDictionary!)
                        print(userJobs)
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
                   getClientListFromDBjob()

             }

        func getClientListFromDBjob() -> Void {


                 showDataOnTableView(query : nil)

             }
        
          
      }
      

   
   
