//
//  AdminListVC.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 25/03/20.
//  Copyright © 2020 Hemant. All rights reserved.
//


import UIKit
import CoreData
import CoreLocation
import SDWebImage

class AdminListVC: UIViewController, UITableViewDataSource, UITableViewDelegate,  SWRevealViewControllerDelegate , UITextFieldDelegate{

      
    @IBOutlet weak var noUserLbl: UILabel!
    @IBOutlet var tableView: UITableView!
          @IBOutlet var extraButton: UIBarButtonItem!
          @IBOutlet weak var searchVw_H: NSLayoutConstraint!
          @IBOutlet weak var txtSearchfield: UITextField!
      
          var users = [UserModel]()
          var filterUsers = [UserModel]()
          var isReavel = false
          let Limit = "50"
          let Index = "0"
          var refreshControl = UIRefreshControl()
    
      //=========================
      // MARK:- Initial methods
      //=========================
    
    
    deinit {
        ChatManager.shared.userModels.forEach({$0.cell = nil})
    }
    
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
        self.filterUsers.removeAll()
           self.extraButton.isEnabled = true
           self.searchVw_H.constant = 0.0
           
           if let revealController = self.revealViewController(){
               revealViewController().delegate = self
               extraButton.target = revealViewController()
               extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
               revealController.tapGestureRecognizer()
           }
           
        
        refreshControl.attributedTitle = NSAttributedString(string: " ")
        refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearchfield.frame.height))
       txtSearchfield.leftView = paddingView
       txtSearchfield.leftViewMode = UITextField.ViewMode.always
       
       let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtSearchfield.frame.height))
       txtSearchfield.rightView = paddingView1
       txtSearchfield.rightViewMode = UITextField.ViewMode.always
        
        setLocalization()
           
       }
    
   
      @objc func refreshControllerMethod() {
          showDataOnTableView()
      }
    
       func setLocalization() -> Void {
           self.navigationItem.title = LanguageKey.side_menu_title_chats //LanguageKey.audit_nav
           txtSearchfield.placeholder = LanguageKey.search_by_username
         noUserLbl.text = LanguageKey.user_not_found
      
       }
    
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

        // self.navigationItem.title = LanguageKey.audit_nav
           tableView.estimatedRowHeight = 200
           tableView.estimatedRowHeight = UITableView.automaticDimension
           tableView.rowHeight = UITableView.automaticDimension

            showDataOnTableView()
       }
    
    
    //=======================
      // Disable Pan gesture
      //========================
      func revealControllerPanGestureShouldBegin(_ revealController: SWRevealViewController!) -> Bool {
          return false
      }
    
      func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        
          if position == .left {
            
            if isReavel {
                setLocalization()
                self.showDataOnTableView()
            }else{
                 isReavel = true
            }
         }
      }
    
    
    //==========================
    // MARK:- Textfield methods
    //==========================
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        self.filterUsers.removeAll()
        
        if result.count > 2 || result.count == 0 {
            if result != "" {
                
                self.filterUsers = self.users.filter({ (user) -> Bool in

                    if user.fullName!.lowercased().contains(result.lowercased()) {
                       return true
                    }else{
                        return false
                    }
                })
            }
            
            self.tableView.isHidden = ((self.filterUsers.count > 0) || (result == "")) ? false : true
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
     
       //==========================
       // MARK:- Tableview methods
       //==========================

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
          return self.filterUsers.count > 0 ? self.filterUsers.count :  self.users.count
       }
       
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdminListCell
           cell.isUserInteractionEnabled = true
           let chatDetails = (self.filterUsers.count > 0 ? filterUsers :  self.users)[indexPath.row]

        if let img = chatDetails.user?.img {
                let imageUrl = Service.BaseUrl + img
                cell.userImg.sd_setImage(with: URL(string: imageUrl) , placeholderImage: UIImage(named: "chatlistimg"))
            }else{
                cell.userImg.image = UIImage(named: "chatlistimg")
            }

            cell.isOnlineView.isHidden = chatDetails.isOnline ? false : true
            
                if (chatDetails.lastMessage != nil) {
                    cell.lblLastMessage.text = chatDetails.lastMessage
                    cell.lblLastMessage.textColor = .darkGray
                }else{
                    cell.lblLastMessage.text = "'\(LanguageKey.start_new_chat_here)'"
                    cell.lblLastMessage.textColor = .lightGray
                }
        
        
               if let time = chatDetails.lastMessageTime { // Time Check
                   cell.lblLastSeen.text = timeDifferenceForChat(unixTimestamp: time)
               }else{
                   cell.lblLastSeen.text = ""
               }
        
        
               if let unreadCount = chatDetails.unreadCount, Int(chatDetails.unreadCount!)! > 0 {
                       cell.lblBadge.text = unreadCount
                       cell.lblBadge.isHidden = false
                       cell.lblLastSeen.isHidden = true
                }else{
                     cell.lblBadge.isHidden = true
                     cell.lblLastSeen.isHidden = false
                }
             
            
            chatDetails.cell = cell
            
            cell.userName.text =  (chatDetails.fullName ?? "").capitalizingFirstLetter()
        
//                if chatDetails.isInactive { // for inactive user
//                    cell.contentView.backgroundColor = .lightGray
//                    cell.contentView.alpha = 0.5
//                    cell.isUserInteractionEnabled = false
//                }else{
//                    cell.contentView.backgroundColor = .white
//                    cell.contentView.alpha = 1.0
//                    cell.isUserInteractionEnabled = true
//                }
        
        
            return cell
    }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let model = self.filterUsers.count > 0 ? self.filterUsers[indexPath.row] :  self.users[indexPath.row]
            if model.isInactive == false {
            let storyboard = UIStoryboard(name: "MainAdminChat", bundle: nil)
                    let pmnt = storyboard.instantiateViewController(withIdentifier: "GROUPCHAT") as!  AdminChatVC
                    pmnt.userData =  self.filterUsers.count > 0 ? self.filterUsers[indexPath.row] :  self.users[indexPath.row]
                    self.navigationController!.pushViewController(pmnt, animated: true)
            }else{
                showDataOnTableView()
                self.showToast(message: LanguageKey.trying_to_chat)
             }
       }
                
    
    
    @IBAction func btnSearchUser(_ sender: Any) {
        if searchVw_H.constant != 0.0 {
            searchVw_H.constant = 0.0
        }else{
            searchVw_H.constant = 44.0
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func showDataOnTableView() -> Void {
        let userList = ChatManager.shared.userModels.filter({$0.isInactive == false}) //DatabaseClass.shared.fetchDataFromDatabse(entityName: "Users", query: query) as? [Users]
         //print("when get users in list user model === \(ChatManager.shared.userModels.count)")
        if userList.count > 0 {
            
            users = userList
            users =  users.sorted { ($0.lastMessageTime ?? "").localizedCaseInsensitiveCompare($1.lastMessageTime ?? "") == ComparisonResult.orderedDescending }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
   
            DispatchQueue.main.async {
                self.noUserLbl.isHidden = self.users.count > 0 ? true : false
              //  self.noUserLbl.text = "jugal"
                self.tableView.isHidden = self.users.count > 0 ? false : true
            }
        
        
            if self.refreshControl.isRefreshing {
                 self.refreshControl.endRefreshing()
            }
        }
    
        
                
}
             

