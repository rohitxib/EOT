//
//  TaxResponse.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 16/04/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation
class taxResponse: Codable {
    var success: Bool?
    var message: String?
    var data: [taxListRes]?
    var count : String?
    var statusCode : String?
}

class taxListRes: Codable {
 
    var taxId : String?
    var label : String?
    var isactive : String?
    var show_Invoice : String?
    var value : Double? = 0.0
    var percentage : String?
    var locId : String?
}

class TaxListResData {
    
    var taxId : String?
    var label : String?
    var isactive : String?
    var show_Invoice : String?
    var value : Double? = 0.0
    var percentage : String?
    var isSelected:Bool?
    var locId : String?
    init(dic:TaxList) {
        taxId = dic.taxId
        label = dic.label
        isactive = dic.isactive
        show_Invoice = dic.show_Invoice
        value = dic.value
        percentage  = dic.percentage
        locId  = dic.locId
        }
    }

class NewTaxListResData {

var taxId : String?
var label : String?
var isactive : String?
var show_Invoice : String?
var value : Double? = 0.0
var percentage : String?
var isSelected:Bool?
var locId : String?
init(dic:TaxList) {
    taxId = dic.taxId
    label = dic.label
    isactive = dic.isactive
    show_Invoice = dic.show_Invoice
    value = dic.value
    percentage  = dic.percentage
    locId  = dic.locId
    }
}
