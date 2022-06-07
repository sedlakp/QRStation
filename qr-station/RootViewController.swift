//
//  RootViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 05.06.2022.
//

//https://stasost.medium.com/ios-root-controller-navigation-3625eedbbff

import UIKit

class RootViewController: UIViewController {
    
    private var current: UIViewController
    
    init() {
        if UserDefaults.standard.bool(forKey: DefaultsKeys.seenOnboarding.rawValue) {
            self.current = CustomTabBarViewController()
        } else {
            self.current = OnboardingPageViewController()
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
       
       transition(from: current, to: new, duration: 0.9, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
       }) { completed in
           self.current.removeFromParent()
           new.didMove(toParent: self)
           self.current = new
           completion?()
       }
    }
    
    
    func switchToMainApp() {
        let new = CustomTabBarViewController()
        animateFadeTransition(to: new)
//        addChild(new)
//        new.view.frame = view.bounds
//        view.addSubview(new.view)
//        new.didMove(toParent: self)
//        current.willMove(toParent: nil)
//        current.view.removeFromSuperview()
//        current.removeFromParent()
//        current = new
    }
 

}
