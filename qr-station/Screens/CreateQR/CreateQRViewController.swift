//
//  CreateQRViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 25.05.2022.
//

import UIKit
import EFQRCode
import Combine

class CreateQRViewController: TabItemViewController {
    
    let realm = RealmService.shared
    
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
        createQR.addTarget(self, action: #selector(createQRCode), for: .touchUpInside)
        pasteBtn.addTarget(self, action: #selector(pasteTapped), for: .touchUpInside)
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        orLbl.text = "or"
        qrImage.backgroundColor = .white
        qrImage.layer.cornerRadius = 4
        
        createQR.setTitle("Create", for: .normal)
        createQR.isEnabled = false
        
        txtField.placeholder = "Type the QR Code content"
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
        let qrRlm = qr.toRLM()
        realm.add(qrRlm)
        //showBulletin(from: qr)
        showSheet(with: qrRlm)
    }
    
    private func showSheet(with qr: QRCodeRLM) {
        let vc = SheetViewController()
        
        vc.setup(qr: qr, title: "QR code created", actionText: "Done", altActionText: "Create another") { [weak self, weak vc] in
            vc?.dismiss(animated: true)
            if let name = vc?.textFld.text?.trimmingCharacters(in: .whitespaces) {
                self?.realm.setQRName(for: qr, to: name)
            }
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

}
