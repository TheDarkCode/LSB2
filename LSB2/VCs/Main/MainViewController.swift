//
//  MainViewController.swift
//  LSB2
//
//  Created by Alexander Kravchenko on 14.05.17.
//  Copyright © 2017 Askrav's Inc. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class MainViewController: TabmanViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        self.view.backgroundColor = .white
        
        self.bar.style = .scrollingButtonBar
        self.bar.appearance = TabmanBar.Appearance({ appearance in
            appearance.indicator.isProgressive = false
            appearance.layout.edgeInset = self.view.bounds.width / 2
            appearance.layout.height = TabmanBar.Height.explicit(value: Constants.tabmanBarHeight)
        })
        
    }

   

}


extension MainViewController: PageboyViewControllerDataSource {
    
    func viewControllers(forPageboyViewController pageboyViewController: PageboyViewController) -> [UIViewController]? {
        
        let VCs = [EncryptViewController(), DecryptViewController()]
        
        self.bar.items = [TabmanBarItem(title: "Encrypt"),
                          TabmanBarItem(title: "Decrypt")]
        
        return VCs
    }
    
    func defaultPageIndex(forPageboyViewController pageboyViewController: PageboyViewController) -> PageboyViewController.PageIndex? {
        return nil
    }
    
}
