//
//  PageViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 06.06.2022.
//

import UIKit
import SnapKit
import Lottie

enum PageType {
    case welcome
    case features
    case enjoy
    
    var title: String {
        switch self {
        case .welcome: return "Onboarding.Welcome.Title".localize()
        case .features: return "Onboarding.Features.Title".localize()
        case .enjoy: return "Onboarding.Enjoy.Title".localize()
        }
    }
    
    var text: String {
        switch self {
        case .welcome:
            return "Onboarding.Welcome.Text".localize()
        case .features:
            return "Onboarding.Features.Text".localize()
        case .enjoy:
            return "Onboarding.Enjoy.Text".localize()
        }
    }
    
    var hasBtn: Bool {
        return self == .enjoy
    }
    
    var animation: String {
        switch self {
        case .welcome: return "Editing Shapes"
        case .features: return "Techno"
        case .enjoy: return "Location"
        }
    }
}

class PageViewController: UIViewController {
    
    let pageType: PageType
    
    let stack = UIStackView()
    
    let lbl = UILabel()
    let animationView = AnimationView()
    let lblDetail = PaddingLabel()
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
        setupAnimationImg()
        setupDetailText()
        stack.addArrangedSubview(spacer)
        if pageType.hasBtn {
            setupBtn()
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        animationView.play()
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        animationView.pause()
//    }
    
    private func setupStack() {
        view.addSubview(stack)
        
        stack.spacing = 40
        stack.axis = .vertical
        
        stack.snp.makeConstraints {
            //$0.centerY.equalToSuperview()
            $0.top.equalToSuperview().offset(200)
            $0.left.equalToSuperview().offset(28)
            $0.right.equalToSuperview().offset(-28)
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
    
    private func setupAnimationImg() {
        stack.addArrangedSubview(animationView)
        animationView.snp.makeConstraints {
            $0.height.equalTo(180)
        }
        
        animationView.animation = Animation.named(pageType.animation)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
    }
    
    private func setupDetailText() {
        stack.addArrangedSubview(lblDetail)
        lblDetail.backgroundColor = .secondarySystemBackground
        lblDetail.layer.masksToBounds = true
        lblDetail.layer.cornerRadius = 12
        lblDetail.textAlignment = pageType == .features ? .left : .center
        lblDetail.font = .appFont.text
        lblDetail.text = pageType.text
        lblDetail.numberOfLines = 0
    }
    
    private func setupBtn() {
        view.addSubview(btn)

        btn.configuration = .filled()
        btn.setTitle("Onboarding.ToTheApp".localize(), for: .normal)
        btn.titleLabel?.font = .appFont.text
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
