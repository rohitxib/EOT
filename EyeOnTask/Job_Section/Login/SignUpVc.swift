//
//  SignUpVc.swift
//  EyeOnTask
//
//  Created by Altab on 03/11/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SignUpVc: UIViewController,UITextFieldDelegate,SWRevealViewControllerDelegate,OptionViewDelegate{
   
    

   
    @IBOutlet weak var showEyeBtn: UIButton!
    @IBOutlet weak var existLbl: UILabel!
    
    @IBOutlet weak var signUpTittle: UILabel!
    @IBOutlet weak var emailShowTitle: UILabel!
    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var locationTxtField: UITextField!
    
    @IBOutlet weak var registerTitle: UIButton!
    var  base = ""
    var sltTxtField = UITextField()
    var sltDropDownBtnTag : Int!
    var optionalVw : OptionalView?
    var locationArr = ["America","Asia","Australia","Europe"]
    let cellReuseIdentifier = "cell"
    var sltDropDownTag : Int!
    var getLocation = ""
    var arrOfShowData = [Any]()
    var arrOfSignUpdata = Email()
    var arrOfMassage = RegistrationResponse()

var buttonIsSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
              
               nameTxtField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 10)
               emailTxtField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 10)
               passwordTxtField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 10)
               locationTxtField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 10)
        
        
        if let revealController = self.revealViewController(){
                        revealViewController().delegate = self
                       // extraBtn.target = revealViewController()
                        //extraBtn.action = #selector(SWRevealViewController.revealToggle(_:))
                        revealController.tapGestureRecognizer()
                    }
        

        // Do any additional setup after loading the view.
    }
    
    
    func updateOnOffButton() {
        if buttonIsSelected {
            showEyeBtn.setImage(UIImage(named: "eyePassword"), for: .normal)
            self.passwordTxtField.isSecureTextEntry = false

        }else{
              //showEyePass
            showEyeBtn.setImage(UIImage(named: "showEyePass"), for: .normal)
            self.passwordTxtField.isSecureTextEntry = true
        }
    }
    
    @IBAction func showEyeBtn(_ sender: Any) {
        
        buttonIsSelected = !buttonIsSelected
                updateOnOffButton()
    }
    
    @IBAction func dropDoemBtn(_ sender: UIButton) {
        
            self.sltDropDownTag = sender.tag
                       switch  sender.tag {
                       case 0:
                        
                        if(self.optionalVw == nil){
                          
                            arrOfShowData = getJson(fileName: "location")["Server_location"] as! [Any]
                                           self.openDwopDown( txtField: self.locationTxtField, arr: arrOfShowData)
        //                    self.openDwopDown( txtField: txtLanguageName , arr: languageArr)
                           // self.openDwopDown( txtField: locationTxtField , arr: locationArr)
                           }else{
                        self.removeOptionalView()
                           }
                                               
                           break
                        
                        
                        default:
                       // print("Defalt")
                        break
        
    }
}
    
    @IBAction func registrationBtn(_ sender: Any) {
   
        if nameTxtField.text! == "" && nameTxtField.text! < "3" {
            ShowError(message: AlertMessage.enterUserName, controller: windowController)
        } else if emailTxtField.text == "" {
            ShowError(message: "enter email address", controller: windowController)
        }else if passwordTxtField.text == "" {
            ShowError(message: "enter your password", controller: windowController)
        }else {
                 emailVerifyService()
        }
     
        
    }
    
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             
              return 50.0
          }
          
          func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                if (sltDropDownTag == 0) {
     
                    return arrOfShowData.count
                  //return locationArr.count
                      
          }
              return 0
      }
    
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
                      if(cell == nil){
                          cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
                      }
                      
                      cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
                      cell?.backgroundColor = .clear
                      
                      cell?.textLabel?.textColor = UIColor.darkGray
             
              // let language = locationArr[indexPath.row]
               switch self.sltDropDownTag {
                    case 0:
                        cell?.textLabel?.text =  ((arrOfShowData[indexPath.row] as? [String : Any])?["text"] as? String)?.capitalizingFirstLetter()
                        break
           
                    default: break
                        
                    }
               
               
               
                   return cell!
       }
       
       func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if (sltDropDownTag == 0) {
                           
               self.locationTxtField.text = (arrOfShowData[indexPath.row] as? [String : Any])?["text"] as? String
               let countryID = (arrOfShowData[indexPath.row] as? [String : Any])?["apiCode"] as? String
               getLocation = countryID!
            
            }
            self.removeOptionalView()
       }
    
    
   //----------------------------------------------------//
    
    
    func removeOptionalView(){
           if optionalVw != nil {
               self.optionalVw?.removeFromSuperview()
               self.optionalVw = nil
           }
       }
    func textFieldDidBeginEditing(_ textField: UITextField) {
           self.sltTxtField = textField
           self.sltDropDownBtnTag = textField.tag
           
           
           if locationTxtField == textField {
               self.callMethodforOpenDwop(tag: 0)
           }
       

       }
    func callMethodforOpenDwop(tag : Int){
           if(self.optionalVw != nil){
               self.removeOptionalView()
                 return
           }
       
           switch tag {
           case 0:
               


               
               if(self.optionalVw == nil){

                                            sltDropDownTag = 0
                                            self.openDwopDown( txtField: locationTxtField, arr: arrOfShowData)
                                                }else{
                                                self.removeOptionalView()
                                            }
                                                            

               break
            

           default:
             return
        }
    }
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                  self.sltDropDownBtnTag = textField.tag
                 let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

                 

                      
                 
                 switch self.sltDropDownBtnTag {
                 case 0:
                     
                     
                            locationTxtField.text = ""
                        

                                
                                    locationTxtField.isUserInteractionEnabled = true
                                    
                            
                   if(self.optionalVw == nil){
                                    self.openDwopDown( txtField: self.locationTxtField, arr: arrOfShowData)
                                   }
                                    self.optionalVw?.isHidden = false
                                   DispatchQueue.main.async{
                                       if(self.arrOfShowData.count > 0){
                                                              

                                         
                                                               self.optionalVw?.table_View?.reloadData()
                                                           }else{
                                                             if(result != ""){
                                                                   self.removeOptionalView()
                                                           
                                                                 
                                                               }else{
                                                                   self.removeOptionalView()
    
                                                                   
                                                                
                                                               }
                                       }
                                   }
                     break
                    

                         default: break

                         }
                 
                

                 return true
             }
    
    //====================================================
    //MARK:-  Create Tags
    //====================================================
        func createTags(strName : String , view : ASJTagsView){
            view.addTag(strName, withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: true)
               view.deleteBlock = {(tagText : String ,idx : Int) -> Void in
               view.deleteTag(at: idx)
              //self.FltWorkerId.remove(at: idx)
            }
        }
    
    func openDwopDown(txtField : UITextField , arr : [Any]) {
       
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
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
    
    
    
    
    func getCountry() -> NSArray {
          return getJson(fileName: "location")["Server_location"] as! NSArray
      }
    
    
    
    
    //==================================================================//
    // Registration Api Calling
    //==================================================================//
    
//  func getRegistrationService(){
//
//                   if !isHaveNetowork() {
//                      // if self.refreshControl.isRefreshing {
//                      //    self.refreshControl.endRefreshing()
//                      // return
//                   }
//
//
//                   let param = Params()
//
//    param.name = trimString(string: nameTxtField.text!)//nameTxtField.text
//    param.pass = trimString(string: passwordTxtField.text!)
//    param.email = trimString(string: emailTxtField.text!)
//    //param.planId = getLocation
//    param.planId = trimString(string: getLocation)
//    print(param.toDictionary)
//
//      //"AuthenticationController/addCompany"
//
//    serverCommunicatorAddCompany(url:"AuthenticationController/addCompany", param: param.toDictionary) { (response, success) in
//
//                       DispatchQueue.main.async {
//                          // if self.refreshControl.isRefreshing {
//                          //    self.refreshControl.endRefreshing()
//                          // }
//                       }
//
//                       if(success){
//                           let decoder = JSONDecoder()
//
//                           if let decodedData = try? decoder.decode(RegistrationResponse.self, from: response as! Data) {
//                               if decodedData.success == true{
//
//                               // print(decodedData.transVar!)
//
//                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                let vc = storyboard.instantiateViewController(identifier: "EmailVerifyVc")as! EmailVerifyVc
//                                vc.email = self.emailTxtField.text
//                                vc.pass = self.passwordTxtField.text
//                                vc.apiCode = self.getLocation
//                                self.navigationController?.pushViewController(vc, animated: true)
//
//
//
//                               }else{
//
//                           }
//                       }else{
//                           ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
//                               if cancelButton {
//                                   showLoader()
//                                   self.getRegistrationService()
//                               }
//                           })
//                       }
//                   }
//               }
    
    
    
//
    
    func getRegistrationService(){
    
                       if !isHaveNetowork() {
                          // if self.refreshControl.isRefreshing {
                          //    self.refreshControl.endRefreshing()
                          // return
                       }
    
    
                       let param = Params()
    
        param.name = trimString(string: nameTxtField.text!)//nameTxtField.text
        param.pass = trimString(string: passwordTxtField.text!)
        param.email = trimString(string: emailTxtField.text!)
        //param.planId = getLocation
        param.planId = trimString(string: getLocation)
     //j   print(param.toDictionary)//j
    
          //"AuthenticationController/addCompany"
    
    
    serverCommunicatorAddCompany(url: Service.addCompany, param: param.toDictionary, images: nil, imagePath: "receipt[]") { (response, success) in
                           killLoader()
                           if(success){
                               let decoder = JSONDecoder()
                               if let decodedData = try? decoder.decode(RegistrationResponse.self, from: response as! Data) {

                                   if decodedData.success == true{
                                 
                                    self.arrOfSignUpdata = decodedData.transVar ?? Email()
                                       DispatchQueue.main.async {
                                         
                                        
                                         let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                                        let vc = storyboard.instantiateViewController(identifier: "EmailVerifyVc")as! EmailVerifyVc
                                                                        vc.email = self.emailTxtField.text
                                                                        vc.pass = self.passwordTxtField.text
                                                                        vc.apiCode = self.getLocation
                                                                        vc.arrOfString = self.arrOfSignUpdata.to!
                                        
                                                                        self.navigationController?.pushViewController(vc, animated: true)
                                        
                                        
                                        
                                        // self.navigationController?.popViewController(animated: true)
                                           ///self.showToast(message:LanguageKey.expense_added)
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
    
    
    
    
    
     func emailVerifyService(){

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



        
       // param.name = nameTxtField.text
       // param.pass = passwordTxtField.text
        param.email = emailTxtField.text
        //param.planId = getLocation
    //j    print(param.toDictionary)//j

                       serverCommunicator(url: Service.verifyEmail, param: param.toDictionary) { (response, success) in

                           DispatchQueue.main.async {
                            
                            
                              // if self.refreshControl.isRefreshing {
                              //    self.refreshControl.endRefreshing()
                              // }
                           }

                           if(success){
                               let decoder = JSONDecoder()

                               if let decodedData = try? decoder.decode(EmailVerify.self, from: response as! Data) {
                                   if decodedData.success == true{
                                    
                                    
                                    
                                    DispatchQueue.main.async {
                                        self.getRegistrationService()
                                    }
                                    
                                    
                                    //self.arrOfMassage = decodedData.message
//                                     DispatchQueue.main.async {
//
//
//                                                                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                                                                                           let vc = storyboard.instantiateViewController(identifier: "EmailVerifyVc")as! EmailVerifyVc
//                                                                                                           vc.email = self.emailTxtField.text
//                                                                                                           vc.pass = self.passwordTxtField.text
//                                                                                                           vc.apiCode = self.getLocation
//                                                                                                           vc.arrOfString =     decodedData.message!
//
//                                                                                                           self.navigationController?.pushViewController(vc, animated: true)
//
//
//
//                                                                           // self.navigationController?.popViewController(animated: true)
//                                                                            //  self.showToast(message:LanguageKey.expense_added)
//                                                                          }
                                   // self.getRegistrationService()

                                   // print(decodedData.transvar)
    //
    //
                                   }else{
                                    
                                  //  DispatchQueue.main.async {
                                            //self.existLbl.text = "this user id Allready exist"
                                        ShowError(message:"this user id Allready exist"
, controller: windowController)
                                          //  }
                                    
                                                                        
                                   // print("allready register")

                               }
                           }else{
                               ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                                   if cancelButton {
                                       showLoader()
                                       self.emailVerifyService()
                                   }
                               })
                           }
                       }
                   }
               
        }
    
//    func serverCommunicatorAddCompany(url:String , param:Dictionary<String, Any>?,callBack : @escaping (Any?, Bool) -> Void) {
//
//         let base : String = "https://au1.eyeontask.com/en/eotServices/"
//        guard let url1 = URL(string: base+url) else { return }
//    //
//        if DebugModePrint() {
//             print(url1)
//        }
//    //
//
//
//        if isHaveNetowork() {
//
//
//            var request = URLRequest(url: url1)
//            request.httpMethod = "POST"
//            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
//            request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
//                //request.addValue("https://us1.eyeontask.com", forHTTPHeaderField: "Origin")
//            let origne = url1.host
//            request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
//            request.timeoutInterval = 30.0
//
//            if param != nil {
//                request.httpBody =  try? JSONSerialization.data(withJSONObject: param!)
//            }
//
//            callRequest(request: request, callBack: callBack) // Send request to CallRequest method
//
//        }else{
//            killLoader()
//            errorString = AlertMessage.checkNetwork
//            //increaseErrorCount(callBack: callBack, data: nil)
//            callBack(nil , false)
//        }
//    }
    
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
        if getLocation == "1" {
            base = "https://us1.eyeontask.com/en/eotServices/"
        }else if getLocation == "2"{
            base = "https://uk1.eyeontask.com/en/eotServices/"
        }else if getLocation == "3"{
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
