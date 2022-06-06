//
//  PageViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 06.06.2022.
//

import UIKit
import SnapKit

enum PageType {
    case welcome
    case features
    case enjoy
    
    var title: String {
        switch self {
        case .welcome: return "Welcome"
        case .features: return "Features"
        case .enjoy: return "Enjoy"
        }
    }
    
    var text: String {
        switch self {
        case .welcome:
            return """
                    Welcome to the QR Station app! With this app, you can scan QR codes from both your camera, or load an image from your photo library.
                    """
        case .features:
            return """
                    * Scan QR code from camera or photo library
                    * Create new QR code
                    * Favorite QR code
                    * See QR code type
                    * If possible, open content hidden inside the QR code
                    * Search for already scanned QR codes
                    """
        case .enjoy:
          return """
                Go explore the app by yourself!
                """
        }
    }
    
    var hasBtn: Bool {
        return self == .enjoy
    }
}

class PageViewController: UIViewController {
    
    let pageType: PageType
    
    let stack = UIStackView()
    
    let lbl = UILabel()
    let lblDetail = UILabel()
    let btn = UIButton()
    let spacer = UIView()
    
    init(type pageType: PageType) {
        self.pageType = pageType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStack()
        setupTitleLbl()
        setupDetailText()
        stack.addArrangedSubview(spacer)
        if pageType.hasBtn {
            setupBtn()
        }
    }
    
    private func setupStack() {
        view.addSubview(stack)
        
        stack.spacing = 40
        stack.axis = .vertical
        
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalToSuperview().offset(200)
            $0.left.equalToSuperview().offset(28)
        }
    }
    
    private func setupTitleLbl() {
        lbl.text = pageType.title
        lbl.font = .appFont.title
        lbl.textAlignment = .center
        stack.addArrangedSubview(lbl)
        
//        lbl.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(70)
//            $0.left.right.equalToSuperview()
//            $0.height.equalTo(40)
//        }
    }
    
    private func setupDetailText() {
        stack.addArrangedSubview(lblDetail)
        lblDetail.textAlignment = .center
        lblDetail.font = .appFont.text
        lblDetail.text = pageType.text
        lblDetail.numberOfLines = 0
    }
    
    private func setupBtn() {
        view.addSubview(btn)

        btn.configuration = .filled()
        btn.setTitle("To the app", for: .normal)
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
        btn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-80)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(60)
            $0.left.equalToSuperview().offset(60)
        }
    }
    
    
    @objc private func btnTapped() {
        UserDefaults.standard.set(true, forKey: DefaultsKeys.seenOnboarding.rawValue)
        SceneDelegate.shared?.rootViewController.switchToMainApp()
    }

}
