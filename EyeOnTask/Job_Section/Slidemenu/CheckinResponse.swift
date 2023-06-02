//
//  CheckinResponse.swift
//  EyeOnTask
//
//  Created by Apple on 14/06/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

class CheckinResponse: Codable {
    var success: Bool?
    var message: String?
    var data: responseData?
}


class responseData: Codable {
    var checkId : String?
    var lastCheckIn : String?
}
