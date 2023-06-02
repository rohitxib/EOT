//
//  ExpenceListVC.swift
//  EyeOnTask
//
//  Created by Hemant's mac on 08/05/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class ExpenceListVC: UIViewController, SWRevealViewControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var notFountMsg: UILabel!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var extraButton: UIBarButtonItem!
    @IBOutlet weak var normalSearchView: UIView!
    @IBOutlet weak var advanceFilterview: UIView!
    @IBOutlet weak var normalSearch_H: NSLayoutConstraint!
    @IBOutlet weak var advanceFilter_H: NSLayoutConstraint!
    @IBOutlet weak var txtSearchfield: UITextField!
    @IBOutlet weak var tableExpence: UITableView!
    

    var refreshControl = UIRefreshControl()
    var expences = [Expence]()
    var searchTxt = ""
    var filteredExpence = [[String : [Expence]]]()
    var arrOFData = [Expence]()
    var filterDict = [String : [Expence]]()
    let expencesForFilter : [expenceStatus] = expenceStatus.allCases
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
        showLoader()
        //  notFountMsg.isHidden = true
        setLocalization()
       
        
        advanceFilter_H.constant = 0.0
        normalSearch_H.constant = 0.0
      

        if let revealController = self.revealViewController(){
           revealViewController().delegate = self
           extraButton.target = revealViewController()
           extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
           revealController.tapGestureRecognizer()
       }
        
        
        createDateViseSection()
        
        getExpenceList()
        
        
      
        
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableExpence.addSubview(refreshControl) // not required when using UITableViewController
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     self.navigationItem.title = LanguageKey.title_expence
        
         tableExpence.reloadData()
         self.getExpenceList()
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
        self.getExpenceList()
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
    
       func setLocalization() -> Void {
           self.navigationItem.title = LanguageKey.title_expence
           notFountMsg .text =  LanguageKey.expense_not_found
           txtSearchfield.placeholder = LanguageKey.expense_search_name
    }
    
    
    @objc func refreshControllerMethod() {
        getExpenceList()
        filteredExpence.removeAll()
    
    }
    
    
    func showDataOnTableView(query : String?) -> Void {

             if filteredExpence.count != 0 {
                 self.createSection ()
             }else{
                 DispatchQueue.main.async {
                     if(self.filteredExpence.count != 0){
                        
                        self.arrOFData.removeAll()
                        self.filterDict.removeAll()
                        self.filteredExpence.removeAll()
                     }
                     self.tableExpence.reloadData()
                   

               }
             }
             
             DispatchQueue.main.async {
                 self.notFountMsg.isHidden = self.filteredExpence.count > 0 ? true : false
             }
         }
    
    
  
    //=======================
    // MARK:- Txt Field Delegates
    //========================
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

        if result.count == 0 {
            searchTxt = ""
            self.filteredExpence.removeAll()
             self.getExpenceList()
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

        print ("asdfasdfsadf")
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
         print ("asdfasdfsadf")
        
                DispatchQueue.main.async {
                           if self.normalSearch_H.constant == 0 {
                            self.normalSearch_H.constant = 55.0
                            self.normalSearchView.layoutIfNeeded()
        
                        UIView.animate(withDuration: 0.3, animations: {
                                self.view.layoutIfNeeded()
                          }) { (isComplete) in
        
                              if isComplete {
        self.collectionVw.reloadData()
     
                              }
                          }
        
        
                    }else{
                            self.showDataOnTableView(query: nil)
                            self.normalSearch_H.constant = 0.0
                            self.normalSearchView.layoutIfNeeded()
        
                        UIView.animate(withDuration: 0.3, animations: {
                                self.view.layoutIfNeeded()
                          }) { (isComplete) in
        
                              if isComplete {
        
                              }
                          }
                    }
                }
            }
    
    //=========================
    // MARK:- API methods
    //=========================
    
    
    func getExpenceList() {

        
          if !isHaveNetowork() {
                  ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                  if self.refreshControl.isRefreshing {
                      self.refreshControl.endRefreshing()
                  }
                  return
              }
        
        let param = Params()
        param.jobId = objOfUserJobListInDetail?.jobId
        param.limit = "\(20*pageNo)"
        param.index = "0"
        param.search = searchTxt
        param.apiRequestFrom = "2"
        
        serverCommunicator(url: Service.getExpenseList, param: param.toDictionary) { (response, success) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
        
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ExpenceListResponse.self, from: response as! Data) {
                    if decodedData.success == true {
                        if let totalExpences = decodedData.data{
                            if totalExpences.count > 0 {
                                DispatchQueue.main.async {
                                self.tableExpence.isHidden = false
                                }
                                self.expences = totalExpences
                                self.createSection()
                              
                            }else{
                                killLoader()
                                
                                DispatchQueue.main.async {
                                   
                                     self.filteredExpence.removeAll()
                                     self.tableExpence.reloadData()
                                   
                                        self.notFountMsg.isHidden = self.expences.count > 0 ? true : false
                                        self.tableExpence.isHidden = true
                                }
                                
                               
                            }
                        }
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                        if cancel {
                            showLoader()
                            self.getExpenceList()
                        }
                    })
                }
            }
        }
    }
    
    
    func createDateViseSection() {
        
        
         var currentDate = ""
         self.expences = self.expences.sorted(by: { $0.dateTime! > $1.dateTime! })

        for  expence in self.expences {
            let strDate = dayDifference(unixTimestamp: (expence.dateTime!))

            if(self.filteredExpence.count > 0){
                
                // Below is new change implemented by Hemant
                    if currentDate == strDate {
                        var dictObj = self.filteredExpence.last
                        dictObj![strDate]?.append(expence)
                        self.filteredExpence[self.filteredExpence.count-1] = dictObj!
                    }else{
                        currentDate = strDate
                        self.arrOFData.removeAll()
                        self.filterDict.removeAll()
                        self.arrOFData.append(expence)
                        self.filterDict[strDate] = self.arrOFData
                        self.filteredExpence.append(self.filterDict)
                    }
           }else{
                currentDate = strDate
                self.arrOFData.append(expence)
                self.filterDict[strDate] = self.arrOFData
                self.filteredExpence.append(self.filterDict)
            }
        }

     

                DispatchQueue.main.async {
                    self.tableExpence.reloadData()
                }
                
    }

}



extension ExpenceListVC : UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
      //=========================
      // MARK:- TableView methods
      //=========================
    
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return self.filteredExpence.count
        }
    
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if(self.filteredExpence.count != 0){
                let dict = self.filteredExpence[section]
                let firstKey = Array(dict.keys)[0] // or .first
                let arr = dict[firstKey]
                return arr!.count
            }else{
                return filteredExpence.count
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
           if  self.filteredExpence.count > 0 {
               let dict = self.filteredExpence[section]
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
             
              
              //headerView.addSubview(headerLabel)
              return headerView
          }
          
       
           func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
                  
                      return 30.0
                 
              }
          
          func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return 103.0
          }
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "expenceCell") as! ExpenceListCell
               cell.lblTime.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
               cell.lblExpenceName.textColor =  UIColor(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
               if self.filteredExpence.count > 0 {
                   let dict = self.filteredExpence[indexPath.section]
                        let firstKey = Array(dict.keys)[0] // or .first
                        let arr = dict[firstKey]
                        let expence = arr![indexPath.row]
                       
                       cell.tegImg.isHidden = true
                       cell.lblExpenceName.text = expence.name
                       cell.lblGroupName.text = expence.tag// grupe
                       cell.lblDes.text = expence.des
                       
                      
                       if expence.dateTime != "" {
                              let date = dateFormateWithMonthandDay(timeInterval: expence.dateTime!)
                              let year = dateFormateWithYeatExpense(timeInterval: expence.dateTime!)
                              cell.lblTime.text = date
                              cell.lblAMPM.text = year
                              
                          } else {
                              cell.lblTime.text = ""
                              cell.lblAMPM.text = ""
                       }
                      
                       let pr = expence.amt
                       cell.price.text = String(format: "%.2f", Float(pr  ?? "0.0") ?? 0.0)
                       cell.lblCategory.text = expence.category
                       
                       
                       let ar = expence.category
                       if ar != "" {
                           cell.tegImg.isHidden = false
                       }
                       
                       if let statusValue = expence.status {
                       if statusValue != "" {
                           let status = expenceStatusDetails(taskType: expenceStatus(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)!)
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
        
        let dict = self.filteredExpence[indexPath.section]
                   let firstKey = Array(dict.keys)[0] // or .first
                   let arr = dict[firstKey]
                   let expence = arr![indexPath.row]
         let storyBoard : UIStoryboard = UIStoryboard(name: "Expence", bundle:nil)
         let detailCon = storyBoard.instantiateViewController(withIdentifier: "ExpenceDetailVC") as! ExpenceDetailVC
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        detailCon.inDetail =  expence
        self.navigationController?.pushViewController(detailCon, animated: true)
    }
    

   
    @IBAction func btnSearch(_ sender: Any) {
        
        searchTxt =  trimString(string: txtSearchfield.text!)
           if searchTxt.count > 0 {
               showLoader()
               self.getExpenceList()
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
            let statusData = expenceStatusDetails(taskType: expencesForFilter[indexPath.row])
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
        
        self.filteredExpence.removeAll()
        var arrOFData = [Expence]()
        var filterDict = [String : [Expence]]()
        var LatestFilterDict  = [[String : [Expence]]]()
        
        var currentDate = ""
        
        var expenceList = [Expence]()
        
        if selectedExpencesforFilter.count > 0 && self.expences.count > 0 {
            expenceList =  self.expences.filter({selectedExpencesforFilter.contains(Int($0.status!)!)})
            expenceList = expenceList.sorted(by: { ($0.dateTime ?? "") > ($1.dateTime ?? "") })
        }else{
            expenceList = self.expences.sorted(by: { ($0.dateTime ?? "") > ($1.dateTime ?? "") })
        }
        
        
        for  objOfUserData in expenceList {
            let strDate = dayDifference(unixTimestamp: objOfUserData.dateTime ?? "")
            
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
            self.filteredExpence = LatestFilterDict
            self.tableExpence.reloadData()
            killLoader()
        }
    }
             
}

