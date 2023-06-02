//
//  CustomFormListV.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 29/04/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class CustomFormListV: UIViewController,OptionViewDelegate {
  
    
    @IBOutlet weak var tblViewCustomForm: UITableView!
    @IBOutlet weak var lblMessageAlert: UILabel!
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
   
    var optionalVw : OptionalView?
    var arrayTypes =  ""
    var templatId = ""
    var jobIdPrint11  = ""
    var templateVelues = ""
    var demoArr11 = ["1","2","3"]
    var fwAr = [Any]()
    var jobIdPrints  = [Any]()
    var JobCardTemplatAr = [JobCardTemplat]()
    var JobCardTemplatArDemo = [CustomFormNmList]()
    var query : String = ""
    var selectedCell : IndexPath? = nil
    var objOfUserJobListInDetail : UserJobList?
    var CustomFormNmListArr = [CustomFormNmList]()
    var objOFTestReplace : TestDetails?
    public  var dataCalbac :(Bool)->() = { _ in }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        JobCardTemplatArDemo = DatabaseClass.shared.fetchDataFromDatabse(entityName: "CustomFormNmList", query: nil) as! [CustomFormNmList]
//
//        var arreayJtid = [String]()
//        var arrOFjit_Id = [jtIdParam]()
//        for jtid in (objOfUserJobListInDetail?.jtId as! [AnyObject]) {
//            let jitIdObj = jtIdParam()
//            jitIdObj.jtId = (jtid as! [String:String])["jtId"]!
//            jitIdObj.title = (jtid as! [String:String])["title"]!
//            arrOFjit_Id.append(jitIdObj)
//            arreayJtid.append((jtid as! [String:String])["jtId"]!)
//        }
//        arreayJtid.append("-1")
//
//        for jtid in arreayJtid{
//            let query1 = "jtId = \(jtid) "
//
//            var formData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "CustomFormNmList", query: query1) as! [CustomFormNmList]
//            CustomFormNmListArr.append(contentsOf: formData)
//        }
        OflineGetFormListInDB()
        
        var isDraftHide : Bool?
        isDraftHide = UserDefaults.standard.value(forKey: "DraftHide") as? Bool
        
        self.title = LanguageKey.title_cutomform
        
        if CustomFormNmListArr.count == 0 {
            self.lblMessageAlert.isHidden = false
            self.lblMessageAlert.text = LanguageKey.no_form_added_for_this_job
        }
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

        NotificationCenter.default.addObserver(self, selector: #selector(Notification1), name: Notification.Name ("CustomFormListV"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        killLoader()
        self.EmailView.isHidden = true
        self.backgoundView.isHidden = true
        tblViewCustomForm.reloadData()
        var isDraftHide : Bool?
        isDraftHide = UserDefaults.standard.value(forKey: "DraftHide") as? Bool
        
    }
    override func viewWillDisappear(_ animated: Bool) {
           isCustomFormListSelected = false 
       }
    
    @objc func Notification1(){
       
        showBackgroundView()
        view.addSubview(EmailView)
        self.EmailView.isHidden = false
        EmailView.center = CGPoint(x: backgoundView.frame.width/2, y: backgoundView.frame.height/2)
        print("tep")
    }
   
    func OflineGetFormListInDB() {
            var arrJobJtIds = [String]()
            var arrAllFromDB = [CustomFormNmList]()
            var arrOfflineForm = [CustomFormNmList]()
            
            for objJobjtids in (objOfUserJobListInDetail?.jtId as! [AnyObject]) {
                arrJobJtIds.append((objJobjtids as! [String:String])["jtId"]!)
            }
            arrJobJtIds.append("-1")
            
            let formData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "CustomFormNmList", query: nil) as! [CustomFormNmList]
            arrAllFromDB.append(contentsOf: formData)
            for obj in arrAllFromDB {
                if let jtId = obj.jtId , jtId != "" {
                    if jtId.contains(",") {
                        let arrJtId = jtId.components(separatedBy: ",")
                        if arrJtId.count > 0 {
                            for objMultiple in arrJtId {
                                for objJobJtIds in arrJobJtIds {
                                    if objMultiple == objJobJtIds {
                                        arrOfflineForm.append(obj)
                                    }
                                }
                            }
                        }
                    } else {
                        for objnew in arrJobJtIds {
                            if objnew == jtId {
                                arrOfflineForm.append(obj)
                            }
                        }
                    }
                }
            }
            
            self.CustomFormNmListArr  = arrOfflineForm.unique{$0.frmId == $1.frmId }
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


extension CustomFormListV : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CustomFormNmListArr.count
       // return APP_Delegate.arrOFCustomForm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formCell") as! CustomFormCell
       // let forms = APP_Delegate.arrOFCustomForm[indexPath.row]
        let forms = CustomFormNmListArr[indexPath.row]
        cell.lblName.text = forms.frmnm
        if selectedCell == indexPath {
            cell.backgroundVw.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        }else{
            cell.backgroundVw.backgroundColor = UIColor.white
        }
        
        cell.selectionStyle  = .none
        cell.draftlbl.isHidden = true
        var isDraftHide : Bool?
        isDraftHide = UserDefaults.standard.value(forKey: "DraftHide") as? Bool
        
        var isDraftgetJobId : String?
        isDraftgetJobId = UserDefaults.standard.value(forKey: "isDraftgetJobId") as? String
        var isDraftfrmId : String?
        isDraftfrmId = UserDefaults.standard.value(forKey: "isDraftJObid") as? String
        
        let jobId = (objOfUserJobListInDetail?.jobId) ?? ""
        let formId = forms.frmId ?? ""
        
        let predicate = "jobId = \(jobId) AND formId = \(formId)"
        let recordCount = DatabaseClass.shared.countTableRecordBy(predicate: predicate, tableName: "CustomFormAnswer")
        if recordCount > 0{
            cell.draftlbl.isHidden = false
        }else{
            cell.draftlbl.isHidden = true
            
        }
        

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (selectedCell != nil) {
            //If selected cell exist on visible indexpaths
            let isExist = tableView.indexPathsForVisibleRows?.contains(selectedCell!)
            if isExist!{
                let cellPrevious = tableView.cellForRow(at: selectedCell!) as! CustomFormCell
                cellPrevious.backgroundVw.backgroundColor = .white
            }
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! CustomFormCell
        cell.backgroundVw.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.selectedCell = indexPath
        
      
        let customFormVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomFormVC") as! CustomFormVC
        if CustomFormNmListArr.count > 0 {
            let objCustomFormNm = CustomFormNmListArr[indexPath.row]
            let objTestDetail = TestDetails()
            objTestDetail.frmId = objCustomFormNm.frmId
            objTestDetail.jtId = objCustomFormNm.jtId
            objTestDetail.frmnm = objCustomFormNm.frmnm
            objTestDetail.event = objCustomFormNm.event
            objTestDetail.tab = objCustomFormNm.tab
            objTestDetail.mandatory = objCustomFormNm.mandatory
            objTestDetail.totalQues = objCustomFormNm.totalQues
            objTestDetail.status_code = objCustomFormNm.status_code
            objTestDetail.jobid = objCustomFormNm.jobid
            customFormVC.objOFTestVC = objTestDetail
            customFormVC.sltNaviCount = 0
            customFormVC.clickedEvent = nil
            customFormVC.isCameFrmStatusBtnClk = true
            customFormVC.objOfUserJobList = self.objOfUserJobListInDetail!
            customFormVC.optionID = "-1"

        }
        
        if !isHaveNetowork() { 
                   let forms = CustomFormNmListArr[indexPath.row]
                   let jobId = (objOfUserJobListInDetail?.jobId) ?? ""
                   let formId = forms.frmId ?? ""
                  
                   let predicate = "jobId = \(jobId) AND formId = \(formId)"
                   let recordCount = DatabaseClass.shared.countTableRecordBy(predicate: predicate, tableName: "CustomFormSubmitStatus")
                   if recordCount > 0{
                       let dialogMessage = UIAlertController(title:LanguageKey.confirm, message: LanguageKey.Form_is_already_submitted, preferredStyle: .alert)
                       let ok = UIAlertAction(title: LanguageKey.yes, style: .default, handler: { [self] (action) -> Void in
                               self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                               self.navigationController?.pushViewController(customFormVC, animated: true)
                       })
                       let cancel = UIAlertAction(title: LanguageKey.no, style: .cancel) { (action) -> Void in
                           
                       }
                       dialogMessage.addAction(ok)
                       dialogMessage.addAction(cancel)
                       self.present(dialogMessage, animated: true, completion: nil)
                       
                   }else{
                       self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                       self.navigationController?.pushViewController(customFormVC, animated: true)
                   }
        }else{
            
            
            let jobId = (objOfUserJobListInDetail?.jobId) ?? ""
            let formId = CustomFormNmListArr[indexPath.row].frmId ?? ""
            let predicate = "jobId = \(jobId) AND formId = \(formId)"
            let recordCount = DatabaseClass.shared.countTableRecordBy(predicate: predicate, tableName: "CustomFormAnswer")
            if recordCount > 0 {
                cell.draftlbl.isHidden = false
                customFormVC.fillingCustomFormFromDraft = true
            } 
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController?.pushViewController(customFormVC, animated: true)
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
//    @objc func customFormSubmitad() {
//        let dialogMessage = UIAlertController(title: "Confirm", message: "Form Is submitad is Allready Do you want Edit", preferredStyle: .alert)
//        let ok = UIAlertAction(title: LanguageKey.yes, style: .default, handler: { [self] (action) -> Void in
//            self.submitad = true
//
//        })
//        let cancel = UIAlertAction(title: LanguageKey.no, style: .cancel) { (action) -> Void in
//            self.submitad = false
//
//        }
//
//        dialogMessage.addAction(ok)
//        dialogMessage.addAction(cancel)
//
//        self.present(dialogMessage, animated: true, completion: nil)
//    }
    
}

extension Array {
    func unique(selector:(Element,Element)->Bool) -> Array<Element> {
        return reduce(Array<Element>()){
            if let last = $0.last {
                return selector(last,$1) ? $0 : $0 + [$1]
            } else {
                return [$1]
            }
        }
    }
}
