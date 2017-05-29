//
//  ActionTableCell.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 26.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

class ActionTableCell: UITableViewCell, ReusableView, NibLoadableView {

    static let height: CGFloat = 80
    
    @IBOutlet private weak var ibButton: UIButton!
    
    var actionHandler: (() -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ibButton.layer.cornerRadius = ibButton.bounds.height / 2
        ibButton.backgroundColor = UIColor.lightBlue
        ibButton.tintColor = .white
    }

    @IBAction func action(_ sender: Any) {
        actionHandler?()
    }
   
    
    func update(with title: String) {
        ibButton.setTitle(title, for: .normal)
    }
}
