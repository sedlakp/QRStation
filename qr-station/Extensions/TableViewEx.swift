//
//  TableViewEx.swift
//  qr-station
//
//  Created by Petr Sedlák on 28.05.2022.
//

import Foundation
import UIKit

extension UITableView {
    
    func setEmptyScreen(with animationName: String, and text: String) {
        let emptyView = EmptyStateView(animationName: animationName, text: text)
        backgroundView = emptyView
        separatorStyle = .none
    }
    
    func setEmptyScreen() {
        let emptyView = EmptyStateView(img: UIImage(), title: "")
        backgroundView = emptyView
        separatorStyle = .none
        //alwaysBounceVertical = bounceAllowed
    }
    
    func removeEmptyScreen() {
        alwaysBounceVertical = true
        backgroundView = nil
        separatorStyle = .singleLine
        separatorInset = .zero
    }
    
    func reloadDataWithoutScroll() {
        let offset = contentOffset
        reloadData()
        layoutIfNeeded()
        setContentOffset(offset, animated: false)
    }

}
