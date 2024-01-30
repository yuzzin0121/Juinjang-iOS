//
//  ToSDetailViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/30/24.
//

import UIKit
import Then
import SnapKit

class ToSDetailViewController: UIViewController {
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = UIColor(named: "gray0")
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "gray4")?.cgColor
    }
    
    let contentView = UIView()
    
    lazy var contentLabel = UILabel().then {
        $0.text = "주인장 이용약관"
        $0.textColor = UIColor(named: "normalText")
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 16, weight: .semiBold)
    }
    
    lazy var contentDetailLabel = UILabel().then {
        $0.text = "제1장 총칙\n\n제 1조 (목적)\n이 약관은 주인장이 제공하는 주인장서비스(이하 “서비스”라 합니다)와 관련하여, 주인장과 이용 고객 간에 서비스의 이용조건 및 절차, 주인장은 회원의 관리, 의무 및 기타 필요한 사항을 규정함을 목적으로 합니다."
        $0.textColor = UIColor(named: "normalText")
        $0.numberOfLines = 3
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 14, weight: .regular)
    }
    
    lazy var agreeButton = UIButton().then {
        $0.setTitle("동의하고 화면 닫기", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        $0.backgroundColor = UIColor(named: "textBlack")
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar()
        addSubViews()
        setupLayout()
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "주인장 이용약관"
        self.navigationItem.hidesBackButton = true
        let cancelButtonImage = UIImage(named: "cancel-black")
        let cancelButton = UIBarButtonItem(image: cancelButtonImage, style: .plain,target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addSubViews() {
        [scrollView,
         agreeButton].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        [contentLabel,
         contentDetailLabel].forEach { contentView.addSubview($0) }
    }
    
    func setupLayout() {
        // 스크롤 뷰
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(46)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(agreeButton.snp.top).offset(-12)
        }
        
        // 콘텐트 뷰
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalTo(view.snp.height).multipliedBy(1.1)
        }
        
        // 콘텐트 Label
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.top.equalTo(contentView.snp.top).offset(16)
        }
        
        // 콘텐트 상세 Label
        contentDetailLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        // 화면 닫기 Button
        agreeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(52)
        }
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
