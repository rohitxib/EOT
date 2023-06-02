//
//  DocViewVC.swift
//  EyeOnTask
//
//  Created by Dharmendra Gour on 07/07/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import WebKit
import IQKeyboardManagerSwift

class DocViewVC: UIViewController , WKNavigationDelegate, UITextViewDelegate{

      var fileUrl : URL?
      var callback: ((String,String) -> Void)?
      var isRename = false
      var imageName = String()
      var name : String?
      var docUrl : URL?
    
    var callbackForDocument: ((String,String) -> Void)?

     @IBOutlet weak var webView: WKWebView!
     @IBOutlet weak var webView_BOTTOM: NSLayoutConstraint!
     @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
     @IBOutlet weak var txtviewDes: UITextView!
     
     @IBOutlet weak var webViewHeight: NSLayoutConstraint!
     @IBOutlet weak var txtNamefield: UITextField!
    
     @IBOutlet weak var HdesctiptionView: NSLayoutConstraint!
     
     @IBOutlet weak var lblDescription: UILabel!
     
     @IBOutlet weak var txtViewSender: UITextView!
     
     var isJobDocument = false
     var documentDes = ""
     
     
     override func viewDidLoad() {
         super.viewDidLoad()

         self.txtviewDes.delegate = self
         self.txtviewDes.text = documentDes
         webViewHeight.constant = self.view.bounds.size.height - 60
             self.webView.navigationDelegate = self
             self.activityIndicator.style = .gray
             self.activityIndicator.center=self.view.center;
             self.activityIndicator.startAnimating()
             self.txtNamefield.text = imageName
        self.webView.load(NSURLRequest(url: self.fileUrl!) as URLRequest)
         
        /// self.webView.loadFileURL(self.fileUrl, allowingReadAccessTo: self.fileUrl)

           if self.isRename {
             
             self.webView_BOTTOM.constant = isJobDocument ? 130 : 65
             HdesctiptionView.constant = 0.0
                 self.title = ""
                 let yourBackImage = UIImage(named: "crossWhite")
                 self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: yourBackImage, style: .plain, target: self, action: #selector(self.addTapped))
                 
             }else{
                 self.webView_BOTTOM.constant = 0.0
                 self.title = LanguageKey.title_documents
             
                 txtviewDes.translatesAutoresizingMaskIntoConstraints = true
                 txtviewDes.sizeToFit()
                 txtviewDes.isScrollEnabled = false
             
             }

     }
     
     @IBAction func tappedDoneButton(_ sender: Any) {
         if callback != nil {
             callback! (txtNamefield.text!,txtViewSender.text!)
         }
        
        
         self.dismiss(animated: true, completion: nil)
     }
     
     
     public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            if lblDescription.isHidden == false {
                lblDescription.isHidden = true
            }
            return true
        }

        
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count == 0 {
            lblDescription.isHidden = false
        }
        return true
    }
        
     
     @objc func addTapped() -> Void {
         //print("tapped back button")
         self.dismiss(animated: true, completion: nil)
     }
     
     
     func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         print("Started to load")
     }

     func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         //print("Finished loading")
          activityIndicator.stopAnimating()
     }
     
     func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
         // print(error.localizedDescription)
         
             activityIndicator.stopAnimating()
             ShowAlert(title: AlertMessage.cant_open_this_file, message: "", controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: nil, style: .alert) { (cancel, ok) in
                 if cancel {
                     self.navigationController?.popViewController(animated: true)
                 }
             }
      }

     
     override func viewDidDisappear(_ animated: Bool) {
         
         if activityIndicator.isAnimating {
             activityIndicator.stopAnimating()
         }

     }
    

}
