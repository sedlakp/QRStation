//
//  DashboardViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import UIKit
import EFQRCode

class DashboardViewController: UIViewController {
    
    let qrManager = QRCodeManager.shared
    
    @IBOutlet weak var qrScanLbl: UILabel!
    @IBOutlet weak var qrScanBtn: UIButton!
    
    @IBOutlet weak var qrImageScanLbl: UILabel!
    @IBOutlet weak var qrImageScanBtn: UIButton!
    
    @IBOutlet weak var qrCreateLbl: UILabel!
    @IBOutlet weak var qrCreateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QR"
        navigationItem.title = "QR Station"
        
        // https://stackoverflow.com/questions/68328038/imageedgeinsets-was-deprecated-in-ios-15-0
//        qrScanBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//
//        qrCreateBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        qrScanLbl.text = "Scan a QR code (Camera)"
        qrImageScanLbl.text = "Scan a QR code (Image)"
        qrCreateLbl.text = "Create a QR code"
        
        qrScanBtn.addTarget(self, action: #selector(scanBtnTapped), for: .touchUpInside)
        qrImageScanBtn.addTarget(self, action: #selector(importPicture), for: .touchUpInside)
        
    }


    @objc private func scanBtnTapped() {
        let vc = ScannerViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        getQR(from: image)
        // TODO: Show the bulletin board after creating the qr object
    }
    
    private func getQR(from image: UIImage) {
        if let testImage = image.cgImage {
            let codes = EFQRCode.recognize(testImage)
            if !codes.isEmpty {
                // get only the first one for now
                let qr = QRCode(string: codes.first!, whereFrom: .image, appearedDate: Date.now)
                qrManager.add(qr)
            } else {
                print("No QR code found")
            }
        }
    }

}


extension DashboardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
