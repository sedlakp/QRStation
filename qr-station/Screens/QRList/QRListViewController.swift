//
//  QRListViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import UIKit

class QRListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List"
        
        tableView.register(QRCell.nib, forCellReuseIdentifier: QRCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension QRListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QRCell", for: indexPath) as! QRCell
        cell.titleText.text = "\(indexPath)"
        cell.titleText.textColor = .black
        
        return cell
    }
    
    
}
