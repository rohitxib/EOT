//
//  HistoryVC.swift
//  EyeOnTask
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,OptionViewDelegate{
    
  
    
    @IBOutlet var table_view: UITableView!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet var backgoundView: UIView!
    @IBOutlet weak var DefaultJobCrdView: UIView!
    @IBOutlet weak var SelectSingnatureView: UIView!
    @IBOutlet weak var EmailJobCrdView: UIView!
    @IBOutlet weak var PrntJobCardView: UIView!
    @IBOutlet weak var EmailJobLbl: UILabel!
    @IBOutlet weak var SelectTemplatetxtfild: FloatLabelTextField!
    @IBOutlet weak var SelectSingnaturetxtfied: FloatLabelTextField!
    @IBOutlet weak var PrintJobLbl: UILabel!
    var objOfUserJobListInDetail : UserJobList?
    var arrOfShowData = [HistoryResDetails]()
    var jobStatusArr = [JobStatusList]()
    var globelImg:UIImage? = nil

    var PurchaseOrderArrList1 = [PurchaseOrderList]()
    var optionalVw : OptionalView?
    var arrayTypes =  ""
    var templatId = ""
    var jobIdPrint11  = ""
    var templateVelues = ""
    var demoArr11 = ["1","2","3"]
    var fwAr = [Any]()
    var jobIdPrints  = [Any]()
    var JobCardTemplatAr = [JobCardTemplat]()
    var query : String = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
 self.jobStatusArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
        getJobCardTemplates()
        
        self.EmailView.isHidden = true
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
       
        let fildW = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: query) as! [FieldWorkerDetails]
        for fw in fildW {
            fwAr.append(("\(String(describing: fw.fnm!)) \(String(describing: fw.lnm!))"))
            jobIdPrints.append(("\(String(describing: fw.usrId!))"))
            self.SelectSingnaturetxtfied.text = ("\(String(describing: fw.fnm!)) \(String(describing: fw.lnm!))")
            
        }

        self.title = LanguageKey.title_history
    
        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobHistory)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationResive), name: Notification.Name ("HistoryVC"), object: nil)
        
       
      
        
    }
    @objc func NotificationResive(){
        
        showBackgroundView()
        view.addSubview(EmailView)
        self.EmailView.isHidden = false
        EmailView.center = CGPoint(x: backgoundView.frame.width/2, y: backgoundView.frame.height/2)
       // print("tep")
    }
   
    
    func showBackgroundView() {
        self.backgoundView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.backgoundView.backgroundColor = UIColor.black
            self.backgoundView.alpha = 0.5
        })
    }
    func removeOptionalView(){
        if optionalVw != nil {
            self.optionalVw?.removeFromSuperview()
            self.optionalVw = nil
        }
    }
    func hideBackgroundView() {
        if ((optionalVw) != nil){
            removeOptionalView()
        }
        if (EmailView != nil) {
            EmailView.removeFromSuperview()
        }
        
        self.backgoundView.isHidden = true
        self.backgoundView.backgroundColor = UIColor.clear
        self.backgoundView.alpha = 1
    }
    @IBAction func SelectTemplatebtn(_ sender: UIButton) {
        arrayTypes = "2"
        self.forDefaultJobCrdOpenDwopDown()

    }
    
    @IBAction func SelectSingnaturebtn(_ sender: UIButton) {
        
        arrayTypes = "1"
        self.foSelectSingnatureOpenDwopDown()
    }
    
    @IBAction func EmailJobBtn(_ sender: Any) {
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        self.backgoundView.isHidden = false
        self.EmailView.isHidden = true
        ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoiceEmail)
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EMAILINVOICE") as! EmailInvoiceVC
        vc.isJobDetail = true
        vc.jobIdDetail = objOfUserJobListInDetail?.jobId as! String
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func PrintJobBtn(_ sender: Any) {
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        self.backgoundView.isHidden = false
        self.EmailView.isHidden = true
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pdfvc") as! ShowPdfVC
        vc.pdfDetailJob = true
        vc.pdfDetailJobId =  objOfUserJobListInDetail?.jobId as! String
        vc.jobIdLabel = objOfUserJobListInDetail?.label as! String
        vc.templateIdPrint = templatId
        vc.jobIdForPrint = jobIdPrint11
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
    
    }
    
    @IBAction func topOnbackgud(_ sender: Any) {
        hideBackgroundView()
       
    }
    
    
    @IBAction func butten(_ sender: Any) {
        showBackgroundView()
        view.addSubview(EmailView)
        EmailView.center = CGPoint(x: backgoundView.frame.width/2, y: backgoundView.frame.height/2)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        GetHistoryList()
       
        
        self.EmailView.isHidden = true
        //self.PrntJobCardView.isHidden = true
        self.backgoundView.isHidden = true
        
        self.tabBarController?.navigationItem.title = LanguageKey.title_history
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = true
            button.tintColor = UIColor.white
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayTypes == "1" {
            return fwAr.count
        }else if self.arrayTypes == "2" {
            return JobCardTemplatAr.count
        }
        return jobIdPrints.count
        
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"cell")
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier:"cell")
        }
        if self.arrayTypes == "1" {
            if demoArr11.count != 0 {
                var ar = jobIdPrints[indexPath.row] as! String
                cell?.textLabel?.text = fwAr[indexPath.row] as! String
            }
        }else if self.arrayTypes == "2" {
            if fwAr.count != 0 {
                cell?.textLabel?.text = JobCardTemplatAr[indexPath.row].tempJson1?.clientDetails![0].inputValue
            }
            
        }
        
        
        return cell!
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrayTypes == "1" {
            self.SelectSingnaturetxtfied.text = fwAr[indexPath.row] as! String
            self.jobIdPrint11 = jobIdPrints[indexPath.row] as! String
            self.removeOptionalView()
         
           
        }else if self.arrayTypes == "2" {
            self.SelectTemplatetxtfild.text = JobCardTemplatAr[indexPath.row].tempJson1?.clientDetails![0].inputValue
            self.templatId = JobCardTemplatAr[indexPath.row].jcTempId ?? ""
            self.removeOptionalView()
          
        }
        
    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfShowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoryCell
                
        let historyResDetails = arrOfShowData[indexPath.row]
        
       // let status = taskStatus(taskType: taskStatusType(rawValue: Int(historyResDetails.status! == "0" ? "1" : historyResDetails.status!)!)!)
        
        if historyResDetails.status == "1" {
            cell.imgView_Status.image = UIImage(named: "New_Task")
        }  else if historyResDetails.status == "2" {
            cell.imgView_Status.image = UIImage(named: "Accepted_task")
        } else if historyResDetails.status == "3" {
            cell.imgView_Status.image = UIImage(named: "Rejected_task")
        } else if historyResDetails.status == "4" {
            cell.imgView_Status.image = UIImage(named: "cancel_task")
        } else if historyResDetails.status == "5" {
            cell.imgView_Status.image = UIImage(named: "Travelling_task")
        } else if historyResDetails.status == "6" {
            cell.imgView_Status.image = UIImage(named: "break_task")
        } else if historyResDetails.status == "7" {
            cell.imgView_Status.image = UIImage(named: "In_progress_task")
        } else if historyResDetails.status == "8" {
            cell.imgView_Status.image = UIImage(named: "job_break")
        } else if historyResDetails.status == "9" {
            cell.imgView_Status.image = UIImage(named: "Complete_task")
        } else if historyResDetails.status == "10" {
            cell.imgView_Status.image = UIImage(named: "closed_task")
        } else if historyResDetails.status == "11" {
            cell.imgView_Status.image = UIImage(named: "whiteMulti_task")
        } else if historyResDetails.status == "12" {
            cell.imgView_Status.image = UIImage(named: "Pending_task")
        }else{
            if ( historyResDetails.status != "1") ||  ( historyResDetails.status != "2") || ( historyResDetails.status != "3") || ( historyResDetails.status != "4") || ( historyResDetails.status != "5") || ( historyResDetails.status != "6") || ( historyResDetails.status != "7") || ( historyResDetails.status != "8") || ( historyResDetails.status != "9") ||  ( historyResDetails.status != "10") || ( historyResDetails.status != "11") || ( historyResDetails.status != "12"){
                for arr in jobStatusArr {
                    if arr.id ==  historyResDetails.status {
                       
                        if arr.url != "" &&  arr.url != nil {
                            DispatchQueue.global().async { [weak self] in
                            let ar = URL(string: Service.BaseUrl)?.absoluteString
                            let ab = arr.url
                            if let data = try? Data(contentsOf: URL(string: ar! + ab!)!) {
                                if let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        cell.imgView_Status.image = image
                                    }
                                }
                            }
                        }
                        }else{
                            cell.imgView_Status.image = UIImage(named: "")
                        }
                   
                    }
                }
            } else{
                cell.imgView_Status.image = UIImage(named: "")
            }
       
        }
        
   
        
        if(indexPath.row % 2 == 0){
            
            if historyResDetails.referencebyType == "1"{
                cell.lbl_1.text = historyResDetails.referencebyName
            }else{
                cell.lbl_1.text = historyResDetails.referencebyName! + " (A)"
            }
            
            
            // cell.lbl_2.text = dateFormateWithMonthandDayAndYears(timeInterval: historyResDetails.time!)
            
            cell.lbl_2.text = dateFormateWithMonthandDayAndYearsShowDayAndTime(timeInterval: historyResDetails.time!)
            
            for arr in jobStatusArr {
                if arr.id == historyResDetails.status {
                    cell.lbl_LeftStatus.text = arr.text
                }
            }
            
           // cell.lbl_LeftStatus.text = statusText
            cell.lbl_1.isHidden = false
            cell.lbl_2.isHidden = false
            cell.lbl_LeftStatus.isHidden = false
            cell.lbl_3.isHidden = true
            cell.lbl_4.isHidden = true
            cell.lbl_RightStatus.isHidden = true
        }else{
            cell.lbl_1.isHidden = true
            cell.lbl_2.isHidden = true
            cell.lbl_LeftStatus.isHidden = true
            cell.lbl_3.isHidden = false
            cell.lbl_4.isHidden = false
            cell.lbl_RightStatus.isHidden = false
            
            if historyResDetails.referencebyType == "1"{
                cell.lbl_3.text = historyResDetails.referencebyName
            }  else {
                cell.lbl_3.text = historyResDetails.referencebyName! + " (A)"
            }
            
            //cell.lbl_3.text = historyResDetails.name
            //cell.lbl_4.text = dateFormateWithMonthandDayAndYears(timeInterval: historyResDetails.time!)
            
            cell.lbl_4.text = dateFormateWithMonthandDayAndYearsShowDayAndTime(timeInterval: historyResDetails.time!)
            for arr in jobStatusArr {
                if arr.id == historyResDetails.status {
                    cell.lbl_RightStatus.text = arr.text
                }
            }
            
           // cell.lbl_RightStatus.text = statusText

        }
        
       
        
        return cell
    }
    func load(url:  URL ) {
                   DispatchQueue.global().async { [weak self] in
                       if let data = try? Data(contentsOf: url) {
                           if let image = UIImage(data: data) {
                               DispatchQueue.main.async {
                                   self?.globelImg = image
                               }
                           }
                       }
                   }
               }
    // ================================
    //  MARK: Open Drop Down jobcard
    // ================================
    func foSelectSingnatureOpenDwopDown() {

        if (optionalVw == nil){
            self.backgoundView.isHidden = false
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = SelectSingnatureView.convert(SelectSingnatureView.bounds, from: self.view)
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
            self.backgoundView.isHidden = false
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = DefaultJobCrdView.convert(DefaultJobCrdView.bounds, from: self.view)
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
   
    //==============================
    // MARK:- Get Task Status Image
    //==============================
    func taskStatus(taskType : taskStatusType) -> (String, UIImage){
        switch taskType {
        case .New:
            return ( "New Task",UIImage(named: "New_Task")!)
        case .Accepted:
            return ( "Accepted Task",UIImage(named: "Accepted_task")!)
        case .Reject:
            return ( "Reject Task",UIImage(named: "Rejected_task")!)
        case .Cancel:
            return ( "Cancel Task",UIImage(named: "cancel_task")!)
        case .Travelling:
            return ( "Travelling Task",UIImage(named: "Travelling_task")!)
        case .Break:
            return ( "Break Task",UIImage(named: "break_task")!)
        case .InProgress:
            return ( "In Progress Task",UIImage(named: "In_progress_task")!)
        case .OnHold:
            return ( "On Hold Task",UIImage(named: "Pending_task")!)
        case .Completed:
            return ( "Completed Task",UIImage(named: "Complete_task")!)
        default:
            return ( "Closed Task",UIImage(named: "closed_task")!)
        }
    }
    
    func GetHistoryList() -> Void {
       
        if !isHaveNetowork() {
            return
        }
        
        showLoader()
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.usrId = getUserDetails()?.usrId
        param.jobId = objOfUserJobListInDetail?.jobId
        param.limit = "50"
        param.index = "0"
        
        serverCommunicator(url: Service.JobStatusHistory , param: param.toDictionary) { (response, success) in
            
            killLoader()
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(HistoryResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            if( decodedData.data.count > 0){
                                let obj = decodedData.data[0]
                                if (obj.jobid != nil && obj.jobid != ""){ //Only For Remove job when Admin Unassign job for FW
                                    var dict = [String : Any]()
                                     dict["data"] = [ "status_code" : obj.status_code! ,
                                                 "jobid" : obj.jobid!]
                                    NotiyCenterClass.fireJobRemoveNotifier(dict: (dict))
                                    self.tabBarController?.navigationController?.popToRootViewController(animated: true)

                                }else{
                                    self.arrOfShowData = decodedData.data
                                    self.table_view.reloadData()
                                }
                            }
                        }
                    }else{
                        if let code =  decodedData.statusCode{
                            if(code == "401"){
                                ShowAlert(title:  getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                    if (Ok){
                                        DispatchQueue.main.async {
                                            (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                        }
                                    }
                                })
                            }
                        }else{
                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                      
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
                
            }else{
               ShowError(message: errorString, controller: windowController)
            }
        }
        
        
        
    }
    
    func getJobCardTemplates(){

        let param = Params()
       
        param.limit = "120"
        
        serverCommunicator(url: Service.getJobCardTemplates, param: param.toDictionary) { (response, success) in
               killLoader()
               if(success){
                   let decoder = JSONDecoder()
                   if let decodedData = try? decoder.decode(JobCardTemplatesRs.self, from: response as! Data) {
                       
                       if decodedData.success == true{
                           
                           self.JobCardTemplatAr = decodedData.data as! [JobCardTemplat]
                           DispatchQueue.main.async {
                               let arr = self.JobCardTemplatAr[0]
                            //   print( "\(String(describing: arr.tempJson1?.clientDetails![0].inputValue ?? ""))")
                               
                               self.templateVelues = "\(String(describing: arr.tempJson1?.clientDetails![0].inputValue ?? ""))"
                               self.SelectTemplatetxtfild.text =  self.templateVelues
                             //  self.txtFldInvoiceTmplt.text = self.templateVelue
                               self.templatId = arr.jcTempId ?? ""
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
   

}
