//
//  PayVC.swift
//  EyeOnTask
//
//  Created by Mac on 08/03/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class PayVC: UIViewController {

  
    @IBOutlet weak var netBankLbl: UILabel!
    @IBOutlet weak var creditLbl: UILabel!
    @IBOutlet weak var PayBtn: UIButton!
    @IBOutlet weak var netBankBtn: UIButton!
    @IBOutlet weak var creditBtn: UIButton!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    

    @IBAction func creditBtnAction(_ sender: Any) {
        
        let img = UIImage(named: "bank-building-(1)")
        netBankBtn.setImage(img , for: .normal)
        let img2 = UIImage(named: "credit-cards-payment1")
        creditBtn.setImage(img2 , for: .normal)
        creditLbl.textColor = UIColor(red: 115/255, green: 125/255, blue: 126/255, alpha: 1)
        netBankLbl.textColor = UIColor.black
        
        
    }
    
    
     @IBAction func netBankBtnAction(_ sender: Any) {
        
        let img = UIImage(named: "bank-building")
        netBankBtn.setImage(img , for: .normal)
        let img2 = UIImage(named: "credit-cards-payment")
        creditBtn.setImage(img2 , for: .normal)
        netBankLbl.textColor = UIColor(red: 115/255, green: 125/255, blue: 126/255, alpha: 1)
        creditLbl.textColor = UIColor.black
   
    }
    
    @IBAction func backBtnActn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
