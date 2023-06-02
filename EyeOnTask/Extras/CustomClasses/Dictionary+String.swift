//
//  Dictionary+String.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 05/07/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation

extension Dictionary {
    var toString: String? {
            let dictionary = self
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            return jsonString
    }
    
    var toData: Data? {
            let dictionary = self
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            return jsonData
    }
    
    
    
}
