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
    
    var cancellables: Set<AnyCancellable> = []

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
        vm.onDismissVC()
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
                self?.vm.updateName(with: text)
            }.store(in: &cancellables)
    }
    
    private func uiSetup() {
        textLbl.backgroundColor = .secondarySystemBackground
        textLbl.layer.masksToBounds = true
        textLbl.layer.cornerRadius = 12
        textLbl.font = .appFont.text
        textLbl.numberOfLines = 0
        btnsBkgView.backgroundColor = .secondarySystemBackground
        btnsBkgView.layer.cornerRadius = 12
        qrImageView.layer.cornerRadius = 4
        textFld.placeholder = "Detail.AddName".localize()
        textFld.setQRBorderless()
        textFld.delegate = vm
        configureWithQR()
    }
    
    func configureWithQR() {
        guard let qr = vm.qr else { return }
        qrImageView.image = qr.qr
        textLbl.text = qr.string
        linkBtn.setImage(qr.content.icon, for: .normal)
        // TODO: Handling for non url content
        linkBtn.isHidden = qr.url == nil ? true : !UIApplication.shared.canOpenURL(qr.url!)
        textFld.text = qr.name
    }

    
    @objc private func openUrl() {
        vm.openQRContent()
    }
    
    @objc private func share() {
        let items = [vm.qr?.qr]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @objc private func copyString() {
        vm.copyToClipboard()
    }
}
