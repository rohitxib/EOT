//
//  SiteVCResp.swift
//  EyeOnTask
//
//  Created by mac on 13/06/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class SiteVCResp: Codable {
    var success: Bool?
    var count: String?
    var data: [SiteVCRespDetails]
    var message : String?
    var statusCode : String?
    
    init(succ: Bool, count : String , data : Array<Codable>? ,message : String , statusCode: String?) {
        self.success = succ
        self.count = count
        self.data =  data as! [SiteVCRespDetails]
        self.message = message
        self.statusCode = statusCode
    }
}


class SiteVCRespDetails :  Codable{
    
    var adr: String?
    var city: String?
    var ctry: String?
    var lat: String?
    var lng: String?
    var siteId: String?
    var snm: String?
    var state: String?
    var zip: String?
    var cltId : String?
    var def : String?
    var isdelete : String?
    var tempId: String?

    
    
    init(adr: String,city: String,ctry: String, lat: String,lng: String,siteId: String,snm: String,state: String,zip: String ,cltId: String, isdelete: String, tempId: String){
        
       
        self.adr = adr
        self.city = city
        self.ctry = ctry
        self.lat = lat
        self.lng = lng
        self.siteId = siteId
        self.snm = snm
        self.state = state
        self.zip = zip
        self.cltId = cltId
        self.isdelete = isdelete
        self.tempId = tempId

}
}

