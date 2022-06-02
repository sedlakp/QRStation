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
    
    let actionStack = UIStackView()
    let actionBtn = UIButton()
    let openBtn = UIButton()
    
    let altActionBtn = UIButton()
    let emptyView = UIView()
    let textFld = UITextField()
    
    var qr: QRProtocol?
    
    var action: () -> () = {}
    var altAction: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
        layoutSetup()
        viewCustomization()
        
        actionBtn.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        altActionBtn.addTarget(self, action: #selector(altActionTapped), for: .touchUpInside)
        openBtn.addTarget(self, action: #selector(openUrl), for: .touchUpInside)
        
    }
    
    private func viewSetup() {
        view.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLbl)
        contentStack.addArrangedSubview(imgView)
        contentStack.addArrangedSubview(descriptionLbl)
        contentStack.addArrangedSubview(textFld)
        
        actionStack.addArrangedSubview(actionBtn)
        actionStack.addArrangedSubview(openBtn)
        contentStack.addArrangedSubview(actionStack)
        
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
        
        descriptionLbl.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(28)
        }
        
        
        actionStack.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(42)
        }
        
        actionBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()//.inset(28)
        }
        
        openBtn.snp.makeConstraints { [weak self] in
            guard let self = self else { return  }
            $0.height.equalTo(self.actionBtn.snp.height)
            $0.width.equalTo(self.openBtn.snp.height)
            
        }
        
        emptyView.snp.makeConstraints {
            $0.height.equalTo(0).priority(.low)
        }
    }
    
    private func viewCustomization() {
        view.backgroundColor = .clear
        
        titleLbl.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        descriptionLbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        descriptionLbl.numberOfLines = 3
        descriptionLbl.textAlignment = .center
        
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 20
        contentStack.layer.cornerRadius = 16
        contentStack.backgroundColor = .secondarySystemBackground
        
        textFld.setQRBorderless()
        textFld.backgroundColor = .systemBackground
        textFld.placeholder = "Create.CodeName".localize()
        
        actionStack.axis = .horizontal
        actionStack.alignment = .center
        actionStack.distribution = .fill
        actionStack.spacing = 10
        
        actionBtn.configuration = .filled()
        actionBtn.tintColor = forcedTintColor
        var btnConfig = UIButton.Configuration.filled()
        btnConfig.cornerStyle = .capsule
        openBtn.configuration = btnConfig
        openBtn.tintColor = forcedTintColor
        
        altActionBtn.setTitleColor(forcedTintColor, for: .normal)
    }
    
    
    
    func setup(qr: QRProtocol, title: String, actionText: String, altActionText: String, action: @escaping () -> () = {}, altAction: @escaping () -> () = {} ) {
        self.action = action
        self.altAction = altAction
        
        self.qr = qr
        
        actionBtn.setTitle(actionText, for: .normal)
        altActionBtn.setTitle(altActionText, for: .normal)
        
        titleLbl.text = title
        descriptionLbl.text = qr.string
        imgView.image = qr.qr
        
        openBtn.setImage(qr.content.icon, for: .normal)
        openBtn.isHidden = qr.url == nil ? true : !UIApplication.shared.canOpenURL(qr.url!)
    }

    @objc private func openUrl() {
        guard let url = qr?.url else { return }
        UIApplication.shared.open(url)
    }

    @objc private func actionTapped() {
        action()
    }
    
    @objc private func altActionTapped() {
        altAction()
    }

}
