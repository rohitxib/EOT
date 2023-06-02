//
//  CustomFormAnswerMO+CoreDataClass.swift
//  
//
//  Created by Aplite ios on 27/04/23.
//
//

import Foundation
import CoreData

@objc(CustomFormAnswerMO)
public class CustomFormAnswerMO: NSManagedObject {

}
extension CustomFormAnswerMO {
    
    func initWithValue(object:[CustomDataRes],withContext:NSManagedObjectContext,jobID:String,formID:String,opID:String){
        self.jobId = jobID
        self.formId = formID
        self.opId = opID
  // getting all ans from FORM
        var anss: [CustomFormAnsResMO] = []
        if object.count > 0 {
            for ansTemp in object {
                let ansEntity = CustomFormAnsResMO(context: withContext)
                ansEntity.initWithValue(object: ansTemp, withContext: withContext)
                anss.append(ansEntity)
            }
        }
        self.answeres = NSSet(array: anss)
        anss.removeAll()
    }
}


