//
//  CreateQRViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 25.05.2022.
//

import UIKit
import EFQRCode
import Combine
import BLTNBoard

class CreateQRViewController: TabItemViewController {
    
    let qrManager = QRCodeManager.shared
    
    var subscriptions: Set<AnyCancellable> = []
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem = BLTNPageItem(title: "")
        return BLTNItemManager(rootItem: rootItem)
    }()

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
        createQR.addTarget(self, action: #selector(createQRCode), for: .touchUpInside)
        pasteBtn.addTarget(self, action: #selector(pasteTapped), for: .touchUpInside)
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        orLbl.text = "or"
        qrImage.backgroundColor = .white
        qrImage.layer.cornerRadius = 4
        txtField.placeholder = "Type the QR Code content"
        createQR.setTitle("Create", for: .normal)
        createQR.isEnabled = false
        txtField.setQRBorderless()
    }
    
    private func setupBindings() {
        txtField.textPublisher.sink { [weak self] str in
            self?.textFldChanged(with: str)
        }.store(in: &subscriptions)
    }
    
    private func textFldChanged(with str: String) {
        generateQR(from: str)
        createQR.isEnabled = !str.isEmpty
        if str.isEmpty {
            qrImage.image = nil
        }
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
            textFldChanged(with: string)
        }
    }
    
    @objc private func createQRCode() {
        self.view.endEditing(true)
        let qr = QRCode(string: txtField.text ?? "", whereFrom: .created, appearedDate: Date.now)
        qrManager.add(qr)
        //showBulletin(from: qr)
        showSheet(with: qr)
    }
    
    private func showSheet(with qr: QRCode) {
        let vc = SheetViewController()
        
        vc.setup(qr: qr, title: "QR code created", actionText: "Done", altActionText: "Create another") { [weak self, weak vc] in
            vc?.dismiss(animated: true)
            self?.navigationController?.popViewController(animated: true)
        } altAction: { [weak self, weak vc] in
            self?.txtField.text = ""
            self?.createQR.isEnabled = false
            self?.qrImage.image = nil
            vc?.dismiss(animated: true)
        }

        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        vc.isModalInPresentation = true
        
        self.present(vc, animated: true)
    }
    
    private func showBulletin(from qr: QRCode) {
        let item = BLTNPageItem(title: "QR code created")
        item.appearance.actionButtonColor = forcedTintColor
        item.appearance.alternativeButtonTitleColor = forcedTintColor
        item.image = qr.smallQr
        item.descriptionText = qr.string
        item.descriptionLabel?.textColor = .label
        item.actionButtonTitle = "Done"
        item.alternativeButtonTitle = "Create another"
        item.actionHandler = { [weak self] _ in
            self?.bulletinManager.dismissBulletin()
            self?.navigationController?.popViewController(animated: true)
        }
        item.alternativeHandler = { [weak self] _ in
            // empty text field
            self?.txtField.text = ""
            self?.createQR.isEnabled = false
            self?.qrImage.image = nil
            self?.bulletinManager.dismissBulletin()
        }
        bulletinManager = BLTNItemManager(rootItem: item)
        bulletinManager.backgroundColor = .secondarySystemBackground
        bulletinManager.showBulletin(above: self)
    }

}
