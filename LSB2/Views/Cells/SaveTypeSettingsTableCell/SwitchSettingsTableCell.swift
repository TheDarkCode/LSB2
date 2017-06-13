//
//  SwitchSettingsTableCell.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 13.06.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

class SwitchSettingsTableCell: UITableViewCell, NibLoadableView, ReusableView {

    static let height: CGFloat = 40
    
    @IBOutlet private weak var ibTitle: UILabel!
    @IBOutlet private weak var ibSwitch: UISwitch!
    private var type: SettingsSwitchType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    @IBAction func switchAction(_ sender: Any) {
        guard type != nil else {return}
        
        switch type! {
        case .saveToPhotos:
            SettingsManager.instance.updateSettingsType(isPhotos: ibSwitch.isOn)
        default:
            break
        }
    }
    
    func update(with title: String, type: SettingsSwitchType, isOn: Bool) {
        ibTitle.text = title
        self.type = type
        ibSwitch.setOn(isOn, animated: false)
    }
    
}
