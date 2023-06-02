//
//  EditExmence.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 15/06/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import CoreData

class EditExmence: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,OptionViewDelegate{
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var ClickRecp_Hieght: NSLayoutConstraint!
    @IBOutlet weak var Hight_upLoadBtn: NSLayoutConstraint!
    @IBOutlet weak var link_to: UILabel!
    @IBOutlet weak var removeImg: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var date: FloatLabelTextField!
    @IBOutlet weak var uploadImg: UIButton!
    @IBOutlet weak var expName: FloatLabelTextField!
    @IBOutlet weak var category: FloatLabelTextField!
    @IBOutlet weak var amount: FloatLabelTextField!
    @IBOutlet weak var des: FloatLabelTextField!
    @IBOutlet weak var group: FloatLabelTextField!
    @IBOutlet weak var noneLbl: UILabel!
    @IBOutlet weak var noneBtn: UIButton!
    @IBOutlet weak var clientLbl: UILabel!
    @IBOutlet weak var clientBtn: UIButton!
    @IBOutlet weak var jobIdLbl: UILabel!
    @IBOutlet weak var jobIdBTN: UIButton!
    @IBOutlet weak var Hight_Lbl: NSLayoutConstraint!
    @IBOutlet weak var linktoLbl: FloatLabelTextField!
    @IBOutlet weak var btnImg: UIImageView!
    @IBOutlet weak var cleamLbl: UILabel!
    @IBOutlet weak var updateexpanceBtn: UIButton!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var HightTopView: NSLayoutConstraint!
       
        var isAdded = Bool()
        var refreshControl = UIRefreshControl()
        var inDetailExp : ExpenceDetail?
        var resId = [ExpenceRec]()
        var imagePicker = UIImagePickerController()
        var objOfUserJobListInDetail : UserJobList!
        let cellReuseIdentifier = "cell"
        var arr = AddExpencee()
        var CategoryList = [AddExpencee]()
        var TagList = [AddExpenceeTag]()
        var optionalVw : OptionalView?
        let param = Params()
        var job = Bool()
        var client = Bool()
        var none = Bool()
        var buttonSwitched : Bool = false
        var sltDropDownTag : Int!
        var filterArry = [ClientList]()
        var arrOfShowData = [ClientList]()
        var filterArryJob = [ClientList]()
        var arrOfShowDataJob = [ClientList]()
        var arrOfFilterDict  = [[String : [UserJobList]]]()
        var arrOFUserData = [UserJobList]()
        var img = Bool()
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
            self.topView.addDashBorder()
            self.imgVw.isHidden = true
            let aa = inDetailExp!.receipt!

            if aa.count > 0 {
                self.removeImg.isHidden = false
                self.imgVw.isHidden = false
                self.ClickRecp_Hieght.constant = 0
                self.Hight_upLoadBtn.constant = 0
            }else{
                self.img = true
                self.removeImg.isHidden = true
                self.imgVw.isHidden = true
                self.HightTopView.constant = 55
            }
            
     
            self.Hight_Lbl.constant = 0
             isAdded = true
           getExpenseTagList()
           getCategoryList()
           setLocalization()
          
            if inDetailExp?.status == "1"{
               
                var yourImage: UIImage = UIImage(named: "BoxOFCheck.png")!
                btnImg.image = yourImage
                param.status = "1"
                
            }
            
            if inDetailExp?.status == "5"{
                 var yourImage: UIImage = UIImage(named: "BoxOFUncheck.png")!
                 btnImg.image = yourImage
                 param.status = "5"
            }
         
           
            if aa.count > 0 {
                
                let ar = URL(string: Service.BaseUrl)?.absoluteString
                let ab = inDetailExp!.receipt![0]
                load(url:URL(string: ar! + ab.receipt!)! )
       }

             self.date.text = dateFormateWithMonthandDayAndYearsShowDayh(timeInterval: ((inDetailExp?.dateTime)!))
             self.expName.text = inDetailExp?.name
             self.category.text = inDetailExp?.categoryName
             self.param.category =  inDetailExp?.category
             self.param.tag =  inDetailExp?.tag
             let amt = inDetailExp?.amt
             self.amount.text = String(format: "%.2f", Float(amt  ?? "0.0") ?? 0.0)
             self.des.text = inDetailExp?.des
             self.group.text = inDetailExp?.tagName
            
            var  idJob  = inDetailExp?.jobCode
            if idJob! != ""   {
                
                 self.linktoLbl.text = inDetailExp?.jobCode
                 self.param.jobId = inDetailExp?.jobId
                 self.Hight_Lbl.constant = 70
                 noneBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                 clientBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                 jobIdBTN.setImage(UIImage(named:"radio-selected"), for: .normal)
            }
            
            var  idClt  = inDetailExp?.cltName
                       if idClt! != "" {
                        self.linktoLbl.text = inDetailExp?.cltName
                        self.param.cltId = inDetailExp?.cltId
                         self.Hight_Lbl.constant = 70
                        noneBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                        clientBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                        jobIdBTN.setImage(UIImage(named:"radio_unselected"), for: .normal)
                       }

         
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
         
       
    }
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
               
               self.getClientListFromDBjob()
               self.getClientListFromDB()
          }
    
    func setLocalization() -> Void {
           
           self.navigationItem.title = LanguageKey.expense_edit
           uploadImg.setTitle(LanguageKey.expense_upload, for: .normal)
           expName.placeholder = "\(LanguageKey.expense_nm)*"
           date.placeholder = "\(LanguageKey.expense_date)*"
           category.placeholder = LanguageKey.expense_category
           amount.placeholder = "\(LanguageKey.expense_amount)*"
           des.placeholder = LanguageKey.expense_description
           group.placeholder = LanguageKey.expense_group
           linktoLbl.placeholder =  LanguageKey.expense_link
           noneLbl .text =  LanguageKey.expense_none
           cleamLbl .text =  LanguageKey.claim_reimbu
           jobIdLbl .text =  LanguageKey.expense_jobid
           clientLbl .text =  LanguageKey.expense_clientid
           link_to .text =  LanguageKey.expense_link
           doneBtn.setTitle(LanguageKey.done, for: .normal)
           cancelBtn.setTitle(LanguageKey.cancel, for: .normal)
           updateexpanceBtn.setTitle(LanguageKey.expense_edit, for: .normal)
       }
    
    func load(url:  URL ) {
                   DispatchQueue.global().async { [weak self] in
                       if let data = try? Data(contentsOf: url) {
                           if let image = UIImage(data: data) {
                               DispatchQueue.main.async {
                                   self?.imgVw.image = image
                               }
                           }
                       }
                   }
               }
               
    
    @IBAction func uploadBtn(_ sender: Any) {
 
             let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: LanguageKey.please_select, message: nil, preferredStyle: .actionSheet)
                           
                           let cancelActionButton = UIAlertAction(title: LanguageKey.cancel , style: .cancel) { _ in
                              
                           }
                           actionSheetControllerIOS8.addAction(cancelActionButton)
                           
                           
                           
                           let camera = UIAlertAction(title: LanguageKey.camera, style: .default)
                           { _ in
                               if UIImagePickerController.isSourceTypeAvailable(.camera){
                                   self.imagePicker.delegate = self
                                   self.imagePicker.sourceType = .camera;
                                   self.imagePicker.allowsEditing = false
                                   APP_Delegate.showBackButtonText()
                                   self.present(self.imagePicker, animated: true, completion: {
                                   
                                   self.imgVw.isHidden = true
                                    self.HightTopView.constant = 55
                                       
                                   })
                               }
                           }
                           
                           let gallery = UIAlertAction(title: LanguageKey.gallery, style: .default)
                           { _ in
                               if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                                   self.imagePicker.delegate = self
                                   self.imagePicker.sourceType = .photoLibrary;
                                   self.imagePicker.allowsEditing = false
                                   APP_Delegate.showBackButtonText()
                                   self.present(self.imagePicker, animated: true, completion: {
                                    
                                   self.imgVw.isHidden = true
                                    self.HightTopView.constant = 55
 
                                       
                                   })
                               }
                           }
                           
                           actionSheetControllerIOS8.addAction(gallery)
                           actionSheetControllerIOS8.addAction(camera)
                           self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        //}
        
        
       
               
        
        
    }
    @IBAction func groupdrpDwnBtn(_ sender: Any) {
    }
    @IBAction func removeImg(_ sender: Any) {
      
               deleteExpenseReceipt()
        
    }
    
    @IBAction func gestureBtnImg(_ sender: Any) {
       
    }
    
    
    @IBAction func doneDatePicker(_ sender: Any) {
         self.view.endEditing(true)
         self.bigView.isHidden = false
        
       
    }
    
    
    @IBAction func clameBtn(_ sender: UIButton) {
        
        
        self.buttonSwitched = !self.buttonSwitched

        if self.buttonSwitched
        {
             param.status = "1"
            var yourImage: UIImage = UIImage(named: "BoxOFCheck.png")!
            btnImg.image = yourImage
        }
        else
        {
            param.status = "5"
            var yourImage: UIImage = UIImage(named: "BoxOFUncheck.png")!
                btnImg.image = yourImage
        }
        


    }
    @IBAction func clientBtn(_ sender: Any) {
                  
    }
    
    @IBAction func noneBtn(_ sender: Any) {
                 self.linktoLbl.text! = " "
                    self.param.jobId = ""
                    self.param.cltId = ""
                    job = true
                    self.Hight_Lbl.constant = 0
                    noneBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                    clientBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                    jobIdBTN.setImage(UIImage(named:"radio_unselected"), for: .normal)
             

                
    }
    @IBAction func categoryBtn(_ sender: UIButton) {
        
        
        self.sltDropDownTag = sender.tag
                      switch  sender.tag {
                      case 1:
                       
                       if(self.optionalVw == nil){
                       self.openDwopDown( txtField: group , arr: TagList)
                          }else{
                       self.removeOptionalView()
                          }
                                              
                          break
                      case 0:
                          
                        
                         if(self.optionalVw == nil){
                                                 self.openDwopDown( txtField: category , arr: CategoryList)
                                             }else{
                                                 self.removeOptionalView()
                                             }
                          break
                     
                      case 2:
                       self.param.cltId = ""
                     self.linktoLbl.placeholder = LanguageKey.expense_jobid
                         var job = true
                           self.Hight_Lbl.constant = 70
                            noneBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                            clientBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                            jobIdBTN.setImage(UIImage(named:"radio-selected"), for: .normal)
                        
                        if(self.optionalVw == nil){
                                             self.openDwopDown( txtField: linktoLbl , arr:arrOFUserData)
                                                 }else{
                                         self.removeOptionalView()
                                                 }

                       
                       case 3:
                          self.param.jobId = ""
                          self.linktoLbl.placeholder = LanguageKey.expense_clientid
                        client = true
                        self.Hight_Lbl.constant = 70
                        noneBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                        clientBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                        jobIdBTN.setImage(UIImage(named:"radio_unselected"), for: .normal)
                                                   
                        if(self.optionalVw == nil){
                                        self.openDwopDown( txtField: linktoLbl, arr: arrOfShowData)
                                                           }else{
                                           self.removeOptionalView()
                                        }
                        
                           break
                      default:
                          print("Defalt")
                          break
                      }
       
        
    }
    
    
    @IBAction func jobIdBtn(_ sender: Any) {
          
        
    }
    
    
    @IBAction func upDateExpance(_ sender: Any) {
        
        
        let trimmexpenceName  =  self.expName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmDate = self.date.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmamount = self.amount.text?.trimmingCharacters(in: .whitespacesAndNewlines)

                    if(trimmexpenceName != nil && trimmexpenceName != ""){
                         
                             if(trimmamount != nil && trimmamount != ""){

                                        updateExpence()
                                         
                                    }else{
                                        ShowError(message: LanguageKey.expense_amount_required, controller: windowController)
                                    }
                                }else{
                                    ShowError(message:LanguageKey.expense_nm_required, controller: windowController)
                            }

        
       
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.bigView.isHidden = true
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        
                     let selectedDate = datePicker!.date
                     let formatter = DateFormatter()
                     formatter.dateFormat="dd-MM-yyyy"
                     let str = formatter.string(from: selectedDate)
                     date.text = str
                     self.bigView.isHidden = true
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      // let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
//        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
//            imgVw.image = image as? UIImage
            if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
            let imgStruct = ImageModel_EditExmence(img: (info[.originalImage] as? UIImage)?.resizeImage_EditExmence(targetSize: CGSize(width: 1000.0, height: 10000.0)))
                     imgVw.image  = (imgStruct.img!)
            
            imgVw.isHidden = false
             imgVw.alpha = 1.0
            imgVw.isUserInteractionEnabled = true
        }
        self.removeImg.isHidden = true
        self.imgVw.isHidden = false
        self.HightTopView.constant = 150
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }

    
      func showDataOnTableView(query : String?) -> Void {
            arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as! [ClientList]
            if arrOfShowData.count != 0 {
                arrOfShowData =  arrOfShowData.sorted { ($0 as AnyObject).nm?.localizedCaseInsensitiveCompare(($1 as AnyObject).nm!) == ComparisonResult.orderedAscending }
                DispatchQueue.main.async {
                  
                }
            }
    
            DispatchQueue.main.async {
                self.optionalVw?.isHidden = self.arrOfShowData.count > 0 ? false : true
            }
        }
    
    func getClientListFromDB() -> Void {
        
        if isAdded {
            showDataOnTableView(query: nil)
        }
       

     }
    
       ///////////////////////////////////////////////////////
       //=======================
       // MARK:- JobId methods
       //=======================
       
       func showDataOnTableViewJob(query : String?) -> Void {
     
           
           arrOFUserData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: query) as! [UserJobList]
           
                      if arrOFUserData.count != 0 {
                          arrOFUserData =  arrOFUserData.sorted { ($0 as AnyObject).nm?.localizedCaseInsensitiveCompare(($1 as AnyObject).nm!) == ComparisonResult.orderedAscending }
                          DispatchQueue.main.async {
                            
                          }
                      }
              
                      DispatchQueue.main.async {
                          self.optionalVw?.isHidden = self.arrOFUserData.count > 0 ? false : true
                      }
       }
       
       
       
       
       func getClientListFromDBjob() -> Void {
            
            if isAdded {
                showDataOnTableViewJob(query: nil)
            }
           

         }
    
    func removeOptionalView(){
           if optionalVw != nil {
               self.optionalVw?.removeFromSuperview()
               self.optionalVw = nil
           }
       }
    

    // MARK:- Optional view Detegate
     
      
      func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
          return 50.0
      }
      
      func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
        if (sltDropDownTag == 0) {
                  return CategoryList.count
               }
               else if (sltDropDownTag == 1) {
                  return TagList.count
               }
               else if (sltDropDownTag == 2) {
                    return arrOFUserData.count
               }
            
               else if (sltDropDownTag == 3) {
                  return arrOfShowData.count
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
          
         
            
        
        switch self.sltDropDownTag {
              case 0:
                      cell?.textLabel?.text = CategoryList[indexPath.row].name
                       
                  break
              case 1:
                  cell?.textLabel?.text = TagList[indexPath.row].name
                
                  break
             
             case 2:
                      cell?.textLabel?.text =   arrOFUserData[indexPath.row].label
                 break
             case 3:
                cell?.textLabel?.text = arrOfShowData[indexPath.row].nm
        
              default: break
                  
              }
         
              return cell!
          
          
      }
      
      
      func optionView(_ OptiontableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                     if (sltDropDownTag == 0) {
                         DispatchQueue.main.async{
                            self.category.text = self.CategoryList[indexPath.row].name
                            self.param.category =  self.CategoryList[indexPath.row].ecId
                        }
                       
                     }
                     else if (sltDropDownTag == 1) {
                           self.group.text = TagList[indexPath.row].name
                           param.tag =  TagList[indexPath.row].etId
                     }
                     else if (sltDropDownTag == 2) {
                        self.linktoLbl.text =  arrOFUserData[indexPath.row].label
                       
                            param.jobId = arrOFUserData[indexPath.row].jobId
                           
                     }
                  
                     else if (sltDropDownTag == 3) {
                        self.linktoLbl.text  = arrOfShowData[indexPath.row].nm
                                 
                      
                       param.cltId = arrOfShowData[indexPath.row].cltId
                             
                        }

                        self.removeOptionalView()
          

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


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        APP_Delegate.hideBackButtonText()
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    func hideloader() -> Void {
                   DispatchQueue.main.async {
                       if self.refreshControl.isRefreshing {
                           self.refreshControl.endRefreshing()
                       }
                   }

                   killLoader()
               }
    
     //=====================================
        // MARK:- Get addExpence Service
        //=====================================
        
        func updateExpence(){
          
            
            if !isHaveNetowork() {
                  ShowError(message: AlertMessage.networkIssue, controller: windowController)
                  hideloader()
                  return
              }
            
//            "jobId -> Job id
//            cltId -> Client Id
//            usrId -> [MObile->Self id, Web->May change from dropdown]
//            name -> Expense Name
//            amt -> Amount
//            dateTime-> 2020-04-18 11:00:01 [YY-mm-dd HH:i:s]
//            category -> Category id
//            tag-> Tag id
//            status -> [1->Claim Reimbursement, 2->Approved, 3-> Reject, 4->Paid, 5-Open]
//            des -> Description
//            receipt -> Multiple images
//            expId -> Expense Id
//            comment -> Comment on status change"
             

            param.expId = inDetailExp?.expId
            param.usrId = getUserDetails()?.usrId
            param.name =  trimString(string: expName.text!)
            param.amt =  trimString(string: amount.text!)
            param.dateTime = trimString(string: date.text!)
            param.des = trimString(string: des.text!)
            param.comment = trimString(string: group.text!)
            
            let images = (imgVw.image != nil) ? [imgVw.image!] : nil
            
            serverCommunicatorUplaodImageInArray(url: Service.updateExpense, param: param.toDictionary, images: images, imagePath: "receipt[]") { (response, success) in
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(ExpenceDetailResponse.self, from: response as! Data) {

                        if decodedData.success == true{
                            DispatchQueue.main.async {
                       
                              self.navigationController?.popViewController(animated: true)
                              self.showToast(message:LanguageKey.expense_update)
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
    
         //=====================================
         // MARK:- Get getExpenseTagList Service
         //=====================================
         
          func  getExpenseTagList(){
     //        "limit ->LINIT
     //        index -> Index
     //        search ->Search [Category name]"
                 
               
                 param.limit = "500"
                 param.index = "0"
                 param.search = ""
                 serverCommunicator(url: Service.getExpenseTagList, param: param.toDictionary) { (response, success) in
                     killLoader()
                     if(success){
                         let decoder = JSONDecoder()
                         if let decodedData = try? decoder.decode(gettagRs.self, from: response as! Data) {
                             
                             if decodedData.success == true{
                               //  print("\(decodedData)")
                              
                                 self.TagList = decodedData.data as! [AddExpenceeTag]
                         
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
        // MARK:- Get getCategory List Service
        //=====================================
        
         func getCategoryList(){
    //        "limit ->LINIT
    //        index -> Index
    //        search ->Search [Category name]"
                
              
                param.limit = "500"
                param.index = "0"
                param.search = ""
                serverCommunicator(url: Service.getCategoryList, param: param.toDictionary) { (response, success) in
                    killLoader()
                    if(success){
                        let decoder = JSONDecoder()
                        if let decodedData = try? decoder.decode(getCategoryRs.self, from: response as! Data) {
                            
                            if decodedData.success == true{
                            //    print("\(decodedData)")
                             
                                self.CategoryList = decodedData.data as! [AddExpencee]
                                
                                
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
          // MARK:- Get deleteExpenseReceipt List Service
          //=====================================
          
           func deleteExpenseReceipt(){
            
            param.expId = inDetailExp?.expId
                  param.erId = inDetailExp!.receipt![0].erId
          
                  serverCommunicator(url: Service.deleteExpenseReceipt, param: param.toDictionary) { (response, success) in
                      killLoader()
                      if(success){
                         
                          DispatchQueue.main.async {
                          self.imgVw.image = nil
                          self.removeImg.isHidden = true
                          self.imgVw.isHidden = true
                          self.HightTopView.constant = 55
                          self.ClickRecp_Hieght.constant = 22
                          self.Hight_upLoadBtn.constant = 25
                        }
                      }else{
                         
                      }
                  }
                  
              }
      
    }

struct ImageModel_EditExmence {
    var img: UIImage?
   
}

extension UIImage {
    func resizeImage_EditExmence(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

