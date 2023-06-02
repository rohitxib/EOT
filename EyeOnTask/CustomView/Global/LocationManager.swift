//
//  LocationManager.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 25/07/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import CoreLocation
import GLKit

class LocationManager: NSObject , CLLocationManagerDelegate {

    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    
    var locationHistory = [LocationObject]()
    var isUpdate = true
    var isFirstLocation: Bool = true
    var Currentloc = CLLocation()
    var oldLocation = CLLocation()
    var currentLattitude : String = "0.0"
    var currentLongitude : String = "0.0"
    var isPermissionAsked = Bool()
    var isFirstTime : Bool = true
    var isStatus : Bool = false
    var isFirstLogin : Bool = true
    var  isGPSenable = false
    var bgTask : BackgroundTaskManager?
    var timer : Timer?
    var statusTimer : Timer?
    var userDistance : Int = 0
    var trkDuration : Int = 0
    var isBackgroundMode = false
    var callback: ((Bool) -> Void)?
    var isStationary:Bool = false
    // var timeInterval:Int = 0
    var calculateTime:Int = 0
    var switchSpeed = "MPH"
    var traveledDistance:Double = 0
    var speed:Double = 0.0
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        }
        
        locationManager.requestAlwaysAuthorization()
    }
    
    
    func gpsConfiguration(gpsStopTimeInterval : Int) -> Void {

        LocationManager.shared.isGPSenable = true
        LocationManager.shared.isUpdate = true
        LocationManager.shared.isFirstLocation = true

        setLocationStatusOnfirebase()
        
        if self.timer == nil {

            self.userDistance = 30 // by default value for distance
            if let serverDistance = getDefaultSettings()?.trkDistance{
                if serverDistance != "" {
                    self.userDistance = Int(serverDistance)!
                }
            }

            self.trkDuration = 40 // by default value for duration   //for 80% accuracy
            if let serverDuration = getDefaultSettings()?.trkDuration{
                if serverDuration != ""{
                    trkDuration = Int(serverDuration)!
                }
            }
            
                //===================================================================================================================
                //self.timer = Timer.scheduledTimer(timeInterval: Double(trkDuration)!*60 , target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                
                self.bgTask =  BackgroundTaskManager.shared()
                self.bgTask?.beginNewBackgroundTask()
                self.timer = Timer.scheduledTimer(timeInterval: Double(trkDuration) , target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            }
        
        APP_Delegate.stopLocationTask =  DispatchWorkItem {
            self.stopTracking()
            self.stopStatusTracking()
            APP_Delegate.stopLocationTask?.cancel()
            APP_Delegate.stopLocationTask = nil
        }

         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(gpsStopTimeInterval), execute: APP_Delegate.stopLocationTask!)
        
    }
    
    //========================================================
    // MARK:- Notification Registration
    //========================================================
    func setNotificationCentreForlocation() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.enterInBackgroundMode(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.enterInForegroundMode(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.enterInWillTerminate(notification:)), name: UIApplication.willTerminateNotification, object: nil)

        
    }
    
    
    func removeNotificationCentreForlocation() -> Void {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
    
    //========================================================
    // MARK:- Background enter and Foreground method
    //========================================================
    @objc func enterInBackgroundMode(notification: NSNotification) {
        isUpdate = true
        isBackgroundMode = true
        locationManager.startUpdatingLocation()
    }
    
    @objc func enterInForegroundMode(notification: NSNotification) {
        isBackgroundMode = false
        locationManager.stopUpdatingLocation()
    }
    
    @objc func enterInWillTerminate(notification: NSNotification) {
        sendAllLocationOnServerAndRemoveHistory()
    }
    
    
    //========================================================
    // MARK:- Start and Stop Tracking
    //========================================================
    func startTracking() -> Void {
        // isUpdate = true
        locationManager.startUpdatingLocation()
    }
    
    func startStatusLocTracking() -> Void {
        if statusTimer == nil {
            statusTimer = Timer.scheduledTimer(timeInterval: Double(trkDuration) , target: self, selector: #selector(statusTimerAction), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    func stopTracking() -> Void {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        bgTask?.endAllBackgroundTasks()
        bgTask = nil
        
        locationManager.stopUpdatingLocation()
        isGPSenable = false
        
        sendAllLocationOnServerAndRemoveHistory()
        
        self.removeNotificationCentreForlocation()
    }
    
    func stopStatusTracking() -> Void {
        if statusTimer != nil {
            statusTimer?.invalidate()
            statusTimer = nil
        }
        
        if isGPSenable == false {
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    //========================================================
    // MARK:- Check if location is available
    //========================================================
    
    func isCheckLocation () -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default :
                return false
            }
        }
        else {
            return false
        }
    }
    
    
    
    func isHaveLocation() {
        
        let isFirst =  UserDefaults.standard.value(forKey: "isFirstLogin") as! Bool
        
        if isFirst {
            UserDefaults.standard.set(false, forKey: "isFirstLogin")
        }else{
            return
        }
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                
                let appName =  Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String   // [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
                
                let mess = AlertMessage.location_app_setting
                let newString = mess.replacingOccurrences(of: EOT_VAR, with: appName)
                
                
                ShowAlert(title: LanguageKey.location_is_disabled, message: newString, controller: windowController, cancelButton: LanguageKey.settings as NSString, okButton: LanguageKey.ok as NSString, style: .alert, callback: { (settings,Okay) in
                    
                    if settings {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            // If general location settings are enabled then open location settings for the app
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                } )
                
                // To enable location in EyeOnTask app setting
                //return false
                
                break
            default :
              //  print("Access")
                //locationManager.startUpdatingLocation()
                // return true
                break
            }
        } else {
            
            ShowAlert(title: LanguageKey.location_is_disabled, message: LanguageKey.location_main_setting, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {(_ , _) in })
            isFirstLogin = false
            
            // return false
        }
    }
    
    
    func updateCurrentLocation(updateCallback : @escaping (Bool) -> Void) {
        callback = updateCallback
        locationManager.startUpdatingLocation()
    }
    
    
    //========================================================
    // MARK:- Other methods
    //========================================================
    @objc func timerAction() {
        isUpdate = true
        locationManager.startUpdatingLocation()
    }
    
    @objc func statusTimerAction() {
        isStatus = true
        locationManager.startUpdatingLocation()
    }
    
    
    func sendMultipleLocationsOnServer(locations :[LocationObject]){
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.latLongData = locations
        DatabaseClass.shared.saveOffline(service: Service.postMultipleLocationUpdate, param: param)
    }
    
    
    func sendLocationOnServer(location : CLLocation , time : String) -> Void {
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.lat = String(location.coordinate.latitude)
        param.lng = String(location.coordinate.longitude)
        param.btryStatus =  batteryLevel
        param.dateTime = time
        DatabaseClass.shared.saveOffline(service: Service.getLocationUpdate, param: param)
    }
    
    
    func sendAllLocationOnServerAndRemoveHistory() -> Void {
        if locationHistory.count > 0 {
            self.sendMultipleLocationsOnServer(locations: locationHistory)
            locationHistory.removeAll()
        }
    }
    
    //========================================
    // MARK: - CoreLocation Delegate Methods
    //========================================
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        //print(error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
       // let location = locations.last
        if isStatus {
            isStatus = false
            let locationArray = locations as NSArray
            Currentloc = locationArray.lastObject as! CLLocation
            let coord = Currentloc.coordinate
            self.currentLattitude = String(coord.latitude)
            self.currentLongitude = String(coord.longitude)
            
            if self.callback != nil {
                self.callback!(true)
                self.callback = nil
            }
        }
        

        if self.isUpdate {
            self.isUpdate =  false
            
            let locationArray = locations as NSArray
            self.Currentloc = locationArray.lastObject as! CLLocation
            let coord = self.Currentloc.coordinate
            self.currentLattitude = String(coord.latitude)
            self.currentLongitude = String(coord.longitude)
          
            
            if (self.isGPSenable) {
                
                let batteryStatus = batteryLevel //get battery status
                let CurrentDateTime = CurrentDateTimeForLocation()
                speed = Currentloc.speed * 3.6  // speed in meters/second to km/hour
                let speedCheck = calculateSpeedInKMPH()
                
                if isFirstLocation == true {
                    isFirstLocation = false
                    // Note -  If user run app first time to send current location  lattitude and longitude but user are simultaneously kill the app and run app so lat long send the server all time but backend side avoide the lat long
                    self.oldLocation = self.Currentloc
                    
//                    // add info in json file
//                    let tempString = "First Location:-  \(Currentloc.coordinate.latitude),\(Currentloc.coordinate.longitude) speed:\(speed)km/h  \(CurrentDateTime)  Battery:\(batteryStatus)\n"
//                    makeJson(location: tempString)
                    
                    
                    let location = LocationObject(battery: batteryStatus, dateTime: CurrentDateTime, lat: Currentloc.coordinate.latitude, lng: Currentloc.coordinate.longitude)
                    self.sendMultipleLocationsOnServer(locations: [location])
                   // self.sendLocationOnServer(location: Currentloc, time: CurrentDateTime)
                    return
                }
                
                
               
               
                let distance = self.Currentloc.distance(from: self.oldLocation)
                
                
                if ( Int(distance) > self.userDistance && speedCheck == true) {
                    
                    //  locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                    self.oldLocation = self.Currentloc
                    calculateTime = 0
                    
//                    // add info in json file
//                    let tempString = "Location\(locationHistory.count) - \(Currentloc.coordinate.latitude),\(Currentloc.coordinate.longitude)speed:\(speed)km/h accuracyLevel : \(Currentloc.horizontalAccuracy)  \(CurrentDateTime)  Battery:\(batteryStatus)\n"
//                    makeJson(location: tempString)
                    
                    
                    // Add location in arry
                    let location = LocationObject(battery: batteryStatus, dateTime: CurrentDateTime, lat: Currentloc.coordinate.latitude, lng: Currentloc.coordinate.longitude)
                    locationHistory.append(location)
                    
                    //Send location on server
                    if locationHistory.count > 2 {
                        self.sendMultipleLocationsOnServer(locations: locationHistory) // send 2 nearest location on server
                        locationHistory.removeAll()
                    }
 
                } else {
                    
                    // this block will call when got location under 30meter and speed less than 4km/h
                    
                    // locationManager.desiredAccuracy = kCLLocationAccuracyBest // for change location Accuracy
                    calculateTime = calculateTime + Int(trkDuration)
                    if calculateTime >= 600 {
                        
                        // this block will call when got location under 30meter and speed less than 4km/h upto 10minuts
                        calculateTime = 0
//                        let tempString = "Break time .... - \(Currentloc.coordinate.latitude),\(Currentloc.coordinate.longitude),speed :\(speed)km/h  \(CurrentDateTime) accuracyLevel : \(Currentloc.horizontalAccuracy)  Battery:\(batteryStatus)\n"
//                        makeJson(location: tempString)
                        
                        sendAllLocationOnServerAndRemoveHistory()
                    }
                    
                     // add info in json file
                   // msg(message: "speed:\(speed) accuracyLevel : \(Currentloc.horizontalAccuracy)", title: "LocationManager")

                }
            }
            
            
            // if app in foreground, location manager will stop capture location every timeinterval.
            // if app in background, location manager will not stop location capture because location manager will not update location in background.
            if self.isBackgroundMode == false {
                self.locationManager.stopUpdatingLocation()
            }

        }
    }
    
//=================================================================================================================================//
    func calculateSpeedInKMPH() -> Bool {

        if (speed > 0 && speed < 4) { // speed range 0-4km/h, send GPS status 'Walk' but not send location on server
            setGpsStatusOnFirebase(status: .Walk)
            return false
        }else if (speed > 4 && speed < 10) {  // speed range 4-104km/h, send GPS status 'Walk' and send location on server
            setGpsStatusOnFirebase(status: .Walk)
            return true
        }else if (10.0 < speed) { // speed range 10km/h and above, send GPS status 'Travel' and send location on server
            setGpsStatusOnFirebase(status: .Travel)
            return true
        } else { // speed range 0km/h and below, send GPS status 'Still' and not send location on server
            setGpsStatusOnFirebase(status: .Still)
            return false
        }
    }
   
//=================================================================================================================================//
    //MARK:- OTHER METHODS
    
    func msg(message: String, title: String = "")
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertView.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))

        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    
    
//    func makeJson(location : String ) -> Void {
//        saveToJsonFile(dict: location)
//    }
//
//    
//    func saveToJsonFile(dict : String) {
//        // Get the url of Persons.json in document directory
//        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let fileUrl = documentDirectoryUrl.appendingPathComponent("location.json")
//
//        // Transform array into data and save it into file
//
//        do {
//            if FileManager.default.fileExists(atPath: fileUrl.path) {
//                let fileHandle = try FileHandle(forWritingTo: fileUrl)
//                fileHandle.seekToEndOfFile()
//                fileHandle.write(dict.data(using: .utf8)!)
//                fileHandle.closeFile()
//            }else {
//                let string = "Distance: 30metre,   Time Interval - 40Sec   Speed > 4km/h \n\n\(dict)"
//                try string.write(to: fileUrl, atomically: true, encoding: .utf8)
//            }
//        } catch {
//            print(error)
//        }
//
//    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        if gpsStatusVariable == GPSstatus.Admin_Permission_Issue ||  gpsStatusVariable == GPSstatus.Time_Expire {
            return
        }
        
        
        switch status {
        case .notDetermined:
            isPermissionAsked = true
            setGpsStatusOnFirebase(status: GPSstatus.Still)
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            setGpsStatusOnFirebase(status: GPSstatus.Still)
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            setGpsStatusOnFirebase(status: GPSstatus.Still)
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            setGpsStatusOnFirebase(status: GPSstatus.GPS_OFF) // setting this status on firebase
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            setLocationStatusOnfirebase()
             // setting this status on firebase
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    func setLocationStatusOnfirebase() -> Void {
        if !CLLocationManager.locationServicesEnabled() {
            setGpsStatusOnFirebase(status: GPSstatus.GPS_OFF)
        }else {
            setGpsStatusOnFirebase(status: GPSstatus.DeviceGPS_Permission_Issue)
        }
    }
    
    
}



