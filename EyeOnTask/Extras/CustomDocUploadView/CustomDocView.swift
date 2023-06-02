//
//  EyeOnTask
//
//  Created by Hemant's mac on 30/03/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import WebKit
class CustomDocView: UIView , WKNavigationDelegate {

    @IBOutlet weak var thenewlyAddedLblComp: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblDocDes: UILabel!
    @IBOutlet weak var txtViewDocDes: UITextView!
    var activityIndicator: UIActivityIndicatorView!
    var completionHandler : ((String, String) -> (Void))?
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblName: UILabel!
    var docName : String?
    var thenewlyAddedLblCompCheck = "false"
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomDocView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
    func setupMethod(url : URL, image : UIImage?, imageName : String, imageDescription : String) {
        self.webView.navigationDelegate = self
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: webView.center, size: CGSize(width: 20, height: 20)))
        self.activityIndicator.style = .gray;
        self.activityIndicator.startAnimating()
        webView.addSubview(self.activityIndicator)

        docName = imageName
        
        if thenewlyAddedLblCompCheck == "true"{
            thenewlyAddedLblComp.text = LanguageKey.update_desc_append_complition
            thenewlyAddedLblComp.isHidden = true
        }else{
             thenewlyAddedLblComp.isHidden = true
        }
        self.webView.load(NSURLRequest(url: url) as URLRequest)
        
        txtViewDocDes.text = imageDescription
        lblDocDes.text = "\(LanguageKey.doc_des_op) \(LanguageKey.optional)"
        btnUpdate.setTitle(LanguageKey.update, for: .normal)
    }
    
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
           print("Started to load")
       }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        webView.evaluateJavaScript("document.body.innerHTML.toString()") { (html, error) in
            if let htmlContent = html {
                if let data = (htmlContent as! String).data(using: .utf8) {
                     let imageSize: Int = data.count
                      self.docName = "  \(self.docName ?? "") (\(Double(imageSize) / 1000.0)KB)"
                }
            }
            self.lblName.text = "  \(self.docName ?? "")"
        }
        activityIndicator.stopAnimating()
    }
    
       
       func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
           // print(error.localizedDescription)
               activityIndicator.stopAnimating()
               ShowAlert(title: AlertMessage.cant_open_this_file, message: "", controller: windowController, cancelButton: LanguageKey.cancel as NSString, okButton: nil, style: .alert) { (cancel, ok) in
                   if cancel {
                       self.removeFromSuperview()
                   }
               }
        }
    
    
    @IBAction func btnSubmitUpload(_ sender: Any) {
        if (completionHandler != nil) {
            completionHandler!(lblName.text! , txtViewDocDes.text!)
        }
    }
    
}


