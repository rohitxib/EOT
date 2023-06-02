//
//  EmailInvoiceRes.swift
//  EyeOnTask
//
//  Created by Mac on 01/05/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation
class EmailRes: Codable {
    var Country: [EmailInvoiceResponse]
    
}

class EmailInvoiceResponse: Codable {
    var success: Bool?
    var message: String?
    var data: EmailInvoiceDetailedData?
}

class EmailInvoiceDetailedData: Codable {
   
       var message : String?
       var subject : String?
       var from : String?
       var fromnm : String?
       var to : String?
      // var stripLink : stripLinkData?
}

class stripLinkData: Codable {
   
       var line_items : [line_itemsArr]?
       var after_completion : after_completionArr?
      
}

class line_itemsArr: Codable {
   
       var price : Int?
       var quantity : Int?
      
}

class after_completionArr: Codable {
   
       var type : String?
       var redirect : redirectURL?
      
}

class redirectURL: Codable {
   
       var url : String?
     
      
}
