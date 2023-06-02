
//
//  ExpenceDetailVC.swift
//  EyeOnTask
//
//  Created by Hemant's mac on 08/05/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class ExpenceDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var expenceHtry: UILabel!
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var desTitle: UILabel!
    @IBOutlet weak var desVw: UILabel!
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var aproveTg: UILabel!
    @IBOutlet weak var aproveImg: UIImageView!
    @IBOutlet weak var amountImg: UIImageView!
    @IBOutlet weak var amountLnl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var jobId: UILabel!
    @IBOutlet weak var expenceNm: UILabel!
    
    
    var expenceDetail = ExpenceDetail()
    var inDetail : Expence?
    var CategoryListStatus = [ExpenceStatus]()
    var isDataLoading:Bool = false
    var pageNo:Int = 1
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        setLocalization()
       
        getExpenseDetail()
         getExpensestatus()
       let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Edit.png"), style: .plain, target: self, action: #selector(logoutUser))
       self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
    }
       
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
         getExpenseDetail()
         getExpensestatus()
            
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
        getExpensestatus()
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
    
    @objc func logoutUser(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Expence", bundle:nil)
          let detailCon = storyBoard.instantiateViewController(withIdentifier: "EditExmence") as! EditExmence
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        detailCon.inDetailExp = expenceDetail
         self.navigationController?.pushViewController(detailCon, animated: true)
    }
    
    func setLocalization() -> Void {
        
        self.navigationItem.title = LanguageKey.expense_details
        expenceHtry .text =  LanguageKey.expense_history
        groupTitle .text =  LanguageKey.expense_group
        desTitle .text =  LanguageKey.expense_description
        //desVw .text =  LanguageKey.audit_not_found
    }

    
    //=========================
      // MARK:- TableView methods
      //=========================
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

                return CategoryListStatus.count

        }
    

       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50.0
       }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell" , for: indexPath) as! ExpenceDetailVCCell
             self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
            let ar = CategoryListStatus[indexPath.row]
             DispatchQueue.main.async {
               
        
                cell.statuslbl.text = dateFormateWithMonthandDayAndYearsShowDay(timeInterval: ((ar.dateTime)!))
           
                
                          if let statusValue = ar.status {
                              if statusValue != "" {
                              let status = expenceStatusDetails(taskType: expenceStatus(rawValue: Int(ar.status  == "0" ? "1" : statusValue)!)!)
                                  cell.name.text = status.0
                                  cell.img.image = status.1
                                      }else{
                                  cell.name.text = nil
                                  cell.img.image = nil
                                }
                        }
            }
             return cell
        }
    
   
    
    
     func getExpensestatus() {
                
    //            if !isHaveNetowork() {
    //                ShowError(message: AlertMessage.networkIssue, controller: windowController)
    //                killLoader()
    //                return
    //            }expId -> Expense Id
                
         let param = Params()
         param.expId = inDetail?.expId
         param.limit = "\(20*pageNo)"
         param.index = "0"
             
                  serverCommunicator(url: Service.getExpenseStatus, param: param.toDictionary) { (response, success) in
                            killLoader()
                            if(success){
                                let decoder = JSONDecoder()
                                if let decodedData = try? decoder.decode(ExpenceStatusResponse.self, from: response as! Data) {
                                    
                                    if decodedData.success == true{
//                                        if let expence = decodedData.data {
                                            
                                            DispatchQueue.main.async {
                                                
                                                
                                                self.CategoryListStatus  = decodedData.data as! [ExpenceStatus]
                                                
                                                
                                                 self.tableVw.reloadData()
                                                //self.dateLbl.text = expence.dateTime
                                                
                                        }

//                                    }else{
//                                        ShowError(message:  getServerMsgFromLanguageJson(key:      decodedData.message!)!, controller: windowController)
//                                    }
                                }else{
                                    
                                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                                }
                            }else{
                                //ShowError(message: "Please try again!", controller: windowController)
                            }
                        }
                        
        }
    
        
    }
     
        //============================
        // MARK:- API method getExpenseDetail
        //=========================
        
        
        func getExpenseDetail() {
            
            if !isHaveNetowork() {
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                killLoader()
                return
            }
            
           showLoader()
           let param = Params()
            param.expId = inDetail?.expId
           
            
              serverCommunicator(url: Service.getExpenseDetail, param: param.toDictionary) { (response, success) in
                        killLoader()
                        if(success){
                            let decoder = JSONDecoder()
                            if let decodedData = try? decoder.decode(ExpenceDetailResponse.self, from: response as! Data) {
                                
                                if decodedData.success == true{
                                    if let expence = decodedData.data {
                                        
                                        DispatchQueue.main.async {
                                             self.expenceDetail = expence
                                             self.expenceNm.text = expence.name
                                             self.group.text = "\(expence.tag == nil ? "" : expence.tagName!)"
                                             self.desVw.text = expence.des
                                             let ap =  expence.amt
                                             self.amountLnl.text = String(format: "%.2f", Float(ap   ?? "0.0") ?? 0.0)
                                             self.categoryLbl.text = "\(LanguageKey.expense_category): \(expence.categoryName!)"
                                             self.dateLbl.text = dateFormateWithMonthandDayAndYearsShowDay(timeInterval: ((expence.dateTime)!))
                                             self.jobId.text = "\(LanguageKey.job_code): \(expence.jobCode!)"
                                           
                                            
                            if let statusValue = expence.status {
                                if statusValue != "" {
                                let status = expenceStatusDetails(taskType: expenceStatus(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)!)
                                        self.aproveTg.text = status.0
                                        self.aproveImg.image = status.1
                                        }else{
                                        self.aproveTg.text = nil
                                        self.aproveImg.image = nil
                                            }
        
                                         }
                                          
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
      }

   
}


class ExpenceDetailVCCell : UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var statuslbl: UILabel!
    
    
}

