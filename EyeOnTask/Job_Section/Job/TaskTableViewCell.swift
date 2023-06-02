//
//  TaskTableViewCell.swift
//  RealmDemo
//
//  Created by Hatshit on 12/04/18.
//  Copyright © 2018 Aplite. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var equipment_Height_Audit: NSLayoutConstraint!
    @IBOutlet weak var heightConstrant_Item: NSLayoutConstraint!
    @IBOutlet weak var heightConstrant_Equipment: NSLayoutConstraint!
    
    @IBOutlet weak var auditSelf_H: NSLayoutConstraint!
    @IBOutlet weak var selfAuditLbl: UILabel!
    @IBOutlet weak var selfLbl_H: NSLayoutConstraint!
    @IBOutlet weak var selfLblWorkHtry: UILabel!
    @IBOutlet weak var selfLbl: UILabel!
    @IBOutlet weak var selfLblhistry_H: NSLayoutConstraint!
    @IBOutlet weak var statusServLbl: UILabel!
    @IBOutlet weak var dateService: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameOne: UILabel!
    @IBOutlet weak var attchment_Audit: UIImageView!
    @IBOutlet weak var Attchment: UIImageView!
    @IBOutlet weak var imgEquipment: UIImageView!
    @IBOutlet weak var imgItems: UIImageView!
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftBaseView : UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var priorityImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var timeAMPM: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEquipementName: UILabel!
    @IBOutlet weak var lblEquipementAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  setLocalization()
    }
    
    //func setLocalization() -> Void {
       
      //  timeAMPM.text = LanguageKey.am
      //  timeAMPM.text = LanguageKey.pm
        
    //}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
