//
//  EmailVerifyVc.swift
//  EyeOnTask
//
//  Created by Altab on 03/11/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class EmailVerifyVc: UIViewController {
    @IBOutlet weak var eotTitle: UILabel!
    @IBOutlet weak var completeDetailTitle: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var emailVerifyTxtField: UITextField!
    @IBOutlet weak var emailVerifyTitle: UIButton!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var resendTitle: UIButton!
    @IBOutlet weak var timerLbl: UILabel!
    
    var email:String!
    var pass:String!
    var apiCode:String!
    //var arrOfSign = Email()
    var arrOfString = String()
    var second = 30
    var timer:Timer?
    var  base = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         emailVerifyTxtField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 10)
        txtView.text! = "your login succefully \(String(describing: arrOfString))"
        timerLbl.text = String("00:\(second)")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func emailVerifyBtn(_ sender: Any) {
        
        
        getVerifyCodeService()
        
        
        
    }
    
    @IBAction func resendBtn(_ sender: Any) {
        
        getResendVerifyCodeService()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(EmailVerifyVc.Update), userInfo: nil, repeats: true)

    }
    
    
   
    
    
    //===================================================//
    //  code verify Api
    //===================================================//
    
      func getVerifyCodeService(){

                       if !isHaveNetowork() {
                          // if self.refreshControl.isRefreshing {
                          //    self.refreshControl.endRefreshing()
                          // return
                       }



                      // var dates = ("","")
           //            if selectedDateRange != nil{
           //                dates = getDateFromStatus(dateRange: selectedDateRange!)
           //            }

                       let param = Params()



        
        //param.name = nameTxtField.text
        param.pass = pass
        param.email = email
        param.apiCode = apiCode
        param.code = emailVerifyTxtField.text
       // param.planId = "0"
       // print(param.toDictionary)
        
        
        serverCommunicatorAddCompany(url: Service.verifyCompanyCode, param: param.toDictionary, images: nil, imagePath: "receipt[]") { (response, success) in
                                  killLoader()
                                  if(success){
                                      let decoder = JSONDecoder()
                                      if let decodedData = try? decoder.decode(RegistrationResponse.self, from: response as! Data) {

                                          if decodedData.success == true{
                                           
                                     
                                          // self.arrOfSignUpdata = decodedData.transVar!
                                           
                                              DispatchQueue.main.async {
                                                
                                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                let vc = storyboard.instantiateViewController(identifier: "AllmostDoneVc")as! AllmostDoneVc
                                                 vc.email = self.email
                                                 vc.pass = self.pass
                                               vc.apiCode = self.apiCode
                                                self.navigationController?.pushViewController(vc, animated: true)
                                               
                                               
                                               
                                               // self.navigationController?.popViewController(animated: true)
                                                 // self.showToast(message:LanguageKey.expense_added)
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
           
           
        
        
        
        

//                       serverCommunicator(url: Service.verifyCompanyCode, param: param.toDictionary) { (response, success) in
//
//                           DispatchQueue.main.async {
//                              // if self.refreshControl.isRefreshing {
//                              //    self.refreshControl.endRefreshing()
//                              // }
//                           }
//
//                           if(success){
//                               let decoder = JSONDecoder()
//
//                               if let decodedData = try? decoder.decode(RegistrationResponse.self, from: response as! Data) {
//                                   if decodedData.success == true{
//
//                                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                                                                       let vc = storyboard.instantiateViewController(identifier: "AllmostDoneVc")as! AllmostDoneVc
//                                                                           vc.email = self.email
//                                                                           vc.pass = self.pass
//
//                                                                           self.navigationController?.pushViewController(vc, animated: true)
//
//                                   // print(decodedData.transVar!)
//    //
//    //
//                                   }else{
//
//                               }
//                           }else{
//                               ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
//                                   if cancelButton {
//                                       showLoader()
//                                       self.getVerifyCodeService()
//                                   }
//                               })
//                           }
//                       }
//                   }
               
        }
    
    @objc func Update(){
        second -= 1
        timerLbl.text = String("00:\(second)")
        self.resendTitle.isEnabled = false
        self.resendTitle.setTitleColor(UIColor.colorButton, for: .normal)
        if second == 0 {
            
            second = 30
            self.resendTitle.isEnabled = true
            self.resendTitle.setTitleColor(UIColor.colorChangeButton, for: .normal)
            timer?.invalidate()
            timer = nil
        }
        //timerLbl.text = String("00:\(30)")
    }
        
    //===================================================//
    // resend code verify Api
    //===================================================//
    
    func getResendVerifyCodeService(){

                           if !isHaveNetowork() {
                              // if self.refreshControl.isRefreshing {
                              //    self.refreshControl.endRefreshing()
                              // return
                           }



                          // var dates = ("","")
               //            if selectedDateRange != nil{
               //                dates = getDateFromStatus(dateRange: selectedDateRange!)
               //            }

                           let param = Params()



            
    //        param.name = nameTxtField.text
   //        param.pass = passwordTxtField.text
           param.email = email
            //param.planId = getLocation
       //     param.planId = "0"
        //    print(param.toDictionary)

                            serverCommunicatorAddCompany(url: Service.resendVerificationCode, param: param.toDictionary, images: nil, imagePath: "receipt[]") { (response, success) in
                                                            killLoader()
                                                            if(success){
                                                                let decoder = JSONDecoder()
                                                                if let decodedData = try? decoder.decode(RegistrationResponse.self, from: response as! Data) {

                                                                    if decodedData.success == true{
                                                                     

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
    
    //=====================================
    //Post Sevice method with IMAGE UPLOAD
    //=====================================
    func serverCommunicatorAddCompany( url:String, param:Dictionary<String, Any>?,images:[UIImage]?, imagePath:String, callBack : @escaping (Any?, Bool) -> Void){

    if isHaveNetowork() {
    var body = Data()
    let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
    let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"

    if let paramDict = param {
    for (key, value) in paramDict {
    body.append(Data("--\(BoundaryConstant)\r\n".utf8))
    body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
    body.append(Data("\(value)\r\n".utf8))
    }
    }


    if let imageArray = images {
    if imageArray.count > 0 {
    for image in imageArray {
    var imageData : Data?
    imageData = image.jpegData(compressionQuality: 0.5)

    if (imageData != nil) {
    body.append(Data("--\(BoundaryConstant)\r\n".utf8))
    body.append(Data("Content-Disposition: form-data; name=\"\(imagePath)\"; filename=\"imageAp.jpeg\"\r\n".utf8))
    body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
    body.append(imageData!)
    body.append(Data("\r\n".utf8))
    }
    body.append(Data("--\(BoundaryConstant)--\r\n".utf8))
    }
    }
    }




    //Request for Service
    // let param = Params()
    if apiCode == "1" {
    base = "https://us1.eyeontask.com/en/eotServices/"
    }else if apiCode == "2"{
    base = "https://uk1.eyeontask.com/en/eotServices/"
    }else if apiCode == "3"{
    base = "https://au1.eyeontask.com/en/eotServices/"
    } else {
    base = "https://as1.eyeontask.com/en/eotServices/"
    }

    guard let url1 = URL(string: base+url) else { return }

    // if DebugModePrint() {
    // print(url1)
    // }

    var request = URLRequest(url: url1)
    request.timeoutInterval = 30
    request.httpMethod = "POST"
    request.httpBody = body
    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
    let origne = url1.host
    request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")

    callRequest(request: request, callBack: callBack) // Send request to CallRequest method
    }else{
    killLoader()
    errorString = AlertMessage.checkNetwork
    callBack(nil , false)
    }
    }

}
extension UIColor {
    static var colorButton = UIColor.init(red: 152/255, green: 152/255, blue: 152/255, alpha: 1)
    static var colorLightGray = UIColor.init(red: 164/255, green: 164/255, blue: 164/255, alpha: 1)
}
extension UIColor {
    static var colorChangeButton = UIColor.init(red: 10/255, green: 90/255, blue: 99/255, alpha: 1)
}
