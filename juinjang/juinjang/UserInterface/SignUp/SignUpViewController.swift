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
                    print("Response image data: \(responseString)")
                }
                // JSON 데이터 파싱
                do {
                    print("여기유")
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
                    } else {
                        UserDefaultManager.shared.profileImage = UIImage(named:"profileImage")
                    }
                    //print("Nickname : \(nickname ?? "")")
                    UserDefaultManager.shared.nickname = nickname ?? ""
                } catch {
                    print("Error parsing JSON: \(error)")
                                                                  
                }
                print("present to Main")
                let nextVC = MainViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
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

//카카오 로그인
extension SignUpViewController{
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
    struct UserInfoResponse: Codable {
        let isSuccess: Bool
        let code: String
        let message: String
        let result: UserInfoResult
    }
    struct UserInfoResult: Codable {
        let nickname: String?
        let email: String
        let provider: String
        let image: String?
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
            self.email = try container.decode(String.self, forKey: .email)
            self.provider = try container.decode(String.self, forKey: .provider)
            self.image = try container.decodeIfPresent(String.self, forKey: .image)
        }
    }
    func sendPostRequest(email: String, nickname: String?) {
        let url = "http://juinjang1227.com:8080/api/auth/kakao/login"
        let requestBody = RequestBody(email: email, nickname: nickname)
            
        AF.request(url, method: .post, parameters: requestBody, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    UserDefaultManager.shared.isKakaoLogin = true
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
                        if let json = value as? [String: Any],
                           let code = json["code"] as? String, code == "MEMBER4001" {
                            print("회원가입")
                            // MEMBER4001 에러 코드일 때 다른 화면으로 전환
                            let nextVC = ToSViewController()
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                        if let json = value as? [String: Any],
                           let code = json["code"] as? String, code == "MEMBER4003" {
                            print("이미 애플로그인 했다미")
                            let alertController = UIAlertController(title: nil, message: "이미 Apple로 회원가입한 회원입니다", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    print("APIError: \(error)")
                }
        }
    }
}

//애플 로그인
extension SignUpViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {

    struct ResponseBody: Codable {
        let isSuccess: Bool
        let code: String
        let message: String
        let result: Result

        struct Result: Codable {
            let accessToken: String
            let refreshToken: String
            let email: String
        }
    }
    func performAppleSignInWithAlamofire(identityToken: String) {
        // Set the URL for the API endpoint
        let url = "http://juinjang1227.com:8080/api/auth/apple/login"
        
        // Create the parameters
        let parameters: [String: Any] = [
            "identityToken": identityToken
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseString(encoding: .utf8) { response in
                switch response.result {
            case .success(let value):
                UserDefaultManager.shared.isKakaoLogin = false
                // 전체 응답 본문 출력
                print("Response: \(value)")
                // JSON 파싱
                if let jsonData = value.data(using: .utf8) {
                    if value.contains("\"isSuccess\":true") {
                        do {
                            let responseBody = try JSONDecoder().decode(ResponseBody.self, from: jsonData)
                            let accessToken = responseBody.result.accessToken
                            let refreshToken = responseBody.result.refreshToken
                            let email = responseBody.result.email
                            print("Access Token: \(accessToken)")
                            print("Refresh Token: \(refreshToken)")
                            UserDefaultManager.shared.accessToken = accessToken
                            UserDefaultManager.shared.refreshToken = refreshToken
                            UserDefaultManager.shared.email = email
                            self.getUserNickname()
                        } catch {
                            print("JSON Decoding Error: \(error)")
                        }
                    } else {
                        if value.contains("\"code\":\"MEMBER4001\"") {
                            print("회원가입")
                            let nextVC = ToSViewController()
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        } else if value.contains("\"code\":\"MEMBER4006\""){
                            print("이미 카카오로그인 했다미")
                            let alertController = UIAlertController(title: nil, message: "이미 Kakao로 회원가입한 회원입니다", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            print("회원가입 실패 또는 다른 에러")
                        }
                    }
                } else {
                    print("Failed to convert response to JSON data")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        print(credential.authorizationCode)
        
        // MARK: - 이메일
        // 처음 애플 로그인 시 이메일은 credential.email 에 들어있다.
        if let email = credential.email {
            print("이메일 : \(email)")
        }
        // 두번째부터는 credential.email은 nil이고, credential.identityToken에 들어있다.
        else {
            // credential.identityToken은 jwt로 되어있고, 해당 토큰을 decode 후 email에 접근해야한다.
            if let tokenString = String(data: credential.identityToken ?? Data(), encoding: .utf8) {
                let email2 = Utils.decode(jwtToken: tokenString)["email"] as? String ?? ""
                print("이메일 - \(email2)")
                print("identityToken : \(tokenString)")
                UserDefaultManager.shared.identityToken = tokenString
                performAppleSignInWithAlamofire(identityToken: tokenString)
            }
        }
        
           // MARK: - 이름
        // 처음 애플 로그인 시 이메일은 credential.fullName 에 들어있다.
        if let fullName = credential.fullName {
            print("이름 : \(fullName.familyName ?? "")\(fullName.givenName ?? "")")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패 \(error.localizedDescription)")
    }
}

class Utils {
    // MARK: - JWT decode
    static func decode(jwtToken jwt: String) -> [String: Any] {
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")

            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }

        func decodeJWTPart(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value),
                  let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
            }
            return payload
        }
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
}
