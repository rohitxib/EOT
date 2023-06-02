//
//  AdminChatRes.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 25/03/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation


class AdminChatRes: Codable {
    var success: Bool?
    var message: String?
    var data: [AdminChat]?
    var count: String?
}

class AdminChat: Codable {
    var usrId : String?
    var fnm : String?
    var lnm : String?
    var img : String?
    var isTeam : String?
    var teamMemId : [AdminChatGrp]?
    
}

class AdminChatGrp: Codable {
    var usrNm : String?
    var usrId : String?
    var usrType : String?
    
    
}

