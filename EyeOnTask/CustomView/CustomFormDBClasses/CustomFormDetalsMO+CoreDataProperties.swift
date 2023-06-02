//
//  CustomFormDetalsMO+CoreDataProperties.swift
//  
//
//  Created by Aplite ios on 21/04/23.
//
//

import Foundation
import CoreData


extension CustomFormDetalsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomFormDetalsMO> {
        return NSFetchRequest<CustomFormDetalsMO>(entityName: "CustomFormDetals")
    }
    
    @NSManaged public var jobId: String?
    @NSManaged public var des: String?
    @NSManaged public var frmId: String?
    @NSManaged public var frmType: String?
    @NSManaged public var mandatory: String?
    @NSManaged public var parentAnsId: String?
    @NSManaged public var parentId: String?
    @NSManaged public var queId: String?
    @NSManaged public var type: String?
    @NSManaged public var opt: NSSet?
    @NSManaged public var ans: NSSet?
    @NSManaged public var arrayOfOptionId: [String]?

}

// MARK: Generated accessors for opt
extension CustomFormDetalsMO {

    @objc(addOptObject:)
    @NSManaged public func addToOpt(_ value: OptDetalsMO)

    @objc(removeOptObject:)
    @NSManaged public func removeFromOpt(_ value: OptDetalsMO)

    @objc(addOpt:)
    @NSManaged public func addToOpt(_ values: NSSet)

    @objc(removeOpt:)
    @NSManaged public func removeFromOpt(_ values: NSSet)

}

// MARK: Generated accessors for ans
extension CustomFormDetalsMO {

    @objc(addAnsObject:)
    @NSManaged public func addToAns(_ value: AnsDetalsMO)

    @objc(removeAnsObject:)
    @NSManaged public func removeFromAns(_ value: AnsDetalsMO)

    @objc(addAns:)
    @NSManaged public func addToAns(_ values: NSSet)

    @objc(removeAns:)
    @NSManaged public func removeFromAns(_ values: NSSet)

}


