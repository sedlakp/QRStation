//
//  CustomItemView.swift
//  qr-station
//
//  Created by Petr Sedlák on 30.05.2022.
//

import UIKit

class CustomItemView: UIView {

    private let nameLabel = UILabel()
    private let iconImageView = UIImageView()
    private let underlineView = UIView()
    private let containerView = UIView()
    let index: Int
    
    var isSelected = false {
        didSet {
            animateItems()
        }
    }
    
    private let item: CustomTabItem
    
    init(with item: CustomTabItem, index: Int) {
        self.item = item
        self.index = index
        super.init(frame: .zero)
        self.tag = index // to handle taps
        
        setupHierarchy()
        setupLayout()
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(underlineView)
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.height.width.equalTo(28)
            $0.top.equalToSuperview()
            $0.bottom.equalTo(nameLabel.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(16)
        }
        
        underlineView.snp.makeConstraints {
            $0.width.equalTo(28)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(nameLabel.snp.centerY)
        }
    }
    
    private func setupProperties() {
      
        nameLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        nameLabel.text = item.name
        nameLabel.textColor = .white.withAlphaComponent(0.4)
        nameLabel.textAlignment = .center
        underlineView.backgroundColor = .white
        underlineView.layer.cornerRadius = 2
        
        iconImageView.image = isSelected ? item.selectedIcon : item.icon
    }
    
    private func animateItems() {
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.nameLabel.alpha = self.isSelected ? 0.0 : 1.0
            self.underlineView.alpha = self.isSelected ? 1.0 : 0.0
        }
        UIView.transition(with: iconImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve) { [unowned self] in
            self.iconImageView.image = self.isSelected ? self.item.selectedIcon : self.item.icon
        }
    }

}
