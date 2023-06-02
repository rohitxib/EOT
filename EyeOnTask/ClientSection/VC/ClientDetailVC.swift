 //
//  ClientDetailVC.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 08/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class ClientDetailVC: UIViewController {

    @IBOutlet weak var imgLatLong: UIImageView!
    @IBOutlet weak var mapViewBtn: UIView!
    @IBOutlet weak var H_latLongView: NSLayoutConstraint!
    @IBOutlet weak var btnLbl: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var letLbl: UILabel!
    @IBOutlet weak var longLbl: UILabel!
    @IBOutlet weak var tittleReferance: UILabel!
    @IBOutlet weak var referanceLbl: UILabel!
    @IBOutlet weak var lblNoteDesView: UILabel!
    @IBOutlet weak var btnOkDesView: UIButton!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblIndustry: UILabel!
    @IBOutlet weak var lblTinNo: UILabel!
    @IBOutlet weak var lblGst: UILabel!
    @IBOutlet weak var lblAccountTyp: UILabel!
    @IBOutlet weak var lblAccountDtl: UILabel!
    @IBOutlet weak var lblClientDetail: UILabel!
    @IBOutlet weak var lblAddressUp: UILabel!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet weak var lblClientNamelower: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMobile1: UILabel!
    @IBOutlet weak var lblMobile2: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var descriptionView: UIView!
    @IBOutlet var textDescriptionView: UITextView!
    @IBOutlet weak var lblGST: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var lblTIN: UILabel!
    @IBOutlet weak var lblInsdustry: UILabel!
    
    var clientDetails : ClientList?
    var arrOfReferenceList = [ReferenceList]()
     var arrofcompenysetting =  getCompanySettingsDetails()
  //  var lastRequestTime = UserDefaults.standard.value(forKey: "getcompany")
    override func viewDidLoad() {
        super.viewDidLoad()
     
        getReferenceListDBjob()
        getCompanySettings()
       // print(arrOfReferenceList)
        if getDefaultSettings()?.isJobLatLngEnable == "0" {
            H_latLongView.constant = 0.0
            mapViewBtn.isHidden = true
            imgLatLong.isHidden = true
            titleLbl.isHidden = true
            longLbl.isHidden = true
            letLbl.isHidden = true
        }
        
      let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        setLocalization()
        
        ActivityLog(module:Modules.client.rawValue , message: ActivityMessages.clientDetails)
        
        lblMobile1.text =  clientDetails?.mob1
        lblMobile2.text = clientDetails?.mob2
        lblEmail.text = clientDetails?.email
        //lblAddress.text = "\(clientDetails?.adr),\(clientDetails?.city),\(clientDetails?.state)"
        lblAddress.text = "\(clientDetails?.adr)"
    }
    
    func setLocalization() -> Void {
       // self.navigationItem.title = LanguageKey.client_details
        lblClientNamelower.text = LanguageKey.client_name
        lblAddressUp.text = LanguageKey.address
        lblClientDetail.text = LanguageKey.client_details
        lblAccountDtl.text = LanguageKey.account_details
        lblAccountTyp.text = "\(LanguageKey.Account_type) :"
      //  lblGst.text = "\(LanguageKey.gst_no) :"
      //  lblTinNo.text = "\(LanguageKey.tin_no) :"
        lblIndustry.text = "\(LanguageKey.industry) :"
        lblNote.text = LanguageKey.notes
        tittleReferance.text = LanguageKey.reference
        lblNoteDesView.text = LanguageKey.notes
        btnOkDesView.setTitle(LanguageKey.ok , for: .normal)
        btnView.setTitle(LanguageKey.view , for: .normal)
        titleLbl.text = LanguageKey.lat_and_lng
        // btnLbl.setTitle(LanguageKey.get_current_lat_long , for: .normal)
        btnLbl.setTitle(LanguageKey.map_on_view , for: .normal)
        
     
        
    }
    
    @objc func addTapped() -> Void {
        performSegue(withIdentifier: "EditClient", sender: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
//        self.parent?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
//        self.parent?.navigationItem.rightBarButtonItem?.isEnabled = true
//
        let image = UIImage(named:"Edit.png")
//        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = true
            button.tintColor = UIColor.white
            self.parent?.navigationItem.rightBarButtonItem?.target = self
            self.parent?.navigationItem.rightBarButtonItem?.action = #selector(addTapped)
            self.parent?.navigationItem.rightBarButtonItem?.image = image
        }else{
            self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        }
        //let isExistSite12 = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: nil) as? [ClientSitList]
        
        self.parent?.title = LanguageKey.client_details
         letLbl.text = clientDetails?.lat?.capitalizingFirstLetter() ?? "0"
        longLbl.text = clientDetails?.lng?.capitalizingFirstLetter() ?? "0"
 
        lblClientName.text = clientDetails?.nm?.capitalizingFirstLetter() ?? ""
       // let queryOFSiteAndContact = "cltId = '\(clientDetails?.cltId! ?? "")' && def = 1 "
        //let isExistSite = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: queryOFSiteAndContact) as? [ClientSitList]
        let queryOFSiteAndContact = "cltId = '\(String(describing: clientDetails?.cltId ?? ""))'"
           let isExistSite = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: queryOFSiteAndContact) as! [ClientSitList]
        
        
        
        if isExistSite.count != 0 && isExistSite != nil {
            lblAddress.text  = isExistSite[0].adr
           // lblAddress.text = cltSiteDetails.adr?.capitalizingFirstLetter()
         // lblAddress.attributedText =  lineSpacing(string: address!, lineSpacing: 7.0)
        }else{
            lblAddress.text = ""
        }
        
        if let addressString = clientDetails?.adr {
          //  lblAddress.attributedText =  lineSpacing(string: addressString, lineSpacing: 7.0)
        }else{
           // lblAddress.text = ""
        }
        
         let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: queryOFSiteAndContact) as? [ClientContactList]
        if  isExist?.count != 0 && isExist != nil{
            
            let cltContactDetails = isExist![0]
            lblMobile1.text = cltContactDetails.mob1 ?? ""
            lblMobile2.text = cltContactDetails.mob2 ?? ""
            lblEmail.text = cltContactDetails.email ?? ""
            
        }else{
           // lblMobile1.text =  ""
           // lblMobile2.text =  ""
           // lblEmail.text =  ""
        }
        
//        lblMobile1.text =  clientDetails?.mob1
//        lblMobile2.text = clientDetails?.mob2
//        lblEmail.text = clientDetails?.email
      //  lblAddress.text = "\(clientDetails?.adr ?? "" ),\(clientDetails?.city ?? "" ),\(clientDetails?.state ?? "" )"
       
        
        
        let result = clientDetails?.pymtType
        var query = ""
        if result != nil && result != "" {
            query = "accId = '\(result!)'"
        }
        let arrOfObj = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserAccType", query: query == "" ? nil : query) as! [UserAccType]
        
        if arrOfObj.count > 0{
            lblAccountType.text = arrOfObj[0].type ?? ""
        }else{
            lblAccountType.text = ""
        }
        
         let aaa = clientDetails?.referral
        
        
        for refarray in arrOfReferenceList {
            if refarray.refId == aaa{
                self.referanceLbl.text = refarray.refName
            }
        }
        
            
      
        lblGST.text = clientDetails?.gstNo
        lblTIN.text = clientDetails?.tinNo
       // descriptionLbl.text = clientDetails?.note
        
        if let desString = clientDetails?.note {
            descriptionLbl.attributedText =  lineSpacing(string: desString, lineSpacing: 4.0)
            if trimString(string: descriptionLbl.text!) == "" {
                 btnView.isHidden = true
            }
        }else{
            descriptionLbl.text = ""
            btnView.isHidden = true
        }
        
        
        
        //For Industry
        if(clientDetails?.industry != nil && clientDetails?.industry != "0"){
            
            let results = clientDetails?.industry
            var querys = ""
            if results != "" && results != nil{
                querys = "industryId = '\(results!)'"
                let arrOfObjs = DatabaseClass.shared.fetchDataFromDatabse(entityName: "IndustryList", query: querys == "" ? nil : querys) as! [IndustryList]
                if arrOfObjs.count > 0 {
                    lblInsdustry.text = arrOfObjs[0].industryName ?? ""//clientDetail?.industryName
                }
                
                // param.industry = clientDetail?.industry
            }
            // lblInsdustry.text =  clientDetails?.industry
        }else {
            lblInsdustry.text = ""
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditClient"{
                let clintDetail = segue.destination as! EditClientVC
                clintDetail.clientDetail = clientDetails
        }
    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 3 { // set your total tabs here
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    @IBAction func lavigationBtn(_ sender: Any) {
       
        if  ((clientDetails?.lat) != nil) &&  ((clientDetails?.lng) != nil)  {
                       if  UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
                           openGoogleMap(latitude: clientDetails!.lat!, longitude: clientDetails!.lng!)
                       } else  {
                           openAppleMap(lat: clientDetails!.lat!, long: clientDetails!.lng!)
                       }
                   } else {
                       ShowError(message: AlertMessage.locationNotAvailable , controller: self)
                   }
    }
    
    
    func openGoogleMap(latitude: String?,longitude:String?, locationAddress : String = "") {
           
           if locationAddress == "" {
               
               let directionsRequest: String = "comgooglemaps://" + "?daddr=\(latitude ?? ""),\(longitude ?? "")" + "&x-success=sourceapp://?resume=true&x-source=AirApp"
               
               //    let strUrl = String(format: "comgooglemaps://?saddr=%@,%@&daddr=%@,%@&directionsmode=driving&zoom=14&views=traffic", lat, long, latitude ?? "", longitude ?? "")
               
               guard let url = URL(string: directionsRequest) else {
                   return
               }
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
               
           } else {
               if let address = locationAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                   let directionsRequest: String = "comgooglemaps://" + "?daddr=\(address)" + "&x-success=sourceapp://?resume=true&x-source=AirApp"
                   //    let strUrl = String(format: "comgooglemaps://?saddr=%@,%@&daddr=%@&directionsmode=driving&zoom=14&views=traffic", lat, long, address)
                   
                   let directionsURL: NSURL = NSURL(string: directionsRequest)!
                   let application:UIApplication = UIApplication.shared
                   if (application.canOpenURL(directionsURL as URL)) {
                       application.open(directionsURL as URL, options: [:], completionHandler: nil)
                   }
               }
           }
           
       }
    
    
    func openAppleMap(lat: String?,long: String?,locationAddress: String = ""){
          
          var components = URLComponents()
          components.scheme = "https"
          components.host = "maps.apple.com"
          components.path = "/"
          
          if locationAddress == "" {
              components.queryItems = [
                  // URLQueryItem(name: "saddr", value: "\(curruntlat),\(curruntlong)"),
                  URLQueryItem(name: "daddr", value: "\(lat?.description ?? ""),\(long?.description ?? "")"),
              ]
          } else {
              components.queryItems = [
                  // URLQueryItem(name: "saddr", value: "\(curruntlat),\(curruntlong)"),
                  URLQueryItem(name: "daddr", value: locationAddress),
              ]
          }
          
          // Getting a URL from our components is as simple as
          let ur1l = components.url
          guard let url = ur1l else {
              return
          }
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
          
      }
    
    @IBAction func detailInstructionViewBtn(_ sender: Any) {
        if clientDetails?.note == nil || clientDetails?.note == "" {
            ShowError(message: AlertMessage.Note_not_available, controller: self)
            return
        }
        
        showBackgroundView()
        textDescriptionView.text = clientDetails?.note
        textDescriptionView.textContainerInset = UIEdgeInsets.init(top: 8,left: 5,bottom: 8,right: 8); // top, left, bottom, right
        view.addSubview(descriptionView)
        descriptionView.center = CGPoint(x: backgroundView.frame.width / 2, y: backgroundView.frame.height / 2)
    }
    
    
    
    @IBAction func closeDetailBtn(_ sender: Any) {
        hideBackgroundView()
    }
    
    @IBAction func tapOnBackgrounVw(_ sender: Any) {
        hideBackgroundView()
    }
    
    
    func showBackgroundView() {
        backgroundView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.backgroundColor = UIColor.black
            self.backgroundView.alpha = 0.5
        })
    }
    
    func hideBackgroundView() {
        if (descriptionView != nil) {
            descriptionView.removeFromSuperview()
        }
       
        self.backgroundView.isHidden = true
        self.backgroundView.backgroundColor = UIColor.clear
        self.backgroundView.alpha = 1
    }
    
    func getCompanySettings(){
        /*
         compId -> Company id
         limit -> limit
         index -> index value
         search -> search value
         dateTime -> date time
         */
        
        
        if !isHaveNetowork() {
            return
        }

        let param = Params()
        param.compId = getUserDetails()?.compId
        serverCommunicator(url: Service.getCompanySettings, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(getCompanySettingsResponse.self, from: response as! Data) {
                    
                
                    if decodedData.success == true{
                 
                      //  UserDefaults.standard.set(self.arrofcompenysetting, forKey: "getcompany")
                        DispatchQueue.main.async{
                            self.arrofcompenysetting = decodedData.data
                            self.lblGst.text = "\(self.arrofcompenysetting.gstLabel ?? ""):"
                            self.lblTinNo.text = "\(self.arrofcompenysetting.tinLabel ?? ""):"
                    
                        }
                    }else{
                        //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }

    func getReferenceListDBjob() -> Void {
              
            
                  showReferenceDataOnTableViewJob(query: nil)
              
    }
    
    func showReferenceDataOnTableViewJob(query : String?) -> Void {
         let arrOfIndustry = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ReferenceList", query: query) as! [ReferenceList]
         
         if arrOfIndustry.count > 0 {
             
             for data in arrOfIndustry {
                 
                 if arrOfReferenceList.contains(where: { $0.refId == data.refId }) {
                     // found
                 } else {
                     // not
                     arrOfReferenceList.append(data)
                     self.arrOfReferenceList = self.arrOfReferenceList.sorted(by: { (Obj1, Obj2) -> Bool in
                         let Obj1_Name = Obj1.refName ?? ""
                         let Obj2_Name = Obj2.refName ?? ""
                         return (Obj1_Name.localizedCaseInsensitiveCompare( Obj2_Name) == .orderedAscending)
                     })
                     
                 }
             }
             
         }
         
         
         DispatchQueue.main.async {
           //  self.optionalVw?.isHidden = self.arrOfIndustryList.count > 0 ? false : true
         }
     }
}
