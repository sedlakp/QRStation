//
//  EmptyStateView.swift
//  qr-station
//
//  Created by Petr Sedlák on 28.05.2022.
//

import UIKit

class EmptyStateView: UIView {

    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    convenience init(img: UIImage?, title: String?) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
    }

    
    private func setupUI() {
        Bundle.main.loadNibNamed("EmptyStateView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = .red
        layoutIfNeeded()
    }

}
