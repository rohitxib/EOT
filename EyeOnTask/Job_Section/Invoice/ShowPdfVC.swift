//
//  ShowPdfVC.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 02/05/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import WebKit
import PDFKit

class ShowPdfVC: UIViewController , WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var invoiceid = String()
    var invoiceCode = String()
    var jobIdLabel = String()
    let activityView = UIActivityIndicatorView()
    var pdfFile = NSData()
    var isRemove = true
    var isInvoice = true
    var objOfUserJobListInDetail : UserJobList!
    var pdfDetailAppoinment = false
    var pdfDetailJob = false
    var appId = ""
    var pdfDetailJobId = ""
    var pdfDetailAppoinmentarr = [String]()
    var pdfWithEquipment = false
    var pdfPathFromEquDetail = ""
    var templateIdPrint = ""
    var jobIdForPrint = ""
    var titelForJobCare = false
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        self.webView.navigationDelegate = self
        activityView.style = .gray
        activityView.center=self.view.center;
        activityView.startAnimating()
        windowController.view.addSubview(activityView)
        
        if titelForJobCare == true {
         
                self.title = LanguageKey.print_job_card
            
        }else{
            if pdfDetailAppoinment == true {
                self.title = ""
            }else{
                self.title = isInvoice ? LanguageKey.print_invoice : LanguageKey.print_quote
            }
        }
        
        
        
        if pdfDetailJob == true {
            generateJobCardPDF()
        }else{
            if pdfDetailAppoinment == true {
                       
                      getPdfAppoinment()
                   }else{
                      self.getPdf()
                   }
        }
        
       if pdfWithEquipment == true{
           let url = Service.BaseUrl+pdfPathFromEquDetail
           DispatchQueue.main.async {
               self.webView.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
           }
       }
        
       
    }
    
    @objc func addTapped(){
        if pdfDetailJob == true {
            loadPDFAndShare()
        }else{
            loadPDFAndShareJob()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let camera = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = camera
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if activityView.isAnimating {
            activityView.stopAnimating()
        }
        
        if isRemove{
            removeFileFromDocumentDirectory(fileName: "\(invoiceCode).pdf")
        }
    }
    

    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         //  print("Started to load")
       }

       func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           //print("Finished loading")
            activityView.stopAnimating()
       }
       
       func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
          //  print(error.localizedDescription)
           
               activityView.stopAnimating()
               ShowAlert(title: AlertMessage.cant_open_this_file, message: "", controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: nil, style: .alert) { (cancel, ok) in
                   if cancel {
                       self.navigationController?.popViewController(animated: true)
                   }
               }
        }
    

    func getPdfAppoinment() -> Void {
           
           let param = Params()
           
          //             let param = Params()
          //            param.jobId = objOfUserJobListInDetail?.jobId
          //           // param.documentId = []
          //            param.moduleType =  "2"
        
               param.jobId =  appId
               param.documentId =  pdfDetailAppoinmentarr
               param.moduleType =  "2"
      //  parm.userID = jobIdPrint
           
           let url = Service.generateJobDocumentPDF
           
           serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
               if success {
                   let decoder = JSONDecoder()
                   if let decodedData = try? decoder.decode(PdfResponse.self, from: response as! Data) {
                       
                       if decodedData.success! {
                           let url = Service.BaseUrl + decodedData.data!.path!
                           saveFileInDocumentDirectory(url: url, fileName: ".pdf")
                           DispatchQueue.main.async {
                               self.webView.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
                           }
                       }
                   }
               }
           }
       }

   
    func getPdf() -> Void {
        
        let param = Params()
        
        if isInvoice {
            param.invId =  invoiceid
            param.tempId = templateIdPrint
            
        }else{
            param.quotId =  invoiceid
            param.tempId = templateIdPrint
            
        }
        
        let url = isInvoice ? Service.generateInvoicePDF : Service.generateQuotPDF
        
        serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
            if success {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(PdfResponse.self, from: response as! Data) {
                    
                    if decodedData.success! {
                        let url = Service.BaseUrl + decodedData.data!.path!
                        saveFileInDocumentDirectory(url: url, fileName: "\(self.invoiceCode).pdf")
                        DispatchQueue.main.async {
                            self.webView.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
                        }
                    }
                }
            }
        }
    }

    func generateJobCardPDF() -> Void {
        
        let param = Params()
        
            param.techId = jobIdForPrint 
            param.jobId = pdfDetailJobId
            param.tempId = templateIdPrint
        
        let url =  Service.generateJobCardPDF
        
        serverCommunicator(url: url, param: param.toDictionary) { (response, success) in
            if success {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(PdfResponse.self, from: response as! Data) {
                    
                    if decodedData.success! {
                        let url = Service.BaseUrl + decodedData.data!.path!
                        saveFileInDocumentDirectory(url: url, fileName: "\(self.jobIdLabel).pdf")
                        DispatchQueue.main.async {
                            self.webView.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
                        }
                    }
                }
            }
        }
    }

    
    func loadPDFAndShare(){
        if let filePath = loadFileFromDocumentDirectory(fileName: "\(jobIdLabel).pdf") {
            let file = NSURL(fileURLWithPath: filePath)  //[NSURL fileURLWithPath:filePath];
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [file], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView=self.view
            activityViewController.completionWithItemsHandler = {(activityType, completed, returnedItems, activityError) in
                self.isRemove = true
                APP_Delegate.hideBackButtonTextPdf()
            }
            isRemove = false
            APP_Delegate.showBackButtonTextPdf()
            present(activityViewController, animated: true, completion: nil)
        }
    }
    func loadPDFAndShareJob(){
           if let filePath = loadFileFromDocumentDirectory(fileName: "\(invoiceCode).pdf") {
               let file = NSURL(fileURLWithPath: filePath)  //[NSURL fileURLWithPath:filePath];
               let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [file], applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView=self.view
               activityViewController.completionWithItemsHandler = {(activityType, completed, returnedItems, activityError) in
                   self.isRemove = true
                   APP_Delegate.hideBackButtonTextPdf()
               }
               isRemove = false
               APP_Delegate.showBackButtonTextPdf()
               present(activityViewController, animated: true, completion: nil)
           }
       }
    
}
