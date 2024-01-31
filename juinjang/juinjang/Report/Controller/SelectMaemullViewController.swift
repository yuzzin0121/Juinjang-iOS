//
//  SelectMaemullViewController.swift
//  juinjang
//
//  Created by 박도연 on 1/31/24.
//
import UIKit
import Then
import SnapKit

class SelectMaemullViewController : UIViewController {
    
    var backButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"leftArrow"), for: .normal)
        $0.addTarget(self, action: #selector(backBtnTap), for: .touchUpInside)
    }
    @objc
    func backBtnTap() {
        self.dismiss(animated: false, completion: nil)
    }
    var compareLabel = UILabel().then {
        $0.text = "비교할 매물 고르기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var searchButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"search"), for: .normal)
    }
    
    var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var tableView = UITableView().then {
        $0.backgroundColor = .purple
    }
    
    var btnBackGroundView = UIView().then{
        $0.backgroundColor = .white
    }
    
    var applyBtn = UIButton().then{
        $0.backgroundColor = UIColor(named: "null")
        $0.layer.cornerRadius = 10
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setConstraint() {
        backButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13.16)
            $0.left.equalToSuperview().inset(24)
            $0.width.height.equalTo(22)
        }
        compareLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.16)
            $0.centerX.equalToSuperview()
        }
        searchButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13.16)
            $0.right.equalToSuperview().inset(24)
            $0.width.height.equalTo(22)
        }
        btnBackGroundView.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(97)
        }
        applyBtn.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        contentView.snp.makeConstraints{
            $0.top.equalTo(compareLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(63)
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(btnBackGroundView.snp.top)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(compareLabel)
        view.addSubview(searchButton)
        view.addSubview(contentView)
        view.addSubview(tableView)
        
        view.addSubview(btnBackGroundView)
        btnBackGroundView.addSubview(applyBtn)
        
        setConstraint()
    }
}
