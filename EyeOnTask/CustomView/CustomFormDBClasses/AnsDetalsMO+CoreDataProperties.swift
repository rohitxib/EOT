//
//  AnsDetalsMO+CoreDataProperties.swift
//  
//
//  Created by Aplite ios on 21/04/23.
//
//

import Foundation
import CoreData


extension AnsDetalsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnsDetalsMO> {
        return NSFetchRequest<AnsDetalsMO>(entityName: "AnsDetals")
    }

    @NSManaged public var key: String?
    @NSManaged public var layer: String?
    @NSManaged public var value: String?
    @NSManaged public var customFormDetals: CustomFormDetalsMO?
    @NSManaged public var customFormAnsRes: CustomFormAnsResMO?

    

}
