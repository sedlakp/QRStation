//
//  CustomTabBarItem.swift
//  qr-station
//
//  Created by Petr Sedlák on 30.05.2022.
//

import Foundation
import UIKit

enum CustomTabItem: String, CaseIterable {
    case dashboard
    case list
}
 
extension CustomTabItem {
    var viewController: UIViewController {
        switch self {
        case .dashboard:
            let vc = DashboardViewController()
            vc.customTabItem = .dashboard
            let nc = UINavigationController(rootViewController: vc)
            return nc
        case .list:
            let vc = QRListViewController()
            vc.customTabItem = .list
            let nc = UINavigationController(rootViewController: vc)
            return nc
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .dashboard:
            return UIImage(systemName: "qrcode")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        case .list:
            return UIImage(systemName: "list.dash")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .dashboard:
            return UIImage(systemName: "qrcode")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        case .list:
            return UIImage(systemName: "list.dash")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        }
    }
    
    var name: String {
        return self.rawValue.capitalized
    }
}
