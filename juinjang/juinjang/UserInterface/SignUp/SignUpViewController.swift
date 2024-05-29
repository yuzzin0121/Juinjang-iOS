//
//  SignUpViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/16.
//

import UIKit
import Then
import SnapKit
import Alamofire

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

import AuthenticationServices

class SignUpViewController: BaseViewController {

    lazy var juinjangLogoImage = UIImageView().then {
        $0.image = UIImage(named: "juinjang-logo-image")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var juinjangLogo = UIImageView().then {
        $0.image = UIImage(named: "juinjang-logo")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var kakaoLoginButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "kakao-logo"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var appleLoginButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "apple-logo"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(appleButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var guideLabel = UILabel().then {
        $0.text = "소셜 계정을 통해\n로그인 또는 회원가입을 진행해 주세요."
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = ColorStyle.darkGray
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
        addSubViews()
        setupLayout()
    }
    
    func addSubViews() {
        [juinjangLogoImage,
         juinjangLogo,
         kakaoLoginButton,
         appleLoginButton,
         guideLabel].forEach { view.addSubview($0) }
    }
    
    func setupLayout() {
        // 주인장 로고 이미지 ImageView
        juinjangLogoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.height * 0.18)
        }

        // 주인장 로고 ImageView
        juinjangLogo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(juinjangLogoImage.snp.bottom).offset(view.frame.height * 0.02)
        }

        // 로그인 Stack View
        let loginStackView = UIStackView(arrangedSubviews: [kakaoLoginButton, appleLoginButton])

        loginStackView.axis = .horizontal
        loginStackView.spacing = view.frame.width * 0.055

        view.addSubview(loginStackView)

        loginStackView.snp.makeConstraints {
            $0.top.equalTo(juinjangLogo.snp.bottom).offset(view.frame.height * 0.13)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.centerX.equalToSuperview()
        }

        // 안내 Label
        guideLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginStackView.snp.bottom).offset(view.frame.height * 0.06)
        }
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            loginWithApp()
        } else {
            // 만약, 카카오톡이 깔려있지 않을 경우에는 웹 브라우저로 카카오 로그인함.
            loginWithWeb()
        }
            
    }
    @objc func appleButtonTapped(_ sender: UIButton) {
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
            
    }
}

extension SignUpViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // 카카오톡 앱으로 로그인
    func loginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print("app\(error)")
            } else {
                print("loginWithKakaoTalk() success.")
                self.getUserInfo()
            }
        }
    }

    // 카카오톡 웹으로 로그인
    func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount {(_, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                self.getUserInfo()
            }
        }
    }
    func getUserInfo() {
        UserApi.shared.me {(user, error) in
            if let error = error {
                print(error)
            } else {
                if let kakaoUser = user {
                    if let email = kakaoUser.kakaoAccount?.email, let nickname = kakaoUser.kakaoAccount?.profile?.nickname {
                        //print("사용자 이메일 : \(email)")
                        UserDefaultManager.shared.email = email
                        UserDefaultManager.shared.nickname = nickname
                        self.sendPostRequest(email: UserDefaultManager.shared.email, nickname: UserDefaultManager.shared.nickname)
                    } else {
                        print("사용자가 이메일 제공에 동의하지 않았습니다.")
                    }
                }
            }
        }
    }
    
    struct RequestBody: Encodable {
        let email: String
        let nickname: String?
    }
    
    func sendPostRequest(email: String, nickname: String?) {
        let url = "http://juinjang1227.com:8080/api/auth/kakao/login"
        let requestBody = RequestBody(email: email, nickname: nickname)
            
        AF.request(url, method: .post, parameters: requestBody, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("API Success: \(value)")
                    if let json = value as? [String: Any],
                       let result = json["result"] as? [String: Any],
                       let accessToken = result["accessToken"] as? String,
                       let refreshToken = result["refreshToken"] as? String {
                        //print("Success: \(accessToken)")
                        UserDefaultManager.shared.accessToken = accessToken
                        //print("Success: \(refreshToken)")
                        UserDefaultManager.shared.refreshToken = refreshToken
                        self.getUserNickname()
                        
                    } else {
                        print(value)
                        print("회원가입")
                        if let json = value as? [String: Any],
                           let code = json["code"] as? String, code == "MEMBER4001" {
                            // MEMBER4001 에러 코드일 때 다른 화면으로 전환
                            let nextVC = ToSViewController()
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        } 
                    }
                case .failure(let error):
                    print("APIError: \(error)")
                }
        }
    }
    
    func authorizationController( controller: ASAuthorizationController,
                didCompleteWithAuthorization authorization: ASAuthorization) {
//        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
//            return
//        }
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName)")
            print("email: \(email)")
            
            //print(credential.user)
            //print("애플 로그인 성공")
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패 \(error.localizedDescription)")
    }
    
    func getUserNickname() {
        let urlString = "http://juinjang1227.com:8080/api/profile"
        
        // HTTP 요청 보내기
        AF.request(urlString, method: .get, headers: HTTPHeaders(["Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"]), interceptor: AuthInterceptor()).responseData { [self] response in
            switch response.result {
            case .success(let data):
                // 응답 확인
                if let httpResponse = response.response {
                    print("Status code: \(httpResponse.statusCode)")
                    //print("Token: \(UserDefaultManager.shared.accessToken)")
                }
                // 응답 데이터 출력
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
                // JSON 데이터 파싱
                do {
                    let userInfoResponse = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                    let nickname = userInfoResponse.result.nickname
                    if let profileImage = userInfoResponse.result.image, let imageUrl = URL(string: profileImage) {
                        loadImage(from: imageUrl) { image in
                            if let image = image {
                                // 이미지 로드 성공
                                print("이미지 로드 성공")
                                UserDefaultManager.shared.profileImage = image
                            } else {
                                // 이미지 로드 실패
                                print("imageLoad Fail")
                            }
                        }
                    }
                    //print("Nickname : \(nickname ?? "")")
                    UserDefaultManager.shared.nickname = nickname ?? ""
                } catch {
                    print("Error parsing JSON: \(error)")
                                                                  
                }
                print("present to Main")
                changeHome()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
}
