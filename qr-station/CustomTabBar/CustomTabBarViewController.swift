//
//  CustomTabBarViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 30.05.2022.
//

import UIKit
import SnapKit

/// This class uses fake tab bar, the official one is hidden. For that reason, first pushed controllers need to be a subclass of the TabItemViewController, where hiding and showing the fake tab bar is handled. Also, viewcontrollers cannot set the .hidesbottombarwhenpushed, becasuse this causes the real tab bar to show up, covering up the fake tabbar. This custom tab bar was made by adjusting https://github.com/jcholuj/CustomTabBarExample
class CustomTabBarViewController: UITabBarController {

    let customTabBar = CustomTabBar()

     override func viewDidLoad() {
         super.viewDidLoad()
         setupHierarchy()
         setupLayout()
         setupProperties()
         bind()
         view.layoutIfNeeded()
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         //navigationController?.isNavigationBarHidden = true
     }
     
     private func setupHierarchy() {
         view.addSubview(customTabBar)
     }
     
     private func setupLayout() {
         customTabBar.snp.makeConstraints {
             $0.bottom.equalToSuperview().inset(24)
             $0.leading.trailing.equalToSuperview().inset(50)
             $0.height.equalTo(70)
         }
     }
     
     private func setupProperties() {
         tabBar.isHidden = true
         
         customTabBar.translatesAutoresizingMaskIntoConstraints = false
         //customTabBar.addShadow()
         
         selectedIndex = 0
         let controllers = CustomTabItem.allCases.map { $0.viewController }
         setViewControllers(controllers, animated: true)
     }

     private func selectTabWith(index: Int) {
         self.selectedIndex = index
     }
     
     //MARK: - Bindings
     
     private func bind() {
         customTabBar.itemTappedCompletion = { [weak self] i in
             self?.selectTabWith(index: i)
         }
        
     }

}
