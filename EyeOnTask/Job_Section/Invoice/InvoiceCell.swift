//
//  InvoiceCell.swift
//  EyeOnTask
//
//  Created by Mac on 05/03/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class InvoiceCell: UITableViewCell {

    @IBOutlet weak var nonBillabalLbl: UILabel!
    @IBOutlet weak var billabelView: UIView!
    @IBOutlet weak var desLbl: UILabel!
    @IBOutlet weak var billingLbl: UILabel!
    @IBOutlet weak var billingView: UIView!
    @IBOutlet weak var quntyTxtFld: UITextField!
    @IBOutlet weak var height_dataSynkLbl: NSLayoutConstraint!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var checkMarkBtn: UIButton!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var btnTap: UIButton!
    

    @IBOutlet weak var X_lblName: NSLayoutConstraint!
    
    @IBOutlet weak var X_lblQty: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
