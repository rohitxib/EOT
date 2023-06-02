//
//  UserUploadChatDocRes.swift
//  EyeOnTask
//
//  Created by Hemant's mac on 17/04/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation


class UserUploadChatDocRes: Codable {
    var success: Bool?
    var message: String?
    var data: [chatDocDetails]?
}

class chatDocDetails: Codable {
    var attachmentId: String?
    var userId: String?
    var attachFileName: String?
    var attachFileActualName: String?
    var attachThumnailFileName : String?
    var createdate: String?
    var name: String?
    var image_name: String?
}
