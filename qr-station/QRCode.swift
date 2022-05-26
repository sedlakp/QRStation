//
//  QRCode.swift
//  qr-station
//
//  Created by Petr Sedlák on 26.05.2022.
//

import Foundation
import EFQRCode
import UIKit

struct QRCode: Equatable {
    
    enum WhereFrom {
        case camera
        case image
        case created
    }
    
    enum Content {
        case text
        case url
    }
    
    //let id = UUID()
    let string: String
    let whereFrom: WhereFrom
    let appearedDate: Date
    
    var url: URL? {
        return URL(string: string)
    }
    
    var content: Content {
        if let _ = url {
            return .url
        } else {
            return .text
        }
    }
    
    // Create nicer qr code to show
    lazy var qr: UIImage? = {
        let cgImage = EFQRCode.generate(for: string)
        guard let cgImage = cgImage else { return nil }
        return UIImage(cgImage: cgImage)
    }()
}
