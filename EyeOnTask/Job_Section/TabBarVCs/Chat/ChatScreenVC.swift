//
//  ChatScreenVC.swift
//  EyeOnTask
//
//  Created by mac on 09/08/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChatScreenVC: UIViewController {
    
    
    @IBOutlet var containerVw_H: NSLayoutConstraint!
    @IBOutlet var table_View: UITableView!
    @IBOutlet var chat_View: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpMethod()
    }
    

    
    func setUpMethod(){
        IQKeyboardManager.shared.enable = false

        self.containerVw_H.constant = (UIApplication.shared.keyWindow?.bounds.size.height)! - 40 - (navigationController?.navigationBar.bounds.size.height)! // 134 = 114 + 20
        self.registorKeyboardNotification()
 

    }
    //=====================================
    //MARK:- Registor Keyboard Notification
    //=====================================
    func registorKeyboardNotification(){
        IQKeyboardManager.shared.enable = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    //=====================================
    //MARK:- Remove Keyboard Notification
    //=====================================
    func removeKeyboardNotification(){
        
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardDidShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardDidHideNotification,object: nil)
    }
    

    
    //========================================
    //MARK:-  Key Board notification method
    //========================================
    @objc func keyboardWillShow(notification: NSNotification) {
        
        self.moveView(userInfo: notification.userInfo as! [String : Any], up: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.moveView(userInfo: notification.userInfo as! [String : Any], up: false)
    }
    
    func moveView(userInfo : [String : Any] , up : Bool){
        
        if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            let y = (-keyboardSize.height * (up ? -1 : 1))
            
            var containerFrame = self.view.frame;
          //  containerFrame.origin.y = 0
            containerFrame.size.height -= ((40) + (navigationController?.navigationBar.bounds.size.height)!);
            
            if(up){
                containerFrame.size.height = (containerFrame.size.height) - y
                
                
                var tableFrame = self.table_View.frame
                var chatViewFrame = self.chat_View.frame
                
                tableFrame.size.height = (containerFrame.size.height)-chatViewFrame.size.height;
                chatViewFrame.origin.y = (containerFrame.size.height)-chatViewFrame.size.height;
                DispatchQueue.main.async {
                    
                    UIView.animate(withDuration: 0.1,
                                   delay: 0.0,
                                   options: UIView.AnimationOptions.curveEaseIn,
                                   animations: { () -> Void in
                                    
                                    self.containerVw_H.constant = (containerFrame.size.height)
                                    
                    }, completion: { (finished) -> Void in
                        
                        DispatchQueue.main.async {
                            if(up){
                                
                                
                               // self.moveToLastIndex()
                                
                            }
                        }
                    })
                }
            }else{
                
                self.containerVw_H.constant = (UIApplication.shared.keyWindow?.bounds.size.height)! - ( 40 ) - (navigationController?.navigationBar.bounds.size.height)! // 134 = 114 + 20
                
                
            }
            
        }
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
//    func moveToLastIndex(){
//
//        if arryChat.count == 0 {
//            return
//        }
//        if(self.table_View!.numberOfSections > 0){
//            // First figure out how many sections there are
//            let lastSectionIndex = self.table_View!.numberOfSections - 1
//
//            // Then grab the number of rows in the last section
//            let lastRowIndex = self.table_View!.numberOfRows(inSection: lastSectionIndex) - 1
//
//            // Now just construct the index path
//            let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
//            // Make the last row visible
//            self.table_View?.scrollToRow(at: pathToLastRow, at: UITableViewScrollPosition.top, animated: true)
//        }
//    }
//

}
