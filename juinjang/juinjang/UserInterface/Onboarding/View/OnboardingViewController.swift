//
//  OnboardingViewController.swift
//  juinjang
//
//  Created by 조유진 on 8/21/24.
//

import UIKit
import AVFoundation

final class OnboardingViewController: UIViewController {
    let titleLabel = UILabel()      // 온보딩 텍스트
    let videoPlayer = AVPlayer()    // 온보딩 영상
    var item1: OnboardingItem
    var item2: OnboardingItem
    
    init(item1: OnboardingItem, item2: OnboardingItem) {
        self.item1 = item1
        self.item2 = item2
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
    
    private func configureHierarchy() {
        view.addSubview(titleLabel)
        
    }
    
    private func configureLayout() {
        
    }
    
    private func configureView() {
        
    }
}
