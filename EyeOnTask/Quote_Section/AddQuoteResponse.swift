//
//  AddQuoteResponse.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 31/07/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

class AddQuoteResponse: Codable {
    var success: Bool?
    var message: String?
    var data:AddQuot?
}

class AddQuot: Codable {
    var quotId:String?
    var invId:String?
    var label:String?
  
}
//"data":{"quotId":"583","invId":"19763","label":"App41"}
