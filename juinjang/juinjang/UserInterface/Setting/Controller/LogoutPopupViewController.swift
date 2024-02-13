//
//  LogoutPopupViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/10/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class LogoutPopupViewController: UIViewController {
    
    private let popupView: LogoutPopupView
    @objc func no(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func yes(_ sender: UIButton) {
        print("logout() success.")
        logout()
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
    }
  
    func logout() {
        // 로그아웃 API의 URL
        let urlString = "http://juinjang1227.com:8080/api/auth/logout"
        // Authorization 헤더에 포함할 토큰
        print("토큰값: \(UserDefaultManager.shared.refreshToken)")
        // HTTP 요청 보내기
        AF.request(urlString, method: .post, headers: HTTPHeaders(["Authorization": "Bearer \(UserDefaultManager.shared.refreshToken)"])).responseData { response in
            switch response.result {
            case .success(let data):
                // 응답 확인
                if let httpResponse = response.response {
                    print("Status code: \(httpResponse.statusCode)")
                }
                // 응답 데이터 출력
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    init(name: String, email: String, ment: String) {
        self.popupView = LogoutPopupView(name: name, email: email, ment: ment)
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) { fatalError() }
}

