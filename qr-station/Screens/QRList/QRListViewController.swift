//
//  QRListViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import UIKit

class QRListViewController: UIViewController {
    
    let vm = QRListVM()
    
    let search = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "QR Codes"
        tableViewSetup()
        searchSetup()
        vm.searchUpdatedCallback = { [weak self] in self?.tableView.reloadData() }
    }
    
    private func tableViewSetup() {
        tableView.register(QRCell.nib, forCellReuseIdentifier: QRCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = vm
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
    }
    
    private func searchSetup() {
        search.searchResultsUpdater = vm
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search for a QR code content"
        navigationItem.searchController = search
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

}


extension QRListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qr = vm.qrCodes[indexPath.row]
        let vc = QRDetailViewController()
        vc.qr = qr
        self.present(vc, animated: true)
        
    }
}
