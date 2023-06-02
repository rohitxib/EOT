//
//  RecurTableCell.swift
//  EyeOnTask
//
//  Created by Ayush purohit on 07/12/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class RecurTableCell: UITableViewCell {

    
    @IBOutlet weak var checkMarkBtn: UIButton!
    @IBOutlet weak var lblRecurDayWeekly: UILabel!
    @IBOutlet weak var btnRecurTap: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
