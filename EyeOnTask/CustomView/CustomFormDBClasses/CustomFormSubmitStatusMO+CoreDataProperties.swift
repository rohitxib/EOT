//
//  CustomFormSubmitStatusMO+CoreDataProperties.swift
//  
//
//  Created by Aplite ios on 28/04/23.
//
//

import Foundation
import CoreData


extension CustomFormSubmitStatusMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomFormSubmitStatusMO> {
        return NSFetchRequest<CustomFormSubmitStatusMO>(entityName: "CustomFormSubmitStatus")
    }

    @NSManaged public var submited: Bool
    @NSManaged public var formId: String?
    @NSManaged public var jobId: String?

}
