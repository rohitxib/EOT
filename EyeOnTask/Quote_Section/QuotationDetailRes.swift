//
//  QuotationDetailRes.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 29/07/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

class QuotationDetailRes: Codable {
    var success: Bool?
    var message: String?
    var data: QuotationDetailData?
    var statusCode: String?
}

class QuotationDetailData: Codable {
    var quotId: String?
    var cltId: String?
    var siteId: String?
    var conId: String?
    var label: String?
    var des: String?
    var status: String?
    var athr: String?
    var inst: String?
    var nm: String?
    var cnm: String?
    var snm: String?
    var email: String?
    var mob1: String?
    var mob2: String?
    var adr: String?
    var city: String?
    var state: String?
    var ctry: String?
    var zip: String?
    var createDate: String?
    var updateDate: String?
    var jtId : [jtIdArray]?
    var statenm: String?
    var ctrynm: String?
    var invData: QuoteInvData?
    var assignByUser: String?
    var term: String?
    
}

class QuoteShiping: Codable {
    var iqmmId : String?
    var itemId : String?
    var type : String?
    var rate : String?
    var inm : String?
    var itype : String?
   
}


class QuoteInvData: Codable {
    var invId : String?
    var code : String?
    var nm : String?
    var discount : String?
    var total : String?
    var note : String?
    var invDate : String?
    var duedate : String?
    var createdate : String?
    var label : String?
    var paid : String?
    var cur : String?
    var invType : String?
    var taxCalculationType : String?
    var itemData : [QuoteItemData]?
    var shippingItem : [QuoteShiping]?
}

class QuoteItemData: Codable {
    var iqmmId : String?
    var itemId : String?
    var groupId : String?
    var type : String?
    var rate : String?
    var qty : String?
    var discount : String?
    var inm : String?
    var des : String?
    var itype : String?
    var label : String?
    var hsncode : String?
    var pno : String?
    var unit : String?
    var taxamnt : String?
    var supplierCost : String?
    var jtId : String?
    var tax : [QuoteTaxDetail]?
    var amount : String?
}

class  QuoteTaxDetail : Codable {
    var iqtmmId : String?
    var iqmmId : String?
    var taxId : String?
    var rate : String?
}

class ProAddressRes: Codable {
    var cmpnm : String?
    var adr : String?
    var city : String?
    var country : String?
    var cmpemail : String?
}


class billingDetail: Codable {
    var invId: String?
    var total: String?
    var paid: String?
}


/*
{
    "success": true,
    "message": "quot_found",
    "data": {
        "quotId": "167",
        "cltId": "1574",
        "siteId": "1668",
        "conId": "1637",
        "label": "Hem14",
        "des": "",
        "status": "1",
        "athr": "8",
        "inst": "",
        "nm": "test ",
        "cnm": "test conatcat",
        "snm": "self",
        "email": "",
        "mob1": "",
        "mob2": "",
        "adr": "vijay nagar",
        "city": "",
        "state": "21",
        "ctry": "101",
        "zip": "",
        "createDate": "1563864830",
        "updateDate": "1563864830",
        "jtId": [{
        "jtId": "263",
        "title": "quotes services"
        }],
        "cltAcctType": [],
        "billingSummary": {
            "invId": "462",
            "total": "660.0000",
            "paid": "0.0000"
        },
        "invData": {
            "invId": "462",
            "parentId": "0",
            "compId": "4",
            "cltId": "0",
            "quotId": "167",
            "code": "INV-9",
            "nm": "",
            "adr": "",
            "pro": "{\"cmpnm\":\"Hemant\",\"adr\":\"\",\"city\":\"Indore, Madhya Pradesh\",\"country\":\"India\",\"cmpemail\":\"hemant.rawat@aplitetech.com\"}",
            "discount": "0.0000",
            "total": "660.0000",
            "note": "",
            "pono": "",
            "invDate": "1563899002",
            "duedate": "1563899002",
            "createdate": "1563864830",
            "label": "Hem14",
            "paid": "0.0000",
            "cur": "7",
            "invType": "1",
            "taxCalculationType": "0",
            "itemData": [{
                    "iqmmId": "440",
                    "itemId": "1907",
                    "quotId": "167",
                    "groupId": "0",
                    "type": "3",
                    "rate": "0",
                    "qty": "1",
                    "discount": "0",
                    "inm": "quotes services",
                    "des": "",
                    "itype": "1",
                    "label": "Hem14",
                    "hsncode": "",
                    "pno": "",
                    "unit": "",
                    "taxamnt": "0.0000",
                    "supplierCost": "0.0000",
                    "jtId": "263",
                    "tax": [{
                                "iqtmmId": "1288",
                                "iqmmId": "440",
                                "taxId": "43",
                                "rate": "0"
                                }, {
                                "iqtmmId": "1289",
                                "iqmmId": "440",
                                "taxId": "42",
                                "rate": "0"
                                }]
                    }, {
                    "iqmmId": "441",
                    "itemId": "1906",
                    "quotId": "167",
                    "groupId": "0",
                    "type": "1",
                    "rate": "600",
                    "qty": "1",
                    "discount": "2",
                    "inm": "test",
                    "des": "",
                    "itype": "0",
                    "label": "Hem14",
                    "hsncode": "",
                    "pno": "",
                    "unit": "",
                    "taxamnt": "72.0000",
                    "supplierCost": "500.0000",
                    "jtId": "0",
                    "tax": [{
                            "iqtmmId": "1290",
                            "iqmmId": "441",
                            "taxId": "43",
                            "rate": "6"
                            }, {
                            "iqtmmId": "1291",
                            "iqmmId": "441",
                            "taxId": "42",
                            "rate": "6"
                            }]
                    }]
        }
    }
}
*/
