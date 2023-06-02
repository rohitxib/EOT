//
//  TermsResponse.swift
//  EyeOnTask
//
//  Created by Hemant's mac on 15/04/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation

class TermsResponse: Codable {
    var success: Bool?
    var message: String?
    var data: termQuote?
}

class termQuote: Codable {
    var quotTerms: String?
}
