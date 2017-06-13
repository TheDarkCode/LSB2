//
//  DecryptViewController.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 26.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit
import PKHUD

class DecryptViewController: UITableViewController, Alertable {

    fileprivate var choosenImage: UIImage?
    fileprivate var decryptedText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.register(ActionTableCell.self)
        tableView.register(TextViewTableCell.self)
        tableView.register(ImagePickerTableCell.self)
        tableView.register(TitleTableCell.self)
        
        tableView.keyboardDismissMode = .onDrag
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.row {
        case 0:
            let titleCell: TitleTableCell = tableView.dequeueReusableCell(for: indexPath)
            titleCell.update(with: "1. Choose image:")
            cell = titleCell
        case 1:
            let imageCell: ImagePickerTableCell = tableView.dequeueReusableCell(for: indexPath)
            imageCell.chooseImageHandler = { [unowned self] in
                self.launchLibrary()
            }
            imageCell.set(image: choosenImage)
            cell = imageCell
        case 2:
            let titleCell: TitleTableCell = tableView.dequeueReusableCell(for: indexPath)
            titleCell.update(with: "2. Decrypted message:")
            cell = titleCell
        case 3:
            let textViewCell: TextViewTableCell = tableView.dequeueReusableCell(for: indexPath)
            textViewCell.ibTextView.isEditable = false
            textViewCell.ibTextView.text = decryptedText ?? ""
            cell = textViewCell
        case 4:
            let actionCell: ActionTableCell = tableView.dequeueReusableCell(for: indexPath)
            actionCell.update(with: "Extract message")
            actionCell.actionHandler = { [unowned self] in
                self.extractMessage()
            }
            cell = actionCell
        default:
            preconditionFailure("Unable to deque a cell")
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0,2:
            return TitleTableCell.height
        case 1:
            return ImagePickerTableCell.height
        case 3:
            return TextViewTableCell.height
        case 4:
            return ActionTableCell.height
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return Constants.tabmanBarHeight + 40
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
        
    }
    
}


extension DecryptViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        choosenImage = image
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    fileprivate func extractMessage() {
        guard let image = choosenImage else {
            showMessage(title: "Error", message: "No image choosen", handler: nil)
            return
        }
        HUD.show(.labeledProgress(title: "Decrypting..", subtitle: "Wait a few seconds"))
        Utils().decrypt(image: image) { [unowned self] result in
            HUD.hide()
            self.decryptedText = result
            self.tableView.reloadData()
        }
    }
    
}



