//
//  AddRecurVC.swift
//  EyeOnTask
//
//  Created by Altab on 04/03/21.
//  Copyright © 2021 Dharmendra. All rights reserved.
//

import UIKit

protocol DailyRecurProtocol {
    func dailyRecurData(recurData:String?,recurType:String?,recurMsg:String?,daily:String)
}
protocol MonthlyRecurProtocol {
    func monthlyRecurData(recurData:String?,recurType:String?,recurMsg:String?,monthly:String)
}
protocol WeeklyRecurProtocol {
    func weeklyRecurData(recurData:String?,recurType:String?,recurMsg:String?,weekly:String,recurDays:String?)
}

class AddRecurVC: UIViewController,OptionViewDelegate {
    
  
  
struct WeekDay {
        let title: String
        var isSelected = false
        var id:String
    }
    
    
    // var WeekDays = ["Monday","Tuesday","Wednesday","Thuesday","Friday","Saturday","Sunday"]
     let weekdays = [
         WeekDay(title: LanguageKey.check_mon, isSelected: true,id: "1"),
         WeekDay(title: LanguageKey.check_tues, isSelected: true,id: "2"),
         WeekDay(title: LanguageKey.check_wedns, isSelected: true,id: "3"),
         WeekDay(title: LanguageKey.check_thurs, isSelected: true,id: "4"),
         WeekDay(title: LanguageKey.check_friday, isSelected: true,id: "5"),
         WeekDay(title: LanguageKey.check_satur, isSelected: true,id: "6"),
         WeekDay(title: LanguageKey.check_sun, isSelected: true,id: "7")
     ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var firstDailyView: UIView!
    @IBOutlet weak var secondWeeklyView: UIView!
    @IBOutlet weak var thirdMonthView: UIView!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var cancleBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var FVXFV: NSLayoutConstraint!
   
    @IBOutlet weak var firstView_H: NSLayoutConstraint!
    //    @IBOutlet weak var dailyContainerView: firstViewVC!
    //    @IBOutlet weak var weeklyContainerView: UIView!
    //    @IBOutlet weak var monthlyContainerView: UIView!
    
    // for DailyView IB Outlets
    // ==================================//
    // MARK:- DailyView IB Outlets
    // ==================================//
    
    @IBOutlet weak var lblDailyDays: UILabel!
    @IBOutlet weak var lblEveryDay: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblEvery: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var txtFieldDays: UITextField!
    @IBOutlet weak var btnWeedaySelect: UIButton!
    
    // ==================================//
    // MARK:- Weekly View IB outlets
    // ==================================//
    @IBOutlet weak var btnSelectWeekly: UIButton!
    @IBOutlet weak var lblWeeklyEvery: UILabel!
    @IBOutlet weak var lblWeeklyDays: UILabel!
    @IBOutlet weak var txtWeeklyField: UITextField!
    @IBOutlet weak var lblMonday: UILabel!
    @IBOutlet weak var lblTuesday: UILabel!
    @IBOutlet weak var lblWednesday: UILabel!
    @IBOutlet weak var lblThuresday: UILabel!
    @IBOutlet weak var lblFriday: UILabel!
    @IBOutlet weak var lblSaturday: UILabel!
    @IBOutlet weak var lblSunday: UILabel!
    @IBOutlet weak var btnMondayImage: UIButton!
    @IBOutlet weak var btnTuesdayImage: UIButton!
    @IBOutlet weak var btnWednesdayImage: UIButton!
    @IBOutlet weak var btnThuresdayImage: UIButton!
    @IBOutlet weak var btnFridayImage: UIButton!
    @IBOutlet weak var btnSaturdayImage: UIButton!
    @IBOutlet weak var btnSundayImage: UIButton!
    
    
    // ==================================//
    // MARK:- monthly View IB outlets
    // ==================================//
    @IBOutlet weak var btnDaySelect: UIButton!
    @IBOutlet weak var btnWeekSelect: UIButton!
    @IBOutlet weak var btnTheSeelect: UIButton!
    @IBOutlet weak var btnMonthSelect: UIButton!
    @IBOutlet weak var lblMonthDay: UILabel!
    @IBOutlet weak var txtFieldMonthDay: UITextField!
    @IBOutlet weak var lblMonthEvery: UILabel!
    @IBOutlet weak var txtMonthEvery: UITextField!
    @IBOutlet weak var lblMonths: UILabel!
    @IBOutlet weak var lblThe: UILabel!
    @IBOutlet weak var txtFieldWeek: UITextField!
    @IBOutlet weak var txtFieldDaySelect: UITextField!
    @IBOutlet weak var lblEveryMonths: UILabel!
    @IBOutlet weak var txtFieldMonths: UITextField!
    @IBOutlet weak var lblMonthss: UILabel!
    
    
    // ==================================//
    // MARK:- Common IB outlets
    // ==================================//
    @IBOutlet weak var lblRange: UILabel!
    @IBOutlet weak var lblStartingOn: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnnoEndDate: UIButton!
    @IBOutlet weak var lblNoEndDate: UILabel!
    @IBOutlet weak var btnAfterDate: UIButton!
    @IBOutlet weak var btnEndByDate: UIButton!
    @IBOutlet weak var lblAfterDate: UILabel!
    
    @IBOutlet weak var btnEndBy: UIButton!
    @IBOutlet weak var lblEndBy: UILabel!
    @IBOutlet weak var lblDateTimeSetByServer: UILabel!
    @IBOutlet weak var lblOccurrense: UILabel!
    @IBOutlet weak var txtFieldAfterDate: UITextField!
    @IBOutlet weak var lblMsgShowing: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    // property create by self
    var arrDaysCollection = [String]()
    let cellReuseIdentifier = "cell"
    var sltTxtField = UITextField()
    var sltDropDownTag : Int!
    var optionalVw : OptionalView?
    var buttonSwitched : Bool = false
    var arrDaysType : [daySelectType] = [.Monday, .Tuesday, .Wednesday, .Thuresday, .Friday, .Saturday, .Sunday]
    var arrWeekType : [weekSelectType] = [.First, .Second, .Third, .Fourth, .Last]
    

    var Monday = LanguageKey.check_mon//"monday"
    var Tuesday = LanguageKey.check_tues//"Tuesday"
    var Wednesday = LanguageKey.check_wedns//"Wednesday"
    var Thuresday = LanguageKey.check_thurs//"thursday"
    var Friday = LanguageKey.check_friday//"Friday"
    var Saturday = LanguageKey.check_satur//"Saturday"
    var Sunday = LanguageKey.check_sun//"Sunday"
    var newValueForTimes = 1
    var newValueForDays = 1
    
  
    var First = LanguageKey.first//"first"
    var Second = LanguageKey.second//"second"
    var Third = LanguageKey.third//"third"
    var Fourth = LanguageKey.forth//"fourth"
    var Last = LanguageKey.last//"last"
    var isbtnselectWeekly = false
    var isButtonSelectedEveryDay = true
    var isButtunSelectedWeekEnd = false
    var isAfterDateButtonSelected = false
    var isbtnMonthDaySelection = true
    var isWeekDayAndMonthSelection = false
    var isbtnNoEndDate = true
    var isEndByButton = false
    var daysDic = [String:Any]()
    var selectedRows:[Int] = []
    var isChecked = false
    var arrDaysCount = [Any]()
    var arrDaysId:[String] = []
    var addWeekly = 0
    var monthlyDaysAddMinus = 1
    var monthlyMonthsAddMinus = 1
    var monthlyDaysCollect = 1
    var monthlyWeekCollect  = 1
    var btnAddMinusMonth = 0
    var addJobDate:String = ""
    
    // for mode selection
    var dailyEveryDayMode:String = "1"
    var endDateMode:String = ""
    var endDate = ""
    var numberOfOcurrencesMode:String = ""
    var endRecurMode:String = "0"
    var aarOfDailyRecur = transVar()
    var dailyInterval:String = ""
    var dailyStart_date:String = ""
    var DailyEnd_date:String = ""
    var occurences = ""
    var endDates = ""
    var weeklyMode = "1"
    var monthlyMode = "1"
    var occurDay = "1"
    // Daily Recur outlets
    
    var  dailyRecurPattern = true
    var  weeklyRecurPattern = false
    var  monthlyRecurPattern = false
    var callBack: ((_ daily: Bool, _ weekly: Bool, _ monthly: Bool)-> Void)?
    var recuDataJsonString:String = ""
    var recuDaysJsonString:String = ""
    var recurMsg:String = ""
    var recurTyp:String = ""
    var delegateDailyRecur:DailyRecurProtocol?
    var delegateMonthlyRecur:MonthlyRecurProtocol?
    var delegateWeeklyRecur:WeeklyRecurProtocol?
    
    // Recur globel language variable
    var add_custom_recur = LanguageKey.add_custom_recur//"Are you sure want to add custom recur"
    var custom_recur_msg1 = LanguageKey.custom_recur_msg1 //"This job will repeat every"
    var starting_on = LanguageKey.starting_on//"day(s)starting on"
    var custom_recur_msg2 = LanguageKey.custom_recur_msg2//"and repeat"
    var custom_recur_msg3 = LanguageKey.custom_recur_msg3//"time(s) until"
    var infinity = LanguageKey.infinity//"indefinitely"
    var weeks_on =  LanguageKey.weeks_on//"week(s) on"
    var schel_start = LanguageKey.schel_start
    var daily_recur = LanguageKey.daily
    var weekly_recur = LanguageKey.weekly
    var monthly_recur = LanguageKey.monthly

    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.FVXFV.constant = 150
        //  tableView.register(RecurTableCell.self, forCellReuseIdentifier: "RecurCell")
        self.tableView.allowsMultipleSelectionDuringEditing = true
        segmentController.selectedSegmentIndex = 0
        self.firstDailyView.isHidden = false
        self.secondWeeklyView.isHidden = true
        self.thirdMonthView.isHidden = true
        //   back title remove and title name given
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
       self.navigationItem.title = LanguageKey.recuring_job
        
        // other methods
       // print(arrDaysCollection.count)
        setCurrentDate()
        txtFieldDaySelect.text = " "
        txtFieldWeek.text = " "
        //btnDaySelect.isEnabled = false
        // btnWeekSelect.isEnabled = false
        txtFieldDays.text! = "1"
        txtMonthEvery.text! = "1"
        txtFieldMonthDay.text! = "1"
        txtFieldMonths.text! = "1"
        txtFieldMonthDay.text! = "1"
        txtWeeklyField.text! = "1"
        txtFieldAfterDate.isEnabled = false
        btnnoEndDate.setImage(UIImage(named:"radio-selected"), for: .normal)
        btnSelect.setImage(UIImage(named:"radio-selected"), for: .normal)
        btnSelectWeekly.setImage(UIImage(named:"radio-selected"), for: .normal)
        btnMonthSelect.setImage(UIImage(named:"radio-selected"), for: .normal)
        setlocalization ()
    }
    
        func setlocalization () {
        segmentController.setTitle(daily_recur, forSegmentAt: 0)
        segmentController.setTitle(weekly_recur, forSegmentAt: 1)
        segmentController.setTitle(monthly_recur, forSegmentAt: 2)

        
        lblEveryDay.text = LanguageKey.every
        lblDays.text = LanguageKey.radio_weekDay
        lblDailyDays.text = LanguageKey.day_s
        
        // weekly recur pattern localiztion
        lblWeeklyDays.text = LanguageKey.day_s
        lblWeeklyEvery.text = LanguageKey.every
        
        
       // monthly recur pattern localiztion
        lblMonthEvery.text = LanguageKey.of_every
        lblMonths.text = LanguageKey.months_starting_on
        lblEveryMonths.text = LanguageKey.of_every
        lblThe.text = LanguageKey.the_radio
        lblMonthDay.text = LanguageKey.day_s
        lblMonthss.text = LanguageKey.months_starting_on
        
        
        //common recur pattern localization
        
        lblRange.text = LanguageKey.range_of_recurence
        lblStartingOn.text = LanguageKey.starting_on
        lblNoEndDate.text = LanguageKey.radio_no_end_date
        lblAfterDate.text = LanguageKey.radio_end_after
        lblOccurrense.text = LanguageKey.occurance
        lblEndBy.text = LanguageKey.radio_end_by
        btnSave.setTitle(LanguageKey.save_btn, for: .normal)
//btnSave.titleLabel = LanguageKey.save_btn
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtFieldDaySelect.text = " "
        txtFieldWeek.text = " "

    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    // ==================================//
    // Segment control method
    // ==================================//
    
    @IBAction func segmentControllerView(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.firstDailyView.isHidden = false
            self.secondWeeklyView.isHidden = true
            self.thirdMonthView.isHidden = true
            dailyRecurPattern = true
            weeklyRecurPattern = false
            monthlyRecurPattern = false
            self.FVXFV.constant = 150
           
        case 1:
            self.firstDailyView.isHidden = true
            self.secondWeeklyView.isHidden = false
            self.thirdMonthView.isHidden = true
            dailyRecurPattern = false
            weeklyRecurPattern = true
            monthlyRecurPattern = false
             self.FVXFV.constant = 300
            
        case 2:
            self.firstDailyView.isHidden = true
            self.secondWeeklyView.isHidden = true
            self.thirdMonthView.isHidden = false
            dailyRecurPattern = false
            weeklyRecurPattern = false
            monthlyRecurPattern = true
              self.FVXFV.constant = 223
            
        default:
            break
        }
    }
    
    // ==================================//
    // MARK:- DailyRecur method
    // ==================================//
    
    @IBAction func btnMinus(_ sender: Any) {
        
        if txtFieldDays!.text! != "1"
        {
            guard let presentValue = Int(txtFieldDays!.text!) else { return }
            newValueForDays = presentValue - 1
            txtFieldDays.text! = String(newValueForDays)
            
            if isbtnNoEndDate == true{
                getDailyRecurrence()
               // dailyEveryAndNoEndDate()
            } else if isAfterDateButtonSelected == true {
                 getDailyRecurrence()
               //  dailyEveryAndRecurenceTime()
            }else {
                getDailyRecurrence()
               // dailyEveryAndEndBy()
            }
           

            if isAfterDateButtonSelected == true {

            }else {

            }
        }else {
            txtFieldDays.text! = "1"
            if isAfterDateButtonSelected == true {

            }else {

            }
        }
        
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        
        guard let presentValue = Int(txtFieldDays.text!) else { return }
        newValueForDays = presentValue + 1
        txtFieldDays.text! = String(newValueForDays)
        if isbtnNoEndDate == true {
            getDailyRecurrence()
            //dailyEveryAndNoEndDate()
        } else if isAfterDateButtonSelected == true {
             getDailyRecurrence()
            // dailyEveryAndRecurenceTime()
        }
        else {
            getDailyRecurrence()
           // dailyEveryAndEndBy()
        }

        
        if isAfterDateButtonSelected == true {

        }else {

        }
        
    }
    
    
    
    
    @IBAction func btnWeekdaysSelect(_ sender: Any) {
        btnWeedaySelect.setImage(UIImage(named:"radio-selected"), for: .normal)
        btnSelect.setImage(UIImage(named:"radio_unselected"), for: .normal)
        txtFieldDays.isEnabled = false
        txtFieldDays.text! = " "
        isButtonSelectedEveryDay = false
        isButtunSelectedWeekEnd = true
        dailyEveryDayMode = "2"
        getDailyRecurrence()
        weekDayAndNoEndDate()
        //dailyEveryAndEndBy()

        
    }
    
    
    
    @IBAction func btnEveryDaySelect(_ sender: Any) {
        txtFieldDays.text! = "1"
        
        btnSelect.setImage(UIImage(named:"radio-selected"), for: .normal)
        btnWeedaySelect.setImage(UIImage(named:"radio_unselected"), for: .normal)
        txtFieldDays.isEnabled = true
        isButtunSelectedWeekEnd = false
       
        isButtonSelectedEveryDay = true
        
        dailyEveryDayMode = "1"

        
    }
    
//    func dailyEveryAndNoEndDate()  {
//           self.lblMsgShowing.text = "\(self.custom_recur_msg1)\(String(describing: self.aarOfDailyRecur.interval))\(self.starting_on)\(String(describing: self.aarOfDailyRecur.start_date))\(self.custom_recur_msg2) \(self.occurences) \(String(describing: self.aarOfDailyRecur.occurences)) \(String(describing: self.aarOfDailyRecur.end_date))"
//       }
//
//    func dailyEveryAndRecurenceTime()  {
//        self.lblMsgShowing.text = "\(self.custom_recur_msg1)\(String(describing: self.aarOfDailyRecur.interval))\(self.starting_on)\(String(describing: self.aarOfDailyRecur.start_date))\(self.custom_recur_msg2) \(self.occurences) \(String(describing: self.aarOfDailyRecur.occurences)) \(String(describing: self.aarOfDailyRecur.end_date))"
//       }
//    func dailyEveryAndEndBy() {
//        self.lblMsgShowing.text = "\(self.custom_recur_msg1)\(self.dailyInterval)\(self.starting_on)\(self.dailyStart_date)\(self.custom_recur_msg2) \(self.occurences) \(String(describing: self.aarOfDailyRecur.occurences)) \(String(describing: self.aarOfDailyRecur.end_date))"
//
//       // This job will repeat every weekday starting on 26-March-2021 and repeat indefinitely
//    }
    
    
        func dailyEveryAndNoEndDate(interval:String?)  {
               self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: interval!))\(self.starting_on) \(String(describing: self.aarOfDailyRecur.start_date!)) \(self.custom_recur_msg2) \(self.infinity)"
            
//            This job will repeat every 1 day(s) starting on 13-April-2021 and repeat indefinitely
           }
    
    func dailyEveryAndAfterDate(interval:String?,occurence:String?,endDate:String?)  {
                   self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: interval!)) \(self.starting_on) \(String(describing: self.aarOfDailyRecur.start_date!)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                      lblDateTimeSetByServer.text = endDate!
                    recurMsg = self.lblMsgShowing.text!
        
        
               }
    
    func dailyEveryAndEndBy(interval:String?,occurence:String?,endDate:String?)  {
               self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: interval!)) \(self.starting_on) \(String(describing: self.aarOfDailyRecur.start_date!)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                  txtFieldAfterDate.text = occurence!
    
    
           }
    
    
    
         func dailyWeedayAndNoEndDate() {
                   self.lblMsgShowing.text = "\(self.custom_recur_msg1) \("weekDay") \(self.starting_on) \(String(describing: self.aarOfDailyRecur.start_date!)) \(self.custom_recur_msg2) \(self.infinity)"
                 recurMsg = self.lblMsgShowing.text ?? ""
    //            This job will repeat every 1 day(s) starting on 13-April-2021 and repeat indefinitely
               }
    
    func dailyWeekdayAndAfterDate(occurence:String?,endDate:String?)  {
                     self.lblMsgShowing.text = "\(self.custom_recur_msg1) \("weeday") \(self.starting_on) \(String(describing: self.aarOfDailyRecur.start_date!)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                        lblDateTimeSetByServer.text = endDate!
                        recurMsg = self.lblMsgShowing.text ?? ""
          
          
                 }
    func dailyWeekdayAndEndBy(occurence:String?,endDate:String?)  {
                        self.lblMsgShowing.text = "\(self.custom_recur_msg1) \("weeday") \(self.starting_on) \(String(describing: self.aarOfDailyRecur.start_date!)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                           txtFieldAfterDate.text = endDate!
                          recurMsg = self.lblMsgShowing.text ?? ""
             
                    }
    
    
    
    func weekDayAndNoEndDate()  {
        self.lblMsgShowing.text = "\(self.custom_recur_msg1) \("weekday") \(self.starting_on) \(String(describing: self.dailyStart_date)) \(self.infinity)"
         recurMsg = self.lblMsgShowing.text ?? ""
        //This job will repeat every weekday starting on 26-March-2021 and repeat indefinitely
         }
    
    func weekDayAndNumberOccurence()  {
        self.lblMsgShowing.text = "\(self.custom_recur_msg1) \("weekday") \(self.starting_on) \(String(describing: self.dailyStart_date)) \(self.custom_recur_msg2) \(self.occurences) \(self.custom_recur_msg3) \(self.endDates)"
             recurMsg = self.lblMsgShowing.text ?? ""
   // This job will repeat every weekday starting on 27-March-2021 and repeat 4 time(s) until 01-April-2021
     }
    
    func weeklyAndNoEndDate(occurs_days:String?,interval:String?)  {
        self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: occurs_days!)) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: self.dailyStart_date)) \(self.custom_recur_msg2) \(self.infinity)"
            recurMsg = self.lblMsgShowing.text ?? ""
         //This job will repeat on Monday, Tuesday, Wednesday every 1 weeks starting on 27-March-2021 and repeat indefinitely
      }
    
    func weeklyAndAfterDate(occurs_days:String?,interval:String?,occurence:String?,endDate:String?)  {
      self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: occurs_days!)) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: self.dailyStart_date)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
           recurMsg = self.lblMsgShowing.text ?? ""
    }
//    func weeklyAndEndby(occurs_days:String?,interval:String?,occurence:String?,endDate:String?)  {
//      self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: occurs_days!)) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: self.dailyStart_date)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3)\(endDate!))"
//
//    }
    
    func monthlyAndNoendDate(days:String?,interval:String?){
          self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: days!)) \("every") \(interval!) \("month(s)") \(self.schel_start) \(String(describing: self.dailyStart_date)) \(self.custom_recur_msg2) \(self.infinity)"
          recurMsg = self.lblMsgShowing.text ?? ""
    }
    
    
    func monthlyAndAfterDate(days:String?,interval:String?,occurence:String?,endDate:String?)  {
      self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: days!)) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: self.dailyStart_date)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
       recurMsg = self.lblMsgShowing.text ?? ""
       // This job will repeat on 1st every 1 month(s) starting on 12-April-2021 and repeat 1 time(s) until 01-May-2021
    }
    func monthlyAndEndBy(days:String?,interval:String?,occurence:String?,endDate:String?)  {
      self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: days!)) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: self.dailyStart_date)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
       recurMsg = self.lblMsgShowing.text ?? ""
       // This job will repeat on 1st every 1 month(s) starting on 12-April-2021 and repeat 1 time(s) until 01-May-2021
    }
    
    
    func monthly_NoendDate(days:String?,interval:String?,days_name:String?){
           self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: days!)) \(String(describing: days_name!)) \("every") \(interval!) \("month(s)") \(self.schel_start) \(String(describing: self.dailyStart_date)) \(self.custom_recur_msg2) \(self.infinity)"
       recurMsg = self.lblMsgShowing.text ?? ""
         
     }
    
    func monthly_AfterDate(days:String?,interval:String?,days_name:String?,occurence:String?,endDate:String?){
              self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: days!)) \(days_name!) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: self.dailyStart_date)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                recurMsg = self.lblMsgShowing.text ?? ""
        
    }
    
    func monthly_Endby(days:String?,interval:String?,days_name:String?,occurence:String?,endDate:String?){
              self.lblMsgShowing.text = "\(self.custom_recur_msg1) \(String(describing: days!)) \(days_name!) \("every") \(interval!) \("weeks") \(self.schel_start) \(String(describing: self.dailyStart_date)) \(self.custom_recur_msg2) \(occurence!) \(self.custom_recur_msg3) \(endDate!)"
                     recurMsg = self.lblMsgShowing.text ?? ""
        
    }

    
    
    
    
    // ==================================//
    // MARK:- WeeklyRecur method
    // ==================================//
    
    @IBAction func btnselectWeekly(_ sender: Any) {
        btnSelectWeekly.setImage(UIImage(named:"radio-selected"), for: .normal)
        isbtnselectWeekly = true
        
    }
    
    @IBAction func btnAddWeekly(_ sender: Any) {
        guard let presentValue = Int(txtWeeklyField.text!) else { return }
        addWeekly = presentValue + 1
        txtWeeklyField.text! = String(addWeekly)
        if isAfterDateButtonSelected == true {
            getWeeklyRecurrence()
        }else if isEndByButton == true {
            getWeeklyRecurrence()
        }
        
    }
    
    @IBAction func buttonMinusWeekly(_ sender: Any) {
        if txtWeeklyField.text! != "1"
        {
            guard let presentValue = Int(txtWeeklyField.text!) else { return }
            addWeekly = presentValue - 1
            txtWeeklyField.text! = String(addWeekly)
            if isAfterDateButtonSelected == true {
              getWeeklyRecurrence()
            }else if isEndByButton == true {
                getWeeklyRecurrence()
            }
        }else {
            txtWeeklyField.text! = "1"
        }
    }
    
    
   
    
    func getArrayValue(){
        var arrOfDaysValu = [String]()
        arrOfDaysValu = arrDaysCollection
    }
    
    // ==================================//
    // MARK:- MonthlyRecur method
    // ==================================//
    
    @IBAction func btnMonthDayAdd(_ sender: Any) {
        guard let presentValue = Int(txtFieldMonthDay.text!) else { return }
        monthlyDaysAddMinus = presentValue + 1
        txtFieldMonthDay.text! = String(monthlyDaysAddMinus)
        
        if isbtnNoEndDate == true {
            occurDay = String(monthlyDaysAddMinus)
            getMonthlyRecurrence()
           // createRecurAccordingToDayAnaMonth()
        }else if isAfterDateButtonSelected == true {
            occurDay = String(monthlyDaysAddMinus)
            getMonthlyRecurrence()
            // monthlyDaysSelection()
        }else if isEndByButton == true {
            occurDay = String(monthlyDaysAddMinus)
            getMonthlyRecurrence()
            
        }
    }
    
    @IBAction func btnMonthDayMinus(_ sender: Any) {
        if txtFieldMonthDay.text! != "1"
        {
            guard let presentValue = Int(txtFieldMonthDay.text!) else { return }
            monthlyDaysAddMinus = presentValue - 1
            txtFieldMonthDay.text! = String(monthlyDaysAddMinus)
            //monthlyDaysSelection()
            if isbtnNoEndDate == true {
                occurDay = String(monthlyDaysAddMinus)
                getMonthlyRecurrence()
                // createRecurAccordingToDayAnaMonth()
            }else if isAfterDateButtonSelected == true {
                occurDay = String(monthlyDaysAddMinus)
                getMonthlyRecurrence()
                // monthlyDaysSelection()
            }else if isEndByButton == true {
                occurDay = String(monthlyDaysAddMinus)
                getMonthlyRecurrence()
                
            }
            
        }else {
            txtFieldMonthDay.text! = "1"
        }
    }
    @IBAction func btnMonthDaySelection(_ sender: Any) {
        txtFieldMonthDay.text! = "1"
        txtMonthEvery.text! = "1"
        btnMonthSelect.setImage(UIImage(named:"radio-selected"), for: .normal)
        btnTheSeelect.setImage(UIImage(named:"radio_unselected"), for: .normal)
        self.txtFieldMonthDay.isEnabled = true
        self.txtMonthEvery.isEnabled = true
        txtFieldMonths.isEnabled = false
        txtFieldDaySelect.isEnabled = false
        txtFieldWeek.isEnabled = false
        txtFieldMonths.text! = " "
        txtFieldWeek.text = " "
        txtFieldDaySelect.text = " "
        btnDaySelect.isEnabled = true
        isbtnMonthDaySelection = true
        isWeekDayAndMonthSelection = false
        monthlyMode = "1"
        
        
        // txtFieldMonthDay
    }
    
    @IBAction func btnSelectMonthlyWeekDay(_ sender: Any) {
        txtFieldMonths.text! = "1"
        btnTheSeelect.setImage(UIImage(named:"radio-selected"), for: .normal)
        btnMonthSelect.setImage(UIImage(named:"radio_unselected"), for: .normal)
        txtFieldMonths.isEnabled = true
        isWeekDayAndMonthSelection = true
        isbtnMonthDaySelection = false
        self.txtFieldMonthDay.isEnabled = false
        self.txtMonthEvery.isEnabled = false
        txtFieldMonthDay.text! = " "
        txtMonthEvery.text! = " "
        txtFieldWeek.text = "First"
        txtFieldDaySelect.text = "Monday"
        monthlyMode = "2"
    }
    
    
    
    
    @IBAction func btnMonthEveryMinus(_ sender: Any) {
        if txtMonthEvery.text! != "1"
        {
            guard let presentValue = Int(txtMonthEvery.text!) else { return }
            monthlyMonthsAddMinus = presentValue - 1
            txtMonthEvery.text! = String(monthlyMonthsAddMinus)
            //monthlyMonthsSelection()
            if isbtnNoEndDate == true {
               // addMonthly = monthlyDaysAddMinus
                getMonthlyRecurrence()
                // createRecurAccordingToDayAnaMonth()
            }else if isAfterDateButtonSelected == true {
                monthlyDaysAddMinus = monthlyMonthsAddMinus
                getMonthlyRecurrence()
                // monthlyDaysSelection()
            }else if isEndByButton == true {
                monthlyDaysAddMinus = monthlyMonthsAddMinus
                getMonthlyRecurrence()
                
            }
        }else {
            txtMonthEvery.text! = "1"
        }
    }
    
    @IBAction func btnMonthEveryAdd(_ sender: Any) {
        guard let presentValue = Int(txtMonthEvery.text!) else { return }
        monthlyMonthsAddMinus = presentValue + 1
        txtMonthEvery.text! = String(monthlyMonthsAddMinus)
        
        if isbtnNoEndDate == true {
            //addMonthly = String(monthlyDaysAddMinus)
            getMonthlyRecurrence()
            // createRecurAccordingToDayAnaMonth()
        } else if isAfterDateButtonSelected == true {
            monthlyDaysAddMinus = monthlyMonthsAddMinus
            getMonthlyRecurrence()
            // monthlyDaysSelection()
        }else if isEndByButton == true {
            monthlyDaysAddMinus = monthlyMonthsAddMinus
            getMonthlyRecurrence()
            
        }
    
    }
    
 
    
    @IBAction func btnSelectDays(_ sender: UIButton) {
        
        self.sltDropDownTag = sender.tag
        switch  sender.tag {
        case 0:
            
            if(self.optionalVw == nil){
                
                self.openDwopDown( txtField: self.txtFieldDaySelect, arr: arrDaysType)
                
            }else{
                self.removeOptionalView()
            }
            
        case 1:
            
            if(self.optionalVw == nil){
                
                self.openDwopDown( txtField: self.txtFieldWeek , arr: arrWeekType)
                
            }else{
                
                self.removeOptionalView()
                
            }
            
            break
        default:
          //  print("Defalt")
            break
            
        }
    }
    @IBAction func btnMinusMonth(_ sender: Any) {
        
        if txtFieldMonths.text! != "1"
        {
            guard let presentValue = Int(txtFieldMonths.text!) else { return }
            btnAddMinusMonth = presentValue - 1
            txtFieldMonths.text! = String(btnAddMinusMonth)
            if isbtnNoEndDate == true {
                monthlyDaysAddMinus = btnAddMinusMonth
                getMonthlyRecurrence()
                
            } else if isAfterDateButtonSelected == true && isWeekDayAndMonthSelection == true
            {
                monthlyDaysAddMinus = btnAddMinusMonth
                getMonthlyRecurrence()
            }else if isWeekDayAndMonthSelection == true && isEndByButton == true{
                monthlyDaysAddMinus = btnAddMinusMonth
                getMonthlyRecurrence()
            }
            
//            if isWeekDayAndMonthSelection == true && isAfterDateButtonSelected{
//                          // recurAccordingToWeekAndDay()
//                       }

        }else {
            txtFieldMonths.text! = "1"
        }
    }
    @IBAction func btnMonthsAdd(_ sender: Any) {
        guard let presentValue = Int(txtFieldMonths.text!) else { return }
        btnAddMinusMonth = presentValue + 1
        txtFieldMonths.text! = String(btnAddMinusMonth)
        //recurAccordingToWeekAndDay()
        if isbtnNoEndDate == true {
            monthlyDaysAddMinus = btnAddMinusMonth
            getMonthlyRecurrence()
            
        }  else if isAfterDateButtonSelected == true && isWeekDayAndMonthSelection == true
        {
            monthlyDaysAddMinus = btnAddMinusMonth
            getMonthlyRecurrence()
        }else if isWeekDayAndMonthSelection == true && isEndByButton == true{
            monthlyDaysAddMinus = btnAddMinusMonth
            getMonthlyRecurrence()
        }
//        if isWeekDayAndMonthSelection == true && isAfterDateButtonSelected{
//            //recurAccordingToWeekAndDay()
//        }

    }
    

    
    func convertDateFormater(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-d"
        return  dateFormatter.string(from: date!)

    }
    

    
    
    // ==================================//
    // MARK:- CommonRecur method
    // ==================================//
    
    
    @IBAction func btnEndByDateSet(_ sender: Any) {
        self.bigView.isHidden = false
        self.showDateAndTimePicker()
        
        
    }
    
    @IBAction func btnDateTimeSet(_ sender: Any) {
        
        self.bigView.isHidden = false
        self.showDateAndTimePicker()
    }
    

    @IBAction func btnNoEndDate(_ sender: Any) {
       // dailyRecurPattern = true
        btnnoEndDate.setImage(UIImage(named:"radio-selected"), for: .normal)
        btnAfterDate.setImage(UIImage(named:"radio_unselected"), for: .normal)
        btnEndBy.setImage(UIImage(named:"radio_unselected"), for: .normal)
        txtFieldAfterDate.isEnabled = false
        txtFieldAfterDate.text! = " "
        
        endDateMode = ""
        numberOfOcurrencesMode = ""
        endRecurMode = "0"
        isbtnNoEndDate = true
        
        if isbtnNoEndDate == true && isButtonSelectedEveryDay == true{
            getDailyRecurrence()
           // dailyEveryAndNoEndDate()
        }else if isButtunSelectedWeekEnd == true {
            getDailyRecurrence()
        } else if isWeekDayAndMonthSelection == true {
            getMonthlyRecurrence()
        }
        
        // btnnoEndDatejgkhj
        
    }
    @IBAction func btnAfterDate(_ sender: Any) {
       // dailyRecurPattern = true
        txtFieldAfterDate.text! = "1"
        btnnoEndDate.setImage(UIImage(named:"radio_unselected"), for: .normal)
        btnAfterDate.setImage(UIImage(named:"radio-selected"), for: .normal)
        btnEndBy.setImage(UIImage(named:"radio_unselected"), for: .normal)
        isbtnNoEndDate = false
        isEndByButton = false
        isAfterDateButtonSelected = true
        endDateMode = ""//convertDateFormater(date: lblDateTime.text!)
        numberOfOcurrencesMode = "1"
        endRecurMode = "1"
        
        
        if isButtonSelectedEveryDay == true
        {
          getDailyRecurrence()
          //dailyEveryAndRecurenceTime()
            
        }else {
            
        }
        
        
//        if isButtunSelectedWeekEnd == true {
//        }
//        else{
//            let  day = Int(txtFieldDays.text!)
//            let timess = (newValueForTimes)
//            let getValue = day!*timess-day!
//            let currentDate = Date()
//            var dateComponent = DateComponents()
//            dateComponent.day = getValue
//            let futureDate = (Calendar.current.date(byAdding: dateComponent, to: currentDate))
//            print(currentDate)
//            lblDateTimeSetByServer.text! = "\(futureDate!)"
//
//
//        }
        
        
        
    }
    

    @IBAction func btnEndBy(_ sender: Any) {
        dailyRecurPattern = true
        btnnoEndDate.setImage(UIImage(named:"radio_unselected"), for: .normal)
        btnAfterDate.setImage(UIImage(named:"radio_unselected"), for: .normal)
        btnEndBy.setImage(UIImage(named:"radio-selected"), for: .normal)
        isbtnNoEndDate = false
        isAfterDateButtonSelected = false
        isEndByButton = true
        txtFieldAfterDate.isEnabled = false
        txtFieldAfterDate.text! = " "
        //endDateMode = lblDateTimeSetByServer.text!
        numberOfOcurrencesMode = ""
        endRecurMode = "2"
       
       // getWeeklyRecurrence()

        }
    
    
    @IBAction func btnAfterDateMinus(_ sender: Any) {
        
        if txtFieldAfterDate.text! != "1"
        {
            guard let presentValue = Int(txtFieldAfterDate.text!) else { return }
            newValueForTimes = presentValue - 1
            txtFieldAfterDate.text! = String(newValueForTimes)
            
            if isAfterDateButtonSelected == true && isButtonSelectedEveryDay
            {
              numberOfOcurrencesMode = String(newValueForTimes)
             getDailyRecurrence()
             //dailyEveryAndRecurenceTime()

            } else if isButtunSelectedWeekEnd == true && isAfterDateButtonSelected  {
                numberOfOcurrencesMode = String(newValueForTimes)
                getDailyRecurrence()
                weekDayAndNumberOccurence()
                
            } else if isAfterDateButtonSelected == true && isbtnselectWeekly == true {
                numberOfOcurrencesMode = String(newValueForTimes)
                getWeeklyRecurrence()
                
            } else if isbtnMonthDaySelection == true {
                numberOfOcurrencesMode = String(newValueForTimes)
                getMonthlyRecurrence()
                
            }else if isWeekDayAndMonthSelection == true {
                numberOfOcurrencesMode = String(newValueForTimes)
                getMonthlyRecurrence()
            }
            
        }else {
            txtFieldAfterDate.text! = "1"

            
        }
        
    }
    @IBAction func btnAfterDateAdd(_ sender: Any) {
        guard let presentValue = Int(txtFieldAfterDate.text!) else { return }
        newValueForTimes = presentValue + 1
        txtFieldAfterDate.text! = String(newValueForTimes)
        
        if isAfterDateButtonSelected == true && isButtonSelectedEveryDay
        {
            numberOfOcurrencesMode = String(newValueForTimes)
            getDailyRecurrence()
            //dailyEveryAndRecurenceTime()
        } else if isButtunSelectedWeekEnd == true && isAfterDateButtonSelected  {
            numberOfOcurrencesMode = String(newValueForTimes)
            getDailyRecurrence()
            weekDayAndNumberOccurence()
            //datesOfCurrentMonth(weekday : newValueForTimes)
        }else if isAfterDateButtonSelected == true && isbtnselectWeekly == true {
            numberOfOcurrencesMode = String(newValueForTimes)
            getWeeklyRecurrence()
        }else if isbtnMonthDaySelection == true {
            numberOfOcurrencesMode = String(newValueForTimes)
            getMonthlyRecurrence()
            
        }else if isWeekDayAndMonthSelection == true {
            numberOfOcurrencesMode = String(newValueForTimes)
            getMonthlyRecurrence()
        }
        

    }
    // ================================
    //  MARK: Open Drop Down
    // ================================
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                
                self.removeOptionalView()
            }
        }else{
            DispatchQueue.main.async {
                self.removeOptionalView()
            }
        }
    }
    
    func removeOptionalView(){
        if optionalVw != nil {
            self.optionalVw?.removeFromSuperview()
            self.optionalVw = nil
        }
    }

    //====================================================
    //MARK:- OptionView Delegate Methods
    //====================================================
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (sltDropDownTag == 0) {
            let DaysArray  = ["\(self.Monday)","\(self.Tuesday)","\(self.Wednesday)","\(self.Thuresday)","\(self.Friday)","\(self.Saturday)","\(self.Sunday)"]
            return DaysArray.count
        }
        else if (sltDropDownTag == 1) {
            let WeekArray = ["\(self.First)","\(self.Second)","\(self.Third)","\(self.Fourth)","\(self.Last)"]
            return WeekArray.count
        }
        return 0
        
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        let DaysArray  = ["\(self.Monday)","\(self.Tuesday)","\(self.Wednesday)","\(self.Thuresday)","\(self.Friday)","\(self.Saturday)","\(self.Sunday)"]
        let WeekArray = ["\(self.First)","\(self.Second)","\(self.Third)","\(self.Fourth)","\(self.Last)"]
       // let days : String = String(describing: DaysArray[indexPath.row])
        
        
        
       // let week : String = String(describing: WeekArray[indexPath.row])
        //        cell?.textLabel?.text = status.capitalizingFirstLetter()
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        cell?.textLabel?.textColor = UIColor.darkGray
        
        
        switch self.sltDropDownTag {
        case 0:
            cell?.textLabel?.text =  DaysArray[indexPath.row].capitalizingFirstLetter()
            break
        case 1:
            cell?.textLabel?.text =   WeekArray[indexPath.row].capitalizingFirstLetter()
            
            break
            
        default: break
            
        }
        
        return cell!
        
        // return cell!
    }
    
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.removeOptionalView()
        
        LocationManager.shared.isHaveLocation()
        
        let DaysArray  = ["\(self.Monday)","\(self.Tuesday)","\(self.Wednesday)","\(self.Thuresday)","\(self.Friday)","\(self.Saturday)","\(self.Sunday)"]
        
        if (sltDropDownTag == 0) {
            
            // self.txtFieldDaySelect.text =  String(describing: DaysArray[indexPath.row])
            
            let status : daySelectType = daySelectType(rawValue: arrDaysType[indexPath.row].rawValue)!
          //  print(status.rawValue)
            monthlyDaysCollect = status.rawValue
            self.txtFieldDaySelect.text = String(describing: status)
            if isbtnNoEndDate == true && isWeekDayAndMonthSelection == true {
                getMonthlyRecurrence()
            } else if isAfterDateButtonSelected == true && isWeekDayAndMonthSelection == true {
                getMonthlyRecurrence()
            }else if isWeekDayAndMonthSelection == true && isEndByButton == true{
                getMonthlyRecurrence()
            }
            
//             if isWeekDayAndMonthSelection == true && isAfterDateButtonSelected{
//               // recurAccordingToWeekAndDay()
//            }

            
        }
        
        if (sltDropDownTag == 1) {
            
            // self.txtFieldDaySelect.text =  String(describing: DaysArray[indexPath.row])
            
            let week : weekSelectType = weekSelectType(rawValue: arrWeekType[indexPath.row].rawValue)!
          //  print(week)
            monthlyWeekCollect = week.rawValue
            self.txtFieldWeek.text = String(describing: week)
            
            if isbtnNoEndDate == true && isWeekDayAndMonthSelection == true {
                getMonthlyRecurrence()
            }else if isAfterDateButtonSelected == true && isWeekDayAndMonthSelection == true {
                getMonthlyRecurrence()
            }else if isWeekDayAndMonthSelection == true && isEndByButton == true{
                getMonthlyRecurrence()
            }
//            if isWeekDayAndMonthSelection == true && isAfterDateButtonSelected{
//               // recurAccordingToWeekAndDay()
//            }

        }
        self.removeOptionalView()
        
    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
    
    func callMethodforOpenDwop(tag : Int){
        if(self.optionalVw != nil){
            self.removeOptionalView()
            return
        }
        
        switch tag {
        case 0:
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 0
                self.openDwopDown( txtField: txtFieldDaySelect, arr: arrDaysType)
            }else{
                self.removeOptionalView()
            }
            
            
            break
            
        case 1:
            
            if(self.optionalVw == nil){
                
                sltDropDownTag = 1
                self.openDwopDown( txtField: txtFieldWeek, arr: arrWeekType)
            }else{
                self.removeOptionalView()
            }
            
            break
            
        default:
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sltTxtField = textField
        self.sltDropDownTag = textField.tag
        
        if txtFieldMonthDay == textField {
            self.callMethodforOpenDwop(tag: 0)
        }
        if txtFieldWeek == textField {
            self.callMethodforOpenDwop(tag: 1)
        }
        
    }
    
    // Date and time futionality
    
    func showDateAndTimePicker(){
        // self.dateAndTimePicker.minimumDate = Date()
        self.bigView.isHidden = false
        UIView.animate(withDuration: 0.2)  {
            let frame = CGRect(x: 0, y: self.view.frame.size.height - 240, width: self.view.frame.size.width, height: 240)
            self.bigView.frame = frame
            
        }
    }
    
    @IBAction func saveBtnRecur(_ sender: Any) {
       if weeklyRecurPattern == true
       {
          if isAfterDateButtonSelected == true {
              var recuDaysArr: [[String:Any]] = []
              var recuDataArr: [[String:Any]] = []
              var paramDic = [String:Any]()
              paramDic["mode"] = dailyEveryDayMode
              paramDic["startDate"] = convertDateFormater(date: lblDateTime.text!)
              paramDic["numOfWeeks"] = String(newValueForDays)
              paramDic["endDate"] = convertDateFormater(date: self.endDate)
              paramDic["occurences"] = numberOfOcurrencesMode
              paramDic["jobId"] = ""
              // paramDic["type"] = "0"
              paramDic["endRecurMode"] = endRecurMode
              //paramDic["schdlStart"] = convertDateStringToTimestampForRecur(dateString: addJobDate)
              paramDic["weekDays"] = arrDaysId
              recuDataArr.append(paramDic)
              recuDaysArr.append(daysDic)
              recuDataJsonString = convertIntoJSONStringForRecur(arrayObject: recuDataArr)!
              recuDaysJsonString = convertIntoJSONStringForRecur(arrayObject: recuDaysArr)!
               delegateWeeklyRecur?.weeklyRecurData(recurData: recuDataJsonString, recurType: "2", recurMsg: recurMsg, weekly: "2", recurDays: recuDaysJsonString)
          }else{
          delegateWeeklyRecur?.weeklyRecurData(recurData: recuDataJsonString, recurType: "2", recurMsg: recurMsg, weekly: "2", recurDays: recuDaysJsonString)
          }
       }else if monthlyRecurPattern == true
       {
          if isAfterDateButtonSelected == true {
              var recuDataArr: [[String:Any]] = []
              var paramDic = [String:Any]()
              paramDic["mode"] = monthlyMode
              paramDic["startDate"] = convertDateFormater(date: lblDateTime.text!)
              paramDic["numOfMonths"] = String(newValueForDays)
              paramDic["endDate"] = convertDateFormater(date: self.endDate)
              paramDic["occurences"] = numberOfOcurrencesMode
              paramDic["jobId"] = ""
              //paramDic["type"] = "0"
              paramDic["endRecurMode"] = endRecurMode
              //paramDic["schdlStart"] = convertDateStringToTimestampForRecur(dateString: addJobDate)
              paramDic["dateNum"] = occurDay
              paramDic["weekNum"] = String(monthlyWeekCollect)
              paramDic["dayNum"] = String(monthlyDaysCollect)
              paramDic["weekDays"] = []
            
              recuDataArr.append(paramDic)
              
              recuDataJsonString = convertIntoJSONStringForRecur(arrayObject: recuDataArr)!
              delegateMonthlyRecur?.monthlyRecurData(recurData: recuDataJsonString, recurType: "3", recurMsg: recurMsg, monthly: "3")
          }else{
              delegateMonthlyRecur?.monthlyRecurData(recurData: recuDataJsonString, recurType: "3", recurMsg: recurMsg, monthly: "3")
          }
          
       }else{
          if isAfterDateButtonSelected == true {
              var recuDataArr: [[String:Any]] = []
              var paramDic = [String:Any]()
              paramDic["mode"] = dailyEveryDayMode
              paramDic["startDate"] = convertDateFormater(date: lblDateTime.text!)
              paramDic["numOfDays"] = String(newValueForDays)
              paramDic["endDate"] = convertDateFormater(date: self.endDate)
              paramDic["occurences"] = numberOfOcurrencesMode
              paramDic["jobId"] = ""
              paramDic["weekDays"] = []
              // paramDic["type"] = "0"
              paramDic["endRecurMode"] = endRecurMode
              // paramDic["schdlStart"] = convertDateStringToTimestampForRecur(dateString: addJobDate)
              paramDic["stopRecur"] = "0"
              //paramDic["stopRecur"] = "0"
              recuDataArr.append(paramDic)
              recuDataJsonString = convertIntoJSONStringForRecur(arrayObject: recuDataArr)!
           //   print(recuDataJsonString)
              delegateDailyRecur?.dailyRecurData(recurData: recuDataJsonString, recurType: "1", recurMsg: recurMsg, daily: "1")
          }else{
              delegateDailyRecur?.dailyRecurData(recurData: recuDataJsonString, recurType: "1", recurMsg: recurMsg, daily: "1")
          }
          
          
      }
        self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func btnCancel(_ sender: Any) {
        self.bigView.isHidden = true
    }
    
    @IBAction func btnDone(_ sender: Any) {
        
        self.bigView.isHidden = true
        let date = self.datePickerView.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy h:mm a"
        formatter.timeZone = TimeZone.current
        
        if let langCode = getCurrentSelectedLanguageCode() {
            formatter.locale = Locale(identifier: langCode)
        }
        
        let strDate = formatter.string(from: date)
        let arr = strDate.components(separatedBy: " ")
        
        if isEndByButton == true && isButtonSelectedEveryDay == true {
            lblDateTimeSetByServer.text = arr[0]
            endDateMode = convertDateFormater(date: lblDateTimeSetByServer.text!)//lblDateTimeSetByServer.text!
            getDailyRecurrence()
            txtFieldAfterDate.text = self.aarOfDailyRecur.occurences
            //dailyEveryAndEndBy()
           // dateTimeSetForEndDateTime()
        } else if isEndByButton == true && isButtunSelectedWeekEnd == true {
           lblDateTimeSetByServer.text = arr[0]
            endDateMode = convertDateFormater(date: lblDateTimeSetByServer.text!)//lblDateTimeSetByServer.text!
            getDailyRecurrence()
            txtFieldAfterDate.text = self.aarOfDailyRecur.occurences
            
            weekDayAndNoEndDate()
        }else if isEndByButton == true && isbtnselectWeekly {
            lblDateTimeSetByServer.text = arr[0]
            endDateMode = convertDateFormater(date: lblDateTimeSetByServer.text!)//lblDateTimeSetByServer.text!
            getWeeklyRecurrence()
            
        } else if isbtnMonthDaySelection == true && isEndByButton == true {
            lblDateTimeSetByServer.text = arr[0]
            endDateMode = convertDateFormater(date: lblDateTimeSetByServer.text!)//lblDateTimeSetByServer.text!
            getMonthlyRecurrence()
        } else if isWeekDayAndMonthSelection == true && isEndByButton == true {
            lblDateTimeSetByServer.text = arr[0]
            endDateMode = convertDateFormater(date: lblDateTimeSetByServer.text!)//lblDateTimeSetByServer.text!
            getMonthlyRecurrence()
        }
        else if  dailyRecurPattern == true || weeklyRecurPattern == true || monthlyRecurPattern == true {
            lblDateTime.text = arr[0]
        }else{
            lblDateTime.text = arr[0]
            
        }
        
        
       
    }
    
    // set current time
    
    func setCurrentDate(){
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        let selectedDate = datePickerView!.date
        let formatter = DateFormatter()
        formatter.dateFormat="dd-MMM-yyyy"
        let strd = formatter.string(from: selectedDate)
        lblDateTime.text = strd
    }
    
    func convertDateStringToTimestampForRecur(dateString : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date: Date? = dateFormatter.date(from: dateString)
        let interval: TimeInterval? = date?.timeIntervalSince1970
        return String(Int(interval!))
    }
}


//====================================================
//MARK:- Extention for Recur Method
//====================================================

extension AddRecurVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecurCell") as! RecurTableCell
        let recurDay = weekdays[indexPath.row]
        
        cell.lblRecurDayWeekly.text = recurDay.title
        
        if isChecked != false {
            if selectedRows.contains(indexPath.row){
                
                cell.checkMarkBtn.isSelected = false
                
                
            }else{
                cell.checkMarkBtn.isSelected = true
               
            }
        }else{
            if selectedRows.contains(indexPath.row){
                
                cell.checkMarkBtn.isSelected = true
               
                
            }else{
                cell.checkMarkBtn.isSelected = false
                
            }
        }
        
        cell.checkMarkBtn.addTarget(self, action: #selector(buttonTapped( sender: )), for: .touchUpInside)
        cell.checkMarkBtn.tag = indexPath.row
    
        return cell
    }
    
    @objc func buttonTapped(sender: UIButton) {
        arrDaysCount.removeAll()
        arrDaysId.removeAll()
        if self.selectedRows.contains(sender.tag){
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: sender.tag)!)
            var exerciseString = ""
            for day in selectedRows{
                let days = weekdays[day].title
                let id = weekdays[day].id
              if id == "1" || id == "1" {
                                    daysDic["monday"] = "1"
                                }
                                else if id == "2" {
                                    daysDic["tuesday"] = "1"
                                }
                                else if id == "3" {
                                    daysDic["wednesday"] = "1"
                                }
                                else if id == "4" {
                                    daysDic["thursday"] = "1"
                                }
                                else if id == "5" {
                                    daysDic["friday"] = "1"
                                }
                                else if id == "6" {
                                    daysDic["saturday"] = "1"
                                }
                                else if id == "7" {
                                    daysDic["sunday"] = "1"
                                }
                arrDaysCount.append(days)
                arrDaysId.append(id)
                
              //  print(days)
              //  print(arrDaysCount.count)
                getWeeklyRecurrence()
            }
            for i in 0..<arrDaysCount.count
            {
                exerciseString = "\(exerciseString) \(arrDaysCount[i])";
                //exerciseString = exerciseString + ","
            }

            
        }else  {
            var exerciseString = ""
            self.selectedRows.append(sender.tag)
            for day in selectedRows{
               let days = weekdays[day].title
                let id = weekdays[day].id
              if id == "1" || id == "1" {
                                    daysDic["monday"] = "1"
                                }
                                else if id == "2" {
                                    daysDic["tuesday"] = "1"
                                }
                                else if id == "3" {
                                    daysDic["wednesday"] = "1"
                                }
                                else if id == "4" {
                                    daysDic["thursday"] = "1"
                                }
                                else if id == "5" {
                                    daysDic["friday"] = "1"
                                }
                                else if id == "6" {
                                    daysDic["saturday"] = "1"
                                }
                                else if id == "7" {
                                    daysDic["sunday"] = "1"
                                }
                arrDaysCount.append(days)
                arrDaysId.append(id)
               // print(arrDaysCount.count)
            }
            for i in 0..<arrDaysCount.count
            {
                exerciseString = "\(exerciseString) \(arrDaysCount[i])";
            }
            getWeeklyRecurrence()

        }
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        
    }
    
    //====================================================
    //MARK:- Daily Api Calling Method
    //====================================================
    
    func getDailyRecurrence(){
              showLoader()
              let param = Params()
               param.jobId = ""
               param.schdlStart = convertDateStringToTimestampForRecur(dateString: addJobDate)
               param.mode = dailyEveryDayMode
               param.startDate = convertDateFormater(date: lblDateTime.text!)
               param.interval = String(newValueForDays)
               param.endDate = endDateMode
               param.numberOfOcurrences = numberOfOcurrencesMode
               param.endRecurMode = endRecurMode
               param.type = "0"
      var recuDataArr: [[String:Any]] = []
      var paramDic = [String:Any]()
      paramDic["mode"] = dailyEveryDayMode
      paramDic["startDate"] = convertDateFormater(date: lblDateTime.text!)
      paramDic["numOfDays"] = String(newValueForDays)
      paramDic["endDate"] = endDateMode
      paramDic["occurences"] = numberOfOcurrencesMode
      paramDic["jobId"] = ""
      paramDic["weekDays"] = []
     // paramDic["type"] = "0"
      paramDic["endRecurMode"] = endRecurMode
     // paramDic["schdlStart"] = convertDateStringToTimestampForRecur(dateString: addJobDate)
      paramDic["stopRecur"] = "0"
      //paramDic["stopRecur"] = "0"
      recuDataArr.append(paramDic)

     // [{"endDate":"2021-04-21","endRecurMode":"1","jobId":"","mode":"1","numOfDays":"1","occurences":"1","startDate":"2021-04-21","stopRecur":"0","weekDays":[]}]

      recuDataJsonString = convertIntoJSONStringForRecur(arrayObject: recuDataArr)!
      
        
        //print(param.toDictionary!)
        

        serverCommunicator(url: Service.DailyJobRecurrenceResult, param: param.toDictionary) { (response, success) in
            
            killLoader()
            if(success){
                let decoder = JSONDecoder()
       
                if let decodedData = try? decoder.decode(RecurResModel.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        self.aarOfDailyRecur = decodedData.transVar!
                       // self.dailyInterval = decodedData.transVar!.interval? ""
                        self.dailyStart_date = decodedData.transVar!.start_date ?? ""
                        self.occurences = decodedData.transVar!.occurences ?? ""
                        self.endDates = decodedData.transVar!.end_date ??  ""
                        let interval = decodedData.transVar!.interval
                        let occurences = decodedData.transVar!.occurences
                        let endDates = decodedData.transVar!.end_date
                        self.endDate = endDates ?? ""
                        
                        DispatchQueue.main.async {
                            
                            if self.isButtonSelectedEveryDay == true
                            {
                                if self.isbtnNoEndDate == true
                                {
                                    self.dailyEveryAndNoEndDate(interval: interval)
                                } else if self.isAfterDateButtonSelected == true {
                                    self.dailyEveryAndAfterDate(interval:interval,occurence:occurences,endDate:endDates)
                                }else if self.isEndByButton == true {
                                    self.dailyEveryAndEndBy(interval:interval,occurence:occurences,endDate:endDates)
                                }
                            }else {
                                if self.isbtnNoEndDate == true
                                {
                                    self.dailyWeedayAndNoEndDate()
                                } else if self.isAfterDateButtonSelected == true {
                                    self.dailyWeekdayAndAfterDate(occurence:occurences,endDate:endDates)
                                }else if self.isEndByButton == true {
                                    self.dailyWeekdayAndEndBy(occurence:occurences,endDate:endDates)
                                }
                            }
                            
                            
                            
                            if self.isButtunSelectedWeekEnd == true && self.isEndByButton == true
                            {
                                 self.txtFieldAfterDate.text = self.occurences
                                //self.lblDateTimeSetByServer.text = self.endDates
                            } else if self.isButtunSelectedWeekEnd == true && self.isAfterDateButtonSelected == true
                            {
                                 self.lblDateTimeSetByServer.text = self.endDates
                            }
//                            else if self.isbtnselectWeekly == true && self.isAfterDateButtonSelected == true || self.isButtonSelectedEveryDay == true && self.isAfterDateButtonSelected == true {
//                                self.lblDateTimeSetByServer.text = self.endDates
//                            }
                           // self.txtFieldAfterDate.text = self.occurences
                            //self.lblDateTimeSetByServer.text = self.endDates
//                            if self.isButtunSelectedWeekEnd == true && self.isbtnNoEndDate == true
//                            {
//                                self.weekDayAndNoEndDate()
//                            }
                        }
                        
                        
                    }else{
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
        //====================================================
        //MARK:- Weekly Api Calling Method
        //====================================================
        
        func getWeeklyRecurrence(){
                  showLoader()
                  let param = Params()
                   param.jobId = ""
                   param.schdlStart = convertDateStringToTimestampForRecur(dateString: addJobDate)
                   param.mode = weeklyMode
                   param.startDate = convertDateFormater(date: lblDateTime.text!)
                   param.interval = String(addWeekly)
                   param.endDate = endDateMode
                   param.numberOfOcurrences = numberOfOcurrencesMode
                   param.endRecurMode = endRecurMode
                   param.weekDays = arrDaysId
                   param.type = "0"
          var recuDaysArr: [[String:Any]] = []
          var recuDataArr: [[String:Any]] = []
                       var paramDic = [String:Any]()
                       paramDic["mode"] = dailyEveryDayMode
                       paramDic["startDate"] = convertDateFormater(date: lblDateTime.text!)
                       paramDic["numOfWeeks"] = String(newValueForDays)
                       paramDic["endDate"] = endDateMode
                       paramDic["occurences"] = numberOfOcurrencesMode
                       paramDic["jobId"] = ""
                      // paramDic["type"] = "0"
                       paramDic["endRecurMode"] = endRecurMode
                       //paramDic["schdlStart"] = convertDateStringToTimestampForRecur(dateString: addJobDate)
                       paramDic["weekDays"] = arrDaysId
                       recuDataArr.append(paramDic)
                       recuDaysArr.append(daysDic)
                      
        //  [{"endDate":"2021-04-26","endRecurMode":"1","jobId":"","mode":"1","numOfWeeks":"1","occurences":"1","startDate":"2021-04-21","stopRecur":"0","weekDays":["1"]}],
                       recuDataJsonString = convertIntoJSONStringForRecur(arrayObject: recuDataArr)!
                       recuDaysJsonString = convertIntoJSONStringForRecur(arrayObject: recuDaysArr)!
            //print(param.toDictionary)
            serverCommunicator(url: Service.weeklyJobRecurrenceResult, param: param.toDictionary) { (response, success) in
                
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
           
                    if let decodedData = try? decoder.decode(RecurResModel.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            self.aarOfDailyRecur = decodedData.transVar!
                           // self.dailyInterval = decodedData.transVar!.interval? ""
                            self.dailyStart_date = decodedData.transVar!.start_date ?? ""
                            self.occurences = decodedData.transVar!.occurences ?? ""
                            self.endDates = decodedData.transVar!.end_date ??  ""
                            let occur_days = decodedData.transVar!.occur_days ?? ""
                            let interval = decodedData.transVar!.interval
                            let occurences = decodedData.transVar!.occurences
                            let endDates = decodedData.transVar!.end_date
                            self.endDate = endDates ?? ""
                            DispatchQueue.main.async {
                                if occur_days != "" {
                                    
                                }
                               // self.txtFieldAfterDate.text = self.occurences
                               // self.lblDateTimeSetByServer.text = self.endDates
                                
                                if self.isbtnNoEndDate == true
                                {
                                    self.weeklyAndNoEndDate(occurs_days:occur_days, interval: interval)
        
                                }else if self.isAfterDateButtonSelected == true
                                {
                                    self.weeklyAndAfterDate(occurs_days:occur_days,interval:interval,occurence:occurences,endDate:endDates)
                                   // self.txtFieldAfterDate.text = self.occurences
                                    self.lblDateTimeSetByServer.text = self.endDates
                                }else if self.isEndByButton == true {
                                      self.weeklyAndAfterDate(occurs_days:occur_days,interval:interval,occurence:occurences,endDate:endDates)
                                    self.txtFieldAfterDate.text = self.occurences
                                   // self.lblDateTimeSetByServer.text = self.endDates
                                }
                            }
                            
                            
                        }else{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    }
                }else{
                    ShowError(message: "Please try again!", controller: windowController)
                }
            }
        }
    
    
        //=======================================
        //MARK:- Monthly Api Calling Method
        //=======================================
        
        func getMonthlyRecurrence(){
                  showLoader()
                  let param = Params()
                   param.jobId = ""
                   param.schdlStart = convertDateStringToTimestampForRecur(dateString: addJobDate)
                   param.mode = monthlyMode
                   param.startDate = convertDateFormater(date: lblDateTime.text!)
                   param.interval = String(monthlyMonthsAddMinus)
                   param.endDate = endDateMode
                   param.numberOfOcurrences = numberOfOcurrencesMode
                   param.endRecurMode = endRecurMode
                   param.occurDay = occurDay
                   param.weekNum = String(monthlyWeekCollect)
                   param.dayNum = String(monthlyDaysCollect)
                   param.type = "0"
          
          
          
            var recuDataArr: [[String:Any]] = []
              var paramDic = [String:Any]()
              paramDic["mode"] = monthlyMode
              paramDic["startDate"] = convertDateFormater(date: lblDateTime.text!)
              paramDic["numOfMonths"] = String(newValueForDays)
              paramDic["endDate"] = endDateMode
              paramDic["occurences"] = numberOfOcurrencesMode
              paramDic["jobId"] = ""
              //paramDic["type"] = "0"
              paramDic["endRecurMode"] = endRecurMode
              //paramDic["schdlStart"] = convertDateStringToTimestampForRecur(dateString: addJobDate)
              paramDic["dateNum"] = occurDay
              paramDic["weekNum"] = String(monthlyWeekCollect)
              paramDic["dayNum"] = String(monthlyDaysCollect)
              paramDic["weekDays"] = []
         // [{"dateNum":"1","dayNum":"","endDate":"2021-05-01","endRecurMode":"1","jobId":"","mode":"1","numOfMonths":"1","occurences":"1","startDate":"2021-04-21","stopRecur":"0","weekDays":[],"weekNum":""}]
              //paramDic["stopRecur"] = "0"
              recuDataArr.append(paramDic)
          
              recuDataJsonString = convertIntoJSONStringForRecur(arrayObject: recuDataArr)!
           //{"mode":"1","schdlStart":"1616828061","startDate":"2021-3-30","jobId":"96509","endDate":"","endRecurMode":"1","occurDay":4,"interval":2,"numberOfOcurrences":1,"type":0}:

            
           // print(param.toDictionary!)
            
            serverCommunicator(url: Service.MonthlyjobRecurrenceResult, param: param.toDictionary) { (response, success) in
                
                killLoader()
                if(success){
                    let decoder = JSONDecoder()
           
                    if let decodedData = try? decoder.decode(RecurResModel.self, from: response as! Data) {
                        
                        if decodedData.success == true{
                            self.aarOfDailyRecur = decodedData.transVar!
                           // self.dailyInterval = decodedData.transVar!.interval? ""
                            self.dailyStart_date = decodedData.transVar!.start_date ?? ""
                            self.occurences = decodedData.transVar!.occurences ?? ""
                            self.endDates = decodedData.transVar!.end_date ??  ""
                            let occur_days = decodedData.transVar!.occur_days ?? ""
                            let days = decodedData.transVar!.week_num ?? ""
                            let interval = decodedData.transVar!.interval ?? ""
                            let occurences = decodedData.transVar!.occurences
                            let endDates = decodedData.transVar!.end_date
                            let days_name = decodedData.transVar!.day_num
                            self.endDate = endDates ?? ""
                            DispatchQueue.main.async {
                                if occur_days != "" {
                                    
                                }
                                self.txtFieldAfterDate.text = self.occurences
                                self.lblDateTimeSetByServer.text = self.endDates
                                
                                if self.isbtnMonthDaySelection == true{
                                if self.isbtnNoEndDate == true
                                {
                                    self.monthlyAndNoendDate(days:days,interval:interval)
                                    
                                } else if self.isAfterDateButtonSelected == true
                                {
                                    self.monthlyAndAfterDate(days:days,interval:interval,occurence:occurences,endDate:endDates)
                                }
                                else if self.isEndByButton == true
                                {
                                    self.monthlyAndEndBy(days:days,interval:interval,occurence:occurences,endDate:endDates)
                                }
                                
                                } else {
                                    if self.isbtnNoEndDate == true{
                                    self.monthly_NoendDate(days:days,interval:interval,days_name:days_name)
                                    } else if self.isAfterDateButtonSelected == true{
                                        self.monthly_AfterDate(days:days,interval:interval,days_name:days_name,occurence:occurences,endDate:endDates)
                                    }else if self.isEndByButton == true{
                                        self.monthly_Endby(days:days,interval:interval,days_name:days_name,occurence:occurences,endDate:endDates)
                                    }
                                }
                            }
                            
                            
                        }else{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }else{
                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                    }
                }else{
                    ShowError(message: "Please try again!", controller: windowController)
                }
            }
        }
    
   
    func convertIntoJSONStringForRecur(arrayObject: [Any]) -> String? {
         
         do {
             let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
             if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                 return jsonString as String
             }
             
         } catch let error as NSError {
           //  print("Array convertIntoJSON - \(error.description)")
         }
         return nil
     }
    
    
}



