//
//  CustomFormAnsResMO+CoreDataProperties.swift
//  
//
//  Created by Aplite ios on 27/04/23.
//
//

import Foundation
import CoreData


extension CustomFormAnsResMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomFormAnsResMO> {
        return NSFetchRequest<CustomFormAnsResMO>(entityName: "CustomFormAnsRes")
    }

    @NSManaged public var formId: String?
    @NSManaged public var isAdded: Bool
    @NSManaged public var queId: String?
    @NSManaged public var type: String?
    @NSManaged public var ans: NSSet?
    @NSManaged public var customFormAnswer: CustomFormAnswerMO?

}

// MARK: Generated accessors for ans
extension CustomFormAnsResMO {

    @objc(addAnsObject:)
    @NSManaged public func addToAns(_ value: AnsDetalsMO)

    @objc(removeAnsObject:)
    @NSManaged public func removeFromAns(_ value: AnsDetalsMO)

    @objc(addAns:)
    @NSManaged public func addToAns(_ values: NSSet)

    @objc(removeAns:)
    @NSManaged public func removeFromAns(_ values: NSSet)

}
