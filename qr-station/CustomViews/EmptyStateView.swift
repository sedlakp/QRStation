//
//  EmptyStateView.swift
//  qr-station
//
//  Created by Petr Sedlák on 28.05.2022.
//

import UIKit
import Lottie

class EmptyStateView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var textLbl: UILabel!
    
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
    
    convenience init(animationName: String, text: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        animationView.animation = Animation.named(animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        textLbl.text = text
    }

    
    private func setupUI() {
        Bundle.main.loadNibNamed("EmptyStateView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        textLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textLbl.numberOfLines = 0
        layoutIfNeeded()
    }

}
