//
//  Date+Extension.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 12.06.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import Foundation

extension Date {
    func toString(withSeparationSymbol separationSymbol: Character = "-") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy\(separationSymbol)MM\(separationSymbol)dd"
        return dateFormatter.string(from: self)
    }
    
    func toFullString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
