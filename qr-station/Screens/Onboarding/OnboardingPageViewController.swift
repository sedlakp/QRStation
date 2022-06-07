//
//  OnboardingPageViewController.swift
//  qr-station
//
//  Created by Petr Sedlák on 05.06.2022.
//

import UIKit
import SnapKit

class OnboardingPageViewController: UIViewController {
    
    var onboardingPages: [PageViewController] = {
        var pages: [PageViewController] = []
        
        pages.append(PageViewController(type: .welcome))
        pages.append(PageViewController(type: .features))
        pages.append(PageViewController(type: .enjoy))
        
        return pages
    }()
    
    var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageController()
    }
    
    private func setupPageController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([onboardingPages.first!], direction: .forward, animated: true)
    }

}


extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? PageViewController else { return nil}
        if let index = onboardingPages.firstIndex(of: viewController) {
            return index > 0 ? onboardingPages[index - 1] : nil
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? PageViewController else { return nil}
        if let index = onboardingPages.firstIndex(of: viewController) {
            return index < onboardingPages.count - 1 ? onboardingPages[index + 1] : nil
        }
        return nil
    }
    
    
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
}
