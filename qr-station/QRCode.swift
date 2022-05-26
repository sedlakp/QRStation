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
    
    // Enum to know what kind of UI and content should be shown
    enum Content {
        case text
        case url
    }
    
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
    lazy private(set) var qr: UIImage? = {
        let cgImage = EFQRCode.generate(for: string)
        guard let cgImage = cgImage else { return nil }
        return UIImage(cgImage: cgImage)
    }()
}
