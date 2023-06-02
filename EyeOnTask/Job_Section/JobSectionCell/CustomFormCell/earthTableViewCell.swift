//
//  earthTableViewCell.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 06/01/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class earthTableViewCell: UITableViewCell {

    @IBOutlet weak var H_singView: NSLayoutConstraint!
    
    @IBOutlet weak var H_singNatureImgVw: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet var AddSignature_view: YPDrawSignatureView!
    @IBOutlet weak var addSignBtn: UIButton!
    @IBOutlet weak var deleteSignBtn: UIButton!
    @IBOutlet var lbl_Qstn: UILabel!
    @IBOutlet weak var numberlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
