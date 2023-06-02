//
//  RecurResponse.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 05/04/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class RecurResModel: Codable {
      var success: Bool?
      var message: String?
      var data: RecurData?
      var transVar : transVar?
      
}

class RecurData: Codable {
    var numberOfOcurrences: String?
    var endDate: Int?
    var occurence: String?
    var schDateArray: [String]?
    var jobsTillNextStartDate: [String]?
}

class transVar: Codable {
    var interval: String?
    var start_date: String?
    var end_date: String?
    var occurences: String?
    var occur_days: String?
    var week_num: String?
    var day_num:String?
}

class DeleteRecur: Codable {
    var success: Bool?
    var message: String?
    var data: [String]?
    
}


