//
//  BottomTableViewCell.swift
//  Juinjang
//
//  Created by 박도연 on 12/31/23.
//

import UIKit
import SnapKit
import Then

class BottomTableViewCell: UITableViewCell{
    
    static let id = "BottomTableViewCell"
    static let cellHeight = 250.0
    var yesRecentImjang : Bool = true
    //MARK: - 변수 설정
    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate : UICollectionViewDelegate & UICollectionViewDataSource, forRow row: Int){
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
    }
    //최근 본 임장
    var recentImjangLabel = UILabel().then {
        $0.text = "최근 본 임장"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //최근 본 임장이 없을 때
    var noImjangImageView = UIImageView().then {
        $0.image = UIImage(named: "투명로고")
        $0.contentMode = .scaleAspectFill
    }
    var noImjangLabel = UILabel().then {
        $0.text = "아직 등록된 집이 없어요"
        $0.textColor = UIColor(named: "450")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func isHidden() {
        if yesRecentImjang == true {
            noImjangLabel.isHidden = true
            noImjangImageView.isHidden = true
        } else {
            collectionView.isHidden = true
        }
    }
    private func addContentView() {
        contentView.addSubview(recentImjangLabel)
        
        //최근 본 임장 없을 때
        contentView.addSubview(noImjangImageView)
        contentView.addSubview(noImjangLabel)
        
        //최근 본 임장 있을 때
        contentView.addSubview(collectionView)
        
        isHidden()
    }
        
    private func autoLayout() {
        recentImjangLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
        }
        
        //최근 본 임장 없을 떄
        noImjangImageView.snp.makeConstraints{
            $0.top.equalTo(recentImjangLabel.snp.bottom).offset(49)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(108.83)
        }
        
        noImjangLabel.snp.makeConstraints{
            $0.top.equalTo(noImjangImageView.snp.bottom).offset(33.17)
            $0.centerX.equalToSuperview()
        }
        
        //최근 본 임장 있을 때
        collectionView.snp.makeConstraints{
            $0.top.equalTo(recentImjangLabel.snp.bottom).offset(15)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(204)
        }
    }
}


