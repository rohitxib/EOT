//
//  ChatCell.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 20/12/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
