//
//  QRListVM.swift
//  qr-station
//
//  Created by Petr Sedlák on 28.05.2022.
//

import Foundation
import UIKit

class QRListVM: NSObject {
    
    private let qrManager = QRCodeManager.shared
    
    var qrCodes: [QRCodeRLM] {
        return qrManager.qrCodes
    }
    
}

extension QRListVM: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        qrCodes.isEmpty ? tableView.setEmptyScreen() : tableView.removeEmptyScreen()
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qrCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QRCell", for: indexPath) as! QRCell
        let qr = qrCodes[indexPath.row]
        cell.setupCell(with: qr)
        return cell
    }
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // TODO: During filtering, be careful about what gets deleted
            qrManager.delete(qrCodes[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }

}
