//
//  TenthTableViewCell.swift
//  EyeOnTask
//
//  Created by Ayush Purohit on 17/01/23.
//  Copyright © 2023 Hemant. All rights reserved.
//

import UIKit

class TenthTableViewCell: UITableViewCell {

    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var lblNm: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
