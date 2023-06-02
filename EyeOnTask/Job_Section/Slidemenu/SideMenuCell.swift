//
//  SideMenuCell.swift
//  EyeOnTask
//
//  Created by Mac on 29/05/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
