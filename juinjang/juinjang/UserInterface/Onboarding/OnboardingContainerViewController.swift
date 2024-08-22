//
//  OnboardingContainerViewController.swift
//  juinjang
//
//  Created by 조유진 on 8/21/24.
//

import UIKit

final class OnboardingContainerViewController: UIViewController {
    private let goLoginButton = UIButton()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pageViewControllerList = [UIViewController]()
    private var initialPage = 0
    
    private var pageControl = UIPageControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        configureDataSource()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func setViewControllers() {
        let checkListOnboardingVC = OnboardingViewController(onboardingType: OnboardingType.checklist)
        let recordImjangOnboardingVC = OnboardingViewController(onboardingType: OnboardingType.recordImjang)
        let reportOnboardingVC = OnboardingViewController(onboardingType: OnboardingType.report)
        
        pageViewControllerList = [checkListOnboardingVC, recordImjangOnboardingVC, reportOnboardingVC]
    }
    
    private func configureDataSource() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func configureHierarchy() {
        view.addSubview(pageViewController.view)
        view.addSubview(pageControl)
        addChild(pageViewController)
    }
    
    private func configureLayout() {
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.backgroundColor = ColorStyle.textWhite
        pageControl.currentPageIndicatorTintColor = ColorStyle.mainOrange
        pageControl.pageIndicatorTintColor = ColorStyle.lightBackgroundOrange
        pageControl.backgroundColor = .clear
        
        pageControl.numberOfPages = pageViewControllerList.count
        
        guard let first = pageViewControllerList.first else { return }
        pageViewController.setViewControllers([first], direction: .forward, animated: true)
    }
}

extension OnboardingContainerViewController: UIPageViewControllerDataSource {
    // 이전 화면에 대한 구성
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 1. 현재 페이지뷰컨에 보이는 뷰컨의 인덱스를 가지고 오기
        // 2. 그 인덱스의 -1 값인 뷰컨을 리턴
        guard let currentIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    // 다음 화면에 대한 구성
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 1. 현재 페이지뷰컨에 보이는 뷰컨의 인덱스를 가지고 오기
        // 2. 그 인덱스의 +1 값인 뷰컨을 리턴
        guard let currentIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewController = pageViewController.viewControllers?.first,
              let currentIndex = pageViewControllerList.firstIndex(of: viewController) else { return 0 }
        return currentIndex
    }
}

extension OnboardingContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let currentIndex = pageViewControllerList.firstIndex(of: viewController) else { return }
        
        pageControl.currentPage = currentIndex
    }
}
