//
//  EquipmentCell.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 15/11/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class EquipmentCell: UITableViewCell {
    
    
    @IBOutlet weak var partLineLbl: UILabel!
    @IBOutlet weak var H_dateLabel: NSLayoutConstraint!
    @IBOutlet weak var newCheckImg: UIImageView!
    @IBOutlet weak var checkImage: UIButton!
    @IBOutlet weak var tabImgBtn: UIButton!
    @IBOutlet weak var checkUnCheckImg: UIImageView!
    @IBOutlet weak var deployDateLbl: UILabel!
    @IBOutlet weak var deployLbl: UILabel!
    @IBOutlet weak var deployView: UIView!
    @IBOutlet weak var partCollactionView: UICollectionView!
    @IBOutlet weak var image_H: NSLayoutConstraint!
    @IBOutlet weak var EqpName_H: NSLayoutConstraint!
    @IBOutlet weak var part_H: NSLayoutConstraint!
    @IBOutlet weak var modal_H: NSLayoutConstraint!
    @IBOutlet weak var viewDetail_H: NSLayoutConstraint!
    @IBOutlet weak var addrs_H: NSLayoutConstraint!
    @IBOutlet weak var serialNo_H: NSLayoutConstraint!
    @IBOutlet weak var remark_H: NSLayoutConstraint!
    @IBOutlet weak var dropDownPartBtn: UIButton!
    @IBOutlet weak var partView_H: NSLayoutConstraint!
    @IBOutlet weak var partBtn: UIButton!
    @IBOutlet weak var partLbl1: UILabel!
    @IBOutlet weak var attechRemrkBtn: UIButton!
    @IBOutlet weak var remarkEditBt: UIButton!
    @IBOutlet weak var remarkNewBtn: UIButton!
    @IBOutlet weak var imgCount: UILabel!
    @IBOutlet weak var remarkView_H: NSLayoutConstraint!
    @IBOutlet weak var imgView_H: NSLayoutConstraint!
    @IBOutlet weak var remarkDisc: UILabel!
    @IBOutlet weak var imgThird: UIImageView!
    @IBOutlet weak var imgSecond: UIImageView!
    @IBOutlet weak var imgFirst: UIImageView!
    @IBOutlet weak var partLbl: UILabel!
    @IBOutlet weak var unlinkBtnAct: UIButton!
    @IBOutlet weak var leftAuditLink_H: NSLayoutConstraint!
    @IBOutlet weak var rightAuditLink_H: NSLayoutConstraint!
    @IBOutlet weak var leftJobLink_H: NSLayoutConstraint!
    @IBOutlet weak var rightJobLink_H: NSLayoutConstraint!
    @IBOutlet weak var unLinkBtn: UIButton!
    @IBOutlet weak var auditLinkStatusLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var linkBtnAct: UIButton!
    @IBOutlet weak var link_Lbl: UILabel!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftview: UIView!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var remarkLbl: UILabel!
    @IBOutlet weak var conditationLbl: UILabel!
    @IBOutlet weak var imageEquip: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var equipmentImg: UIImageView!
    @IBOutlet weak var lblSerialNo: UILabel!
    @IBOutlet weak var lblModelNo: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnRemark: UIButton!
    @IBOutlet weak var btnDefaults: UIButton!
    
    var poIdNam = ""
    var equipmentsStatus = [getEquipmentStatusDate]()
    var filterequipmentData : equipDataArray?
   // var filterequipmentDataNew : equipDataArray?
    var delegate : partEqDelegate?
    override func awakeFromNib() {
    super.awakeFromNib()
        getEquipmentStatus()
        var isSwitchOff = ""
        isSwitchOff =   UserDefaults.standard.value(forKey: "partView_H") as? String ?? ""
         
        if isSwitchOff == "On" {
            partCollactionView.delegate = self
            partCollactionView.dataSource = self
        }
      
   
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
    }
    
    func setPartData(equipArray:equipDataArray) {
        filterequipmentData = equipArray
        partCollactionView.reloadData()
    }
    //==================================
    // MARK:- Equipement LIST Service methods
    //==================================
    func getEquipmentStatus(){
        
        if !isHaveNetowork() {
//            if self.refreshControl.isRefreshing {
//                self.refreshControl.endRefreshing()
//            }
            killLoader()
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            
            return
        }
        
        
        
        let param = Params()
   
        param.limit = ""
        param.index = "0"
        param.isCondition = "1"
      
        
        serverCommunicator(url: Service.getEquipmentStatus, param: param.toDictionary) { (response, success) in
            
               DispatchQueue.main.async {
//                   if self.refreshControl.isRefreshing {
//                       self.refreshControl.endRefreshing()
//                   }
               }
              
            
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(getEquipmentStatusRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        if decodedData.data!.count > 0 {
                            self.equipmentsStatus = decodedData.data!
                            DispatchQueue.main.async {
                                var isSwitchOff = ""
                                isSwitchOff =   UserDefaults.standard.value(forKey: "partView_H") as? String ?? ""
                                if isSwitchOff == "On" {
                                    self.partCollactionView.reloadData()
                                }
                          
                            }
                            print(self.equipmentsStatus)
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
                            self.getEquipmentStatus()
                        }
                    })
                }
            }else{
                killLoader()
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        self.getEquipmentStatus()
                    }
                })
            }
        }
    }
}

extension EquipmentCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return  self.filterequipmentData?.equComponent?.count ?? 0
       // self.equipment?.equComponent?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartCollectionCell", for: indexPath as IndexPath) as! PartCollectionCell
        
        let modl = LanguageKey.model_no
        let serl = LanguageKey.serial_no
      
        
        let equipmentPartData = filterequipmentData?.equComponent?[indexPath.row]
        
        if  equipmentPartData?.equStatus == "1" {
            
            cell.deployView.isHidden = true
            
        }else{
            if  equipmentPartData?.equStatus != "" {
                
                for poIdnm in equipmentsStatus {
                    
                    if  poIdnm.esId == equipmentPartData?.equStatus {
                        
                        self.poIdNam = poIdnm.statusText ?? ""
                        
                        cell.deployLbl.text = poIdNam
                        if poIdNam == "Deployed" {
                            cell.deployLbl.text = LanguageKey.deployed
                            cell.deployView.backgroundColor =  UIColor(red: 238/255.0, green: 174/255.0, blue: 91/255.0, alpha: 1.0)
                            cell.deployLbl.textColor =  UIColor.white//UIColor(red: 231/255.0, green: 192/255.0, blue: 125/255.0, alpha: 1.0)
                            cell.deployDateLbl.textColor = UIColor.white //UIColor(red: 231/255.0, green: 192/255.0, blue: 125/255.0, alpha: 1.0)
                        }else if poIdNam == "Discarded" {
                            cell.deployView.backgroundColor =  UIColor(red: 249/255.0, green: 110/255.0, blue: 114/255.0, alpha: 1.0)
                            cell.deployLbl.textColor =  UIColor.white//UIColor(red: 179/255.0, green: 61/255.0, blue: 50/255.0, alpha: 1.0)
                            cell.deployDateLbl.textColor =   UIColor.white//UIColor(red: 179/255.0, green: 61/255.0, blue: 50/255.0, alpha: 1.0)
                        }
                        
                    }
                }
                
            }
        }
        
        if equipmentPartData?.statusUpdateDate != "" {
            cell.deployDateLbl.text = convertTimestampToDateForPayment(timeInterval: (equipmentPartData?.statusUpdateDate ?? ""))
        }else{
            cell.deployDateLbl.text = ""
        }
       
        
        
        let aa = equipmentPartData?.image

        if aa != nil {
            let ar = URL(string: Service.BaseUrl)?.absoluteString
            let ab = equipmentPartData?.image

            var ii:URL = URL(string: ar! + ab!)!

            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: ii) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.imagePart.image = image
                        }
                    }
                }
            }

        }


        cell.desktopLbl.text = equipmentPartData?.equnm
        cell.modelLbl.text = "\(modl) : \(equipmentPartData?.mno ?? "")"
        cell.serialNoLbl.text = "\(serl) : \(equipmentPartData?.sno ?? "")"
        cell.adrsLbl.text = equipmentPartData?.location

        cell.remarkBtn.addTarget(self, action: #selector(buttonPressedRemarkIsPart), for: .touchUpInside)
        cell.remarkBtn.tag = indexPath.row

        cell.viewDetailBtn.addTarget(self, action: #selector(buttonPressedRemarkDetailIpart), for: .touchUpInside)
        cell.viewDetailBtn.tag = indexPath.row


       
        return cell
    }
    
    @objc func buttonPressedRemarkDetailIpart(_ sender: UIButton) {
        
        var dataModal = filterequipmentData?.equComponent?[sender.tag]
       // delegate?.showpartEqView(equipArray: dataModal)
        
 
       
    }
    
    @objc func buttonPressedRemarkIsPart(_ sender: UIButton) {
        
        var dataModal = filterequipmentData?.equComponent?[sender.tag]
     //   delegate?.showpartRemarkView(filterArry: dataModal)
       
    }
}

 protocol partEqDelegate {
     
     func showpartEqView(equipArray:equipDataArray)
     func showpartRemarkView(filterArry :equipDataArray)

}
