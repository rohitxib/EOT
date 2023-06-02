//
//  ClientCell.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 08/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class ClientCell: UITableViewCell {

    @IBOutlet weak var viw: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


