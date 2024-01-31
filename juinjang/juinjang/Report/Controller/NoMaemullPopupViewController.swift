//
//  NoMaemullPopupViewController.swift
//  juinjang
//
//  Created by 박도연 on 1/31/24.
//

import UIKit
import SnapKit
import Then

class NoMaemullPopupViewController: UIViewController {
    private let popupView: NoMaemullPopupView
    @objc
    func btnTap(_ sender: UIButton) {
        let vc = SelectMaemullViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
  
    init(ment: String) {
        self.popupView = NoMaemullPopupView(ment: ment)
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
