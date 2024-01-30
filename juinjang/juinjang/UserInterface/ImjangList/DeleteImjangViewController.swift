//
//  DeleteImjangViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit
import Then
import SnapKit

class DeleteImjangViewController: UIViewController {
    let titleLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.6, height: 24))
        label.text = "삭제할 페이지를 선택해주세요"
        label.font = .pretendard(size: 16, weight: .semiBold)
        label.textColor = ColorStyle.textGray
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designNavigationBar()
        configureView()
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
//        self.navigationItem.title = "삭제할 페이지를 선택해주세요"
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.tintColor = .black

        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: nil)
      
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
}
