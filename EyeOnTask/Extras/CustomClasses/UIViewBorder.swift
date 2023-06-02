//
//  UIViewBorder.swift
//  EyeOnTask
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
       var shadowRadius: CGFloat {
           set {
               layer.shadowRadius = newValue
           }
        
            get {
                return layer.shadowRadius
            }
       }
       
       @IBInspectable var shadowColor: UIColor {
 
            set {
                layer.shadowColor = newValue.cgColor
             }
            
            get {
                 return UIColor.init(cgColor: layer.shadowColor!)
            }
       }
       
       @IBInspectable var shadowOpacity: Float {
            set {
                layer.shadowOpacity = newValue
             }
            
            get {
                return layer.shadowOpacity
            }
       }
       
       @IBInspectable var shadowOffset: CGSize {

            set {
               layer.shadowOffset = newValue
            }
                          
            get {
                return layer.shadowOffset
            }
        
                   
       }
       
}
