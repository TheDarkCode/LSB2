//
//  SavedImageCollectionCell.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 12.06.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

class SavedImageCollectionCell: UICollectionViewCell, NibLoadableView, ReusableView {

    @IBOutlet private weak var ibImageView: UIImageView!
    @IBOutlet private weak var ibDateLabel: UILabel!
    @IBOutlet private weak var ibTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ibDateLabel.font = UIFont.boldSystemFont(ofSize: 14)
        ibDateLabel.textColor = .white
        ibDateLabel.textAlignment = .center
        
        ibTextView.backgroundColor = .clear
        ibTextView.isUserInteractionEnabled = false
    }

    func update(with image: UIImage, name: String, showText: Bool = false, text: String? = nil) {
        ibImageView.image = image
        ibDateLabel.attributedText = name.stroked(size: 14)
        
        if showText {
            guard let decryptedText = text else {return}
            ibTextView.attributedText = decryptedText.stroked(size: 14)
        } else {
            ibTextView.attributedText = NSAttributedString(string: "")
        }
    }
    
}
