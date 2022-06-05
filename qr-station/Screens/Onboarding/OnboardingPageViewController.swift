//
//  OnboardingPageViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 05.06.2022.
//

import UIKit
import SnapKit

class OnboardingPageViewController: UIPageViewController {
    
    let btn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        btn.configuration = .filled()
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
        view.addSubview(btn)
        
        btn.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(100)
            $0.centerX.centerY.equalTo(view)
        }
    }


    @objc private func btnTapped() {
        UserDefaults.standard.set(true, forKey: DefaultsKeys.seenOnboarding.rawValue)
        SceneDelegate.shared?.rootViewController.switchToMainApp()
    }

}
