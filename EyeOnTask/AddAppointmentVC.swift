//
//  AddAppointmentVC.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 03/07/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class AddAppointmentVC: UIViewController,OptionViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

 @IBOutlet weak var H_Des: NSLayoutConstraint!
 @IBOutlet weak var textView: UITextView!
 @IBOutlet weak var H_DesView: NSLayoutConstraint!
 @IBOutlet weak var endDateAndTime: UILabel!
 @IBOutlet weak var startDateAndTime: UILabel!
 @IBOutlet weak var assignTo: UILabel!
 @IBOutlet weak var addAppoiment: UIButton!
 @IBOutlet weak var btnDone: UIButton!
 @IBOutlet weak var btnCancle: UIButton!
 @IBOutlet weak var scheduleDateTime: UILabel!
 @IBOutlet weak var moLbl_Hight: NSLayoutConstraint!
 @IBOutlet weak var addAtchmntTxtFld: FloatLabelTextField!
 @IBOutlet weak var tagView: ASJTagsView!
 @IBOutlet weak var clientVw_Hieght: NSLayoutConstraint!
 @IBOutlet weak var moLbl_Hieght: NSLayoutConstraint!
 @IBOutlet weak var moImg_Hieght: NSLayoutConstraint!
 @IBOutlet weak var moVW_Hieght: NSLayoutConstraint!
 @IBOutlet weak var cityTxtFld: FloatLabelTextField!
 @IBOutlet weak var statesTxtFld: FloatLabelTextField!
 @IBOutlet weak var contryuTxtFld: FloatLabelTextField!
 @IBOutlet weak var clientTxtFld: FloatLabelTextField!
 @IBOutlet weak var desTxtFld: FloatLabelTextField!
 @IBOutlet weak var moNoTxtFld: FloatLabelTextField!
 @IBOutlet weak var emailTxtFld: FloatLabelTextField!
 @IBOutlet weak var adssTxtFld: FloatLabelTextField!
 @IBOutlet weak var bigView: UIView!
 @IBOutlet weak var datePicker: UIDatePicker!
 @IBOutlet weak var endTimeLbl: UILabel!
 @IBOutlet weak var startTimeLbl: UILabel!
 @IBOutlet weak var endDateLbl: UILabel!
 @IBOutlet weak var startDateLbl: UILabel!
 @IBOutlet weak var clientBn: UIButton!
 @IBOutlet weak var postalCdTxtFld: FloatLabelTextField!
 @IBOutlet weak var assignToTxtFld: UITextField!
 @IBOutlet weak var imgView: UIImageView!
    
 var city = ""
 var cityId = ""
 var status = ""
 var statusId = ""
 var isAddValidation = Bool()
 var imagePicker = UIImagePickerController()
 var FltWorkerId = [String]()
 var FltArrClintList = [ClientList]()
 var sltTxtField = UITextField()
 var startDates = Bool()
 var startDatee = Bool()
 var startTimes = Bool()
 var startTimee = Bool()
 var arrOfShow = [Any]()
 let param = Params()
 var isClintFutUser  = false
 var filterArry = [ClientList]()
 var arrOfShowData = [ClientList]()
 var filterArryJob = [ClientList]()
 var arrOfShowDataJob = [ClientList]()
 var sltDropDownTag : Int!
 var optionalVw : OptionalView?
 var isAdded = Bool()
 let cellReuseIdentifier = "cell"
 var sltDropDownBtnTag : Int!
 var isClear  = false
 var callbackForJobVC: ((Bool) -> Void)?
 var isStartScheduleBtn : Bool!
 var docUrlStr : String?
// var imagePicker = UIImagePickerController()
 var imgArr = [ImageModel]()
 var stringToHtml = ""
    var forDic = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView.delegate = self
        textView.text = LanguageKey.description
        textView.textColor = UIColor.lightGray
        self.getClintListFrmDB()
        
        getClientSink()
        getClientContactSink()
        getClientSiteSink()
        H_DesView.constant = 70
        
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                datePicker.locale = Locale.init(identifier: "en_US")
                
            }else{
                datePicker.locale = Locale.init(identifier: "en_gb")
                
            }
        }
        
        isAddValidation = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        // let duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "0:0" // old
        var duration : String? = getDefaultSettings()?.duration != "" ? getDefaultSettings()?.duration  : "01:00"
        duration = updateDefaultTime(duration ?? "01:00")
        let arrOFDurationTime = duration?.components(separatedBy: ":")
        // let currentTime : String? = getDefaultSettings()?.jobCurrentTime // old
        let currentTime : String? = updateDefaultTime(getDefaultSettings()?.jobCurrentTime ?? "01:00")
        if(currentTime != "" && currentTime != nil){
            let arrOFCurntTime = currentTime?.components(separatedBy: ":")//- 0 : "00"
            
            let strDate = getSchuStartAndEndDateForAgoTime(Hrs:Int(arrOFCurntTime![0])!, min: Int(arrOFCurntTime![1])!, diffOfHr: Int(arrOFDurationTime![0])!, diffOfMin: Int(arrOFDurationTime![1])!)
            let arr = strDate.0.components(separatedBy: " ")
            if arr.count == 2 {
                startTimeLbl.text = arr[0]
                startTimeLbl.text = arr[1]
                endTimeLbl.text = arr[0]
            }else{
                
                startTimeLbl.text = arr[0]
                startTimeLbl.text = arr[1] + " " + arr[2]
                endTimeLbl.text = arr[0]
                
            }
            
            let arrOfEndDate = strDate.1.components(separatedBy: " ")
            if arrOfEndDate.count == 2 {
                endTimeLbl.text = arrOfEndDate[0]
                endTimeLbl.text = arrOfEndDate[1]
            }else{
                endTimeLbl.text = arrOfEndDate[0]
                endTimeLbl.text = arrOfEndDate[1] + " " + arrOfEndDate[2]
            }
            
        }
        
        setLocalization()
        DispatchQueue.main.async {
            self.createTags(strName: (getUserDetails()?.fnm)!, view: self.tagView)
        }
        
        
        self.FltWorkerId.append((getUserDetails()?.usrId)!)
        self.moLbl_Hight.constant = 0
        self.moImg_Hieght.constant = 0
        self.moVW_Hieght.constant = 0
        self.setuomethard()
        // self.clientBn.isHidden = true
        isAdded = true
        self.bigView.isHidden = true
        
        
        // Do any additional setup after loading the view.
    }

override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
       self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
    
        
           self.getClientListFromDB()
      }

  
  
  func setLocalization() -> Void {
      
        self.navigationItem.title = LanguageKey.add_appointment
        startDateAndTime.text =  LanguageKey.start_date_and_time
        endDateAndTime.text =  LanguageKey.end_date_and_time
        scheduleDateTime.text =  LanguageKey.appointment_schedule
        assignToTxtFld.text =  LanguageKey.add_fieldworker
        assignTo.text = "\(LanguageKey.assign_to)"
        adssTxtFld.placeholder = "\(LanguageKey.address)"
        postalCdTxtFld.placeholder = "\(LanguageKey.postal_code)"
        cityTxtFld.placeholder = "\(LanguageKey.city)"
        statesTxtFld.placeholder = "\(LanguageKey.state)"
        contryuTxtFld.placeholder = "\(LanguageKey.country)"
        clientTxtFld.placeholder = "\(LanguageKey.clients)*"
        desTxtFld.placeholder = "\(LanguageKey.description)"
        moNoTxtFld.placeholder = "\(LanguageKey.mob_no)"
        emailTxtFld.placeholder = "\(LanguageKey.email)"
        btnDone.setTitle(LanguageKey.done, for: .normal)
        btnCancle.setTitle(LanguageKey.cancel, for: .normal)
        addAppoiment.setTitle(LanguageKey.add_appointment, for: .normal)
    
  }
  
  
  @IBAction func btnDateAndTimeStrt(_ sender: Any) {
      removeOptionalView()
      isStartScheduleBtn = true
      self.bigView.isHidden = false
      self.showDateAndTimePicker()
  }
  
  @IBAction func btnDateAndTimeEnd(_ sender: Any) {
      removeOptionalView()
            isStartScheduleBtn = false
            self.bigView.isHidden = false
            self.showDateAndTimePicker()
  }
  
  func showDateAndTimePicker(){
  // self.dateAndTimePicker.minimumDate = Date()
   self.bigView.isHidden = false
   UIView.animate(withDuration: 0.2)  {
       let frame = CGRect(x: 0, y: self.view.frame.size.height - 240, width: self.view.frame.size.width, height: 240)
       self.bigView.frame = frame

   }
  }
  
@IBAction func clienBtn(_ sender: Any) {
    if(clientBn.imageView?.image == UIImage(named: "BoxOFUncheck")){
                                    self.clientBn.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
                                  
                                    self.isClintFutUser = true
          isAddValidation = true
              adssTxtFld.placeholder = "\(LanguageKey.address)*"
              statesTxtFld.placeholder = "\(LanguageKey.state)*"
              contryuTxtFld.placeholder = "\(LanguageKey.country)*"
        
                                }else{
                                     isAddValidation = false
                                    self.clientBn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                                    self.isClintFutUser = false
              adssTxtFld.placeholder = "\(LanguageKey.address)"
              statesTxtFld.placeholder = "\(LanguageKey.state)"
              contryuTxtFld.placeholder = "\(LanguageKey.country)"
    }
}

@IBAction func client(_ sender: UIButton) {

}

  func setuomethard(){
        
      let selectedDate = datePicker!.date
      let formatter = DateFormatter()
      var isdateFormt = ""
      isdateFormt =   UserDefaults.standard.value(forKey: "clickDate") as? String ?? ""
      
      var persimissionOn = ""
      persimissionOn =   UserDefaults.standard.value(forKey: "persimissionOn") as? String ?? ""
      
      //persimissionOn
      formatter.dateFormat="dd-MM-yyyy"
      let strd = formatter.string(from: selectedDate)
      startDateLbl.text = strd
      
      if  persimissionOn == "On"{
          startDateLbl.text = isdateFormt
      }else{
          startDateLbl.text = strd
      }
      
      formatter.dateFormat="dd-MM-yyyy"
      let strf = formatter.string(from: selectedDate)
      endDateLbl.text = strf
      
      if  persimissionOn == "On"{
          endDateLbl.text = isdateFormt
      }else{
          endDateLbl.text = strf
      }
      
             
        }

func getCountry() -> NSArray {
     return getJson(fileName: "countries")["countries"] as! NSArray
 }
 
 func getStates() -> NSArray {
     return getJson(fileName: "states")["states"] as! NSArray
 }
    func callMethodforOpenDwop(tag : Int){
        if(self.optionalVw != nil){
            self.removeOptionalView()
            return
        }
        
        switch tag {
        case 0:
            
            
            if(clientBn.imageView?.image == UIImage(named: "BoxOFUncheck")){
                self.clientBn.setImage(UIImage(named: "BoxOFCheck"), for: .normal)
                
                self.isClintFutUser = true
            }else{
                self.clientBn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                self.isClintFutUser = false
                
            }
            
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 0
                self.openDwopDown( txtField: clientTxtFld, arr: arrOfShowData)
            }else{
                self.removeOptionalView()
            }
            
            
            break
        case 1:
            
            if(self.optionalVw == nil){
                sltDropDownTag = 1
                
                arrOfShow = getJson(fileName: "countries")["countries"] as! [Any]
                self.openDwopDown( txtField: self.contryuTxtFld, arr: arrOfShow)
                
            }else{
                self.removeOptionalView()
            }
            
            break
        case 3:
            
            sltDropDownTag = 3
            if(self.optionalVw == nil){
                self.arrOfShow = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: nil) as! [FieldWorkerDetails]
                print(arrOfShow.count)
                if(arrOfShowData.count > 0){
                    self.openDwopDown(txtField: self.assignToTxtFld, arr: self.arrOfShow)
                }
                
            }else{
                self.removeOptionalView()
                
            }
            break
        case 2:
            sltDropDownTag = 2
            
            if(self.optionalVw == nil){
                let namepredicate: NSPredicate = NSPredicate(format:"self.name == %@", self.contryuTxtFld.text! )
                let arr = getCountry().filtered(using: namepredicate)
                if(arr.count > 0){
                    let dict = (arr[0] as? [String : Any])
                    let serchCourID = dict?["id"]
                    let bPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                    arrOfShow =  getStates().filtered(using: bPredicate)
                    self.openDwopDown( txtField: self.statesTxtFld, arr: arrOfShow)
                }
                
                
            }else{
                self.removeOptionalView()
                
            }
            
            break
            
            
        default:
            return
        }
    }

@IBAction func contry(_ sender: Any) {
}

@IBAction func stats(_ sender: Any) {
}

@IBAction func city(_ sender: Any) {
}


@IBAction func clientBtn(_ sender: Any) {
}

    @IBAction func addAppoinmentBtn(_ sender: Any) {
        
        
        if  isAddValidation == false {
            
            
            let trimmClintNm  = trimString(string: self.clientTxtFld.text!)
            
            
            if (trimmClintNm != ""){
                
                if !isHaveNetowork() {
                    if imgArr.count > 0 {
                        
                        ShowError(message: LanguageKey.offline_feature_alert, controller: windowController)
                        
                    }else{
                        AddAppoiment()
                    }
                }else{
                    OnlineAttachmentAddAppoiment()
                }
                
            }else{
                ShowError(message: AlertMessage.clientName, controller: windowController)
            }
            
            
        }else{
            
            let trimmClintNm  = trimString(string: self.clientTxtFld.text!)
            let trimmAdr = trimString(string: self.adssTxtFld.text!)
            let trimmContary = trimString(string: self.contryuTxtFld.text!)
            let trimmState = trimString(string: self.statesTxtFld.text!)
            
            if (trimmClintNm != ""){
                if(trimmAdr != ""){
                    if(trimmContary != ""){
                        if(trimmState != ""){
                            AddAppoiment()
                        } else {
                            ShowError(message: AlertMessage.validState, controller: windowController)
                        }
                    } else {
                        ShowError(message: AlertMessage.selectCountry, controller: windowController)
                    }
                }else{
                    ShowError(message: AlertMessage.validAddress, controller: windowController)
                }
            }else{
                ShowError(message: AlertMessage.clientName, controller: windowController)
            }
            
        }
        
        
    }
 
 
 func textFieldDidBeginEditing(_ textField: UITextField) {
     self.sltTxtField = textField
     self.sltDropDownBtnTag = textField.tag
     
     
     if clientTxtFld == textField {

self.callMethodforOpenDwop(tag: 0)
      }
      if contryuTxtFld == textField {
                 self.callMethodforOpenDwop(tag: 1)
             }
      if statesTxtFld == textField {
                 self.callMethodforOpenDwop(tag: 2)
             }
      if assignToTxtFld == textField {
          
      
                 self.callMethodforOpenDwop(tag: 3)
            
             }
      if moNoTxtFld == textField {
                        self.callMethodforOpenDwop(tag:4)
                    }
      if postalCdTxtFld == textField {
                        self.callMethodforOpenDwop(tag: 5)
                    }
    
  }
  
  //=====================================
  // MARK:- Optional view Detegate
  //=====================================

   
     func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return 50.0
     }
     
     func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


       if (sltDropDownTag == 0) {
          return FltArrClintList.count != 0 ? FltArrClintList.count : arrOfShowData.count //arrOfShowData.count
       }
       else if (sltDropDownTag == 1) {
          return arrOfShow.count
       }
       else if (sltDropDownTag == 2) {

             return arrOfShow.count
       }

       else if (sltDropDownTag == 3) {
          return arrOfShow.count
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
              
              let clintList = self.FltArrClintList.count != 0 ? self.FltArrClintList[indexPath.row] : arrOfShowData[indexPath.row]
                        
                      //  cell?.textLabel?.text = clintList.nm?.capitalizingFirstLetter()
                   cell?.textLabel?.text = clintList.nm?.capitalizingFirstLetter()
                break
            case 1:
                cell?.textLabel?.text =  ((arrOfShow[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()

                break

           case 2:

           cell?.textLabel?.text = ((arrOfShow[indexPath.row] as? [String : Any])?["name"] as? String)?.capitalizingFirstLetter()


               break
           case 3:
               cell?.textLabel?.text = (self.arrOfShow[indexPath.row] as? FieldWorkerDetails)?.fnm?.capitalizingFirstLetter()

            default: break

            }

       
       
           return cell!
         
     }
     
    func optionView(_ OptiontableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if (sltDropDownTag == 0) {
            
            self.moLbl_Hight.constant = 70
            self.moImg_Hieght.constant = 70
            self.moVW_Hieght.constant = 70
            self.clientBn.isHidden = true
            moNoTxtFld.textColor = UIColor.lightGray
            emailTxtFld.textColor = UIColor.lightGray
            adssTxtFld.textColor = UIColor.lightGray
            contryuTxtFld.textColor = UIColor.lightGray
            statesTxtFld.textColor = UIColor.lightGray
            cityTxtFld.textColor = UIColor.lightGray
            postalCdTxtFld.textColor = UIColor.lightGray
            
            // desTxtFld.isUserInteractionEnabled = false
            moNoTxtFld.isUserInteractionEnabled = false
            emailTxtFld.isUserInteractionEnabled = false
            adssTxtFld.isUserInteractionEnabled = false
            contryuTxtFld.isUserInteractionEnabled = false
            statesTxtFld.isUserInteractionEnabled = false
            cityTxtFld.isUserInteractionEnabled = false
            postalCdTxtFld.isUserInteractionEnabled = false
            
            let objOfArr = self.FltArrClintList.count != 0 ? self.FltArrClintList[indexPath.row] : arrOfShowData[indexPath.row]
            self.clientTxtFld.text  = objOfArr.nm
            param.nm = objOfArr.nm
            param.cltId = objOfArr.cltId
            self.desTxtFld.text  = arrOfShowData[indexPath.row].note
            let query = "cltId = '\(objOfArr.cltId!)' AND def = '1'"
            let arrOfContNm = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
            if(arrOfContNm.count > 0){
                let contact = arrOfContNm[0]
                moNoTxtFld.text = contact.mob1
                param.conId = contact.conId
                emailTxtFld.text = contact.email
                
                
                let arrOfSiteNm = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
                if(arrOfSiteNm.count > 0){
                    let site = arrOfSiteNm[0]
                    param.siteId = site.siteId
                    cityTxtFld.text = site.city
                    adssTxtFld.text = site.adr
                    postalCdTxtFld.text = site.zip
                    let ctrsname = filterStateAccrdToCountry(serchCourID: (site.ctry)!, searchPredicate: "id", arr: getCountry() as! [Any])
                    let statename = filterStateAccrdToCountry(serchCourID: (site.state)!, searchPredicate: "id", arr: getStates() as! [Any])
                    contryuTxtFld.text = ctrsname.count != 0 ? (ctrsname[0] as? [String : Any])!["name"] as? String  : ""
                    statesTxtFld.text = statename.count != 0 ? (statename[0] as? [String : Any])!["name"] as? String : ""
                    param.ctry = ctrsname.count>0 ? site.ctry : ""
                    param.state = statename.count>0 ? site.state : ""
                    self.cityId = ctrsname.count>0 ? site.ctry! : ""
                    self.statusId =  statename.count>0 ? site.state! : ""
                    
                    
                }
                
            }
        }
        else if (sltDropDownTag == 1) {
            self.contryuTxtFld.text = (arrOfShow[indexPath.row] as? [String : Any])?["name"] as? String
            let countryID = (arrOfShow[indexPath.row] as? [String : Any])?["id"] as? String
            param.ctry = countryID
            self.cityId = countryID!
            let idPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", countryID! )
            let arrOfstate =  getStates().filtered(using: idPredicate)
            self.statesTxtFld.text = (arrOfstate[0] as? [String : Any])?["name"] as? String
            param.state = (arrOfstate[0] as? [String : Any])?["id"] as? String
        }
        else if (sltDropDownTag == 2) {
            
            
            self.statesTxtFld.text =  (arrOfShow[indexPath.row] as? [String : Any])?["name"] as? String
            param.state = (arrOfShow[indexPath.row] as? [String : Any])?["id"] as? String
            self.statusId = ((arrOfShow[indexPath.row] as? [String : Any])?["id"] as? String)!
            
        }
        
        else if (sltDropDownTag == 3) {
            self.view.endEditing(true)
            let isExist = self.FltWorkerId.contains(((self.arrOfShow[indexPath.row] as? FieldWorkerDetails)?.usrId)!)
            if(!isExist){
                createTags(strName: ((self.arrOfShow[indexPath.row] as? FieldWorkerDetails)?.fnm)!, view: self.tagView)
                self.FltWorkerId.append(((self.arrOfShow[indexPath.row] as? FieldWorkerDetails)?.usrId)!)
            }
            self.assignToTxtFld.text = ""
            
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
    
    func removeOptionalView(){
             if optionalVw != nil {
                 self.optionalVw?.removeFromSuperview()
                 self.optionalVw = nil
             }
         }
      
    func getClientListFromDB() -> Void {
        
        if isAdded {
            showDataOnTableView(query: nil)
        }
       

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
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.removeOptionalView()
        
        if(self.sltTxtField.isEqual(clientTxtFld)){

            moNoTxtFld.text = ""
            emailTxtFld.text = ""
            cityTxtFld.text = ""
            adssTxtFld.text = ""
            postalCdTxtFld.text = ""
            contryuTxtFld.text = ""
            statesTxtFld.text = ""

        }
        
        textField.text = ""
        return true
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.sltDropDownBtnTag = textField.tag
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        
        switch self.sltDropDownBtnTag {
        case 0:
            
            
            moNoTxtFld.text = ""
            emailTxtFld.text = ""
            cityTxtFld.text = ""
            adssTxtFld.text = ""
            postalCdTxtFld.text = ""
            contryuTxtFld.text = ""
            statesTxtFld.text = ""
            
            
            moNoTxtFld.isUserInteractionEnabled = true
            emailTxtFld.isUserInteractionEnabled = true
            adssTxtFld.isUserInteractionEnabled = true
            contryuTxtFld.isUserInteractionEnabled = true
            statesTxtFld.isUserInteractionEnabled = true
            cityTxtFld.isUserInteractionEnabled = true
            postalCdTxtFld.isUserInteractionEnabled = true
            
            moNoTxtFld.textColor = UIColor.gray
            emailTxtFld.textColor = UIColor.gray
            adssTxtFld.textColor = UIColor.gray
            contryuTxtFld.textColor = UIColor.gray
            statesTxtFld.textColor = UIColor.gray
            cityTxtFld.textColor = UIColor.gray
            postalCdTxtFld.textColor = UIColor.gray
            
            
            FltArrClintList = self.filterArrUsingpredicate(txtFid: textField, txt: string , range : range , arr : arrOfShowData, predecateIdentity: "nm") as! [ClientList]
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.clientTxtFld, arr: FltArrClintList)
            }
            self.optionalVw?.isHidden = false
            DispatchQueue.main.async{
                if(self.FltArrClintList.count > 0){
                    
                    
                    self.clientBn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                    
                    self.moLbl_Hight.constant = 70
                    self.moImg_Hieght.constant = 70
                    self.moVW_Hieght.constant = 70
                    
                    self.clientBn.isHidden = true
                    
                    self.moNoTxtFld.textColor = UIColor.gray
                    self.emailTxtFld.textColor = UIColor.gray
                    self.adssTxtFld.textColor = UIColor.gray
                    self.contryuTxtFld.textColor = UIColor.gray
                    self.statesTxtFld.textColor = UIColor.gray
                    self.cityTxtFld.textColor = UIColor.gray
                    self.postalCdTxtFld.textColor = UIColor.gray
                    //  self.removeOptionalView()
                    // desTxtFld.isUserInteractionEnabled = false
                    self.moNoTxtFld.isUserInteractionEnabled = true
                    self.emailTxtFld.isUserInteractionEnabled = true
                    self.adssTxtFld.isUserInteractionEnabled = true
                    self.contryuTxtFld.isUserInteractionEnabled = true
                    self.statesTxtFld.isUserInteractionEnabled = true
                    self.cityTxtFld.isUserInteractionEnabled = true
                    self.postalCdTxtFld.isUserInteractionEnabled = true
                    self.clientBn.isHidden = true
                    
                    // self.removeOptionalView()
                    //
                    self.clientBn.isHidden = false
                    
                    self.optionalVw?.table_View?.reloadData()
                }else{
                    if(result != ""){ // When Txtfield emprt remove dropdown buttton
                        self.removeOptionalView()
                        self.clientBn.isHidden = false
                        
                        self.clientBn.setImage(UIImage(named: "BoxOFUncheck"), for: .normal)
                        
                    }else{
                        self.removeOptionalView()
                        //
                        self.moImg_Hieght.constant = 0
                        self.moVW_Hieght.constant = 0
                        self.moLbl_Hight.constant = 0
                        self.clientBn.isHidden = true
                        
                    }
                }
            }
            break
            
            
        case 1:
            let bPredicate: NSPredicate = NSPredicate(format: "self.name beginswith[c] %@", result)
            arrOfShow =  getCountry().filtered(using: bPredicate)
            if(self.optionalVw == nil){
                self.openDwopDown( txtField: self.contryuTxtFld, arr: arrOfShowData)
            }
            DispatchQueue.main.async{
                if(self.arrOfShowData.count > 0){
                    self.optionalVw?.isHidden = false
                    self.optionalVw?.table_View?.reloadData()
                }else{
                    self.optionalVw?.isHidden = true
                }
            }
            
            break
            
        case 2:
            
            let namepredicate: NSPredicate = NSPredicate(format:"self.name = %@", contryuTxtFld.text! )
            let arr = getCountry().filtered(using: namepredicate)
            if(arr.count > 0){
                self.optionalVw?.isHidden = false
                let dict = (arr[0] as? [String : Any])
                let serchCourID = dict?["id"]
                let idPredicate: NSPredicate = NSPredicate(format:"self.country_id == %@", serchCourID! as! CVarArg )
                let arrOfstate =  getStates().filtered(using: idPredicate)
                let bPredicate: NSPredicate = NSPredicate(format: "self.name beginswith[c] %@", result)
                arrOfShow =  ((arrOfstate as NSArray).filtered(using: bPredicate))
                if(self.optionalVw == nil){
                    self.openDwopDown( txtField: self.statesTxtFld, arr: arrOfShowData)
                }
            }
            DispatchQueue.main.async{
                if(self.arrOfShowData.count > 0){
                    self.optionalVw?.isHidden = false
                    self.optionalVw?.table_View?.reloadData()
                }else{
                    self.optionalVw?.isHidden = true
                }
            }
            break
        case 4:
            
            if (textField == moNoTxtFld){
                
                if (string != "") && (textField.text?.count)! > 14 {
                    return false
                }
                
                let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
            
            
            break
        case 5:
            if (textField == postalCdTxtFld){
                
                if (string != "") && (textField.text?.count)! > 7 {
                    return false
                }
                
                //                                                   let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                //                                                   let compSepByCharInSet = string.components(separatedBy: aSet)
                //                                                   let numberFiltered = compSepByCharInSet.joined(separator: "")
                //                                                   return string == numberFiltered
            }
            
        default: break
            
        }
        
        
        
        return true
    }
     
    
     func filterArrUsingpredicate(txtFid : UITextField? , txt : String , range : NSRange? , arr : [Any] , predecateIdentity : String) -> [Any]{
         
         let predicateStr: NSString;
         if(txtFid != nil && range != nil){
              predicateStr =
                 (txtFid!.text as NSString?)!.replacingCharacters(in: range!, with: txt) as NSString
         }else{
             predicateStr = txt as NSString
         }
         
         let bPredicate: NSPredicate = NSPredicate(format: "self.%@ contains[c] %@", predecateIdentity ,predicateStr)
     
             return (arr as NSArray).filtered(using: bPredicate)
     }
   
     
     @IBAction func clientDropDwBtn(_ sender: Any) {
         
 
         
     }

  
    @IBAction func AddAtchmntBtn(_ sender: Any) {
        self.forDic = true
        
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
                    
                    
                })
            }
        }
        let document = UIAlertAction(title: LanguageKey.document, style: .default)
        { _ in
            
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document", "com.microsoft.excel.xls","org.openxmlformats.spreadsheetml.sheet",kUTTypePDF as String], in: .import)
            // documentPicker.delegate = self
            APP_Delegate.showBackButtonTextForFileMan()
            self.present(documentPicker, animated: true, completion: nil)
        }
        
        actionSheetControllerIOS8.addAction(gallery)
        actionSheetControllerIOS8.addAction(camera)
        actionSheetControllerIOS8.addAction(document)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        killLoader()
         picker.dismiss(animated: true, completion: nil)
         self.H_Des.constant = 50
         APP_Delegate.hideBackButtonText()
     }
     
     fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
         return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
     }

     // Helper function inserted by Swift 4.2 migrator.
     fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
         return input.rawValue
     }
     
     public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//         let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//          if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
//           imgView.image = image as? UIImage
            
            
            if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)).rawValue)] != nil{
        let imgStruct = ImageModel_AddAppointmentVC(img: (info[.originalImage] as? UIImage)?.resizeImage_AddAppointmentVC(targetSize: CGSize(width: 1000.0, height: 10000.0)))
                imgView.image = (imgStruct.img!)
            
             let imgSting = imgView.image?.pngData()?.base64EncodedString()
            param.attachments = imgSting
            param.atechmentType = "img"
                
                
                self.addImageInline(image: (info[.originalImage] as? UIImage)!)
                      let imgStructDes = ImageModel(img: (info[.originalImage] as? UIImage)?.resizeImage(targetSize: CGSize(width: 200.0, height: 200.0)), id: getTempIdForNewAttechment(newId: 0))
                      imgArr.append(imgStructDes)
                      self.H_DesView.constant = self.H_DesView.constant+100
                    //  stringToHtmlFormate()
                

          }
          
      
          
          self.dismiss(animated: true, completion: { () -> Void in
              
          })
      }

 
     @IBAction func doneBtn(_ sender: Any) {

         isClear = false
         
         self.bigView.isHidden = true
         let date = self.datePicker.date
         let formatter = DateFormatter()
        

        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                    if enableCustomForm == "0"{
                        formatter.dateFormat = "dd-MM-yyyy h:mm a"
                    }else{
                        formatter.dateFormat = "dd-MM-yyyy HH:mm"
                    }
                }
      //   formatter.dateFormat = "dd-MM-yyyy h:mm a"
         formatter.timeZone = TimeZone.current
         
         if let langCode = getCurrentSelectedLanguageCode() {
             formatter.locale = Locale(identifier: langCode)
         }
         
         let strDate = formatter.string(from: date)
         if(isStartScheduleBtn){
             let arr = strDate.components(separatedBy: " ")
             
             if arr.count == 2 {
                 startDateLbl.text = arr[0]
                 startTimeLbl.text = arr[1]
             }else{
                 startDateLbl.text = arr[0]
                 startTimeLbl.text = arr[1] + " " + arr[2]
             }
             
            
             
         }else{
             let schStartDate = self.startDateLbl.text! + " " +  self.startTimeLbl.text!
            if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
                if enableCustomForm == "0"{
                  let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy)
                  if(value == "orderedDescending"){
                      ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                  }else{
                      let arr = strDate.components(separatedBy: " ")
                      
                      if arr.count == 2 {
                          endDateLbl.text = arr[0]
                          endTimeLbl.text = arr[1]
                      }else{
                          endDateLbl.text = arr[0]
                          endTimeLbl.text = arr[1] + " " + arr[2]
                      }
                  }
                }else{
                    let value = compareTwodate(schStartDate: schStartDate, schEndDate: strDate, dateFormate: DateFormate.dd_MM_yyyy_HH_mm)
                    if(value == "orderedDescending"){
                        ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.dateMustBeGreater, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
                    }else{
                        let arr = strDate.components(separatedBy: " ")
                        
                        if arr.count == 2 {
                            endDateLbl.text = arr[0]
                            endTimeLbl.text = arr[1]
                        }else{
                            endDateLbl.text = arr[0]
                            endTimeLbl.text = arr[1] + " " + arr[2]
                        }
                    }
                }
            }
             
             
         }
        
             
//         if startTimes == true{
//              let selectedDate = datePicker!.date
//              let formatter = DateFormatter()
//              formatter.dateFormat = "hh:mm a"
//            if let langCode = getCurrentSelectedLanguageCode() {
//                formatter.locale = Locale(identifier: langCode)
//            }
//                        let str = formatter.string(from: selectedDate)
//                        startTimeLbl.text = str
//                     //endTimeLbl.text = str
//         }
//         if startTimee == true {
//
//            //////////////
//
//            let selectedDate = datePicker!.date
//                     let formatter = DateFormatter()
//                                formatter.dateFormat="hh:mm a"
//                    if let langCode = getCurrentSelectedLanguageCode() {
//                                   formatter.locale = Locale(identifier: langCode)
//                               }
//                                let str = formatter.string(from: selectedDate)
//
//            let schStartDate = self.startTimeLbl.text
//            let value = compareTwodate(schStartDate: schStartDate!, schEndDate: str, dateFormate: DateFormate.hh_mm_a)
//                      if(value == "orderedDescending"){
//                          ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.err_start_end_time, controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert,callback: {_,_ in})
//                      }else{
//                         let selectedDate = datePicker!.date
//                         let formatter = DateFormatter()
//                         formatter.dateFormat="hh:mm a"
//                         if let langCode = getCurrentSelectedLanguageCode() {
//                                formatter.locale = Locale(identifier: langCode)
//                                    }
//                                    let str = formatter.string(from: selectedDate)
//                                endTimeLbl.text = str
//                      }
//
//
//            //////////////// "dd-MM-yyyy"
//
//
//
//         }
//
//         if startDates == true {
//              let selectedDate = datePicker!.date
//             let formatter = DateFormatter()
//             formatter.dateFormat="dd-MM-yyyy"
//             let str = formatter.string(from: selectedDate)
//             startDateLbl.text = str
//            endDateLbl.text = str
//
//         }
//        if startDatee == true {
//          let selectedDate = datePicker!.date
//             let formatter = DateFormatter()
//             formatter.dateFormat="dd-MM-yyyy"
//             let str = formatter.string(from: selectedDate)
//             endDateLbl.text = str
//         }
//           self.bigView.isHidden = true
         
     }


    @IBAction func cancelBtn(_ sender: Any) {
         self.bigView.isHidden = true
    }
    
    
    @IBAction func startDateBtn(_ sender: Any) {
          self.datePicker.datePickerMode = .date
       
       let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.year = -5
        let minDate = calendar.date(byAdding: comps, to: Date())
       
         datePicker.minimumDate = minDate
        startDates = true
        startDatee = false
        startTimes = false
        startTimee = false
        self.view.endEditing(true)
        self.bigView.isHidden = false
    }
    
    @IBAction func endDateBtn(_ sender: Any) {
            self.datePicker.datePickerMode = .date
       let formatter = DateFormatter()
       formatter.dateFormat = "dd-MM-yyyy"
          let dateText = formatter.date(from: startDateLbl.text!)
          self.datePicker.minimumDate = dateText
        
        startDates = false
        startDatee = true
        startTimes = false
        startTimee = false
        self.view.endEditing(true)
        self.bigView.isHidden = false
    }
    
    @IBAction func startTimeBtn(_ sender: Any) {
           self.datePicker.datePickerMode = .time
        startTimes = true
        startDates = false
        startDatee = false
        startTimee = false
        self.view.endEditing(true)
        self.bigView.isHidden = false
    }
    
    @IBAction func endTimeBtn(_ sender: Any) {
           self.datePicker.datePickerMode = .time
        startTimee = true
        startDates = false
        startDatee = false
        startTimes = false
        self.view.endEditing(true)
        self.bigView.isHidden = false
    }
    
            
            
    func filterStateAccrdToCountry(serchCourID : String, searchPredicate : String , arr : [Any])-> [Any]{
         let bPredicate: NSPredicate = NSPredicate(format:"self.%@ == %@", searchPredicate ,serchCourID )
         return (arr as NSArray).filtered(using: bPredicate)
         
     }
    
    //====================================================
    //MARK:-  Create Tags
    //====================================================
        func createTags(strName : String , view : ASJTagsView){
            view.addTag(strName, withHeight: 0, withtagFont: UIFont.systemFont(ofSize: 10.0), withDeleteBtn: true)
               view.deleteBlock = {(tagText : String ,idx : Int) -> Void in
               view.deleteTag(at: idx)
              self.FltWorkerId.remove(at: idx)
            }
        }
    
    //=====================================
    // MARK:- Get addExpence Service
    //=====================================
    
    func Addappointment(){
        DispatchQueue.main.async {
        self.navigationController?.popViewController(animated: true)
            
}
    }
    

//=======================
 // MARK:- Other methods
 //=======================
 func getClintListFrmDB() -> Void {
     let query = "isactive = 1"
     arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as! [ClientList]
     FltArrClintList = arrOfShowData
 }

//==============================
   // MARK:- Save data in DataBase
   //==============================
   func saveSiteInDataBase( data : [SiteVCRespDetails] ) -> Void {
       for jobs in data{
           let query = "siteId = '\(jobs.siteId!)'"
           let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
           if isExist.count > 0 {
               if(jobs.isdelete == "0"){
                   let existingJob = isExist[0]
                   DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
               }else{
                   let existingJob = isExist[0]
                   existingJob.setValuesForKeys(jobs.toDictionary!)
                  // DatabaseClass.shared.saveEntity()
               }
           }else{
               if(jobs.isdelete != "0"){
                   let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
                   userJobs?.setValuesForKeys(jobs.toDictionary!)
                  // DatabaseClass.shared.saveEntity()
               }
           }
       }

       DatabaseClass.shared.saveEntity(callback: { _ in})

   }


//==============================
   // MARK:- Save data in DataBase
   //==============================
   func saveClintInDataBase( data : [ClientListData]) -> Void {
       
       for jobs in data{
           let query = "cltId = '\(jobs.cltId!)'"
           let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: query) as! [ClientList]
           if isExist.count > 0 {
               if(jobs.isdelete == "0"){
                   let existingJob = isExist[0]
                   DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                   
               }else{
                   let existingJob = isExist[0]
                   existingJob.setValuesForKeys(jobs.toDictionary!)
                   //DatabaseClass.shared.saveEntity()
               }
               
           }else{
               if(jobs.isdelete != "0"){
                   let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientList")
                   userJobs?.setValuesForKeys(jobs.toDictionary!)
                  // DatabaseClass.shared.saveEntity()
               }
           }
       }
        DatabaseClass.shared.saveEntity(callback: { _ in})
   }


//=====================================
  // MARK:- Get Clint List Service
  //=====================================
  
  func getClientSink(){
      /*
       "compId -> company id
       limit -> limit (No. of rows)
       index -> index value
       search -> search value
       isactive ->0 - deactive clients,1 - active clients, no value - all clients "
       */
      
      if !isHaveNetowork() {
          return
      }
      
      let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientSink) as? String
      
      let param = Params()
      param.compId = getUserDetails()?.compId
      param.limit = "120"
      param.index = "0"
      param.search = ""
      param.isactive = ""
      param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
      
      
      serverCommunicator(url: Service.getClientSink, param: param.toDictionary) { (response, success) in
          if(success){
              let decoder = JSONDecoder()

              if let decodedData = try? decoder.decode(ClientResponse.self, from: response as! Data) {
                  if decodedData.success == true{
                      
                      //Request time will be update when data comes otherwise time won't be update
                      UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSink)
                      if decodedData.data.count > 0 {
                          self.saveClintInDataBase(data: decodedData.data)
                          self.getClintListFrmDB()
                      }else{
                         
                      }
                  }else{
                     // ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                      
                          killLoader()
                          if let code =  decodedData.statusCode{
                              if(code == "401"){
                                  ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                      if (Ok){
                                          DispatchQueue.main.async {
                                              (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                          }
                                      }
                                  })
                              }
                          }else{
                              ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                          }
                      }
                  }
      else{
                  ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
              }
          }else{
              //ShowError(message: "Please try again!", controller: windowController)
          }
      }
  }


   //==============================
     // MARK:- Save contact data in DataBase
     //==============================
     func saveUserContactInDataBase( data : [ContactRespsDetails]) -> Void {
         
         for jobs in data{
             let query = "conId = '\(jobs.conId!)'"
             let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: query) as! [ClientContactList]
             if isExist.count > 0 {
                 
                 if(jobs.isdelete == "0"){
                     let existingJob = isExist[0]
                     DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                 }else{
                     let existingJob = isExist[0]
                     existingJob.setValuesForKeys(jobs.toDictionary!)
                     //DatabaseClass.shared.saveEntity()
                 }
                 
             }else{
                 if(jobs.isdelete != "0"){

                     let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientContactList")
                     userJobs?.setValuesForKeys(jobs.toDictionary!)
                     //DatabaseClass.shared.saveEntity()
                 }
             }
         }
         
          DatabaseClass.shared.saveEntity(callback: { _ in})
         
     }
    //=====================================
    // MARK:- Get Contact List  Service
    //=====================================
    
    func getClientContactSink(){
        /*
         compId-> company id
         limit->limit
         index->index
         dateTime->date time (only for update)
         */
        
        if !isHaveNetowork() {
            return
        }
        
        let param = Params()
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientContactSink) as? String
        
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = ""
        param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
        
        serverCommunicator(url: Service.getClientContactSink, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(ContactResps.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        DatabaseClass.shared.saveEntity(callback: { _ in
                            
                            if decodedData.data.count > 0 {
                                self.saveUserContactInDataBase(data: decodedData.data)
                            }
                            
                            //Request time will be update when data comes otherwise time won't be update
                            UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientContactSink)
                            
                        })
                    
                    }else{
                        //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        
                            killLoader()
                            if let code =  decodedData.statusCode{
                                if(code == "401"){
                                    ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                        if (Ok){
                                            DispatchQueue.main.async {
                                                (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                            }
                                        }
                                    })
                                }
                            }else{
                                ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                            }
                        }
                
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
        //  }
    }
    
        func getTempIdForNewJob(newId : Int) -> String {
            
            return "Appointment-\(String(describing: getUserDetails()?.usrId ?? ""))-\(getCurrentTimeStamp())"

        }
    
//    cltId -> client id
//    siteId -> site id
//    conId -> contact id
//    leadId -> Lead Id [If appointment create from inside the lead otherwise 0]
//    des -> description
//    schdlStart -> shedule start
//    schdlFinish -> shedule finish
//    nm-> client name
//    snm-> site name
//    cnm -> contact name
//    email -> email
//    mob1 -> mobile no.1
//    mob2 -> mobile no.2
//    adr -> address
//    city -> city
//    state -> state
//    ctry -> country
//    zip -> zipcode
//    memIds -> members id array
//    appDoc-> Document array
//    clientForFuture -> [1->save client for future : 0 ->Not]
//    siteForFuture -> [1->site for future : 0 -> Not]
//    contactForFuture -> [1->contact for future : 0 -> Not]
    

    func AddAppoiment (){
        
        let temp = getTempIdForNewJob(newId: 0)
        param.tempId = temp
        param.appId = temp
        param.type = "1"
        param.cltId = param.cltId == nil ?  "" : param.cltId
        param.label = ""
        param.des = self.desTxtFld.text
        param.status = "12"
        param.memIds =   (FltWorkerId.count == 0 ? [] : FltWorkerId) //(FltWorkerId.count == 1 ? [] : FltWorkerId))
        param.nm = self.clientTxtFld.text
        param.leadId = "0"
        param.siteId =  param.siteId == nil ? "" : param.siteId
        param.conId = ""
        param.snm = ""
        param.cnm = ""
        param.appDoc = []
        param.clientForFuture = isClintFutUser ? "1" : "0"
        param.siteForFuture = "0"
        param.contactForFuture = "0"
        
        
        var schTime12 = ""
        var endTime12 = ""
        
        let dateFormatter = DateFormatter()
        //    dateFormatter.dateFormat = "h:mm a"
        
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                dateFormatter.dateFormat = "h:mm a"
            }else{
                dateFormatter.dateFormat = "HH:mm"
            }
        }
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter.locale = Locale(identifier: langCode)
        }
        let date = dateFormatter.date(from: self.startTimeLbl.text!)
        dateFormatter.dateFormat = "HH:mm:ss"
        schTime12 = dateFormatter.string(from: date!)
        //print(schTime12)
        
        
        let dateFormatter1 = DateFormatter()
        
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                dateFormatter1.dateFormat = "h:mm a"
            }else{
                dateFormatter1.dateFormat = "HH:mm"
            }
        }
        //  dateFormatter1.dateFormat = "h:mm a"
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter1.locale = Locale(identifier: langCode)
        }
        let date1 = dateFormatter1.date(from: self.endTimeLbl.text!)
        dateFormatter1.dateFormat = "HH:mm:ss"
        endTime12 = dateFormatter1.string(from: date1!)
        //print(endTime12)
        
        param.schdlStart =  (self.startDateLbl.text! + " " + schTime12)
        param.schdlFinish =  (self.endDateLbl.text! + " " + endTime12)
        
        //2018-08-09 15:27:00
        
        var schdlStartStr = ""
        var schdlFinishStr = ""
        
        if param.schdlStart != "" {
            schdlStartStr = convertDateStringToTimestampAppoiment(dateString: param.schdlStart!)
        }
        
        if param.schdlFinish != "" {
            schdlFinishStr = convertDateStringToTimestampAppoiment(dateString: param.schdlFinish!)
        }
        
        
        param.cnm = "" //param.conId == nil ? "" :  param.conId
        param.email = self.emailTxtFld.text
        param.mob1 = self.moNoTxtFld.text
        param.mob2 = ""
        param.adr = self.adssTxtFld.text
        param.city = self.cityTxtFld.text
        
        param.zip = self.postalCdTxtFld.text
        param.landmark = ""
        
        
        let userJobss = DatabaseClass.shared.createEntity(entityName: "AppointmentList") as! AppointmentList
        
        
        userJobss.appId = temp
        userJobss.type = "1"
        userJobss.cltId = param.cltId == nil ?  "" : param.cltId
        userJobss.label = ""
        userJobss.des = self.desTxtFld.text
        userJobss.status = "12"
        userJobss.kpr = (FltWorkerId.count == 0 ? [] : FltWorkerId) as NSObject
        userJobss.nm = self.clientTxtFld.text
        userJobss.schdlStart = schdlStartStr
        userJobss.schdlFinish = schdlFinishStr
        userJobss.cnm = "" //param.conId == nil ? "" :  param.conId
        userJobss.email = self.emailTxtFld.text
        userJobss.mob1 = self.moNoTxtFld.text
        userJobss.mob2 = ""
        userJobss.adr = self.adssTxtFld.text
        userJobss.city = self.cityTxtFld.text
        userJobss.state =  param.state
        userJobss.ctry = param.ctry
        userJobss.zip = self.postalCdTxtFld.text
        userJobss.landmark = ""
        
        DatabaseClass.shared.saveEntity(callback: {_ in
            if self.callbackForJobVC != nil {
                self.callbackForJobVC!(true)
            }
        })
        
        
        
        param.dateTime =  currentDateTime24HrsFormate()
        param.cltId = param.cltId == nil ?  "" : param.cltId
        param.nm =  param.cltId == "" ? param.nm : ""
        let dict =  param.toDictionary
        
        
        let userJobs = DatabaseClass.shared.createEntity(entityName: "OfflineList") as! OfflineList// jugalpratap
        userJobs.apis = Service.addAppointment
        userJobs.parametres = dict?.toString
        // print(dict)
        userJobs.time = Date()
        
        DatabaseClass.shared.saveEntity(callback: {_ in
            DatabaseClass.shared.syncDatabase()
            self.navigationController?.popViewController(animated: true)
        })
        
    }
   

    func OnlineAttachmentAddAppoiment(){
        
        var params = [String: Any]()
        let temp = getTempIdForNewJob(newId: 0)
        params["tempId"] = temp
        params["appId"] = temp
        params["type"] = "1"
        params["cltId"] = param.cltId == nil ?  "" : param.cltId
        params["label"] = ""
        
        if forDic == true {
            params["des"] = self.stringToHtml//self.desTxtFld.text
        }else{
            params["des"] = self.textView.text
        }
        params["ctry"] = cityId
        params["state"] = statusId
        params["memIds"] = (FltWorkerId.count == 0 ? [] : FltWorkerId) 
        params["nm"] = self.clientTxtFld.text
        params["leadId"] = "0"
        params["siteId"] =  param.siteId == nil ? "" : param.siteId
        params["conId"] = ""
        params["snm"] = ""
        params["cnm"] = ""
        params["appDoc"] = []
        params["clientForFuture"] = isClintFutUser ? "1" : "0"
        params["siteForFuture"] = "0"
        params["contactForFuture"] = "0"
        
        var schTime12 = ""
        var endTime12 = ""
        
        let dateFormatter = DateFormatter()
   
        
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{
            if enableCustomForm == "0"{
                dateFormatter.dateFormat = "h:mm a"
            }else{
                dateFormatter.dateFormat = "HH:mm"
            }
        }
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter.locale = Locale(identifier: langCode)
        }
        let date = dateFormatter.date(from: self.startTimeLbl.text!)
        dateFormatter.dateFormat = "HH:mm:ss"
        schTime12 = dateFormatter.string(from: date!)
     
        let dateFormatter1 = DateFormatter()
        
        if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{
            if enableCustomForm == "0"{
                dateFormatter1.dateFormat = "h:mm a"
            }else{
                dateFormatter1.dateFormat = "HH:mm"
            }
        }
       
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter1.locale = Locale(identifier: langCode)
        }
        let date1 = dateFormatter1.date(from: self.endTimeLbl.text!)
        dateFormatter1.dateFormat = "HH:mm:ss"
        endTime12 = dateFormatter1.string(from: date1!)
    
        
        params["schdlStart"] =  (self.startDateLbl.text! + " " + schTime12)
        params["schdlFinish"] =  (self.endDateLbl.text! + " " + endTime12)
        
     
        var schdlStart = isClear ? "" : (self.startDateLbl.text! + " " + schTime12)
        var schdlFinish = isClear ? "" : (self.endDateLbl.text! + " " + endTime12)
        
        
        if schdlStart != "" {
            // params["schdlStart"] = convertDateStringToTimestampAppoiment(dateString: schdlStart)
        }
        
        if schdlFinish != "" {
            //  params["schdlFinish"] = convertDateStringToTimestampAppoiment(dateString: schdlFinish)
        }
        
        params["cnm"] = "" //param.conId == nil ? "" :  param.conId
        params["email"] = self.emailTxtFld.text
        params["mob1"] = self.moNoTxtFld.text
        params["mob2"] = ""
        params["adr"] = self.adssTxtFld.text
        params["city"] = self.cityTxtFld.text
        params["zip"] = self.postalCdTxtFld.text
        params["landmark"] = ""
        params["dateTime"] = currentDateTime24HrsFormate()
        params["cltI"] = param.cltId == nil ?  "" : param.cltId
        params["nm"] = param.cltId == "" ? param.nm : ""
       
        showLoader()
        serverCommunicatorUplaodImageInArrayForInputField(url: Service.addAppointment, param: params, images: imgArr , imagePath:"appDoc[]") { (response, success) in
            killLoader()
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AddAppointmentRes.self, from: response as! Data) {
                   
                    if decodedData.success == true{
                        
                        DispatchQueue.main.async {
                            killLoader()
                          
                            self.showToast(message:LanguageKey.add_appointment)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    
                     ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                ShowError(message: "Please try again!", controller: windowController)
            }
        }
    
    }
       
       
        
       @IBAction func btnAddImage(_ sender: Any) {
           
           self.textView.text = ""
           
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
                       
                       
                       
                   })
               }
           }
           
           let gallery = UIAlertAction(title: LanguageKey.gallery, style: .default)
           { _ in
               if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                 showLoader()
                   self.imagePicker.delegate = self
                   self.imagePicker.sourceType = .photoLibrary;
                   self.imagePicker.allowsEditing = false
                   APP_Delegate.showBackButtonText()
                   self.present(self.imagePicker, animated: true, completion: {
                       
                       
                   })
               }
           }
           actionSheetControllerIOS8.addAction(gallery)
           actionSheetControllerIOS8.addAction(camera)
           self.present(actionSheetControllerIOS8, animated: true, completion: nil)
       }
    
    //=====================================
    // MARK:- Get Clint Sit List  Service
    //=====================================
    
    func getClientSiteSink(){
        /*
         compId-> company id
         limit->limit
         index->index
         dateTime->date time (only for update)
         */
        
        if !isHaveNetowork() {
            return
        }
        
        let param = Params()
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getClientSiteSink) as? String
        
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = ""
        param.dateTime = currentDateTime24HrsFormate()//jugal//lastRequestTime ?? ""
        
        
        serverCommunicator(url: Service.getClientSiteSink, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(SiteVCResp.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data.count > 0 {
                            self.saveSiteIdInDataBase(data: decodedData.data)
                        }
                        
                        UserDefaults.standard.set(CurrentDateTime(), forKey: Service.getClientSiteSink)
                    }else{
                        killLoader()
                        if let code =  decodedData.statusCode{
                            if(code == "401"){
                                ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                    if (Ok){
                                        DispatchQueue.main.async {
                                            (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                        }
                                    }
                                })
                            }
                        }else{
                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                //  ShowAlert(title: "Network Error", message: "Please try again!", controller: windowController, cancelButton: "Ok", okButton: nil, style: UIAlertControllerStyle.alert, callback: {, in})
            }
        }
        // }
    }
    
    //==============================
    // MARK:- Save data in DataBase
    //==============================
    func saveSiteIdInDataBase( data : [SiteVCRespDetails] ) -> Void {
        for jobs in data{
            let query = "siteId = '\(jobs.siteId!)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: query) as! [ClientSitList]
            if isExist.count > 0 {
                if(jobs.isdelete == "0"){
                    let existingJob = isExist[0]
                    DatabaseClass.shared.deleteEntity(object: existingJob, callback: { (_) in})
                }else{
                    let existingJob = isExist[0]
                    existingJob.setValuesForKeys(jobs.toDictionary!)
                    // DatabaseClass.shared.saveEntity()
                }
            }else{
                if(jobs.isdelete != "0"){
                    let userJobs = DatabaseClass.shared.createEntity(entityName: "ClientSitList")
                    userJobs?.setValuesForKeys(jobs.toDictionary!)
                    // DatabaseClass.shared.saveEntity()
                }
            }
        }
        
        DatabaseClass.shared.saveEntity(callback: { _ in})
        
    }
    
   }
   struct ImageModel_AddAppointmentVC {
       var img: UIImage?
      
   }

   extension UIImage {
       func resizeImage_AddAppointmentVC(targetSize: CGSize) -> UIImage {
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

//=================================
//MARK: View controller Extension
//=================================
extension AddAppointmentVC {
    
    func getTempIdForNewAttechment(newId : Int) -> String {
        
        return "\(getCurrentTimeStamp())"
        
    }
    //PickerView Delegate Methods
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        self.addImageInline(image: (info[.originalImage] as? UIImage)!)
//        let imgStruct = ImageModel(img: (info[.originalImage] as? UIImage)?.resizeImage(targetSize: CGSize(width: 200.0, height: 200.0)), id: getTempIdForNewAttechment(newId: 0))
//        imgArr.append(imgStruct)
//        self.H_Des.constant = 100
//        stringToHtmlFormate()
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("Did cancel")
//        self.H_Des.constant = 50
//        picker.dismiss(animated: true, completion: nil)
//    }

    //=================================
    //MARK: Other methods
    //=================================
    func addImageInline(image: UIImage) {
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        //images.append(image)
        let oldwidth: CGFloat = textAttachment.image?.size.width ?? 0
        let scaleFactor = oldwidth/150 // resize image
        textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        DispatchQueue.main.async {
              killLoader()
            print("Successfully converted string to HTML")
        }
        textView.textStorage.insert(attrStringWithImage, at: textView.selectedRange.location)
    }

    //====================================================//
    // convert string to html formate
    //====================================================//
    func stringToHtmlFormate(){
        let finalText = self.textView.attributedText

        DispatchQueue.global(qos: .background).async {
            self.stringToHtml = finalText!.toHtml() ?? ""
            let urlPaths = self.stringToHtml.imagePathsFromHTMLString()
            //print(urlPaths)// get all images fake paths

            for (index,model) in self.imgArr.enumerated() {
                let imageId = "_jobAttSeq_\(index)_"
                if imageId != "" {
                     self.stringToHtml = self.stringToHtml.replacingOccurrences(of: urlPaths[index], with: imageId)
                }
            }

            //print(self.stringToHtml)

            DispatchQueue.main.async {
                  killLoader()
                print("Successfully converted string to HTML")
            }
        }
    }
}

