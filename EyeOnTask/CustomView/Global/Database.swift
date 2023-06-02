//
//  Database.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 30/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol DataSyncDelegate : class {
    func dataSyncComplete(isJobList : Bool)
}


var delegate: DataSyncDelegate?

class DatabaseClass {
    static let shared = DatabaseClass()
    weak var delegate: DataSyncDelegate?
    var bgTask : BackgroundTaskManager?
    var attempedCount = Int()
    var callbackForJobVC: ((Bool) -> Void)?
    var callbackForClientVC: ((Bool) -> Void)?
    var callbackForContactVC: ((Bool) -> Void)?
    var callbackForSiteVC: ((Bool) -> Void)?
    
    
    //==========================================================================================
    //Note:- When any data ADD and UPDATE in database after that call DatabaseClass.shared.saveEntity() method otherwise database will not update.
    //===========================================================================================
    let context = APP_Delegate.persistentContainer.newBackgroundContext()

    var isSync = Bool()
    var isAdded = Bool()
    var isProgressBarShow = Bool()
    var TotalSyncCount = Int()
    
    let progressView = UIProgressView()
    let label = UILabel()
    var progressBackground = UIView()
    
    
    //===========================
    //MARK:- Initialize Database
    //===========================
    private init() {
        //   print("initialize Database")
        //InitializeProgressBar()
    }
    
    
    
    //=====================
    //MARK:- Create Entity
    //=====================
    func createEntity(entityName : String) -> NSManagedObject? {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        //print("Created managed object data \(entityName)")
        return newUser
    }
    
    
    //=====================
    //MARK:- Save Entity
    //=====================
    func saveEntity(callback:(Bool)  -> Void) -> Void {
        //print("process in saving....")
        //let context = APP_Delegate.persistentContainer.viewContext
        if context.hasChanges{
            context.performAndWait({
                do {
                    
                    try context.save()
                    
                    callback(true)
                } catch {
                    
                    callback(true)
                    print("error in saving")
                }
            })
        }else{
            callback(true)
        }
        
    }
    
    // METHORD TO STORE CUSTOMFORM :-
    
    func storeCustomFormSubmitStatus(formID: String,jobID:String,subStatus:Bool?) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CustomFormSubmitStatus")
        fetchRequest.predicate = NSPredicate(format: "jobId = %@ AND formId = %@",jobID,formID)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error.localizedDescription)
        }
        // storing
        if let status = subStatus{
            print("")
            let customRecord = CustomFormSubmitStatusMO(context: context)
            customRecord.initWithValue(jobID: jobID, formID: formID, status: status, withContext: context)
            do {
                try context.save()
            } catch let error as NSError {
                print ("Could not save. \(error), \(error.userInfo)")}
        }
    }
    
    func storeCustomFormInDataBase(customForm: [CustomFormDetals],jobID:String,formID:String) {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CustomFormDetals") // Find this name in your .xcdatamodeld file
        fetchRequest.predicate = NSPredicate(format: "jobId = %@ AND frmId = %@",jobID,formID)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error.localizedDescription)
        }
        
        // storing
        if customForm.count > 0{
            customForm.forEach { form in
                print(form)
                let customRecord = CustomFormDetalsMO(context: context)
                customRecord.initWithValue(object: form, withContext: context,jobID: jobID)
                do {
                    try context.save()
                } catch let error as NSError {
                    print ("Could not save. \(error), \(error.userInfo)")}
            }
        }
    }
    
    func storeOnlyCustomFormInDataBase(customForm: [CustomFormDetals],formID:String) {
        
        //delet if alreadt existed
               let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CustomForm")
               fetchRequest.predicate = NSPredicate(format: "formId = %@",formID)
               let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
               do {
                   try context.execute(deleteRequest)
               } catch let error as NSError {
                   // TODO: handle the error
                   print(error.localizedDescription)
               }
        
        // storing
        if customForm.count > 0{
            print("")
            let customRecord = CustomFormMO(context: context)
            customRecord.initWithValue(object: customForm, withContext: context,formID: formID)
            do {
                try context.save()
            } catch let error as NSError {
                print ("Could not save. \(error), \(error.userInfo)")}
        }
    }
    
    func storeOnlyCustomFormAnsInDataBase(customFormAns: [CustomDataRes],formID:String,jobID:String,optionId:String) {

        //delet if alreadt existed
               let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CustomFormAnswer")
               fetchRequest.predicate = NSPredicate(format: "jobId = %@ AND formId = %@ AND opId = %@",jobID,formID,optionId)
               let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
               do {
                   try context.execute(deleteRequest)
               } catch let error as NSError {
                   // TODO: handle the error
                   print(error.localizedDescription)
               }
        
        // storing
        if customFormAns.count > 0{
            print("")
            let customRecord = CustomFormAnswerMO(context: context)
            customRecord.initWithValue(object: customFormAns, withContext: context, jobID: jobID, formID: formID, opID: optionId)
            do {
                try context.save()
            } catch let error as NSError {
                print ("Could not save. \(error), \(error.userInfo)")}
        }
    }
    
    func fetchCustomDataRequest(customFormID:String, jobID:String) -> [CustomFormDetals] {
        var customVCArr = [CustomFormDetals]()
        let fetchrequest = CustomFormDetalsMO.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "jobId = %@ AND frmId = %@",jobID,customFormID)
        
        do{
            let records = try context.fetch(fetchrequest)
            print(records)
            for record in records {
                var objAns = [AnsDetals]()
                var objOpt = [OptDetals]()
                
                let arrAnsDetal =  record.ans?.allObjects as! [AnsDetalsMO]
                for ansTemp in arrAnsDetal {
                    let ansDetail = AnsDetals.init(key: ansTemp.key, value: ansTemp.value, layer: ansTemp.layer)
                    objAns.append(ansDetail)
                }
                
                let arrOptDetals =  record.opt?.allObjects as! [OptDetalsMO]
                for optTemp in arrOptDetals {
                    let optDetail = OptDetals.init(key: optTemp.key, questions: nil, value: optTemp.value, optHaveChild: optTemp.optHaveChild)
                    objOpt.append(optDetail)
                }
                
                objOpt.sort {
                    $0.key! < $1.key!
                }
                
                let customRecord = CustomFormDetals.init(queId: record.queId, parentId: record.parentId, parentAnsId: record.parentAnsId, frmId: record.frmId, des: record.des, type: record.type, mandatory: record.mandatory, frmType: record.frmType, opt: objOpt, ans: objAns)
                
                customVCArr.append(customRecord)
                objAns.removeAll()
                objOpt.removeAll()
                
            }
            print(customVCArr)
            try context.save()
        } catch let error as NSError {
            print ("Could not save. \(error), \(error.userInfo)")
        }
        return customVCArr
    }
    
    func fetchCustomFormBy(customFormID:String, jobID:String) -> [CustomFormDetals] {
        var customVCArr = [CustomFormDetals]()
        var customVCArr2 = [CustomFormDetals]()
        
        let fetchrequest = CustomFormMO.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "formId = %@",customFormID)
        
        do{
            let customForms = try context.fetch(fetchrequest)
            print(customForms)
            if customForms.count > 0 {
                var customFrm = customForms.first
                
                customFrm?.formQuestions?.forEach{ qusObject in
                    let questionTemp  = qusObject as! CustomFormDetalsMO
                    // assigning que to model
                    var objAns = [AnsDetals]()
                    var objOpt = [OptDetals]()
                    var objOpt2 = [OptDetals]()
                    
                    let arrOptDetals =  questionTemp.opt?.allObjects as! [OptDetalsMO]
                    for optTemp in arrOptDetals {
                        let optDetail = OptDetals.init(key: optTemp.key, questions: nil, value: optTemp.value, optHaveChild: optTemp.optHaveChild)
                        objOpt.append(optDetail)
                    }
                 
                    // sorting options acording to return by server
                    
                    if   let optIDs = questionTemp.arrayOfOptionId{
                        
                        for optID in optIDs{
                            if let idx = objOpt.firstIndex(where: { $0.key ==  optID }){
                                let optFirst  = objOpt[idx]
                                objOpt2.append(optFirst)
                            }
                        }
                        objOpt = objOpt2
                    }
                    
                    let customRecord = CustomFormDetals.init(queId: questionTemp.queId, parentId: questionTemp.parentId, parentAnsId: questionTemp.parentAnsId, frmId: questionTemp.frmId, des: questionTemp.des, type: questionTemp.type, mandatory: questionTemp.mandatory, frmType: questionTemp.frmType, opt: objOpt, ans: objAns)
                    
                    customVCArr.append(customRecord)
                    objAns.removeAll()
                    objOpt.removeAll()
                }
                // to maintain question order in form
                
                
                if   let quesIDs = customFrm?.arryOfQueID{
                    
                    for qusID in quesIDs{
                        if let idx = customVCArr.firstIndex(where: { $0.queId ==  qusID }){
                            let objOfCusArr  = customVCArr[idx]
                            customVCArr2.append(objOfCusArr)
                        }
                    }
                    customVCArr = customVCArr2
                    
                }
            }
            
            print(customVCArr)
            try context.save()
        } catch let error as NSError {
            print ("Could not save. \(error), \(error.userInfo)")
        }
        
        return customVCArr
    }
    
    func fetchCustomFormAnswersBy(customFormID:String, jobID:String,optionId:String) -> [CustomDataRes] {
        var customVCArr = [CustomDataRes]()
        let fetchrequest = CustomFormAnswerMO.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "jobId = %@ AND formId = %@ AND opId = %@",jobID,customFormID,optionId)
        
        do{
            let customForms = try context.fetch(fetchrequest)
            print(customForms)
            if customForms.count > 0 {
                var customFrm = customForms.first
                
                customFrm?.answeres?.forEach{ qusObject in
                    let answereTemp  = qusObject as! CustomFormAnsResMO
                    // assigning que to model
                    var objAns = [ansDetails]()
                    
                    var custmAns = CustomDataRes()
                    custmAns.queId = answereTemp.queId
                    custmAns.frmId = answereTemp.formId
                    custmAns.type = answereTemp.type
                    custmAns.isAdded = answereTemp.isAdded
                    
                    let arrAnsDetal =  answereTemp.ans?.allObjects as! [AnsDetalsMO]
                    for ansTemp in arrAnsDetal {
                        let ansDetail = ansDetails()
                        ansDetail.key = ansTemp.key
                        ansDetail.value = ansTemp.value
                        ansDetail.layer = ansTemp.layer
                        objAns.append(ansDetail)
                    }
                    custmAns.ans = objAns
                    
                    customVCArr.append(custmAns)
                    objAns.removeAll()
                }
            }
            
            print(customVCArr)
            try context.save()
        } catch let error as NSError {
            print ("Could not save. \(error), \(error.userInfo)")
        }
        return customVCArr
    }
    
    func deleteCustomFormInDataBase(jobID:String,formID:String) {
        
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CustomFormDetals") // Find this name in your .xcdatamodeld file
        fetchRequest.predicate = NSPredicate(format: "jobId = %@ AND frmId = %@",jobID,formID)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error.localizedDescription)
        }
        
    }

    func deleteCustomFormAns(formID:String,jobID:String,optionId:String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CustomFormAnswer") // Find this name in your .xcdatamodeld file
        
        if optionId == "" {
            fetchRequest.predicate = NSPredicate(format: "jobId = %@ AND formId = %@",jobID,formID)

        }else{
            fetchRequest.predicate = NSPredicate(format: "jobId = %@ AND formId = %@ AND opId = %@",jobID,formID,optionId)

        }
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
           
        }
    }
    
    func countCustomform(customFormID:String, jobID:String) -> Int{
        var dataCount = 0
        let fetchrequest = CustomFormDetalsMO.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "jobId = %@ AND frmId = %@",jobID,customFormID)
        do{
            let recordsCount = try context.count(for: fetchrequest)
            dataCount = recordsCount
        } catch let error as NSError {
            print ("Could not save. \(error), \(error.userInfo)")
        }
        return dataCount
    }
    
    func countTableRecordBy(predicate:String?, tableName:String) -> Int{
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:tableName )
        if let formate = predicate {
            fetchRequest.predicate = NSPredicate(format: formate)
        }
        var dataCount = 0
        
        do{
            let recordsCount = try context.count(for: fetchRequest)
            dataCount = recordsCount
        } catch let error as NSError {
            print ("Could not save. \(error), \(error.userInfo)")
        }
        return dataCount
    }
    
    //=====================
    //MARK:- Delete Entity
    //=====================
    func deleteEntity(object : NSManagedObject, callback:@escaping(Bool)  -> Void) {
        context.delete(object)
        //  self.saveEntity()
        //if callback != nil {
        callback(true)
        // }
    }
    
    
    //=====================
    //MARK:- FETCH Entity
    //=====================
    
    func callSomeMethodWithParams(entityName : String, query : String?, onSuccess success: @escaping (_ JSON: Any?) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let formate = query {
            request.predicate = NSPredicate(format: formate)
        }
        request.returnsObjectsAsFaults = false
        context.performAndWait {
            do{
                let result = try context.fetch(request)
                success(result)
                //  return result
            }catch {
                success(nil)
            }
        }
    }
    
    
    func fetchDataFromDatabse(entityName : String, query : String?) -> Any? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let formate = query {
            
            request.predicate = NSPredicate(format: formate)
        }
        request.returnsObjectsAsFaults = false
        
        do{
            
            let result = try context.fetch(request)
            
            return result
        }catch {
            
            return nil
        }
    }
    
    func fetchDataFromDatabse1(entityName : String, query : String?) -> Any? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let formate = query {
            // NSPredicate(format: "id IN %@", ids
            request.predicate = NSPredicate(format: "id IN %@",formate)
        }
        request.returnsObjectsAsFaults = false
        
        do{
            
            let result = try context.fetch(request)
            
            return result
        }catch {
            
            return nil
        }
    }
    
    //    func fetchDataFromDatabseForJobTittle(entityName : String, query : String?) -> Any? {
    //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    //        if let formate = query {
    //            request.predicate = NSPredicate(format: formate)
    //        }
    //        request.returnsObjectsAsFaults = false
    //
    //        do{
    //
    //            let result = try contextForgetJobTittle.fetch(request)
    //            //print("success")
    //            return result
    //        }catch {
    //            //print("Failed")
    //            return nil
    //        }
    //    }
    //
    //    func fetchDataFromDatabseForForgetFieldWorkerList(entityName : String, query : String?) -> Any? {
    //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    //        if let formate = query {
    //            request.predicate = NSPredicate(format: formate)
    //        }
    //        request.returnsObjectsAsFaults = false
    //
    //        do{
    //
    //            let result = try contextForgetFieldWorkerList.fetch(request)
    //            //print("success")
    //            return result
    //        }catch {
    //            //print("Failed")
    //            return nil
    //        }
    //    }
    //
    //    func fetchDataFromDatabseForgetClientSink(entityName : String, query : String?) -> Any? {
    //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    //        if let formate = query {
    //            request.predicate = NSPredicate(format: formate)
    //        }
    //        request.returnsObjectsAsFaults = false
    //
    //        do{
    //
    //            let result = try contextForgetClientSink.fetch(request)
    //            //print("success")
    //            return result
    //        }catch {
    //            //print("Failed")
    //            return nil
    //        }
    //    }
    //
    //    func fetchDataFromDatabseForgetClientSiteSink(entityName : String, query : String?) -> Any? {
    //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    //        if let formate = query {
    //            request.predicate = NSPredicate(format: formate)
    //        }
    //        request.returnsObjectsAsFaults = false
    //
    //        do{
    //
    //            let result = try contextForgetClientSiteSink.fetch(request)
    //            //print("success")
    //            return result
    //        }catch {
    //            //print("Failed")
    //            return nil
    //        }
    //    }
    //
    //    func fetchDataFromDatabseForgetClientContactSink(entityName : String, query : String?) -> Any? {
    //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    //        if let formate = query {
    //            request.predicate = NSPredicate(format: formate)
    //        }
    //        request.returnsObjectsAsFaults = false
    //
    //        do{
    //
    //            let result = try contextForgetClientContactSink.fetch(request)
    //            //print("success")
    //            return result
    //        }catch {
    //            //print("Failed")
    //            return nil
    //        }
    //    }
    //
    //    func fetchDataFromDatabseForgetTagListService(entityName : String, query : String?) -> Any? {
    //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    //        if let formate = query {
    //            request.predicate = NSPredicate(format: formate)
    //        }
    //        request.returnsObjectsAsFaults = false
    //
    //        do{
    //
    //            let result = try contextForgetTagListService.fetch(request)
    //            //print("success")
    //            return result
    //        }catch {
    //            //print("Failed")
    //            return nil
    //        }
    //    }
    //
    //    func fetchDataFromDatabseForJob(entityName : String, query : String?) -> Any? {
    //
    //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    //        if let formate = query {
    //            request.predicate = NSPredicate(format: formate)
    //        }
    //        request.returnsObjectsAsFaults = false
    //
    //        do{
    //
    //            let result = try contextForJob.fetch(request)
    //            //print("success")
    //            return result
    //        }catch {
    //            //print("Failed")
    //            return nil
    //        }
    //    }
    
    //=========================
    //MARK:- save OFFLINE LIST
    //=========================
    func saveOffline(service : String, param : Params) -> Void {
        let userJobs = self.createEntity(entityName: "OfflineList") as! OfflineList
        userJobs.apis = service
        userJobs.parametres = param.toString
        userJobs.time = Date()
        
        self.saveEntity(callback: {isSuccess in
            self.syncDatabase()
        })
    }
    
    func saveOfflineContect(service : String, param : ParamsContect) -> Void {
        let userJobs = self.createEntity(entityName: "OfflineList") as! OfflineList
        userJobs.apis = service
        userJobs.parametres = param.toString
        userJobs.time = Date()
        
        self.saveEntity(callback: {isSuccess in
            self.syncDatabase()
        })
    }
    
    
    func saveActivityOffline(service : String, param : ActivityParams) -> Void {
        let userJobs = self.createEntity(entityName: "OfflineList") as! OfflineList
        userJobs.apis = service
        userJobs.parametres = param.toString
        userJobs.time = Date()
        
        self.saveEntity(callback: {isSuccess in
            self.syncDatabase()
        })
    }
    
    
    
    func deleteEntityWithName(EntityName : String,  callback :@escaping (Bool) -> Void) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            
            
        } catch {
            
        }
        
        
        callback(true)
        
    }
    
    
    func deleteEntityCustomAns(object : NSManagedObject, callback:@escaping(Bool)  -> Void) {
        context.delete(object)
        do {
            try context.save()
            callback(true)
        } catch {
            callback(true)
            
        }
        
    }
    
    
    func deleteAllRecords( callback : (Bool) -> Void) {
        for entity in Entities.allCases {
            
            if entity != Entities.OfflineList {
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                
                do {
                    try context.execute(deleteRequest)
                    saveEntity { (isSave) in
                        
                    }
                    
                } catch {
                    print ("There was an error")
                }
            }
        }
        
        callback(true)
        //        do {
        //            try context.save()
        //            print("All entity deleted")
        //            callback(true)
        //        } catch {
        //            callback(true)
        //            print ("All entity deleted There was an error")
        //        }
    }
    
    //=====================
    //MARK:- DataBase SYNC
    //=====================
    func syncDatabase() -> Void {
        if isHaveNetowork() {
            if self.isSync {
                //print("Database already syncing...")
            }else{
                // print("Start Syncing...")
                self.isSync = true
                
                //Use the BackgroundTaskManager to manage all the background Task
                if bgTask == nil{
                    bgTask =  BackgroundTaskManager.shared()
                    bgTask?.beginNewBackgroundTask()
                }
                self.UploadRequests()
            }
        }else{
            self.isSync = false
            bgTask = nil
            // print("Syncing Failed Because of network error...")
        }
    }
    
    
    //=====================
    //MARK:- UploadRequests
    //=====================

    func UploadRequests() -> Void {
        var arryData = self.fetchDataFromDatabse(entityName: "OfflineList", query: nil) as! [OfflineList]
        // print("arry data count ===================== \(arryData.count)")
        
        if arryData.count > 0 {
            // Sort requests in assending order for upload request according to time (First in First out)
            arryData = arryData.sorted(by: {
                $0.time?.compare($1.time!) == .orderedAscending
            })
           // print("************************\(arryData.count)")

            
            let arryData2 = [arryData.first!]
            
            for obj in arryData2 {
                
                let data = obj //arryData [0]
                
                if data.apis == Service.addAppointment || data.apis == Service.updateAppointment {
                    
                    serverCommunicatorUplaodImageAppoiment(url: data.apis!, param:  data.parametres?.toDictionary, images:  nil
                                                           , imagePath: "appDoc[]", docUrl: nil) { (response, success) in
                        
                        if success {
                            
                            guard let data1 = response  else { return }
                            
                            do {
                                
                                let res = try JSONSerialization.jsonObject(with: (data1 as? Data)!)
                                
                                if ((res as! [String : Any])["success"] as! Bool){
                                    
                                    //Delete data here
                                    self.context.delete(data)
                                    DatabaseClass.shared.saveEntity(callback: { _ in})
                                    
                                    if let dict = ((res as! [String : Any])["data"] as? [String : Any]){
                                        
                                        if(dict["tempId"] != nil && dict["tempId"] as! String != ""){
                                            let temp = (dict["tempId"] as! String).components(separatedBy: "-")
                                            
                                            let tempid = temp[0]
                                            
                                            if tempid == "Job" {
                                                self.replaceJobID(dict: dict)
                                                
                                            }else if(tempid == "Contact"){
                                                self.replaceContactID(dict: dict)
                                                
                                            }else if(tempid == "Site"){
                                                self.replaceSiteID(dict: dict)
                                                
                                            }else if(tempid == "Client"){
                                                self.replaceClientID(dict: dict)
                                                
                                            }else if(tempid == "Appointment"){
                                                
                                                self.replaceAppointmentID(dict: dict)
                                            }
                                        }
                                    }else{
                                        if let arr = ((res as! [String : Any])["data"] as? [[String : Any]]){
                                            if(arr.count > 0){
                                                
                                                if(arr[0]["jobid"] != nil){
                                                    var dict = [String : Any]()
                                                    dict["data"] = [ "status_code" : arr[0]["status_code"]! ,
                                                                     "jobid" : arr[0]["jobid"]!]
                                                    NotiyCenterClass.fireJobRemoveNotifier(dict: (dict))
                                                    
                                                    let arrOfVC = (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).viewControllers
                                                    
                                                    for vc in arrOfVC{
                                                        if(vc is JobVC){
                                                            (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popToViewController(vc, animated: true)
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        
                                    }
                                }else{
                                    //check error attempt and save in database
                                    
                                    if ((res as! [String : Any])["statusCode"] != nil && (res as! [String : Any])["statusCode"] as! String == "2"){
                                        //Delete data here
                                        self.context.delete(data)
                                        DatabaseClass.shared.saveEntity(callback: {isSuccess in
                                            self.UploadRequests()
                                        })
                                        return
                                    }else  if  (res as! [String : Any])["statusCode"] != nil && ((res as! [String : Any])["statusCode"] as! String == "401"){
                                        self.isSync = false
                                        ShowAlert(title:getServerMsgFromLanguageJson(key:((res as! [String : Any])["message"] as! String)) , message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                            if (Ok){
                                                DispatchQueue.main.async {
                                                    (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                                }
                                            }
                                        })
                                    }else{
                                         self.saveError(data: data, response: response)
                                    }
                                    return
                                }
                                
                            } catch {
                                //check error attempt and save in database
                                 self.saveError(data: data, response: response)
                                return
                            }
                            
                            //Re-call this method for check if pending requests  in Offline Table
                            self.UploadRequests()
                            
                        }else{
                            self.isSync = false
                            //check error attempt and save in database
                            if errorString == AlertMessage.formatProblem {
                                self.saveError(data: data, response: response)
                            }
                        }
                    }
                    
                    
                } else if data.apis == Service.addSignatureAndDoc {
                  //  print(" offline sync image upload when user is online data.apis \(data.apis)")
//                    var strJobId = ""
//                    var strFrmId = ""
                    var strDocSaved = [String]()
                    var strSignSaved = [String]()
                    var arrDocImageModel = [ImageModel]()
                    var arrSignImageModel = [ImageModel]()
                    var arrOfflineImage = [String]()
                    var finalParam: [String: Any] = [:]
                    DispatchQueue.main.async {
                    let savedDict = data.parametres?.toDictionary
                        if savedDict != nil {
                            finalParam = data.parametres?.toDictionary ?? [:]
                        }
//                    if let jobId = savedDict?["jobId"] as? String {
//                        print(" jobId isis  \(jobId)")
//                        strJobId = jobId
//                    }
                    
                    if let arrDoc = savedDict?["docQueIdArray"] as? NSArray, arrDoc.count > 0 {
                        for obj in arrDoc {
                            if let strDoc = obj as? String {
                                strDocSaved.append(strDoc)
                            }
                        }
                        finalParam["docQueIdArray"] = strDocSaved
                    }
                    
                    if let arrDoc = savedDict?["signQueIdArray"] as? NSArray, arrDoc.count > 0 {
                        for obj in arrDoc {
                            if let strSign = obj as? String {
                                strSignSaved.append(strSign)
                            }
                        }
                        finalParam["signQueIdArray"] = strSignSaved
                    }
                        // rohit***************
                                                let jobId = savedDict?["jobId"] as? String
                                                let frmId = savedDict?["frmId"] as? String
                                                //"Photo-\(jobId! + signId! + frmId!).jpg"
                                                for itemm in strSignSaved {
                                                    let signId = itemm
                                                    let imageName = "Photo-\(jobId! + frmId!+signId).jpg"
                                                    if let imageObj = self.getImage(imageName: imageName){
                                                        let signImage: ImageModel = ImageModel(img: imageObj, id: signId, frmId: frmId)
                                                        arrSignImageModel.append(signImage)
                                                    }
                                                    arrOfflineImage.append(imageName)
                                                }
                                                for itemm in strDocSaved {
                                                    let signId = itemm
                                                    let imageName = "Photo-\(jobId! + frmId!+signId).jpg"
                                                    if let imageObj = self.getImage(imageName: imageName){
                                                        let signImage: ImageModel = ImageModel(img: imageObj, id: signId, frmId: frmId)
                                                        arrDocImageModel.append(signImage)
                                                    }
                                                    arrOfflineImage.append(imageName)
                                                }
                                                print("arrSignImageModel\(arrSignImageModel.count)")
                                                print("arrDocImageModel\(arrDocImageModel.count)")
                                                print("arrDocImageModel\(arrOfflineImage)")
                                                print("strSignSaved\(strSignSaved)")
                                                print("strDocSaved\(strDocSaved)")

                                               //rohit ****************
                        
//                    if let arrAnswer = savedDict?["answer"] as? [[String:Any]] {
//                        for obj in arrAnswer {
//                            if let queId = obj["queId"] as? String, let frmId = obj["frmId"] as? String {
//                               // strFrmId = frmId
//                                if strSignSaved.count > 0 {
//                                    for objSign in strSignSaved {
//                                        if objSign == queId {
//                                            //  let imageName = "Photo-\(strJobId+queId+frmId).jpg"
//                                            let imageName = "Photo-\(queId+frmId).jpg"
//                                            arrOfflineImage.append(imageName)
//                                            if let imageObj = self.getImage(imageName: imageName) {
//                                                let objSignImageModel: ImageModel = .init(img: imageObj, id: queId , frmId: frmId)
//                                                arrSignImageModel.append(objSignImageModel)
//                                            }
//                                        }
//                                    }
//                                }
//
//                                if strDocSaved.count > 0 {
//                                    for objDoc in strDocSaved {
//                                        if objDoc == queId {
//                                            //  let imageName = "Photo-\(strJobId+queId+frmId).jpg"
//                                            let imageName = "Photo-\(queId+frmId).jpg"
//                                            arrOfflineImage.append(imageName)
//                                            if let imageObj = self.getImage(imageName: imageName) {
//                                                let objDocImageModel: ImageModel = .init(img: imageObj, id: queId, frmId: frmId)
//                                                arrDocImageModel.append(objDocImageModel)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
                }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        serverCommunicatorUplaodSignatureAndAttachment(stringUrl: Service.addSignatureAndDoc, method: "POST", parameters: finalParam, imageSig: arrSignImageModel, imageAtchmnt: arrDocImageModel, signaturePath: "signAns[]", atchmntPath: "docAns[]") { response, error, succes in
                            if succes {
                                guard let data1 = response  else { return }
                                do {
                                    let res = try JSONSerialization.jsonObject(with: (data1 as? Data)!)
                                    if ((res as! [String : Any])["success"] as! Bool){
                                        //Delete data here
                                        print("******************** document sync online from database")
                                        if let obj  = data.parametres?.toDictionary, obj != nil {
                                            if let jobID = obj["jobId"] as? String {//rohit30
                                                print(jobID)
                                                if let formID = obj["frmId"] as? String {
                                                    print("================submited by sink")
                                                        DatabaseClass.shared.storeCustomFormSubmitStatus(formID: formID, jobID: jobID, subStatus: true)
                                                        DatabaseClass.shared.deleteCustomFormAns(formID: formID, jobID: jobID, optionId: "")
                                                    
                                                    //Remove Image in File Manager in Mobile : -
                                                                        for index in arrOfflineImage {
                                                                            self.deleteFileForImage(fileName: index)
                                                                        }
                                                   
                                                }
                                            }
                                            
                                           
                                            var customansArr = [CustomAns]()
                                            customansArr = DatabaseClass.shared.fetchDataFromDatabse(entityName: "CustomAns", query: nil) as! [CustomAns]
                                            for job in customansArr{
                                                DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
                                            }
                                            self.context.delete(data)
                                            DatabaseClass.shared.saveEntity(callback: { _ in})
                                        }
                                    } else {
                                        //check error attempt and save in database
                                        if ((res as! [String : Any])["statusCode"] != nil && (res as! [String : Any])["statusCode"] as! String == "2") {
                                            //Delete data here
                                            self.context.delete(data)
                                            DatabaseClass.shared.saveEntity(callback: {isSuccess in
                                                self.UploadRequests()
                                            })
                                            return
                                        } else if  (res as! [String : Any])["statusCode"] != nil && ((res as! [String : Any])["statusCode"] as! String == "401") {
                                            self.isSync = false
                                            ShowAlert(title:getServerMsgFromLanguageJson(key:((res as! [String : Any])["message"] as! String)) , message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                                if (Ok){
                                                    DispatchQueue.main.async {
                                                        (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                                    }
                                                }
                                            })
                                        }
                                        return
                                    }
                                } catch {
                                    return
                                }
                                //Re-call this method for check if pending requests  in Offline Table
                                self.UploadRequests()
                            } else {
                                    self.isSync = false
                            }
                        }
                    }
                } else if  data.apis == Service.addAnswer  {
                    serverCommunicator(url: Service.addAnswer, param: data.parametres?.toDictionary) { (response, success) in
                        if success {
                            guard let data1 = response  else { return }
                            do {
                                let res = try JSONSerialization.jsonObject(with: (data1 as? Data)!)
                                if ((res as! [String : Any])["success"] as! Bool){
                                    //Delete data here
                                    print("******************** add answer addAnswer")
                                    if let obj  = data.parametres?.toDictionary, obj != nil {
                                        if let jobID = obj["jobId"] as? String {
                                            print(jobID)
                                            if let formID = obj["frmId"] as? String{
                                                DatabaseClass.shared.storeCustomFormSubmitStatus(formID: formID, jobID: jobID, subStatus: true)
                                            }
                                        }
                                        self.context.delete(data)
                                        DatabaseClass.shared.saveEntity(callback: { _ in})
                                    }
                                }else{
                                    //check error attempt and save in database
                                    if  (res as! [String : Any])["statusCode"] != nil && ((res as! [String : Any])["statusCode"] as! String == "401"){
                                        self.isSync = false
                                        ShowAlert(title:getServerMsgFromLanguageJson(key:((res as! [String : Any])["message"] as! String)) , message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                            if (Ok){
                                                DispatchQueue.main.async {
                                                    (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                                }
                                            }
                                        })
                                    }
                                    return
                                }
                            } catch {
                                return
                            }
                        }
                    }
                } else {
                    serverCommunicator(url: data.apis!, param: data.parametres?.toDictionary ) { (response, success) in
                        
                        if success {
                            let param1 = data.parametres?.toDictionary
                            guard let data1 = response  else { return }
                            
                            do {
                                
                                let res = try JSONSerialization.jsonObject(with: (data1 as? Data)!)
                                
                                if ((res as! [String : Any])["success"] as! Bool){
                                    
                                   
                                    let apiName =  data.apis ?? ""
                                    //Delete data here

                                    self.context.delete(data)
                                    DatabaseClass.shared.saveEntity(callback: { isSuccess in
                                       // print("==============hi i am callback of delete entity")

                                    })
                                    
                                    if let dict = ((res as! [String : Any])["data"] as? [String : Any]){
                                        
                                        if(dict["tempId"] != nil && dict["tempId"] as! String != ""){
                                            let temp = (dict["tempId"] as! String).components(separatedBy: "-")
                                            
                                            let tempid = temp[0]
                                            
                                            if tempid == "Job" {
                                                self.replaceJobID(dict: dict)
                                                self.offlineItemSync(dict: dict)
                                                
                                            }else if(tempid == "Contact"){
                                                self.replaceContactID(dict: dict)
                                                
                                            }else if(tempid == "Site"){
                                                self.replaceSiteID(dict: dict)
                                                
                                            }else if(tempid == "Client"){
                                                self.replaceClientID(dict: dict)
                                                
                                            }else if(tempid == "Appointment"){
                                                self.replaceAppointmentID(dict: dict)
                                            } else if apiName == Service.addItemOnJob {
                                                
                                            }
                                        }
                                    } else{
                                        if let arr = ((res as! [String : Any])["data"] as? [[String : Any]]){
                                            if(arr.count > 0){
                                                
                                                if(arr[0]["jobid"] != nil){
                                                    var dict = [String : Any]()
                                                    dict["data"] = [ "status_code" : arr[0]["status_code"]! ,
                                                                     "jobid" : arr[0]["jobid"]!]
                                                    NotiyCenterClass.fireJobRemoveNotifier(dict: (dict))
                                                    
                                                    let arrOfVC = (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).viewControllers
                                                    
                                                    for vc in arrOfVC{
                                                        if(vc is JobVC){
                                                            (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popToViewController(vc, animated: true)
                                                        }
                                                    }
                                                    
                                                } else  {
                                                    if apiName == Service.addItemOnJob || apiName == Service.updateItemInJobMobile || apiName == Service.deleteItemFromJob {
                                                        if let dict = (res as! [String : Any])["data"] as? [[String:Any]] {
                                                            self.replaceJobItemDataID(dict: dict , jobID: param1?["jobId"] as? String ?? "")
                                                        }
                                                        if let totalAmount = (res as! [String : Any])["totalAmount"] as? Any, totalAmount != nil && apiName == Service.deleteItemFromJob {
                                                           // print("totalAmount is \(totalAmount) and apiName is \(apiName) ")
                                                            NotiyCenterClass.fireRefreshInvoiceAmount(dict: [:])
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }

                                }else{
                                    //check error attempt and save in database
                                    
                                    if ((res as! [String : Any])["statusCode"] != nil && (res as! [String : Any])["statusCode"] as! String == "2"){
                                        //Delete data here
                                        self.context.delete(data)
                                        DatabaseClass.shared.saveEntity(callback: {isSuccess in
                                            print("==============ELSEBLOCK i am callback of delete entity")

                                            self.UploadRequests()
                                        })
                                        return
                                    }else  if  (res as! [String : Any])["statusCode"] != nil && ((res as! [String : Any])["statusCode"] as! String == "401"){
                                        self.isSync = false
                                        ShowAlert(title:getServerMsgFromLanguageJson(key:((res as! [String : Any])["message"] as! String)) , message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                            if (Ok){
                                                DispatchQueue.main.async {
                                                    (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                                }
                                            }
                                        })
                                    }else{
                                          self.saveError(data: data, response: response)
                                    }
                                    return
                                }
                                self.UploadRequests()

                                // }
                            } catch {
                                //check error attempt and save in database
                                  self.saveError(data: data, response: response)
                                return
                            }
                            
                            //Re-call this method for check if pending requests  in Offline Table
                           // self.UploadRequests() // commented by rohit
                            
                        }else{
                            self.isSync = false
                            
                            if errorString == AlertMessage.formatProblem {
                                 self.saveError(data: data, response: response)
                            }
                        }
                    }
                }
            }
            
        }else{
            self.isSync = false
        }
    }
    
    func saveError(data: OfflineList, response : Any?) -> Void {
        self.attempedCount =  self.attempedCount + 1
        
        if self.attempedCount == 3 {
            attempedCount = 0
            
            var responseData = ""
            
            if let data = response {
                responseData = String(data: data as! Data, encoding: .utf8)!
            }else{
                responseData = errorString
            }
            
            self.saveInErrorTable(service: data.apis!, params: data.parametres!, response: responseData , time: data.time!)
            //Delete data here
            self.context.delete(data)
            DatabaseClass.shared.saveEntity(callback: {isSuccess in
                self.UploadRequests()
            })
        }else{
            //Re-call this method for check if pending requests in Offline Table
            self.UploadRequests()
            // print("Sync Failed...")
        }
        
    }
    
    
    func uploadErrorsOnServer() -> Void {
        var errorArry = self.fetchDataFromDatabse(entityName:Entities.ErrorsList.rawValue, query: nil) as! [ErrorsList]
        
        if errorArry.count > 0{
            
            // Sort requests in assending order for upload request according to time (First in First out)
            errorArry = errorArry.sorted(by: {
                $0.time?.compare($1.time!) == .orderedAscending
            })
            
            let data = errorArry [0]
            let param = Params()
            param.apiUrl = data.apiUrl
            param.requestParam = data.requestParam
            param.response = data.response
            param.version = data.version
            
            serverCommunicator(url: Service.errorUpload, param: param.toDictionary, callBack: { (response, success) in
                
                if (success){
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(ErrorServiceResponse.self, from: response as! Data) {
                        if decodedData.success! {
                            self.context.delete(data)
                            DatabaseClass.shared.saveEntity(callback: {isSuccess in
                                //Re-call this method for check if pending requests in Error Table
                                //self.uploadErrorsOnServer() // UNCOMMENT
                            })
                        }
                    }
                }else{
                    
                }
            })
        }
    }
    
    
    
    //===========================
    //MARK:- Replace Job methods
    //===========================
    func replaceJobID( dict :[String : Any]) -> Void {
        
        //Replace Contact id in OFFLINE Entity
        let searchQuery1 = String.init(format: "parametres contains[c] '\"jobId\":\"%@\'", ((dict["tempId"] as! String)))
        let isTempConArry = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineList", query: searchQuery1) as! [OfflineList]
        if isTempConArry.count > 0 {
            for param in isTempConArry {
                var conDict = param.parametres?.toDictionary
                conDict!["jobId"] = dict["jobId"]
                param.parametres = conDict?.toString
            }
        }
        
        let searchQuery = "jobId = '\((dict["tempId"] as! String))'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            existingJob.jobId = dict["jobId"] as? String
            existingJob.label = dict["label"] as? String
            if let finishTime = existingJob.schdlFinish {
                existingJob.schdlFinish = finishTime.description
            }
            if let startTime = existingJob.schdlStart {
                existingJob.schdlStart = startTime.description
            }
            existingJob.snm = (dict["snm"] as! String)
            existingJob.cnm = (dict["cnm"] as! String)
            existingJob.skype = (dict["skype"] as! String)
            existingJob.twitter = (dict["twitter"] as! String)
            existingJob.kpr = (dict["kpr"] as! String)
            
            //Create listner  for new job
            let model = ChatManager.shared.chatModels.filter { (model) -> Bool in
                if model.jobId == existingJob.jobId{
                    return true
                }
                return false
            }
            
            if model.count == 0 {
                let model = ChatModel(from: existingJob)
                ChatManager.shared.chatModels.append(model)
            }
        }
        self.saveEntity(callback: {isSuccess in
            if self.callbackForJobVC != nil {
                self.callbackForJobVC!(true)
            }
        })
    }
    
    
    func offlineItemSync( dict :[String : Any]) -> Void{
        var arryData = self.fetchDataFromDatabse(entityName: "OfflineJob", query: nil) as! [OfflineJob]
        if arryData.count > 0 {
            arryData = arryData.sorted(by: {
                $0.time?.compare($1.time!) == .orderedAscending
            })
            for data in arryData{
                let data1 = data.parametres?.toDictionary
                if data.apis == Service.addItemOnJob || data.apis == Service.updateItemInJobMobile  {
                    let dct = data.parametres?.toDictionary
                    if dct!["jobId"] as! String == dict["tempId"] as! String {
                        let  param  = Params()
                        let item = data1?["itemData"]  as? [itemData]
                        param.jobId = (dict["jobId"]) as? String  ?? ""
                        param.itemData = item != nil ? item  : []
                        param.groupData = []
                        let dic = ["jobId": param.jobId ,"itemData":data1?["itemData"],"groupData":[]]
                        let userJobs = self.createEntity(entityName: "OfflineList") as! OfflineList
                        userJobs.apis = Service.addItemOnJob
                        userJobs.parametres = dic.toString
                        userJobs.time = Date()
                        
                        self.saveEntity(callback: {_ in
                            DatabaseClass.shared.syncDatabase()
                            self.context.delete(data)
                            
                        })
                        
                    } else if data.apis == Service.changeJobStatus {
                        
                    }
                }
                }
            }
    }
   
    //===============================
    //MARK:- Replace Contact methods
    //===============================
    func replaceContactID( dict :[String : Any]) -> Void {
        
        //Replace Contact id in OFFLINE Entity
        let searchQuery1 = String.init(format: "parametres contains[c] '\"conId\":\"%@\'", ((dict["tempId"] as! String)))
        let isTempConArry = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineList", query: searchQuery1) as! [OfflineList]
        if isTempConArry.count > 0 {
            
            for param in isTempConArry {
                var conDict = param.parametres?.toDictionary
                conDict!["conId"] = dict["conId"]
                param.parametres = conDict?.toString
                // DatabaseClass.shared.saveEntity()
            }
        }
        
        
        //Replace Contact id in ClientContactList Entity
        let searchQuery = "conId = '\((dict["tempId"] as! String))'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientContactList", query: searchQuery) as! [ClientContactList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            existingJob.conId = dict["conId"] as? String
            // DatabaseClass.shared.saveEntity()
        }
        
        //delegate?.dataSyncComplete(isJobList: true)
        
        self.saveEntity(callback: {isSuccess in
            if self.callbackForContactVC != nil {
                self.callbackForContactVC!(true)
            }
        })
        
    }
    
    
    //============================
    //MARK:- Replace Site methods
    //============================
    func replaceSiteID( dict :[String : Any]) -> Void {
        
        
        //Replace Site id in OFFLINE Entity
        let searchQuery1 = String.init(format: "parametres contains[c] '\"siteId\":\"%@\'", ((dict["tempId"] as! String)))
        let isTempConArry = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineList", query: searchQuery1) as! [OfflineList]
        if isTempConArry.count > 0 {
            
            for param in isTempConArry {
                var conDict = param.parametres?.toDictionary
                conDict!["siteId"] = dict["siteId"]
                param.parametres = conDict?.toString
                // DatabaseClass.shared.saveEntity()
            }
        }
        
        
        //Replace Contact id in ClientContactList Entity
        let searchQuery = "siteId = '\((dict["tempId"] as! String))'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientSitList", query: searchQuery) as! [ClientSitList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            existingJob.siteId = dict["siteId"] as? String
            // DatabaseClass.shared.saveEntity()
        }
        
        // delegate?.dataSyncComplete(isJobList: true)
        
        self.saveEntity(callback: {isSuccess in
            if self.callbackForSiteVC != nil {
                self.callbackForSiteVC!(true)
            }
        })
        
    }
    
    //===========================
    //MARK:- Replace Job Item Data methods
    //===========================
    func replaceJobItemDataID( dict :[[String : Any]], jobID: String) -> Void {
        
        let searchQuery = "jobId = '\((jobID))'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "UserJobList", query: searchQuery) as! [UserJobList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            
            existingJob.itemData = dict as NSObject
            
        }
        
        self.saveEntity(callback: {isSuccess in
            if self.callbackForJobVC != nil {
                self.callbackForJobVC!(true)
            }
        })
        
    }
    
    
    //===========================
    //MARK:- Replace Appointment methods
    //===========================
    func replaceAppointmentID( dict :[String : Any]) -> Void {
        
        //Replace Contact id in OFFLINE Entity
        let searchQuery1 = String.init(format: "parametres contains[c] '\"appId\":\"%@\'", ((dict["tempId"] as! String)))
        let isTempConArry = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineList", query: searchQuery1) as! [OfflineList]
        if isTempConArry.count > 0 {
            
            for param in isTempConArry {
                var conDict = param.parametres?.toDictionary
                conDict!["appId"] = dict["appId"]
                
                param.parametres = conDict?.toString
                // DatabaseClass.shared.saveEntity()
            }
        }
        
        
        //Replace Contact id in ClientContactList Entity
        let searchQuery = "appId = '\((dict["tempId"] as! String))'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: searchQuery) as! [AppointmentList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            
            existingJob.appId = (dict["appId"] as! String )
            existingJob.label = dict["label"] as? String
            
            if let finishTime = existingJob.schdlFinish {
                existingJob.schdlFinish = finishTime.description
            }
            
            if let startTime = existingJob.schdlStart {
                existingJob.schdlStart = startTime.description
            }
            
            
            //   existingJob.schdlFinish = (dict["schdlFinish"] as! NSNumber).stringValue
            //   existingJob.schdlStart = (dict["schdlStart"] as! NSNumber).stringValue
            //            existingJob.lat = (dict["lat"] as! NSNumber).stringValue
            //            existingJob.lng = (dict["lng"] as! NSNumber).stringValue
            //            existingJob.snm = (dict["snm"] as! String)
            //            existingJob.cnm = (dict["cnm"] as! String)
            //            existingJob.skype = (dict["skype"] as! String)
            //            existingJob.twitter = (dict["twitter"] as! String)
            //            existingJob.kpr = (dict["kpr"] as! String)
            
            // DatabaseClass.shared.saveEntity()
            
            //Create listner  for new job
            //            let model = ChatManager.shared.chatModels.filter { (model) -> Bool in
            //                if model.appId == existingJob.appId{
            //                    return true
            //                }
            //                return false
            //            }
            //
            //            if model.count == 0 {
            //                let model = ChatModel(from: existingJob)
            //                ChatManager.shared.chatModels.append(model)
            //            }
            
            existingJob.snm = (dict["snm"] as? String)
            existingJob.ctry = (dict["ctry"] as? String)
            existingJob.state = (dict["state"] as? String)
            existingJob.siteId = (dict["siteId"] as? String)
            existingJob.city = (dict["city"] as? String)
        }
        
        self.saveEntity(callback: {isSuccess in
            if self.callbackForJobVC != nil {
                self.callbackForJobVC!(true)
            }
        })
        
        
    }
    
    
    
    //===========================
    //MARK:- Replace Appointment methods
    //===========================
    func replaceEditAppointmentID( dict :[String : Any]) -> Void {
        
        //Replace Contact id in OFFLINE Entity
        let searchQuery1 = String.init(format: "parametres contains[c] '\"appId\":\"%@\'", ((dict["tempId"] as! String)))
        let isTempConArry = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineList", query: searchQuery1) as! [OfflineList]
        if isTempConArry.count > 0 {
            
            for param in isTempConArry {
                var conDict = param.parametres?.toDictionary
                conDict!["appId"] = dict["appId"]
                
                param.parametres = conDict?.toString
                // DatabaseClass.shared.saveEntity()
            }
        }
        
        
        //Replace Contact id in ClientContactList Entity
        let searchQuery = "appId = '\((dict["tempId"] as! String))'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "AppointmentList", query: searchQuery) as! [AppointmentList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            
            existingJob.appId = (dict["appId"] as! String )
            existingJob.label = dict["label"] as? String
            existingJob.cltId = dict["cltId"] as? String
            existingJob.siteId = dict["siteId"] as? String
            existingJob.conId = dict["conId"] as? String
            existingJob.des = dict["des"] as? String
            existingJob.status = dict["status"] as? String
            existingJob.nm = dict["nm"] as? String
            existingJob.snm = dict["snm"] as? String
            existingJob.cnm = dict["cnm"] as? String
            existingJob.email = dict["email"] as? String
            existingJob.mob1 = dict["mob1"] as? String
            existingJob.mob2 = dict["mob2"] as? String
            existingJob.adr = dict["adr"] as? String
            existingJob.city = dict["city"] as? String
            existingJob.state = dict["state"] as? String
            existingJob.ctry = dict["ctry"] as? String
            existingJob.zip = dict["zip"] as? String
            //  existingJob.memIds = dict["memIds"] as? String
            //                existingJob.appDoc = dict["appDoc"] as? String
            //                existingJob.clientForFuture = dict["clientForFuture"] as? String
            //                existingJob.siteForFuture = dict["siteForFuture"] as? String
            //                existingJob.contactForFuture = dict["contactForFuture"] as? String
            
            
            if let finishTime = existingJob.schdlFinish {
                existingJob.schdlFinish = finishTime.description
            }
            
            if let startTime = existingJob.schdlStart {
                existingJob.schdlStart = startTime.description
            }
            
        }
        
        self.saveEntity(callback: {isSuccess in
            if self.callbackForJobVC != nil {
                self.callbackForJobVC!(true)
            }
        })
        
        
    }
    
    //============================
    //MARK:- Replace Client methods
    //============================
    func replaceClientID( dict :[String : Any]) -> Void {
        
        //Replace Site id in OFFLINE Entity
        let searchQuery1 = String.init(format: "parametres contains[c] '\"cltId\":\"%@\'", ((dict["tempId"] as! String)))
        let isTempConArry = DatabaseClass.shared.fetchDataFromDatabse(entityName: "OfflineList", query: searchQuery1) as! [OfflineList]
        if isTempConArry.count > 0 {
            
            for param in isTempConArry {
                var conDict = param.parametres?.toDictionary
                conDict!["cltId"] = dict["cltId"]
                param.parametres = conDict?.toString
                //DatabaseClass.shared.saveEntity()
            }
        }
        
        
        //Replace Contact id in ClientContactList Entity
        let searchQuery = "cltId = '\((dict["tempId"] as! String))'"
        let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "ClientList", query: searchQuery) as! [ClientList]
        if isExist.count > 0 {
            let existingJob = isExist[0]
            existingJob.cltId = dict["cltId"] as? String
            //DatabaseClass.shared.saveEntity()
        }
        
        // delegate?.dataSyncComplete(isJobList: true)
        self.saveEntity(callback: {isSuccess in
            if self.callbackForClientVC != nil {
                self.callbackForClientVC!(true)
            }
        })
        
    }
    
    
    //========================
    //MARK:- Sync Progressbar
    //========================
    
    func InitializeProgressBar() -> Void {
        let screenSize = UIScreen.main.bounds
        
        if screenSize.height > 800 {
            progressBackground.frame = CGRect(x: 0, y: 34, width: screenSize.width, height: 10)
        }else{
            progressBackground.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 10)
        }
        
        progressView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 10)
        progressView.trackTintColor = .white
        progressView.progressTintColor = .red
        
        label.frame =  CGRect(x: (screenSize.width/2) - 90, y: 5, width: 180 , height: 15)
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.text = "\(LanguageKey.sync_alert) - (25%)"
        
        progressBackground.addSubview(progressView)
        progressBackground.addSubview(label)
        UIApplication.shared.keyWindow?.addSubview(progressBackground)
        progressBackground.isHidden = true
    }
    
    
    //===========================================
    //MARK:- Sync Error Save in ErrorsList table
    //===========================================
    func saveInErrorTable(service:String, params:String, response:String, time : Date) -> Void {
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let deviceName = UIDevice.modelName
        let iOSVersion = UIDevice.current.systemVersion
        
        
        // If increase any coloum in 'ErrorsList' table so add that key in params during the sending response in function of 'uploadErrorsOnServer()'
        let error = self.createEntity(entityName: Entities.ErrorsList.rawValue) as! ErrorsList
        error.apiUrl = Service.BaseUrl + service
        error.requestParam = params
        error.response = response
        error.time = time
        error.version = "Device Name - \(deviceName), iOS Version - \(iOSVersion), App Version - \(appVersion)"
        self.saveEntity(callback: { isSuccess in })
    }
    
}

//    func excutApiResult(arrOfflineImage: [String],frmId: String,jobId: String, response: Any?,success: Bool) {
//        killLoader()
//        if(success){
//            let decoder = JSONDecoder()
//            if let decodedData = try? decoder.decode(CustomFormResponse.self, from: response as! Data) {
//                if decodedData.success == true{
//                    DatabaseClass.shared.storeCustomFormSubmitStatus(formID: frmId, jobID: jobId, subStatus: decodedData.success)
//                    DatabaseClass.shared.deleteCustomFormAns(formID: frmId, jobID: jobId)
//                    //Remove Image in File Manager in Mobile : -
//                   // var arrOfflineImage = [String]()
//                    for index in arrOfflineImage {
//                        deleteFileForImage(fileName: index)
//                    }
//                    //Re-call this method for check if pending requests  in Offline Table
//                    self.UploadRequests()
//                }else{
//                    if let code =  decodedData.statusCode{
//                        if(code == "401"){
//                            isSync = false
//                            ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
//                                if (Ok){
//                                    DispatchQueue.main.async {
//                                        (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
//                                    }
//                                }
//                            })
//                        }
//                    }else{
//                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
//                    }
//                }
//            }else{
//                ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
//            }
//        }else{
//            self.isSync = false
//        }
//    }
//}

extension DatabaseClass {
    func getImage(imageName:String) -> UIImage?{
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePAth){
            return UIImage(contentsOfFile: imagePAth)
        } else {
            return nil
        }
    }

    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func deleteFileForImage(fileName : String) -> Bool{
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePath = docDir.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: filePath)
            print("File deleted from database")
            return true
        } catch {
            print("Error")
        }
        return false
    }
    
    
    
}
