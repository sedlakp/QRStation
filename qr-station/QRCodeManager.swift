//
//  QRCodeManager.swift
//  qr-station
//
//  Created by Petr Sedlák on 26.05.2022.
//

import Foundation

class QRCodeManager {
    
    static let shared = QRCodeManager()
    
    let realm = RealmService.shared
    
    init() {
        // TODO: get from Realm
        _qrCodes = []
    }
    
    private var _qrCodes: [QRCode]
    
    var qrCodes: [QRCodeRLM] {
        //return _qrCodes
        return Array(realm.realm.objects(QRCodeRLM.self))
    }
    
    func add(_ code: QRCode) {
        //_qrCodes.append(code)
        
        realm.add(code.toRLM())
    }
    
    func delete(_ code: QRCodeRLM) {
        //_qrCodes.remove(code)
        realm.delete(code)
    }
    
}
