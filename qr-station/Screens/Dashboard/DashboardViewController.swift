//
//  DashboardViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import UIKit
import EFQRCode
import BLTNBoard

class DashboardViewController: UIViewController {
    
    let qrManager = QRCodeManager.shared
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem = BLTNPageItem(title: "QR found")
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    @IBOutlet weak var scanTitleLbl: UILabel!
    @IBOutlet weak var qrScanLbl: UILabel!
    @IBOutlet weak var qrScanBtn: UIButton!
    @IBOutlet weak var scanBkgView: UIView!
    
    @IBOutlet weak var qrImageScanLbl: UILabel!
    @IBOutlet weak var qrImageScanBtn: UIButton!
    
    @IBOutlet weak var createBkgView: UIView!
    @IBOutlet weak var qrCreateLbl: UILabel!
    @IBOutlet weak var qrCreateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Station"
        navigationItem.title = "QR Station"
        
        // https://stackoverflow.com/questions/68328038/imageedgeinsets-was-deprecated-in-ios-15-0
//        qrScanBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//
//        qrCreateBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        scanTitleLbl.text = "Scan a QR code"
        scanTitleLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        qrScanLbl.text = "From camera"
        qrScanLbl.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        qrImageScanLbl.text = "From image"
        qrImageScanLbl.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        qrCreateLbl.text = "Create a QR code"
        qrCreateLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        scanBkgView.layer.cornerRadius = 12
        createBkgView.layer.cornerRadius = 12
        scanBkgView.backgroundColor = .secondarySystemBackground
        createBkgView.backgroundColor = .secondarySystemBackground
        
        qrScanBtn.addTarget(self, action: #selector(scanBtnTapped), for: .touchUpInside)
        qrImageScanBtn.addTarget(self, action: #selector(importPicture), for: .touchUpInside)
        qrCreateBtn.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        
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
    
    @objc func createTapped() {
        let vc = CreateQRViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        getQR(from: image)
    }
    
    private func getQR(from image: UIImage) {
        if let testImage = image.cgImage {
            let codes = EFQRCode.recognize(testImage)
            if !codes.isEmpty {
                // get only the first one for now
                let qr = QRCode(string: codes.first!, whereFrom: .image, appearedDate: Date.now)
                showBulletin(from: qr)
            } else {
                print("No QR code found")
            }
        }
    }
    
    private func showBulletin(from qr: QRCode) {
        let item = BLTNPageItem(title: "Found QR code")
        item.image = qr.smallQr
        item.descriptionText = qr.string
        item.descriptionLabel?.textColor = .label
        item.actionButtonTitle = "Save"
        item.actionHandler = { [weak self] _ in
            self?.qrManager.add(qr)
            self?.bulletinManager.dismissBulletin()
        }
        
        bulletinManager = BLTNItemManager(rootItem: item)
        bulletinManager.showBulletin(above: self)
    }

}


extension DashboardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
