//
//  ImagePickerTableCell.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 26.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

class ImagePickerTableCell: UITableViewCell, ReusableView, NibLoadableView {

    static let height: CGFloat = 160
    
    var chooseImageHandler: (() -> (Void))?
    
    @IBOutlet private weak var ibChooseImageButton: UIButton!
    @IBOutlet private weak var ibImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ibImage.backgroundColor = .clear
        ibChooseImageButton.setTitle("Open Gallery", for: .normal)
    }

    @IBAction private func chooseImage(_ sender: Any) {
        chooseImageHandler?()
    }
    
    func set(image: UIImage?) {
        if let newImage = image {
            ibImage.backgroundColor = .white
            ibImage.image = newImage
        } else {
            ibImage.backgroundColor = .clear
        }
    }
    
}
