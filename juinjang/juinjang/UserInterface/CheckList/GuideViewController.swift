//
//  GuideViewController.swift
//  juinjang
//
//  Created by 임수진 on 7/21/24.
//

import UIKit
import Then
import SnapKit

class GuideViewController: UIViewController {
    
    private let imageView =  UIImageView().then {
        $0.image = UIImage(named: "guide-checklist")
        $0.contentMode = .scaleToFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupView() {
        view.addSubview(imageView)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    @objc private func handleTap() {
        dismiss(animated: true, completion: nil)
    }
}
