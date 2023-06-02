//
//  AddAppointmentRes.swift
//  EyeOnTask
//
//  Created by Dharmendra Gour on 08/07/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import Foundation

class AddAppointmentRes: Codable {
     var success: Bool?
          var message: String?
          var data: AddAppointment?
          var statusCode : String?
     }


     class AddAppointment: Codable {
          var appId: String?
          var type: String?
          var cltId: String?
          var label : String?
          var des : String?
          var kpr: [KprData]?
          var nm: String?
          var schdlStart : String?
          var schdlFinish: String?
          var status: String?
          var cnm : String?
          var email : String?
          var mob1 : String?
          var mob2 : String?
          var adr : String?
          var city : String?
          var state : String?
          var ctry : String?
          var zip : String?
          var landmark : String?
          var conId : String?
          var attachments:[AppointmentRes]?
          var siteId:String?
          var snm:String?
          var tempId:String?
          var jobLabel:String?
          var jobId:String?
          
     }

     class AppointmentRes: Codable {
         
     //      var attachmentId : String?
     //      var appId : String?
     //      var deleteTable : String?
     //      var image_name : String?
     //      var attachFileName : String?
     //      var attachThumnailFileName : String?
     //      var attachFileActualName : String?
     //      var createdate : String?
         
         var attachmentId: String?
         var deleteTable: String?
         var userId: String?
         var attachFileName: String?
         var attachFileActualName: String?
         var attachThumnailFileName : String?
         var type: String?
         var createdate: String?
         var name: String?
         var image_name: String?
         var appId : String?
         var des: String?
         
     }

     class AppoimentDocumentRes: Codable {
         var success: Bool?
         var message: String?
         var data: [AppointmentRes]?
         var count : String?
         var statusCode  :String?
     }



     //class getCategoryRes: Codable {
     //     var success: Bool?
     //     var message: String?
     //     var data: [AddExpence]?
     //
     //}
     //
     //class getCategoryRs: Codable {
     //     var success: Bool?
     //     var message: String?
     //     var data: [AddExpencee]?
     //     var count: String?
     //
     //}
     //
     //class AddExpencee: Codable {
     //      var ecId: String?
     //      var name:String?
     //
     //}
     //
     //
     //class gettagRs: Codable {
     //     var success: Bool?
     //     var message: String?
     //     var data: [AddExpenceeTag]?
     //     var count: String?
     //
     //}
     //
     //class AddExpenceeTag: Codable {
     //      var etId: String?
     //      var name:String?
     //
     //}
