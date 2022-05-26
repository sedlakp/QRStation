//
//  CreateQRViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 25.05.2022.
//

import UIKit
import EFQRCode
import Combine

class CreateQRViewController: UIViewController {
    
    let qrManager = QRCodeManager.shared
    
    var subscriptions: Set<AnyCancellable> = []

    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var pasteBtn: UIButton!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var createQR: UIButton!
    
    deinit {
        print("Create screen Deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create QR Code"
        orLbl.text = "or"
        qrImage.backgroundColor = .white
        qrImage.layer.cornerRadius = 4
        txtField.placeholder = "Type the QR Code content"
        
        createQR.setTitle("Create", for: .normal)

        createQR.addTarget(self, action: #selector(createQRCode), for: .touchUpInside)
        createQR.isEnabled = false
        
        pasteBtn.addTarget(self, action: #selector(pasteTapped), for: .touchUpInside)
        
        txtField.textPublisher.sink { [weak self] str in
            self?.generateQR(from: str)
            self?.createQR.isEnabled = !str.isEmpty
        }.store(in: &subscriptions)
        
        
    }
    
    private func generateQR(from text: String) {
        if let image = EFQRCode.generate(for: text) {
            qrImage.image = UIImage(cgImage: image)
        }
    }
    
    @objc private func pasteTapped() {
        let pasteboard = UIPasteboard.general
        if let string = pasteboard.string {
            txtField.text = string
        }
    }
    
    @objc private func createQRCode() {
        let qr = QRCode(string: txtField.text ?? "", whereFrom: .created, appearedDate: Date.now)
        qrManager.add(qr)
        // TODO: Show confirmation
    }

}
