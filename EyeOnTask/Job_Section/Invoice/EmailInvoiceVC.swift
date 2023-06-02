//
//  EmailInvoiceVC.swift
//  EyeOnTask
//
//  Created by Mac on 30/04/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class EmailInvoiceVC: UIViewController,OptionViewDelegate{
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var to_TxtFld: FloatLabelTextField!
    @IBOutlet weak var cc_TxtFld: FloatLabelTextField!
    @IBOutlet weak var sub_TxtFld: FloatLabelTextField!
    @IBOutlet weak var msg_TxtView: UITextView!
    @IBOutlet weak var txtFldInvoiceTmplt: UITextField!
    var arrOfShowData = [JobCardTemplat]()
    var isdidSelect : Bool!
    var isSelect : Bool!
    var optionalVw : OptionalView?
    var sltDropDownTag : Int!
    let cellReuseIdentifier = "cell"
    var arr = ["a","b","c"]
    var arr1 = ["a","b"]
    var arr2 = ["a","b","c","d"]
    
    var JobCardTemplatArr = [JobCardTemplat]()
    var InvoiceTemplateArr = [JobCardTemplat1]()
    var QuotaTemplateArr = [JobCardTemplat2]()
    var templateVelue = ""
    
    var templateId = ""
    var isInvoice = true
    var isJobDetail = false
    var invoiceid = String()
    var emailRes = EmailInvoiceResponse()
    var emailResStrp = stripLinkData()
    var pdfDetailAppoinmentarr = [String]()
    var  pdfDetailAppoinment = false
    // vc.pdfDetailAppoinmentarr = itemValue
    var str = ""
    var jobIdDetail = ""
    var selectJobId = ""
    var selectJobName = ""
    var  att = ""
    var jobIdDetailPDF = ""
    var arrayType =  ""
    var arrayTypeBool : Bool = false
    var jobIdForPrint = ""
             // vc.appId = appintDetainsDicCommon?.commonId ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isJobDetail == true {
            
            
            self.arrayType = "1"
            getJobCardTemplates()
            generateJobCardPDF()
            getJobCardEmailTemplate()
            self.title = "Job Email" //LanguageKey.email_document
            sub_TxtFld.placeholder = LanguageKey.subject
            to_TxtFld.placeholder = LanguageKey.to
            cc_TxtFld.placeholder = LanguageKey.cc
            lblMessage.text = LanguageKey.message
        }else {
            if pdfDetailAppoinment == true {
                self.arrayType = "2"
                getQuotaTemplates()
                getPdfAppoinmentpath()
                getJobDocEmailTemplate()
                self.title = LanguageKey.email_document
                sub_TxtFld.placeholder = LanguageKey.subject
                to_TxtFld.placeholder = LanguageKey.to
                cc_TxtFld.placeholder = LanguageKey.cc
                lblMessage.text = LanguageKey.message
                
            }else{
                if arrayTypeBool == true {
                    self.arrayType = "2"
                    getQuotaTemplates()
                    self.title = isInvoice ? LanguageKey.email_invoice : LanguageKey.email_quote
                    sub_TxtFld.placeholder = LanguageKey.subject
                    to_TxtFld.placeholder = LanguageKey.to
                    cc_TxtFld.placeholder = LanguageKey.cc
                    lblMessage.text = LanguageKey.message
                    getInvoiceRecord()
                }else{
                    arrayTypeBool = false
                    self.arrayType = "3"
                    getInvoiceTemplates()
                    self.title = isInvoice ? LanguageKey.email_invoice : LanguageKey.email_quote
                    sub_TxtFld.placeholder = LanguageKey.subject
                    to_TxtFld.placeholder = LanguageKey.to
                    cc_TxtFld.placeholder = LanguageKey.cc
                    lblMessage.text = LanguageKey.message
                    getInvoiceRecord()
                }
            }
            
            
            
        }
       // print(isInvoice)
        
    }
    
    @objc func addTapped(){
        
        let  trimmedUserNmStr  = to_TxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let  trimmedUserMsg  = msg_TxtView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let  trimmedUserSub  = sub_TxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       // let  trimmedUsercc = cc_TxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isValidEmail(testStr: trimmedUserNmStr!)  {
        //  if isValidEmail(testStr: trimmedUserCc!) {
            if trimmedUserNmStr != "" {
                self.to_TxtFld.resignFirstResponder()
                if trimmedUserSub != "" {
                    self.sub_TxtFld.resignFirstResponder()
                   if trimmedUserMsg != "" {
                       self.msg_TxtView.resignFirstResponder()
                
                    if isJobDetail == true{
                        
                        sendJobCardEmailTemplate()
                    }else {
                        if pdfDetailAppoinment == true {
                            sendJobDocEmailTemplate()
                        }else{
                            self.sendInvoiceEmailTemplate()
                        }
                        
                    }
                       
                       
                   }  else{
                    
                    ShowAlert(title: "", message: AlertMessage.message, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
                  }
                    
                } else{
                    ShowAlert(title: "", message: AlertMessage.subject, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
                }
            }
             else{
                
                ShowAlert(title: "", message: AlertMessage.userId, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
              }
                
                
       //  } else{
       //          ShowAlert(title: "", message: AlertMessage.validEmailid, controller: self, cancelButton: "OK", okButton: nil, style: .alert, callback: {_,_ in})
       //     }
                
                
        } else{
            ShowAlert(title: "", message: trimmedUserNmStr != "" ? AlertMessage.validEmailid : AlertMessage.userId, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
        }
        
        
    }
   override func viewWillAppear(_ animated: Bool) {
       navigationController?.setNavigationBarHidden(false, animated: animated)
    let image = UIImage(named:"send_icon-1")
    let leftButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
    self.navigationItem.rightBarButtonItem = leftButton
    
    }
  
    
    func getPdfAppoinmentpath() -> Void {
              
              let param = Params()
              
             //             let param = Params()
             //            param.jobId = objOfUserJobListInDetail?.jobId
             //           // param.documentId = []
             //            param.moduleType =  "2"
           
                  param.jobId =  str
                  param.documentId =  pdfDetailAppoinmentarr
                  param.moduleType =  "2"
              
              
              let url = Service.generateJobDocumentPDF
              
              serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
                  if success {
                      let decoder = JSONDecoder()
                      if let decodedData = try? decoder.decode(PdfResponse.self, from: response as! Data) {
                          
                          if decodedData.success! {
                            self.att =  decodedData.data!.path!
//                              saveFileInDocumentDirectory(url: url, fileName: ".pdf")
//                              DispatchQueue.main.async {
//                                  self.webView.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
//                              }
                          }
                      }
                  }
              }
          }
    
     func generateJobCardPDF() -> Void {
                  
         let param = Params()
         
         //             let param = Params()
         //            param.jobId = objOfUserJobListInDetail?.jobId
         //           // param.documentId = []
         //            param.moduleType =  "2"
         
         param.jobId =  jobIdDetail
         // param.documentId =  pdfDetailAppoinmentarr
         // param.moduleType =  "2"
         param.techId = jobIdForPrint
         
         param.tempId = selectJobId
         
         let url = Service.generateJobCardPDF
                  
                  serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
                      if success {
                          let decoder = JSONDecoder()
                          if let decodedData = try? decoder.decode(PdfResponse.self, from: response as! Data) {
                              
                              if decodedData.success! {
                                self.jobIdDetailPDF =  decodedData.data!.path!
    //                              saveFileInDocumentDirectory(url: url, fileName: ".pdf")
    //                              DispatchQueue.main.async {
    //                                  self.webView.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
    //                              }
                              }
                          }
                      }
                  }
              }

    //======================================================
    // MARK:- getInvoiceEmailTemplate
    //======================================================
    
    func getInvoiceRecord() {

        showLoader()
        let param = Params()
        param.compId = getUserDetails()?.compId
        
        if isInvoice {
            param.invId =  invoiceid
            param.isProformaInv = "0"
        }else{
            param.quotId =  invoiceid
        }
        
        let url = isInvoice ? Service.getInvoiceEmailTemplate : Service.getQuotationEmailTemplate
        
        serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
                        killLoader()
                        if(success){
                            let decoder = JSONDecoder()
                            if let decodedData = try? decoder.decode(EmailInvoiceResponse.self, from: response as! Data) {
            
                                if decodedData.success == true{
            
                                    self.emailRes = decodedData
                                    
                                    let html = self.emailRes.data?.message
                                    let data = Data(html!.utf8)
                                    
                                    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil) {
                                      
                                     DispatchQueue.main.async {
                                        self.msg_TxtView.attributedText = attributedString
                                        self.sub_TxtFld.text = self.emailRes.data?.subject
                                        self.to_TxtFld.text = self.emailRes.data?.to
                                    }
                                   }
                               }
                            }else{
            
                                ShowError(message: AlertMessage.formatProblem, controller: windowController)
                            }
                        }else{
                            //ShowError(message: "Please try again!", controller: windowController)
                        }
                    }
               }
    
      
        
        func getJobDocEmailTemplate() {
   
            showLoader()
            let param = Params()
            param.jobId = str
            
//            if isInvoice {
//                param.invId =  invoiceid
//            }else{
//                param.quotId =  invoiceid
//            }
            
            let url =  Service.getJobDocEmailTemplate
            
            serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
                            killLoader()
                            if(success){
                                let decoder = JSONDecoder()
                                if let decodedData = try? decoder.decode(EmailInvoiceResponse.self, from: response as! Data) {
                
                                    if decodedData.success == true{
                
                                        self.emailRes = decodedData
                                        
                                        let html = self.emailRes.data?.message
                                        let data = Data(html!.utf8)
                                        
                                        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil) {
                                          
                                         DispatchQueue.main.async {
                                            self.msg_TxtView.attributedText = attributedString
                                            self.sub_TxtFld.text = self.emailRes.data?.subject
                                            self.to_TxtFld.text = self.emailRes.data?.to
                                        }
                                       }
                                   }
                                }else{
                
                                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                                }
                            }else{
                                //ShowError(message: "Please try again!", controller: windowController)
                            }
                        }
                   }
    
    func getJobCardEmailTemplate() {
        
        //        "invId -> Invoice Id
        //        compId -> Company Id"
        showLoader()
        let param = Params()
        param.jobId = jobIdDetail
        param.techId = jobIdForPrint
        param.tempId = selectJobId
        //            if isInvoice {
        //                param.invId =  invoiceid
        //            }else{
        //                param.quotId =  invoiceid
        //            }
        
        let url =  Service.getJobCardEmailTemplate
        
        serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(EmailInvoiceResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        self.emailRes = decodedData
                        
                        let html = self.emailRes.data?.message
                        let data = Data(html!.utf8)
                        
                        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil) {
                            
                            DispatchQueue.main.async {
                                self.msg_TxtView.attributedText = attributedString
                                self.sub_TxtFld.text = self.emailRes.data?.subject
                                self.to_TxtFld.text = self.emailRes.data?.to
                            }
                        }
                    }
                }else{
                    
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    @IBAction func selectInvTemplate(_ sender: UIButton) {
        self.sltDropDownTag = sender.tag
        switch  sender.tag {
        case 0:
            
            if(self.optionalVw == nil){
                
                //  arrOfShowData = getJson(fileName: "location")["Server_location"] as! [Any]
                self.openDwopDown( txtField: self.txtFldInvoiceTmplt, arr: arr)
                
            }else{
                self.removeOptionalView()
            }
            
            break
            
            
        default:
          //  print("Defalt")
            break
            
        }
        
    }
    
    func sendInvoiceEmailTemplate() {
        
        
        let mailString = self.msg_TxtView.text.replacingOccurrences(of: "\n", with: "<br>")
        
        showLoader()
        let param = Params()
        param.message = self.emailRes.data?.message//mailString
        param.subject = self.sub_TxtFld.text!
        param.to = self.to_TxtFld.text!
        param.cc =  self.cc_TxtFld.text!
        param.bcc =  ""
        param.from =  emailRes.data?.from
        param.fromnm = emailRes.data?.fromnm
        param.compId = getUserDetails()?.compId
     //   param.stripLink =  emailRes.data?.stripLink
        if isInvoice {
            param.isProformaInv = "0"
            param.invId =  invoiceid
            param.tempId = templateId
        }else{
            param.quotId =  invoiceid
            param.tempId = templateId
        }
    
        let url = isInvoice ? Service.sendInvoiceEmailTemplate : Service.sendQuotationEmailTemplate
        
        serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
             killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(EmailInvoiceResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        self.emailRes = decodedData
                        
                        DispatchQueue.main.async {
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            self.navigationController?.popViewController(animated: true)
                        }
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
    
    
    func sendJobDocEmailTemplate() {
          
          //    "message -> mail body
          //    subject -> mail subject
          //    to -> reciepent email id
          //    cc -> cc email id
          //    bcc -> bcc email id
          //    from -> from email id
          //    fromnm -> from name
          //    invId -> Invoice Id
          //    compId -> Company Id"
          
          let mailString = self.msg_TxtView.text.replacingOccurrences(of: "\n", with: "<br>")
          
          showLoader()
          let param = Params()
          param.message = mailString
          param.subject = self.sub_TxtFld.text!
          param.to = self.to_TxtFld.text!
          param.cc =  self.cc_TxtFld.text!
          param.bcc =  ""
          param.from =  emailRes.data?.from
          param.fromnm = emailRes.data?.fromnm
         // param.compId = getUserDetails()?.compId
          param.moduleType = "2"
          param.pdfPath = att
         // param.isInvPdfSend = "1"
          param.jobId =  str
          
          
          let url =  Service.sendJobDocEmailTemplate
          
          serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
               killLoader()
              if(success){
                  let decoder = JSONDecoder()
                  if let decodedData = try? decoder.decode(EmailInvoiceResponse.self, from: response as! Data) {
                      
                      if decodedData.success == true{
                          
                          self.emailRes = decodedData
                          
                          DispatchQueue.main.async {
                              ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                              self.navigationController?.popViewController(animated: true)
                          }
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
    
    func sendJobCardEmailTemplate() {

            let mailString = self.msg_TxtView.text.replacingOccurrences(of: "\n", with: "<br>")
            
            showLoader()
            let param = Params()
            param.message = self.emailRes.data?.message//mailString
            param.subject = self.sub_TxtFld.text!
            param.to = self.to_TxtFld.text!
            param.cc = self.cc_TxtFld.text!
            param.pdfPath = jobIdDetailPDF
            param.jobId =  jobIdDetail
            param.tempId = templateId
            param.isJobCardPdfSend = "1"
            param.techId = jobIdForPrint
       
            let url =  Service.sendJobCardEmailTemplate
            
            serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
                 killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(EmailInvoiceResponse.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                          //  self.emailResStrp = decodedData[0].st
                            self.emailRes = decodedData
                            
                            DispatchQueue.main.async {
                                ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                                self.navigationController?.popViewController(animated: true)
                            }
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
                                //print( "\(String(describing: arr.tempJson1?.clientDetails![0].inputValue ?? ""))")
                                self.templateVelue = "\(String(describing: arr.tempJson1?.clientDetails![0].inputValue ?? ""))"
                                if self.selectJobId != "" {
                                    self.txtFldInvoiceTmplt.text = self.selectJobName
                                    self.templateId = self.selectJobId  ?? ""
                                }else{
                                    self.txtFldInvoiceTmplt.text = self.templateVelue
                                    self.templateId = arr.jcTempId ?? ""
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
    
    //=====================================
    // MARK:- getInvoiceTemplates  Service
    //=====================================
    
     func getInvoiceTemplates(){

            serverCommunicator(url: Service.getInvoiceTemplates, param: nil) { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(InvoiceTemplateRs.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            self.InvoiceTemplateArr = decodedData.data as! [JobCardTemplat1]
                            DispatchQueue.main.async {
                                let arr = self.InvoiceTemplateArr[0]
                               // print( "\(String(describing: arr.tempJson1?.invDetail![0].inputValue ?? ""))")
                                self.templateVelue = "\(String(describing: arr.tempJson1?.invDetail![0].inputValue ?? ""))"
                                self.txtFldInvoiceTmplt.text = self.templateVelue
                                self.templateId = arr.invTempId ?? ""
                            }
                            
                        }else{
                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{
                        
                      //  ShowError(message: AlertMessage.formatProblem, controller: windowController)
                    }
                }else{
                    //ShowError(message: "Please try again!", controller: windowController)
                }
            }
            
        }
    
    //=====================================
    // MARK:- getQuotaTemplates  Service
    //=====================================
    
     func getQuotaTemplates(){

            serverCommunicator(url: Service.getQuotaTemplates, param: nil) { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(QuotaTemplateRs.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            self.QuotaTemplateArr = decodedData.data as! [JobCardTemplat2]
                            DispatchQueue.main.async {
                                let arr = self.QuotaTemplateArr[0]
                                //print( "\(String(describing: arr.tempJson1?.quoDetail![0].inputValue ?? ""))")
                                self.templateVelue = "\(String(describing: arr.tempJson1?.quoDetail![0].inputValue ?? ""))"
                                self.txtFldInvoiceTmplt.text = self.templateVelue
                                self.templateId = arr.quoTempId ?? ""
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
    

    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

                return 50.0
            }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayType == "1"{
            return JobCardTemplatArr.count
        } else if self.arrayType == "2" {
            return QuotaTemplateArr.count
        }else if self.arrayType == "3" {
            return InvoiceTemplateArr.count
        }
        return arr.count
    }

    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        
        cell?.textLabel?.textColor = UIColor.darkGray
        
        if self.arrayType == "1"{
            if JobCardTemplatArr.count != 0 {
            cell?.textLabel?.text = JobCardTemplatArr[indexPath.row].tempJson1?.clientDetails![0].inputValue
            }
        } else if self.arrayType == "2" {
            if QuotaTemplateArr.count != 0 {
            cell?.textLabel?.text = QuotaTemplateArr[indexPath.row].tempJson1?.quoDetail![0].inputValue
            }
        }else if self.arrayType == "3" {
            if InvoiceTemplateArr.count != 0 {
            cell?.textLabel?.text = InvoiceTemplateArr[indexPath.row].tempJson1?.invDetail![0].inputValue
        }
        
        }
        
        return cell!
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (sltDropDownTag == 0) {
            
            if self.arrayType == "1"{
                
                self.txtFldInvoiceTmplt.text = JobCardTemplatArr[indexPath.row].tempJson1?.clientDetails![0].inputValue
                self.templateId = JobCardTemplatArr[indexPath.row].jcTempId ?? ""
            } else if self.arrayType == "2" {
                
                self.txtFldInvoiceTmplt.text = QuotaTemplateArr[indexPath.row].tempJson1?.quoDetail![0].inputValue
                self.templateId = QuotaTemplateArr[indexPath.row].quoTempId ?? ""
            }else if self.arrayType == "3" {
                
                self.txtFldInvoiceTmplt.text = InvoiceTemplateArr[indexPath.row].tempJson1?.invDetail![0].inputValue
                self.templateId = InvoiceTemplateArr[indexPath.row].invTempId  ?? ""
                
            }
            
            
        }
        self.removeOptionalView()
    }
    
  
    //==========================
    //MARK:- Open OptionalView
    //==========================
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView
            self.optionalVw?.delegate = self
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                self.removeOptionalView()
            }
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
            self.view.addSubview( self.optionalVw!)
        }
        
    }
    
    func removeOptionalView(){
        if optionalVw != nil {
            DispatchQueue.main.async {
                self.optionalVw?.removeFromSuperview()
                self.optionalVw = nil
            }
        }
    }
 
}

