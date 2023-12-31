//
//  ViewController.swift
//  juinjang
//
//  Created by 임수진 on 2023/12/29.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        
        let button = UIButton(type: .system)
        button.setTitle("Go to Detail", for: .normal)
        button.addTarget(self, action: #selector(goToDetail), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        // 버튼 레이아웃 설정
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
            
    // 버튼 액션 메서드
    @objc func goToDetail() {
        let OpenNewPageViewController = OpenNewPageViewController()
        navigationController?.pushViewController(OpenNewPageViewController, animated: true)
    }
    
        
}

