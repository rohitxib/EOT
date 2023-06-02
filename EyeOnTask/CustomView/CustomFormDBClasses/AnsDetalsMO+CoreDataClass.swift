//
//  AnsDetalsMO+CoreDataClass.swift
//  
//
//  Created by Aplite ios on 21/04/23.
//
//

import Foundation
import CoreData

@objc(AnsDetalsMO)
public class AnsDetalsMO: NSManagedObject {

}
extension AnsDetalsMO {
    func initWithValue(object:AnsDetals,withContext:NSManagedObjectContext){
        
        self.value = object.value
        self.key = object.key
        self.layer = object.layer
       }
    func initWithValue2(object:ansDetails,withContext:NSManagedObjectContext){
        
        self.value = object.value
        self.key = object.key
        self.layer = object.layer
       }
}
