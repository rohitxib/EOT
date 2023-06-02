//
//  OptDetalsMO+CoreDataProperties.swift
//  
//
//  Created by Aplite ios on 21/04/23.
//
//

import Foundation
import CoreData


extension OptDetalsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OptDetalsMO> {
        return NSFetchRequest<OptDetalsMO>(entityName: "OptDetals")
    }

    @NSManaged public var key: String?
    @NSManaged public var optHaveChild: String?
    @NSManaged public var value: String?
    @NSManaged public var customFormDetals: CustomFormDetalsMO?

}
