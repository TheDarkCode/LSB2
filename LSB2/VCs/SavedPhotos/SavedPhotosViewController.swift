//
//  SavedPhotosViewController.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 12.06.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit
import MessageUI
import PKHUD

class SavedPhotosViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet private weak var noImagesLabel: UILabel!
    
    fileprivate var isNoImagesLabelHidden = true {
        didSet {
            noImagesLabel.isHidden = isNoImagesLabelHidden
        }
    }
    
    fileprivate var showedTextItemId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: Constants.tabmanBarHeight + 10, left: 0, bottom: 0, right: 0)
        collectionView.register(SavedImageCollectionCell.self)
        setupNoImagesLabel()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset.left = 2
            flowLayout.sectionInset.right = 2
            flowLayout.sectionInset.top = 2
            flowLayout.sectionInset.bottom = 2
            let width = UIScreen.main.bounds.width / 2.1
            flowLayout.itemSize.width = width
            flowLayout.itemSize.height = width
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(imagesLoaded), name: .StorageUpdated, object: nil)
     
        DataManager.instance.loadImages()
    }
    
    private func setupNoImagesLabel() {
        noImagesLabel.font = UIFont.boldSystemFont(ofSize: 16)
        noImagesLabel.text = "No images found"
        isNoImagesLabelHidden = true
    }
    
    private func sendMail(with image: UIImage) {
        if MFMailComposeViewController.canSendMail() {
            navigationController?.isNavigationBarHidden = false
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setMessageBody("", isHTML: false)
            let imageData: Data = UIImagePNGRepresentation(image)!
            mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "imageName")
            self.present(mail, animated: true, completion: nil)
        }
    }
    
    private func reloadImageWithDecryptedTextIfNeeded(newId: Int) {
        if showedTextItemId != -1, showedTextItemId < DataManager.instance.images.count {
            let oldIndexPath = IndexPath(item: showedTextItemId, section: 0)
            showedTextItemId = newId
            collectionView.reloadItems(at: [oldIndexPath])
        }
    }
    
    private func showTextOnItem(with id: Int) {
        reloadImageWithDecryptedTextIfNeeded(newId: id)
        showedTextItemId = id
        let newIndexPath = IndexPath(item: id, section: 0)
        collectionView.reloadItems(at: [newIndexPath])
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        navigationController?.isNavigationBarHidden = false
        controller.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func chooseAction(id: Int, image: UIImage) {
        let alertSheet = UIAlertController(title: "Choose action", message: nil, preferredStyle: .actionSheet)
        
        alertSheet.addAction(UIAlertAction(title: "Decrypt text", style: .default) { action in
            self.showTextOnItem(with: id)
        })
        
        alertSheet.addAction(UIAlertAction(title: "Send via Email", style: .default) { action in
            self.sendMail(with: image)
        })
        
        alertSheet.addAction(UIAlertAction(title: "Delete", style: .destructive) { action in
            self.reloadImageWithDecryptedTextIfNeeded(newId: -1)
            DataManager.instance.remove(imageWith: id)
            let indexPath = IndexPath(item: id, section: 0)
            self.collectionView.deleteItems(at: [indexPath])
        })
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertSheet, animated: true, completion: nil)
    }
    
}

extension SavedPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isNoImagesLabelHidden = !DataManager.instance.images.isEmpty
        return DataManager.instance.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SavedImageCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if indexPath.row == showedTextItemId {
            HUD.show(.progress)
            Utils().decrypt(image: DataManager.instance.images[indexPath.row]) { result in
                HUD.hide()
                cell.update(with: DataManager.instance.images[indexPath.row],
                            name: DataManager.instance.names[indexPath.row].cuttedToShortDate(),
                            showText: true,
                            text: result)
            }
        } else {
            cell.update(with: DataManager.instance.images[indexPath.row], name: DataManager.instance.names[indexPath.row].cuttedToShortDate())
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showedTextItemId == indexPath.row {
            showedTextItemId = -1
            collectionView.reloadItems(at: [indexPath])
        } else {
            let image = DataManager.instance.images[indexPath.row]
            chooseAction(id: indexPath.row, image: image)
        }
    }
    
}

//MARK: - Notification handler
extension SavedPhotosViewController {
    @objc fileprivate func imagesLoaded() {
        collectionView.reloadData()
    }
}
