//
//  ContactCell.swift
//  EyeOnTask
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var contactNoLbl: UILabel!
     @IBOutlet weak var viw: UIView!
    @IBOutlet weak var arrowImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
