//
//  SheetViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 31.05.2022.
//

import UIKit

class SheetViewController: UIViewController {

    let contentStack = UIStackView()
    let titleLbl = UILabel()
    let imgView = UIImageView()
    let descriptionLbl = UILabel()
    let actionBtn = UIButton()
    let altActionBtn = UIButton()
    let emptyView = UIView()
    let textFld = UITextField()
    
    var action: () -> () = {}
    var altAction: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
        layoutSetup()
        viewCustomization()
        
        actionBtn.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        altActionBtn.addTarget(self, action: #selector(altActionTapped), for: .touchUpInside)
        
    }
    
    private func viewSetup() {
        view.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLbl)
        contentStack.addArrangedSubview(imgView)
        contentStack.addArrangedSubview(descriptionLbl)
        contentStack.addArrangedSubview(textFld)
        contentStack.addArrangedSubview(actionBtn)
        contentStack.addArrangedSubview(altActionBtn)
        contentStack.addArrangedSubview(emptyView)
    }
    
    private func layoutSetup() {
        contentStack.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
        }
        
        imgView.snp.makeConstraints { [weak imgView] in
            $0.width.equalToSuperview().dividedBy(3)
            if let imgView = imgView {
                $0.height.equalTo(imgView.snp.width)
            }
        }
        
        textFld.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(28)
        }
        
        actionBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(42)
        }
        
        emptyView.snp.makeConstraints {
            $0.height.equalTo(0).priority(.low)
        }
    }
    
    private func viewCustomization() {
        view.backgroundColor = .clear
        
        titleLbl.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        descriptionLbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 20
        contentStack.layer.cornerRadius = 16
        contentStack.backgroundColor = .secondarySystemBackground
        
        textFld.setQRBorderless()
        textFld.backgroundColor = .systemBackground
        textFld.placeholder = "QR code name (optional)"
        
        actionBtn.configuration = .filled()
        actionBtn.tintColor = forcedTintColor
        altActionBtn.setTitleColor(forcedTintColor, for: .normal)
    }
    
    
    
    func setup(qr: QRProtocol, title: String, actionText: String, altActionText: String, action: @escaping () -> () = {}, altAction: @escaping () -> () = {} ) {
        self.action = action
        self.altAction = altAction
        
        actionBtn.setTitle(actionText, for: .normal)
        altActionBtn.setTitle(altActionText, for: .normal)
        
        titleLbl.text = title
        descriptionLbl.text = qr.string
        imgView.image = qr.qr
    }


    @objc private func actionTapped() {
        action()
    }
    
    @objc private func altActionTapped() {
        altAction()
    }

}
