//
//  CheckInOutVC.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 12/08/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit
import PDFKit

class CheckInOutVC: UIViewController,SWRevealViewControllerDelegate, URLSessionDelegate {
 

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var txtFldDateFrom: FloatLabelTextField!
    @IBOutlet weak var txtFldDateTo: FloatLabelTextField!
    @IBOutlet weak var downLdBtn: UIButton!
    @IBOutlet weak var downloadrReport: UILabel!
    @IBOutlet weak var disReport: UILabel!
    @IBOutlet weak var reportFrom: UILabel!
    @IBOutlet weak var reportFrmDate: UILabel!
    @IBOutlet weak var reportTo: UILabel!
    @IBOutlet weak var reportToDate: UILabel!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var extraButton: UIBarButtonItem!
    var pdfUrl : URL?
    var yourArray = [String]()
    var isClear  = false
    var isStartScheduleBtn : Bool!
    var pdfURL: URL!
        override func viewDidLoad() {
            super.viewDidLoad()
          // setuomethard()
            let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
            leftButton.setTitleTextAttributes(attributes, for: .normal)
            self.navigationItem.rightBarButtonItem = leftButton
            
            self.bigView.isHidden = true
            setLocalization()
            
            if let revealController = self.revealViewController(){
                revealViewController().delegate = self
                extraButton.target = revealViewController()
                extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
                revealController.tapGestureRecognizer()
            }
            
        }
        
        
        func setuomethard(){
              
                    let selectedDate = datePicker!.date
                     let formatter = DateFormatter()

                
                       formatter.dateFormat="yyyy-MM-dd"
                       let strd = formatter.string(from: selectedDate)
                       reportFrmDate.text = strd
                 
                       formatter.dateFormat="yyyy-MM-dd"
                       let strf = formatter.string(from: selectedDate)
                       reportToDate.text = strf
              
                   
              }
        
        func setLocalization() -> Void {
            
            self.navigationItem.title = LanguageKey.title_report
            downloadrReport.text =  LanguageKey.download_report
            disReport.text =  LanguageKey.download_report_lable_stext
            txtFldDateFrom.placeholder = "\(LanguageKey.report_from)"
            txtFldDateTo.placeholder = "\(LanguageKey.report_to)"
            downLdBtn.setTitle(LanguageKey.download_report, for: .normal)
             cancelBtn.setTitle(LanguageKey.cancel, for: .normal)
             doneBtn.setTitle(LanguageKey.done, for: .normal)
            
        }
        
        @IBAction func reportFrm(_ sender: Any) {
            
            self.isStartScheduleBtn = true
            self.bigView.isHidden = false
            self.showDateAndTimePicker()
        }
        
        @IBAction func reportto(_ sender: Any) {
            self.isStartScheduleBtn = false
            self.bigView.isHidden = false
            self.showDateAndTimePicker()
        }
        
        @IBAction func donBtn(_ sender: Any) {

            self.bigView.isHidden = true
            let date = self.datePicker.date
            let formatter = DateFormatter()
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                if enableCustomForm == "0"{
                    formatter.dateFormat = "yyyy-MM-dd"
                }else{
                    formatter.dateFormat = "yyyy-MM-dd"
                }
            }
            
            
            formatter.timeZone = TimeZone.current
            
            if let langCode = getCurrentSelectedLanguageCode() {
                formatter.locale = Locale(identifier: langCode)
            }
            
            let strDate = formatter.string(from: date)
            if(isStartScheduleBtn){
    //            let arr = strDate.components(separatedBy: " ")
    //
    //            if arr.count == 2 {
    //                lblStartDate.text = arr[0]
    //                lblStartTime.text = arr[1]
    //            }else{
    //                lblStartDate.text = arr[0]
    //                lblStartTime.text = arr[1] + " " + arr[2]
    //            }
                
                   txtFldDateFrom.text = strDate
                // reportToDate
            }else{
                
                
                let schStartDate = self.txtFldDateFrom.text!
                
                if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                   // if enableCustomForm == "0"{
                        let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.yyyy_MM_dd)
                        if(value == "orderedDescending"){
                            ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                        }else{
                            
                            txtFldDateTo.text = strDate
                           // let arr = strDate.components(separatedBy: " ")
    //
    //                        if arr.count == 2 {
    //                            lblEndDate.text = arr[0]
    //                            lblEndTime.text = arr[1]
    //
    //                        }else{
    //                            lblEndDate.text = arr[0]
    //                            lblEndTime.text = arr[1] + " " + arr[2]
    //                        }
                        }
                   // }
                }
                
            }
            
            
            
        }
        
        @IBAction func cancelBtn(_ sender: Any) {
            self.bigView.isHidden = true
        }
        
        @IBAction func downloadRprtBtnAct(_ sender: Any) {
            
            if(txtFldDateFrom.text != ""){
                if(txtFldDateTo.text != ""){
                    generateCheckInOutPDF()
                }else{
                    ShowError(message:"\(LanguageKey.please_select) \(LanguageKey.to) \(LanguageKey.date)", controller: windowController)
                }
            }else{
                ShowError(message: AlertMessage.select_date_range, controller: windowController)
            }
           
        }
        
        
        func showDateAndTimePicker(){
            // self.dateAndTimePicker.minimumDate = Date()
            self.bigView.isHidden = false
            UIView.animate(withDuration: 0.2)  {
                let frame = CGRect(x: 0, y: self.view.frame.size.height - 240, width: self.view.frame.size.width, height: 240)
                self.bigView.frame = frame
                
            }
        }
        
        //=======================================
        // MARK:- API method generateCheckInOutPDF
        //=======================================
        
  
        func generateCheckInOutPDF() {
            
            if !isHaveNetowork() {
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                killLoader()
                return
            }
            
            let schStartDate = String(format: "%@",  (self.txtFldDateFrom.text == nil ? "" : self.txtFldDateFrom.text! ))
            let schEndDate = String(format: "%@",  (self.txtFldDateTo.text == "" ? "" : self.txtFldDateTo.text!))
            
            if schStartDate == "yyyy-MM-dd"{
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectStartDate, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                return
            }
            
            if schEndDate == "yyyy-MM-dd"{
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.selectEndDate, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                return
            }
            
            let value = compareTwodate(schStartDate:schStartDate , schEndDate: schEndDate, dateFormate: DateFormate.yyyy_MM_dd)
            if(value == "orderedDescending") || (value == "orderedSame"){
                ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                return
            }
           
            showLoader()
            
            var parm = [String: Any]()
            var memId = [String]()
            memId.append((getUserDetails()?.usrId)!)
            
            parm["dtt"] = self.txtFldDateTo.text ?? ""
            parm["dtf"] = self.txtFldDateFrom.text ?? ""
            parm["usrId"] = memId
            
            
            print(parm)
            serverCommunicator(url: Service.generateCheckInOutPDF, param: parm) { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(CommonResponsePdf.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                         
                            DispatchQueue.main.async {
                                
                                let ar = URL(string: Service.BaseUrl)?.absoluteString
                               // self.savePdf(urlString: ar!, fileName: decodedData.data.path!)
                                
                                
                                //  guard let url = URL(string: "https://us1.eyeontask.com/en/eotServices/uploads//tempPDF//11342230082021.pdf")
                               guard let urlPdf = URL(string: ar! + decodedData.data.path!)
                                    
                                else { return }
                                
                                print(urlPdf)
                                let fileName = "CheckInOut"
                                
                                 let url = "\(urlPdf)"
                                
                   // let url = "https://us1.eyeontask.com/en/eotServices/uploads//tempPDF//11342230082021.pdf"
                                self.savePdf(urlString: url, fileName: fileName)
                               
                                
                               // self.showToast(message: decodedData.message!)
                                self.showToast(message:LanguageKey.download_report)
                                
                            }
                            
                        }else{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{
                        
                        ShowError(message: AlertMessage.formatProblem, controller: windowController)
                    }
                }else{
                    ShowError(message: AlertMessage.check_in_out_fail, controller: windowController)
                }
            }
            
    }
            


    func savePdf(urlString:String, fileName:String) {
            DispatchQueue.main.async {
                let url = URL(string: urlString)
                let pdfData = try? Data.init(contentsOf: url!)
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "EOT-\(fileName).pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("pdf successfully saved!")
    //file is downloaded in app data container, I can find file from x code > devices > MyApp > download Container >This container has the file
                } catch {
                    print("Pdf could not be saved")
                }
            }
        }
 
        }



private func downloadFiles(url:URL, fileName: String) {
    let downloadTask = URLSession.shared.downloadTask(with: url) {
        urlOrNil, responseOrNil, errorOrNil in
        guard let fileURL = urlOrNil else { return }
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            
            let savedURL = documentsURL.appendingPathComponent(fileName)
            print(savedURL)
            try FileManager.default.moveItem(at: fileURL, to: savedURL)
        } catch {
            print ("file error: \(error)")
        }
    }
    downloadTask.resume()
}
