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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ibDateLabel.font = UIFont.boldSystemFont(ofSize: 14)
        ibDateLabel.textColor = .white
        ibDateLabel.textAlignment = .center
    }

    func update(with image: UIImage, name: String) {
        ibImageView.image = image
        ibDateLabel.text = name
    }
    
}
