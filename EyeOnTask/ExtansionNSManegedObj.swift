//
//  ExtansionNSManegedObj.swift
//  EyeOnTask
//
//  Created by Aplite ios on 21/04/23.
//  Copyright © 2023 Hemant. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    func keys() -> [String] {
        var results: [String] = []

        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0
        let myClass: AnyClass = self.classForCoder
        let properties = class_copyPropertyList(myClass, &count)
        
        guard let guardedProperties = properties else {
            return []
        }

        for i in 0...count-1 {
            let property = guardedProperties[Int(i)]

            // retrieve the property name by calling property_getName function
            let cname = property_getName(property)

            // covert the c string into a Swift string
            let name = String(cString: cname)
            results.append(name)
        }

        // release objc_property_t structs
        free(properties)

        return results
    }
   
}

