//
//  CustomFormMO+CoreDataProperties.swift
//  
//
//  Created by Aplite ios on 27/04/23.
//
//

import Foundation
import CoreData


extension CustomFormMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomFormMO> {
        return NSFetchRequest<CustomFormMO>(entityName: "CustomForm")
    }

    @NSManaged public var formId: String?
    @NSManaged public var formQuestions: NSSet?
    @NSManaged public var arryOfQueID: [String]?
    
}

// MARK: Generated accessors for formQuestions
extension CustomFormMO {

    @objc(addFormQuestionsObject:)
    @NSManaged public func addToFormQuestions(_ value: CustomFormDetalsMO)

    @objc(removeFormQuestionsObject:)
    @NSManaged public func removeFromFormQuestions(_ value: CustomFormDetalsMO)

    @objc(addFormQuestions:)
    @NSManaged public func addToFormQuestions(_ values: NSSet)

    @objc(removeFormQuestions:)
    @NSManaged public func removeFromFormQuestions(_ values: NSSet)

}
