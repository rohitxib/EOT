//
//  OptDetalsMO+CoreDataClass.swift
//  
//
//  Created by Aplite ios on 21/04/23.
//
//

import Foundation
import CoreData

@objc(OptDetalsMO)
public class OptDetalsMO: NSManagedObject {

}

extension OptDetalsMO{
    func initWithValue(object:OptDetals,withContext:NSManagedObjectContext){
       
        self.value = object.value
        self.key = object.key
        self.optHaveChild = object.optHaveChild
       }
}
