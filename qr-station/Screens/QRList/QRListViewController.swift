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
    
    lazy var leftBarButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage.init(systemName: "star.square.fill"), style: .plain, target: self, action: #selector(showOnlyFavoritesTapped))
        btn.isSelected = false
        btn.tintColor = .systemGray
        return btn
    }()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List.Title".localize()
        tableViewSetup()
        searchSetup()
        vm.searchUpdatedCallback = { [weak self] in self?.tableView.reloadData() }
        vm.updateAtIndexCallback = { [weak self] _ in
            self?.tableView.reloadData()
        }
        navigationItem.leftBarButtonItem = leftBarButton
        
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
    
    @objc private func showOnlyFavoritesTapped() {
        leftBarButton.tintColor = leftBarButton.tintColor == .systemYellow ? .systemGray : .systemYellow
        vm.justFavoritesActive(leftBarButton.tintColor == .systemYellow)
    }
    
    private func openDetail(from indexPath: IndexPath) {
        let qr = vm.qrCodes[indexPath.row]
        let vc = QRDetailViewController()
        vc.vm.qr = qr
        vc.vm.onDismiss = { [weak tableView] hasChange in
            if hasChange {
                tableView?.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        self.present(vc, animated: true)
    }

}


extension QRListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetail(from: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = vm.setFavoriteAction(forIndex: indexPath)
        return UISwipeActionsConfiguration(actions: [action])
    }
}
