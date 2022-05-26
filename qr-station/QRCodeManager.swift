//
//  QRCodeManager.swift
//  qr-station
//
//  Created by Petr Sedlák on 26.05.2022.
//

import Foundation

class QRCodeManager {
    
    static let shared = QRCodeManager()
    
    init() {
        // TODO: get from Realm
        _qrCodes = []
    }
    
    private var _qrCodes: [QRCode]
    
    var qrCodes: [QRCode] {
        return _qrCodes
    }
    
    func add(_ code: QRCode) {
        _qrCodes.append(code)
    }
    
    func delete(_ code: QRCode) {
        _qrCodes.remove(code)
    }
    
}
