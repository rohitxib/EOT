//
//  CustomFormSubmitStatusMO+CoreDataClass.swift
//  
//
//  Created by Aplite ios on 28/04/23.
//
//

import Foundation
import CoreData

@objc(CustomFormSubmitStatusMO)
public class CustomFormSubmitStatusMO: NSManagedObject {

}
extension CustomFormSubmitStatusMO {
    func initWithValue(jobID:String,formID:String,status: Bool,withContext:NSManagedObjectContext){
        self.formId = formID
        self.jobId = jobID
        self.submited = status
    }
}
