//
//  QRDetailVM.swift
//  qr-station
//
//  Created by Petr Sedlák on 31.05.2022.
//

import Foundation
import UIKit

class QRDetailVM: NSObject {
    
}


extension QRDetailVM: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
