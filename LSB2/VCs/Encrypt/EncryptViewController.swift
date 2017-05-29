//
//  EncryptViewController.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 26.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit
import PKHUD

class EncryptViewController: UITableViewController, Alertable {

    fileprivate var choosenImage: UIImage?
    fileprivate var textToEncrypt: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(ActionTableCell.self)
        tableView.register(TextViewTableCell.self)
        tableView.register(ImagePickerTableCell.self)
        tableView.register(TitleTableCell.self)
        
        tableView.keyboardDismissMode = .onDrag
        
    }

    // MARK: - Table view data source

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
            titleCell.update(with: "2. Enter message:")
            cell = titleCell
        case 3:
            let textViewCell: TextViewTableCell = tableView.dequeueReusableCell(for: indexPath)
            textViewCell.ibTextView.delegate = self
            cell = textViewCell
        case 4:
            let actionCell: ActionTableCell = tableView.dequeueReusableCell(for: indexPath)
            actionCell.update(with: "Inject message")
            actionCell.actionHandler = { [unowned self] in
                self.savePhoto()
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

extension EncryptViewController: UITextViewDelegate {

    func textViewDidChangeSelection(_ textView: UITextView) {
        textToEncrypt = textView.text
    }
}

extension EncryptViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        choosenImage = image
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    fileprivate func savePhoto() {
        guard let image = choosenImage, let text = textToEncrypt, text != "" else {
            showMessage(title: "Error", message: "No image choosen or no text entered", handler: nil)
            return
        }
        
        HUD.show(.labeledProgress(title: "Encrypting..", subtitle: "Wait a few seconds"))
    
        Utils().encrypt(imageToEncrypt: image, message: text) { [unowned self] resultImage in
            HUD.hide()
            guard resultImage != nil else {
                self.showMessage(title: Constants.encryptingErrorMessage)
                return
            }
            
            guard let imageData = UIImagePNGRepresentation(resultImage!), let newImage = UIImage(data: imageData) else {
                self.showMessage(title: "Unknown error")
                return
            }
            UIImageWriteToSavedPhotosAlbum(newImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
    }
    
}

