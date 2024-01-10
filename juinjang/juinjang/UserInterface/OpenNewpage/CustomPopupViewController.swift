//
//  CustomPopupViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/03.
//
import UIKit
import Then

class CustomPopupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) // 흐리게 만듦
        
        lazy var popupView = UIView().then { // 팝업창 뷰
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(popupView)
        
        // 팝업창 위치 설정
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalToConstant: 342),
            popupView.heightAnchor.constraint(equalToConstant: 234)
        ])
        
        lazy var messageLabel = UILabel().then {
            $0.text = "메인화면으로 돌아갈까요?\n입력한 정보는 저장되지 않습니다."
            $0.textColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Medium", size: 18)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        popupView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 65)
        ])
        
        lazy var cancelButton = UIButton().then {
            $0.setTitle("아니요", for: .normal)
            $0.setTitleColor(UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1), for: .normal)
            
            $0.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
            $0.layer.cornerRadius = 8
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
            $0.titleLabel?.numberOfLines = 1
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.titleLabel?.minimumScaleFactor = 0.5
            $0.titleLabel?.lineBreakMode = .byTruncatingTail
            $0.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        }
        
        popupView.addSubview(cancelButton)
        
        // "아니요" 버튼 위치 설정
        NSLayoutConstraint.activate([
            cancelButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: -81),
            cancelButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 169),
            cancelButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 12),
            cancelButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -13)
        ])
        
        lazy var confirmButton = UIButton().then {
            $0.setTitle("예", for: .normal)
            $0.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            $0.backgroundColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
            $0.layer.cornerRadius = 8
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
            $0.titleLabel?.numberOfLines = 1
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.titleLabel?.minimumScaleFactor = 0.5
            $0.titleLabel?.lineBreakMode = .byTruncatingTail
            $0.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
        }
        popupView.addSubview(confirmButton)
        
        // "예" 버튼 위치 설정
        NSLayoutConstraint.activate([
            confirmButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: 81.5),
            confirmButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 169),
            confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 7),
            confirmButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -13)
        ])
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func confirmAction(_ sender: UIButton) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            // window가 nil인 상태 혹은 not found
            return
        }
        guard let navigationController = window.rootViewController as? UINavigationController else {
            // 네비게이션 컨트롤러가 nil인 상태 혹은 not found
            return
        }
        navigationController.popToRootViewController(animated: true)
        
        // 현재 나타난 팝업창을 찾아서 닫기
        if let presentedViewController = navigationController.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: nil)
        }
    }

}
