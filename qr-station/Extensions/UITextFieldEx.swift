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

}
