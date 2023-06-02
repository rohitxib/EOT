//
//  CustomDataRes.swift
//  EyeOnTask
//
//  Created by mac on 14/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class CustomDataRes:  Codable {
    
    var queId: String?
    var frmId : String?
    var type : String?
    var isAdded : Bool?
    var ans : [ansDetails]?
    
}

class ansDetails : Codable {
    
    var key : String?
    var value : String?
    var layer : String?
    
}
