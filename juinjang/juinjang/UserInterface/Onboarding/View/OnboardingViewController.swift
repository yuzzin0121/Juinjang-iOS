//
//  OnboardingViewController.swift
//  juinjang
//
//  Created by 조유진 on 8/21/24.
//

import UIKit
import AVFoundation
import Lottie

final class OnboardingViewController: UIViewController {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()      // 온보딩 텍스트]
    private lazy var animationView = LottieAnimationView(name: onboardingType.item1.jsonURLString)
    private var onboardingType: OnboardingType
    
    init(onboardingType: OnboardingType) {
        self.onboardingType = onboardingType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    // MARK: viewDidAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTitle(onboardingType.item1.title, keyword: onboardingType.item1.keyword)
        animationView = LottieAnimationView(name: onboardingType.item1.jsonURLString)
        animationView.alpha = 0
        setAnimationViewLayout(isItem2: false)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self else { return }
            self.titleLabel.alpha = 1.0
        }) { _ in   // 타이틀 애니메이션 끝났을 때
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self else { return }
                self.animationView.alpha = 1.0
            }) { [weak self] _ in   // 영상뷰 애니메이션 끝났을 때
                guard let self else { return }
                // 3D 영상 재생 시작
                animationView.play { [weak self] (finish) in
                    guard let self else { return }
                    // 어플 예시 화면, 텍스트로 변경
                    startItem2Animation()
                }
            }
        }
    }
    
    private func startItem2Animation() {
        UIView.animate(withDuration: 1, delay: 0.0, options: .allowUserInteraction, animations: { [weak self] in
            guard let self else { return }
            setUIHidden(true, hiddenAlpha: 0)
        })
        setTitle(onboardingType.item2.title, keyword: onboardingType.item2.keyword)
        self.animationView = LottieAnimationView(name: onboardingType.item2.jsonURLString)
        setAnimationViewLayout(isItem2: true)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .allowUserInteraction, animations: { [weak self] in
            guard let self else { return }
            setUIHidden(false)
        }) { [weak self] _ in
            guard let self else { return }
            animationView.play()
        }
    
    }
    
    // MARK: viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setUIHidden(true)
    }
    
    private func configureHierarchy() {
        view.addSubview(stackView)
        [titleLabel, animationView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(64)
            make.top.equalToSuperview().offset(view.frame.height * 0.15)
        }
        
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(54)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(animationView.snp.width)
        }
    }
    
    private func setAnimationViewLayout(isItem2: Bool) {
        stackView.subviews.forEach { subView in
            if subView is LottieAnimationView {
                subView.removeFromSuperview()
            }
        }
        stackView.addArrangedSubview(animationView)
        
        if isItem2 {
            stackView.spacing = 0
            stackView.snp.updateConstraints { make in
                make.horizontalEdges.equalToSuperview()
            }
            stackView.layoutIfNeeded()
        } else {
            stackView.spacing = 54
            stackView.snp.updateConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(64)
            }
            stackView.layoutIfNeeded()
        }
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(54)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(animationView.snp.width)
        }
    }
    
    private func configureView() {
        stackView.design(axis: .vertical, spacing: 54)
        
        titleLabel.design(text: onboardingType.item1.title, font: .pretendard(size: 24, weight: .bold), numberOfLines: 0)
        titleLabel.setLineSpacing(spacing: 10)
        titleLabel.textAlignment = .center
        titleLabel.asColor(targetString: onboardingType.item1.keyword, color: ColorStyle.mainOrange)
        
        animationView.backgroundColor = .systemGray6
        animationView.loopMode = .playOnce
        
        
        setUIHidden(true)
    }
    
    private func setTitle(_ title: String, keyword: String) {
        titleLabel.text = title
        titleLabel.asColor(targetString: keyword, color: ColorStyle.mainOrange)
    }
    
    private func setUIHidden(_ isHidden: Bool, hiddenAlpha: Double = 0.2) {
        titleLabel.alpha = isHidden ? hiddenAlpha : 1
        animationView.alpha = isHidden ? hiddenAlpha : 1
    }
}
