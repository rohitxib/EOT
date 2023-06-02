//
//  AppointmentListCell.swift
//  EyeOnTask
//
//  Created by Altab on 06/07/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class AppointmentListCell: UITableViewCell {
    
    @IBOutlet weak var withAtchImg: NSLayoutConstraint!
    @IBOutlet weak var withItmImg: NSLayoutConstraint!
    @IBOutlet weak var wightEquipImg: NSLayoutConstraint!
    
    @IBOutlet weak var attechmentImg: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var equipmentImg: UIImageView!
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var lblVertical: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var ViewBgJob: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
