//
//  TabItemViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 30.05.2022.
//

import UIKit

class TabItemViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tab = tabBarController as? CustomTabBarViewController {
            UIView.animate(withDuration: 0.4) { [weak tab] in
                tab?.customTabBar.alpha = 0
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tab = tabBarController as? CustomTabBarViewController {
            UIView.animate(withDuration: 0.4) { [weak tab] in
                tab?.customTabBar.alpha = 1
            }
        }
    }

}
