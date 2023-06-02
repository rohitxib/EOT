//
//  CustomFormAnsResMO+CoreDataClass.swift
//  
//
//  Created by Aplite ios on 27/04/23.
//
//

import Foundation
import CoreData

@objc(CustomFormAnsResMO)
public class CustomFormAnsResMO: NSManagedObject {

}
extension CustomFormAnsResMO{
    func initWithValue(object:CustomDataRes,withContext:NSManagedObjectContext){
       
        self.formId = object.frmId
        self.queId = object.queId
        self.type = object.type
        self.isAdded = object.isAdded ?? false

        var anss: [AnsDetalsMO] = []
        if let ansModel = object.ans {
            for ansTemp in ansModel {
                let ansEntity = AnsDetalsMO(context: withContext)
                ansEntity.initWithValue2(object: ansTemp, withContext: withContext)
                anss.append(ansEntity)
            }
        }
        self.ans = NSSet(array: anss)
        anss.removeAll()
       }
}
