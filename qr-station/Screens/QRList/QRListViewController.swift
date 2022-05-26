//
//  QRListViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import UIKit

class QRListViewController: UIViewController {
    
    let qrManager = QRCodeManager.shared

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List"
        navigationItem.title = "QR Codes"
        
        tableView.register(QRCell.nib, forCellReuseIdentifier: QRCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

}


extension QRListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qrManager.qrCodes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QRCell", for: indexPath) as! QRCell
        var qr = qrManager.qrCodes[indexPath.row]
        cell.titleText.text = "\(qr.string)"
        cell.titleText.textColor = .label
        cell.qrImage.image = qr.qr
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // TODO: During filtering, be careful about what gets deleted
            qrManager.delete(qrManager.qrCodes[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    
    
}
