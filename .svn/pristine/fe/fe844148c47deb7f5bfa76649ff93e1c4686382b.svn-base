//
//  MultiFilterQuoteVC.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 03/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class MultiFilterQuoteVC: UIViewController,OptionViewDelegate {
  
     var sltBtn : Int!
     let cellReuseIdentifier = "cell"
     var optionalVw : OptionalView?
     var arrQuoteStatus : [QuoteStatusType] = [.New, .Approve,.OnHold, .Reject ]
     let dateRange: [DateRange] = [.Today, .Yesterday, .Last7Days, .Last30Days, .ThisMonth, .LastMonth, .CustomRange]
     var selectedStatus = [Int]()
     var selectedDate = [Int]()
     var callbackOfMultipleFilter: (( [QuoteStatusType],DateRange?, (Date?,Date?) ) -> Void)?
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var txtQuoteStatus: FloatLabelTextField!
     @IBOutlet weak var txtQuoteDate: FloatLabelTextField!
    @IBOutlet weak var lblStartDate: FloatLabelTextField!
    @IBOutlet weak var lblEndDate: FloatLabelTextField!
    @IBOutlet weak var H_dateView: NSLayoutConstraint!
    @IBOutlet var dateAndTimePicker: UIDatePicker!
     @IBOutlet var bgViewOfPicker: UIView!
     var isStartDate = true
    var customDates : (Date?,Date?) = (nil,nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        H_dateView.constant = 0.0
        self.setLocalization()
        
        if let langCode = getCurrentSelectedLanguageCode() {
            dateAndTimePicker.locale = Locale(identifier: langCode)
        }
        
        // Do any additional setup after loading the view.
        
        ActivityLog(module:Modules.quaotation.rawValue , message: ActivityMessages.quoteFilter)
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.filter_quotes
        txtQuoteDate.placeholder = LanguageKey.quote_date
        txtQuoteStatus.placeholder = LanguageKey.quote_status
        btnReset.setTitle(LanguageKey.reset , for: .normal)
        btnFilter.setTitle(LanguageKey.filter , for: .normal)
        lblStartDate.placeholder = LanguageKey.start_date
        lblEndDate.placeholder = LanguageKey.end_date
        btnDone.setTitle(LanguageKey.done, for: .normal)
        btnCancel.setTitle(LanguageKey.cancel, for: .normal)
    }
    
    
    @IBAction func btnActions(_ sender: UIButton) {
        sltBtn = sender.tag
        switch sender.tag{
        case 0:
            self.openDwopDown( txtField: self.txtQuoteStatus, arr: arrQuoteStatus)
            break
        default:
            self.openDwopDown( txtField: self.txtQuoteDate, arr: dateRange)
            break
        }
        
        
    }
    
    
    //==========================
    //MARK:- Open OptionalView
    //==========================
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height ), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            //self.scroll_View.isScrollEnabled = false
            self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                self.removeOptionalView()
            }
            
            // self.optionalVw = nil
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
            // self.scroll_View.isScrollEnabled = true
            // self.arrOfShowData.removeAll()
        }
    }
    
    //=====================================
    // MARK:- Option view Detegate
    //=====================================
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSelectedArr().count
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        cell?.textLabel?.textColor = UIColor.darkGray
        
        
        switch self.sltBtn {
        case 0:// Status
            showCheckMark(arry: selectedStatus, cell: cell!, row: indexPath.row)
            let status : String = String(describing: arrQuoteStatus[indexPath.row])
            cell?.textLabel?.text = status.capitalizingFirstLetter()
            break
            
        case 1: //Priority
            showCheckMark(arry: selectedDate, cell: cell!, row: indexPath.row)
            //let priroity : String = String(describing: dateRange[indexPath.row])
            cell?.textLabel?.text = dateRange[indexPath.row].rawValue
            break
            
        default: break
            
        }
        return cell!
        
    }
    
    func showCheckMark(arry : [Int], cell : UITableViewCell, row : Int ) -> Void {
        //Check if current indexpath row exist in  array , so we can show checkmark for this row
        if arry.contains(row){
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.sltBtn {
            
        case 0:
            addRemoveRowNumber(row: indexPath.row, array: &selectedStatus)
            showStatusOnTextField(arry: selectedStatus, textField: txtQuoteStatus, arryName: arrQuoteStatus)
            self.removeOptionalView()
            break
            
        case 1:
            
            self.customDates = (nil,nil)
            if dateRange[indexPath.row] == .CustomRange {
                self.H_dateView.constant = 60.0
                UIView.animate(withDuration: 0.5){
                    self.view.layoutIfNeeded()
                }
            }else{
                self.H_dateView.constant = 0.0
                UIView.animate(withDuration: 0.5){
                    self.view.layoutIfNeeded()
                }
            }
            
            
            if selectedDate.contains(indexPath.row)
            {
                if let index = selectedDate.firstIndex(of: indexPath.row) {
                    selectedDate.remove(at: index)
                     txtQuoteDate.text = ""
                }
            }else{
                selectedDate.removeAll()
                selectedDate.append(indexPath.row)
                 txtQuoteDate.text = dateRange[indexPath.row].rawValue
            }
 
            
            self.removeOptionalView()
            break
            
        default:
            break
        }
    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
    
    
    func getSelectedArr() -> [Any]{
        switch self.sltBtn {
        case 0:
            return arrQuoteStatus
        case 1:
            return dateRange
       
        default: break
            
        }
        
        return []
    }
    
    func addRemoveRowNumber(row: Int, array : inout [Int]) -> Void {
        //If indexpath row exist in this array so remove this index otherwise add this row in the array
        if array.contains(row)
        {
            if let index = array.firstIndex(of: row) {
                array.remove(at: index)
            }
        }else{
            array.append(row)
        }
    }
    
    func showStatusOnTextField(arry : [Int], textField : UITextField, arryName : [Any]) -> Void {
        var appendString = ""
       // if arry.count <= 3{
            for item in arry{
                let status : String = String(describing: arryName[item])
                if appendString == ""{
                    appendString = status
                }else{
                    appendString = appendString + ", \(status)"
                }
            }
            textField.text = appendString

    }
    
    @IBAction func btnReset(_ sender: Any) {
        self.txtQuoteDate.text = ""
        self.txtQuoteStatus.text = ""
        selectedStatus.removeAll()
        selectedDate.removeAll()
    }
    
    
    
    
    
    @IBAction func btnFilterButton(_ sender: Any) {
        if (self.callbackOfMultipleFilter != nil) && (selectedStatus .count>0 || selectedDate .count>0 )  {
            
            
            var arry = [QuoteStatusType]()
            //For add status value in selectedStatus
            for element in selectedStatus{
                arry.append(arrQuoteStatus[element])
            }
            
            
            
            //For add Priority value in selectedPriority
            var dateRangeString : DateRange? = nil
            for element in selectedDate{
                    dateRangeString = dateRange[element]
            }
            
            if dateRangeString == DateRange.CustomRange {
                if customDates.0 == nil {
                    ShowError(message: LanguageKey.please_select_start_date, controller: windowController)
                    return
                }else if customDates.1 == nil {
                    ShowError(message: LanguageKey.please_select_end_date, controller: windowController)
                    return
                }
            }
            
            
            if self.callbackOfMultipleFilter != nil {
                self.callbackOfMultipleFilter!(arry, dateRangeString, customDates)
            }
            
            self.navigationController?.popViewController(animated: true)
        }else{
            ShowError(message: AlertMessage.filterButton, controller: windowController)
        }
        
    }
    
    
    @IBAction func btnStartEndDates(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            isStartDate = true
            break
        default:
            isStartDate = false
            break
        }
        
        self.bgViewOfPicker.isHidden = false
        
    }
    
    
    
    @IBAction func btnDatePickerCancel(_ sender: Any) {
        self.bgViewOfPicker.isHidden = true
    }
    
    
    @IBAction func btnDatePickerDone(_ sender: Any) {
        
        self.bgViewOfPicker.isHidden = true
        let date = self.dateAndTimePicker.date
        let strDate = convertDateToString(date: date, dateFormate: DateFormate.ddMMMyyyy_hh_mm_a)
        
        if(isStartDate){
           // invDate = convertDateToString(date: date, dateFormate: DateFormate.dd_MM_yyyy_hh_mm_ss_a)
            let arr = strDate.components(separatedBy: " ")
            lblStartDate.text = arr[0]
            customDates.0 = date
            // lbl_SrtSchTime.text = arr[1] + " " + arr[2]
        }else{
           
               // dueDate = convertDateToString(date: date, dateFormate: DateFormate.dd_MM_yyyy_hh_mm_ss_a)
                let arr = strDate.components(separatedBy: " ")
                lblEndDate.text = arr[0]
                customDates.1 = date
                //  lbl_EndSchTime.text = arr[1] + " " + arr[2]
            
            
        }
        
    }
    
}
