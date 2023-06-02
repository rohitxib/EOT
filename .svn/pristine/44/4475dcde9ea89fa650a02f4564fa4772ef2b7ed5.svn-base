//
//  EditSiteResp.swift
//  EyeOnTask
//
//  Created by mac on 13/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class EditSiteResp: Codable {
    var success: Bool?
    var count: String?
    var data: EditSiteDetails
    var message : String?
    
    init(succ: Bool, count : String , data : EditSiteDetails? ,message : String ) {
        self.success = succ
        self.count = count
        self.data =  data!
        self.message = message
    }
    
}
class EditSiteDetails :  Codable{
    var adr: String?
    var city: String?
    var ctry: String?
    var lat: String?
    var lng: String?
    var siteId: String?
    var snm: String?
    var state: String?
    var zip: String?
    
    init(adr: String,city: String,ctry: String, lat: String,lng: String,siteId: String,snm: String,state: String,zip: String){
        
        self.adr = adr
        self.city = city
        self.ctry = ctry
        self.lat = lat
        self.lng = lng
        self.siteId = siteId
        self.snm = snm
        self.state = state
        self.zip = zip
        
}
}
