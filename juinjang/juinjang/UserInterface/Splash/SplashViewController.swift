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

class SplashViewController: UIViewController {
    
    let animationView = LottieAnimationView(name: "splash-ezgif.com-gif-to-mp4-converter.mp4.lottie.json").then {
        $0.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        $0.contentMode = .scaleAspectFit
    }
    
    func hasLogin() {
        
        if UserDefaultManager.shared.userStatus {
            if UserDefaultManager.shared.accessToken.isEmpty {
                changeLoginVC()
            } else {
                changeHome()
            }
        } else {
            UserDefaultManager.shared.userStatus = true
            changeOnboardingContainerVC()
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "splash")
        
        view.addSubview(animationView)
        animationView.center = view.center
        
        animationView.play{ (finish) in
            self.hasLogin()
        }
    }
}
