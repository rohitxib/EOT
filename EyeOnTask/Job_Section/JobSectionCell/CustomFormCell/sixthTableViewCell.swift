//
//  sixthTableViewCell.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 14/12/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class sixthTableViewCell: UITableViewCell {

        static let identifier = "termsAndConditionCell"
        static let cellClass = "sixthTableViewCell"

        @IBOutlet weak var lblTerms: UILabel!
        @IBOutlet weak var btnCheckBox: UIButton!


        override func awakeFromNib() {
            super.awakeFromNib()
            
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
       
       
   }

