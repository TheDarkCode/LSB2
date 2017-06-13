//
//  String+Extensions.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 26.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

extension String {
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    func cuttedToShortDate() -> String {
        let index = self.index(self.startIndex, offsetBy: 10)
        return self.substring(to: index)
    }
    
    func stroked(size: CGFloat) -> NSMutableAttributedString {
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSStrokeWidthAttributeName : -4.0,
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: size)
            ] as [String : Any]
        
        let customizedText = NSMutableAttributedString(string: self,
                                                       attributes: strokeTextAttributes)
        return customizedText
    }
}
