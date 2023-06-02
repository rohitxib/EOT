//
//  AdminListCell.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 25/03/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import Firebase
class AdminListCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var isOnlineView: UIView!
    @IBOutlet weak var lblLastMessage: UILabel!
    @IBOutlet weak var lblLastSeen: UILabel!
     var onlineObserver : DatabaseHandle?
    @IBOutlet weak var lblBadge: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
