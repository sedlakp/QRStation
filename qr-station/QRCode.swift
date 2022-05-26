//
//  QRCode.swift
//  qr-station
//
//  Created by Petr Sedlák on 26.05.2022.
//

import Foundation
import EFQRCode
import UIKit
import RealmSwift

// Protocol to reuse code same for both QR classes
protocol QRProtocol {
    var string: String { get }
}

extension QRProtocol {
    var url: URL? {
        return URL(string: string)
    }
    
    var content: QRCode.Content {
        if let _ = url {
            return .url
        } else {
            return .text
        }
    }
}

struct QRCode: Equatable, QRProtocol {
    
    enum WhereFrom: String{
        case camera
        case image
        case created
        case unknown
    }
    
    // Enum to know what kind of UI and content should be shown
    enum Content {
        case text
        case url
    }
    
    let string: String
    let whereFrom: WhereFrom
    let appearedDate: Date
    
    // var numberScanned
    
    // Create nicer qr code to show
    lazy private(set) var qr: UIImage? = {
        let cgImage = EFQRCode.generate(for: string)
        guard let cgImage = cgImage else { return nil }
        return UIImage(cgImage: cgImage)
    }()
    
    
    func toRLM() -> QRCodeRLM {
        let qrRLM = QRCodeRLM()
        qrRLM.string = string
        qrRLM.appearedDate = appearedDate
        qrRLM.whereFromStr = whereFrom.rawValue
        return qrRLM
    }
}

/// Realm version of the QRCode object
class QRCodeRLM: Object, QRProtocol {
    
    @Persisted var string: String
    @Persisted var whereFromStr: String
    @Persisted var appearedDate: Date
    
    var whereFrom: QRCode.WhereFrom {
        return QRCode.WhereFrom(rawValue: whereFromStr) ?? .unknown
    }
    
    // Create nicer qr code to show
    lazy private(set) var qr: UIImage? = {
        let cgImage = EFQRCode.generate(for: string)
        guard let cgImage = cgImage else { return nil }
        return UIImage(cgImage: cgImage)
    }()
}
