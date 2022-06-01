//
//  QRListViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import UIKit

class QRListViewController: UIViewController, HasCustomTabProtocol {
    var customTabItem: CustomTabItem?
    
    let vm = QRListVM()
    
    let search = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List.Title".localize()
        tableViewSetup()
        searchSetup()
        vm.searchUpdatedCallback = { [weak self] in self?.tableView.reloadData() }
        vm.updateAtIndexCallback = { [weak self] i in
            self?.tableView.reloadRows(at: [i], with: .automatic)
        }
    }
    
    private func tableViewSetup() {
        tableView.register(QRCell.nib, forCellReuseIdentifier: QRCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = vm
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.contentInset.bottom = 70
    }
    
    private func searchSetup() {
        search.searchResultsUpdater = vm
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "List.Search".localize()
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
        vc.onDismiss = { [weak tableView] hasChange in
            if hasChange {
                tableView?.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        self.present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = vm.setFavoriteAction(forIndex: indexPath)
        return UISwipeActionsConfiguration(actions: [action])
    }
}
