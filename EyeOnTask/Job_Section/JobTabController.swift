//
//  JobTabController.swift
//  EyeOnTask
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import CoreData
class JobTabController: UITabBarController, UITabBarControllerDelegate {
    
    var name : String?
    var objOfUserJobList : UserJobList?
    var tabUserJob = UserJobList()
    var jobs = [UserJobList]()
    var chatmodel = [ChatModel]()
    var isChatTabSelected = false
    var callback: ((Bool,NSManagedObject) -> Void)?
    var customCollectionVew : CustomCollectionView?
    var chatBadgePosition = 2
    var btnMore : UIButton?
    var invoiceId = ""
    var objOfUserAppintList : CommanListDataModel?
    var CustomFormNmListArr = [CustomFormNmList]()
    
    private lazy var bgView: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        btn.addTarget(self, action: #selector(removeBgView(sender:)), for: UIControl.Event.touchUpInside)
        btn.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateJobCard()
        SetBackBarButtonCustom()
        self.delegate = self
        let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
        var controllers = [UIViewController]()
        let detailCon = storyboard.instantiateViewController(withIdentifier: "detailJobVC") as! DetailJobVC
        detailCon.tabBarItem = UITabBarItem(title: LanguageKey.job_details, image: UIImage(named: "detail_selected"), tag: 0)
        detailCon.objOfUserJobListInDetail = objOfUserJobList
        detailCon.jobArray = jobs
        detailCon.callbackDetailVC = callback
        controllers.append(detailCon)
        let isfooter = getDefaultSettings()?.footerMenu
        let JobItemQuantityFormEnable = getDefaultSettings()?.isJobItemQuantityFormEnable
        let  isItem = isPermitForShow(permission: permissions.isItemVisible)
        
        // for ary in isfooter! {
        if isfooter?.count != nil {
            for i in 0 ..< isfooter!.count{
                if i < 4 {
                    
                    if isfooter![i].isEnable == "1"{
                        if isfooter![i].menuField == "set_feedbackMenuOdrNo"{
                            if self.isChatTabSelected == true {
                                let chatCon = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
                                chatCon.tabBarItem = UITabBarItem(title: LanguageKey.title_chat, image: UIImage(named: "Chat_icon_unselected_footer"), tag: 1)
                                chatCon.objOfUserJobListInDetail = objOfUserJobList
                                controllers.append(chatCon)
                            }else{
                                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "feedbackVC") as! FeedbackVC
                                vc.tabBarItem = UITabBarItem(title:LanguageKey.title_feedback, image: UIImage(named: "FeedbackGray"), tag: 1)
                                vc.objOfUserJobListInDetail = self.objOfUserJobList
                                vc.tabBarItem = UITabBarItem(title: LanguageKey.title_feedback, image: UIImage(named: "FeedbackGray"), tag: 1)
                                controllers.append(vc)
                            }
                        }
                        
                    }
                    if isfooter![i].isEnable == "1"{
                        if isfooter![i].menuField == "set_historyMenuOdrNo"{
                            if self.isChatTabSelected == true {
                                let chatCon = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
                                chatCon.tabBarItem = UITabBarItem(title: LanguageKey.title_chat, image: UIImage(named: "Chat_icon_unselected_footer"), tag: 1)
                                chatCon.objOfUserJobListInDetail = objOfUserJobList
                                controllers.append(chatCon)
                            }else{
                                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                let feedVC = storyboard.instantiateViewController(withIdentifier: "history") as! HistoryVC
                                feedVC.objOfUserJobListInDetail = self.objOfUserJobList
                                feedVC.tabBarItem = UITabBarItem(title: LanguageKey.title_history, image: UIImage(named: "History_icon_unselcted"), tag: 1)
                                controllers.append(feedVC)
                            }
                        }}
                    if isfooter![i].isEnable == "1"{
                        if isfooter![i].menuField == "set_paymentMenuOdrNo"{
                            if self.isChatTabSelected == true {
                                let chatCon = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
                                chatCon.tabBarItem = UITabBarItem(title: LanguageKey.title_chat, image: UIImage(named: "Chat_icon_unselected_footer"), tag: 1)
                                chatCon.objOfUserJobListInDetail = objOfUserJobList
                                controllers.append(chatCon)
                            }else{
                                let storyboard = UIStoryboard(name: "Payment", bundle: nil)
                                let pmnt = storyboard.instantiateViewController(withIdentifier: "PAYMENTVC") as! PaymentVC
                                pmnt.objOfUserJobListInDetail = self.objOfUserJobList
                                pmnt.tabBarItem = UITabBarItem(title: LanguageKey.title_payment, image: UIImage(named: "Payment"), tag: 1)
                                controllers.append(pmnt)
                            }
                            
                        }}
                    if isfooter![i].isEnable == "1"{
                        if isfooter![i].menuField == "set_invoiceMenuOdrNo"{
                            if self.objOfUserJobList!.canInvoiceCreated == 0 {
                                ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.invoice_can_not_generate_msg)!, controller: windowController)
                            }else{
                                
                                let data =  (self.objOfUserJobList?.itemData as! [AnyObject])
                                if data.count > 0 {
                                    self.getInvoiceRecord()
                                    let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
                                    let invoiceCon = storyboard.instantiateViewController(withIdentifier: "invoiceVC") as! InvoiceVC
                                    invoiceCon.objOfUserJobListInDetail = self.objOfUserJobList
                                    // invoiceCon.invoiceRes = self.eniVoiceResp
                                    invoiceCon.tabBarItem = UITabBarItem(title: LanguageKey.title_invoice, image: UIImage(named: "Invoice"), tag: 1)
                                    controllers.append(invoiceCon)
                                    
                                } else {
                                    ShowAlert(title: AlertMessage.invoiceNotGenerate, message: "" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {(_,_) in})
                                    
                                }
                                
                                // self.getInvoiceRecord()
                            }
                            
                        }}
                    if isfooter![i].isEnable == "1"{
                        if isfooter![i].menuField == "set_clientChatMenuOdrNo"{
                            let storyboard = UIStoryboard(name: "MainClientChat", bundle: nil)
                            let pmnt = storyboard.instantiateViewController(withIdentifier: "CLIENTCHATE") as!  ClientChatVC
                            pmnt.objOfUserJobListInDetail = self.objOfUserJobList
                            
                            pmnt.tabBarItem = UITabBarItem(title: LanguageKey.client_fw_chat, image: UIImage(named: "client_chat"), tag: 1)
                            controllers.append(pmnt)
                            
                        }}
                    if isfooter![i].isEnable == "1"{
                        if isfooter![i].menuField == "set_customFormMenuOdrNo"{
                            if self.isChatTabSelected == true {
                                let chatCon = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
                                chatCon.tabBarItem = UITabBarItem(title: LanguageKey.title_chat, image: UIImage(named: "Chat_icon_unselected_footer"), tag: 1)
                                chatCon.objOfUserJobListInDetail = objOfUserJobList
                                controllers.append(chatCon)
                            }else{
                                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                let feedVC = storyboard.instantiateViewController(withIdentifier: "formList") as! CustomFormListV
                                feedVC.objOfUserJobListInDetail = self.objOfUserJobList
                                feedVC.tabBarItem = UITabBarItem(title: LanguageKey.title_cutomform, image: UIImage(named: "CustomForm"), tag: 1)
                                controllers.append(feedVC)
                            }
                        }}
                    if isfooter![i].isEnable == "1"{
                        if isfooter![i].menuField == "set_equipmentMenuOrdrNo"{
                            if self.isChatTabSelected == true {
                                let chatCon = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
                                chatCon.tabBarItem = UITabBarItem(title: LanguageKey.title_chat, image: UIImage(named: "Chat_icon_unselected_footer"), tag: 1)
                                chatCon.objOfUserJobListInDetail = objOfUserJobList
                                controllers.append(chatCon)
                            }else{
                                
                                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                                let pmnt = storyboard.instantiateViewController(withIdentifier: "LinlEquipment") as! LinlEquipment
                                pmnt.objOfUserJobListInDetails = self.objOfUserJobList!
                                pmnt.tabBarItem = UITabBarItem(title: LanguageKey.detail_equipment, image: UIImage(named:  "Group 220"), tag: 1)
                                controllers.append(pmnt)
                            }
                            
                        }}
                    
                    if isfooter![i].isEnable == "1"{
                        
                        if JobItemQuantityFormEnable == "0" {
                            if isItem && isfooter![i].menuField == "set_itemMenuOdrNo"{
                                if self.isChatTabSelected == true {
                                    let chatCon = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
                                    chatCon.tabBarItem = UITabBarItem(title: LanguageKey.title_chat, image: UIImage(named: "Chat_icon_unselected_footer"), tag: 1)
                                    chatCon.objOfUserJobListInDetail = objOfUserJobList
                                    controllers.append(chatCon)
                                }else{
                                    
                                    let storyboard1 = UIStoryboard(name: "Invoice", bundle: nil)
                                    let invoiceCon = storyboard1.instantiateViewController(withIdentifier: "items") as! ItemsVC
                                    invoiceCon.tabBarItem = UITabBarItem(title: LanguageKey.items_screen_title, image: UIImage(named: "shopping-cart"), tag: 1)
                                    invoiceCon.objOfUserJobListInDetail = objOfUserJobList
                                    controllers.append(invoiceCon)
                                    
                                    chatBadgePosition = 3
                                }
                            }else{
                                chatBadgePosition = 2
                            }
                            
                        }else{
                            if isItem && isfooter![i].menuField == "set_itemMenuOdrNo"{
                                if self.isChatTabSelected == true {
                                    let chatCon = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
                                    chatCon.tabBarItem = UITabBarItem(title: LanguageKey.title_chat, image: UIImage(named: "Chat_icon_unselected_footer"), tag: 1)
                                    chatCon.objOfUserJobListInDetail = objOfUserJobList
                                    controllers.append(chatCon)
                                }else{
                                    
                                    let storyboard1 = UIStoryboard(name: "Invoice", bundle: nil)
                                    let invoiceCon = storyboard1.instantiateViewController(withIdentifier: "NewItem") as! NewItem
                                    invoiceCon.tabBarItem = UITabBarItem(title: LanguageKey.items_screen_title, image: UIImage(named: "shopping-cart"), tag: 1)
                                    invoiceCon.objOfUserJobListInDetail = objOfUserJobList
                                    controllers.append(invoiceCon)
                                    
                                    chatBadgePosition = 3
                                }
                            }else{
                                chatBadgePosition = 2
                            }
                            
                        }
                        
                    }
                    
                    if isfooter![i].isEnable == "1"{
                        if isfooter![i].menuField == "set_attachmentMenuOdrNo"{
                            
                            if self.isChatTabSelected == true {
                                let chatCon = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
                                chatCon.tabBarItem = UITabBarItem(title: LanguageKey.title_chat, image: UIImage(named: "Chat_icon_unselected_footer"), tag: 1)
                                chatCon.objOfUserJobListInDetail = objOfUserJobList
                                controllers.append(chatCon)
                            }else{
                                let attachmentCon = storyboard.instantiateViewController(withIdentifier: "document") as! DocumentVC
                                attachmentCon.tabBarItem = UITabBarItem(title: LanguageKey.title_documents, image: UIImage(named: "Document"), tag: 1)
                                let asd = UserJobList()
                                attachmentCon.objOfUserJobListInDoc = objOfUserJobList ?? asd
                                attachmentCon.callback = self.callback
                                controllers.append(attachmentCon)
                            }
                            
                        }
                    }
                    
                    if isfooter![i].isEnable == "1"{
                        if isfooter![i].menuField == "set_commentsMenuOdrNo"{
                            let chatCon = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
                            chatCon.tabBarItem = UITabBarItem(title: LanguageKey.title_chat, image: UIImage(named: "Chat_icon_unselected_footer"), tag: 1)
                            chatCon.objOfUserJobListInDetail = objOfUserJobList
                            controllers.append(chatCon)
                            
                        }
                    }
                    
                }
            }
        }

        let item1 = storyboard.instantiateViewController(withIdentifier: "more") as! MoreVC
        let icon1 = UITabBarItem(title: LanguageKey.more, image: UIImage(named: "menu3Dots.png"), selectedImage: UIImage(named: "menu3Dots.png"))
        item1.tabBarItem = icon1
        controllers.append(item1)
        
        self.viewControllers = controllers
        
        if jobs.count == 0 {
            jobs = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: nil) as! [UserJobList]
        }
        
        tabUserJob = objOfUserJobList!
        
        if objOfUserJobList?.jtId != nil {
            let ladksj  = objOfUserJobList?.jobId!.components(separatedBy: "-")
            if ladksj!.count > 0 {
                let tempId = ladksj?[0]
                if tempId != "Job" {
                    getFormName()
                }
            }
        }
      
        if isChatTabSelected {
            self.selectedIndex = chatBadgePosition
        }
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateJobCard()
        let image = UIImage(named:"icons8-menu-vertical-32")
    
       
        NotiyCenterClass.registerPopToJobVCNotifier(vc: self, selector: #selector(self.popToJobVC(_:)))
        APP_Delegate.isRegPopNoti = true
      
        self.btnMore?.isEnabled =    true
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APP_Delegate.isRegPopNoti = false
        if  chatmodel.count > 0 {
            chatmodel[0].closureName = nil
            chatmodel[0].clientClosureName = nil
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //ChatManager.shared.listenerForjob?.remove()
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
        NotiyCenterClass.removePopToJobVCNotifier(vc: self)
        btnMore?.isEnabled = false
        LocationManager.shared.stopStatusTracking()
    }
    
    @objc func addTapped(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DetailJobVC") , object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DocumentVC") , object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FeedbackVC") , object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ClientChatVC") , object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChatVC") , object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CustomFormListV") , object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HistoryVC") , object: nil)

    }
    
    func updateJobCard() {
            var isJobCardHide =  UserDefaults.standard.value(forKey: "isJobCardHide") as? String ?? ""
            
            if isJobCardHide == "True" {
                let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(addTapped))
                let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
                leftButton.setTitleTextAttributes(attributes, for: .normal)
                self.navigationItem.rightBarButtonItem = leftButton
                
                var isJobCardHide = "False"
                UserDefaults.standard.set(isJobCardHide, forKey: "isJobCardHide")
            } else {
                let leftButton = UIBarButtonItem(title: LanguageKey.job_card_bold, style: .plain, target: self, action: #selector(addTapped))
                let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
                leftButton.setTitleTextAttributes(attributes, for: .normal)
                self.navigationItem.rightBarButtonItem = leftButton
            }
        }
    
    func SetBackBarButtonCustom()
    {
        
        
        let button = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action:#selector(AuditVC.onClcikBack))
        self.navigationItem.leftBarButtonItem  = button
    }
    
    @objc func onClcikBack()
    {
        APP_Delegate.currentJobTab = nil
        ChatManager.shared.listenerForjob?.remove() //job listener remove when jobtabbar completely dismiss
        _ = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func chatModelInitiate() -> Void {
        chatmodel = ChatManager.shared.chatModels.filter { (modelData : ChatModel) -> Bool in
            if modelData.jobId == objOfUserJobList!.jobId {
                return true
            }
            return false
        }
        
        if chatmodel.count > 0{
            
            
            if chatmodel[0].count > 0{
                self.viewControllers![chatBadgePosition].tabBarItem.badgeValue = String(chatmodel[0].count)
            }else{
                self.viewControllers![chatBadgePosition].tabBarItem.badgeValue = nil
            }
            
            chatmodel[0].closureName = {(count) in
                if self.chatmodel[0].count > 0{
                    self.viewControllers![self.chatBadgePosition].tabBarItem.badgeValue = String(self.chatmodel[0].count)
                }else{
                    self.viewControllers![self.chatBadgePosition].tabBarItem.badgeValue = nil
                }
            }
        }
    
    }
    
    @objc func popToJobVC(_ notification: NSNotification){
       
        if let dict = notification.userInfo!["data"] as? [String : Any]{
            
            if(self.tabUserJob.jobId == dict["jobid"] as? String){
                DispatchQueue.main.async {
                    ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.removeJobFromAdmin, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (isCancel, isOk) in
                        if(isCancel){
                            ChatManager.shared.removeJobForChat(jobId: self.tabUserJob.jobId!)
                            DatabaseClass.shared.deleteEntity(object: self.tabUserJob, callback: { (isDelete : Bool) in
                                if (self.callback != nil){
                                    self.callback!(true, self.tabUserJob)
                                }
                            })
                        }
                    })
                }
            }else{
                NotiyCenterClass.fireJobRemoveNotifier(dict: notification.userInfo as! [String : Any])
            }
        }
       
    }
    
    
    //=============================================
    // MARK:- setUpOfCenterBtnAndHamburger Method
    //=============================================
    
    func setUpOfMoreBtn (){
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            // For More Button
            btnMore = UIButton(frame: CGRect(x: self.view.bounds.size.width - 80, y: (self.view.bounds.size.height-(50 + bottomPadding!)) , width: 80, height: 50))
            btnMore?.addTarget(self, action: #selector(moreOptionBtnAction(sender:)), for: UIControl.Event.touchUpInside)
            btnMore?.imageView?.contentMode = .scaleToFill
            
            windowController.view.addSubview(btnMore!)
        }else{
            // For More Button
            btnMore = UIButton(frame: CGRect(x: self.view.bounds.size.width - 80, y: self.view.bounds.size.height-50 , width: 80, height: 50))
            btnMore?.addTarget(self, action: #selector(moreOptionBtnAction(sender:)), for: UIControl.Event.touchUpInside)
            btnMore?.imageView?.contentMode = .scaleToFill
            windowController.view.addSubview(btnMore!)
        }
    } 
   
    @objc func moreOptionBtnAction (sender: AnyObject){
        //print("moreOptionBtnAction")
        self.openCollectionView()
    }
   
    func openCollectionView() {
        let arrMandatoryForms = APP_Delegate.arrOFCustomForm.filter { (obj) -> Bool in
            if(obj.tab == "1"){
                return true
            }else{
                return false
            }
        }
       
        customCollectionVew = CustomCollectionView.instanceFromNib() as? CustomCollectionView
        
        if chatmodel.count > 0{
            customCollectionVew?.badgeCount = String(chatmodel[0].clientCount)
        }else{
            customCollectionVew?.badgeCount = "0"
        }
       
        customCollectionVew?.setUpMethod(arr: arrMandatoryForms)
        customCollectionVew?.onHideComplete = {( isClicked : Bool? ,result : TestDetails? , controller : CollectionType) -> Void in
            self.removeAllView()
            if !isHaveNetowork(){
                let  isCustomFormEnable1 = isPermitForShow(permission: permissions.isCustomFormEnable)
                if  isCustomFormEnable1 {
                    
                    if controller == CollectionType.CustomForm {
                        isCustomFormListSelected = true
                        let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                        let feedVC = storyboard.instantiateViewController(withIdentifier: "formList") as! CustomFormListV
                        feedVC.objOfUserJobListInDetail = self.objOfUserJobList
                        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                        self.navigationController?.pushViewController(feedVC, animated: true)
                    }
                    
                }
                return
            }
            if !isHaveNetowork(){
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                return
            }
           
            if controller ==   CollectionType.History { //History
                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                let feedVC = storyboard.instantiateViewController(withIdentifier: "history") as! HistoryVC
                feedVC.objOfUserJobListInDetail = self.objOfUserJobList
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController?.pushViewController(feedVC, animated: true)
            }
            else if controller == CollectionType.Feedback { //Document
                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "feedbackVC") as! FeedbackVC
                vc.objOfUserJobListInDetail = self.objOfUserJobList!
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController!.pushViewController(vc, animated: true)
            }
            else if controller == CollectionType.Payment  { //Payment
                let storyboard = UIStoryboard(name: "Payment", bundle: nil)
                let pmnt = storyboard.instantiateViewController(withIdentifier: "PAYMENTVC") as! PaymentVC
                pmnt.objOfUserJobListInDetail = self.objOfUserJobList
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController!.pushViewController(pmnt, animated: true)
            }
            else if controller == CollectionType.Comments  {
                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                let pmnt = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
                pmnt.objOfUserJobListInDetail = self.objOfUserJobList
                
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController!.pushViewController(pmnt, animated: true)
                self.chatModelInitiate()
                
            }
            else if controller == CollectionType.Attechment  { 
                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                let pmnt = storyboard.instantiateViewController(withIdentifier: "document") as! DocumentVC
                let asd = UserJobList()
                pmnt.objOfUserJobListInDoc = self.objOfUserJobList ?? asd
                pmnt.callback = self.callback
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController!.pushViewController(pmnt, animated: true)
             
            }
            else if controller == CollectionType.Invoice {
                
                if self.objOfUserJobList!.canInvoiceCreated == 0 {
                    ShowError(message: getServerMsgFromLanguageJson(key: LanguageKey.invoice_can_not_generate_msg)!, controller: windowController)
                }else{
                   
                    let data =  (self.objOfUserJobList?.itemData as! [AnyObject])
                    if data.count > 0 {
                        
                        // already add innvoice
                        if self.objOfUserJobList?.isJobInvoiced == "1" {
                            self.getInvoiceRecord()
                            let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
                            let invoiceCon = storyboard.instantiateViewController(withIdentifier: "invoiceVC") as! InvoiceVC
                            let asd = UserJobList()
                            invoiceCon.objOfUserJobListInDetail = self.objOfUserJobList
                         
                            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                            self.navigationController!.pushViewController(invoiceCon, animated: true)
                            
                       
                        }else {
                            
                            ShowAlert(title: "", message: LanguageKey.are_you_sure_invoice, controller: windowController, cancelButton: LanguageKey.no as NSString, okButton: LanguageKey.yes as NSString, style: .alert) { (NO, OK) in
                                if OK {
                                    self.addInvoiceForMobile()
                                }
                                
                                if NO {
                                    
                                }
                            }
                        }
                       
                     
                    } else {
                        ShowAlert(title: AlertMessage.invoiceNotGenerate, message: "" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {(_,_) in})
                        return
                    }
                 
                }
                
            }else if controller == CollectionType.Item  { //Payment
                let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
                let pmnt = storyboard.instantiateViewController(withIdentifier: "items") as! ItemsVC
                pmnt.objOfUserJobListInDetail = self.objOfUserJobList
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController!.pushViewController(pmnt, animated: true)
             
            }
          
            let  isClientChats = isPermitForShow(permission: permissions.isClientChatEnable)
            if  isClientChats {
                
                if controller == CollectionType.ClientChat  { //ClientChat
                    let storyboard = UIStoryboard(name: "MainClientChat", bundle: nil)
                    let pmnt = storyboard.instantiateViewController(withIdentifier: "CLIENTCHATE") as!  ClientChatVC
                    pmnt.objOfUserJobListInDetail = self.objOfUserJobList
                    
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                    self.navigationController!.pushViewController(pmnt, animated: true)
                }
                
            }
            
            let  isEquipmentEnable = isPermitForShow(permission: permissions.isEquipmentEnable)
            if  isEquipmentEnable {
                
                if controller == CollectionType.Equipment { //Custom Form
                    
                    let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                    let pmnt = storyboard.instantiateViewController(withIdentifier: "LinlEquipment") as! LinlEquipment
                    pmnt.objOfUserJobListInDetails = self.objOfUserJobList!
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                    self.navigationController!.pushViewController(pmnt, animated: true)
                }
                
            }
            
            let  isCustomFormEnable = isPermitForShow(permission: permissions.isCustomFormEnable)
            if  isCustomFormEnable {

                if controller == CollectionType.CustomForm { //Custom Form
                    let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                    let feedVC = storyboard.instantiateViewController(withIdentifier: "formList") as! CustomFormListV
                    feedVC.objOfUserJobListInDetail = self.objOfUserJobList
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                    self.navigationController?.pushViewController(feedVC, animated: true)
                }

            }
            
        }
       
        self.bgView.backgroundColor = UIColor.clear
        self.bgView.alpha = 0.0
        self.view.addSubview(self.bgView)
        self.view.addSubview(customCollectionVew!)
        UIView.animate(withDuration: 0.2, animations: {
            self.bgView.backgroundColor = UIColor.black
            self.bgView.alpha = 0.5
        })

    }
   
    func  addInvoiceForMobile() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            return
        }
        
        showLoader()
        let param = Params()
        param.jobId = objOfUserJobList?.jobId
        param.invId = ""
      
        serverCommunicator(url: Service.addInvoiceForMobile, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(InvoiceResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        taxCalculationType = (decodedData.data?.taxCalculationType)!
                        
                        if let invId = decodedData.data?.invId{
                            self.invoiceId = invId
                        }
                      
                        if decodedData.data?.itemData?.count == 0 {
                            
                            let data = (self.objOfUserJobList?.itemData as! [AnyObject])
                            if data.count > 0 {
                                
                            } else {
                                ShowAlert(title: AlertMessage.invoiceNotGenerate, message: "" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {(_,_) in})
                                return
                            }
                            
                        }
                        
                        if decodedData.data?.isShowInList == "0" {
                            ShowAlert(title: AlertMessage.invoiceAndPreview, message: "" , controller: windowController, cancelButton:LanguageKey.no as NSString , okButton:LanguageKey.yes as NSString , style: .alert, callback: {(no,yes) in
                                
                                if yes {
                                    self.generateInvoice(invoiceRes: decodedData)
                                }
                            })
                            return
                        }
                        
                        self.navigateToInvoicePage(invoiceRes: decodedData)
                        
                    }else{
                        if (decodedData.statusCode != nil) && decodedData.statusCode == "401" {
                            ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                if (Ok){
                                    DispatchQueue.main.async {
                                        (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                    }
                                }
                            })
                        }else{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }
                }else{
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    func  getInvoiceRecord() {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            return
        }
        
        showLoader()
        let param = Params()
        param.jobId = objOfUserJobList?.jobId
        param.invId = ""

        serverCommunicator(url: Service.getInvoiceDetailMobile, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(InvoiceResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                      
                        taxCalculationType = (decodedData.data?.taxCalculationType)!
                        
                        if let invId = decodedData.data?.invId{
                            self.invoiceId = invId
                        }
                        
                        if decodedData.data?.itemData?.count == 0 {
                            
                            let data = (self.objOfUserJobList?.itemData as! [AnyObject])
                            if data.count > 0 {
                                
                            } else {
                                ShowAlert(title: AlertMessage.invoiceNotGenerate, message: "" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {(_,_) in})
                                return
                            }
                  
                        }
                     
                    }else{
                        if (decodedData.statusCode != nil) && decodedData.statusCode == "401" {
                            ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                if (Ok){
                                    DispatchQueue.main.async {
                                        (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                    }
                                }
                            })
                        }else{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }
                }else{
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    func generateInvoice(invoiceRes : InvoiceResponse) {
        
        if !isHaveNetowork() {
            ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            return
        }
        
        showLoader()
        let param = Params()
        param.isShowInList = "1"
        param.invId = invoiceId
        
        serverCommunicator(url: Service.generateInvoice, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(CommonResponse.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        invoiceRes.data?.isShowInList = "1"
                        self.navigateToInvoicePage(invoiceRes: invoiceRes)
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
    
    func navigateToInvoicePage(invoiceRes : InvoiceResponse) -> Void {
        DispatchQueue.main.async {
            let storyboard1 = UIStoryboard(name: "Invoice", bundle: nil)
            let invoiceCon = storyboard1.instantiateViewController(withIdentifier: "invoiceVC") as! InvoiceVC
            invoiceCon.objOfUserJobListInDetail = self.objOfUserJobList
            invoiceCon.invoiceRes = invoiceRes
            invoiceCon.addNewInvc = true
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(invoiceCon, animated: true)
        }
    }
   
    @objc func removeBgView (sender: AnyObject){
        DispatchQueue.main.async {
            self.removeAllView()
        }
    }
    
    func removeAllView(){
        self.bgView.removeFromSuperview()
        self.customCollectionVew?.removeFromSuperview()
        
        if ChatManager.shared.callbackClientBadge != nil {
            ChatManager.shared.callbackClientBadge = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
   
    func addBlankVCForDisplayMoreBtn(){
        DispatchQueue.main.async {
            self.btnMore?.isEnabled = true
            //print(self.viewControllers ?? "")
            let item1 = UIViewController()
            let icon1 = UITabBarItem(title: LanguageKey.more, image: UIImage(named: "menu3Dots.png"), selectedImage: UIImage(named: "menu3Dots.png"))
            item1.tabBarItem = icon1
            self.viewControllers?.append(item1)
            
        }
    }
  
    //   ================================
    //      MARK: getFormName
    //   ================================

    func getFormName(){
        if !isHaveNetowork() {
            return
            
        }
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = ContentLimit
        param.index = "0"
        param.search = ""
        param.dateTime = ""
        param.jobId = objOfUserJobList?.jobId
        param.usrId = getUserDetails()?.usrId
        
        var arrOFjit_Id = [jtIdParam]()
        for jtid in (objOfUserJobList?.jtId as! [AnyObject]) {
            let jitIdObj = jtIdParam()
            jitIdObj.jtId = (jtid as! [String:String])["jtId"]!
            jitIdObj.title = (jtid as! [String:String])["title"]!
            arrOFjit_Id.append(jitIdObj)
            
        }
        param.jtId = arrOFjit_Id
        
        var dict =  param.toDictionary
        var ids = [String]()
        let titles : [[String : String]] = dict!["jtId"] as! [[String : String]]
        
        for title in titles {
            ids.append(title["jtId"]!)
        }
        
        dict!["jtId"] = ids
        
        serverCommunicator(url: Service.getCustomFormNmList, param: dict) { (response, success) in
            
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(TestRes.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        if decodedData.data.count > 0 {
                            DispatchQueue.main.async {
                                
                                let obj = decodedData.data[0]
                                if (obj.jobid != nil && obj.jobid != ""){ //Only For Remove job when Admin Unassign job for FW
                                    
                                    ShowAlert(title: LanguageKey.dialog_alert, message: AlertMessage.removeJobFromAdmin, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (isCancel, isOk) in
                                        if(isCancel){
                                            ChatManager.shared.removeJobForChat(jobId: self.tabUserJob.jobId!)
                                            DatabaseClass.shared.deleteEntity(object: self.tabUserJob, callback: { (isDelete : Bool) in
                                                if (self.callback != nil){
                                                    self.callback!(true, self.tabUserJob)
                                                }
                                            })
                                        }
                                    })
                                }else{
                                    
                                    if decodedData.data.count > 0 {
                                        
                                        APP_Delegate.arrOFCustomForm = decodedData.data.filter({ (form) -> Bool in
                                            if form.tab == "1" && form.totalQues != "0" {
                                                return true
                                            }else{
                                                return false
                                            }
                                        })
                                    }
                                    
                                }
                            }
                            
                        }else{
                            killLoader()
                            
                        }
                    }else{
                        killLoader()
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                killLoader()
            }
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is MoreVC {
            
            self.openCollectionView()
            
            return false
        }
        
        if viewController is ItemsVC {
            UserDefaults.standard.set("True", forKey: "isJobCardHide")
        } else {
            UserDefaults.standard.set("False", forKey: "isJobCardHide")
        }
        self.updateJobCard()
        
        return true
    }
   
}//END



