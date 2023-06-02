//
//  ClientTabController.swift
//  EyeOnTask
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Hemant. All rights reserved.


import UIKit


class ClientTabController: UITabBarController {

    
    
    var titleText : String?
    var valueToPass: String?
    var objOFClintTabBar : ClientList?
    var isDisable = true
    //var controllers = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()

     isDisable = compPermissionVisible(permission: compPermission.cltWorkHistory)
        
        let clintdetailVC = self.viewControllers![0] as! ClientDetailVC
        clintdetailVC.tabBarItem = UITabBarItem(title:LanguageKey.client_details, image: UIImage(named: "overview_icon_unselected"), tag: 0)
        clintdetailVC.clientDetails = objOFClintTabBar
       
        let contactVC = self.viewControllers![1] as! ContactVC
        contactVC.tabBarItem = UITabBarItem(title:LanguageKey.contacts_screen_title, image: UIImage(named: "contact_unselected_3x-1"), tag: 0)
        contactVC.objOFContactVC = objOFClintTabBar

        let sitVC = self.viewControllers![2] as! SiteVC
          sitVC.tabBarItem = UITabBarItem(title:LanguageKey.sites_screen_title, image: UIImage(named: "site_unselected"), tag: 0)
        sitVC.objOFSitVC = objOFClintTabBar
        
        

              
        if isDisable == true {
            
            let workHistryVC = self.viewControllers![3] as! WorkHistry
            workHistryVC.tabBarItem = UITabBarItem(title:LanguageKey.work_history, image: UIImage(named: "History_icon_unselcted"), tag: 0)
            workHistryVC.objOFWorkHistry = objOFClintTabBar
             // controllers.append(workHistryVC)
        }else{
       
        }
     
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    

}
