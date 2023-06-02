//
//  FileManagerWrapper.swift
//
//
//  Created by 1/19/22.
//  Copyright © 2022 EyeOnTask Inc. All rights reserved.
//

import Foundation

class FileManagerWrapper: NSObject {
    func createDirectory(at path: URL) {
        do {
            let manager = FileManager.default
            if !manager.fileExists(atPath: path.relativePath) {
                try manager.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createFile(at path: URL) {
        let manager = FileManager.default
        if !manager.fileExists(atPath: path.relativePath) {
            manager.createFile(atPath: path.relativePath, contents: nil, attributes: nil)
        }
    }
    
    func removeFile(at path: URL) {
        let manager = FileManager.default
        do {
            try manager.removeItem(atPath: path.relativePath)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fileExists(at path: URL) -> Bool {
        let manager = FileManager.default
        return manager.fileExists(atPath: path.relativePath)
    }
    

}
