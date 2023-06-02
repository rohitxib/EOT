//
//  CustomCollectionView.swift
//  EyeOnTask
//
//  Created by mac on 11/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//shorting of footer array - accordind to order no///////////



enum CollectionType : Int , CaseIterable {
    case Feedback = 1
    case History
    case Payment
    case Invoice
    case ClientChat
    case CustomForm
    case Equipment
    case Item
    case Attechment
    case Comments
    
}

class ControllerDetail: NSObject {
    var id : CollectionType!
    var name : String!
    var image : String!
    
}


import UIKit

class CustomCollectionView: UIView {
 
    var arrOfShowData = [TestDetails]()
    var onHideComplete: ((Bool , TestDetails? , CollectionType) -> Void)?
    let reuseIdentifier = "CustomCollectionViewCell"
   
    var screenSize = UIScreen.main.bounds
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var controllerArry = [ControllerDetail]()
    var badgeLabelIndex : Int?
    var badgeCount = "0"
  //  let controllerDesArry = [CollectionType.History : ["name" : ]]
      var objOfUserJobList : UserJobList?
    var objOfUserJobListInDetail : UserJobList!
   // self.delegate = self
          let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
    
    
    lazy var collection_View : UICollectionView = {
        
        let frame = CGRect(x: screenSize.origin.x, y: screenSize.origin.y, width: screenSize.size.width, height:  300)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = false
        cv.isScrollEnabled = true
        cv.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        cv.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.backgroundColor = .white
        return cv
    }()
    
  // var collection_View: UICollectionView?
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomCollectionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
    
    
    func setUpMethod(arr : [TestDetails]){
        //self.arrFilterData.sorted(by: { $0.schdlStart! > $1.schdlStart! })
        let isfooter = getDefaultSettings()?.footerMenu//?.sorted(by: { $0.odrNo! < $1.odrNo! })
        print(isfooter)
        
        let  isItem = isPermitForShow(permission: permissions.isItemVisible)
        let  isPayment = isPermitForShow(permission: permissions.isPaymentVisible)
        let  isInvoice = isPermitForShow(permission: permissions.isInvoiceVisible)
        let  isEquipment = isPermitForShow(permission: permissions.isClientChatEnable)
        
        
        var isClientChats = true
        if let enableClientChat = getDefaultSettings()?.isClientChatEnable{ //This is round off digit for invoice
            if enableClientChat == "0"{
                isClientChats = false
            }
        }
        
        
        //  let  isCustomForm = isPermitForShow(permission: permissions.isCustomFormEnable)
        
        var isCustomForm = true
        if let enableCustomForm = getDefaultSettings()?.isCustomFormEnable{ //This is round off digit for invoice
            if enableCustomForm == "0"{
                isCustomForm = false
            }
        }
        
        var isCustomFieldEnable = true
        if let enableCustomForm = getDefaultSettings()?.isCustomFieldEnable{ //This is round off digit for invoice
            if enableCustomForm == "1"{
                isCustomFieldEnable = false
            }
        }
        
        var isEquipmentEnable = true
        if let enableEquipmentEnable = getDefaultSettings()?.isEquipmentEnable{ //This is round off digit for invoice
            if enableEquipmentEnable == "0"{
                isEquipmentEnable = false
            }
        }
        
        
        for i in 0 ..< isfooter!.count{
            if i > 3 {
                if isfooter![i].isEnable == "1"{
                    
                    if isItem && isfooter![i].menuField == "set_itemMenuOdrNo" {
                        
                        let feedback = ControllerDetail()
                        feedback.id = CollectionType.Item
                        feedback.name = LanguageKey.items_screen_title
                        feedback.image = "shopping-cart"
                        controllerArry.append(feedback)
                    }}
                if isfooter![i].isEnable == "1"{
                    if isfooter![i].menuField == "set_attachmentMenuOdrNo" {
                        
                        let feedback = ControllerDetail()
                        feedback.id = CollectionType.Attechment
                        feedback.name = LanguageKey.title_documents
                        feedback.image = "Document"
                        controllerArry.append(feedback)
                    }
                }
                if isfooter![i].isEnable == "1"{
                    if isfooter![i].menuField == "set_commentsMenuOdrNo" {
                        let feedback = ControllerDetail()
                        feedback.id = CollectionType.Comments
                        feedback.name = LanguageKey.title_chat
                        feedback.image = "Chat_icon_unselected_footer"
                        controllerArry.append(feedback)
                    }}
                
                
                if isfooter![i].isEnable == "1"{
                    if isfooter![i].menuField == "set_feedbackMenuOdrNo" {
                        
                        let feedback = ControllerDetail()
                        feedback.id = CollectionType.Feedback
                        feedback.name = LanguageKey.title_feedback
                        feedback.image = "FeedbackGray"
                        controllerArry.append(feedback)
                    }
                }
                
                
                if isfooter![i].isEnable == "1"{
                    if isfooter![i].menuField == "set_historyMenuOdrNo"{
                        let history = ControllerDetail()
                        history.id = CollectionType.History
                        history.name = LanguageKey.title_history
                        history.image = "History_icon_unselcted"
                        controllerArry.append(history)
                    }
                }
                
                
                
                if isfooter![i].isEnable == "1"{
                    if isPayment && isfooter![i].menuField == "set_paymentMenuOdrNo" {
                        let payment = ControllerDetail()
                        payment.id = CollectionType.Payment
                        payment.name = LanguageKey.title_payment
                        payment.image = "Payment"
                        controllerArry.append(payment)
                    }
                }
                
                if isfooter![i].isEnable == "1"{
                    if isInvoice && isfooter![i].menuField == "set_invoiceMenuOdrNo" {
                        let invoice = ControllerDetail()
                        invoice.id = CollectionType.Invoice
                        invoice.name = LanguageKey.title_invoice
                        invoice.image = "Invoice"
                        controllerArry.append(invoice)
                    }
                }
                
                
                if isfooter![i].isEnable == "1"{
                    if isClientChats && isfooter![i].menuField == "set_clientChatMenuOdrNo" {
                        let isClintChat = ControllerDetail()
                        isClintChat.id = CollectionType.ClientChat
                        isClintChat.name = LanguageKey.client_fw_chat
                        isClintChat.image = "client_chat"
                        controllerArry.append(isClintChat)
                        badgeLabelIndex = controllerArry.count - 1
                    }
                }
                
                
                if isfooter![i].isEnable == "1"{
                    if  isCustomForm && isfooter![i].menuField == "set_customFormMenuOdrNo" {
                        let customForm = ControllerDetail()
                        customForm.id = CollectionType.CustomForm
                        customForm.name = LanguageKey.title_cutomform
                        customForm.image = "CustomForm"
                        controllerArry.append(customForm)
                    }
                }
                
                if isfooter![i].isEnable == "1"{
                    if isEquipmentEnable && isfooter![i].menuField == "set_equipmentMenuOrdrNo" {
                        let invoice = ControllerDetail()
                        invoice.id = CollectionType.Equipment
                        invoice.name = LanguageKey.detail_equipment
                        invoice.image = "Group 220"
                        controllerArry.append(invoice)
                    }
                }
            }
           
        }
        
        //      let  isItem = isPermitForShow(permission: permissions.isItemVisible)
        //      let  isPayment = isPermitForShow(permission: permissions.isPaymentVisible)
        //      let  isInvoice = isPermitForShow(permission: permissions.isInvoiceVisible)
        //      let  isEquipment = isPermitForShow(permission: permissions.isClientChatEnable)
        // let  isCustomForm = isPermitForShow(permission: permissions.isCustomFormEnable)
        
        
        
        //Collectionview order -  Feedback, History, Payment, Invoice, client chat , custom form
        
        
        DispatchQueue.main.async {
            self.showviewWithAnimation(array: arr)
            
            self.screenSize = UIScreen.main.bounds
            self.screenWidth = self.screenSize.width
            self.screenHeight = self.screenSize.height
            
            
            self.collection_View.register(UINib.init(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.reuseIdentifier)
            
            
            var collViewHight : CGFloat?
            
            var isEquipmentEnable = true
            if let enableEquipmentEnable = getDefaultSettings()?.isEquipmentEnable{ //This is round off digit for invoice
                
                if self.controllerArry.count == 0 {
                    var viewHeight : CGFloat?
                    viewHeight = hasNotch() ? 0 : 0
                }else{
                    if enableEquipmentEnable == "0"{
                        
                        if Constants.kIphone_5 || Constants.kIphone_4s || Constants.kIphone_6 || Constants.kIphone_6_Plus {
                            if self.controllerArry.count > 3{
                                collViewHight = hasNotch() ? 330 : 250
                                self.collection_View.isScrollEnabled = false
                            }else{
                                collViewHight = hasNotch() ? 205 : 150
                                self.collection_View.isScrollEnabled = false
                                
                            }
                        }else{
                            if self.controllerArry.count > 3{
                                collViewHight = hasNotch() ? 330: 230
                                self.collection_View.isScrollEnabled = false
                            }else{
                                collViewHight = hasNotch() ? 155 : 100
                                self.collection_View.isScrollEnabled = false
                                
                            }
                        }
                        
                        
                        
                    }else{
                        
                        if Constants.kIphone_5 || Constants.kIphone_4s || Constants.kIphone_6 || Constants.kIphone_6_Plus {
                            if self.controllerArry.count > 3{
                                collViewHight = hasNotch() ? 420 : 350
                                self.collection_View.isScrollEnabled = false
                            }else{
                                collViewHight = hasNotch() ? 305 : 250
                                self.collection_View.isScrollEnabled = false
                                
                            }
                        }else{
                            if self.controllerArry.count > 3{
                                
                                
                                
                                collViewHight = hasNotch() ? 410 : 320
                                self.collection_View.isScrollEnabled = false
                            }else{
                                collViewHight = hasNotch() ? 245 : 190
                                self.collection_View.isScrollEnabled = false
                                
                            }
                        }
                        
                        
                    }
                    
                }
                
            }
            //            if #available(iOS 13, *) {
            //                collViewHight = collViewHight! + 100.0
            //            }
            //
            //
            var viewHeight : CGFloat?
            if self.controllerArry.count == 0 {
                viewHeight = hasNotch() ? 0 : 0
            }else{
                self.collection_View.frame = CGRect(x: self.frame.origin.x, y: (self.frame.size.height - (collViewHight)!), width: self.screenSize.width, height:  collViewHight!) //300 is self.view Height
                
                self.addSubview(self.collection_View)
                self.arrOfShowData = arr
            }
            
            
            
            // self.backgroundColor = UIColor.red
            
        }
    }
    
    
    func showviewWithAnimation(array : [TestDetails]){
       
        var viewHeight : CGFloat?
        if controllerArry.count == 0 {
               viewHeight = hasNotch() ? 0 : 0
        }else{
            if Constants.kIphone_5 || Constants.kIphone_4s || Constants.kIphone_6 || Constants.kIphone_6_Plus {
                       if controllerArry.count > 3{
                                viewHeight = hasNotch() ? 420 : 350
                            }else{
                                viewHeight = hasNotch() ? 305 : 250
                            }
                   }else{
                       if controllerArry.count > 3{
                                viewHeight = hasNotch() ? 450 : 350
                            }else{
                                viewHeight = hasNotch() ? 205 : 105
                            }
                   }
        }
       
     
        
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height:  viewHeight!)
        
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - viewHeight!, width: UIScreen.main.bounds.width, height:  viewHeight!)
        }
    }

}//END


    // MARK: - CollectionViewDataSource
    
    extension CustomCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
             return controllerArry.count
        }
        
        internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
            let controller = controllerArry[indexPath.row]
            cell.lbl_Tittle.text = controller.name
            cell.imgCustomForm.image =  UIImage(named: controller.image)
            cell.frame.size.width = screenWidth / 5
            cell.frame.size.height = screenWidth / 5
           // cell.backgroundColor = .red
            cell.clientChatbatch.isHidden = true
            
            if (badgeLabelIndex == indexPath.row ){
                
                ChatManager.shared.callbackClientBadge = {(count) in
                    self.badgeCount = String(count)
                    if Int(self.badgeCount)! > 0 {
                        cell.clientChatbatch.text = "\(self.badgeCount)"
                        cell.clientChatbatch.isHidden = false
                    }else{
                        cell.clientChatbatch.isHidden = true
                    }
                }
                if Int(badgeCount)! > 0 {
                    cell.clientChatbatch.text = "\(badgeCount)"
                    cell.clientChatbatch.isHidden = false
                }else{
                    cell.clientChatbatch.isHidden = true
                }
                
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            if !isHaveNetowork() {
                if let collectionType = controllerArry[indexPath.row].id, collectionType == .Invoice {
                    ShowError(message: AlertMessage.checkNetwork, controller: windowController)
                }
            }
            
            if self.onHideComplete != nil {
                self.onHideComplete!(false , nil , controllerArry[indexPath.row].id )
            }
        }
    }

extension CustomCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: ((UIScreen.main.bounds.size.width)/3.5), height: ((UIScreen.main.bounds.size.width)/4.0))
        
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if UIScreen.main.sizeType == .iPhone5 {
            return UIEdgeInsets(top: 15, left: 20, bottom: 20, right: 0)
        }
        
        return UIEdgeInsets(top: 10, left:30, bottom: 20, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

