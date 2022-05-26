//
//  ScannerViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 26.05.2022.
//

import UIKit
import QRScanner
import AVFoundation

class ScannerViewController: UIViewController {
    
    lazy var qrScannerView: QRScannerView = {
        return QRScannerView(frame: view.bounds)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupQRScanner()
        // Do any additional setup after loading the view.
    }
    

    private func setupQRScanner() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setupQRScannerView()
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

}


extension ScannerViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
    }
}
