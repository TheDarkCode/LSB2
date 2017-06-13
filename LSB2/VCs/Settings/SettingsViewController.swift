//
//  SettingsViewController.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 13.06.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.register(SwitchSettingsTableCell.self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch indexPath.row {
        case 0:
            let saveTypeCell: SwitchSettingsTableCell = tableView.dequeueReusableCell(for: indexPath)
            if let isOn = SettingsManager.instance.settings[Constants.saveToPhotosKey] as? Bool, isOn == true {
                saveTypeCell.update(with: "Save also to Photos", type: .saveToPhotos, isOn: true)
            } else {
                saveTypeCell.update(with: "Save also to Photos", type: .saveToPhotos, isOn: false)
            }
            cell = saveTypeCell
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.tabmanBarHeight + 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return SwitchSettingsTableCell.height
        default:
            return 0
        }
    }
    
}
