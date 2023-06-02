//
//  BatteryStatus.swift
//  EyeOnTask
//
//  Created by Mac on 13/02/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
        
    }
}

