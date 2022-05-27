//
//  TabsController.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import UIKit

class TabsController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
        delegate = self
        
        let vc2 = makeQrListController()
        let vc1 = makeDashboardController()
        
        self.viewControllers = [vc1,vc2]
        
        // this makes the tab bar not transparent on new iOS version
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .regular)
            tabBar.scrollEdgeAppearance = appearance
        }
    }

    func makeQrListController() -> UINavigationController {
        let vc = QRListViewController(nibName: "QRListViewController", bundle: nil)
        vc.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.dash"), tag: 0)
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
    
    func makeDashboardController() -> UINavigationController {
        let vc = DashboardViewController(nibName: "DashboardViewController", bundle: nil)
        vc.tabBarItem = UITabBarItem(title: "QR", image: UIImage(systemName: "qrcode"), tag: 1)
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }

}


extension TabsController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected Controller: \(viewController.title)")
    }
}
