//
//  fourthTableViewCell.swift
//  EyeOnTask
//
//  Created by Mac on 05/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class fourthTableViewCell: UITableViewCell , OptionViewDelegate  {
  
    
    var optionalVw : OptionalView?
    let cellReuseIdentifier = "cell"
    var arrOFShowData = [Any]()
    var callBack: ((Bool , OptDetals , Int) -> Void)?
    var sltItem : String?



    @IBOutlet var lbl_Ans: UILabel!
    @IBOutlet var lbl_Qstn: UILabel!
    @IBOutlet weak var numberlbl: UILabel!
    @IBOutlet var bgViewOFBtn: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbl_Ans.text = LanguageKey.select_option
    }

    @IBAction func BtnActionMethod(_ sender: Any) {
        
        self.openDwopDown(view: bgViewOFBtn, arr: arrOFShowData)
        
    }
    
    
    func openDwopDown(view : UIView , arr : [Any]) {
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = bgViewOFBtn.convert(bgViewOFBtn.bounds, to: windowController.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: bgViewOFBtn.frame.origin.x, y: (sltTxtfldFrm.origin.y + bgViewOFBtn.frame.size.height), width: self.bgViewOFBtn.frame.size.width , height: CGFloat((arr.count > 5) ? 150 : arr.count*38)))
            self.optionalVw?.delegate = self
            windowController.view.addSubview( self.optionalVw!)
            
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
        }
    }
    //====================================================
    //MARK:- OptionView Delegate Methods
    //====================================================
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOFShowData.count
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        //cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
        cell?.textLabel?.textColor = UIColor.darkGray
        let arrOFOptDetals = arrOFShowData[indexPath.row] as? OptDetals
        cell?.textLabel?.text =  arrOFOptDetals?.value
        
       if sltItem == arrOFOptDetals?.value {
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark

       }else{
            cell?.accessoryType = UITableViewCell.AccessoryType.none
        }
//
//        if APP_Delegate.tempArray.count != 0  {
//            let arrOdAns = APP_Delegate.tempArray[0]["answer"] as? [[String : Any]]
//            if arrOdAns?.index(where: { ((($0)["ans"]! as! [String : Any])["key"] as! String) == arrOFOptDetals?.key }) != nil {
//
//                    cell?.accessoryType = UITableViewCellAccessoryType.checkmark
//
//            }else{
//                cell?.accessoryType = UITableViewCellAccessoryType.none
//
//            }
//        }
        
        
   
        return cell!
        
    }
    
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.removeOptionalView()

        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark){
            if self.callBack != nil {
                self.callBack!(false , (arrOFShowData[indexPath.row] as? OptDetals)! ,  (indexPath.row + 1))
            }
        }else{
            if self.callBack != nil {
                self.callBack!(true , (arrOFShowData[indexPath.row] as? OptDetals)! , (indexPath.row + 1))
            }
        }
        
        

    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
