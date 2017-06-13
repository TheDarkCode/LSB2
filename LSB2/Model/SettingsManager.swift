//
//  SettingsManager.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 13.06.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

enum SettingsSwitchType {
    case saveToPhotos
    case useCustomKey
}

class SettingsManager {
    private init(){}
    static let instance = SettingsManager()
    
    private(set) var settings: [String: Any] = [:]
    
    func updateSettingsType(isPhotos: Bool) {
        settings[Constants.saveToPhotosKey] = isPhotos
        updateUserDefaults()
    }
    
    func update() {
        fetchFromUserDefaults()
    }
    
    private func updateUserDefaults() {
        UserDefaults.standard.set(settings, forKey: "settings")
    }
    
    private func fetchFromUserDefaults() {
        if let tmpSettings = UserDefaults.standard.dictionary(forKey: "settings") {
            settings = tmpSettings
        } else {
            debugPrint("Cannot fetch user defaults :(")
        }
    }
    
}
