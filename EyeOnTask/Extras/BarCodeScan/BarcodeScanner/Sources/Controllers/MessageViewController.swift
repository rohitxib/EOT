import UIKit

/// View controller used for showing info text and loading animation.
public final class MessageViewController: UIViewController {
  // Image tint color for all the states, except for `.notFound`.
  public var regularTintColor: UIColor = .black
  // Image tint color for `.notFound` state.
  public var errorTintColor: UIColor = .red
  // Customizable state messages.
  public var messages = StateMessageProvider()
  
  // MARK: - UI properties

  /// Text label.
  public private(set) lazy var textLabel: UILabel = self.makeTextLabel()
  /// Info image view.
  public private(set) lazy var imageView: UIImageView = self.makeImageView()
  /// Border view.
  public private(set) lazy var borderView: UIView = self.makeBorderView()
   /// TextField .
  public private(set) lazy var textField: UITextField = self.makeTextField()

  /// Blur effect view.
  private lazy var blurView: UIVisualEffectView = .init(effect: UIBlurEffect(style: .dark))
  // Constraints that are activated when the view is used as a footer.
  private lazy var collapsedConstraints: [NSLayoutConstraint] = self.makeCollapsedConstraints()
  // Constraints that are activated when the view is used for loading animation and error messages.
  private lazy var expandedConstraints: [NSLayoutConstraint] = self.makeExpandedConstraints()

    var auditId : String?
    var equipId : String?
    var barcode : String?
    var cltId : String?
    var arrOfEquipment = [LinkEquipment]()
  //  var isScanBarcode = false
    
    private var isBackEnable : Bool = false
    
  var status = Status(state: .scanning) {
    didSet {
      handleStatusUpdate()
    }
  }

  // MARK: - View lifecycle

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(blurView)
    blurView.contentView.addSubviews(textLabel, imageView, borderView,textField)
    handleStatusUpdate()
  }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isBackEnable {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  //  blurView.frame = view.bounds
    
    let screensize = UIScreen.main.bounds
    blurView.frame = CGRect(x:0 , y: screensize.origin.y - 50, width: screensize.size.width, height: 100)
    blurView.backgroundColor = .clear
  }

  // MARK: - Animations

  /// Animates blur and border view.
  func animateLoading() {
    animate(blurStyle: .light)
    animate(borderViewAngle: CGFloat(Double.pi/2))
  }

  /**
   Animates blur to make pulsating effect.

   - Parameter style: The current blur style.
   */
    private func animate(blurStyle: UIBlurEffect.Style) {
    guard status.state == .processing else { return }

    UIView.animate(
      withDuration: 2.0,
      delay: 0.5,
      options: [.beginFromCurrentState],
      animations: ({ [weak self] in
        self?.blurView.effect = UIBlurEffect(style: blurStyle)
      }),
      completion: ({ [weak self] _ in
        self?.animate(blurStyle: blurStyle == .light ? .extraLight : .light)
      }))
  }

  /**
   Animates border view with a given angle.

   - Parameter angle: Rotation angle.
   */
  private func animate(borderViewAngle: CGFloat) {
    guard status.state == .processing else {
      borderView.transform = .identity
      return
    }

    UIView.animate(
      withDuration: 0.8,
      delay: 0.5,
      usingSpringWithDamping: 0.6,
      initialSpringVelocity: 1.0,
      options: [.beginFromCurrentState],
      animations: ({ [weak self] in
        self?.borderView.transform = CGAffineTransform(rotationAngle: borderViewAngle)
      }),
      completion: ({ [weak self] _ in
        self?.animate(borderViewAngle: borderViewAngle + CGFloat(Double.pi / 2))
      }))
  }

  // MARK: - State handling

  private func handleStatusUpdate() {
    borderView.isHidden = true
    borderView.layer.removeAllAnimations()
    textLabel.text = LanguageKey.scan_barcode_manually
    
    
    
    //status.text ?? messages.makeText(for: status.state)
   // textField.text = "jugal"

    switch status.state {
    case .scanning, .unauthorized:
      textLabel.numberOfLines = 3
      textLabel.textAlignment = .left
      imageView.tintColor = errorTintColor
      textField.textAlignment = .center
    case .processing:
      textLabel.numberOfLines = 10
      textLabel.textAlignment = .center
      borderView.isHidden = false
      imageView.tintColor = errorTintColor
      textField.textAlignment = .center
    case .notFound:
      textLabel.font = UIFont.boldSystemFont(ofSize: 16)
      textLabel.numberOfLines = 10
      textLabel.textAlignment = .center
      imageView.tintColor = errorTintColor
      textField.textAlignment = .center
    }

    if status.state == .scanning || status.state == .unauthorized {
      expandedConstraints.deactivate()
      collapsedConstraints.activate()
    } else {
      collapsedConstraints.deactivate()
      expandedConstraints.activate()
    }
  }
}

// MARK: - Subviews factory

private extension MessageViewController {
    
    func makeTextField() -> UITextField {
        let TextField = UITextField()
        TextField.translatesAutoresizingMaskIntoConstraints = false
        TextField.textColor = .white
        TextField.backgroundColor = .darkGray
        TextField.layer.borderWidth = 0.5
        TextField.layer.borderColor = UIColor.white.cgColor
        TextField.font = UIFont.boldSystemFont(ofSize: 14)
        
//   //     let imageView = UIImageView(image: UIImage(named: "search_icon"))
//        imageView.frame = CGRect(x: 18, y: 3, width: imageView.image!.size.width , height: imageView.image!.size.height)
//        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
//        paddingView.addSubview(imageView)
//        TextField.rightViewMode = .always
//        TextField.rightView = paddingView
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red: 168/255, green: 212/255, blue: 250/255, alpha: 1.0)
        button.setImage(UIImage(named: "search_icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(TextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(45), height: CGFloat(35))
        button.addTarget(self, action: #selector(self.btn), for: .touchUpInside)
        TextField.rightView = button
        TextField.rightViewMode = .always
        
        return TextField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
    @objc func btn (){
        //self.textField.text = ""
        
        if !isHaveNetowork() {
           // killLoader()
            //DispatchQueue.main.async {
            DispatchQueue.global(qos: .background).async {
                 self.showErrorOnScreen(errorString:AlertMessage.checkNetwork)
            }

            return
        }
        
        
        if textField.text!.count > 0 {
            self.getEquipmentListOfflineBarcodeScanner(barcodeString: textField.text!)
           // self.getEquipmentListFromBarcodeScanner(barcodeString: textField.text!)
           
        }
        self.textField.resignFirstResponder()
    }
  func makeTextLabel() -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .white
    label.numberOfLines = 3
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }

  func makeImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = imageNamed("").withRenderingMode(.alwaysTemplate)
    imageView.tintColor = .red
    return imageView
  }

  func makeBorderView() -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    view.layer.borderWidth = 2
    view.layer.cornerRadius = 10
    view.layer.borderColor = UIColor.black.cgColor
    return view
  }
}

// MARK: - Layout

extension MessageViewController {
  private func makeExpandedConstraints() -> [NSLayoutConstraint] {
    let padding: CGFloat = 10
    let borderSize: CGFloat = 51

    return [
      imageView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor, constant: -60),
      imageView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 30),
      imageView.heightAnchor.constraint(equalToConstant: 27),

      textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18),
      textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      
      textField.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18),
      textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 47),
      textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -53),
      //textField.widthAnchor.constraint(equalToConstant:-30),
      
      borderView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -12),
      borderView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
      borderView.widthAnchor.constraint(equalToConstant: borderSize),
      borderView.heightAnchor.constraint(equalToConstant: borderSize)
    ]
  }

  private func makeCollapsedConstraints() -> [NSLayoutConstraint] {
    let padding: CGFloat = 10
    var constraints = [
      imageView.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 20),
      imageView.widthAnchor.constraint(equalToConstant: 30),
      imageView.heightAnchor.constraint(equalToConstant: 27),

      textLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -14 ),
      textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 7),
        
      textField.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
      textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:47),
      textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-55),
      textField.heightAnchor.constraint(equalToConstant:35),
   //  textField.widthAnchor.constraint(equalToConstant:-30)
        
 ]

    if #available(iOS 11.0, *) {
      constraints += [
        imageView.leadingAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.leadingAnchor,
          constant: padding
        ),
        textLabel.trailingAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.trailingAnchor,
          constant: -padding
        )
      ]
    } else {
      constraints += [
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        
      ]
    }

    return constraints
  }
    
   func getEquipmentListOfflineBarcodeScanner(barcodeString : String) -> Void{

    if barcode == "1"{
        
        var aarOfFilterEquipment = [LinkEquipment]()
        print(true)
        for equip in arrOfEquipment {
        let getEquip = equip.barcode
        if getEquip == barcodeString {
            aarOfFilterEquipment.removeAll()
            aarOfFilterEquipment.append(equip)
        
              let storyboard: UIStoryboard = UIStoryboard(name: "MainJob", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "LinkClientsEquioment") as! LinkClientsEquioment
                            let navCon = NavClientController(rootViewController: vc)
                            vc.aarOfFilterEquipment = aarOfFilterEquipment
                            vc.jobId = cltId
                           // vc.barcodeString = barcodeString
                            vc.isMsgBarcode = true
                            navCon.modalPresentationStyle = .fullScreen
                            self.present(navCon, animated: true, completion: nil)
            
            
            
            }
        }
        

           
    }else{
        
           
           if equipId == nil
           {
           var equpDataArrayAudit = [equipDataArray]()
           // var sNo:String = ""
           //let query = "audId = '\(job.audId!)'"
           let isExistAudit = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AuditOfflineList", query: nil) as! [AuditOfflineList]
           if isExistAudit.count > 0 {
           equpDataArrayAudit.removeAll()

           for audit in isExistAudit {
           for item in (audit.equArray as! [AnyObject]) {

           if item["barcode"] as? String == barcodeString
           {


           var arrTac = [AttechmentArry]()

           if item["attachments"] != nil {


           if (item["attachments"] is [AnyObject]) && ((item["attachments"] as! [AnyObject]).count > 0) {
           let attachments = item["attachments"] as! [AnyObject]
           for attechDic in attachments {
           arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
           }

           let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String, installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
           // equipmentData.append(dic)
           equpDataArrayAudit.append(dic)
           // print(equipmentDic.self)

           // if let dta = item as? equipData {
           // }
           }else {
           let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
           // equipmentData.append(dic)
           equpDataArrayAudit.append(dic)
           }


           }else{
           let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:[], type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)

           equpDataArrayAudit.append(dic)

           }



           }


           }
           }

           }
           var equpDataArrayJob = [equipDataArray]()
           // var sNo:String = ""
           let isExistJob = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: nil) as! [UserJobList]
           if isExistJob.count > 0 {
           equpDataArrayJob.removeAll()
           // equpDataArray.append(isExistAudit[0].equArray as! AuditOfflineList)
           for job in isExistJob {
           for item in (job.equArray as! [AnyObject]) {

           if item["barcode"] as? String == barcodeString
           {


           var arrTac = [AttechmentArry]()

           if item["attachments"] != nil {


           if (item["attachments"] is [AnyObject]) && ((item["attachments"] as! [AnyObject]).count > 0) {
           let attachments = item["attachments"] as! [AnyObject]
           for attechDic in attachments {
           arrTac.append(AttechmentArry(attachmentId: attechDic["attachmentId"] as? String, audId: attechDic["audId"] as? String, deleteTable: attechDic["deleteTable"] as? String, image_name: attechDic["image_name"] as? String, userId: attechDic["userId"] as? String, attachFileName: attechDic["attachFileName"] as? String, attachThumnailFileName: attechDic["attachThumnailFileName"] as? String, attachFileActualName: attechDic["attachFileActualName"] as? String, docNm: attechDic["docNm"] as? String, des: attechDic["des"] as? String, createdate: attechDic["createdate"] as? String))
           }

           let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
           // equipmentData.append(dic)
           equpDataArrayJob.append(dic)
           // print(equipmentDic.self)

           // if let dta = item as? equipData {
           // }
           }else {
           let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:arrTac, type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
           // equipmentData.append(dic)
           equpDataArrayJob.append(dic)
           }


           }else{
           let dic = equipDataArray(equId: item["equId"] as? String , equnm: item["equnm"] as? String, mno: item["mno"] as? String, sno: item["sno"] as? String, audId: item["audId"] as? String, remark: item["remark"] as? String, changeBy: item["changeBy"] as? String, status: item["status"] as? String, updateData: item["updateData"] as? String, lat: item["lat"] as? String, lng: item["lng"] as? String, location: item["location"] as? String, contrid: item["contrid"] as? String,attachments:[], type: item["type"] as? String,brand: item["brand"] as? String,expiryDate: item["expiryDate"] as? String,manufactureDate: item["manufactureDate"] as? String,purchaseDate: item["purchaseDate"] as? String,barcode: item["barcode"] as? String,equipment_group: item["equipment_group"] as? String, image: item["image"] as? String, rate: item["rate"] as? String,supId: item["supId"] as? String,supplier: item["supplier"] as? String,cltId: item["cltId"] as? String,nm: item["nm"] as? String,statusText: item["statusText"] as? String,category: item["category"] as? String,parentId: item["parentId"] as? String,ecId: item["ecId"] as? String,equComponent:[],notes: item["notes"] as? String, isPart: item["isPart"] as? String, extraField1: item["extraField1"] as? String , extraField2: item["extraField2"] as? String,usrManualDoc: item["usrManualDoc"] as? String,snm: item["snm"] as? String,datetime: item["datetime"] as? String,installedDate: item["installedDate"] as? String,servIntvalType: item["servIntvalType"] as? String,servIntvalValue: item["servIntvalValue"] as? String,equStatus: item["equStatus"] as? String,statusUpdateDate: item["statusUpdateDate"] as? String)
           equpDataArrayJob.append(dic)


           }


           }


           }
           }


           }
           var arrOFAdminEquipData = [AdminEquipmentList]()
           var arrFilterData = [EquipListDataModel]()
           arrOFAdminEquipData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AdminEquipmentList", query: nil) as! [AdminEquipmentList]

           if arrOFAdminEquipData.count>0 {

           for job in arrOFAdminEquipData {

           if job.barcode == barcodeString as String
           {
           let dic = EquipListDataModel(equId: job.equId, parentId: job.parentId, equnm: job.equnm, cltId: job.cltId, nm: job.nm, mno: job.mno, sno: job.sno, brand: job.brand, rate: job.rate, supId: job.supId, supplier: job.supplier, notes: job.notes, expiryDate: job.expiryDate, manufactureDate: job.manufactureDate, purchaseDate: job.purchaseDate, barcode: job.barcode, isusable: job.isusable, barcodeImg: job.barcodeImg, adr: job.adr, city: job.city, state: job.state, ctry: job.ctry, zip: job.zip, status: job.status, type: job.type, ecId: job.equId, egId: job.egId, ebId: job.ebId, isdelete: job.isdelete, groupName: job.groupName, image: job.image, isDisable: job.isDisable, updateDate: job.updateDate, lastAuditLabel: job.lastAuditLabel, lastAuditDate: job.lastAuditDate, equStatusOnAudit: job.equStatusOnAudit, lastAudit_id: job.lastAudit_id, lastJobLabel: job.lastJobLabel, lastJobDate: job.lastJobDate, equStatusOnJob: job.equStatusOnJob, lastJob_id: job.lastJob_id)
           arrFilterData.append(dic)

           }


           }
           }


           let jobBarcode = equpDataArrayJob.filter({$0.barcode == barcodeString})
           let auditBarcode = equpDataArrayAudit.filter({$0.barcode == barcodeString})
           let adminEquipBarcode = arrFilterData.filter({$0.barcode == barcodeString})
           UserDefaults.standard.set(barcodeString, forKey: "barcodeString")

           if jobBarcode.count != 0 && auditBarcode.count != 0 {
           //2
           let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
           vc.equipmentDetailAudit = equpDataArrayAudit
           vc.equipmentDetailJob = equpDataArrayJob
           vc.barcodeString = barcodeString


           let navCon = NavClientController(rootViewController: vc)
           navCon.modalPresentationStyle = .fullScreen
           vc.isBarcodeScanner = true
           self.present(navCon, animated: true, completion: nil)
           self.isBackEnable = true

           } else if jobBarcode.count != 0 {

           // if equpDataArrayJob.count>1 {

           let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc


           vc.equipmentDetailJob = equpDataArrayJob
           vc.barcodeString = barcodeString

           let navCon = NavClientController(rootViewController: vc)
           navCon.modalPresentationStyle = .fullScreen
           vc.isBarcodeScanner = true
           self.present(navCon, animated: true, completion: nil )


           } else if auditBarcode.count != 0 {


           //audit
           if equpDataArrayAudit.count > 1 {

           let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
           vc.equipmentDetailAudit = equpDataArrayAudit
           vc.barcodeString = barcodeString


           let navCon = NavClientController(rootViewController: vc)
           navCon.modalPresentationStyle = .fullScreen
           vc.isBarcodeScanner = true



           self.present(navCon, animated: true, completion: nil)

           }else{

           let vc = UIStoryboard(name: "MainAudit", bundle: nil).instantiateViewController(withIdentifier: "remarkTab") as! RemarkVC;
           let navCon = NavClientController(rootViewController: vc)
           vc.isPresented = true
           vc.equipment = equpDataArrayAudit[0]
           navCon.modalPresentationStyle = .fullScreen
           self.present(navCon, animated: true, completion: nil)


           }

           }
           else if adminEquipBarcode.count != 0 {

           let storyboard: UIStoryboard = UIStoryboard(name: "MainAudit", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: "EquipmentDetailVc") as! EquipmentDetailVc
           let navCon = NavClientController(rootViewController: vc)
           vc.adminEquipment = arrFilterData
           vc.barcodeString = barcodeString
           vc.isFromMssage = true
           navCon.modalPresentationStyle = .fullScreen
           self.present(navCon, animated: true, completion: nil)

           }
           else{
           self.showToast(message: "Equipment not found")
           }

           }




           else{

           if !isHaveNetowork() {
           return
           }

           let param = Params()
           param.barCode = barcodeString
           param.equId = equipId ?? ""
           print(param.toDictionary)

           serverCommunicator(url: Service.generateBarcodeUsingGivenCode, param: param.toDictionary) { (response, success) in
           if(success){
           let decoder = JSONDecoder()
           if let decodedData = try? decoder.decode(ScanBarcodeRes.self, from: response as! Data) {
           if decodedData.success == true{

           DispatchQueue.main.async {
           self.dismiss(animated: true, completion: nil)
           self.showToast(message:"Barcode Added")

           }
           }else{

           killLoader()
           if let code = decodedData.statusCode{
           if(code == "401"){
           ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
           if (Ok){
           DispatchQueue.main.async {
           (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
           }
           }
           })
           }
           }else{
           ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
           }
           }


           }else{

           }
           }else{

           }
           }

           }
          
    }
   
    }
    
    
    func showErrorOnScreen(errorString : String) -> Void {
        DispatchQueue.main.async {
            self.textLabel.text = getServerMsgFromLanguageJson(key: errorString)
            self.textLabel.textColor = .red
        }
        do {
            sleep(3)
        }
        
        DispatchQueue.main.async {
            self.textLabel.text = LanguageKey.scan_barcode_manually
            self.textLabel.textColor = .white
        }
    }
    
    
    }

class ScanBarcodeRes: Codable {
    var success: Bool?
    var message: String?
    var data: String?
    var statusCode:String?
}
