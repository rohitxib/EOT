//
//  ShippingItemCell.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 30/09/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class ShippingItemCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
