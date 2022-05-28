//
//  ScannerViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 26.05.2022.
//

import UIKit
import QRScanner
import AVFoundation
import BLTNBoard

class ScannerViewController: UIViewController {
    
    let qrManager = QRCodeManager.shared
    var qrScannerView: QRScannerView?
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem = BLTNPageItem(title: "QR found")
        return BLTNItemManager(rootItem: rootItem)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupQRScanner()
        
    }
    
    deinit{
        print("Scanning deinit")
    }

    private func setupQRScanner() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                DispatchQueue.main.async { [weak self] in
                    self?.setupQRScannerView()
                }
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    if granted {
                        DispatchQueue.main.async { [weak self] in
                            self?.setupQRScannerView()
                        }
                    }
                }
            default:
                showAlert()
            }
        }
    
    private func setupQRScannerView() {
        let qrScannerView = QRScannerView(frame: view.bounds)
        self.qrScannerView = qrScannerView
        view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }

    private func showAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let alert = UIAlertController(title: "Error", message: "QR Codes are scanned using camera, allow camera usage in device settings", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private func showBulletin(from qr: QRCode) {
        let item = BLTNPageItem(title: "Found QR code")
        item.appearance.actionButtonColor = .tintColor
        item.appearance.alternativeButtonTitleColor = .tintColor
        item.image = qr.smallQr
        item.descriptionText = qr.string
        item.descriptionLabel?.textColor = .label
        item.actionButtonTitle = "Save"
        item.actionHandler = { [weak self] _ in
            self?.qrManager.add(qr)
            self?.bulletinManager.dismissBulletin()
        }
        item.dismissalHandler = { [weak self] _ in
            self?.qrScannerView?.rescan()
        }
        
        bulletinManager = BLTNItemManager(rootItem: item)
        bulletinManager.showBulletin(above: self)
    }

}


extension ScannerViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        
        // TODO: Show screen to confirm adding the qr code - use bulletinboard? -> it will show the created QR object
        let qr = QRCode(string: code, whereFrom: .camera, appearedDate: Date.now)
        showBulletin(from: qr)
        
    }
}
