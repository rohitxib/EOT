//
//  String+Dictionary.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 18/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation

extension String {
    var toDictionary: [String: Any]? {
        var dictionary:Dictionary<String, Any>?
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                return dictionary
            } catch  {
               // print( "Error in convert = \(error)")
                return nil
            }
        }
        return nil
    }
}
