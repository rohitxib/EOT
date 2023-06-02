//
//  LanguageManager.swift
//  EyeOnTask
//
//  Created by Mac on 24/05/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation




class LanguageManager {
    static let shared = LanguageManager()
    var mobileMsgsModel = [String : String]()
    var backendMsgsModel = [String : String]()
    let defaultJson = "en_mobile"
    let lanugageFileName = "language.json"
    var dataLang : String?
    //===========================
    //MARK:- Initialize Database
    //===========================
    private init() {
   // print("initialize LanguageManager")
       changeJsonFile()
        
    }
    
    func changeJsonFile() -> Void {
        if let isExist = loadFileFromDocumentDirectory(fileName: lanugageFileName) {
            self.getJsonFileFromBundle(filePath: isExist, callBack: {(_) in })
            }else{
                setDefaultLanguageFile(callBack: {(_) in })
            }
    }
    
    
    func getJsonFileFromBundle(filePath:String, callBack : (Bool) -> Void) -> Void {
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
            guard let anyObj = (try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]) else {
                //print("Could not get JSON from response as Dictionary")
                setDefaultLanguageFile(callBack: callBack)
                return
            }
            
            var  isSwitchOff =  UserDefaults.standard.value(forKey: "staticLabelFwKeyVal") as? String ?? ""
            // print(isSwitchOff!.replacingOccurrences(of: "\\", with: ""))
          
            
            if isSwitchOff != "" {
                //========================================================
                // MARK:- For Statick Label
                //========================================================
                
                
                dataLang = isSwitchOff.replacingOccurrences(of: "\\", with: "" ,options: .literal,range: nil )
                // print(dataLang)
               
                
                let res = try? JSONSerialization.jsonObject(with: dataLang!.data(using:.utf8)!, options: []) as? [String : String]
                
                if res != nil {
                    let resStr = "\(res)"
                 
                    // print(resStr)
                    if let mobileMsg = anyObj["mobileMsgsModel"] {
                        
                        mobileMsgsModel = res!
                        if let backendMsg = anyObj["backendMsgsModel"] {
                            backendMsgsModel = backendMsg as! [String : String]
                        }else{
                            setDefaultLanguageFile(callBack: callBack)
                        }
                    }else{
                        setDefaultLanguageFile(callBack: callBack)
                    }
                }else{
                    if let mobileMsg = anyObj["mobileMsgsModel"] {
                        mobileMsgsModel = mobileMsg as! [String : String]
                        
                        if let backendMsg = anyObj["backendMsgsModel"] {
                            backendMsgsModel = backendMsg as! [String : String]
                        }else{
                            setDefaultLanguageFile(callBack: callBack)
                        }
                    }else{
                        setDefaultLanguageFile(callBack: callBack)
                    }
                }
              
                
            }else{
                
                //========================================================
                // MARK:- For Dynamick Label
                //========================================================
                
                if let mobileMsg = anyObj["mobileMsgsModel"] {
                    mobileMsgsModel = mobileMsg as! [String : String]
                    
                    if let backendMsg = anyObj["backendMsgsModel"] {
                        backendMsgsModel = backendMsg as! [String : String]
                    }else{
                        setDefaultLanguageFile(callBack: callBack)
                    }
                }else{
                    setDefaultLanguageFile(callBack: callBack)
                }
            }
         
        } catch {
            // print("Error in get file")
            setDefaultLanguageFile(callBack: callBack)
        }
    }
    
    
    func setLanguage(filename: String, filePath: String, languageName: String, version: String, alert: Bool, callBack : (Bool) -> Void) {

            let newFileName = lanugageFileName
            let lanugageFileUrl = "\(Service.BaseUrl + filePath + filename).json" //get language file link from here
            saveFileInDocumentDirectory(url: lanugageFileUrl, fileName: newFileName)

            if let isExist = loadFileFromDocumentDirectory(fileName: newFileName){
                LanguageManager.shared.getJsonFileFromBundle(filePath: isExist, callBack: callBack)
                //killLoader()
                saveCurrentSelectedLanguage(filename: languageName)
                saveCurrentSelectedLanguageCode(filename: filename)
                callBack (true)
                if alert {
                     showSuccessfullyChangedToast(langName: languageName)
                }
            }else{
                setDefaultLanguageFile(callBack: callBack)
            }
    }
    
    
    func setDefaultLanguageFile(callBack : (Bool) -> Void) -> Void {
        saveCurrentSelectedLanguage(filename: "English")
        saveCurrentSelectedLanguageCode(filename: "en_US")
        let path = Bundle.main.path(forResource: defaultJson, ofType: "json")
        getJsonFileFromBundle(filePath: path!, callBack: callBack)
    }
    
    
    func showSuccessfullyChangedToast(langName : String) -> Void {
        let mess = LanguageKey.language_success
        let newString = mess.replacingOccurrences(of: EOT_VAR, with: langName)
        windowController.showToast(message: newString)
    }
}

func getValueFromLanguageJson(key:String) -> String? {
    if let value = LanguageManager.shared.mobileMsgsModel[key] {
        if (value != ""){
            return value
        }else{
            return key
        }
    }else{
        return key
    }
}

func getServerMsgFromLanguageJson(key:String) -> String? {
    if let value = LanguageManager.shared.backendMsgsModel[key] {
        if (value != ""){
            return value
        }else{
            return key 
        }
    }else{
        return key 
    }
}
