//
//  OnboardingContainerViewController.swift
//  juinjang
//
//  Created by 조유진 on 8/21/24.
//

import UIKit

protocol ShowLoginButtonDelegate: AnyObject {
    func showLoginButton()
}

final class OnboardingContainerViewController: UIViewController {
    private let goLoginButton = UIButton()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pageViewControllerList: [UIViewController] = []
    private var initialPage = 0
    
    private var pageControl = UIPageControl()
    private var isShowingLoginButton = false
    
    
    init() {
        print("OnboardingContainerViewController Init")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("OnboardingContainerViewController Init")
    }
    
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
        reportOnboardingVC.showLoginButtonDelegate = self
        
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
        
        var config = UIButton.Configuration.filled()
        config.title = "로그인 페이지로"
        config.titleAlignment = .center
        config.baseForegroundColor = ColorStyle.textWhite
        config.baseBackgroundColor = ColorStyle.textBlack
        config.background.cornerRadius = 10
 
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        config.attributedTitle = AttributedString("로그인 페이지로", attributes: container)
        
        goLoginButton.configuration = config
        goLoginButton.alpha = 0
        goLoginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        changeLoginVC()
    }
    
    private func setLoginButtonLayout() {
        view.addSubview(goLoginButton)
        goLoginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(52)
        }
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

extension OnboardingContainerViewController: ShowLoginButtonDelegate {
    func showLoginButton() {
        if isShowingLoginButton == false {
            isShowingLoginButton = true
            // 로그인 버튼 보여주기
            setLoginButtonLayout()
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, animations: { [weak self] in
                guard let self else { return }
                goLoginButton.alpha = 1
            })
        }
    }
}
