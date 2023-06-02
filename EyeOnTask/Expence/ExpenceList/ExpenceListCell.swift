//
//  ExpenceListCell.swift
//  EyeOnTask
//
//  Created by Hemant's mac on 08/05/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit

class ExpenceListCell: UITableViewCell {

    
    @IBOutlet weak var userList: UILabel!
    @IBOutlet weak var tegImg: UIImageView!
    @IBOutlet weak var tegView: UIView!
    @IBOutlet weak var lblExpenceName: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAMPM: UILabel!
    @IBOutlet weak var imgTaskStatus: UIImageView!
    @IBOutlet weak var lblTaskStatus: UILabel!
    @IBOutlet weak var viewLeftBase: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var viewrightBase: UIView!
    @IBOutlet weak var endDateShedulLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(expence : Expence)  {
        lblExpenceName.text = expence.name?.capitalizingFirstLetter()
        lblGroupName.text = expence.category?.capitalizingFirstLetter()
        lblDes.text = expence.des?.capitalizingFirstLetter()
        lblCategory.text = expence.category?.capitalizingFirstLetter()
        price.text = "$\(expence.amt ?? "0.0")"
        setDateTime(expence: expence)
        setStatusImageAndName(expence: expence)
     }
    
    
    private func setDateTime(expence : Expence) {
        if expence.dateTime != nil && expence.dateTime != "" {
         let tempTime = convertTimestampToDate(timeInterval: expence.dateTime!)
            lblTime.text = tempTime.0
            lblAMPM.text = tempTime.1
        } else {
            lblTime.text = ""
            lblAMPM.text = ""
        }
     }
    
    private func setStatusImageAndName(expence : Expence) {
           let status = taskStatus(taskType: taskStatusType(rawValue: Int(expence.status! == "0" ? "1" : expence.status!)!)!)
           if taskStatusType(rawValue: Int(expence.status! == "0" ? "1" : expence.status!)!)! == taskStatusType.InProgress{
                lblTaskStatus.text = status.0
                viewLeftBase.backgroundColor = UIColor(red: 109.0/255.0, green: 209.0/255.0, blue: 32.0/255.0, alpha: 1.0)
                lblTaskStatus.textColor = UIColor.white
                lblAMPM.textColor = UIColor.white
                lblTime.textColor = UIColor.white
                imgTaskStatus.image  = UIImage.init(named: "inprogress_white")
            }else{
                lblTaskStatus.text = status.0.replacingOccurrences(of: " Task", with: "")
                lblTaskStatus.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                lblAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                lblTime.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                imgTaskStatus.image  = status.1
            }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

