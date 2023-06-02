//
//  TagListResponse.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 05/08/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation

class tagListResponse: Codable {
    var success: Bool?
    var data: [tagElements]?
    var count: String?
    var message : String?
    var statusCode : String?
}

class tagElements: Codable {
    var tagId: String?
    var tnm: String?
}

