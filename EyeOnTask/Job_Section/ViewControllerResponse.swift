//
//  ViewControllerResponse.swift
//  EyeOnTask
//
//  Created by mac on 04/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class ViewControllerResponse: Codable {
    var success: Bool?
    var message: String?
    var data: [jobTittleListData]?
    var count : String?
    var statusCode : String?
}

class jobTittleListData: Codable {
    var des: String?
    var jtId: String?
    var labour: String?
    var taxData: [taxDataRes]?
    var title: String?
    var suggestionList: [suggestionListData]?
}

class taxDataRes: Codable {
    var rate: String?
    var taxId: String?
}

class Countries: Codable {
    var countries: [CountriesDetails]?
}

class CountriesDetails: Codable {
    var id: String?
    var sortname: String?
    var name: String?
}

class FldWorkerData: Codable {
    var success: Bool?
    var message: String?
    var data: [FldWorkerDetailsList]?
    var count : String?
    var statusCode : String?
}

class FldWorkerDetailsList: Codable {
    var usrId: String?
    var fnm: String?
    var lnm: String?
    var email: String?
    var mob1: String?
    var img: String?
    var lat: String?
    var lng: String?
    var isactive: String?
}

struct suggestionListData: Codable{
    var suggId: String?
    var compId: String?
    var jtId: String?
    var jtDesSugg: String?
    var complNoteSugg: String?
    var createdDate: String?
    var updateDate: String?
    
}

class getItemPartsResp: Codable {
    var success: Bool?
    var message: String?
    var data: [getItemPartsData]?
    var count : String?
   
}

class getItemPartsData: Codable {
    var qty: String?
    var inm: String?
    var rate: String?
 
}

