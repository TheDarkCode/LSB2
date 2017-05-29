//
//  TextViewTableCell.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 26.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

class TextViewTableCell: UITableViewCell, UITextViewDelegate, ReusableView, NibLoadableView {

    static let height: CGFloat = 140
    
    @IBOutlet weak var ibTextView: UITextView!
    var delegate: UITextViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ibTextView.layer.borderWidth = 1
        ibTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        delegate = ibTextView.delegate
    }


}
