//
//  QRDetailViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 28.05.2022.
//

import UIKit
import Combine

class QRDetailViewController: UIViewController {
    
    let vm = QRDetailVM()
    
    var qrManager = QRCodeManager.shared
    
    var qr: QRProtocol?
    
    var cancellables: Set<AnyCancellable> = []
    
    var onDismiss: (_ hasChange: Bool) -> () = {_ in}
    var somethingChanged: Bool = false

    @IBOutlet weak var textFld: UITextField!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var textLbl: PaddingLabel!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var linkBtn: UIButton!
    @IBOutlet weak var btnsBkgView: UIView!
    @IBOutlet weak var copyToClipboardBtn: UIButton!
    
    deinit {
        print("Detail deinitialized")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onDismiss(somethingChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkBtn.addTarget(self, action: #selector(openUrl), for: .touchUpInside)
        shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        copyToClipboardBtn.addTarget(self, action: #selector(copyString), for: .touchUpInside)
        uiSetup()
        
        textFld.textPublisher
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let qr = self?.qr as? QRCodeRLM else { return }
                self?.qrManager.setQRName(for: qr, to: text)
                self?.somethingChanged = true // on dismiss of this controller table reload will be triggered
            }.store(in: &cancellables)
    }
    
    private func uiSetup() {
        textLbl.backgroundColor = .secondarySystemBackground
        textLbl.layer.masksToBounds = true
        textLbl.layer.cornerRadius = 12
        textLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textLbl.numberOfLines = 0
        btnsBkgView.backgroundColor = .secondarySystemBackground
        btnsBkgView.layer.cornerRadius = 12
        qrImageView.layer.cornerRadius = 4
        textFld.placeholder = "Add a name"
        textFld.setQRBorderless()
        textFld.delegate = vm
        configureWithQR()
    }
    
    func configureWithQR() {
        guard let qr = qr else { return }
        qrImageView.image = qr.qr
        textLbl.text = qr.string
        linkBtn.isHidden = !(qr.url?.isValidUrl() ?? false)
        textFld.text = qr.name
    }

    
    @objc private func openUrl() {
        guard let url = qr?.url else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func share() {
        let items = [qr?.qr]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @objc private func copyString() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = qr?.string
        // TODO: Add some visual response
    }
}
