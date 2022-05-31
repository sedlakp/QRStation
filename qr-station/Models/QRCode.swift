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
    var appearedDate: Date { get }
    var whereFrom: QRCode.WhereFrom { get }
    var isFavorite: Bool { get set }
    var name: String { get set }
}

extension QRProtocol {
    var url: URL? {
        // TODO: more robust link detection
        if string.starts(with: "www") {
            return URL(string: "https://" + string)
        }
        return URL(string: string)
    }
    
    var content: QRCode.Content {
        return url?.isValidUrl() ?? false ? .url : .text
    }
    
    // Create nicer qr code to show
    var qr: UIImage? {
        let cgImage = EFQRCode.generate(for: string)
        guard let cgImage = cgImage else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    var smallQr: UIImage? {
        guard let qr = qr else { return nil}
        let targetSize = CGSize(width: 100, height: 100)
        return qr.scalePreservingAspectRatio(targetSize: targetSize)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: appearedDate)
    }
    
}

struct QRCode: Equatable, QRProtocol {
    
    enum WhereFrom: String{
        case camera
        case image
        case created
        case unknown
        
        var detail: String {
            switch self {
            case .camera: return "Camera scan"
            case .image: return "Image scan"
            case .created: return "Created"
            case .unknown: return "???"
            }
        }
        
        var color: UIColor {
            switch self {
            case .camera: return .systemTeal
            case .image: return .systemBrown
            case .created: return .systemPink
            case .unknown: return .systemGray
            }
        }
    }
    
    // Enum to know what kind of UI and content should be shown
    enum Content {
        case text
        case url
    }
    
    let string: String
    let whereFrom: WhereFrom
    let appearedDate: Date
    var isFavorite: Bool = false
    var name: String = ""
    
    // var numberScanned
    
    func toRLM() -> QRCodeRLM {
        let qrRLM = QRCodeRLM()
        qrRLM.string = string
        qrRLM.appearedDate = appearedDate
        qrRLM.whereFromStr = whereFrom.rawValue
        return qrRLM
    }
}

/// Realm version of the QRCode object
class QRCodeRLM: Object, QRProtocol, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var string: String
    @Persisted var whereFromStr: String
    @Persisted var appearedDate: Date
    @Persisted var isFavorite: Bool = false
    @Persisted var name: String = ""
    
    var whereFrom: QRCode.WhereFrom {
        return QRCode.WhereFrom(rawValue: whereFromStr) ?? .unknown
    }
}
