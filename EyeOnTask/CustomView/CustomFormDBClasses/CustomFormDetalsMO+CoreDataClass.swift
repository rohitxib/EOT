//
//  CustomFormDetalsMO+CoreDataClass.swift
//  
//
//  Created by Aplite ios on 21/04/23.
//
//

import Foundation
import CoreData

@objc(CustomFormDetalsMO)
public class CustomFormDetalsMO: NSManagedObject {

}

extension CustomFormDetalsMO {
    
    func initWithValue(object:CustomFormDetals,withContext:NSManagedObjectContext,jobID:String){
        self.jobId = jobID
        self.frmId = object.frmId
        self.parentId = object.parentId
        self.type = object.type
        self.parentAnsId = object.parentAnsId
        self.mandatory = object.mandatory
        self.des = object.des
        self.queId = object.queId
        self.frmType = object.frmType
        
        var anss: [AnsDetalsMO] = []
        if let ansModel = object.ans {
            for ansTemp in ansModel {
                let ansEntity = AnsDetalsMO(context: withContext)
                ansEntity.initWithValue(object: ansTemp, withContext: withContext)
                anss.append(ansEntity)
            }
        }
        self.ans = NSSet(array: anss)
        anss.removeAll()
        
        var opts: [OptDetalsMO] = []
        if let optModel = object.opt {
            
            let optIDs = optModel.map({ $0.key! })
            self.arrayOfOptionId = optIDs
            for optTemp in optModel {
                let optEntity = OptDetalsMO(context: withContext)
                optEntity.initWithValue(object: optTemp, withContext: withContext)
                opts.append(optEntity)
            }
        }
        self.opt = NSSet(array: opts)
        opts.removeAll()
    }
}
//anss
