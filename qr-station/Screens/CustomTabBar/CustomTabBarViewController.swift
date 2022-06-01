//
//  CustomTabBarViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 30.05.2022.
//

import UIKit
import SnapKit

/** This class uses fake tab bar, the official one is hidden. For that reason, first pushed controllers need to be a subclass of the TabItemViewController, where hiding and showing the fake tab bar is handled. Also, viewcontrollers cannot set the .hidesbottombarwhenpushed, becasuse this causes the real tab bar to show up, covering up the fake tabbar. This custom tab bar was made by adjusting https://github.com/jcholuj/CustomTabBarExample , but RxSwift code was replaced with closures and tapgesturerecognizers because it is less code.
 
    The custom tab bar has this structure:
    1. CustomTabBarViewController - the top most layer, one of its views is the CustomTabBar
    2. CustomTabBar - StackView containing multiple CustomTabItemViews
    3. CustomTabItemView - A view containing CustomTabItem info
 
    CustomTabItem - enum specifying the tab item
 */
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
         customTabBar.layer.shadowColor = UIColor.label.cgColor // does not refresh right away when system changes from dark mode to light mode
         customTabBar.layer.shadowOffset = .zero
         customTabBar.layer.shadowOpacity = 0.4
         customTabBar.layer.shadowRadius = 7
         
         selectedIndex = 0
         // Create the controllers contained in the tab bar
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
