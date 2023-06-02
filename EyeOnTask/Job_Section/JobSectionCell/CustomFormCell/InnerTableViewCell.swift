//
//  InnerTableViewCell.swift
//  EyeOnTask
//
//  Created by Mac on 06/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class InnerTableViewCell: UITableViewCell {

    @IBOutlet weak var radioImg: UIImageView!
    @IBOutlet weak var answerLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
