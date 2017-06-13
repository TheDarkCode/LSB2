//
//  DataManager.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 12.06.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

class DataManager {
    
    private init() {}
    static let instance = DataManager()
    private(set) var images: [UIImage] = []
    private(set) var names: [String] = []
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func saveToDocuments(image: UIImage, name: String) {
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            
            
            try? data.write(to: filename)
            
            print("image named \(name) saved to ~/Documents/")
        }
    }
    
    private func removeFromDocuments(name: String)  {
        let fileName = self.getDocumentsDirectory().appendingPathComponent(name)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: fileName)
        print("Deleting \(fileName)")
    }
    
    
    func remove(imageWith id: Int) {
        let imageName = names[id]
        removeFromDocuments(name: imageName)
        images.remove(at: id)
        names.remove(at: id)
        UserDefaults.standard.set(names, forKey: "names")
    }
    
    func save(image: UIImage) {
        let imgName = Date().toFullString()
        saveToDocuments(image: image, name: imgName)
        images.append(image)
        names.append(imgName)
        UserDefaults.standard.set(names, forKey: "names")
        NotificationCenter.default.post(name: .StorageUpdated, object: nil)
    }
    
    func loadImages() {
        self.images.removeAll()
        DispatchQueue.global().async {
            if let namesArray =  UserDefaults.standard.array(forKey: "names") as? [String] {
                self.names = namesArray
                for name in namesArray {
                    let filename = self.getDocumentsDirectory().appendingPathComponent(name)
                    guard let image = UIImage(contentsOfFile: filename.path) else {return}
                    self.images.append(image)
                }
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .StorageUpdated, object: nil)
            }
        }
        
    }
    
    
}
