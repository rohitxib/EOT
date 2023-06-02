    //
    //  WorkHistry.swift
    //  EyeOnTask
    //
    //  Created by Jugal Shaktawat on 22/03/21.
    //  Copyright © 2021 Hemant. All rights reserved.
    //
    
    import UIKit
    
    class WorkHistry: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
        
        @IBOutlet weak var lblNotFound: UILabel!
        @IBOutlet weak var lblImg: UILabel!
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var sigment: UISegmentedControl!
        
        var refreshControl = UIRefreshControl()
        var selectedAuditID : String? = nil
        var allEqpHistry = [AuditHWorkHistry]()
        var objOFWorkHistry : ClientList?
        var allAppoinmentHsry = [AppoinmentHWorkHistry]()
        var allJobHistry = [JobHWorkHistry]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setLocalization()
            
            self.lblImg.isHidden = true
            self.lblNotFound.isHidden = true
            refreshControl.attributedTitle = NSAttributedString(string: " ")
            refreshControl.addTarget(self, action: #selector(refreshControllerMethod), for: UIControl.Event.valueChanged)
            tableView.addSubview(refreshControl) // not required when using UITableViewController
            //  createSection()
            getAdminJobList()
            
            //  getEquAuditScheduleService()
            
            // getAppointmentAdminList()
            ///////////////
           // self.parent?.title = "Work Histry"
            let image = UIImage(named:"")
            //        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
            
            if let button = self.parent?.navigationItem.rightBarButtonItem {
                button.isEnabled = true
                button.tintColor = UIColor.white
                self.parent?.navigationItem.rightBarButtonItem?.target = self
                self.parent?.navigationItem.rightBarButtonItem?.action = #selector(addTapped)
                self.parent?.navigationItem.rightBarButtonItem?.image = image
            }else{
                self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
            }
            
            //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
            //               swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            //               self.view.addGestureRecognizer(swipeRight)
            //
            /////////////
            //self.navigationItem.title = "Work Histry"
            // Do any additional setup after loading the view.
        }
        
        func setLocalization() -> Void {
            
            self.navigationItem.title = LanguageKey.work_history
            sigment.setTitle(LanguageKey.job, forSegmentAt: 0)
            sigment.setTitle(LanguageKey.audit_nav, forSegmentAt: 1)
            sigment.setTitle(LanguageKey.appointment, forSegmentAt: 2)
        }
            
        override func viewWillAppear(_ animated: Bool) {
            
             setLocalization()
            
            //  getAdminJobList()
            
            //   getEquAuditScheduleService()
            
            //  getAppointmentAdminList()
            
            
            switch(sigment.selectedSegmentIndex)
            {
            case 0:
                //    self.tableView.reloadData()
                // self.tableVi()
                getAdminJobList()
              //  print("0")
                
                break
            case 1:
                //   self.tableView.reloadData()
                //  getEquAuditScheduleService()
               // print("1")
                
                break
            case 2:
                //    self.tableView.reloadData()
                //    getAppointmentAdminList()
               // print("2")
                
                break
                
            default:
                break
                
            }
            self.tableView.reloadData()
            
            
            self.parent?.title = LanguageKey.work_history
            let image = UIImage(named:"")
            //        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
            
            if let button = self.parent?.navigationItem.rightBarButtonItem {
                button.isEnabled = true
                button.tintColor = UIColor.white
                self.parent?.navigationItem.rightBarButtonItem?.target = self
                self.parent?.navigationItem.rightBarButtonItem?.action = #selector(addTapped)
                self.parent?.navigationItem.rightBarButtonItem?.image = image
            }else{
                self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
            }
        }
        
        ////////////////
        //    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        //
        //         print("jugalTab")
        //          if gesture.direction == .right {
        //              if (self.tabBarController?.selectedIndex)! > 0 { // set your total tabs here
        //                  self.tabBarController?.selectedIndex  -= 1
        //              }
        //        }
        //    }
        
        @objc func addTapped() -> Void {
           // print("jugalTab")
            
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // print("jugalTab")
        }
        //////////////
        
        @IBAction func sigmentBtnAct(_ sender: Any) {
            
            switch(sigment.selectedSegmentIndex)
            {
            case 0:
                //    self.tableView.reloadData()
                // self.tableVi()
                getAdminJobList()
               // print("0")
                
                break
            case 1:
                //   self.tableView.reloadData()
                getEquAuditScheduleService()
              //  print("1")
                
                break
            case 2:
                //    self.tableView.reloadData()
                getAppointmentAdminList()
               // print("2")
                
                break
                
            default:
                break
                
            }
            self.tableView.reloadData()
        }
        
        
        //==========================
        // MARK:- Tableview methods
        //==========================
        
        //           func numberOfSections(in tableView: UITableView) -> Int {
        //               return self.allJobHistry.count
        //           }
        //
        //           func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //               let headerView = UIView()
        //               headerView.frame = CGRect(x: 0, y: 0, width: Int(self.tableView.frame.size.width), height: 30)
        //               headerView.backgroundColor = UIColor(red: 246.0/255.0, green: 242.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        //
        //               let headerLabel = UILabel(frame: CGRect(x: 14, y: 10, width:
        //                   headerView.bounds.size.width-20, height: 20))
        //               headerLabel.font = Font.ArimoBold(fontSize: 13.0)
        //               headerLabel.textColor = UIColor(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
        //
        //               let dict = self.allJobHistry[section]
        //
        ////               let firstKey = Array(dict.keys)[0]
        ////               let arr = firstKey.components(separatedBy: ",")
        ////               let att = changeColoreOFDate(main_string: firstKey, string_to_color: arr[0])
        ////
        ////               if(arr[0] == "Today" || arr[0] == "Yesterday" || arr[0] == "Tomorrow" ) {
        ////                   headerLabel.attributedText = att
        ////               }else{
        ////                   headerLabel.text = att.string
        ////               }
        //
        //
        //               headerLabel.textAlignment = .left;
        //
        //               DispatchQueue.main.async {
        //                   headerView.addSubview(headerLabel)
        //               }
        //
        //               //headerView.addSubview(headerLabel)
        //               return headerView
        //           }
        //
        
        //           func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //               return 30.0
        //           }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            
            
            return 103.0
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
            
            
            
            var cellToReturn = UITableViewCell()
            
            switch(sigment.selectedSegmentIndex)
            {
            case 0:
                
                return allJobHistry.count
                // self.tableVi()
                // getAdminJobList()
              //  print("0")
                
                break
            case 1:
                return allEqpHistry.count
              //  print("1")
                
                break
            case 2:
                return allAppoinmentHsry.count
              //  print("2")
                
                break
                
            default:
                break
                // return
            }
            
            //               if(self.allEqpHistry.count != 0){
            //                   let dict = self.allEqpHistry[section]
            //                   //  let firstKey = Array(dict.keys)[0] // or .first
            //                   //    let arr = dict[firstKey]
            //                   return allEqpHistry.count
            //               }else{
            //                   return 0
            //               }
            //
            //  return allEqpHistry.count + allJobHistry.count + allAppoinmentHsry.count
            return 50
            
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cellToReturn = UITableViewCell()
            switch(sigment.selectedSegmentIndex)
            {
            case 0:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
                cell.isUserInteractionEnabled = true
                let dict = self.allJobHistry[indexPath.section]
                
                var isSwitchOff = ""
                isSwitchOff =   UserDefaults.standard.value(forKey: "TokenOff") as? String ?? ""
                
                var adf = "Off"
                
                
                var adf1 = "On"
                
                if (isSwitchOff == "Off") {
                    
                    cell.selfLblhistry_H.constant = 0
                    
                }else{
                    cell.selfLblWorkHtry.text = dict.snm
                    cell.selfLblhistry_H.constant = 13
                }
                
                
                //  print(self.arrOfFilterDict1[indexPath.section])
                // let firstKey = Array(dict.keys)[0] // or .first
                //  let arr = dict[firstKey]
                let audit = allJobHistry[indexPath.row]
                
                // cell.imgEquipment.isHidden = true
                // cell.attchment_Audit.isHidden = true
                
                if selectedAuditID == audit.jobId {
                    cell.rightView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                    cell.leftBaseView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                }else{
                    cell.rightView.backgroundColor = UIColor.white
                    cell.leftBaseView.backgroundColor = UIColor.white
                }
                var someArray = [String]()
                
                //      if audit.equArray == someArray as NSObject {
                //       cell.imgEquipment.isHidden = true
                //           cell.equipment_Height_Audit.constant = 0
                //
                //               }else{
                //           cell.equipment_Height_Audit.constant = 14
                //           cell.imgEquipment.isHidden = false
                //           cell.imgEquipment.image =  UIImage.init(named: "equip")
                //       }
                
                //      if audit.attachCount == "0"  {
                //              cell.attchment_Audit.isHidden = true
                //
                //                              }else{
                //      if audit.attachCount == nil  {
                //              cell.attchment_Audit.isHidden = true
                //                              }else{
                //
                //              cell.attchment_Audit.isHidden = false
                //              cell.attchment_Audit.image =  UIImage.init(named: "icons8@-attech")
                //
                //                      }
                //
                //                  }
                //
                
                if let auditID = audit.jobId {
                    cell.name.text = "\(audit.label != nil ? audit.label! : "Apl\(auditID)" )"
                }
                cell.lblTitle.text = audit.title
                
                var address = ""
                if let adr = audit.adr {
                    if adr != "" {
                        address = "\(adr)"
                    }
                }
                
                
                if  address != "" {
                    cell.taskDescription.attributedText =  lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
                }else{
                    cell.taskDescription.text = ""
                }
                
                if audit.schdlStart != "" {
                    let tempTime = convertTimestampToDate(timeInterval: audit.schdlStart!)
                    cell.time.text = tempTime.0
                    cell.timeAMPM.text = tempTime.1
                    
                } else {
                    cell.time.text = ""
                    cell.timeAMPM.text = ""
                }
                
                
                //temp code // if status are nil ....
                
                if let statusValue = audit.status {
                    if statusValue != "" {
                        let status =
                            taskStatus(taskType: taskStatusType(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)!)     //taskStatus(taskType: taskStatusType(rawValue: Int(job.status! == "0" ? "1" : job.status!)!)!)
                        
                        if taskStatusType(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)! == taskStatusType.InProgress{
                            cell.status.text = status.0
                            cell.leftBaseView.backgroundColor = UIColor(red: 109.0/255.0, green: 209.0/255.0, blue: 32.0/255.0, alpha: 1.0)
                            cell.status.textColor = UIColor.white
                            cell.timeAMPM.textColor = UIColor.white
                            cell.time.textColor = UIColor.white
                            cell.statusImage.image  = UIImage.init(named: "inprogress_white")
                        }else{
                            
                            cell.status.text = status.0.replacingOccurrences(of: " Task", with: "")
                            cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                            cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                            cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                            cell.statusImage.image  = status.1
                        }
                    }else{
                        cell.status.text = ""
                        cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                        cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                        cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                        cell.statusImage.image  = nil
                    }
                }else{
                    cell.status.text = ""
                    cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                    cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                    cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                    cell.statusImage.image  = nil
                }
                
                
                if audit.prty != "0" {
                    let priorityDetail = taskPriorityImage(Priority: taskPriorities(rawValue: Int(audit.prty!)!)!)
                    cell.priorityImage.image = priorityDetail.1
                }
                
                
                //if user add job in OFFLINE mode and job not sync on the server
                let ladksj  = audit.jobId!.components(separatedBy: "-")
                if ladksj.count > 0 {
                    let tempId = ladksj[0]
                    if tempId == "Job" {
                        
                        cell.name.textColor = UIColor.lightGray
                        cell.lblTitle.textColor = UIColor.lightGray
                        cell.time.textColor = UIColor.lightGray
                        cell.timeAMPM.textColor = UIColor.lightGray
                        cell.status.textColor = UIColor.lightGray
                        cell.taskDescription.textColor = UIColor.red
                        cell.taskDescription.text = LanguageKey.audit_not_sync
                        cell.isUserInteractionEnabled = false
                    }else{
                        
                        if audit.status != "7"{
                            cell.name.textColor =  UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                            //cell.lblTitle.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                            cell.taskDescription.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                            cell.time.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                            cell.timeAMPM.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                            cell.status.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        }
                    }
                }
                
                return cell
                // self.tableVi()
                // getAdminJobList()
                print("0")
                
                break
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
                cell.isUserInteractionEnabled = true
                cell.priorityImage.isHidden = true
                
                
                let dict = self.allEqpHistry[indexPath.section]
                //  print(self.arrOfFilterDict1[indexPath.section])
                // let firstKey = Array(dict.keys)[0] // or .first
                //  let arr = dict[firstKey]
                let audit = allEqpHistry[indexPath.row]
                
                
                var isSwitchOff = ""
                isSwitchOff =   UserDefaults.standard.value(forKey: "TokenOff") as? String ?? ""
                
                var adf = "Off"
                
                
                var adf1 = "On"
                
                if (isSwitchOff == "Off") {
                    
                    cell.selfLblhistry_H.constant = 0
                    
                }else{
                    cell.selfLblWorkHtry.text = audit.snm
                    cell.selfLblhistry_H.constant = 13
                }
                // cell.imgEquipment.isHidden = true
                // cell.attchment_Audit.isHidden = true
                
                if selectedAuditID == audit.audId {
                    cell.rightView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                    cell.leftBaseView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                }else{
                    cell.rightView.backgroundColor = UIColor.white
                    cell.leftBaseView.backgroundColor = UIColor.white
                }
                var someArray = [String]()
                
                //      if audit.equArray == someArray as NSObject {
                //       cell.imgEquipment.isHidden = true
                //           cell.equipment_Height_Audit.constant = 0
                //
                //               }else{
                //           cell.equipment_Height_Audit.constant = 14
                //           cell.imgEquipment.isHidden = false
                //           cell.imgEquipment.image =  UIImage.init(named: "equip")
                //       }
                
                //      if audit.attachCount == "0"  {
                //              cell.attchment_Audit.isHidden = true
                //
                //                              }else{
                //      if audit.attachCount == nil  {
                //              cell.attchment_Audit.isHidden = true
                //                              }else{
                //
                //              cell.attchment_Audit.isHidden = false
                //              cell.attchment_Audit.image =  UIImage.init(named: "icons8@-attech")
                //
                //                      }
                //
                //                  }
                //
                
                if let auditID = audit.audId {
                    cell.name.text = "\(audit.label != nil ? audit.label! : "Apl\(auditID)" )"
                }
                
                
                var address = ""
                if let adr = audit.adr {
                    if adr != "" {
                        address = "\(adr)"
                    }
                }
                
                
                if  address != "" {
                    cell.taskDescription.attributedText =  lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
                }else{
                    cell.taskDescription.text = ""
                }
                
                if audit.schdlStart != "" {
                    let tempTime = convertTimestampToDate(timeInterval: audit.schdlStart!)
                    cell.time.text = tempTime.0
                    cell.timeAMPM.text = tempTime.1
                    
                } else {
                    cell.time.text = ""
                    cell.timeAMPM.text = ""
                }
                
                
                //temp code // if status are nil ....
                
                if let statusValue = audit.status {
                    if statusValue != "" {
                        let status =
                            taskStatus(taskType: taskStatusType(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)!)     //taskStatus(taskType: taskStatusType(rawValue: Int(job.status! == "0" ? "1" : job.status!)!)!)
                        
                        if taskStatusType(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)! == taskStatusType.InProgress{
                            cell.status.text = status.0
                            cell.leftBaseView.backgroundColor = UIColor(red: 109.0/255.0, green: 209.0/255.0, blue: 32.0/255.0, alpha: 1.0)
                            cell.status.textColor = UIColor.white
                            cell.timeAMPM.textColor = UIColor.white
                            cell.time.textColor = UIColor.white
                            cell.statusImage.image  = UIImage.init(named: "inprogress_white")
                        }else{
                            
                            cell.status.text = status.0.replacingOccurrences(of: " Task", with: "")
                            cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                            cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                            cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                            cell.statusImage.image  = status.1
                        }
                    }else{
                        cell.status.text = ""
                        cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                        cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                        cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                        cell.statusImage.image  = nil
                    }
                }else{
                    cell.status.text = ""
                    cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                    cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                    cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                    cell.statusImage.image  = nil
                }
                
                
                
                
                
                //if user add job in OFFLINE mode and job not sync on the server
                let ladksj  = audit.audId!.components(separatedBy: "-")
                if ladksj.count > 0 {
                    let tempId = ladksj[0]
                    if tempId == "Job" {
                        
                        cell.name.textColor = UIColor.lightGray
                        //cell.lblTitle.textColor = UIColor.lightGray
                        cell.time.textColor = UIColor.lightGray
                        cell.timeAMPM.textColor = UIColor.lightGray
                        cell.status.textColor = UIColor.lightGray
                        cell.taskDescription.textColor = UIColor.red
                        cell.taskDescription.text = LanguageKey.audit_not_sync
                        cell.isUserInteractionEnabled = false
                    }else{
                        
                        if audit.status != "7"{
                            cell.name.textColor =  UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                            //cell.lblTitle.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                            cell.taskDescription.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                            cell.time.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                            cell.timeAMPM.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                            cell.status.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        }
                    }
                }
                
                return cell
                print("1")
                
                break
            case 2:
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
                cell.isUserInteractionEnabled = true
                
                var isSwitchOff = ""
                isSwitchOff =   UserDefaults.standard.value(forKey: "TokenOff") as? String ?? ""
                
                var adf = "Off"
                
                
                var adf1 = "On"
                
                if (isSwitchOff == "Off") {
                    
                    cell.selfLblhistry_H.constant = 0
                    
                }else{
                    //  cell.selfLblWorkHtry.text = dict.cnm
                    cell.selfLblhistry_H.constant = 0
                }
                cell.priorityImage.isHidden = true
                let dict = self.allAppoinmentHsry[indexPath.section]
                //  print(self.arrOfFilterDict1[indexPath.section])
                // let firstKey = Array(dict.keys)[0] // or .first
                //  let arr = dict[firstKey]
                let audit = allAppoinmentHsry[indexPath.row]
                
                // cell.imgEquipment.isHidden = true
                // cell.attchment_Audit.isHidden = true
                
                if selectedAuditID == audit.appId {
                    cell.rightView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                    cell.leftBaseView.backgroundColor = UIColor.init(red: 236.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                }else{
                    cell.rightView.backgroundColor = UIColor.white
                    cell.leftBaseView.backgroundColor = UIColor.white
                }
                var someArray = [String]()
                
                //      if audit.equArray == someArray as NSObject {
                //       cell.imgEquipment.isHidden = true
                //           cell.equipment_Height_Audit.constant = 0
                //
                //               }else{
                //           cell.equipment_Height_Audit.constant = 14
                //           cell.imgEquipment.isHidden = false
                //           cell.imgEquipment.image =  UIImage.init(named: "equip")
                //       }
                
                //      if audit.attachCount == "0"  {
                //              cell.attchment_Audit.isHidden = true
                //
                //                              }else{
                //      if audit.attachCount == nil  {
                //              cell.attchment_Audit.isHidden = true
                //                              }else{
                //
                //              cell.attchment_Audit.isHidden = false
                //              cell.attchment_Audit.image =  UIImage.init(named: "icons8@-attech")
                //
                //                      }
                //
                //                  }
                //
                
                if let auditID = audit.appId {
                    cell.name.text = "\(audit.label != nil ? audit.label! : "Apl\(auditID)" )"
                }
                
                
                var address = ""
                if let adr = audit.adr {
                    if adr != "" {
                        address = "\(adr)"
                    }
                }
                
                
                if  address != "" {
                    cell.taskDescription.attributedText =  lineSpacing(string: address.capitalizingFirstLetter(), lineSpacing: 5.0)
                }else{
                    cell.taskDescription.text = ""
                }
                
                if audit.schdlStart != "" {
                    let tempTime = convertTimestampToDate(timeInterval: audit.schdlStart!)
                    cell.time.text = tempTime.0
                    cell.timeAMPM.text = tempTime.1
                    
                } else {
                    cell.time.text = ""
                    cell.timeAMPM.text = ""
                }
                
                
                //temp code // if status are nil ....
                
                if let statusValue = audit.status {
                    if statusValue != "" {
                        let status =
                            taskStatus(taskType: taskStatusType(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)!)     //taskStatus(taskType: taskStatusType(rawValue: Int(job.status! == "0" ? "1" : job.status!)!)!)
                        
                        if taskStatusType(rawValue: Int(statusValue == "0" ? "1" : statusValue)!)! == taskStatusType.InProgress{
                            cell.status.text = status.0
                            cell.leftBaseView.backgroundColor = UIColor(red: 109.0/255.0, green: 209.0/255.0, blue: 32.0/255.0, alpha: 1.0)
                            cell.status.textColor = UIColor.white
                            cell.timeAMPM.textColor = UIColor.white
                            cell.time.textColor = UIColor.white
                            cell.statusImage.image  = UIImage.init(named: "inprogress_white")
                        }else{
                            
                            cell.status.text = status.0.replacingOccurrences(of: " Task", with: "")
                            cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                            cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                            cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                            cell.statusImage.image  = status.1
                        }
                    }else{
                        cell.status.text = ""
                        cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                        cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                        cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                        cell.statusImage.image  = nil
                    }
                }else{
                    cell.status.text = ""
                    cell.status.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                    cell.timeAMPM.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.6)
                    cell.time.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 0.7)
                    cell.statusImage.image  = nil
                }
                
                
                
                
                
                //if user add job in OFFLINE mode and job not sync on the server
                let ladksj  = audit.appId!.components(separatedBy: "-")
                if ladksj.count > 0 {
                    let tempId = ladksj[0]
                    if tempId == "Job" {
                        
                        cell.name.textColor = UIColor.lightGray
                        //cell.lblTitle.textColor = UIColor.lightGray
                        cell.time.textColor = UIColor.lightGray
                        cell.timeAMPM.textColor = UIColor.lightGray
                        cell.status.textColor = UIColor.lightGray
                        cell.taskDescription.textColor = UIColor.red
                        cell.taskDescription.text = LanguageKey.audit_not_sync
                        cell.isUserInteractionEnabled = false
                    }else{
                        
                        if audit.status != "7"{
                            cell.name.textColor =  UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                            //cell.lblTitle.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                            cell.taskDescription.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                            cell.time.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                            cell.timeAMPM.textColor = UIColor.init(red: 140.0/255.0, green: 146.0/255.0, blue: 147.0/255.0, alpha: 1.0)
                            cell.status.textColor = UIColor.init(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                        }
                    }
                }
                
                return cell
                
               // print("2")
                
                break
                
            default:
                break
                // return
            }
            
            //////
            return cellToReturn
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            switch(sigment.selectedSegmentIndex)
            {
            case 0:
                
                let storyboard: UIStoryboard = UIStoryboard(name: "MainClient", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "JobDetailCltHstry") as! JobDetailCltHstry
                vc.jobDetailHstry = allJobHistry[indexPath.row]
                // vc.auditDetail = allEqpHistry
                // vc.barcodeString = barcodeString
                //  self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
               // print("0")
                
                break
            case 1:
                
                let storyboard: UIStoryboard = UIStoryboard(name: "MainClient", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AuditDetailCltHtry") as! AuditDetailCltHtry
                vc.auditDetailHstry = allEqpHistry[indexPath.row]
                // vc.auditDetail = allEqpHistry
                // vc.barcodeString = barcodeString
                //  self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
              //  print("1")
                
                break
            case 2:
                
                let storyboard: UIStoryboard = UIStoryboard(name: "MainClient", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AppoinmentDetailCltHstry") as! AppoinmentDetailCltHstry
                vc.allAppoinmentDetailHstry = allAppoinmentHsry[indexPath.row]
                // vc.auditDetail = allEqpHistry
                // vc.barcodeString = barcodeString
                //  self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
                
               // print("2")
                
                break
                
            default:
                break
                
            }
            
        }
        
        //=====================================
        // MARK:- SECTIONS for JOBLIST
        //=====================================
        
        func createSection(){
            
            
            var arrOFData = [AuditHWorkHistry]()
            var filterDict = [String : [AuditHWorkHistry]]()
            var LatestFilterDict  = [[String : [AuditHWorkHistry]]]()
            
            var currentDate = ""
            
            //  self.arrOFUserData1 = self.arrOFUserData1.sorted(by: { ($0.createDate ?? "") > ($1.createDate ?? "") })
            self.allEqpHistry = self.allEqpHistry.sorted(by: { ($0.schdlStart ?? "") > ($1.schdlStart ?? "") })
            for  objOfUserData in self.allEqpHistry{
                let strDate = dayDifference(unixTimestamp: objOfUserData.createDate ?? "")
                
                if(LatestFilterDict.count > 0){
                    
                    // Below is new change implemented by Hemant
                    if currentDate == strDate {
                        var dictObj = LatestFilterDict.last
                        dictObj![strDate]?.append(objOfUserData)
                        LatestFilterDict[LatestFilterDict.count-1] = dictObj!
                    }else{
                        currentDate = strDate
                        arrOFData.removeAll()
                        filterDict.removeAll()
                        arrOFData.append(objOfUserData)
                        filterDict[strDate] = arrOFData
                        LatestFilterDict.append(filterDict)
                    }
                }else{
                    currentDate = strDate
                    arrOFData.append(objOfUserData)
                    filterDict[strDate] = arrOFData
                    LatestFilterDict.append(filterDict)
                }
            }
            
            DispatchQueue.main.async{
                // self.allEqpHistry = LatestFilterDict
                self.tableView.reloadData()
                //self.hideloader()
            }
        }
        
        //==================================/
        // MARK:- Equipement getJobListSimpleView methods
        //==================================
        func getEquAuditScheduleService(){
            
            if !isHaveNetowork() {
                
                killLoader()
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                
                return
            }
            
            showLoader()
            
            // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getEquipmentList) as? String
            let param = Params()
            //{"index":0,"limit":10,"search":"","searchType":"0","srtType":"asc","dtf":"","dtt":"","cltId":"10118"
            //  param.siteId = equipments?.equId
            param.limit = "10"
            param.index = "0"
            param.search = ""
            //        param.searchType = "10"
            //        param.srtType = "0"
            //        param.dtf = ""
            param.cltId = objOFWorkHistry?.cltId
            serverCommunicator(url: Service.getAuditAdminList, param: param.toDictionary) { (response, success) in
                
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                
                
                if(success){
                    let decoder = JSONDecoder()
                    
                    if let decodedData = try? decoder.decode(WorkHistryRes.self, from: response as! Data) {
                        if decodedData.success == true{
                            killLoader()
                            if decodedData.data!.count > 0 {
                                self.allEqpHistry = decodedData.data as! [AuditHWorkHistry]//[[String : [AllEquipment]]]                                                        }
                                
                                DispatchQueue.main.async {
                                
                                    self.tableView.reloadData()
                                    self.tableView.isHidden = false
                                    
                                    self.lblImg.isHidden = true
                                    self.lblNotFound.isHidden = true
                                    //                                //
                                    //                                  //  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                    //
                                    killLoader()
                                }
                            }else{
                                DispatchQueue.main.async {
                                    self.lblNotFound.text = LanguageKey.audit_not_found
                                    self.tableView.isHidden = true
                                    self.lblImg.isHidden = false
                                    self.lblNotFound.isHidden = false
                                    self.tableView.reloadData()
                                }
                        
                                killLoader()
                            }
                        }else{
                            killLoader()
                        }
                    }else{
                        killLoader()
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                            
                            if cancel {
                                showLoader()
                                //  self.getAdminEquipementList()
                            }
                        })
                    }
                }else{
                    killLoader()
                    ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                        if cancelButton {
                            showLoader()
                            // self.getAdminEquipementList()
                        }
                    })
                }
            }
        }
        
        
        //==================================/
        // MARK:- Equipement getAdminJobList methods
        //==================================
        func getAdminJobList(){
            
            if !isHaveNetowork() {
                
                killLoader()
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                
                return
            }
            
            showLoader()
            
            // let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getEquipmentList) as? String
            let param = Params()
            //{"limit":10,"index":0,"search":"","searchType":"0","srtType":"asc","dtf":"","dtt":"","jtId":"","cltId":"10118","isFilterBy":"1","apiCallFrom":"1"}:
            
           // {"apiCallFrom":"1","cltId":"5877","dtf":"","dtt":"","index":0,"isFilterBy":"1","jtId":"","limit":120,"search":"","searchType":"0","srtType":"asc"}
            param.cltId = objOFWorkHistry?.cltId
            param.limit = "10"
            param.index = "0"
            param.search = ""
            param.apiCallFrom = "1"
            param.dtf = ""
            param.dtt = ""
            param.isFilterBy = "1"
            param.jtId = nil
            param.searchType = "0"
            param.srtType = "asc"
            
           
            serverCommunicator(url: Service.getAdminJobList, param: param.toDictionary) { (response, success) in
                
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                
                
                if(success){
                    let decoder = JSONDecoder()
                    
                    if let decodedData = try? decoder.decode(WorkHistryJobRes.self, from: response as! Data) {
                        if decodedData.success == true{
                            killLoader()
                            if decodedData.data!.count > 0 {
                                self.allJobHistry = decodedData.data as! [JobHWorkHistry]//[[String : [AllEquipment]]]                                                        }
                                
                                DispatchQueue.main.async {
                                 
                                    self.tableView.reloadData()
                                    self.tableView.isHidden = false
                                    
                                    self.lblImg.isHidden = true
                                    self.lblNotFound.isHidden = true
                                    //                                //
                                    //                                  //  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                    //
                                    killLoader()
                                }
                            }else{
                                
                                DispatchQueue.main.async {
                                    self.lblNotFound.text = LanguageKey.err_no_jobs_found
                                    self.tableView.isHidden = true
                                    self.lblImg.isHidden = false
                                    self.lblNotFound.isHidden = false
                                    self.tableView.reloadData()
                                    
                                }
                         
                                killLoader()
                            }
                        }else{
                            killLoader()
                        }
                    }else{
                        killLoader()
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                            
                            if cancel {
                                showLoader()
                                //  self.getAdminEquipementList()
                            }
                        })
                    }
                }else{
                    killLoader()
                    ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                        if cancelButton {
                            showLoader()
                            // self.getAdminEquipementList()
                        }
                    })
                }
            }
        }
        
        @objc func refreshControllerMethod() {
            //     //   getEquAuditScheduleService()
            //                  getAdminJobList()
            //                      getAppointmentAdminList()
            
        }
        
        //==================================
        // MARK:- Equipement getAppointmentAdminList methods
        //==================================
        func getAppointmentAdminList(){
            
            if !isHaveNetowork() {
                
                killLoader()
                ShowError(message: AlertMessage.networkIssue, controller: windowController)
                
                return
            }
            
            showLoader()
            
            //{"index":0,"limit":10,"search":"","searchType":"0","srtType":"asc","dtf":"","dtt":"","cltId":"11082"}
            let param = Params()
            
            param.cltId = objOFWorkHistry?.cltId
            param.limit = "10"
            param.index = "0"
            param.search = ""
            
            // param.searchType = ""
            //   param.srtType = "10"
            // param.dtf = "0"
            // param.jtId = ""
            //param.isFilterBy = "0"
            // param.apiCallFrom = ""
            
            serverCommunicator(url: Service.getAppointmentAdminList, param: param.toDictionary) { (response, success) in
                
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                
                if(success){
                    let decoder = JSONDecoder()
                    
                    if let decodedData = try? decoder.decode(WorkHistryAppoinmentRes.self, from: response as! Data) {
                        if decodedData.success == true{
                            killLoader()
                            if decodedData.data!.count > 0 {
                                self.allAppoinmentHsry = decodedData.data as! [AppoinmentHWorkHistry]
                                
                                DispatchQueue.main.async {
                    
                                    self.tableView.reloadData()
                                    self.tableView.isHidden = false
                                    self.lblImg.isHidden = true
                                    self.lblNotFound.isHidden = true
                                    //                                //
                                    //                                  //  self.lblEqListNo.text! = "\(LanguageKey.list_item) \(String(self.equipments.count))"
                                    //
                                    killLoader()
                                }
                            }else{
                                
                                DispatchQueue.main.async {
                                    self.lblNotFound.text = LanguageKey.no_appointment_found
                                    self.tableView.isHidden = true
                                    self.lblImg.isHidden = false
                                    self.lblNotFound.isHidden = false
                                    self.tableView.reloadData()
                                }
                       
                                killLoader()
                            }
                        }else{
                            killLoader()
                        }
                    }else{
                        killLoader()
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {(cancel,done) in
                            
                            if cancel {
                                showLoader()
                                //  self.getAdminEquipementList()
                            }
                        })
                    }
                }else{
                    killLoader()
                    ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                        if cancelButton {
                            showLoader()
                            // self.getAdminEquipementList()
                        }
                    })
                }
            }
        }
        
        
        
    }
    
