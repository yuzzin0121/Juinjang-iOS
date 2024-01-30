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
        $0.textColor = UIColor(named: "normalText")
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 16, weight: .semiBold)
    }
    
    let contentDetailLabel = UILabel().then {
        $0.textColor = UIColor(named: "normalText")
        $0.numberOfLines = 0
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
        }
        
        // 콘텐트 Label
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.top.equalTo(contentView.snp.top).offset(16)
        }
        
        // 콘텐트 상세 Label
        contentDetailLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
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
        // -TODO: itemtableView의 checkButton 체크 상태로 변경시키기
        navigationController?.popViewController(animated: true)
    }
}
