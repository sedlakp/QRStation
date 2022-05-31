//
//  CustomTabBar.swift
//  qr-station
//
//  Created by Petr Sedlák on 30.05.2022.
//

import UIKit
import SnapKit

class CustomTabBar: UIStackView {
    
    var itemTappedCompletion: (_ index: Int) -> () = {_ in}
        
    private lazy var customItemViews: [CustomItemView] = [dashboardItem, listItem]
    
    private let dashboardItem = CustomItemView(with: .dashboard, index: 0)
    private let listItem = CustomItemView(with: .list, index: 1)
    
    init() {
        super.init(frame: .zero)
        
        setupHierarchy()
        setupProperties()
        bind()
        
        setNeedsLayout()
        layoutIfNeeded()
        selectItem(index: 0)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addArrangedSubview(dashboardItem)
        addArrangedSubview(listItem)
    }
    
    private func setupProperties() {
        distribution = .fillEqually
        alignment = .center
        
        backgroundColor = forcedTintColor
        layer.cornerRadius = 16
        
        customItemViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
    }
    
    private func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = $0.index == index }
        itemTappedCompletion(index)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let tag = sender?.view?.tag else { return }
        self.selectItem(index: tag)
            
    }
    
    //MARK: - Bindings
    
    private func bind() {
        
        let tapD = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        dashboardItem.addGestureRecognizer(tapD)
        
        let tapL = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        listItem.addGestureRecognizer(tapL)
        
//        profileItem.rx.tapGesture()
//            .when(.recognized)
//            .bind { [weak self] _ in
//                guard let self = self else { return }
//                self.profileItem.animateClick {
//                    self.selectItem(index: self.profileItem.index)
//                }
//            }
//            .disposed(by: disposeBag)

    }

}
