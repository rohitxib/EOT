//
//  ItemListEqupCell.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 23/03/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class ItemListEqupCell: UITableViewCell {

    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var itemQty: UILabel!
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
