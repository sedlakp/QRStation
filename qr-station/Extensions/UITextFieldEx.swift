//
//  UITextFieldEx.swift
//  qr-station
//
//  Created by Petr Sedlák on 26.05.2022.
//

import Foundation
import Combine
import UIKit

extension UITextField {

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }
    
    func setPadding(_ left: CGFloat?, _ right: CGFloat?){
        if let left = left {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        
        if let right = right {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
    func setQRBorderless() {
        borderStyle = .none
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 6
        clearButtonMode = .whileEditing
        setPadding(16, nil)
        font = .appFont.text
        returnKeyType = .done
    }

}
