//
//  Define.swift
//  Swift_Demo
//
//  Created by Hemant Pandagre on 02/09/17.
//  Copyright © 2017 Hemant Pandagre. All rights reserved.
//

import Foundation
import UIKit


let login = "login"

// User Detail
let userLName = "usr_lname"


class Constants {
    
    //Screen size
    static let mainScreenWidth : CGFloat = UIScreen.main.bounds.width
    static let mainScreenHeight : CGFloat = UIScreen.main.bounds.height
    
    // Check Device IPHONE
    static let kIphone_4s : Bool =  (UIScreen.main.bounds.size.height == 480)
    static let kIphone_5 : Bool =  (UIScreen.main.bounds.size.height == 568)
    static let kIphone_6 : Bool =  (UIScreen.main.bounds.size.height == 667)
    static let kIphone_6_Plus : Bool =  (UIScreen.main.bounds.size.height == 736)
    static let kIphone_11_Pro_Max : Bool =  (UIScreen.main.bounds.size.height == 900)
    
    
    static let firebaseEmailSuffix = "@eyeontask.com"
    static let firebaseUserPassword = "123456"
    static let APPSTORE_URL : String = "https://itunes.apple.com/us/app/eyeontask/id1439586051?mt=8"
    
    
}

extension UIView {
    func addDashBorder() {
        let color = UIColor.white.cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()

        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [2,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath

        self.layer.masksToBounds = false

        self.layer.addSublayer(shapeLayer)
    }
}
