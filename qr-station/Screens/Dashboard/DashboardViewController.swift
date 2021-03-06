//
//  DashboardViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import UIKit
import EFQRCode
import BLTNBoard

class DashboardViewController: UIViewController, HasCustomTabProtocol {
    
    var customTabItem: CustomTabItem?
    
    private let realm = RealmService.shared
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem = BLTNPageItem(title: "")
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
        navigationItem.title = "Dashboard.Title".localize()
        
        setupUI()
        
        qrScanBtn.addTarget(self, action: #selector(scanBtnTapped), for: .touchUpInside)
        qrImageScanBtn.addTarget(self, action: #selector(importPicture), for: .touchUpInside)
        qrCreateBtn.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        
    }
    
    private func setupUI() {
        scanTitleLbl.text = "Dashboard.Scan".localize()
        scanTitleLbl.font = .appFont.smallTitle
        qrScanLbl.text = "Dashboard.Scan.Camera".localize()
        qrScanLbl.font = .appFont.mini
        qrImageScanLbl.text = "Dashboard.Scan.Image".localize()
        qrImageScanLbl.font = .appFont.mini
        qrCreateLbl.text = "Dashboard.Create".localize()
        qrCreateLbl.font = .appFont.smallTitle
        
        scanBkgView.layer.cornerRadius = 12
        createBkgView.layer.cornerRadius = 12
        scanBkgView.backgroundColor = .secondarySystemBackground
        createBkgView.backgroundColor = .secondarySystemBackground
    }


    @objc private func scanBtnTapped() {
        let vc = ScannerViewController()
        //vc.hidesBottomBarWhenPushed = true
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
        //vc.hidesBottomBarWhenPushed = true
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
                showSheet(with: qr.toRLM())
            } else {
                showNotFoundBulletin()
            }
        }
    }
    
    
    private func showSheet(with qr: QRCodeRLM) {
        let vc = SheetViewController()
        
        vc.setup(qr: qr, title: "CameraScan.Scanned".localize(), actionText: "CameraScan.Save".localize(), altActionText: "CameraScan.Discard".localize()) { [weak self, weak vc] in
            if let name = vc?.textFld.text?.trimmingCharacters(in: .whitespaces) {
                qr.name = name
            }
            self?.realm.add(qr)
            vc?.dismiss(animated: true)
        } altAction: { [weak vc] in
            vc?.dismiss(animated: true)
        }

        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        vc.isModalInPresentation = true
        
        self.present(vc, animated: true)
    }
    
    private func showNotFoundBulletin() {
        let item = BLTNPageItem(title: "ImageScan.NoQR".localize())
        item.appearance.actionButtonColor = forcedTintColor
        item.appearance.alternativeButtonTitleColor = forcedTintColor
        //item.image = UIImage(systemName: "exclamationmark.triangle")
        item.descriptionText = "ImageScan.NoQR.message".localize()
        item.descriptionLabel?.textColor = .label
        item.actionButtonTitle = "ImageScan.NoQR.Ok".localize()
        item.actionHandler = { [weak self] _ in
            self?.bulletinManager.dismissBulletin()
        }
        
        bulletinManager = BLTNItemManager(rootItem: item)
        bulletinManager.backgroundColor = .secondarySystemBackground
        bulletinManager.showBulletin(above: self)
    }

}


extension DashboardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
