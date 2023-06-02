//
//  TaxCell.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 16/04/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class TaxCell: UITableViewCell {

    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var txtField: FloatLabelTextField!
    @IBOutlet weak var txtFieldPersentShow: UILabel!
    @IBOutlet weak var tapBtn: UIButton!
    
    @IBOutlet weak var txtFieldPersentShowQute: UILabel!
    @IBOutlet weak var tapBtnQute: UIButton!
     @IBOutlet weak var imgBtnQute: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
