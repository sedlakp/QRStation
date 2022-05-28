//
//  StringEx.swift
//  qr-station
//
//  Created by Petr Sedlák on 28.05.2022.
//

import Foundation
import UIKit

extension String {
    func isValidUrl() -> Bool {
        if let url = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
}

extension URL {
    func isValidUrl() -> Bool {
        return UIApplication.shared.canOpenURL(self)
    }
}
