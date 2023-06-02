//
//  FeedBackRes.swift
//  EyeOnTask
//
//  Created by mac on 28/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class FeedBackRes: Codable {
    var success: Bool?
    var message: String?
    var data: [FeedBackResDetails]
    var count : String?
    var statusCode : String?
}
class FeedBackResDetails : Codable {
    var status_code : String?
    var  jobid : String?
}
