//
//  QRDetailViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 28.05.2022.
//

import UIKit

class QRDetailViewController: UIViewController {
    
    var qr: QRProtocol?

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var textLbl: PaddingLabel!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var linkBtn: UIButton!
    @IBOutlet weak var btnsBkgView: UIView!
    @IBOutlet weak var copyToClipboardBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLbl.backgroundColor = .secondarySystemBackground
        textLbl.layer.masksToBounds = true
        textLbl.layer.cornerRadius = 12
        textLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        linkBtn.addTarget(self, action: #selector(openUrl), for: .touchUpInside)
        shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        copyToClipboardBtn.addTarget(self, action: #selector(copyString), for: .touchUpInside)
        btnsBkgView.backgroundColor = .secondarySystemBackground
        btnsBkgView.layer.cornerRadius = 12
        qrImageView.layer.cornerRadius = 4
        configureWithQR()
    }
    
    func configureWithQR() {
        guard let qr = qr else { return }
        qrImageView.image = qr.qr
        textLbl.text = qr.string
        linkBtn.isHidden = !(qr.url?.isValidUrl() ?? false)
        
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
    }
}
