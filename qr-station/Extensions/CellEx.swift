//
//  CellEx.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
