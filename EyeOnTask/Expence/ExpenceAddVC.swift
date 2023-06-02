//
//  ExpenceAddVC.swift
//  EyeOnTask
//
//  Created by Hemant's mac on 08/05/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import CoreData

class ExpenceAddVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,OptionViewDelegate,UITextFieldDelegate,UISearchBarDelegate ,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var noneLbl: UILabel!
    @IBOutlet weak var jobidLbl: UILabel!
    @IBOutlet weak var clientLbl: UILabel!
    @IBOutlet weak var doneDatePkr: UIButton!
    @IBOutlet weak var cancleDatePkr: UIButton!
    @IBOutlet weak var addExpenceBtn: UIButton!
    @IBOutlet weak var linkto: UILabel!
    @IBOutlet weak var clickuplodrecpt: UILabel!
    @IBOutlet weak var clame_RemberLbl: UILabel!
    @IBOutlet weak var claim_rembrImg: UIImageView!
    @IBOutlet weak var jobIdBtn: UIButton!
    @IBOutlet weak var clientBtn: UIButton!
    @IBOutlet weak var noneBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var expenceName: FloatLabelTextField!
    @IBOutlet weak var date: FloatLabelTextField!
    @IBOutlet weak var category: FloatLabelTextField!
    @IBOutlet weak var amount: FloatLabelTextField!
    @IBOutlet weak var des: FloatLabelTextField!
    @IBOutlet weak var group: FloatLabelTextField!
    @IBOutlet weak var linkTo: FloatLabelTextField!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnUplaod: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var HightCon: NSLayoutConstraint!
  
    @IBOutlet weak var HightTopView: NSLayoutConstraint!
    var isAdded = Bool()
     var refreshControl = UIRefreshControl()
     var imagePicker = UIImagePickerController()
     var objOfUserJobListInDetail : UserJobList!
     let cellReuseIdentifier = "cell"
     var CategoryList = [AddExpencee]()
     var TagList = [AddExpenceeTag]()
     var optionalVw : OptionalView?
     let param = Params()
     var job = Bool()
     var client = Bool()
     var none = Bool()
     var buttonSwitched : Bool = false
     var Option = Bool()
     var filterArry = [ClientList]()
     var arrOfShowData = [ClientList]()
     var filterArryJob = [ClientList]()
     var arrOfShowDataJob = [ClientList]()
     var sltDropDownTag : Int!
     var arrOfFilterDict  = [[String : [UserJobList]]]()
     var arrOFUserData = [UserJobList]()
     var isFistTimeAdd = false
     var dateTm = " "
    
    //==
     var attempedCount = Int()
     let context = APP_Delegate.persistentContainer.viewContext //Create context
    
    //==
    override func viewDidLoad() {
        
        let selectedDate = datePicker!.date
              let formatter = DateFormatter()
              formatter.dateFormat="dd-MM-yyyy hh:mm:ss a"
        
        
        //=====================================================converttimezone
        var converTimeZoneschEndDate = ""

        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                dateTm = formatter.string(from: selectedDate)
            }else{
                let timeZoneDemo11 = formatter.string(from: selectedDate)
                dateTm = convertTimeZoneForAllDateTime(dateStr: timeZoneDemo11, dateFormate: formatter.dateFormat) ?? ""
                
            }
        }
        //=====================================================converttimezone
                        formatter.dateFormat="dd-MM-yyyy"
              let str = formatter.string(from: selectedDate)
              date.text = str
              self.bigView.isHidden = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        super.viewDidLoad()
        getCategoryList()
        getExpenseTagList()
        self.btnRemove.isHidden = true
        self.imgView.isHidden = true
        self.HightTopView.constant = 55
        self.HightCon.constant = 0
        self.title = "Add Expence"
        setLocalization()
        param.status = "5"
        isAdded = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
          
            self.getClientListFromDBjob()
            self.getClientListFromDB()
       }
    
    func setLocalization() -> Void {
        
        self.navigationItem.title = LanguageKey.add_expense
        btnUplaod.setTitle(LanguageKey.expense_upload, for: .normal)
        clickuplodrecpt .text =  LanguageKey.click_here
        expenceName.placeholder = "\(LanguageKey.expense_nm)*"
        date.placeholder = "\(LanguageKey.expense_date)*"
        category.placeholder = LanguageKey.expense_category
        amount.placeholder = "\(LanguageKey.expense_amount)*"
        des.placeholder = LanguageKey.expense_description
        group.placeholder = LanguageKey.expense_group
        linkTo .placeholder =  LanguageKey.expense_link
        noneLbl .text =  LanguageKey.expense_none
        clame_RemberLbl .text =  LanguageKey.claim_reimbu
        jobidLbl .text =  LanguageKey.expense_jobid
        linkto .text =  LanguageKey.expense_link
        clientLbl .text =  LanguageKey.expense_clientid
        doneDatePkr.setTitle(LanguageKey.done, for: .normal)
        cancleDatePkr.setTitle(LanguageKey.cancel, for: .normal)
        addExpenceBtn.setTitle(LanguageKey.add_expense, for: .normal)
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
                           
                                 self.imgView.isHidden = true
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
                               
                                 self.imgView.isHidden = true
                                 self.HightTopView.constant = 55
                                 
                             })
                         }
                     }
                     
                     actionSheetControllerIOS8.addAction(gallery)
                     actionSheetControllerIOS8.addAction(camera)
                     self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    @IBAction func btnRemoveImage(_ sender: Any) {
      
    }
    
    @IBAction func donePickerBtn(_ sender: Any) {
        let selectedDate = datePicker!.date
        let formatter = DateFormatter()
        formatter.dateFormat="dd-MM-yyyy"
        let str = formatter.string(from: selectedDate)
        date.text = str
        self.bigView.isHidden = true
    }
    
    @IBAction func cancelPicerBtn(_ sender: Any) {
        
          self.bigView.isHidden = true
    }
    
    
    @IBAction func clientIdBtn(_ sender: Any) {
        
            self.HightCon.constant = 70
            client = true
            self.linkTo.placeholder = LanguageKey.expense_clientid
            noneBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
            clientBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
            jobIdBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)

        
    }
    @IBAction func jonIdBtn(_ sender: Any) {
        
        job = true
        
          self.linkTo.placeholder = LanguageKey.expense_jobid
          self.HightCon.constant = 70
          noneBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                      clientBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                          jobIdBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
    }
    @IBAction func noneBtn(_ sender: Any) {
         self.linkTo.text! = " "
        self.param.jobId = ""
        self.param.cltId = ""
          self.HightCon.constant = 0
          noneBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                   clientBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                      jobIdBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
    }
    
    @IBAction func btnTapGesture(_ sender: Any) {
       
      
    }
    
    @IBAction func groupDRPDwnBtn(_ sender: Any) {
     
                
    }
    
    @IBAction func categoryDropDwn(_ sender: UIButton) {
        
      
        
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
                            job = true
                            self.linkTo.placeholder = LanguageKey.expense_jobid
                            self.HightCon.constant = 70
                            noneBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                            clientBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                            jobIdBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                           self.linkTo.text! = " "
                if(self.optionalVw == nil){
                        self.openDwopDown( txtField: linkTo , arr:arrOFUserData)
                            }else{
                    self.removeOptionalView()
                            }
                
                case 3:
                               self.param.jobId = ""
                                self.HightCon.constant = 70
                                client = true
                                self.linkTo.placeholder = LanguageKey.expense_clientid
                                noneBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                                clientBtn.setImage(UIImage(named:"radio-selected"), for: .normal)
                                jobIdBtn.setImage(UIImage(named:"radio_unselected"), for: .normal)
                               self.linkTo.text! = " "
                    if(self.optionalVw == nil){
                        self.openDwopDown( txtField: linkTo, arr: arrOfShowData)
                                    }else{
                    self.removeOptionalView()
                        }
                             
                    break
               default:
                   print("Defalt")
                   break
               }
        
        
        
    }
    
    @IBAction func addExpenceBtn(_ sender: Any) {
        
        
            let trimmexpenceName  =  self.expenceName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmamount = self.amount.text?.trimmingCharacters(in: .whitespacesAndNewlines)

               if(trimmexpenceName != nil && trimmexpenceName != ""){
                   if(trimmamount != nil && trimmamount != ""){
                       addExpence()
                                    
                        }else{
                        ShowError(message: LanguageKey.expense_amount_required, controller: windowController)
                            }
                               }else{
                                   ShowError(message: LanguageKey.expense_nm_required, controller: windowController)
                            }

    }
    
    
    
    @IBAction func btnUpload(_ sender: Any) {
        
        
    }
    
    @IBAction func clameBtn(_ sender: UIButton) {
        
        self.buttonSwitched = !self.buttonSwitched

           if self.buttonSwitched
           {
            
            var yourImage: UIImage = UIImage(named: "BoxOFCheck.png")!
            claim_rembrImg.image = yourImage
                param.status = "1"
           }
           else
           {
            
            var yourImage: UIImage = UIImage(named: "BoxOFUncheck.png")!
                       claim_rembrImg.image = yourImage
                          // param.status = "1"
                 param.status = "5"
           }
        
        //sender.isSelected = !sender.isSelected
//param.status = sender.isSelected ? "1" : "5"
        
      
    }
    
    
    @IBAction func datepickerBtn(_ sender: Any) {
        self.view.endEditing(true)
        
        self.bigView.isHidden = false
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//       let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
//            imgView.image = image as? UIImage
         
            
            if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
                  let imgStruct = ImageModel_ExpenceAddVC(img: (info[.originalImage] as? UIImage)?.resizeImage_ExpenceAddVC(targetSize: CGSize(width: 1000.0, height: 10000.0)))
                          imgView.image = (imgStruct.img!)
            btnUplaod.alpha = 1.0
           
        }
        
        self.btnRemove.isHidden = true
        self.imgView.isHidden = false
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
    //==========================
     // MARK:- Textfield methods
     //==========================
  
     
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
         
         if result.count > 2 || result.count == 0 {
             var query = ""
             if result != "" {
                 query = "nm CONTAINS[c] '\(result)'"
             }
             showDataOnTableViewJob(query: query == "" ? nil : query)
             showDataOnTableView(query: query == "" ? nil : query)
         }
         
         return true
     }

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
         textField.resignFirstResponder()
         return true
     }
    
    func removeOptionalView(){
           if optionalVw != nil {
               self.optionalVw?.removeFromSuperview()
               self.optionalVw = nil
           }
       }
    

    
    
    //=======================
    // MARK:- Other methods
    //=======================
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
    arrOFUserData =  arrOFUserData.sorted { ($0 as AnyObject).nm?.localizedCaseInsensitiveCompare(($1 as AnyObject).nm ?? "") == ComparisonResult.orderedAscending }
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
    
    ///////////////////////////////////////////////////////
      
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
            
            self.category.text = CategoryList[indexPath.row].name
            param.category =  CategoryList[indexPath.row].ecId
                
              }
              else if (sltDropDownTag == 1) {
                    self.group.text = TagList[indexPath.row].name
                    param.tag =  TagList[indexPath.row].etId
              }
              else if (sltDropDownTag == 2) {
            

             self.linkTo.text =  arrOFUserData[indexPath.row].label
            if job == true {
                param.jobId = arrOFUserData[indexPath.row].jobId
                         }

         
              }
           
              else if (sltDropDownTag == 3) {
            self.linkTo.text  = arrOfShowData[indexPath.row].nm
            
            if client == true {
                param.cltId = arrOfShowData[indexPath.row].cltId
                  }
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

    func openDwopDownForConstactHeight(txtField : UITextField , arr : [Any]) {
          
          if (optionalVw == nil){
              self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
              let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
              self.optionalVw?.setUpMethod(frame: CGRect(x:10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height ), width: self.view.frame.size.width - 20, height: 100))
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
                             //   print("\(decodedData)")
                             
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
    // MARK:- Get addExpence Service
    //=====================================
    
    func addExpence(){
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            hideloader()
            return
        }
        
        
        if isFistTimeAdd == false {
            isFistTimeAdd = true
            
            
            param.usrId = getUserDetails()?.usrId
            param.name = trimString(string: expenceName.text!)
            param.amt =  trimString(string: amount.text!)
//            if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
//                if isAutoTimeZone == "0"{
                    param.dateTime = trimString(string: dateTm)
//                }else{
//                    param.dateTime = CurrentDateTime()
//                }
//            }
           
            param.des = trimString(string: des.text!)
            
            
            
            let images = (imgView.image != nil) ? [imgView.image!] : nil
            
            serverCommunicatorUplaodImageInArray(url: Service.addExpense, param: param.toDictionary, images: images, imagePath: "receipt[]") { (response, success) in
             
                killLoader()
                if(success){
                    
                    
                    
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(ExpenceDetailResponse.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                                self.showToast(message:LanguageKey.expense_added)
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
    }
    
}


struct ImageModel_ExpenceAddVC {
    var img: UIImage?
   
}

extension UIImage {
    func resizeImage_ExpenceAddVC(targetSize: CGSize) -> UIImage {
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
