//
//  AccountDeleteFinalViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/19/24.
//

import UIKit
import Then
import SnapKit
import Alamofire
import AuthenticationServices

class AccountDeleteFinalViewController: BaseViewController {
    
    var accountDeleteFinalView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
    }
    
    var logoImageView = UIImageView().then {
        $0.image = UIImage(named:"deleteLogo")
    }
    
    var bigMent = UILabel().then {
        $0.text = "더 나은 주인장이 되도록 \n노력할게요"
        $0.numberOfLines = 0
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "600")
        
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
    }
    var smallMent = UILabel().then {
        $0.text = "불편했던 점을 남겨주시면 주인장 팀에 큰 도움이 됩니다. \n다음에 또 만나요!"
        $0.numberOfLines = 0
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
        
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
    }
    
    let buttonList = ["더 이상 쓸 일이 없어요", "앱 사용법을 모르겠어요", "임장에 도움이 되지 않아요", "앱이 정상적으로 작동하기 않아요", "보안이 걱정돼요", "다른 서비스가 더 좋아요"]
    
    var btnArry : [UIButton] = []
    
    var noButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("취소하고 돌아갈래요", for: .normal)
        $0.backgroundColor = UIColor(named: "600")
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.layer.cornerRadius = 10
    }
    var yesButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(named: "juinjang")
        $0.setTitle("계정 삭제하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.layer.cornerRadius = 10
    }
    
    func setConstraint() {
        accountDeleteFinalView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        logoImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(33)
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(49)
            $0.height.equalTo(51)
        }
        bigMent.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(31)
            $0.left.equalToSuperview().offset(24)
        }
        smallMent.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(114)
            $0.left.equalToSuperview().offset(24)
        }
        noButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(93)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
        yesButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
    }
    
    @objc
    func btnSelected(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = UIColor(named: "main200")
            sender.layer.borderWidth = 1.5
            sender.layer.borderColor = UIColor(red: 1, green: 0.664, blue: 0.475, alpha: 1).cgColor
            sender.setTitleColor(UIColor(named: "juinjang"), for: .normal)
            
        } else {
            sender.backgroundColor = UIColor(named: "100")
            sender.layer.borderWidth = 0
            sender.layer.borderColor = .none
            sender.setTitleColor(UIColor(named: "300"), for: .normal)
        }
    }
    @objc func no(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    @objc func yes(_ sender: Any) {
        if UserDefaultManager.shared.isKakaoLogin {
            withdrawKakaoAccount(accessToken: UserDefaultManager.shared.accessToken, kakaoTargetId: UserDefaultManager.shared.kakaoTargetId)
        } else {
            withdrawAppleAccount(accessToken: UserDefaultManager.shared.accessToken, xAppleCode: UserDefaultManager.shared.appleAuthCode)
        }
        
    }
    
    // 카카오톡 탈퇴 API를 호출하는 함수
    func withdrawKakaoAccount(accessToken: String, kakaoTargetId: Int64) {
        // 탈퇴 API의 URL
        let url = "http://juinjang1227.com:8080/api/auth/withdraw/kakao"
        
        // Authorization과 target-id 헤더 설정
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "target-id": String(kakaoTargetId)
        ]
        print("targetID: \(kakaoTargetId)")
        // Alamofire를 사용하여 DELETE 요청
        AF.request(url, method: .delete, headers: headers)
            .validate() // 응답의 상태 코드가 성공 범위 내에 있는지 확인
            .responseString { response in
                switch response.result {
                    case .success(let responseBody):
                    print("Response Body: \(responseBody)")
                    let signupViewController = SignUpViewController()
                    // 현재 내비게이션 컨트롤러가 nil인지 확인
                    if let navigationController = self.navigationController {
                        navigationController.pushViewController(signupViewController, animated: true)
                        print("SignUpViewController로 push됨") // 확인용 로그 추가
                    } else {
                        // 현재 내비게이션 컨트롤러가 없는 경우, 새로운 내비게이션 컨트롤러를 시작하고 SignUpViewController를 rootViewController로 설정
                        let navigationController = UINavigationController(rootViewController: signupViewController)
                        if let windowScene = UIApplication.shared.connectedScenes
                            .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
                            if let window = windowScene.windows.first {
                                window.rootViewController = navigationController
                            }
                        }
                        print("SignUpViewController로 새로운 내비게이션 스택 시작됨") // 확인용 로그 추가
                    }
                    UserDefaultManager.shared.userStatus = false
                    case .failure(let error):
                        print("Error: \(error)")
                    // 상세 오류 정보 출력
                        if let data = response.data, let errorDetails = String(data: data, encoding: .utf8) {
                            print("Error Details: \(errorDetails)")
                        }
                    }
            }       
    }
    
    // apple 탈퇴 API를 호출하는 함수
    func withdrawAppleAccount(accessToken: String, xAppleCode: String) {
        // 탈퇴 API의 URL
        let url = "http://juinjang1227.com:8080/api/auth/apple/withdraw"
        
        // Authorization과 target-id 헤더 설정
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "X-Apple-Code": xAppleCode
        ]
        
        // Alamofire를 사용하여 DELETE 요청
        AF.request(url, method: .delete, headers: headers)
            .validate() // 응답의 상태 코드가 성공 범위 내에 있는지 확인
            .responseString { response in
                switch response.result {
                case .success(let responseBody):
                    print("Response Body: \(responseBody)")
                    let signupViewController = SignUpViewController()
                    // 현재 내비게이션 컨트롤러가 nil인지 확인
                    if let navigationController = self.navigationController {
                        navigationController.pushViewController(signupViewController, animated: true)
                        print("SignUpViewController로 push됨") // 확인용 로그 추가
                    } else {
                        // 현재 내비게이션 컨트롤러가 없는 경우, 새로운 내비게이션 컨트롤러를 시작하고 SignUpViewController를 rootViewController로 설정
                        let navigationController = UINavigationController(rootViewController: signupViewController)
                        if let windowScene = UIApplication.shared.connectedScenes
                            .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
                            if let window = windowScene.windows.first {
                                window.rootViewController = navigationController
                            }
                        }
                        print("SignUpViewController로 새로운 내비게이션 스택 시작됨") // 확인용 로그 추가
                    }
                    UserDefaultManager.shared.userStatus = false
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(accountDeleteFinalView)
        accountDeleteFinalView.addSubview(logoImageView)
        accountDeleteFinalView.addSubview(bigMent)
        accountDeleteFinalView.addSubview(smallMent)
        
        for i in 0...5 {
            let selectedbutton = UIButton().then {
                $0.backgroundColor = UIColor(named: "100")
                $0.layer.cornerRadius = 10
                //$0.isUserInteractionEnabled = true
                $0.setTitle(buttonList[i], for: .normal)
                $0.titleEdgeInsets = UIEdgeInsets(top: 0,left: 16,bottom: 0,right: 0)
                $0.setTitleColor(UIColor(named: "300"), for: .normal)
                $0.contentHorizontalAlignment = .left
                $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
                $0.addTarget(self, action: #selector(btnSelected), for: .touchUpInside)
            }
            
            accountDeleteFinalView.addSubview(selectedbutton)
            selectedbutton.snp.makeConstraints {
                $0.top.equalTo(smallMent.snp.bottom).offset(20+i*62)
                $0.left.right.equalToSuperview().inset(24)
                $0.height.equalTo(54)
            }
            btnArry.append(selectedbutton)
        }
    
        accountDeleteFinalView.addSubview(noButton)
        noButton.addTarget(self, action: #selector(no), for: .touchUpInside)
        accountDeleteFinalView.addSubview(yesButton)
        yesButton.addTarget(self, action: #selector(yes), for: .touchUpInside)
        setConstraint()
    }
}

