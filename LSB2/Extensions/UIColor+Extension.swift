//
//  UIColor+Extension.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 26.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red) / 255.0
        let newGreen = CGFloat(green) / 255.0
        let newBlue = CGFloat(blue) / 255.0
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    class var lightBlue: UIColor {
        return UIColor(red: 13, green: 152, blue: 179)
    }
}
