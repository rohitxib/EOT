//
//  emailCheckVC.swift
//  EyeOnTask
//
//  Created by Mac on 29/11/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class emailCheckVC: UIViewController {

    var isForgot: Bool = false
    @IBOutlet weak var usrTxtfld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        let  trimmedUserNmStr  = usrTxtfld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (trimmedUserNmStr! == "") {
            ShowAlert(title: "", message: AlertMessage.enterUserName, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
            return
        }
        
        if isValidEmail(testStr: trimmedUserNmStr!) {
            if trimmedUserNmStr != "" {
                self.usrTxtfld.resignFirstResponder()
                showLoader()
                //currentCompanyCode  = ""
                //isForgot = false
                self.login(email: trimmedUserNmStr!)
                //self.login(username: self.usrTxtfld.text!)
              
            }
            else{
                
                ShowAlert(title: "", message: AlertMessage.enterUserName, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
                
            }
        }
        else{
            ShowAlert(title: "", message: trimmedUserNmStr != "" ? AlertMessage.enterValidEmail : AlertMessage.enterUserName, controller: self, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
        }
    }
    
  
    
    func login(email : String){
        
        let param = Params()
        param.email = email
        //param.cc = currentCompanyCode
        
        serverCommunicator(url: Service.signin, param: param.toDictionary) { (response, success) in
            
            killLoader()
            
            if(success){
                let decoder = JSONDecoder()

                  if let decodedData = try? decoder.decode(loginResponse.self, from: response as! Data) {
                    // print(decodedData)
                    
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                ShowError(message: errorString, controller: windowController)
            }
        }
    }

}
