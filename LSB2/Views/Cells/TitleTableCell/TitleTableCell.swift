//
//  TitleTableCell.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 26.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

class TitleTableCell: UITableViewCell, ReusableView, NibLoadableView {

    static let height: CGFloat = 40
    
    @IBOutlet private weak var ibTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func update(with title: String) {
        ibTitle.text = title
    }
    
}
