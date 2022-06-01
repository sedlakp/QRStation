//
//  QRListVM.swift
//  qr-station
//
//  Created by Petr Sedlák on 28.05.2022.
//

import Foundation
import UIKit
import RealmSwift

class QRListVM: NSObject {
    
    private let realm = RealmService.shared
    
    private var filterText: String = ""
    
    var searchUpdatedCallback: () -> () = {}
    var updateAtIndexCallback: (IndexPath) -> () = {_ in}
    
    var qrCodes: RealmSwift.Results<QRCodeRLM> {
        realm.getCodes(searchedText: filterText)
    }
    
    private func setEmptyScreen(in tableView: UITableView) {
        if !filterText.isEmpty {
            qrCodes.isEmpty ? tableView.setEmptyScreen(with: "Search", and: "No QR codes found.") : tableView.removeEmptyScreen()
        } else {
            qrCodes.isEmpty ? tableView.setEmptyScreen(with: "Editing", and: "You have not scanned or created any QR codes yet.") : tableView.removeEmptyScreen()
        }
    }
    
    func setQRFavoriteStatus(qr: QRCodeRLM) {
        realm.updateFavorite(qr: qr)
    }
    
    func setFavoriteAction(forIndex index: IndexPath) -> UIContextualAction {
        let qr = qrCodes[index.row]
        let action = UIContextualAction(style: .normal, title: qr.isFavorite ? "Unfavorite": "Favorite")
            { [weak self] (action, view, completionHandler) in
                self?.setQRFavoriteStatus(qr:qr)
                self?.updateAtIndexCallback(index)
                completionHandler(true)
            }
        action.backgroundColor = .systemYellow
        return action
    }
    
}

extension QRListVM: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        setEmptyScreen(in: tableView)
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
            realm.delete(qrCodes[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }

}

extension QRListVM: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) ?? ""
        searchUpdatedCallback()
    }
    
    
}
