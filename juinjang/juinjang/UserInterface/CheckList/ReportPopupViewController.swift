//
//  ReportPopupViewController.swift
//  juinjang
//
//  Created by 임수진 on 2/2/24.
//

import UIKit
import Then

class ReportPopupViewController: BaseViewController {
    
    var delegate: ButtonStateDelegate?
    
    // 팝업 View
    lazy var popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    // 팝업 메시지 Label
    lazy var messageLabel = UILabel().then {
        $0.text = "리포트는 체크리스트 입력 후 볼 수 있어요.\n지금 입력을 시작해 볼까요?"
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
//        $0.setLineSpacing(spacing: 3)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    // 돌아가기 Button
    lazy var backButton = UIButton().then {
        $0.setTitle("돌아가기", for: .normal)
        $0.setTitleColor(UIColor(named: "textBlack"), for: .normal)
        
        $0.backgroundColor = UIColor(named: "gray3")
        $0.layer.cornerRadius = 8
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }
    
    // 체크리스트 입력 Button
    lazy var checklistButton = UIButton().then {
        $0.setTitle("체크리스트 입력", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        
        $0.backgroundColor = UIColor(named: "textBlack")
        $0.layer.cornerRadius = 8
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(inputAction(_:)), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) // 흐리게 만듦
        setupWidgets()
        setupLayout()
     }
    
    func setupWidgets() {
        view.addSubview(popupView)
        [messageLabel, backButton, checklistButton].forEach { popupView.addSubview($0)}
    }
    
    func setupLayout() {
        
        // 팝업 View
        popupView.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
            $0.width.equalTo(342)
            $0.height.equalTo(234)
        }
        
        // 팝업 메시지
        messageLabel.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX)
            $0.top.equalTo(popupView.snp.top).offset(68)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-120)
        }
        
        // "돌아가기" Button
        backButton.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX).offset(-81)
            $0.top.equalTo(popupView.snp.top).offset(169)
            $0.leading.equalTo(popupView.snp.leading).offset(12)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-13)
        }
        
        // "체크리스트 입력" Button
        checklistButton.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX).offset(81.5)
            $0.top.equalTo(popupView.snp.top).offset(169)
            $0.leading.equalTo(backButton.snp.trailing).offset(7)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-13)
        }
    }
    
    @objc func backAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func inputAction(_ sender: UIButton) {
        // TODO: 수정모드 진입은 되나 버튼 이미지가 안 바뀌는 거 변경해야됨
        NotificationCenter.default.post(name: NSNotification.Name("EditButtonTapped"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("EditModeChanged"), object: true)
        delegate?.updateButtonState(isSelected: true)
        dismiss(animated: false, completion: nil)
    }
}

protocol ButtonStateDelegate {
    func updateButtonState(isSelected: Bool)
}
