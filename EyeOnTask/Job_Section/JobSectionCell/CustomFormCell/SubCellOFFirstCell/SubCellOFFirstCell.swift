//
//  SubCellOFFirstCell.swift
//  EyeOnTask
//
//  Created by mac on 06/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class SubCellOFFirstCell: UITableViewCell {

    // MARK: Properties
    
    static let identifier = String(describing: SubCellOFFirstCell.self)
   
   var cellButton: UIButton?
   
    
    // MARK: Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.init(red: 242.0/255.0, green: 238.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        contentView.backgroundColor = nil
        textLabel?.textColor = UIColor.darkGray
        cellButton = UIButton(frame: CGRect(x: 15, y: 8, width: 25, height: 25))
        addSubview(cellButton!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.textAlignment = .left
        textLabel?.frame = CGRect(x: 55, y: 5, width: 200, height: 30)
        self.imageView?.frame = CGRect(x: 15, y: 8, width: 25, height: 25)
    }

}
