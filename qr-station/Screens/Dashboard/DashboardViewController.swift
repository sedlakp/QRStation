//
//  DashboardViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var qrScanLbl: UILabel!
    @IBOutlet weak var qrScanBtn: UIButton!
    
    @IBOutlet weak var qrCreateLbl: UILabel!
    @IBOutlet weak var qrCreateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QR"
        navigationItem.title = "QR Station"
        
        // https://stackoverflow.com/questions/68328038/imageedgeinsets-was-deprecated-in-ios-15-0
//        qrScanBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//
//        qrCreateBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        qrScanLbl.text = "Scan a QR code"
        
        qrCreateLbl.text = "Create a QR code"
        
        qrScanBtn.addTarget(self, action: #selector(scanBtnTapped), for: .touchUpInside)
        
    }


    @objc private func scanBtnTapped() {
        let vc = ScannerViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
