//
//  DeletePopupViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/17/24.
//

import UIKit
import Then
import SnapKit

class DeletePopupViewController: UIViewController {
    lazy var popupView = UIView().then { // 팝업창 뷰
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var confirmButton = UIButton()
    
    lazy var cancelButton = UIButton()
    lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 7
    }
    
    lazy var messageLabel = UILabel().then {
        $0.text = "메인화면으로 돌아갈까요?\n입력한 정보는 저장되지 않습니다."
        $0.textColor = UIColor(named: "nomalText")
        $0.font = .pretendard(size: 18, weight: .medium)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    var fileIndexPath: IndexPath? = nil
    var completionHandler: ((IndexPath) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) // 흐리게 만듦
        addSubview()
        designViews()
        setConstraints()
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
        print(fileIndexPath)
    }
    
    func addSubview() {
        view.addSubview(popupView)
        popupView.addSubview(stackView)
        [cancelButton, confirmButton].forEach {
            stackView.addArrangedSubview($0)
        }
        popupView.addSubview(messageLabel)
    }
    
    func designViews() {
        designButton(cancelButton, title: "아니요", backgroundColor: UIColor(named: "buttonGray")!)
        designButton(confirmButton, title: "예", backgroundColor: UIColor(named: "textBlack")!, textColor: .white)
    }
    
    func setConstraints() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        // 팝업창 위치 설정
        popupView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(view)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.height.equalTo(popupView.snp.width).multipliedBy(234.0 / 342.0)
        }
//        NSLayoutConstraint.activate([
//            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            popupView.widthAnchor.constraint(equalToConstant: 342),
//            popupView.heightAnchor.constraint(equalToConstant: 234)
//        ])
        
        messageLabel.snp.makeConstraints {
            $0.centerX.equalTo(popupView)
            $0.top.equalTo(popupView.snp.top).offset(65)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalTo(popupView)
            $0.leading.equalTo(popupView.snp.leading).offset(12)
            $0.trailing.equalTo(popupView.snp.trailing).offset(-12)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-13)
            $0.height.equalTo(52)
        }
        

//        NSLayoutConstraint.activate([
//            messageLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
//            messageLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 65)
//        ])
        
        // "아니요" 버튼 위치 설정
//        NSLayoutConstraint.activate([
//            cancelButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: -81),
//            cancelButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 169),
//            cancelButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 12),
//            cancelButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -13)
//        ])
//        
//        // "예" 버튼 위치 설정
//        NSLayoutConstraint.activate([
//            confirmButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: 81.5),
//            confirmButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 169),
//            confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 7),
//            confirmButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -13)
//        ])
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
//        guard let navigationController = window.rootViewController as? UINavigationController else {
//            // 네비게이션 컨트롤러가 nil인 상태 혹은 not found
//            return
//        }
//        
//        navigationController.popToRootViewController(animated: true)
        self.completionHandler?(fileIndexPath!)
        dismiss(animated: false, completion: nil)

        
        // 현재 나타난 팝업창을 찾아서 닫기
//        if let presentedViewController = navigationController.presentedViewController {
//            guard let fileIndexPath = fileIndexPath else { return }
//            self.completionHandler?(fileIndexPath)
//            presentedViewController.dismiss(animated: false, completion: nil)
//        }
    }
    
    func designButton(_ button: UIButton, title: String = "확인", backgroundColor: UIColor = .white, textColor: UIColor = UIColor(named: "textBlack")!) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 8
        
        button.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.lineBreakMode = .byTruncatingTail
    }

}
