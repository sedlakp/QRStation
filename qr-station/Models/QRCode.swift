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
        return URL(string: string)
    }
    
    var content: QRCode.Content {
        return decideContent(from: string)
    }
    
    // Create nicer qr code to show
    var qr: UIImage? {
        let cgImage = EFQRCode.generate(for: string)
        guard let cgImage = cgImage else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
//    var smallQr: UIImage? {
//        guard let qr = qr else { return nil}
//        let targetSize = CGSize(width: 100, height: 100)
//        return qr.scalePreservingAspectRatio(targetSize: targetSize)
//    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: appearedDate)
    }
    
    private func decideContent(from qrString: String) -> QRCode.Content {
        // look for specific pattern first
        for content in QRCode.Content.allCases {
            guard let pattern = content.patternDistinciton else { continue }
            if qrString.starts(with: pattern) {
                return content
            }
        }
        // if no matches in previous loop match one of the basic contents
        if qrString.isValidUrl() {
            return .url
        } else {
            return .text
        }
    }
    
}

struct QRCode: Equatable, QRProtocol {
    
    /// URL Schemes and other standardized patterns
    enum Content: String, CustomStringConvertible, CaseIterable {
        // basic content
        case text
        case url
        // apple default open url
        case mailto, tel, facetime, sms
        // special cases
        case vcard, mecard, bizcard //Contact info
        case vevent //calendar event
        case wifi
        case youtube
        case map // google, apple
        //case social // fb, tw, line
        
        var description: String {
            switch self {
            case .text: return "Text"
            case .url: return "URL"
            case .tel: return "Phone"
            case .mailto: return "Mail"
            case .mecard, .vcard, .bizcard: return "Contact"
            case .facetime: return "Facetime"
            case .wifi: return "WIFI"
            case .sms: return "SMS"
            case .map: return "Place"
            case .vevent: return "Event"
            case .youtube: return "Video"
            }
        }
        
        // return these as predicates, probably the most clear solution
        // also make a function that will be like, decide qr content
        var patternDistinciton: String? {
            switch self {
            case .text: return nil
            case .url: return nil
            case .mailto: return "mailto:"
            case .facetime: return "facetime:"
            case .sms: return "sms:"
            case .tel: return "tel:"
            case .youtube: return "youtube:"
            case .wifi: return "WIFI:"
            case .map: return "geo:"
            case .vevent: return "BEGIN:VEVENT"
            case .vcard: return "BEGIN:VCARD"
            case .bizcard: return "BIZCARD:"
            case .mecard: return "MECARD:"
            }
        }
        
        var color: UIColor {
            return .systemTeal
        }
        
        var icon: UIImage? {
            switch self {
            case .text:                     return nil
            case .url:                      return UIImage(systemName: "safari")
            case .mailto:                   return UIImage(systemName: "square.and.pencil")
            case .tel:                      return UIImage(systemName: "phone")
            case .facetime:                 return UIImage(systemName: "video")
            case .sms:                      return UIImage(systemName: "message")
            case .vcard, .mecard, .bizcard: return UIImage(systemName: "person.text.rectangle")
            case .vevent:                   return UIImage(systemName: "venvelope.open")
            case .wifi:                     return UIImage(systemName: "wifi")
            case .youtube:                  return UIImage(systemName: "film")
            case .map:                      return UIImage(systemName: "map")
            //case .social:                   return UIImage(systemName: "person")
            }
        }
    }
    
    enum WhereFrom: String {
        
        case camera
        case image
        case created
        case unknown
        
        var detail: String {
            switch self {
            case .camera: return "QRCode.WhereFrom.CameraScan".localize()
            case .image: return "QRCode.WhereFrom.ImageScan".localize()
            case .created: return "QRCode.WhereFrom.Created".localize()
            case .unknown: return "???"
            }
        }
        
        var color: UIColor {
            switch self {
            case .camera: return .systemGray
            case .image: return .systemBrown
            case .created: return .systemPink
            case .unknown: return .systemGray
            }
        }
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
