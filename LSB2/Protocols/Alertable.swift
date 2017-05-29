//
//  Alertable.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 26.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit

protocol Alertable {
    func showMessage(title: String?, message: String?, handler: (() -> Void)?)
}

extension Alertable where Self: UIViewController {
    
    func showMessage(title: String?, message: String? = nil, handler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
            handler?()
        })
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
