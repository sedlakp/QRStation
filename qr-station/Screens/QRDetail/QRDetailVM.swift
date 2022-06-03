//
//  QRDetailVM.swift
//  qr-station
//
//  Created by Petr Sedlák on 31.05.2022.
//

import Foundation
import UIKit

class QRDetailVM: NSObject {
    
    var realm = RealmService.shared
    var qr: QRProtocol?
    
    var onDismiss: (_ hasChange: Bool) -> () = {_ in}
    var somethingChanged: Bool = false
    
    func updateName(with text: String ){
        guard let qr = qr as? QRCodeRLM else { return }
        realm.setQRName(for: qr, to: text)
        somethingChanged = true // on dismiss of this controller table reload will be triggered
    }
    
    func onDismissVC() {
        onDismiss(somethingChanged)
    }
    
    func openQRContent() {
        // TODO: If not url handle appropriately
        // do action based on the content
        // for example if openable with the open(url) then include all appropriate cases
        // handle geo, events, contacts,... separately
        guard let url = qr?.url else { return }
        UIApplication.shared.open(url)
    }
    
    func copyToClipboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = qr?.string
        // TODO: Add some visual response
    }
}


extension QRDetailVM: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
