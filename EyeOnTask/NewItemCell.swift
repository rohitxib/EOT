//
//  NewItemCell.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 20/10/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class NewItemCell: UITableViewCell {

    @IBOutlet weak var itnemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
