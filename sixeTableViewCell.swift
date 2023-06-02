//
//  sixeTableViewCell.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 05/01/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class sixeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var H_imgView: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var Height_BigView: NSLayoutConstraint!
    
    @IBOutlet weak var addAttechement: UIButton!
    @IBOutlet var lbl_Qstn: UILabel!
    @IBOutlet weak var numberlbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
