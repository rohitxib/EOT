//
//  CustomFormAnswerMO+CoreDataProperties.swift
//  
//
//  Created by Aplite ios on 27/04/23.
//
//

import Foundation
import CoreData


extension CustomFormAnswerMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomFormAnswerMO> {
        return NSFetchRequest<CustomFormAnswerMO>(entityName: "CustomFormAnswer")
    }

    @NSManaged public var formId: String?
    @NSManaged public var jobId: String?
    @NSManaged public var opId: String?
    @NSManaged public var answeres: NSSet?

}

// MARK: Generated accessors for answeres
extension CustomFormAnswerMO {

    @objc(addAnsweresObject:)
    @NSManaged public func addToAnsweres(_ value: CustomFormAnsResMO)

    @objc(removeAnsweresObject:)
    @NSManaged public func removeFromAnsweres(_ value: CustomFormAnsResMO)

    @objc(addAnsweres:)
    @NSManaged public func addToAnsweres(_ values: NSSet)

    @objc(removeAnsweres:)
    @NSManaged public func removeFromAnsweres(_ values: NSSet)

}
