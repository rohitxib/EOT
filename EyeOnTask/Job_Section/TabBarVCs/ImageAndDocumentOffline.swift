//
//  ImageAndDocumentOffline.swift
//  EyeOnTask
//
//  Created by Aplite ios on 30/03/23.
//  Copyright © 2023 Hemant. All rights reserved.
//

import UIKit

class ImageAndDocumentOffline: NSObject {

    static let imageShareIntance = ImageAndDocumentOffline()
    
    func getOfflinePhotos(imageNamed name: String) -> UIImage? {
           guard let imagePath = path(for: name) else {
               return nil
           }
           return UIImage(contentsOfFile: imagePath.path)
       }
    //let demoImage: UIImage = UIImage(named: "gallery-2")!
   
    func saveOfflinePhotos(image: UIImage, name: String) throws {
       // image.jpegData(compressionQuality: 0.5)
        let imageName = "Photo_\(Int(Date().timeIntervalSince1970)).jpg"
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
               
                return
            }
    
            guard let imagePath = path(for: name) else {
                
                return
            }
            try imageData.write(to: imagePath)
        }


    private func path(for imageName: String, fileExtension: String = "png") -> URL? {
         let imageDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("EyeOnTaskImages")
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            if let folderPath = imageDirectory {
                FileManagerWrapper().createDirectory(at: folderPath)
            }
            
            return directory?.appendingPathComponent("appImages").appendingPathComponent(imageName)
        }
    }
