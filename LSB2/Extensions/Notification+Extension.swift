//
//  Notification+Extension.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 29.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let FinishedDecrypting = Notification.Name("FinishedDecrypting")
    
    static let LoadedFromLocalStorage = Notification.Name("LoadedFromLocalStorage")
}
