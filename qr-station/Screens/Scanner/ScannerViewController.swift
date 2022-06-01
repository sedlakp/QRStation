//
//  ScannerViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 26.05.2022.
//

import UIKit
import QRScanner
import AVFoundation

class ScannerViewController: TabItemViewController {
    
    let realm = RealmService.shared
    var qrScannerView: QRScannerView?

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
    
    private func showSheet(with qr: QRCodeRLM) {
        let vc = SheetViewController()
        
        vc.setup(qr: qr, title: "CameraScan.Scanned".localize(), actionText: "CameraScan.Save".localize(), altActionText: "CameraScan.Discard".localize()) { [weak self, weak vc] in
            if let name = vc?.textFld.text?.trimmingCharacters(in: .whitespaces) {
                qr.name = name
            }
            self?.realm.add(qr)
            self?.qrScannerView?.rescan()
            vc?.dismiss(animated: true)
        } altAction: { [weak self, weak vc] in
            self?.qrScannerView?.rescan()
            vc?.dismiss(animated: true)
        }

        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        vc.isModalInPresentation = true
        
        self.present(vc, animated: true)
    }

}


extension ScannerViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error) // TODO: Handle error
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        let qr = QRCode(string: code, whereFrom: .camera, appearedDate: Date.now)
        showSheet(with: qr.toRLM())
    }
}
