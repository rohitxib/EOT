//
//  CustomFormMO+CoreDataClass.swift
//  
//
//  Created by Aplite ios on 27/04/23.
//
//

import Foundation
import CoreData

@objc(CustomFormMO)
public class CustomFormMO: NSManagedObject {

}


extension CustomFormMO{
    
    func initWithValue(object:[CustomFormDetals]?,withContext:NSManagedObjectContext,formID:String){
        self.formId = formID

          var questionss: [CustomFormDetalsMO] = []
          if let formQuestions = object {

              let quesIDs = formQuestions.map({ $0.queId! })
              self.arryOfQueID = quesIDs

              for questionObj in formQuestions {
                  let frmQuestion = CustomFormDetalsMO(context: withContext)
                  frmQuestion.initWithValue(object: questionObj, withContext: withContext, jobID: "")
                  questionss.append(frmQuestion)
              }
          }
          self.formQuestions = NSSet(array: questionss)
          questionss.removeAll()
      }
}
