//
//  AccountDeleteFinalViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/19/24.
//

import UIKit

class AccountDeleteFinalViewController: UIViewController {
    
    var accountDeleteFinalView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
    }
    func setConstraint() {
        accountDeleteFinalView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(accountDeleteFinalView)
        view.addSubview(AccountDeleteViewController().noButton)
        view.addSubview(AccountDeleteViewController().yesButton)
        setConstraint()
    }
}
