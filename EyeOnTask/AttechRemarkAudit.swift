//
//  AttechRemarkAudit.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 19/07/21.
//  Copyright © 2021 Hemant. All rights reserved.
//

import UIKit

class AttechRemarkAudit:UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
     var objOfUserJobListInDoc = AuditOfflineList()
           var equipment : equipDataArray?
        
        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
        }
        
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           self.navigationItem.title = LanguageKey.title_documents
    }

         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                //return self.arrOfFilterData..count > 0 ? self.arrOfFilterData.count :  self.arrOfShowData.count
                return self.equipment?.attachments?.count ?? 0
                // return self.arrOfShowData1.count
            }
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageDetailCell", for: indexPath as IndexPath) as! ImageDetailCell
                // let docResDataDetailsObj = self.arrOfShowData?.attachments?[indexPath.row]
                let docResDataDetailsObj = self.equipment?.attachments?[indexPath.row]
                cell.lblfileName.text = docResDataDetailsObj?.attachFileActualName
                
                if let img = docResDataDetailsObj?.attachThumnailFileName {
                    let imageUrl = Service.BaseUrl + img
                    cell.imageView.sd_setImage(with: URL(string: imageUrl) , placeholderImage: getImage(fileType: docResDataDetailsObj?.image_name ?? "unknownDoc"))
                }else{
                    cell.imageView.image = UIImage(named: "unknownDoc")
                }
                return cell
            }
           
        func getImage(fileType : String) -> UIImage {
               
               //'jpg','png','jpeg','pdf','doc','docx','xlsx','csv','xls'
               
               let filename: NSString = fileType as NSString
               let pathExtention = filename.pathExtension
               
               var imageName = ""
               switch pathExtention {
               case "jpg","png","jpeg":
                   imageName = "default-thumbnail"
                   
               case "pdf":
                   imageName = "pdf"
                   
               case "doc","docx":
                   imageName = "word"
                   
               case "xlsx","xls":
                   imageName = "excel"
                   
               case "csv":
                   imageName = "csv"
                   
               default:
                   imageName = "unknownDoc"
               }
               
               let image = UIImage(named: imageName)
               return image!
               
           }
        

    }
