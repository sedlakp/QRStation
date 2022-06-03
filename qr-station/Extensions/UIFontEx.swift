//
//  UIFontEx.swift
//  qr-station
//
//  Created by Petr Sedlák on 03.06.2022.
//

import Foundation
import UIKit

extension UIFont {
    /// Font and sizes used in the app
    static let appFont = AppFont()
    
    struct AppFont {
        let title = UIFont.systemFont(ofSize: 30, weight: .semibold)
        let text = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let tiny = UIFont.systemFont(ofSize: 9, weight: .semibold)
        let smallTitle = UIFont.systemFont(ofSize: 16, weight: .bold)
        let mini = UIFont.systemFont(ofSize: 11, weight: .semibold)
    }
}
