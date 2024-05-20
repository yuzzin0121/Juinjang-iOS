//
//  WelcomeViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/16.
//

import UIKit
import Then
import SnapKit
import Alamofire

class WelcomeViewController: UIViewController {
    
    var userInfo: UserInfo?
    
    lazy var backgroundImage = UIImageView().then {
        $0.image = UIImage(named: "welcome-background")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var greetingLabel = UILabel().then {
        $0.text = "반가워요, 땡땡님"
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
        $0.asColor(targetString: "땡땡", color: UIColor(named: "mainOrange"))
    }
    
    lazy var guideLabel1 = UILabel().then {
        $0.text = "주인장과 함께"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
    }
    
    lazy var guideLabel2 = UILabel().then {
        $0.text = "똑똑한 임장 노트를"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
    }
    
    lazy var guideLabel3 = UILabel().then {
        $0.text = "만들어봐요!"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
    }

    lazy var imjangNoteImage = UIImageView().then {
        $0.image = UIImage(named: "welcome-imjang-note")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var nickNameLabel = UILabel().then {
        $0.text = "땡땡"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "omyu pretty", size: 14)
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        $0.backgroundColor = UIColor(named: "textBlack")
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
        fadeIn()
        setNavigationBar()
        addSubViews()
        setupLayout()
        setNickname()
    }
    
    func fadeIn() {
        greetingLabel.alpha = 0
        guideLabel1.alpha = 0
        guideLabel2.alpha = 0
        guideLabel3.alpha = 0
        
        // 페이드 인 애니메이션을 순차적으로 실행
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.greetingLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                self.guideLabel1.alpha = 1
                self.guideLabel2.alpha = 1
                self.guideLabel3.alpha = 1
            }, completion: nil)
        })
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        let backButtonImage = UIImage(named: "arrow-left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain,target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    func addSubViews() {
        [backgroundImage,
         greetingLabel,
         guideLabel1,
         guideLabel2,
         guideLabel3,
         imjangNoteImage,
         nextButton].forEach { view.addSubview($0) }
        imjangNoteImage.addSubview(nickNameLabel)
    }
    
    func setupLayout() {
        // 배경 ImageView
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 인사 Label
        greetingLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0.04 * view.bounds.height)
            $0.centerX.equalToSuperview()
        }

        // 안내 Label
        guideLabel1.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(0.06 * view.bounds.height)
            $0.height.lessThanOrEqualTo(0.08 * view.bounds.height)
            $0.centerX.equalToSuperview()
        }

        guideLabel2.snp.makeConstraints {
            $0.top.equalTo(guideLabel1.snp.bottom).offset(0.03 * view.bounds.height)
            $0.height.lessThanOrEqualTo(0.08 * view.bounds.height)
            $0.centerX.equalToSuperview()
        }

        guideLabel3.snp.makeConstraints {
            $0.top.equalTo(guideLabel2.snp.bottom).offset(0.03 * view.bounds.height)
            $0.height.lessThanOrEqualTo(0.08 * view.bounds.height)
            $0.centerX.equalToSuperview()
        }

        // 임장 노트 ImageView
        imjangNoteImage.snp.makeConstraints {
            $0.top.equalTo(guideLabel3.snp.bottom).offset(0.07 * view.bounds.height)
            $0.centerX.equalToSuperview()
        }

        // 닉네임 Label
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(imjangNoteImage.snp.top).offset(43.19)
            $0.centerX.equalToSuperview().offset(-8)
//            $0.width.equalTo(23)
            $0.height.equalTo(19)
        }

        // 입력 완료 Button
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-0.03 * view.bounds.height)
            $0.width.equalTo(202)
            $0.height.equalTo(52)
        }
    }
    
    func setNickname() {
        if let nickname = userInfo?.nickname {
            greetingLabel.text = "반가워요, \(nickname)님"
            nickNameLabel.text = nickname
            greetingLabel.asColor(targetString: nickname, color: UIColor(named: "mainOrange"))
            print("사용자가 설정한 닉네임: \(nickname)")
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        //UserDefaultManager.shared.userStatus = true
        signupRequest(email: UserDefaultManager.shared.email, kakaoNickname: UserDefaultManager.shared.nickname, nickname: UserDefaultManager.shared.nickname)
//        let RecordingRightsVC = RecordingRightsViewController()
//        RecordingRightsVC.modalPresentationStyle = .fullScreen
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationController?.pushViewController(RecordingRightsVC, animated: true)
    }
    func signupRequest(email: String, kakaoNickname: String?, nickname: String) {
            let parameters: [String: Any] = [
                "email": email,
                "kakaoNickname": kakaoNickname ?? NSNull(),
                "nickname": nickname
            ]

            AF.request("http://juinjang1227.com:8080/api/auth/kakao/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        print(value) // 서버에서 받은 응답을 출력하거나 필요한 처리를 진행합니다.
                        if let json = value as? [String: Any],
                           let isSuccess = json["isSuccess"] as? Bool,
                           let result = json["result"] as? [String: Any],
                           let accessToken = result["accessToken"] as? String,
                           let refreshToken = result["refreshToken"] as? String,
                           isSuccess {
                            // 응답이 성공이라면 다음 ViewController로 이동합니다.
                                print("Success: \(accessToken)")
                                UserDefaultManager.shared.accessToken = accessToken
                                print("Success: \(refreshToken)")
                                UserDefaultManager.shared.refreshToken = refreshToken
                            let RecordingRightsVC = RecordingRightsViewController()
                            RecordingRightsVC.modalPresentationStyle = .fullScreen
                            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                            self.navigationController?.pushViewController(RecordingRightsVC, animated: true)
                        } else {
                            // 실패 처리 로직을 추가할 수 있습니다.
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        // 실패 처리 로직을 추가할 수 있습니다.
                    }
                }
        }
}
