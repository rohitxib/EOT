//
//  NavClientController.swift
//  EyeOnTask
//
//  Created by Apple on 12/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class NavClientController: UINavigationController{
    
    var isFirstLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
//
//    //
//            let destinationVC = segue.destination as! JobVC
//            destinationVC.isFirstLogin = false
//            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
