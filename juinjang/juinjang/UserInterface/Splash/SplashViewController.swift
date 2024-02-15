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
import AlamofireImage

class SplashViewController: UIViewController {
    
    let animationView = LottieAnimationView(name: "splash-ezgif.com-gif-to-mp4-converter.mp4.lottie.json").then {
        $0.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        $0.contentMode = .scaleAspectFit
    }
    
    func hasLogin() {
        if UserDefaultManager.shared.userStatus {
            let mainVC = MainViewController()
            let nav = UINavigationController(rootViewController: mainVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        } else {
            let signupVC = SignUpViewController()
            let nav = UINavigationController(rootViewController: signupVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
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
