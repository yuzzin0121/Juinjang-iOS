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
        self.navigationItem.title = "주인장"
        // Do any additional setup after loading the view.
        
        
        let button = UIButton(type: .system)
        button.setTitle("생성하기", for: .normal)
        button.addTarget(self, action: #selector(goToCreation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        // 버튼 레이아웃 설정
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
            
    // 버튼 액션 메서드
    @objc func goToCreation(_ sender: UIButton) {
        let newPageViewController = OpenNewPageViewController()
        // 백 버튼 타이틀 숨기기
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(newPageViewController, animated: false)
    }
}

