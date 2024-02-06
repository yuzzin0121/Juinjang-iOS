//
//  SplashViewController.swift
//  juinjang
//
//  Created by 박도연 on 2/5/24.
//

import UIKit
import SnapKit
import Lottie
import Then
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class SplashViewController: UIViewController {
    
    let animationView = LottieAnimationView(name: "splash-ezgif.com-gif-to-mp4-converter.mp4.lottie.json").then {
        $0.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        $0.contentMode = .scaleAspectFit
    }
    
    func hasLogin() {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        let vc = SignUpViewController()
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                    else {
                        //기타 에러
                    }
                }
                else {
                    let vc = MainViewController()
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
        else {
            let vc = SignUpViewController()
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "juinjang")
        
        view.addSubview(animationView)
        animationView.center = view.center
        
        animationView.play{ (finish) in
            self.hasLogin()
        }
    }
}
