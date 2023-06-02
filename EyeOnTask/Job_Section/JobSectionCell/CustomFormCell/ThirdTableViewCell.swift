//
//  ThirdTableViewCell.swift
//  EyeOnTask
//
//  Created by Mac on 05/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class ThirdTableViewCell: UITableViewCell {
    
    @IBOutlet var lbl_Qstn: UILabel!
    @IBOutlet weak var numberlbl: UILabel!
    @IBOutlet var txtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
