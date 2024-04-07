//
//  SetNickNameViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/16.
//

import UIKit
import Then
import SnapKit
import Alamofire

class SetNickNameViewController: UIViewController {
    
    lazy var introLabel = UILabel().then {
        $0.text = "당신을 위한 노트를 준비했어요"
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = ColorStyle.normalText
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    lazy var guideLabel = UILabel().then {
        $0.text = "임장 노트에\n이름을 적어볼까요?"
        $0.numberOfLines = 2
        $0.textAlignment = .left
        $0.textColor = ColorStyle.normalText
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
        $0.asColor(targetString: "임장 노트", color: ColorStyle.mainOrange)
    }

    lazy var imjangNoteImage = UIImageView().then {
        $0.image = UIImage(named: "imjang-note")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var textFieldContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
    }
    
    lazy var nickNameTextField = UITextField().then {
        $0.layer.cornerRadius = 3
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ColorStyle.mainOrange.cgColor
        $0.textAlignment = .center
        $0.textColor = ColorStyle.normalText
        $0.font = UIFont(name: "omyu pretty", size: 20)
        $0.attributedPlaceholder = NSAttributedString(
            string: "8자 이내",
            attributes: [
                .foregroundColor: ColorStyle.gray0 as Any,
                .font: UIFont(name: "Pretendard-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20)
            ]
        )
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("입력 완료!", for: .normal)
        $0.setTitleColor(ColorStyle.textWhite, for: .normal)
        $0.backgroundColor = ColorStyle.lightGray
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        nickNameTextField.delegate = self
        setNavigationBar()
        addSubViews()
        setupLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "닉네임 정하기"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        let backButtonImage = ImageStyle.arrowLeft
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain,target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    func addSubViews() {
        [introLabel,
         guideLabel,
         imjangNoteImage,
         textFieldContainerView,
         nextButton].forEach { view.addSubview($0) }
        textFieldContainerView.addSubview(nickNameTextField)
    }
    
    func setupLayout() {
        // 소개 Label
        introLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(0.06 * view.bounds.width)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0.03 * view.bounds.height)
        }

        // 안내 Label
        guideLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(0.06 * view.bounds.width)
            $0.top.equalTo(introLabel.snp.bottom).offset(0.03 * view.bounds.height)
        }

        // 임장 노트 ImageView
        imjangNoteImage.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(guideLabel.snp.bottom).offset(0.05 * view.bounds.height)
        }

        // 텍스트 필드 감싸는 View
        textFieldContainerView.snp.makeConstraints {
            $0.leading.equalTo(imjangNoteImage.snp.leading).offset(0.16 * view.bounds.width)
            $0.top.equalTo(imjangNoteImage.snp.top).offset(0.08 * view.bounds.height)
            $0.width.equalTo(149)
            $0.height.equalTo(51)
        }

//        textFieldContainerView.bringSubviewToFront(imjangNoteImage)

        // 닉네임 TextField
        nickNameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(135)
            $0.height.equalTo(37)
        }

        // 입력 완료 Button
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-0.03 * view.bounds.height)
            $0.width.equalTo(202)
            $0.height.equalTo(52)
        }
    }
    
    func sendNickName() {
        
        // 요청 URL 설정
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)", // 예시: 인증 토큰
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "nickname": UserDefaultManager.shared.nickname
        ]

        let urlString = "http://juinjang1227.com:8080/api/nickname"

        AF.request(urlString, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseString(encoding: .utf8) { response in
                switch response.result {
                case .success(let value):
                    print("Success: \(value)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        MainViewController().refreshToken()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // -TODO: 동일한 닉네임이 존재할 경우 팝업창 띄움
//        let alertController = UIAlertController(title: "", message: "동일한 닉네임이 존재합니다.", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//        alertController.addAction(okAction)

//        present(alertController, animated: true, completion: nil)
        // -TODO: 동일한 닉네임이 존재하지 않을 경우 다음 뷰 컨트롤러로 이동
        if let nickname = nickNameTextField.text, !nickname.isEmpty {
            let welcomeViewController = WelcomeViewController()
            welcomeViewController.userInfo = UserInfo(nickname: nickname)
            UserDefaultManager.shared.nickname = nickname
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
    
    func checkNextButtonActivation() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = ColorStyle.textBlack
    }
}

extension SetNickNameViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // 모든 조건을 검사하여 버튼 상태 변경
        checkNextButtonActivation()
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        // 백 스페이스 실행 가능하도록
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        // 글자 수 제한
        guard text.count < 8 else { return false }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = "" // 입력 시작 시 placeholder를 숨김
    }
}
