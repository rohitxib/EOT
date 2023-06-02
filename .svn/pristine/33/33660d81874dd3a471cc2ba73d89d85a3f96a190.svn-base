//
//  SecondTableViewCell.swift
//  EyeOnTask
//
//  Created by Mac on 05/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
    
    
    @IBOutlet var lbl_Qstn: UILabel!
    @IBOutlet weak var numberlbl: UILabel!
    @IBOutlet var txt_Field: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txt_Field.placeholder = LanguageKey.add_your_ans
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: self.txt_Field.frame.height))
        txt_Field.leftView = paddingView
        txt_Field.leftViewMode = UITextField.ViewMode.always
        
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: self.txt_Field.frame.height))
        txt_Field.rightView = paddingView1
        txt_Field.rightViewMode = UITextField.ViewMode.always
        
       
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
